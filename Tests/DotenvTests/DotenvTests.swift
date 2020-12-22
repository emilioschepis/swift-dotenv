import Dotenv
import XCTest

final class DotenvTests: XCTestCase {
    func testSkipsEmptyLines() throws {
        let env = """
        key1=true
        
        key2=false
        """
        
        createEnvFile(content: env)
        addTeardownBlock { self.removeEnvFile() }
        
        let dotenv = try Dotenv()
        let environment = dotenv.variables
        
        XCTAssertEqual(environment.count, 2)
        XCTAssertEqual(dotenv.get("key1"), "true")
        XCTAssertEqual(dotenv.get("key2"), "false")
    }
    
    func testSkipsCommentLines() throws {
        let env = """
        # key1=true
        key2=true
        """
        
        createEnvFile(content: env)
        addTeardownBlock { self.removeEnvFile() }
        
        let dotenv = try Dotenv()
        let environment = dotenv.variables
        
        XCTAssertEqual(environment.count, 1)
        XCTAssertNil(dotenv.get("key1"))
    }
    
    func testSupportsWhitespacesInLines() throws {
        let env = """
          key1  = true
        """
        
        createEnvFile(content: env)
        addTeardownBlock { self.removeEnvFile() }
        
        let dotenv = try Dotenv()
        let environment = dotenv.variables
        
        XCTAssertEqual(environment.count, 1)
        XCTAssertEqual(dotenv.get("key1"), "true")
    }
    
    func testSupportsNumbers() throws {
        let env = """
        key1=111
        key2=123
        key3=1a2
        """
        
        createEnvFile(content: env)
        addTeardownBlock { self.removeEnvFile() }
        
        let dotenv = try Dotenv()
        let environment = dotenv.variables
        
        XCTAssertEqual(environment.count, 3)
        XCTAssertEqual(dotenv.getInt("key1"), 111)
        XCTAssertEqual(dotenv.getInt("key2"), 123)
        
        XCTAssertEqual(dotenv.get("key3"), "1a2")
        XCTAssertNil(dotenv.getInt("key3"))
    }
    
    func testSupportsBooleans() throws {
        let env = """
        key1=true
        key2=false
        key3=somethingelse
        """
        
        createEnvFile(content: env)
        addTeardownBlock { self.removeEnvFile() }
        
        let dotenv = try Dotenv()
        let environment = dotenv.variables
        
        XCTAssertEqual(environment.count, 3)
        XCTAssertEqual(dotenv.getBool("key1"), true)
        XCTAssertEqual(dotenv.getBool("key2"), false)
        
        XCTAssertEqual(dotenv.get("key3"), "somethingelse")
        XCTAssertNil(dotenv.getBool("key3"))
    }
    
    func testThrowsOnMissingFile() throws {
        XCTAssertThrowsError(try Dotenv(), "Did not throw an error with missing file") { error in
            XCTAssertEqual(error as? DotenvError, DotenvError.notFound)
        }
    }
    
    func testThrowsOnInvalidSyntax() throws {
        let env = """
        key1
        """
        
        createEnvFile(content: env)
        addTeardownBlock { self.removeEnvFile() }
        
        XCTAssertThrowsError(try Dotenv(), "Did not throw an error with invalid syntax") { error in
            XCTAssertEqual(error as? DotenvError, DotenvError.invalidValue)
        }
    }
    
    func testThrowsOnKeyWithoutValue() throws {
        let env = """
        key1=
        """
        
        createEnvFile(content: env)
        addTeardownBlock { self.removeEnvFile() }
        
        XCTAssertThrowsError(try Dotenv(), "Did not throw an error with invalid syntax") { error in
            XCTAssertEqual(error as? DotenvError, DotenvError.invalidValue)
        }
    }
    
    func testThrowsOnKeyWithWhitespaces() throws {
        let env = """
        key 1=value1
        """
        
        createEnvFile(content: env)
        addTeardownBlock { self.removeEnvFile() }
        
        XCTAssertThrowsError(try Dotenv(), "Did not throw an error with invalid syntax") { error in
            XCTAssertEqual(error as? DotenvError, DotenvError.invalidValue)
        }
    }
    
    private func createEnvFile(content: String, filename: String = ".env") {
        let data = content.data(using: .utf8)
        let path = FileManager.default.currentDirectoryPath + "/" + filename
        FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
    }
    
    private func removeEnvFile(_ filename: String = ".env") {
        let path = FileManager.default.currentDirectoryPath + "/" + filename
        try? FileManager.default.removeItem(atPath: path)
    }
    
    static var allTests = [
        ("testSkipsEmptyLines", testSkipsEmptyLines),
        ("testSkipsCommentLines", testSkipsCommentLines),
        ("testSupportsWhitespacesInLines", testSupportsWhitespacesInLines),
        ("testSupportsNumbers", testSupportsNumbers),
        ("testSupportsBooleans", testSupportsBooleans),
        ("testThrowsOnMissingFile", testThrowsOnMissingFile),
        ("testThrowsOnInvalidSyntax", testThrowsOnInvalidSyntax),
        ("testThrowsOnKeyWithoutValue", testThrowsOnKeyWithoutValue),
        ("testThrowsOnKeyWithWhitespaces", testThrowsOnKeyWithWhitespaces),
    ]
}
