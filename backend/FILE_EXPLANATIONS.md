# 📁 File-by-File Explanation

This document provides a detailed explanation of every file in the EdTech Platform backend project.

---

## 📂 Project Structure

```
backend/
├── index.js                              # Main API handler
├── discord-logger.js                     # Discord logging utility
├── src/
│   └── main.js                          # Appwrite default template
├── package.json                         # Project dependencies
├── package-lock.json                    # Locked dependency versions
├── env.template                         # Environment variables template
├── appwrite-setup.md                    # Appwrite configuration guide
├── edtech-api.postman_collection.json   # API testing collection
├── README.md                            # Main documentation
├── .gitignore                           # Git ignore rules
├── .prettierrc.json                     # Code formatting config
└── scripts/                             # Utility scripts (if any)
```

---

## 🔧 Core Files

### 1. `index.js` (Main API Handler)
**Size:** ~1,130 lines  
**Purpose:** The heart of the backend - handles all API requests and business logic

#### What it does:
- **HTTP Request Handling**: Processes all incoming HTTP requests (GET, POST, PUT, DELETE)
- **Authentication**: Validates users via `X-User-Id` header and Appwrite Users service
- **Authorization**: Implements role-based access control (admin vs student)
- **Database Operations**: Performs all CRUD operations using Appwrite Database SDK
- **Routing**: Manages 40+ API endpoints across 13 resource types
- **CORS**: Handles cross-origin requests for frontend compatibility
- **Error Handling**: Comprehensive error catching and logging
- **Team Management**: Manages course enrollment using Appwrite Teams

#### Key Components:

**1. Client Initialization** (Lines 1-16)
```javascript
const client = new sdk.Client();
client
  .setEndpoint(process.env.APPWRITE_FUNCTION_ENDPOINT)
  .setProject(process.env.APPWRITE_FUNCTION_PROJECT_ID)
  .setKey(process.env.APPWRITE_API_KEY);

const databases = new sdk.Databases(client);
const storage = new sdk.Storage(client);
const users = new sdk.Users(client);
const teams = new sdk.Teams(client);
```
- Sets up Appwrite SDK with server credentials
- Initializes services: Databases, Storage, Users, Teams

**2. Database Collections** (Lines 18-31)
```javascript
const COLLECTIONS = {
  COURSES: 'courses',
  LESSONS: 'lessons',
  QUIZZES: 'quizzes',
  // ... 11 collections total
}
```
- Defines all database collection names
- Centralized reference for database operations

**3. Authentication Helper** (Lines 47-69)
```javascript
const authenticateUser = async (userId) => {
  const user = await users.get(userId);
  const userRole = user.labels?.role || 'student';
  return { userId, role: userRole, user };
}
```
- Validates user existence
- Extracts user role from labels
- Returns authentication data

**4. Permission Checker** (Lines 72-105)
```javascript
const checkPermission = (userRole, operation, resource) => {
  if (userRole === 'admin') return true;
  if (userRole === 'student') {
    // Specific rules for students
  }
  return false;
}
```
- Enforces role-based access control
- Admin: Full access to everything
- Student: Limited to GET and specific POST operations

**5. API Endpoints** (Lines 211-1127)

Each resource has its own section with CRUD operations:

- **Courses** (Lines 211-304)
  - List all courses with filters
  - Get course with lessons
  - Create/update/delete courses (admin only)
  - Auto-create teams for courses

- **Enrollment** (Lines 308-485)
  - Enroll students in courses
  - Verify enrollment status
  - Unenroll from courses
  - Track enrollment transactions

- **Lessons** (Lines 489-550)
  - CRUD operations for lessons
  - Order lessons sequentially
  - Track completion counts

- **Quizzes** (Lines 554-623)
  - Manage quizzes and questions
  - Time limits and active status

- **Quiz Questions** (Lines 627-680)
  - Multiple choice questions
  - Correct answer tracking

- **User Progress** (Lines 684-738)
  - Track lesson completion
  - Time spent tracking
  - Progress percentage

- **Quiz Attempts** (Lines 742-906)
  - Submit quiz answers
  - Auto-grade quizzes
  - Calculate scores and pass/fail
  - Store detailed answer analysis

- **Transactions** (Lines 909-957)
  - Track enrollments and payments

- **Ranks** (Lines 958-1006)
  - Leaderboard management

- **Badges** (Lines 1007-1055)
  - Badge definitions

- **User Badges** (Lines 1056-1104)
  - Award badges to users

- **Notifications** (Lines 1105-1127)
  - User notifications with read status

#### Special Features:

**Auto-Grading System** (Lines 780-850)
```javascript
// Validates answers against correct answers
const detailedAnswers = questions.documents.map((question, index) => {
  const studentAnswer = answers[index];
  const isCorrect = studentAnswer === question.correctAnswer;
  if (isCorrect) score++;
  return { questionId, studentAnswer, correctAnswer, isCorrect };
});
```
- Compares student answers with correct answers
- Calculates score automatically
- Determines pass/fail (60% threshold)
- Stores detailed breakdown

**Team-Based Enrollment** (Lines 320-385)
```javascript
// Add user to course team
await teams.createMembership(
  courseId,
  ['student'],
  'http://localhost',
  enrollStudentId
);
```
- Uses Appwrite Teams for access control
- Each course has its own team
- Students join team upon enrollment

---

### 2. `discord-logger.js` (Logging Utility)
**Size:** ~303 lines  
**Purpose:** Real-time logging to Discord webhooks for monitoring and debugging

#### What it does:
- **Discord Integration**: Sends formatted messages to Discord channel via webhook
- **Log Levels**: Supports 5 levels (info, success, warning, error, debug)
- **Colored Embeds**: Uses Discord embeds with color coding
- **Specialized Loggers**: Pre-built methods for common scenarios
- **Development Mode**: Debug logs only in development

#### Architecture:

**1. Logger Class** (Lines 6-17)
```javascript
class DiscordLogger {
  constructor() {
    this.webhookUrl = process.env.DISCORD_WEBHOOK_URL;
    this.enabled = !!this.webhookUrl;
    this.colors = {
      info: 0x3498db,    // Blue
      success: 0x2ecc71, // Green
      warning: 0xf39c12, // Orange
      error: 0xe74c3c,   // Red
      debug: 0x9b59b6    // Purple
    };
  }
}
```
- Singleton pattern for global access
- Graceful fallback if webhook not configured
- Color-coded for visual distinction

**2. Core Sending Method** (Lines 26-77)
```javascript
async sendToDiscord(title, description, level, fields) {
  const embed = {
    title: `🎓 EdTech Platform - ${title}`,
    description: description,
    color: this.colors[level],
    timestamp: new Date().toISOString(),
    fields: fields,
    footer: { text: `Environment: ${process.env.NODE_ENV}` }
  };
  
  // Add emoji thumbnails based on level
  if (level === 'error') embed.thumbnail = { url: '🚨 emoji' };
  
  await fetch(this.webhookUrl, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ embeds: [embed] })
  });
}
```
- Creates rich Discord embeds
- Adds contextual emojis
- Includes environment info
- Timestamps all logs

**3. Log Level Methods** (Lines 84-194)

Each method formats data appropriately:

- **logInfo()** - General information
- **logSuccess()** - Successful operations
- **logWarning()** - Potential issues
- **logError()** - Errors with stack traces
- **logDebug()** - Development debugging (dev only)

**4. Specialized Loggers** (Lines 203-278)

Pre-built for common use cases:

- **logApiRequest()** - HTTP request logging
- **logUserActivity()** - User action tracking
- **logCourseActivity()** - Course events
- **logQuizActivity()** - Quiz events
- **logPerformanceMetrics()** - System metrics
- **logSecurityEvent()** - Security alerts

**5. Test Method** (Lines 283-293)
```javascript
async testConnection() {
  await this.logInfo('Discord Logger Test', {
    message: 'Discord logging is working correctly!',
    timestamp: new Date().toISOString()
  });
  return true;
}
```
- Verifies webhook is working
- Called by `/test-discord` endpoint

#### Usage Examples:

```javascript
// Import logger
import { logger } from './discord-logger.js';

// Log success
await logger.logSuccess('Course Created', {
  courseId: 'course_123',
  title: 'JavaScript Basics',
  instructor: 'user_456'
});

// Log error
await logger.logError('Database Error', error, {
  operation: 'createDocument',
  collection: 'courses'
});

// Log user activity
await logger.logUserActivity('user_123', 'Enrolled in Course', {
  courseId: 'course_456',
  courseName: 'Python Fundamentals'
});
```

#### Benefits:
- **Real-time monitoring** - See what's happening instantly
- **Historical record** - All logs stored in Discord
- **Team visibility** - Entire team can see system events
- **Visual clarity** - Color coding and emojis make scanning easy
- **No external service** - Uses Discord (likely already in use)

---

### 3. `package.json` (Dependencies)
**Purpose:** Node.js project configuration and dependencies

```json
{
  "name": "starter-template",
  "version": "1.0.0",
  "description": "",
  "main": "src/main.js",
  "type": "module",
  "scripts": {
    "format": "prettier --write ."
  },
  "dependencies": {
    "node-appwrite": "^14.1.0"
  },
  "devDependencies": {
    "prettier": "^3.2.5"
  }
}
```

#### Key Fields:

- **`"type": "module"`** - Enables ES6 imports/exports (not CommonJS)
- **`"main": "src/main.js"`** - Default entry point (not used, index.js is actual entry)
- **`node-appwrite`** - Official Appwrite SDK for Node.js
  - Version 14.1.0
  - Provides: Client, Databases, Users, Teams, Storage
  - Server-side SDK (not browser-compatible)
- **`prettier`** - Code formatter (development only)
  - Configured via `.prettierrc.json`
  - Script: `npm run format`

#### Why these dependencies?

**node-appwrite** is the only runtime dependency because:
- Appwrite Functions are serverless
- No web framework needed (Appwrite handles HTTP)
- No database driver needed (uses Appwrite Database)
- No authentication library needed (uses Appwrite Auth)
- Minimal bundle size for faster cold starts

---

### 4. `package-lock.json` (Locked Dependencies)
**Purpose:** Locks exact versions of all dependencies and their sub-dependencies

```json
{
  "name": "starter-template",
  "version": "1.0.0",
  "lockfileVersion": 3,
  "requires": true,
  "packages": {
    "node_modules/node-appwrite": {
      "version": "14.1.0",
      "dependencies": {
        "node-fetch-native-with-agent": "1.7.2"
      }
    }
  }
}
```

#### What it does:
- **Version Locking**: Ensures everyone gets same versions
- **Reproducible Builds**: Same code across all environments
- **Security**: Prevents supply chain attacks via version pinning
- **Sub-dependencies**: Locks transitive dependencies
  - `node-fetch-native-with-agent` - HTTP client for Appwrite SDK

#### Best Practice:
- ✅ **Always commit** `package-lock.json` to version control
- ✅ **Use `npm ci`** in production (respects lock file exactly)
- ✅ **Update carefully** with `npm update`

---

## 📄 Configuration Files

### 5. `env.template` (Environment Variables Template)
**Purpose:** Template for required environment variables

```env
# Appwrite Configuration (Required)
APPWRITE_FUNCTION_ENDPOINT=https://cloud.appwrite.io/v1
APPWRITE_FUNCTION_PROJECT_ID=your_project_id_here
APPWRITE_API_KEY=your_server_api_key_here
DATABASE_ID=edtech_db

# Discord Logging (Optional but recommended)
DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/your/webhook/url

# Environment
NODE_ENV=production
```

#### Variables Explained:

**1. APPWRITE_FUNCTION_ENDPOINT**
- Appwrite API endpoint URL
- Cloud: `https://cloud.appwrite.io/v1`
- Self-hosted: Your custom domain + `/v1`

**2. APPWRITE_FUNCTION_PROJECT_ID**
- Your project's unique identifier
- Found in Appwrite Console → Settings
- Format: alphanumeric string (e.g., `6543c1a2b3f4e5d6g7h8`)

**3. APPWRITE_API_KEY**
- Server API key with full permissions
- Generated in Appwrite Console → API Keys
- Scopes needed: `databases.read`, `databases.write`, `users.read`, `teams.read`, `teams.write`
- ⚠️ **Security**: Never expose in client-side code

**4. DATABASE_ID**
- Database identifier (default: `edtech_db`)
- Must match database created in Appwrite Console

**5. DISCORD_WEBHOOK_URL**
- Discord webhook for logging (optional)
- Create in Discord: Server Settings → Integrations → Webhooks
- Format: `https://discord.com/api/webhooks/{id}/{token}`

**6. NODE_ENV**
- Environment mode (`development` or `production`)
- Affects debug logging and error details

#### Usage:
```bash
# Copy template
cp env.template .env

# Edit with your values
nano .env

# For Appwrite Functions, add these in Console → Environment Variables
```

---

### 6. `.gitignore` (Git Ignore Rules)
**Purpose:** Tells Git which files/folders to ignore

```
# Dependencies
node_modules/

# Environment variables
.env
.env.local
.env.*.local

# Logs
logs
*.log

# Build outputs
dist/
.appwrite/

# IDE
.vscode-test

# etc...
```

#### Important Exclusions:

**Security:**
- `.env` - Contains sensitive credentials
- `*.log` - May contain sensitive data

**Build artifacts:**
- `node_modules/` - Can be regenerated with `npm install`
- `.appwrite/` - Appwrite CLI local cache

**Why this matters:**
- Prevents accidentally committing secrets to Git
- Keeps repository clean and small
- Prevents merge conflicts on generated files

---

### 7. `.prettierrc.json` (Code Formatting)
**Purpose:** Prettier configuration for consistent code style

```json
{
  "trailingComma": "es5",
  "tabWidth": 2,
  "semi": true,
  "singleQuote": true
}
```

#### Settings Explained:

- **trailingComma: "es5"** - Adds trailing commas where valid in ES5 (objects, arrays)
- **tabWidth: 2** - Uses 2 spaces for indentation
- **semi: true** - Always adds semicolons
- **singleQuote: true** - Uses single quotes instead of double

#### Usage:
```bash
# Format all files
npm run format

# Format specific file
npx prettier --write index.js
```

---

## 📚 Documentation Files

### 8. `README.md` (Main Documentation)
**Size:** ~950 lines  
**Purpose:** Comprehensive project documentation

#### Sections:

1. **Overview** - What the project is
2. **Features** - List of capabilities
3. **Architecture** - System design diagrams
4. **Getting Started** - Installation guide
5. **API Endpoints** - All 40+ endpoints documented
6. **Authentication** - Security model
7. **Database Schema** - All 11 collections
8. **Environment Variables** - Configuration guide
9. **Deployment** - Appwrite deployment steps
10. **Monitoring** - Discord logging setup
11. **Testing** - Postman collection usage
12. **Error Handling** - Response formats
13. **Best Practices** - Developer guidelines

#### Audience:
- New developers joining the project
- Frontend developers integrating the API
- DevOps engineers deploying the system
- QA testers validating functionality

---

### 9. `appwrite-setup.md` (Setup Guide)
**Size:** ~260 lines  
**Purpose:** Step-by-step Appwrite configuration

#### Contents:

**1. Environment Variables** (Lines 1-15)
- Copy-paste ready configuration
- All required and optional variables

**2. Function Settings** (Lines 17-29)
- Runtime: Node.js 18.0
- Entrypoint: index.js
- Build commands
- Memory and timeout recommendations

**3. Deployment Steps** (Lines 31-61)
- Creating function in Console
- Configuring environment
- Uploading code
- Setting up database
- Testing deployment

**4. Database Permissions** (Lines 63-88)
- Permission rules for each collection type
- Public collections vs user-specific
- Admin-only collections

**5. Collection Attributes** (Lines 90-237)
- Complete JSON schemas for all 11 collections
- Field types, sizes, and requirements
- Default values

**6. Indexes for Performance** (Lines 239-250)
- Recommended indexes for each collection
- Improves query performance

**7. Testing** (Lines 252-262)
- Postman setup
- Environment variables
- Test sequence

**8. Monitoring** (Lines 264-271)
- Log checking
- Discord webhooks
- Performance tracking

**9. Troubleshooting** (Lines 273-283)
- Common issues and solutions
- Permission errors
- CORS problems
- Timeout issues

#### Use Case:
Reference when setting up fresh Appwrite project or troubleshooting configuration issues.

---

### 10. `FILE_EXPLANATIONS.md` (This File)
**Purpose:** Detailed explanation of every file in the project

You're reading it! 😊

---

## 🧪 Testing Files

### 11. `edtech-api.postman_collection.json` (API Tests)
**Size:** ~682 lines  
**Purpose:** Postman collection for testing all API endpoints

#### Structure:

```json
{
  "info": {
    "name": "EdTech Platform API",
    "description": "Complete API collection...",
    "version": "1.0.0"
  },
  "variable": [
    {
      "key": "base_url",
      "value": "https://68c2a1d90003e461b539.fra.appwrite.run"
    }
  ],
  "item": [ /* 13 folders with 40+ requests */ ]
}
```

#### Collection Folders:

1. **Health Check** (2 requests)
   - GET /health
   - GET /test-discord

2. **Courses** (5 requests)
   - GET /courses
   - GET /courses/{id}
   - POST /courses
   - PUT /courses/{id}
   - DELETE /courses/{id}

3. **Enrollment** (3 requests)
   - POST /enroll
   - GET /enroll
   - DELETE /enroll

4. **Lessons** (6 requests)
   - GET /lessons
   - GET /lessons/{id}
   - GET /lessons?courseId=
   - POST /lessons
   - PUT /lessons/{id}
   - DELETE /lessons/{id}

5. **Quizzes** (5 requests)
   - GET /quizzes
   - GET /quizzes/{id}
   - POST /quizzes
   - PUT /quizzes/{id}
   - DELETE /quizzes/{id}

6. **Quiz Questions** (4 requests)
   - GET /quiz-questions?quizId=
   - POST /quiz-questions
   - PUT /quiz-questions/{id}
   - DELETE /quiz-questions/{id}

7. **User Progress** (2 requests)
   - GET /progress
   - POST /progress

8. **Quiz Attempts** (2 requests)
   - GET /quiz-attempts
   - POST /quiz-attempts

9. **Transactions** (2 requests)
   - GET /transactions
   - POST /transactions

10. **Ranks** (2 requests)
    - GET /ranks
    - POST /ranks

11. **Badges** (2 requests)
    - GET /badges
    - POST /badges

12. **User Badges** (2 requests)
    - GET /user-badges
    - POST /user-badges

13. **Notifications** (3 requests)
    - GET /notifications
    - POST /notifications
    - PUT /notifications/{id}

#### Features:

**Variables:**
```json
{
  "key": "base_url",
  "value": "https://your-function-url",
  "type": "string"
}
```
- Change once, applies to all requests
- Easy environment switching

**Pre-configured Headers:**
```json
{
  "X-User-Id": "{{user_id}}",
  "Content-Type": "application/json"
}
```
- Authentication header included
- Content type set correctly

**Sample Request Bodies:**
```json
{
  "title": "Test Course",
  "description": "Test Description",
  "instructorId": "user_123",
  "category": "Testing",
  "price": 0
}
```
- Ready-to-use examples
- Valid data for testing

#### How to Use:

1. **Import into Postman**
   - Open Postman
   - File → Import
   - Select `edtech-api.postman_collection.json`

2. **Configure Variables**
   - Click collection name
   - Variables tab
   - Set `base_url` to your function URL
   - Add `user_id` and `admin_id` variables

3. **Test Endpoints**
   - Start with Health Check
   - Test as admin (full access)
   - Test as student (limited access)
   - Verify responses

4. **Debugging**
   - Check response status codes
   - View response bodies
   - Check Discord logs
   - Verify database changes

---

## 📂 Directory Structure

### 12. `src/` Directory
**Contains:** Default Appwrite function template

#### `src/main.js`
**Purpose:** Appwrite's default starter template (not actively used)

```javascript
import { Client, Users } from 'node-appwrite';

export default async ({ req, res, log, error }) => {
  const client = new Client()
    .setEndpoint(process.env.APPWRITE_FUNCTION_API_ENDPOINT)
    .setProject(process.env.APPWRITE_FUNCTION_PROJECT_ID)
    .setKey(req.headers['x-appwrite-key'] ?? '');
  
  const users = new Users(client);

  if (req.path === "/ping") {
    return res.text("Pong");
  }

  return res.json({
    motto: "Build like a team of hundreds_",
    learn: "https://appwrite.io/docs",
    connect: "https://appwrite.io/discord",
    getInspired: "https://builtwith.appwrite.io",
  });
};
```

**Status:** Reference only - actual API is in `index.js`

**Why keep it?**
- Shows Appwrite function structure
- Reference for function signature
- Demonstrates basic request/response
- Can be used for testing basic function deployment

---

### 13. `scripts/` Directory
**Purpose:** Utility scripts (if any)

Currently empty or may contain:
- Database setup scripts
- Data migration scripts
- Seed data scripts
- Development utilities

---

## 🔄 File Relationships

### Dependency Flow:

```
index.js
  ├─→ discord-logger.js (import)
  ├─→ node-appwrite (import)
  ├─→ .env (environment variables)
  └─→ Appwrite Cloud (API calls)

discord-logger.js
  ├─→ .env (webhook URL)
  └─→ Discord Webhook (HTTP POST)

package.json
  ├─→ node-appwrite (dependency)
  └─→ prettier (dev dependency)

package-lock.json
  └─→ locks all dependency versions

.gitignore
  └─→ protects .env from being committed
```

### Execution Flow:

```
1. Appwrite receives HTTP request
2. Loads index.js as serverless function
3. index.js reads environment from process.env
4. index.js imports discord-logger.js
5. Request is authenticated and routed
6. Database operations executed
7. Discord logger called (if applicable)
8. Response returned to client
```

---

## 📊 File Statistics

| File | Lines | Purpose | Critical? |
|------|-------|---------|-----------|
| `index.js` | ~1,130 | Main API | ✅ Yes |
| `discord-logger.js` | ~303 | Logging | ⚠️ Optional |
| `README.md` | ~950 | Docs | 📖 Info |
| `appwrite-setup.md` | ~260 | Setup Guide | 📖 Info |
| `edtech-api.postman_collection.json` | ~682 | Testing | 🧪 Test |
| `package.json` | ~15 | Config | ✅ Yes |
| `package-lock.json` | ~60 | Lock file | ✅ Yes |
| `env.template` | ~18 | Template | 📋 Template |
| `.gitignore` | ~125 | Git rules | ✅ Yes |
| `.prettierrc.json` | ~6 | Formatting | 🎨 Style |
| `src/main.js` | ~34 | Template | 📚 Reference |

**Total Project Size:** ~3,583 lines of code and documentation

---

## 🎯 Critical Files (Must Have)

1. **`index.js`** - Without this, no API
2. **`package.json`** - Node.js won't work
3. **`package-lock.json`** - Ensures consistent builds
4. **`.gitignore`** - Prevents committing secrets
5. **`.env` (created from template)** - Required for function to run

## 📚 Documentation Files (Recommended)

1. **`README.md`** - Primary documentation
2. **`appwrite-setup.md`** - Setup instructions
3. **`FILE_EXPLANATIONS.md`** - This file

## 🧪 Development Files (Optional but Useful)

1. **`discord-logger.js`** - Makes debugging much easier
2. **`edtech-api.postman_collection.json`** - Essential for testing
3. **`.prettierrc.json`** - Keeps code clean
4. **`env.template`** - Helps new developers

---

## 🚀 Quick Start Summary

To get the backend running, you need:

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Configure environment:**
   ```bash
   cp env.template .env
   # Edit .env with your values
   ```

3. **Deploy to Appwrite:**
   - Upload `index.js`, `discord-logger.js`, `package.json`
   - Set environment variables in Console
   - Deploy and test

4. **Test with Postman:**
   - Import `edtech-api.postman_collection.json`
   - Set `base_url` variable
   - Run health check

5. **Monitor:**
   - Check Appwrite Function logs
   - Watch Discord channel (if configured)

---

## 💡 File Maintenance Tips

### Regular Updates:
- **`package.json`** - Update dependencies monthly for security
- **`README.md`** - Update when adding new features
- **`edtech-api.postman_collection.json`** - Update when API changes

### Version Control:
- ✅ Commit: All files except `.env` and `node_modules/`
- ✅ Track: `package-lock.json` for reproducible builds
- ❌ Never commit: `.env`, sensitive data

### Before Deployment:
1. Run `npm run format` (formats code)
2. Test all endpoints in Postman
3. Check Discord logging is working
4. Verify environment variables are set
5. Review Appwrite Console configuration

---

## 🔍 Finding Things

**Need to:**
- **Add a new endpoint?** → Edit `index.js`, add route handler
- **Change logging?** → Edit `discord-logger.js`
- **Update docs?** → Edit `README.md`
- **Fix configuration?** → Check `appwrite-setup.md`
- **Test API?** → Use `edtech-api.postman_collection.json`
- **Change dependencies?** → Edit `package.json`, run `npm install`
- **Set environment?** → Copy `env.template` to `.env`

---

## 📞 Questions?

If you need clarification on any file:
1. Check the relevant documentation file
2. Review code comments
3. Test in Postman
4. Check Appwrite docs: https://appwrite.io/docs
5. Review Discord logs for runtime behavior

---

**Last Updated:** October 20, 2025  
**Project:** EdTech Platform Backend  
**Version:** 1.0.0
