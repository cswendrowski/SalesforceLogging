public class SSLogging {
    private String hostName;
    @TestVisible
    private String appName;
    @TestVisible
    private String loggerName;

    private SSLoggingSettings__c settings;

    public SSLogging(String loggerName) {
        hostName = URL.getSalesforceBaseUrl().toExternalForm();
        settings = SSLoggingSettings__c.getInstance();
        this.appName = settings.App_Name__c;
        this.loggerName = loggerName;
    }

    public SSLogging withAppName(String appName) {
        this.appName = appName;

        return this;
    }

    public void error(String message) {
        System.debug(System.LoggingLevel.ERROR, message);

        postLogToBridge(new LogMessage(hostName, appName, loggerName, settings, message, 'error'));
    }

    public void warn(String message) {
        System.debug(System.LoggingLevel.WARN, message);

        postLogToBridge(new LogMessage(hostName, appName, loggerName, settings, message, 'warn'));
    }

    public void info(String message) {
        System.debug(System.LoggingLevel.INFO, message);

        postLogToBridge(new LogMessage(hostName, appName, loggerName, settings, message, 'info'));
    }


    public void debug(String message) {
        System.debug(System.LoggingLevel.DEBUG, message);

        postLogToBridge(new LogMessage(hostName, appName, loggerName, settings, message, 'debug'));
    }

    public void trace(String message) {
        System.debug(System.LoggingLevel.FINE, message);

        postLogToBridge(new LogMessage(hostName, appName, loggerName, settings, message, 'trace'));
    }

    private void postLogToBridge(LogMessage log) {
        try {
            HttpRequest request = new HttpRequest();
            Http http = new Http();
            request.setMethod('POST');
            request.setEndpoint(log.bridgeUrl);

            String json = System.JSON.serialize(log);

            request.setBody(json);
            request.setHeader('content-type', 'application/json');

            HttpResponse response = http.send(request);
        } catch (Exception e) {
            System.debug(System.LoggingLevel.ERROR, 'SSLogging: Unable to queue log message.\n Reason: ' + e.getMessage());
        }
    }

    public static SSLogging GetCurrentClassLogger() {
        return new SSLogging(StackTrace.getCallingClassName());
    }

    public static SSLogging GetLogger(String loggerName) {
        return new SSLogging(loggerName);
    }

    public class LogMessage {
        public String hostName;
        public String appName;
        public String loggerName;
        public String message;
        public String logLevel;
        public String bridgeUrl;
        public String loggingServerUrl;
        public Integer loggingServerPort;
        public String logLayout;
        public Datetime sourceDate;


        public LogMessage(String hostName, String appName, String loggerName, SSLoggingSettings__c settings, String message, String logLevel) {
            this.hostName = hostName;
            this.appName = appName;
            this.loggerName = loggerName;
            this.message = message;
            this.logLevel = logLevel;
            this.bridgeUrl = settings.Logging_Bridge_Url__c;
            this.loggingServerUrl = settings.Logging_Server_URL__c;
            this.loggingServerPort = settings.Logging_Server_Port__c.intValue();
            this.logLayout = settings.Log_Layout__c;
            sourceDate = Datetime.now();
        }
    }
}