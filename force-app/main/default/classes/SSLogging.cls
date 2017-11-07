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
        postLogToBridge(hostName, appName, loggerName, message, 'error');
    }

    public void warn(String message) {
        postLogToBridge(hostName, appName, loggerName, message, 'warn');
    }

    public void info(String message) {
        postLogToBridge(hostName, appName, loggerName, message, 'info');
    }

    public void debug(String message) {
        postLogToBridge(hostName, appName, loggerName, message, 'debug');
    }

    public void trace(String message) {
        postLogToBridge(hostName, appName, loggerName, message, 'trace');
    }

    @future(callout=true)
    private static void postLogToBridge(String hostName, String appName, String loggerName, String message, String level) {
        System.debug(message);

        HttpRequest request = new HttpRequest();
        Http http = new Http();
        request.setMethod('POST');

        String url = 'https://salesforcelogging.azurewebsites.net/api/Log';
        request.setEndpoint(url);

        LogMessage log = new LogMessage(hostName, appName, loggerName, message, level);
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

        public LogMessage(String hostName, String appName, String loggerName, String message, String logLevel) {
            this.hostName = hostName;
            this.appName = appName;
            this.loggerName = loggerName;
            this.message = message;
            this.logLevel = logLevel;
        }
    }
}