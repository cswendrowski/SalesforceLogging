@isTest
class SSLoggingTest {

    @testSetup
    static void setup() {
        SSLoggingSettings__c settings = new SSLoggingSettings__c();
        settings.App_Name__c = 'SSLoggingTesting';
        settings.Papertrail_LogsX__c = 1;
        settings.Papertrail_Port__c = 44444;
        settings.Log_Layout__c = '[${level}] ${message}';

        insert settings;
    }

    @isTest
    static void testInfoLog() {
        Test.setMock(HttpCalloutMock.class, new SalesforceLoggingHttpMock());

        SSLogging logger = SSLogging.GetCurrentClassLogger();

        System.assert(logger != null);
        logger.info('Info Test');
        System.assert(true);
    }

    @isTest
    static void testDefaultAppname() {
        SSLogging logger = SSLogging.GetCurrentClassLogger();

        System.assertEquals('SSLoggingTesting', logger.appName);
    }

    @isTest
    static void testCanSetAppname() {
        SSLogging logger = SSLogging.GetCurrentClassLogger().withAppName('CustomAppName');

        System.assertEquals('CustomAppName', logger.appName);
    }

    @isTest
    static void testDefaultLoggerName() {
        SSLogging logger = SSLogging.GetCurrentClassLogger();

        System.assertEquals('SSLoggingTest', logger.loggerName);
    }

    @isTest
    static void testNamedLogger() {
        SSLogging logger = SSLogging.GetLogger('CustomLogger');

        System.assertEquals('CustomLogger', logger.loggerName);
    }

    @isTest
    static void testCanGetSettings() {
        SSLoggingSettings__c settings = SSLoggingSettings__c.getInstance();

        System.assert(settings != null);
        System.assertEquals('SSLoggingTesting', settings.App_Name__c);
    }
}

