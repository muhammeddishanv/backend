/**
 * Discord Logger Utility for EdTech Platform
 * Sends logs to Discord webhook for monitoring and debugging
 */

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

  /**
   * Send a message to Discord webhook
   * @param {string} title - The message title
   * @param {string} description - The message description
   * @param {string} level - The log level (info, success, warning, error, debug)
   * @param {Object} fields - Additional fields to include
   */
  async sendToDiscord(title, description, level = 'info', fields = []) {
    if (!this.enabled) {
      console.log(`[${level.toUpperCase()}] ${title}: ${description}`);
      return;
    }

    try {
      const embed = {
        title: `🎓 EdTech Platform - ${title}`,
        description: description,
        color: this.colors[level] || this.colors.info,
        timestamp: new Date().toISOString(),
        fields: fields,
        footer: {
          text: `Environment: ${process.env.NODE_ENV || 'development'}`
        }
      };

      // Add additional context based on log level
      if (level === 'error') {
        embed.thumbnail = {
          url: 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/72x72/1f6a8.png'
        };
      } else if (level === 'success') {
        embed.thumbnail = {
          url: 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/72x72/2705.png'
        };
      } else if (level === 'warning') {
        embed.thumbnail = {
          url: 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/72x72/26a0.png'
        };
      }

      const payload = {
        embeds: [embed]
      };

      const response = await fetch(this.webhookUrl, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(payload)
      });

      if (!response.ok) {
        console.error('Failed to send Discord notification:', response.statusText);
      }
    } catch (error) {
      console.error('Discord logger error:', error.message);
    }
  }

  /**
   * Log an info message
   * @param {string} title - The message title
   * @param {Object} data - Additional data to log
   */
  async logInfo(title, data = {}) {
    const fields = Object.entries(data).map(([key, value]) => ({
      name: key,
      value: typeof value === 'object' ? JSON.stringify(value, null, 2) : String(value),
      inline: true
    }));

    await this.sendToDiscord(
      title,
      'Information event occurred',
      'info',
      fields
    );
  }

  /**
   * Log a success message
   * @param {string} title - The message title
   * @param {Object} data - Additional data to log
   */
  async logSuccess(title, data = {}) {
    const fields = Object.entries(data).map(([key, value]) => ({
      name: key,
      value: typeof value === 'object' ? JSON.stringify(value, null, 2) : String(value),
      inline: true
    }));

    await this.sendToDiscord(
      title,
      'Operation completed successfully',
      'success',
      fields
    );
  }

  /**
   * Log a warning message
   * @param {string} title - The message title
   * @param {Object} data - Additional data to log
   */
  async logWarning(title, data = {}) {
    const fields = Object.entries(data).map(([key, value]) => ({
      name: key,
      value: typeof value === 'object' ? JSON.stringify(value, null, 2) : String(value),
      inline: true
    }));

    await this.sendToDiscord(
      title,
      'Warning condition detected',
      'warning',
      fields
    );
  }

  /**
   * Log an error message
   * @param {string} title - The message title
   * @param {Error|string} error - The error object or message
   * @param {Object} data - Additional data to log
   */
  async logError(title, error, data = {}) {
    const errorFields = [];
    
    if (error instanceof Error) {
      errorFields.push(
        { name: 'Error Message', value: error.message, inline: false },
        { name: 'Stack Trace', value: '```\n' + (error.stack || 'No stack trace').substring(0, 1000) + '\n```', inline: false }
      );
    } else {
      errorFields.push({ name: 'Error', value: String(error), inline: false });
    }

    const additionalFields = Object.entries(data).map(([key, value]) => ({
      name: key,
      value: typeof value === 'object' ? JSON.stringify(value, null, 2) : String(value),
      inline: true
    }));

    await this.sendToDiscord(
      title,
      'An error occurred in the system',
      'error',
      [...errorFields, ...additionalFields]
    );
  }

  /**
   * Log a debug message
   * @param {string} title - The message title
   * @param {Object} data - Additional data to log
   */
  async logDebug(title, data = {}) {
    // Only log debug messages in development environment
    if (process.env.NODE_ENV !== 'development') {
      return;
    }

    const fields = Object.entries(data).map(([key, value]) => ({
      name: key,
      value: typeof value === 'object' ? JSON.stringify(value, null, 2) : String(value),
      inline: true
    }));

    await this.sendToDiscord(
      title,
      'Debug information',
      'debug',
      fields
    );
  }

  /**
   * Log API request details
   * @param {string} method - HTTP method
   * @param {string} endpoint - API endpoint
   * @param {Object} details - Request details
   */
  async logApiRequest(method, endpoint, details = {}) {
    await this.logInfo(`API Request: ${method} ${endpoint}`, {
      method,
      endpoint,
      ...details
    });
  }

  /**
   * Log user activity
   * @param {string} userId - User ID
   * @param {string} action - Action performed
   * @param {Object} details - Additional details
   */
  async logUserActivity(userId, action, details = {}) {
    await this.logInfo(`User Activity: ${action}`, {
      userId,
      action,
      timestamp: new Date().toISOString(),
      ...details
    });
  }

  /**
   * Log course activity
   * @param {string} courseId - Course ID
   * @param {string} action - Action performed
   * @param {Object} details - Additional details
   */
  async logCourseActivity(courseId, action, details = {}) {
    await this.logInfo(`Course Activity: ${action}`, {
      courseId,
      action,
      timestamp: new Date().toISOString(),
      ...details
    });
  }

  /**
   * Log quiz activity
   * @param {string} quizId - Quiz ID
   * @param {string} action - Action performed
   * @param {Object} details - Additional details
   */
  async logQuizActivity(quizId, action, details = {}) {
    await this.logInfo(`Quiz Activity: ${action}`, {
      quizId,
      action,
      timestamp: new Date().toISOString(),
      ...details
    });
  }

  /**
   * Log system performance metrics
   * @param {Object} metrics - Performance metrics
   */
  async logPerformanceMetrics(metrics = {}) {
    await this.logInfo('System Performance Metrics', {
      ...metrics,
      timestamp: new Date().toISOString()
    });
  }

  /**
   * Log security events
   * @param {string} event - Security event type
   * @param {Object} details - Event details
   */
  async logSecurityEvent(event, details = {}) {
    await this.logWarning(`Security Event: ${event}`, {
      event,
      timestamp: new Date().toISOString(),
      ...details
    });
  }

  /**
   * Test the Discord webhook connection
   */
  async testConnection() {
    try {
      await this.logInfo('Discord Logger Test', {
        message: 'Discord logging is working correctly!',
        timestamp: new Date().toISOString()
      });
      return true;
    } catch (error) {
      console.error('Discord webhook test failed:', error.message);
      return false;
    }
  }
}

// Create and export a singleton instance
const logger = new DiscordLogger();

export {
  DiscordLogger,
  logger
};
