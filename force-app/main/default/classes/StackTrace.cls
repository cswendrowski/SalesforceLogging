/* Based on https://salesforce.stackexchange.com/questions/153835/get-currently-executing-class-method-name */
public class StackTrace {
    public static List<String> getCurrentStack()
    {
        return new DmlException().getStackTraceString().split('\n');
    }

    private static String getClassName(String line)
    {
        if (line.startsWith('Class.'))
            line = line.substringAfter('Class.');
        return line.substringBefore(':').substringBeforeLast('.');
    }

    private static String getMethod(String line)
    {
        return line.substringBefore(':').substringAfterLast('.');
    }

    public static String getClassName()
    {
        return getClassName(getCurrentStack()[2]);
    }

    public static String getMethod()
    {
        return getMethod(getCurrentStack()[2]);
    }

    public static String getCallingClassName()
    {
        return getClassName(getCurrentStack()[3]);
    }

    public static String getCallingMethodName()
    {
        return getMethod(getCurrentStack()[3]);
    }
}