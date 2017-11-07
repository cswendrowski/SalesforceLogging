@isTest
global class SalesforceLoggingHttpMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        System.assertEquals('https://salesforcelogging.azurewebsites.net/api/Log', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());

        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        return res;
    }
}