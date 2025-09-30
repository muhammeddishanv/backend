import * as sdk from 'node-appwrite';
import { logger } from './discord-logger.js';

// This is your Appwrite function
export default async ({ req, res, log, error }) => {
  // Initialize Appwrite client
  const client = new sdk.Client();
  client
    .setEndpoint(process.env.APPWRITE_FUNCTION_ENDPOINT || 'https://cloud.appwrite.io/v1')
    .setProject(process.env.APPWRITE_FUNCTION_PROJECT_ID)
    .setKey(process.env.APPWRITE_API_KEY);

  const databases = new sdk.Databases(client);
  const storage = new sdk.Storage(client);
  const users = new sdk.Users(client);
  const teams = new sdk.Teams(client);

  // Database and collection IDs
  const DATABASE_ID = process.env.DATABASE_ID || 'edtech_db';
  const COLLECTIONS = {
    COURSES: 'courses',
    LESSONS: 'lessons',
    QUIZZES: 'quizzes',
    QUIZ_QUESTIONS: 'quiz_questions',
    USER_PROGRESS: 'user_progress',
    QUIZ_ATTEMPTS: 'quiz_attempts',
    TRANSACTIONS: 'transactions',
    RANKS: 'ranks',
    BADGES: 'badges',
    USER_BADGES: 'user_badges',
    NOTIFICATIONS: 'notifications'
  };

  // CORS headers
  const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type, Authorization, X-Appwrite-Project, X-Appwrite-Key, X-User-Id',
    'Access-Control-Max-Age': '86400'
  };

  // Helper function to generate unique IDs with prefixes
  const generateId = (prefix) => {
    return `${prefix}_${sdk.ID.unique()}`;
  };

  // Helper function to get user and validate authentication
  const authenticateUser = async (userId) => {
    if (!userId) {
      throw new Error('X-User-Id header is required');
    }
    
    try {
      const user = await users.get(userId);
      const userRole = user.labels?.role; // Default to student if no role set
      
      return {
        userId: user.$id,
        role: userRole,
        user: user
      };
    } catch (error) {
      throw new Error('Invalid user ID or user not found');
    }
  };

  // Helper function to check permissions
  const checkPermission = (userRole, operation, resource) => {
    // Admin can do everything
    if (userRole === 'admin') {
      return true;
    }
    
    // Students can only GET operations and specific enrollment operations
    if (userRole === 'student') {
      if (operation === 'GET') {
        return true;
      }
      // Allow specific POST operations for students
      if (operation === 'POST' && (resource === 'enroll' || resource === 'quiz-attempts' || resource === 'progress')) {
        return true;
      }
      // Allow PUT for marking notifications as read
      if (operation === 'PUT' && resource === 'notifications') {
        return true;
      }
      return false;
    }
    
    return false;
  };

  // Handle preflight requests
  if (req.method === 'OPTIONS') {
    return res.json({ message: 'OK' }, 200, corsHeaders);
  }

  // Helper function to handle errors
  const handleError = async (err, message = 'Internal Server Error') => {
    await logger.logError(`EdTech API Error: ${message}`, err);
    error(err);
    return res.json({ 
      success: false, 
      error: message,
      details: process.env.NODE_ENV === 'development' ? err.message : undefined
    }, 500, corsHeaders);
  };

  // Helper function to validate required fields
  const validateRequired = (data, fields) => {
    const missing = fields.filter(field => !data[field]);
    if (missing.length > 0) {
      throw new Error(`Missing required fields: ${missing.join(', ')}`);
    }
  };

  try {
    // Parse URL path
    const url = new URL(req.url, 'http://localhost');
    const pathSegments = url.pathname.split('/').filter(segment => segment);
    const [resource, id, subResource, subId] = pathSegments;

    log(`${req.method} ${url.pathname}`);
    await logger.logInfo(`API Request: ${req.method} ${url.pathname}`, { 
      userAgent: req.headers['user-agent'],
      ip: req.headers['x-forwarded-for'] || req.headers['x-real-ip']
    });

    // Extract user ID from headers for authentication (skip for health check and test endpoints)
    let authData = null;
    const skipAuthPaths = ['health', 'test-discord'];
    const needsAuth = resource && !skipAuthPaths.includes(resource);
    
    if (needsAuth) {
      const userId = req.headers['x-user-id'];
      authData = await authenticateUser(userId);
      log(`Authenticated user: ${authData.userId} with role: ${authData.role}`);
    }

    // Health check
    if (req.method === 'GET' && (!resource || resource === 'health')) {
      return res.json({ 
        success: true, 
        message: 'EdTech API is running',
        timestamp: new Date().toISOString()
      }, 200, corsHeaders);
    }

    // Discord logger test endpoint
    if (req.method === 'GET' && resource === 'test-discord') {
      try {
        await logger.logSuccess('Discord Test', {
          message: 'Discord webhook is working correctly! 🎉',
          endpoint: '/test-discord',
          timestamp: new Date().toISOString(),
          status: 'Active'
        });
        
        await logger.logInfo('API Test Information', {
          testType: 'Discord Integration',
          result: 'Success',
          webhook: logger.enabled ? 'Enabled' : 'Disabled'
        });
        
        await logger.logWarning('Test Warning', {
          message: 'This is a test warning message',
          level: 'Warning'
        });
        
        return res.json({ 
          success: true, 
          message: 'Discord test messages sent successfully',
          webhookEnabled: logger.enabled,
          timestamp: new Date().toISOString()
        }, 200, corsHeaders);
      } catch (error) {
        await logger.logError('Discord Test Failed', error);
        return res.json({ 
          success: false, 
          message: 'Discord test failed',
          error: error.message
        }, 500, corsHeaders);
      }
    }

    const requestBody = req.bodyRaw ? JSON.parse(req.bodyRaw) : {};
    
    // Remove any fields that don't exist in database schema to prevent errors
    const forbiddenFields = ['passingScore', 'createdAt', 'updatedAt'];
    forbiddenFields.forEach(field => {
      if (requestBody.hasOwnProperty(field)) {
        delete requestBody[field];
      }
    });

    // COURSES ENDPOINTS
    if (resource === 'courses') {
      switch (req.method) {
        case 'GET':
          if (id) {
            // Get specific course
            const course = await databases.getDocument(DATABASE_ID, COLLECTIONS.COURSES, id);
            // Get course lessons
            const lessons = await databases.listDocuments(DATABASE_ID, COLLECTIONS.LESSONS, [
              sdk.Query.equal('courseId', id),
              sdk.Query.orderAsc('order')
            ]);
            return res.json({ 
              success: true, 
              data: { ...course, lessons: lessons.documents }
            }, 200, corsHeaders);
          } else {
            // List all courses
            const queryParams = [];
            if (url.searchParams.get('category')) {
              queryParams.push(sdk.Query.equal('category', url.searchParams.get('category')));
            }
            if (url.searchParams.get('instructor')) {
              queryParams.push(sdk.Query.equal('instructorId', url.searchParams.get('instructor')));
            }
            queryParams.push(sdk.Query.orderDesc('$createdAt'));
            
            const courses = await databases.listDocuments(DATABASE_ID, COLLECTIONS.COURSES, queryParams);
            return res.json({ 
              success: true, 
              data: courses.documents,
              total: courses.total
            }, 200, corsHeaders);
          }

        case 'POST':
          // Check permissions
          if (!checkPermission(authData.role, 'POST', 'courses')) {
            return res.json({ success: false, error: 'Insufficient permissions' }, 403, corsHeaders);
          }
          
          validateRequired(requestBody, ['title', 'description', 'instructorId', 'category', 'price']);
          const courseId = generateId('course');
          const newCourse = await databases.createDocument(
            DATABASE_ID,
            COLLECTIONS.COURSES,
            courseId,
            {
              ...requestBody,
              enrollmentCount: 0,
              isPublished: false
            }
          );
          
          // Create team for course
          try {
            await teams.create(
              courseId,
              `Course: ${requestBody.title}`,
              ['admin', 'student'] // roles
            );
            await logger.logInfo('Course team created', { courseId, teamId: courseId });
          } catch (teamError) {
            await logger.logWarning('Failed to create course team', { courseId, error: teamError.message });
          }
          await logger.logInfo('Course created', { courseId: newCourse.$id, title: newCourse.title });
          return res.json({ success: true, data: newCourse }, 201, corsHeaders);

        case 'PUT':
          // Check permissions
          if (!checkPermission(authData.role, 'PUT', 'courses')) {
            return res.json({ success: false, error: 'Insufficient permissions' }, 403, corsHeaders);
          }
          
          if (!id) throw new Error('Course ID is required');
          const updatedCourse = await databases.updateDocument(
            DATABASE_ID,
            COLLECTIONS.COURSES,
            id,
            { ...requestBody }
          );
          await logger.logInfo('Course updated', { courseId: id });
          return res.json({ success: true, data: updatedCourse }, 200, corsHeaders);

        case 'DELETE':
          // Check permissions
          if (!checkPermission(authData.role, 'DELETE', 'courses')) {
            return res.json({ success: false, error: 'Insufficient permissions' }, 403, corsHeaders);
          }
          
          if (!id) throw new Error('Course ID is required');
          await databases.deleteDocument(DATABASE_ID, COLLECTIONS.COURSES, id);
          await logger.logInfo('Course deleted', { courseId: id });
          return res.json({ success: true, message: 'Course deleted' }, 200, corsHeaders);
      }
    }

    // COURSE ENROLLMENT ENDPOINTS
    if (resource === 'enroll') {
      switch (req.method) {
        case 'POST':
          // Check permissions - students can enroll
          if (!checkPermission(authData.role, 'POST', 'enroll')) {
            return res.json({ success: false, error: 'Insufficient permissions' }, 403, corsHeaders);
          }
          
          validateRequired(requestBody, ['courseId']);
          const { courseId } = requestBody;
          const enrollStudentId = authData.userId;
          
          try {
            // Check if course exists
            const course = await databases.getDocument(DATABASE_ID, COLLECTIONS.COURSES, courseId);
            
            // Check if user is already enrolled (member of course team)
            try {
              const membership = await teams.getMembership(courseId, enrollStudentId);
              return res.json({ 
                success: false, 
                error: 'User already enrolled in this course' 
              }, 400, corsHeaders);
            } catch (notFoundError) {
              // User not enrolled, proceed with enrollment
            }
            
            // Add user to course team
            await teams.createMembership(
              courseId,
              ['student'], // roles
              'http://localhost', // url (placeholder)
              enrollStudentId // userId
            );
            
            // Update course enrollment count
            await databases.updateDocument(
              DATABASE_ID,
              COLLECTIONS.COURSES,
              courseId,
              { 
                enrollmentCount: (course.enrollmentCount || 0) + 1 
              }
            );
            
            // Create enrollment transaction record
            await databases.createDocument(
              DATABASE_ID,
              COLLECTIONS.TRANSACTIONS,
              generateId('transaction'),
              {
                userId: enrollStudentId,
                courseId: courseId,
                type: 'enrollment',
                amount: course.price || 0,
                description: `Enrolled in course: ${course.title}`,
                status: 'completed'
              }
            );
            
            await logger.logSuccess('Student enrolled in course', {
              studentId: enrollStudentId,
              courseId,
              courseTitle: course.title
            });
            
            return res.json({ 
              success: true, 
              message: 'Successfully enrolled in course',
              data: {
                courseId,
                courseTitle: course.title,
                enrolledAt: new Date().toISOString()
              }
            }, 201, corsHeaders);
            
          } catch (error) {
            await logger.logError('Course enrollment failed', error, {
              studentId: enrollStudentId,
              courseId
            });
            return res.json({ 
              success: false, 
              error: 'Failed to enroll in course',
              details: error.message
            }, 400, corsHeaders);
          }

        case 'GET':
          // Get user's enrolled courses
          const queryStudentId = url.searchParams.get('userId') || authData.userId;
          
          try {
            // Get user's team memberships (enrolled courses)
            const memberships = await teams.listMemberships(queryStudentId);
            const enrolledCourseIds = memberships.memberships
              .filter(m => m.teamId.startsWith('course_'))
              .map(m => m.teamId);
            
            if (enrolledCourseIds.length === 0) {
              return res.json({ 
                success: true, 
                data: [],
                total: 0
              }, 200, corsHeaders);
            }
            
            // Get course details for enrolled courses
            const enrolledCourses = await Promise.all(
              enrolledCourseIds.map(async (courseId) => {
                try {
                  return await databases.getDocument(DATABASE_ID, COLLECTIONS.COURSES, courseId);
                } catch (error) {
                  await logger.logWarning('Failed to fetch enrolled course', { courseId, error: error.message });
                  return null;
                }
              })
            );
            
            const validCourses = enrolledCourses.filter(course => course !== null);
            
            return res.json({ 
              success: true, 
              data: validCourses,
              total: validCourses.length
            }, 200, corsHeaders);
            
          } catch (error) {
            await logger.logError('Failed to get enrolled courses', error, { studentId: queryStudentId });
            return res.json({ 
              success: false, 
              error: 'Failed to get enrolled courses'
            }, 500, corsHeaders);
          }

        case 'DELETE':
          // Unenroll from course
          if (!checkPermission(authData.role, 'DELETE', 'enroll')) {
            return res.json({ success: false, error: 'Insufficient permissions' }, 403, corsHeaders);
          }
          
          const courseIdToUnenroll = url.searchParams.get('courseId');
          if (!courseIdToUnenroll) {
            return res.json({ success: false, error: 'courseId parameter is required' }, 400, corsHeaders);
          }
          
          try {
            // Remove user from course team
            await teams.deleteMembership(courseIdToUnenroll, authData.userId);
            
            // Update course enrollment count
            const course = await databases.getDocument(DATABASE_ID, COLLECTIONS.COURSES, courseIdToUnenroll);
            await databases.updateDocument(
              DATABASE_ID,
              COLLECTIONS.COURSES,
              courseIdToUnenroll,
              { 
                enrollmentCount: Math.max((course.enrollmentCount || 1) - 1, 0)
              }
            );
            
            await logger.logInfo('Student unenrolled from course', {
              studentId: authData.userId,
              courseId: courseIdToUnenroll
            });
            
            return res.json({ 
              success: true, 
              message: 'Successfully unenrolled from course'
            }, 200, corsHeaders);
            
          } catch (error) {
            return res.json({ 
              success: false, 
              error: 'Failed to unenroll from course'
            }, 400, corsHeaders);
          }
      }
    }

    // LESSONS ENDPOINTS
    if (resource === 'lessons') {
      switch (req.method) {
        case 'GET':
          if (id) {
            const lesson = await databases.getDocument(DATABASE_ID, COLLECTIONS.LESSONS, id);
            return res.json({ success: true, data: lesson }, 200, corsHeaders);
          } else {
            const courseId = url.searchParams.get('courseId');
            const queryParams = courseId ? [sdk.Query.equal('courseId', courseId)] : [];
            queryParams.push(sdk.Query.orderAsc('order'));
            
            const lessons = await databases.listDocuments(DATABASE_ID, COLLECTIONS.LESSONS, queryParams);
            return res.json({ 
              success: true, 
              data: lessons.documents,
              total: lessons.total
            }, 200, corsHeaders);
          }

        case 'POST':
          // Check permissions
          if (!checkPermission(authData.role, 'POST', 'lessons')) {
            return res.json({ success: false, error: 'Insufficient permissions' }, 403, corsHeaders);
          }
          
          validateRequired(requestBody, ['courseId', 'title', 'content', 'order']);
          const newLesson = await databases.createDocument(
            DATABASE_ID,
            COLLECTIONS.LESSONS,
            generateId('lesson'),
            {
              ...requestBody,
              completionCount: 0
            }
          );
          return res.json({ success: true, data: newLesson }, 201, corsHeaders);

        case 'PUT':
          // Check permissions
          if (!checkPermission(authData.role, 'PUT', 'lessons')) {
            return res.json({ success: false, error: 'Insufficient permissions' }, 403, corsHeaders);
          }
          
          if (!id) throw new Error('Lesson ID is required');
          const updatedLesson = await databases.updateDocument(
            DATABASE_ID,
            COLLECTIONS.LESSONS,
            id,
            { ...requestBody }
          );
          return res.json({ success: true, data: updatedLesson }, 200, corsHeaders);

        case 'DELETE':
          // Check permissions
          if (!checkPermission(authData.role, 'DELETE', 'lessons')) {
            return res.json({ success: false, error: 'Insufficient permissions' }, 403, corsHeaders);
          }
          
          if (!id) throw new Error('Lesson ID is required');
          await databases.deleteDocument(DATABASE_ID, COLLECTIONS.LESSONS, id);
          return res.json({ success: true, message: 'Lesson deleted' }, 200, corsHeaders);
      }
    }

    // QUIZZES ENDPOINTS
    if (resource === 'quizzes') {
      switch (req.method) {
        case 'GET':
          if (id) {
            const quiz = await databases.getDocument(DATABASE_ID, COLLECTIONS.QUIZZES, id);
            // Get quiz questions
            const questions = await databases.listDocuments(DATABASE_ID, COLLECTIONS.QUIZ_QUESTIONS, [
              sdk.Query.equal('quizId', id),
              sdk.Query.orderAsc('order')
            ]);
            return res.json({ 
              success: true, 
              data: { ...quiz, questions: questions.documents }
            }, 200, corsHeaders);
          } else {
            const courseId = url.searchParams.get('courseId');
            const queryParams = courseId ? [sdk.Query.equal('courseId', courseId)] : [];
            queryParams.push(sdk.Query.orderDesc('$createdAt'));
            
            const quizzes = await databases.listDocuments(DATABASE_ID, COLLECTIONS.QUIZZES, queryParams);
            return res.json({ 
              success: true, 
              data: quizzes.documents,
              total: quizzes.total
            }, 200, corsHeaders);
          }

        case 'POST':
          // Check permissions
          if (!checkPermission(authData.role, 'POST', 'quizzes')) {
            return res.json({ success: false, error: 'Insufficient permissions' }, 403, corsHeaders);
          }
          
          validateRequired(requestBody, ['courseId', 'title', 'description', 'timeLimit']);
          const newQuiz = await databases.createDocument(
            DATABASE_ID,
            COLLECTIONS.QUIZZES,
            generateId('quiz'),
            {
              ...requestBody,
              attemptCount: 0
            }
          );
          return res.json({ success: true, data: newQuiz }, 201, corsHeaders);

        case 'PUT':
          // Check permissions
          if (!checkPermission(authData.role, 'PUT', 'quizzes')) {
            return res.json({ success: false, error: 'Insufficient permissions' }, 403, corsHeaders);
          }
          
          if (!id) throw new Error('Quiz ID is required');
          const updatedQuiz = await databases.updateDocument(
            DATABASE_ID,
            COLLECTIONS.QUIZZES,
            id,
            { ...requestBody }
          );
          return res.json({ success: true, data: updatedQuiz }, 200, corsHeaders);

        case 'DELETE':
          // Check permissions
          if (!checkPermission(authData.role, 'DELETE', 'quizzes')) {
            return res.json({ success: false, error: 'Insufficient permissions' }, 403, corsHeaders);
          }
          
          if (!id) throw new Error('Quiz ID is required');
          await databases.deleteDocument(DATABASE_ID, COLLECTIONS.QUIZZES, id);
          return res.json({ success: true, message: 'Quiz deleted' }, 200, corsHeaders);
      }
    }

    // QUIZ QUESTIONS ENDPOINTS
    if (resource === 'quiz-questions') {
      switch (req.method) {
        case 'GET':
          const quizId = url.searchParams.get('quizId');
          const queryParams = quizId ? [sdk.Query.equal('quizId', quizId)] : [];
          queryParams.push(sdk.Query.orderAsc('order'));
          
          const questions = await databases.listDocuments(DATABASE_ID, COLLECTIONS.QUIZ_QUESTIONS, queryParams);
          return res.json({ 
            success: true, 
            data: questions.documents,
            total: questions.total
          }, 200, corsHeaders);

        case 'POST':
          // Check permissions
          if (!checkPermission(authData.role, 'POST', 'quiz-questions')) {
            return res.json({ success: false, error: 'Insufficient permissions' }, 403, corsHeaders);
          }
          
          validateRequired(requestBody, ['quizId', 'question', 'options', 'correctAnswer', 'order']);
          const newQuestion = await databases.createDocument(
            DATABASE_ID,
            COLLECTIONS.QUIZ_QUESTIONS,
            generateId('question'),
            requestBody
          );
          return res.json({ success: true, data: newQuestion }, 201, corsHeaders);

        case 'PUT':
          // Check permissions
          if (!checkPermission(authData.role, 'PUT', 'quiz-questions')) {
            return res.json({ success: false, error: 'Insufficient permissions' }, 403, corsHeaders);
          }
          
          if (!id) throw new Error('Question ID is required');
          const updatedQuestion = await databases.updateDocument(
            DATABASE_ID,
            COLLECTIONS.QUIZ_QUESTIONS,
            id,
            requestBody
          );
          return res.json({ success: true, data: updatedQuestion }, 200, corsHeaders);

        case 'DELETE':
          // Check permissions
          if (!checkPermission(authData.role, 'DELETE', 'quiz-questions')) {
            return res.json({ success: false, error: 'Insufficient permissions' }, 403, corsHeaders);
          }
          
          if (!id) throw new Error('Question ID is required');
          await databases.deleteDocument(DATABASE_ID, COLLECTIONS.QUIZ_QUESTIONS, id);
          return res.json({ success: true, message: 'Question deleted' }, 200, corsHeaders);
      }
    }

    // USER PROGRESS ENDPOINTS
    if (resource === 'progress') {
      switch (req.method) {
        case 'GET':
          const userId = url.searchParams.get('userId');
          const courseId = url.searchParams.get('courseId');
          const queryParams = [];
          
          if (userId) queryParams.push(sdk.Query.equal('userId', userId));
          if (courseId) queryParams.push(sdk.Query.equal('courseId', courseId));
          
          const progress = await databases.listDocuments(DATABASE_ID, COLLECTIONS.USER_PROGRESS, queryParams);
          return res.json({ 
            success: true, 
            data: progress.documents,
            total: progress.total
          }, 200, corsHeaders);

        case 'POST':
          // Check permissions
          if (!checkPermission(authData.role, 'POST', 'progress')) {
            return res.json({ success: false, error: 'Insufficient permissions' }, 403, corsHeaders);
          }
          
          validateRequired(requestBody, ['userId', 'courseId', 'lessonId']);
          // Check if progress already exists
          const existingProgress = await databases.listDocuments(DATABASE_ID, COLLECTIONS.USER_PROGRESS, [
            sdk.Query.equal('userId', requestBody.userId),
            sdk.Query.equal('courseId', requestBody.courseId),
            sdk.Query.equal('lessonId', requestBody.lessonId)
          ]);

          if (existingProgress.documents.length > 0) {
            // Update existing progress
            const updated = await databases.updateDocument(
              DATABASE_ID,
              COLLECTIONS.USER_PROGRESS,
              existingProgress.documents[0].$id,
              {
                ...requestBody
              }
            );
            return res.json({ success: true, data: updated }, 200, corsHeaders);
          } else {
            // Create new progress
            const newProgress = await databases.createDocument(
              DATABASE_ID,
              COLLECTIONS.USER_PROGRESS,
              generateId('progress'),
              {
                ...requestBody
              }
            );
            return res.json({ success: true, data: newProgress }, 201, corsHeaders);
          }
      }
    }

    // QUIZ ATTEMPTS ENDPOINTS
    if (resource === 'quiz-attempts') {
      switch (req.method) {
        case 'GET':
          const userId = url.searchParams.get('userId');
          const quizId = url.searchParams.get('quizId');
          const queryParams = [];
          
          if (userId) queryParams.push(sdk.Query.equal('userId', userId));
          if (quizId) queryParams.push(sdk.Query.equal('quizId', quizId));
          queryParams.push(sdk.Query.orderDesc('$createdAt'));
          
          const attempts = await databases.listDocuments(DATABASE_ID, COLLECTIONS.QUIZ_ATTEMPTS, queryParams);
          return res.json({ 
            success: true, 
            data: attempts.documents,
            total: attempts.total
          }, 200, corsHeaders);

        case 'POST':
          // Check permissions
          if (!checkPermission(authData.role, 'POST', 'quiz-attempts')) {
            return res.json({ success: false, error: 'Insufficient permissions' }, 403, corsHeaders);
          }
          
          try {
            validateRequired(requestBody, ['userId', 'quizId', 'answers']);
            
            // Validate that the student is enrolled in the course containing this quiz
            const quiz = await databases.getDocument(DATABASE_ID, COLLECTIONS.QUIZZES, requestBody.quizId);
            
            // Check if student is enrolled in the course
            try {
              await teams.getMembership(quiz.courseId, requestBody.userId);
            } catch (membershipError) {
              return res.json({ 
                success: false, 
                error: 'Student must be enrolled in the course to take this quiz' 
              }, 403, corsHeaders);
            }
            
            // Get quiz questions to validate answers and calculate score
            const questions = await databases.listDocuments(DATABASE_ID, COLLECTIONS.QUIZ_QUESTIONS, [
              sdk.Query.equal('quizId', requestBody.quizId),
              sdk.Query.orderAsc('order')
            ]);
            
            if (questions.documents.length === 0) {
              return res.json({ 
                success: false, 
                error: 'No questions found for this quiz' 
              }, 400, corsHeaders);
            }
            
            // Validate answers format and calculate score
            let score = 0;
            const totalQuestions = questions.documents.length;
            const answers = Array.isArray(requestBody.answers) ? requestBody.answers : [];
            
            // Validate that answers are provided for all questions
            if (answers.length !== totalQuestions) {
              return res.json({ 
                success: false, 
                error: `Expected ${totalQuestions} answers, but received ${answers.length}` 
              }, 400, corsHeaders);
            }
            
            // Calculate score by comparing student answers with correct answers
            const detailedAnswers = questions.documents.map((question, index) => {
              const studentAnswer = answers[index];
              const isCorrect = studentAnswer === question.correctAnswer;
              if (isCorrect) score++;
              
              return {
                questionId: question.$id,
                question: question.question,
                studentAnswer: studentAnswer,
                correctAnswer: question.correctAnswer,
                isCorrect: isCorrect,
                options: question.options
              };
            });
            
            await logger.logInfo('Processing quiz attempt', {
              userId: requestBody.userId,
              quizId: requestBody.quizId,
              score: score,
              totalQuestions: totalQuestions,
              answers: detailedAnswers
            });
            
            // Ensure answers is properly formatted for storage
            const attemptData = {
              userId: requestBody.userId,
              quizId: requestBody.quizId,
              answers: JSON.stringify(detailedAnswers),
              score: score,
              totalQuestions: totalQuestions,
              attemptedAt: new Date().toISOString(),
              passed: (score / totalQuestions) >= 0.6, // 60% passing grade
              timeSpent: requestBody.timeSpent || null
            };
            
            const newAttempt = await databases.createDocument(
              DATABASE_ID,
              COLLECTIONS.QUIZ_ATTEMPTS,
              generateId('attempt'),
              attemptData
            );
            
            await logger.logSuccess('Quiz attempt created successfully', {
              attemptId: newAttempt.$id,
              userId: requestBody.userId,
              quizId: requestBody.quizId,
              score: score,
              totalQuestions: totalQuestions,
              passed: newAttempt.passed
            });
            
            // Update quiz attempt count
            await logger.logInfo('Updating quiz attempt count', { quizId: requestBody.quizId });
            
            try {
              await databases.updateDocument(
                DATABASE_ID,
                COLLECTIONS.QUIZZES,
                requestBody.quizId,
                { attemptCount: (quiz.attemptCount || 0) + 1 }
              );
              
              await logger.logSuccess('Quiz attempt count updated', { 
                quizId: requestBody.quizId, 
                newAttemptCount: (quiz.attemptCount || 0) + 1 
              });
            } catch (quizError) {
              await logger.logWarning('Failed to update quiz attempt count', { 
                quizId: requestBody.quizId, 
                error: quizError.message 
              });
              // Continue anyway since the quiz attempt was created successfully
            }

            return res.json({ 
              success: true, 
              data: {
                ...newAttempt,
                score: score,
                totalQuestions: totalQuestions,
                percentage: Math.round((score / totalQuestions) * 100),
                passed: newAttempt.passed
              }
            }, 201, corsHeaders);
          
          } catch (error) {
            await logger.logError('Quiz attempt creation failed', error, {
              userId: requestBody.userId,
              quizId: requestBody.quizId,
              requestBody: requestBody
            });
            return res.json({ 
              success: false, 
              error: error.message,
              details: 'Failed to create quiz attempt'
            }, 400, corsHeaders);
          }
      }
    }

    // TRANSACTIONS ENDPOINTS
    if (resource === 'transactions') {
      switch (req.method) {
        case 'GET':
          const userId = url.searchParams.get('userId');
          const queryParams = userId ? [sdk.Query.equal('userId', userId)] : [];
          queryParams.push(sdk.Query.orderDesc('$createdAt'));
          
          const transactions = await databases.listDocuments(DATABASE_ID, COLLECTIONS.TRANSACTIONS, queryParams);
          return res.json({ 
            success: true, 
            data: transactions.documents,
            total: transactions.total
          }, 200, corsHeaders);

        case 'POST':
          // Check permissions
          if (!checkPermission(authData.role, 'POST', 'transactions')) {
            return res.json({ success: false, error: 'Insufficient permissions' }, 403, corsHeaders);
          }
          
          validateRequired(requestBody, ['userId', 'type', 'amount', 'description']);
          const newTransaction = await databases.createDocument(
            DATABASE_ID,
            COLLECTIONS.TRANSACTIONS,
            generateId('transaction'),
            {
              ...requestBody,
              status: 'completed'
            }
          );
          return res.json({ success: true, data: newTransaction }, 201, corsHeaders);
      }
    }

    // RANKS ENDPOINTS
    if (resource === 'ranks') {
      switch (req.method) {
        case 'GET':
          const courseId = url.searchParams.get('courseId');
          const queryParams = courseId ? [sdk.Query.equal('courseId', courseId)] : [];
          queryParams.push(sdk.Query.orderAsc('rank'));
          
          const ranks = await databases.listDocuments(DATABASE_ID, COLLECTIONS.RANKS, queryParams);
          return res.json({ 
            success: true, 
            data: ranks.documents,
            total: ranks.total
          }, 200, corsHeaders);

        case 'POST':
          // Check permissions
          if (!checkPermission(authData.role, 'POST', 'ranks')) {
            return res.json({ success: false, error: 'Insufficient permissions' }, 403, corsHeaders);
          }
          
          validateRequired(requestBody, ['userId', 'courseId', 'score', 'rank']);
          const newRank = await databases.createDocument(
            DATABASE_ID,
            COLLECTIONS.RANKS,
            generateId('rank'),
            {
              ...requestBody,
              achievedAt: new Date().toISOString()
            }
          );
          return res.json({ success: true, data: newRank }, 201, corsHeaders);
      }
    }

    // BADGES ENDPOINTS
    if (resource === 'badges') {
      switch (req.method) {
        case 'GET':
          const badges = await databases.listDocuments(DATABASE_ID, COLLECTIONS.BADGES, [
            sdk.Query.orderAsc('name')
          ]);
          return res.json({ 
            success: true, 
            data: badges.documents,
            total: badges.total
          }, 200, corsHeaders);

        case 'POST':
          // Check permissions
          if (!checkPermission(authData.role, 'POST', 'badges')) {
            return res.json({ success: false, error: 'Insufficient permissions' }, 403, corsHeaders);
          }
          
          validateRequired(requestBody, ['name', 'description', 'criteria', 'icon']);
          const newBadge = await databases.createDocument(
            DATABASE_ID,
            COLLECTIONS.BADGES,
            generateId('badge'),
            {
              ...requestBody
            }
          );
          return res.json({ success: true, data: newBadge }, 201, corsHeaders);
      }
    }

    // USER BADGES ENDPOINTS
    if (resource === 'user-badges') {
      switch (req.method) {
        case 'GET':
          const userId = url.searchParams.get('userId');
          const queryParams = userId ? [sdk.Query.equal('userId', userId)] : [];
          queryParams.push(sdk.Query.orderDesc('$createdAt'));
          
          const userBadges = await databases.listDocuments(DATABASE_ID, COLLECTIONS.USER_BADGES, queryParams);
          return res.json({ 
            success: true, 
            data: userBadges.documents,
            total: userBadges.total
          }, 200, corsHeaders);

        case 'POST':
          // Check permissions
          if (!checkPermission(authData.role, 'POST', 'user-badges')) {
            return res.json({ success: false, error: 'Insufficient permissions' }, 403, corsHeaders);
          }
          
          validateRequired(requestBody, ['userId', 'badgeId']);
          const newUserBadge = await databases.createDocument(
            DATABASE_ID,
            COLLECTIONS.USER_BADGES,
            generateId('userbadge'),
            {
              ...requestBody,
              earnedAt: new Date().toISOString()
            }
          );
          return res.json({ success: true, data: newUserBadge }, 201, corsHeaders);
      }
    }

    // NOTIFICATIONS ENDPOINTS
    if (resource === 'notifications') {
      switch (req.method) {
        case 'GET':
          const userId = url.searchParams.get('userId');
          const queryParams = userId ? [sdk.Query.equal('userId', userId)] : [];
          queryParams.push(sdk.Query.orderDesc('$createdAt'));
          
          const notifications = await databases.listDocuments(DATABASE_ID, COLLECTIONS.NOTIFICATIONS, queryParams);
          return res.json({ 
            success: true, 
            data: notifications.documents,
            total: notifications.total
          }, 200, corsHeaders);

        case 'POST':
          // Check permissions
          if (!checkPermission(authData.role, 'POST', 'notifications')) {
            return res.json({ success: false, error: 'Insufficient permissions' }, 403, corsHeaders);
          }
          
          validateRequired(requestBody, ['userId', 'title', 'message', 'type']);
          const newNotification = await databases.createDocument(
            DATABASE_ID,
            COLLECTIONS.NOTIFICATIONS,
            generateId('notification'),
            {
              ...requestBody,
              isRead: false
            }
          );
          return res.json({ success: true, data: newNotification }, 201, corsHeaders);

        case 'PUT':
          // Check permissions (students can mark their own notifications as read)
          if (!checkPermission(authData.role, 'PUT', 'notifications')) {
            return res.json({ success: false, error: 'Insufficient permissions' }, 403, corsHeaders);
          }
          
          if (!id) throw new Error('Notification ID is required');
          const updatedNotification = await databases.updateDocument(
            DATABASE_ID,
            COLLECTIONS.NOTIFICATIONS,
            id,
            { isRead: true, readAt: new Date().toISOString() }
          );
          return res.json({ success: true, data: updatedNotification }, 200, corsHeaders);
      }
    }

    // FILE UPLOAD ENDPOINTS
    if (resource === 'upload') {
      if (req.method === 'POST') {
        // This would handle file uploads to Appwrite Storage
        // Implementation depends on how files are sent from frontend
        return res.json({ 
          success: false, 
          error: 'File upload endpoint not implemented yet' 
        }, 501, corsHeaders);
      }
    }

    // Default response for unknown endpoints
    return res.json({ 
      success: false, 
      error: 'Endpoint not found',
      availableEndpoints: [
        'GET /health',
        'GET|POST|PUT|DELETE /courses (admin only for POST/PUT/DELETE)',
        'GET|POST|DELETE /enroll (students can enroll/unenroll)',
        'GET|POST|PUT|DELETE /lessons (admin only for POST/PUT/DELETE)',
        'GET|POST|PUT|DELETE /quizzes (admin only for POST/PUT/DELETE)', 
        'GET|POST|PUT|DELETE /quiz-questions (admin only for POST/PUT/DELETE)',
        'GET|POST /progress (students can POST their progress)',
        'GET|POST /quiz-attempts (students can POST their attempts)',
        'GET|POST /transactions (admin only for POST)',
        'GET|POST /ranks (admin only for POST)',
        'GET|POST /badges (admin only for POST)',
        'GET|POST /user-badges (admin only for POST)',
        'GET|POST|PUT /notifications (students can PUT to mark as read)'
      ]
    }, 404, corsHeaders);

  } catch (err) {
    return await handleError(err, 'An error occurred processing your request');
  }
};


