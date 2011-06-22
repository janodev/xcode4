

@interface MyTest : GHTestCase { }
@end


@implementation MyTest

- (BOOL)shouldRunOnMainThread {
    // By default NO, but if you have a UI test or test dependent on running on the main thread return YES
    return NO;
}

- (void)setUpClass {
    // Run at start of all tests in the class
}

- (void)tearDownClass {
    // Run at end of all tests in the class
}

- (void)setUp {
    // Run before each test method
}

- (void)tearDown {
    // Run after each test method
}  

- (void)testFoo {
    NSDate *date = [NSDate date];
    // assert a is not NULL, with no custom error description
    GHAssertNotNULL(date, nil);
    // assert equal objects, add custom error description
    GHAssertEqualObjects(date, date, @"%@ should be equal to: %@. Something bad happened", date, date);
}

- (void)testBar {
    // Another test
}

@end