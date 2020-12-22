import Foundation

/// An error that might be thrown by a method in `Dotenv`.
public enum DotenvError: Error {
    /// Thrown if the specified file could not be found.
    case notFound
    /// Thrown if the one of the values in the file is not valid.
    case invalidValue
}

/// Reads .env files and sets their content as environment variables.
public struct Dotenv {
    private let fileManager: FileManager
    private var _variables: [String: String] = [:]
    
    /// A dictionary that contains all the parsed environment variables.
    public var variables: [String: String] { _variables }
    
    public init(path: String = ".env", fileManager: FileManager = .default) throws {
        self.fileManager = fileManager
        
        let absolutePath = getAbsolutePath(for: path)
        
        guard fileManager.fileExists(atPath: absolutePath) else {
            throw DotenvError.notFound
        }
        
        let contents = try String.init(contentsOfFile: absolutePath, encoding: .utf8)
        let lines = contents.split(separator: "\n").map { $0.trimmingCharacters(in: .whitespaces) }
        
        for line in lines {
            if line.isEmpty {
                continue
            }
            
            if line.starts(with: "#") {
                continue
            }
            
            let parts = line.split(separator: "=", maxSplits: 1)
            
            if parts.count != 2 {
                throw DotenvError.invalidValue
            }
            
            let key = parts[0].trimmingCharacters(in: .whitespaces)
            let value = parts[1].trimmingCharacters(in: .whitespaces)
            
            if key.rangeOfCharacter(from: .whitespaces) != nil {
                throw DotenvError.invalidValue
            }
            
            _variables[key] = value
            
            setenv(key, value, 1)
        }
    }
    
    
    /// Retrieves the value of the specified key in the environment variables.
    ///
    /// - Parameter key: The key to retrieve
    /// - Returns: The value of the variable or nil if it does not exist
    public func get(_ key: String) -> String? {
        guard let value = getenv(key) else {
            return nil
        }
        
        return String(validatingUTF8: value)
    }
    
    /// Retrieves the integer value of the specified key in the environment variables.
    ///
    /// - Parameter key: The key to retrieve
    /// - Returns: The value of the variable or nil if it is not compatible with type `Int`
    public func getInt(_ key: String) -> Int? {
        guard let value = get(key) else {
            return nil
        }
        
        return Int(value)
    }
    
    /// Retrieves the boolean value of the specified key in the environment variables.
    ///
    /// Only returns a boolean value if it is exactly "true" or "false".
    ///
    /// - Parameter key: The key to retrieve
    /// - Returns: The value of the variable or nil if it is not compatible with type `Bool`
    public func getBool(_ key: String) -> Bool? {
        guard let value = get(key) else {
            return nil
        }
        
        if value == "true" {
            return true
        } else if value == "false" {
            return false
        } else {
            return nil
        }
    }
    
    private func getAbsolutePath(for relativePath: String) -> String {
        let currentPath = fileManager.currentDirectoryPath
        return currentPath + "/" + relativePath
    }
}
