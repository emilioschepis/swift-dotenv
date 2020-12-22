# Dotenv

Swift package to parse and set environment variables read from `.env` files.

![](https://github.com/emilioschepis/swift-dotenv/workflows/CI/badge.svg)

## Install
```swift
// Package.swift

// ...
dependencies: [
// ...
.package(url: "https://github.com/emilioschepis/swift-dotenv.git", from: "1.0.0"),
]
// ...
```

## Methods

### Initializer
```swift
let dotenv = try Dotenv() // defaults to ".env"
let custom = try Dotenv(path: ".env.local")
```

### Get
```swift
let value: String? = try Dotenv().get("key")
```

### Get as number
```swift
let number: Int? = try Dotenv().getInt("key")
```

### Get as boolean
```swift
let boolean: Bool? = try Dotenv().getBool("key")
```

## Resources
- [SwiftDotEnv](https://github.com/SwiftOnTheServer/SwiftDotEnv) (archived)
