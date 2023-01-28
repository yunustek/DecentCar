//
//  Configuration.swift
//  DecentCar
//
//  Created by Yunus Tek on 28.01.2023.
//

import Foundation

enum Configuration {

    enum ConfigError: Swift.Error {

        case missingPlistKey, invalidValue
    }

    private static func contents() -> [String : AnyObject] {

        guard let resource = Bundle.main.object(forInfoDictionaryKey: "Configurations"),
              let contents = resource as? [String : AnyObject] else { return [:] }
        return contents
    }

    static func value<T>(for key: String) throws -> T? where T: LosslessStringConvertible {

        guard let object = contents()[key] else {
            throw ConfigError.missingPlistKey
        }

        switch object {
        case let value as T:
            return (value as? String)?.isEmpty ?? false ? nil : value
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            throw ConfigError.invalidValue
        }
    }

    static var baseURL: String {

        let content: String! = try! Configuration.value(for: "BASE_URL")
        return content
    }
}
