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
    'Access-Control-Allow-Headers': 'Content-Type, Authorization, X-Appwrite-Project, X-Appwrite-Key',
    'Access-Control-Max-Age': '86400'
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
          validateRequired(requestBody, ['title', 'description', 'instructorId', 'category', 'price']);
          const newCourse = await databases.createDocument(
            DATABASE_ID,
            COLLECTIONS.COURSES,
            sdk.ID.unique(),
            {
              ...requestBody,
              enrollmentCount: 0,
              isPublished: false
            }
          );
          await logger.logInfo('Course created', { courseId: newCourse.$id, title: newCourse.title });
          return res.json({ success: true, data: newCourse }, 201, corsHeaders);

        case 'PUT':
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
          if (!id) throw new Error('Course ID is required');
          await databases.deleteDocument(DATABASE_ID, COLLECTIONS.COURSES, id);
          await logger.logInfo('Course deleted', { courseId: id });
          return res.json({ success: true, message: 'Course deleted' }, 200, corsHeaders);
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
          validateRequired(requestBody, ['courseId', 'title', 'content', 'order']);
          const newLesson = await databases.createDocument(
            DATABASE_ID,
            COLLECTIONS.LESSONS,
            sdk.ID.unique(),
            {
              ...requestBody,
              completionCount: 0
            }
          );
          return res.json({ success: true, data: newLesson }, 201, corsHeaders);

        case 'PUT':
          if (!id) throw new Error('Lesson ID is required');
          const updatedLesson = await databases.updateDocument(
            DATABASE_ID,
            COLLECTIONS.LESSONS,
            id,
            { ...requestBody }
          );
          return res.json({ success: true, data: updatedLesson }, 200, corsHeaders);

        case 'DELETE':
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
          validateRequired(requestBody, ['courseId', 'title', 'description', 'timeLimit']);
          const newQuiz = await databases.createDocument(
            DATABASE_ID,
            COLLECTIONS.QUIZZES,
            sdk.ID.unique(),
            {
              ...requestBody,
              attemptCount: 0
            }
          );
          return res.json({ success: true, data: newQuiz }, 201, corsHeaders);

        case 'PUT':
          if (!id) throw new Error('Quiz ID is required');
          const updatedQuiz = await databases.updateDocument(
            DATABASE_ID,
            COLLECTIONS.QUIZZES,
            id,
            { ...requestBody }
          );
          return res.json({ success: true, data: updatedQuiz }, 200, corsHeaders);

        case 'DELETE':
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
          validateRequired(requestBody, ['quizId', 'question', 'options', 'correctAnswer', 'order']);
          const newQuestion = await databases.createDocument(
            DATABASE_ID,
            COLLECTIONS.QUIZ_QUESTIONS,
            sdk.ID.unique(),
            requestBody
          );
          return res.json({ success: true, data: newQuestion }, 201, corsHeaders);

        case 'PUT':
          if (!id) throw new Error('Question ID is required');
          const updatedQuestion = await databases.updateDocument(
            DATABASE_ID,
            COLLECTIONS.QUIZ_QUESTIONS,
            id,
            requestBody
          );
          return res.json({ success: true, data: updatedQuestion }, 200, corsHeaders);

        case 'DELETE':
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
              sdk.ID.unique(),
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
          try {
            validateRequired(requestBody, ['userId', 'quizId', 'answers', 'score', 'totalQuestions']);
            
            await logger.logInfo('Creating quiz attempt', {
              userId: requestBody.userId,
              quizId: requestBody.quizId,
              score: requestBody.score,
              totalQuestions: requestBody.totalQuestions,
              answersType: typeof requestBody.answers,
              answersIsArray: Array.isArray(requestBody.answers),
              requestBody: requestBody
            });
            
            // Ensure answers is properly formatted for storage
            const attemptData = {
              ...requestBody,
              answers: typeof requestBody.answers === 'object' ? JSON.stringify(requestBody.answers) : requestBody.answers,
              attemptedAt: new Date().toISOString(),
              passed: (requestBody.score / requestBody.totalQuestions) >= 0.6
            };
            
            const newAttempt = await databases.createDocument(
              DATABASE_ID,
              COLLECTIONS.QUIZ_ATTEMPTS,
              sdk.ID.unique(),
              attemptData
            );
            
            await logger.logSuccess('Quiz attempt created successfully', {
              attemptId: newAttempt.$id,
              userId: requestBody.userId,
              quizId: requestBody.quizId,
              passed: newAttempt.passed
            });
            
            // Update quiz attempt count
            await logger.logInfo('Updating quiz attempt count', { quizId: requestBody.quizId });
            
            try {
              const quiz = await databases.getDocument(DATABASE_ID, COLLECTIONS.QUIZZES, requestBody.quizId);
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

            return res.json({ success: true, data: newAttempt }, 201, corsHeaders);
          
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
          validateRequired(requestBody, ['userId', 'type', 'amount', 'description']);
          const newTransaction = await databases.createDocument(
            DATABASE_ID,
            COLLECTIONS.TRANSACTIONS,
            sdk.ID.unique(),
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
          validateRequired(requestBody, ['userId', 'courseId', 'score', 'rank']);
          const newRank = await databases.createDocument(
            DATABASE_ID,
            COLLECTIONS.RANKS,
            sdk.ID.unique(),
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
          validateRequired(requestBody, ['name', 'description', 'criteria', 'icon']);
          const newBadge = await databases.createDocument(
            DATABASE_ID,
            COLLECTIONS.BADGES,
            sdk.ID.unique(),
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
          validateRequired(requestBody, ['userId', 'badgeId']);
          const newUserBadge = await databases.createDocument(
            DATABASE_ID,
            COLLECTIONS.USER_BADGES,
            sdk.ID.unique(),
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
          validateRequired(requestBody, ['userId', 'title', 'message', 'type']);
          const newNotification = await databases.createDocument(
            DATABASE_ID,
            COLLECTIONS.NOTIFICATIONS,
            sdk.ID.unique(),
            {
              ...requestBody,
              isRead: false
            }
          );
          return res.json({ success: true, data: newNotification }, 201, corsHeaders);

        case 'PUT':
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
        'GET|POST|PUT|DELETE /courses',
        'GET|POST|PUT|DELETE /lessons',
        'GET|POST|PUT|DELETE /quizzes',
        'GET|POST|PUT|DELETE /quiz-questions',
        'GET|POST /progress',
        'GET|POST /quiz-attempts',
        'GET|POST /transactions',
        'GET|POST /ranks',
        'GET|POST /badges',
        'GET|POST /user-badges',
        'GET|POST|PUT /notifications'
      ]
    }, 404, corsHeaders);

  } catch (err) {
    return await handleError(err, 'An error occurred processing your request');
  }
};


