# EdTech Platform Backend

A comprehensive Node.js backend for an EdTech platform built with Appwrite Functions, featuring course management, quizzes, progress tracking, gamification, and more.

## 🌟 Features

- **Course Management**: Create, update, and manage courses with lessons
- **Quiz System**: Interactive quizzes with questions and scoring
- **Progress Tracking**: Track user progress through courses and lessons
- **Gamification**: Badges, ranks, and achievement system
- **Transaction Management**: Handle payments and coin transactions
- **Notifications**: Send and manage user notifications
- **Discord Logging**: Comprehensive logging system with Discord integration
- **CORS Support**: Cross-origin resource sharing enabled
- **Error Handling**: Robust error handling with detailed logging

## 🏗️ Architecture

### System Architecture Diagram

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Flutter App   │    │   Web Admin    │    │  Discord Bot    │
│   (Mobile)      │    │    Panel       │    │   (Logging)     │
└─────────┬───────┘    └─────────┬───────┘    └─────────┬───────┘
          │                      │                      │
          │ HTTP/HTTPS           │ HTTP/HTTPS           │ Webhook
          │                      │                      │
          └──────────┬───────────┘                      │
                     │                                  │
                     ▼                                  │
┌─────────────────────────────────────────────────────┐ │
│              Appwrite Function                      │ │
│              (Node.js Backend)                      │ │
│                                                     │ │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  │ │
│  │   Courses   │  │   Quizzes   │  │  Progress   │  │ │
│  │ Management  │  │   System    │  │  Tracking   │  │ │
│  └─────────────┘  └─────────────┘  └─────────────┘  │ │
│                                                     │ │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  │ │
│  │Gamification │  │Transactions │  │Notifications│  │ │
│  │   System    │  │  Management │  │   System    │  │ │
│  └─────────────┘  └─────────────┘  └─────────────┘  │ │
└─────────────────┬───────────────────────────────────┘ │
                  │                                     │
                  ▼                                     │
┌─────────────────────────────────────────────────────┐ │
│                Appwrite Database                    │ │
│                                                     │ │
│ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐     │ │
│ │   Courses   │ │   Lessons   │ │   Quizzes   │     │ │
│ └─────────────┘ └─────────────┘ └─────────────┘     │ │
│                                                     │ │
│ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐     │ │
│ │  Progress   │ │ Transactions│ │   Badges    │     │ │
│ └─────────────┘ └─────────────┘ └─────────────┘     │ │
└─────────────────────────────────────────────────────┘ │
                                                        │
┌─────────────────────────────────────────────────────┐ │
│                Discord Channel                      │◄┘
│              (Monitoring & Logs)                   │
└─────────────────────────────────────────────────────┘
```

### Data Flow Diagram

```
┌─────────────┐
│   Client    │
│ (App/Web)   │
└──────┬──────┘
       │ 1. HTTP Request
       ▼
┌─────────────┐
│  Appwrite   │
│  Function   │◄──────────────┐
│  (Backend)  │               │ 7. Discord Logging
└──────┬──────┘               │
       │ 2. Validate          │
       │    Request           │
       ▼                      │
┌─────────────┐               │
│  Business   │               │
│    Logic    │               │
│ Processing  │               │
└──────┬──────┘               │
       │ 3. Database          │
       │    Operations        │
       ▼                      │
┌─────────────┐               │
│  Appwrite   │               │
│  Database   │               │
│ Collections │               │
└──────┬──────┘               │
       │ 4. Data              │
       │    Response          │
       ▼                      │
┌─────────────┐               │
│   Format    │               │
│  Response   │               │
│   & Error   │               │
│  Handling   │               │
└──────┬──────┘               │
       │ 5. HTTP Response     │
       ▼                      │
┌─────────────┐               │
│   Client    │               │
│  Receives   │               │
│   Data      │               │
└─────────────┘               │
       │ 6. Log Activity      │
       └──────────────────────┘
```

## 📊 Database Structure

### Collections Overview

```
edtech_db/
├── courses/
│   ├── $id (string, unique)
│   ├── title (string, required)
│   ├── description (string, required)
│   ├── instructorId (string, required)
│   ├── category (string, required)
│   ├── price (number, required)
│   ├── thumbnail (string, optional)
│   ├── duration (number, optional)
│   ├── level (string, optional)
│   ├── enrollmentCount (number, default: 0)
│   ├── isPublished (boolean, default: false)
│   ├── createdAt (datetime)
│   └── updatedAt (datetime)
│
├── lessons/
│   ├── $id (string, unique)
│   ├── courseId (string, required, relation)
│   ├── title (string, required)
│   ├── content (string, required)
│   ├── type (string, enum: video|text|pdf|link)
│   ├── order (number, required)
│   ├── duration (number, optional)
│   ├── videoUrl (string, optional)
│   ├── fileUrl (string, optional)
│   ├── completionCount (number, default: 0)
│   ├── createdAt (datetime)
│   └── updatedAt (datetime)
│
├── quizzes/
│   ├── $id (string, unique)
│   ├── courseId (string, required, relation)
│   ├── title (string, required)
│   ├── description (string, required)
│   ├── timeLimit (number, required, minutes)
│   ├── passingScore (number, required, percentage)
│   ├── maxAttempts (number, optional)
│   ├── attemptCount (number, default: 0)
│   ├── isActive (boolean, default: true)
│   ├── createdAt (datetime)
│   └── updatedAt (datetime)
│
├── quiz_questions/
│   ├── $id (string, unique)
│   ├── quizId (string, required, relation)
│   ├── question (string, required)
│   ├── options (array, required)
│   ├── correctAnswer (string, required)
│   ├── explanation (string, optional)
│   ├── order (number, required)
│   └── points (number, default: 1)
│
├── user_progress/
│   ├── $id (string, unique)
│   ├── userId (string, required)
│   ├── courseId (string, required, relation)
│   ├── lessonId (string, required, relation)
│   ├── completedAt (datetime, optional)
│   ├── progress (number, 0-100)
│   ├── timeSpent (number, seconds)
│   ├── createdAt (datetime)
│   └── updatedAt (datetime)
│
├── quiz_attempts/
│   ├── $id (string, unique)
│   ├── userId (string, required)
│   ├── quizId (string, required, relation)
│   ├── answers (array, required)
│   ├── score (number, required)
│   ├── totalQuestions (number, required)
│   ├── timeTaken (number, seconds)
│   ├── passed (boolean, required)
│   └── attemptedAt (datetime)
│
├── transactions/
│   ├── $id (string, unique)
│   ├── userId (string, required)
│   ├── type (string, enum: purchase|reward|refund)
│   ├── amount (number, required)
│   ├── description (string, required)
│   ├── courseId (string, optional, relation)
│   ├── status (string, enum: pending|completed|failed)
│   ├── paymentMethod (string, optional)
│   └── createdAt (datetime)
│
├── ranks/
│   ├── $id (string, unique)
│   ├── userId (string, required)
│   ├── courseId (string, required, relation)
│   ├── score (number, required)
│   ├── rank (number, required)
│   ├── totalParticipants (number, required)
│   └── achievedAt (datetime)
│
├── badges/
│   ├── $id (string, unique)
│   ├── name (string, required)
│   ├── description (string, required)
│   ├── criteria (string, required)
│   ├── icon (string, required)
│   ├── points (number, default: 10)
│   └── createdAt (datetime)
│
├── user_badges/
│   ├── $id (string, unique)
│   ├── userId (string, required)
│   ├── badgeId (string, required, relation)
│   └── earnedAt (datetime)
│
└── notifications/
    ├── $id (string, unique)
    ├── userId (string, required)
    ├── title (string, required)
    ├── message (string, required)
    ├── type (string, enum: info|success|warning|error)
    ├── isRead (boolean, default: false)
    ├── readAt (datetime, optional)
    └── createdAt (datetime)
```

## 🚀 Quick Start

### Prerequisites

- Node.js 18+ 
- Appwrite Cloud account or self-hosted Appwrite instance
- Discord webhook URL (optional, for logging)

### Environment Variables

Create a `.env` file in your project root:

```env
# Appwrite Configuration
APPWRITE_FUNCTION_ENDPOINT=https://cloud.appwrite.io/v1
APPWRITE_FUNCTION_PROJECT_ID=your_project_id
APPWRITE_API_KEY=your_api_key
DATABASE_ID=edtech_db

# Discord Logging (Optional)
DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/your/webhook/url

# Environment
NODE_ENV=production
```

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   npm install
   ```
3. Deploy to Appwrite Functions or run locally

### Appwrite Setup

1. Create a new Appwrite project
2. Create a database named `edtech_db`
3. Create collections as per the database structure above
4. Set up appropriate permissions for each collection
5. Generate API key with necessary permissions

## 📚 API Endpoints

### Base URL
```
https://your-appwrite-endpoint/v1/functions/your-function-id/executions
```

### Health Check
- **GET** `/health` - Check API status

### Courses
- **GET** `/courses` - List all courses
- **GET** `/courses/:id` - Get specific course with lessons
- **POST** `/courses` - Create new course
- **PUT** `/courses/:id` - Update course
- **DELETE** `/courses/:id` - Delete course

### Lessons
- **GET** `/lessons` - List lessons (filter by courseId)
- **GET** `/lessons/:id` - Get specific lesson
- **POST** `/lessons` - Create new lesson
- **PUT** `/lessons/:id` - Update lesson
- **DELETE** `/lessons/:id` - Delete lesson

### Quizzes
- **GET** `/quizzes` - List quizzes (filter by courseId)
- **GET** `/quizzes/:id` - Get quiz with questions
- **POST** `/quizzes` - Create new quiz
- **PUT** `/quizzes/:id` - Update quiz
- **DELETE** `/quizzes/:id` - Delete quiz

### Quiz Questions
- **GET** `/quiz-questions?quizId=:id` - Get questions for quiz
- **POST** `/quiz-questions` - Create new question
- **PUT** `/quiz-questions/:id` - Update question
- **DELETE** `/quiz-questions/:id` - Delete question

### User Progress
- **GET** `/progress?userId=:id&courseId=:id` - Get user progress
- **POST** `/progress` - Update/create progress

### Quiz Attempts
- **GET** `/quiz-attempts?userId=:id&quizId=:id` - Get quiz attempts
- **POST** `/quiz-attempts` - Submit quiz attempt

### Transactions
- **GET** `/transactions?userId=:id` - Get user transactions
- **POST** `/transactions` - Create new transaction

### Ranks
- **GET** `/ranks?courseId=:id` - Get course rankings
- **POST** `/ranks` - Update user rank

### Badges
- **GET** `/badges` - List all badges
- **POST** `/badges` - Create new badge

### User Badges
- **GET** `/user-badges?userId=:id` - Get user badges
- **POST** `/user-badges` - Award badge to user

### Notifications
- **GET** `/notifications?userId=:id` - Get user notifications
- **POST** `/notifications` - Create notification
- **PUT** `/notifications/:id` - Mark as read

## 🔧 Configuration

### Appwrite Collections Permissions

For each collection, set up these permissions:

**Courses Collection:**
- Read: `role:all` (public courses)
- Create: `role:instructor`, `role:admin`
- Update: `role:instructor`, `role:admin`
- Delete: `role:admin`

**Lessons Collection:**
- Read: `role:all`
- Create: `role:instructor`, `role:admin`
- Update: `role:instructor`, `role:admin`
- Delete: `role:admin`

**User Progress Collection:**
- Read: `role:user`, `role:admin`
- Create: `role:user`, `role:admin`
- Update: `role:user`, `role:admin`
- Delete: `role:admin`

### Discord Logging Setup

1. Create a Discord server or use existing one
2. Create a text channel for logs
3. Go to Channel Settings > Integrations > Webhooks
4. Create a new webhook and copy the URL
5. Add the webhook URL to your environment variables

## 🧪 Testing

Use the provided Postman collection (`edtech-api.postman_collection.json`) to test all endpoints.

## 📈 Monitoring

The system includes comprehensive Discord logging for:
- API requests and responses
- Error tracking
- User activity monitoring
- Performance metrics
- Security events

## 🚀 Deployment

### Appwrite Functions Deployment

1. Create a new function in your Appwrite console
2. Set runtime to Node.js 18
3. Upload your code or connect to Git repository
4. Set environment variables
5. Deploy and test

### Environment-specific Configuration

**Development:**
```env
NODE_ENV=development
DISCORD_WEBHOOK_URL=your_dev_webhook_url
```

**Production:**
```env
NODE_ENV=production
DISCORD_WEBHOOK_URL=your_prod_webhook_url
```

## 🔒 Security Features

- Input validation on all endpoints
- Error handling without sensitive data exposure
- CORS configuration
- Environment-based logging levels
- Secure environment variable usage

## 📋 Response Format

All API responses follow this structure:

**Success Response:**
```json
{
  "success": true,
  "data": {...},
  "total": 100 // (for list endpoints)
}
```

**Error Response:**
```json
{
  "success": false,
  "error": "Error message",
  "details": "Detailed error info (development only)"
}
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the ISC License - see the LICENSE file for details.

## 🆘 Support

For support and questions:
- Create an issue in the repository
- Check the Discord logs for error details
- Review the Appwrite console for function logs

---

**Built with ❤️ for EdTech Platform**
