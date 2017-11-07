@isTest
class StackTraceTest {

    @isTest
    static void testCanGetExecutingClass() {
        String name = StackTrace.getClassName();
        System.assertEquals('StackTraceTest', name);
    }

    @isTest
    static void testCanGetExecutingMethod() {
        String name = StackTrace.getMethod();
        System.assertEquals('testCanGetExecutingMethod', name);
    }

    @isTest
    static void testCanGetCallingClass() {
        String name = new Wrapper().nestedClass();
        System.assertEquals('StackTraceTest', name);
    }

    @isTest
    static void testCanGetCallingMethod() {
        String name = new Wrapper().nestedMethod();
        System.assertEquals('testCanGetCallingMethod', name);
    }

    class Wrapper {
        public String nestedClass() {
            return StackTrace.getCallingClassName();
        }

        public String nestedMethod() {
            return StackTrace.getCallingMethodName();
        }
    }
}
