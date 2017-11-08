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
        postLogToBridge(hostName, appName, loggerName, message, 'error',
                settings.Papertrail_LogsX__c, settings.Papertrail_Port__c, settings.Log_Layout__c);
    }

    public void warn(String message) {
        postLogToBridge(hostName, appName, loggerName, message, 'warn',
                settings.Papertrail_LogsX__c, settings.Papertrail_Port__c, settings.Log_Layout__c);
    }

    public void info(String message) {
        postLogToBridge(hostName, appName, loggerName, message, 'info',
                settings.Papertrail_LogsX__c, settings.Papertrail_Port__c, settings.Log_Layout__c);
    }

    public void debug(String message) {
        postLogToBridge(hostName, appName, loggerName, message, 'debug',
                settings.Papertrail_LogsX__c, settings.Papertrail_Port__c, settings.Log_Layout__c);
    }

    public void trace(String message) {
        postLogToBridge(hostName, appName, loggerName, message, 'trace',
                settings.Papertrail_LogsX__c, settings.Papertrail_Port__c, settings.Log_Layout__c);
    }

    private void postLogToBridge(String hostName, String appName, String loggerName, String message, String level,
            Decimal logsX, Decimal port, String layout) {
        System.debug(message);

        HttpRequest request = new HttpRequest();
        Http http = new Http();
        request.setMethod('POST');

        String url = 'https://salesforcelogging.azurewebsites.net/api/Log';
        request.setEndpoint(url);

        LogMessage log = new LogMessage(hostName, appName, loggerName, message, level,
                logsX.intValue(), port.intValue(), layout);
        String json = System.JSON.serialize(log);

        System.debug('Sending json ' + json);

        request.setBody(json);
        request.setHeader('content-type', 'application/json');

        HttpResponse response = http.send(request);
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
        public Integer paperTrailX;
        public Integer paperTrailPort;
        public String logLayout;
        public Datetime sourceDate;

        public LogMessage(String hostName, String appName, String loggerName, String message, String logLevel,
                Integer paperTrailX, Integer paperTrailPort, String layout) {
            this.hostName = hostName;
            this.appName = appName;
            this.loggerName = loggerName;
            this.message = message;
            this.logLevel = logLevel;
            this.paperTrailX = paperTrailX;
            this.paperTrailPort = paperTrailPort;
            this.logLayout = layout;
            sourceDate = Datetime.now();
        }
    }
}