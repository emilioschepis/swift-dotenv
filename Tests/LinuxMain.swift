import XCTest

import DotenvTests

var tests = [XCTestCaseEntry]()
tests += DotenvTests.allTests()
XCTMain(tests)
