@isTest
class SSLoggingTest {

    private static SSLogging logger = SSLogging.GetCurrentClassLogger();
    private static SSLogging appNamedLogger = SSLogging.GetCurrentClassLogger().withAppName('CustomAppName');
    private static SSLogging namedLogger = SSLogging.GetLogger('CustomLogger');

    @testSetup
    static void setup() {
        SSLoggingSettings__c settings = new SSLoggingSettings__c();
        settings.App_Name__c = 'SSLoggingTesting';
        settings.Logging_Bridge_Url__c = 'http://www.bridge.dev/Log';
        settings.Logging_Server_URL__c = 'http://www.someserver.dev';
        settings.Logging_Server_Port__c = 44444;
        settings.Log_Layout__c = '[${level}] ${message}';

        insert settings;
    }

    @isTest
    static void testInfoLog() {
        Test.setMock(HttpCalloutMock.class, new SalesforceLoggingHttpMock());

        System.assert(logger != null);
        logger.info('Info Test');
        System.assert(true);
    }

    @isTest
    static void testDefaultAppname() {
        System.assertEquals('SSLoggingTesting', logger.appName);
    }

    @isTest
    static void testCanSetAppname() {
        System.assertEquals('CustomAppName', appNamedLogger.appName);
    }

    @isTest
    static void testDefaultLoggerName() {
        System.assertEquals('SSLoggingTest', logger.loggerName);
    }

    @isTest
    static void testNamedLogger() {
        System.assertEquals('CustomLogger', namedLogger.loggerName);
    }

    @isTest
    static void testCanGetSettings() {
        SSLoggingSettings__c settings = SSLoggingSettings__c.getInstance();

        System.assert(settings != null);
        System.assertEquals('SSLoggingTesting', settings.App_Name__c);
    }
}

