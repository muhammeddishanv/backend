# 🎓 EdTech Platform Backend API

A comprehensive backend system for an educational technology platform built with **Appwrite Functions** and **Node.js**. This API provides complete learning management system functionality including course management, quiz systems, user progress tracking, enrollment, gamification features, and more.

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Architecture](#-architecture)
- [Getting Started](#-getting-started)
- [API Endpoints](#-api-endpoints)
- [Authentication & Permissions](#-authentication--permissions)
- [Database Schema](#-database-schema)
- [Environment Variables](#-environment-variables)
- [Deployment](#-deployment)
- [Monitoring & Logging](#-monitoring--logging)
- [Testing](#-testing)
- [Error Handling](#-error-handling)
- [Best Practices](#-best-practices)

---

## 🌟 Overview

This is a serverless backend API deployed as an **Appwrite Function** that provides a complete learning management system. It handles all backend operations for an EdTech platform including:

- **Course Management**: Create, update, and manage educational courses
- **User Enrollment**: Handle student enrollments with team-based access control
- **Content Delivery**: Manage lessons and learning materials
- **Assessment System**: Quiz creation, question management, and automated grading
- **Progress Tracking**: Monitor student progress through courses and lessons
- **Gamification**: Badges, ranks, and achievement systems
- **Notifications**: User notification management
- **Transactions**: Track enrollment and payment transactions
- **Discord Integration**: Real-time logging and monitoring via Discord webhooks

### Technology Stack

- **Runtime**: Node.js 18.0
- **Backend**: Appwrite Functions (Serverless)
- **Database**: Appwrite Database (NoSQL)
- **Storage**: Appwrite Storage
- **Authentication**: Appwrite Auth with role-based access control
- **Teams**: Appwrite Teams for course enrollment
- **Logging**: Custom Discord webhook integration

---

## ✨ Features

### 🔐 Security & Authentication
- Role-based access control (Admin, Student)
- User authentication via `X-User-Id` header
- Permission checks for all operations
- CORS enabled for cross-origin requests
- Secure API key management

### 📚 Course Management
- Create and manage courses
- Course categorization
- Instructor assignment
- Enrollment tracking
- Course publishing/unpublishing
- Course team creation for access control

### 📖 Lesson Management
- Create lessons within courses
- Order lessons sequentially
- Track lesson completion
- Support for various content types (video, text, PDF)
- Completion count tracking

### 📝 Quiz System
- Create quizzes for courses
- Multiple choice questions
- Automatic grading system
- Time limits for quizzes
- Track quiz attempts
- Score calculation and passing grades (60% default)
- Detailed answer analysis

### 👥 Enrollment System
- Student course enrollment
- Team-based access control
- Enrollment verification
- Unenrollment functionality
- Enrollment transaction tracking

### 📊 Progress Tracking
- Track user progress through lessons
- Course completion tracking
- Lesson completion status
- Progress history

### 🏆 Gamification
- Badge system with criteria
- User badge assignments
- Rank system with leaderboards
- Achievement tracking

### 🔔 Notifications
- User notifications
- Read/unread status
- Notification types
- Timestamp tracking

### 💳 Transaction Management
- Enrollment transactions
- Transaction history
- Amount tracking
- Status management

### 📡 Monitoring & Logging
- Discord webhook integration
- Real-time error logging
- API request logging
- User activity tracking
- Performance metrics
- Security event logging

---

## 🏗️ Architecture

### System Design

```
┌─────────────────┐
│   Flutter App   │
│  (Frontend)     │
└────────┬────────┘
         │ HTTP/HTTPS Requests
         │ Headers: X-User-Id, Content-Type
         ▼
┌─────────────────────────────┐
│   Appwrite Function         │
│   (Backend API)             │
│   • index.js                │
│   • discord-logger.js       │
└────────┬────────────────────┘
         │
         ├──────────────┐
         ▼              ▼
┌─────────────┐  ┌──────────────┐
│  Appwrite   │  │   Discord    │
│  Services   │  │   Webhook    │
│  • Database │  │  (Logging)   │
│  • Auth     │  └──────────────┘
│  • Teams    │
│  • Storage  │
└─────────────┘
```

### Request Flow

1. **Client Request**: Flutter app sends HTTP request with authentication headers
2. **Authentication**: API validates user via `X-User-Id` header and Appwrite Users service
3. **Authorization**: Role-based permission check (admin/student)
4. **Processing**: Execute database operations via Appwrite SDK
5. **Logging**: Log activity to Discord webhook (if configured)
6. **Response**: Return JSON response with success/error status
7. **CORS**: All responses include CORS headers for cross-origin access

### File Structure

```
backend/
├── index.js                    # Main API handler (all endpoints)
├── discord-logger.js           # Discord logging utility
├── src/
│   └── main.js                # Default Appwrite function template
├── package.json               # Dependencies
├── env.template              # Environment variable template
├── appwrite-setup.md         # Setup documentation
├── edtech-api.postman_collection.json  # API testing collection
└── README.md                 # This file
```

---

## 🚀 Getting Started

### Prerequisites

- **Node.js** 18.0 or higher
- **Appwrite** account and project (cloud.appwrite.io or self-hosted)
- **Discord** webhook URL (optional, for logging)
- **Postman** (optional, for API testing)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd backend
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Configure environment variables**
   ```bash
   # Copy template
   cp env.template .env
   
   # Edit .env with your values
   APPWRITE_FUNCTION_ENDPOINT=https://cloud.appwrite.io/v1
   APPWRITE_FUNCTION_PROJECT_ID=your_project_id
   APPWRITE_API_KEY=your_api_key
   DATABASE_ID=edtech_db
   DISCORD_WEBHOOK_URL=your_webhook_url (optional)
   NODE_ENV=development
   ```

4. **Set up Appwrite database**
   - Create database: `edtech_db`
   - Create collections (see [Database Schema](#-database-schema))
   - Configure permissions
   - Create indexes (see [appwrite-setup.md](./appwrite-setup.md))

5. **Deploy to Appwrite**
   ```bash
   # Using Appwrite CLI
   appwrite deploy function
   
   # Or manually upload to Appwrite Console
   ```

---

## 📡 API Endpoints

### Base URL
```
Production: https://68c2a1d90003e461b539.fra.appwrite.run
Local: http://localhost:3000 (or your local Appwrite endpoint)
```

### Authentication Header
All endpoints (except health check) require:
```
X-User-Id: <user_id>
```

---

### 🏥 Health & Testing

#### `GET /health`
Check API status (no authentication required).

**Response:**
```json
{
  "success": true,
  "message": "EdTech API is running",
  "timestamp": "2025-10-20T12:00:00.000Z"
}
```

#### `GET /test-discord`
Test Discord webhook integration (no authentication required).

**Response:**
```json
{
  "success": true,
  "message": "Discord test messages sent successfully",
  "webhookEnabled": true,
  "timestamp": "2025-10-20T12:00:00.000Z"
}
```

---

### 📚 Courses

#### `GET /courses`
Get all courses with optional filters.

**Query Parameters:**
- `category` (optional): Filter by category
- `instructor` (optional): Filter by instructor ID

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "$id": "course_abc123",
      "title": "Introduction to Programming",
      "description": "Learn the basics of programming",
      "instructorId": "user_instructor_123",
      "category": "Programming",
      "price": 49.99,
      "thumbnailUrl": "https://...",
      "enrollmentCount": 42,
      "isPublished": true
    }
  ],
  "total": 1
}
```

#### `GET /courses/{id}`
Get a specific course with its lessons.

**Response:**
```json
{
  "success": true,
  "data": {
    "$id": "course_abc123",
    "title": "Introduction to Programming",
    "lessons": [
      {
        "$id": "lesson_xyz789",
        "title": "Getting Started",
        "order": 1
      }
    ]
  }
}
```

#### `POST /courses` (Admin only)
Create a new course.

**Request Body:**
```json
{
  "title": "Advanced JavaScript",
  "description": "Master advanced JavaScript concepts",
  "instructorId": "user_instructor_123",
  "category": "Programming",
  "price": 79.99,
  "thumbnailUrl": "https://...",
  "level": "Advanced",
  "duration": "8 weeks"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "$id": "course_generated_id",
    "title": "Advanced JavaScript",
    "enrollmentCount": 0,
    "isPublished": false
  }
}
```

#### `PUT /courses/{id}` (Admin only)
Update a course.

#### `DELETE /courses/{id}` (Admin only)
Delete a course.

---

### 🎓 Enrollment

#### `POST /enroll`
Enroll in a course (Student can enroll themselves).

**Request Body:**
```json
{
  "courseId": "course_abc123"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Successfully enrolled in course",
  "data": {
    "courseId": "course_abc123",
    "courseTitle": "Introduction to Programming",
    "enrolledAt": "2025-10-20T12:00:00.000Z"
  }
}
```

#### `GET /enroll?userId={userId}`
Get enrolled courses for a user.

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "$id": "course_abc123",
      "title": "Introduction to Programming"
    }
  ],
  "total": 1
}
```

#### `DELETE /enroll?courseId={courseId}`
Unenroll from a course.

---

### 📖 Lessons

#### `GET /lessons?courseId={courseId}`
Get all lessons for a course (ordered by sequence).

#### `GET /lessons/{id}`
Get a specific lesson.

#### `POST /lessons` (Admin only)
Create a new lesson.

**Request Body:**
```json
{
  "courseId": "course_abc123",
  "title": "Variables and Data Types",
  "content": "In this lesson, we'll learn about...",
  "order": 1,
  "videoUrl": "https://...",
  "duration": "15 minutes",
  "resources": ["link1", "link2"]
}
```

#### `PUT /lessons/{id}` (Admin only)
Update a lesson.

#### `DELETE /lessons/{id}` (Admin only)
Delete a lesson.

---

### 📝 Quizzes

#### `GET /quizzes?courseId={courseId}`
Get all quizzes for a course.

#### `GET /quizzes/{id}`
Get a specific quiz with all questions.

**Response:**
```json
{
  "success": true,
  "data": {
    "$id": "quiz_xyz789",
    "title": "JavaScript Basics Quiz",
    "description": "Test your knowledge",
    "timeLimit": 30,
    "questions": [
      {
        "$id": "question_123",
        "question": "What is a variable?",
        "options": ["A", "B", "C", "D"],
        "correctAnswer": "A",
        "order": 1
      }
    ]
  }
}
```

#### `POST /quizzes` (Admin only)
Create a new quiz.

**Request Body:**
```json
{
  "courseId": "course_abc123",
  "title": "Midterm Exam",
  "description": "Comprehensive test",
  "timeLimit": 60,
  "isActive": true
}
```

#### `PUT /quizzes/{id}` (Admin only)
Update a quiz.

#### `DELETE /quizzes/{id}` (Admin only)
Delete a quiz.

---

### ❓ Quiz Questions

#### `GET /quiz-questions?quizId={quizId}`
Get all questions for a quiz.

#### `POST /quiz-questions` (Admin only)
Create a quiz question.

**Request Body:**
```json
{
  "quizId": "quiz_xyz789",
  "question": "What is the capital of France?",
  "options": ["London", "Paris", "Berlin", "Madrid"],
  "correctAnswer": "Paris",
  "order": 1,
  "points": 1
}
```

#### `PUT /quiz-questions/{id}` (Admin only)
Update a question.

#### `DELETE /quiz-questions/{id}` (Admin only)
Delete a question.

---

### 📊 Progress Tracking

#### `GET /progress?userId={userId}&courseId={courseId}`
Get user progress.

#### `POST /progress`
Update/create progress entry (Students can track their own progress).

**Request Body:**
```json
{
  "userId": "user_student_123",
  "courseId": "course_abc123",
  "lessonId": "lesson_xyz789",
  "isCompleted": true,
  "timeSpent": 45,
  "progress": 75
}
```

---

### ✅ Quiz Attempts

#### `GET /quiz-attempts?userId={userId}&quizId={quizId}`
Get quiz attempt history.

#### `POST /quiz-attempts`
Submit a quiz attempt (Students can submit their attempts).

**Request Body:**
```json
{
  "userId": "user_student_123",
  "quizId": "quiz_xyz789",
  "answers": ["Paris", "Berlin", "London"],
  "timeSpent": 25
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "$id": "attempt_generated_id",
    "score": 2,
    "totalQuestions": 3,
    "percentage": 67,
    "passed": true,
    "attemptedAt": "2025-10-20T12:00:00.000Z"
  }
}
```

**Note:** The system automatically:
- Verifies enrollment in the course
- Fetches quiz questions
- Validates answer count
- Calculates score by comparing with correct answers
- Determines pass/fail (60% passing grade)
- Stores detailed answer breakdown
- Updates quiz attempt count

---

### 💳 Transactions

#### `GET /transactions?userId={userId}`
Get transaction history.

#### `POST /transactions` (Admin only)
Create a transaction record.

---

### 🏆 Ranks

#### `GET /ranks?courseId={courseId}`
Get course rankings (leaderboard).

#### `POST /ranks` (Admin only)
Create/update a rank entry.

---

### 🎖️ Badges

#### `GET /badges`
Get all available badges.

#### `POST /badges` (Admin only)
Create a new badge.

---

### 🎯 User Badges

#### `GET /user-badges?userId={userId}`
Get badges earned by a user.

#### `POST /user-badges` (Admin only)
Award a badge to a user.

---

### 🔔 Notifications

#### `GET /notifications?userId={userId}`
Get user notifications.

#### `POST /notifications` (Admin only)
Create a notification.

#### `PUT /notifications/{id}`
Mark notification as read (Students can mark their own notifications).

---

## 🔐 Authentication & Permissions

### Authentication

All endpoints (except `/health` and `/test-discord`) require authentication via the `X-User-Id` header:

```http
X-User-Id: user_123abc456def
```

The API validates the user ID against Appwrite Users service and retrieves the user's role from their labels.

### User Roles

The system supports two roles:

#### 1. **Admin** (`role: admin`)
- **Full access** to all operations
- Can perform all CRUD operations (Create, Read, Update, Delete)
- Can manage courses, lessons, quizzes, questions
- Can create badges, ranks, notifications
- Can view all user data

#### 2. **Student** (`role: student`)
- **Limited access** based on operation type
- **Allowed operations:**
  - All `GET` operations (read-only access)
  - `POST /enroll` - Enroll in courses
  - `POST /progress` - Track their own progress
  - `POST /quiz-attempts` - Submit quiz attempts
  - `PUT /notifications/{id}` - Mark their notifications as read
- **Denied operations:**
  - Cannot create/update/delete courses, lessons, quizzes
  - Cannot modify other users' data

### Setting User Roles

User roles are managed through Appwrite User labels:

```javascript
// In Appwrite Console or via API:
{
  labels: {
    role: "admin"  // or "student"
  }
}
```

**Default:** If no role is set, users default to `student` role.

### Permission Checks

The API performs permission checks using the `checkPermission()` helper function:

```javascript
if (!checkPermission(authData.role, 'POST', 'courses')) {
  return res.json({ 
    success: false, 
    error: 'Insufficient permissions' 
  }, 403, corsHeaders);
}
```

### CORS Configuration

CORS is enabled for all endpoints with the following settings:

```javascript
{
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization, X-Appwrite-Project, X-Appwrite-Key, X-User-Id',
  'Access-Control-Max-Age': '86400'
}
```

---

## 💾 Database Schema

The system uses **11 collections** in the Appwrite database (`edtech_db`):

### 1. **courses**
Stores course information.

| Attribute | Type | Required | Description |
|-----------|------|----------|-------------|
| `title` | string(255) | Yes | Course title |
| `description` | string(5000) | Yes | Course description |
| `instructorId` | string(50) | Yes | Instructor user ID |
| `category` | string(100) | Yes | Course category |
| `price` | float | Yes | Course price |
| `thumbnailUrl` | string(500) | No | Thumbnail image URL |
| `level` | string(50) | No | Difficulty level |
| `duration` | string(100) | No | Course duration |
| `enrollmentCount` | integer | No | Number of enrollments |
| `isPublished` | boolean | No | Publication status |

**Indexes:** `instructorId`, `category`, `isPublished`

---

### 2. **lessons**
Stores lesson content for courses.

| Attribute | Type | Required | Description |
|-----------|------|----------|-------------|
| `courseId` | string(50) | Yes | Parent course ID |
| `title` | string(255) | Yes | Lesson title |
| `content` | string(10000) | Yes | Lesson content |
| `order` | integer | Yes | Sequence order |
| `videoUrl` | string(500) | No | Video URL |
| `duration` | string(50) | No | Lesson duration |
| `resources` | string(2000) | No | JSON array of resources |
| `completionCount` | integer | No | Times completed |

**Indexes:** `courseId`, `order`

---

### 3. **quizzes**
Stores quiz information.

| Attribute | Type | Required | Description |
|-----------|------|----------|-------------|
| `courseId` | string(50) | Yes | Parent course ID |
| `title` | string(255) | Yes | Quiz title |
| `description` | string(2000) | Yes | Quiz description |
| `timeLimit` | integer | Yes | Time limit (minutes) |
| `isActive` | boolean | No | Active status |
| `attemptCount` | integer | No | Number of attempts |

**Indexes:** `courseId`, `isActive`

---

### 4. **quiz_questions**
Stores individual quiz questions.

| Attribute | Type | Required | Description |
|-----------|------|----------|-------------|
| `quizId` | string(50) | Yes | Parent quiz ID |
| `question` | string(1000) | Yes | Question text |
| `options` | string(2000) | Yes | JSON array of options |
| `correctAnswer` | string(500) | Yes | Correct answer |
| `order` | integer | Yes | Question order |
| `points` | integer | No | Points value |

**Indexes:** `quizId`, `order`

---

### 5. **user_progress**
Tracks user progress through courses.

| Attribute | Type | Required | Description |
|-----------|------|----------|-------------|
| `userId` | string(50) | Yes | User ID |
| `courseId` | string(50) | Yes | Course ID |
| `lessonId` | string(50) | Yes | Lesson ID |
| `isCompleted` | boolean | No | Completion status |
| `timeSpent` | integer | No | Time spent (minutes) |
| `progress` | integer | No | Progress percentage |
| `lastAccessed` | datetime | No | Last access time |

**Indexes:** `userId`, `courseId`, `lessonId`

---

### 6. **quiz_attempts**
Records quiz attempt history.

| Attribute | Type | Required | Description |
|-----------|------|----------|-------------|
| `userId` | string(50) | Yes | User ID |
| `quizId` | string(50) | Yes | Quiz ID |
| `answers` | string(10000) | Yes | JSON of answers |
| `score` | integer | Yes | Score achieved |
| `totalQuestions` | integer | Yes | Total questions |
| `passed` | boolean | No | Pass/fail status |
| `timeSpent` | integer | No | Time spent (minutes) |
| `attemptedAt` | datetime | Yes | Attempt timestamp |

**Indexes:** `userId`, `quizId`, `attemptedAt`

---

### 7. **transactions**
Records enrollment and payment transactions.

| Attribute | Type | Required | Description |
|-----------|------|----------|-------------|
| `userId` | string(50) | Yes | User ID |
| `courseId` | string(50) | No | Course ID (if applicable) |
| `type` | string(50) | Yes | Transaction type |
| `amount` | float | Yes | Amount |
| `description` | string(500) | Yes | Description |
| `status` | string(50) | Yes | Transaction status |

**Indexes:** `userId`, `type`, `$createdAt`

---

### 8. **ranks**
Stores user rankings and leaderboards.

| Attribute | Type | Required | Description |
|-----------|------|----------|-------------|
| `userId` | string(50) | Yes | User ID |
| `courseId` | string(50) | Yes | Course ID |
| `score` | integer | Yes | User score |
| `rank` | integer | Yes | Rank position |
| `achievedAt` | datetime | Yes | Achievement time |

**Indexes:** `courseId`, `rank`, `achievedAt`

---

### 9. **badges**
Defines available badges/achievements.

| Attribute | Type | Required | Description |
|-----------|------|----------|-------------|
| `name` | string(100) | Yes | Badge name |
| `description` | string(500) | Yes | Description |
| `criteria` | string(1000) | Yes | Earning criteria |
| `icon` | string(500) | Yes | Icon URL |

**Indexes:** `name`

---

### 10. **user_badges**
Tracks badges earned by users.

| Attribute | Type | Required | Description |
|-----------|------|----------|-------------|
| `userId` | string(50) | Yes | User ID |
| `badgeId` | string(50) | Yes | Badge ID |
| `earnedAt` | datetime | Yes | Earned timestamp |

**Indexes:** `userId`, `badgeId`

---

### 11. **notifications**
Stores user notifications.

| Attribute | Type | Required | Description |
|-----------|------|----------|-------------|
| `userId` | string(50) | Yes | User ID |
| `title` | string(255) | Yes | Notification title |
| `message` | string(1000) | Yes | Message content |
| `type` | string(50) | Yes | Notification type |
| `isRead` | boolean | No | Read status |
| `readAt` | datetime | No | Read timestamp |

**Indexes:** `userId`, `isRead`, `$createdAt`

---

## 🔧 Environment Variables

Create a `.env` file or configure in Appwrite Console:

```env
# Appwrite Configuration (Required)
APPWRITE_FUNCTION_ENDPOINT=https://cloud.appwrite.io/v1
APPWRITE_FUNCTION_PROJECT_ID=your_project_id_here
APPWRITE_API_KEY=your_server_api_key_here
DATABASE_ID=edtech_db

# Discord Logging (Optional but recommended for monitoring)
DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/your/webhook/url

# Environment (development/production)
NODE_ENV=production
```

### Required Variables

- **`APPWRITE_FUNCTION_ENDPOINT`**: Your Appwrite endpoint URL
- **`APPWRITE_FUNCTION_PROJECT_ID`**: Your Appwrite project ID
- **`APPWRITE_API_KEY`**: Server API key with full permissions
- **`DATABASE_ID`**: Database ID (default: `edtech_db`)

### Optional Variables

- **`DISCORD_WEBHOOK_URL`**: Discord webhook for real-time logging
- **`NODE_ENV`**: Environment mode (`development` or `production`)

---

## 🚀 Deployment

### Deploy to Appwrite Cloud

1. **Create Appwrite Function**
   - Go to Appwrite Console → Functions
   - Click "Create Function"
   - Set Name: `edtech-backend`
   - Set Runtime: `Node.js 18.0`
   - Set Entrypoint: `index.js`
   - Set Build Commands: `npm install`

2. **Configure Settings**
   - Timeout: `15 seconds`
   - Memory: `512 MB` (recommended)
   - Enable HTTP trigger

3. **Set Environment Variables**
   - Add all required variables from `.env`

4. **Upload Code**
   - Zip entire backend folder
   - Upload via Console or CLI
   - Deploy

5. **Get Function URL**
   - Copy your function's execution URL
   - Format: `https://[PROJECT_ID].appwrite.run`

### Using Appwrite CLI

```bash
# Install Appwrite CLI
npm install -g appwrite-cli

# Login to Appwrite
appwrite login

# Initialize function
appwrite init function

# Deploy function
appwrite deploy function

# View logs
appwrite functions logs
```

---

## 📊 Monitoring & Logging

### Discord Integration

The API includes comprehensive Discord webhook logging via `discord-logger.js`:

#### Log Types

1. **Info Logs** (Blue) - General information
2. **Success Logs** (Green) - Successful operations
3. **Warning Logs** (Orange) - Potential issues
4. **Error Logs** (Red) - Errors and failures
5. **Debug Logs** (Purple) - Development debugging

#### Logged Events

- API requests and responses
- User authentication
- Course enrollments
- Quiz attempts and scores
- Database operations
- Error occurrences
- Security events
- Performance metrics

#### Test Discord Integration

```bash
GET /test-discord
```

This sends test messages to verify Discord webhook configuration.

### Viewing Logs

1. **Discord Channel**: Real-time logs in your Discord channel
2. **Appwrite Console**: View execution logs in Functions section
3. **Function Logs**: Use Appwrite CLI to stream logs

---

## 🧪 Testing

### Postman Collection

Import `edtech-api.postman_collection.json` into Postman:

1. Open Postman
2. Import → Upload Files
3. Select `edtech-api.postman_collection.json`
4. Set environment variables:
   - `base_url`: Your function URL
   - `user_id`: Test user ID
   - `admin_id`: Admin user ID

### Manual Testing

```bash
# Health check
curl https://your-function-url/health

# Get courses
curl https://your-function-url/courses \
  -H "X-User-Id: user_123"

# Create course (admin)
curl -X POST https://your-function-url/courses \
  -H "X-User-Id: admin_123" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Test Course",
    "description": "Test Description",
    "instructorId": "admin_123",
    "category": "Testing",
    "price": 0
  }'
```

---

## ⚠️ Error Handling

### Error Response Format

```json
{
  "success": false,
  "error": "Error message",
  "details": "Detailed error information (development only)"
}
```

### HTTP Status Codes

- **200** - Success
- **201** - Created
- **400** - Bad Request (validation errors)
- **403** - Forbidden (permission denied)
- **404** - Not Found
- **500** - Internal Server Error

### Common Errors

1. **Authentication Failed**
   ```json
   {
     "success": false,
     "error": "Invalid user ID or user not found"
   }
   ```

2. **Permission Denied**
   ```json
   {
     "success": false,
     "error": "Insufficient permissions"
   }
   ```

3. **Validation Error**
   ```json
   {
     "success": false,
     "error": "Missing required fields: title, description"
   }
   ```

4. **Already Enrolled**
   ```json
   {
     "success": false,
     "error": "User already enrolled in this course"
   }
   ```

---

## 💡 Best Practices

### For Developers

1. **Always include `X-User-Id` header** for authenticated requests
2. **Check response `success` field** before processing data
3. **Handle errors gracefully** in your frontend
4. **Use Postman collection** for testing
5. **Monitor Discord logs** for debugging
6. **Follow RESTful conventions** for new endpoints
7. **Validate input data** on frontend before sending
8. **Use proper HTTP methods** (GET, POST, PUT, DELETE)

### For Admins

1. **Set user roles** in Appwrite User labels
2. **Monitor Discord channel** for real-time issues
3. **Review transaction logs** regularly
4. **Backup database** periodically
5. **Update API keys** securely
6. **Configure CORS** as needed
7. **Set appropriate permissions** on collections
8. **Create database indexes** for better performance

### Security Recommendations

1. **Never expose API keys** in frontend code
2. **Use environment variables** for sensitive data
3. **Enable HTTPS only** in production
4. **Implement rate limiting** if needed
5. **Regularly rotate API keys**
6. **Audit user permissions** periodically
7. **Monitor suspicious activities** via logs
8. **Keep dependencies updated**

---

## 🔄 API Response Standards

### Success Response
```json
{
  "success": true,
  "data": { /* response data */ },
  "total": 10  // optional, for list endpoints
}
```

### Error Response
```json
{
  "success": false,
  "error": "Error message",
  "details": "Additional details"  // optional
}
```

---

## 📝 Additional Documentation

- **[appwrite-setup.md](./appwrite-setup.md)** - Detailed Appwrite configuration
- **[env.template](./env.template)** - Environment variable template
- **[Postman Collection](./edtech-api.postman_collection.json)** - API testing collection

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

---

## 📞 Support

- **Documentation**: See [appwrite-setup.md](./appwrite-setup.md)
- **Issues**: Create an issue on GitHub
- **Appwrite Docs**: https://appwrite.io/docs
- **Discord**: https://appwrite.io/discord

---

## 📄 License

This project is part of an EdTech platform. All rights reserved.

---

## ⚙️ Technical Configuration

| Setting           | Value         |
| ----------------- | ------------- |
| Runtime           | Node.js 18.0  |
| Entrypoint        | `index.js`    |
| Build Commands    | `npm install` |
| Timeout           | 15 seconds    |
| Memory            | 512 MB        |
| Permissions       | Full API key  |
| Dependencies      | `node-appwrite@14.1.0` |

---

**Built with ❤️ using Appwrite Functions**
