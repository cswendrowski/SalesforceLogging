# About

SSLogging uses an Azure Function as a Logging bridge in order to aggregate live-logs from Apex and Javascript to [Papertrail](https://papertrailapp.com), a popular log service with excellent search and filter capabilities.

Logging is automatically able to be grouped and filtered in Papertrail by environment (`HostName`) and application (`AppName`).

SSLogging uses [NLog](https://github.com/NLog) behind the scenes as its bridge logger.

## Why?

Apex logs are pretty terrible to find and use, which makes debugging a pain. By aggregatting logs across all environments and systems (both Apex and JS) it becomes much easier to understand your code's behavior at a glance and help resolve bugs.

# Installing SSLogging

One Click Deploy to Scratch Org via Dev Hub:
[![Deploy](https://deploy-to-sfdx.com/dist/assets/images/DeployToSFDX.svg)](https://deploy-to-sfdx.com)

As Managed Package:
**Coming Soon**

## Configuring

The package creates a new Custom Setting called `SSLoggingSettings`. An org-wide default for this setting must be created at minimum for the Logging to work.

From your Papertrail account, hit "Add Systems" and find the URL they give you for logs.
[![4ba5fa5a92.png](https://s1.postimg.org/7o7jkua0f3/4ba5fa5a92.png)](https://postimg.org/image/6sb25e0byz/)

Create an org-wide default setting that points to your PaperTrail and define a Log Layout.
![](https://s1.postimg.org/5afeba7eb3/087db900ef.png)

### Log Layouts

SSLogging fully supports the following dynamic values for the Log Layout:

* `${level}` - The log level
* `${logger}` - The logger name
* `${message}` - The formatted log message

SSLogging has support for any automatic values from the default NLog Package listed [here](https://github.com/NLog/NLog/wiki/Layout-Renderers) but does not have support for certain dynamic values such as `${exeception}`.

Examples:
`[${level}|${logger}] ${message}` produces `[Info|TestLogger] Test`

`[${level}] ${message}` produces `[Info] Test`

`${date}|${level}|${logger}|{$message}` produces `2017-11-06 14:15:06.9297|Info|TestLogger|Test`

# Using

## Log Levels

SSLogging supports the following levels:

* `Trace` - very detailed logs, which may include high-volume information such as protocol payloads. This log level is typically only enabled during development
* `Debug` - debugging information, less detailed than trace, typically not enabled in production environment.
* `Info` - information messages, which are normally enabled in production environment
* `Warn` - warning messages, typically for non-critical issues, which can be recovered or which are temporary failures
* `Error` - error messages - most of the time these are Exceptions

## Creating Apex Logs

### Creating loggers
Apex logging should be familiar to anyone who has used NLog or simliar logging libraries before.

It is advised to create one (`private static`) `SSLogging` per class.

This will create a `SSLogging` with the same name of the calling class - in this case, `SampleLogging`:
```
public class SampleLogging {
  private static SSLogging logger = SSLogging.GetCurrentClassLogger();
}
```

It is also possible to set the logger's name:
```
public class SampleLogging {
  private static SSLogging logger = SSLogging.GetLogger('CustomName');
}
```

Loggers can also be created with a custom `AppName` which is useful if you want to group logs into different groups:
```
public class SampleLogging {
  private static SSLogging logger = SSLogging.GetCurrentClassLogger().withAppName('CustomAppName');
}
```

### Writing Logs

Emitting log messages is based on the level you want to write the log as:
```
public class SampleLogging {
  private static SSLogging logger = SSLogging.GetCurrentClassLogger();
  
  public void foo() {
    logger.trace('Sample trace message');
    logger.debug('Sample debug message');
    logger.info('Sample informational message');
    logger.warn('Sample warning message');
    logger.error('Sample error message');
  }
}
```

## Creating JS Logs

**Coming soon**
