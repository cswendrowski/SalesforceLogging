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
        postLogToBridge(hostName, appName, loggerName, message, 'error', settings.Log_Layout__c);
    }

    public void warn(String message) {
        postLogToBridge(hostName, appName, loggerName, message, 'warn', settings.Log_Layout__c);
    }

    public void info(String message) {
        postLogToBridge(hostName, appName, loggerName, message, 'info', settings.Log_Layout__c);
    }

    public void debug(String message) {
        postLogToBridge(hostName, appName, loggerName, message, 'debug', settings.Log_Layout__c);
    }

    public void trace(String message) {
        postLogToBridge(hostName, appName, loggerName, message, 'trace', settings.Log_Layout__c);
    }

    @future(callout=true)
    private static void postLogToBridge(String hostName, String appName, String loggerName, String message, String level, String layout) {
        System.debug(message);

        HttpRequest request = new HttpRequest();
        Http http = new Http();
        request.setMethod('POST');

        String url = 'https://salesforcelogging.azurewebsites.net/api/Log';
        request.setEndpoint(url);

        LogMessage log = new LogMessage(hostName, appName, loggerName, message, level, layout);
        String json = System.JSON.serialize(log);

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
        public String logLayout;

        public LogMessage(String hostName, String appName, String loggerName, String message, String logLevel, String layout) {
            this.hostName = hostName;
            this.appName = appName;
            this.loggerName = loggerName;
            this.message = message;
            this.logLevel = logLevel;
            this.logLayout = layout;
        }
    }
}