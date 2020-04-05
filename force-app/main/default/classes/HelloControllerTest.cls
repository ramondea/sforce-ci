@isTest
private class HelloControllerTest {
    @isTest static void testController() {
        HelloController.hello();
        HelloController.helloParametrizado('teste');
    }
}
