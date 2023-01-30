//
//  CarEndpointTests.swift
//  DecentCarTests
//
//  Created by Yunus Tek on 30.01.2023.
//

@testable import DecentCar
import XCTest

final class CarEndpointTests: XCTestCase {

    func test_car_anyURL() throws {

        let baseURL = anyURL()
        let received = CarEndpoint.base.url(baseURL: baseURL)

        XCTAssertEqual(received.scheme, "https", "scheme")
        XCTAssertEqual(received.host, "any-url.com", "host")
        XCTAssertEqual(received.path, "", "path")
        XCTAssertEqual(received.query, "format=json&nojsoncallback=1", "query")
    }

    func test_car_endpointURL() throws {

        let baseURL = Configuration.baseURL
        let received = CarEndpoint.base.url(baseURL: baseURL)

        XCTAssertEqual(received.scheme, "https", "scheme")
        XCTAssertEqual(received.host, "private-fe87c-simpleclassifieds.apiary-mock.com", "host")
        XCTAssertEqual(received.path, "", "path")
        XCTAssertEqual(received.query, "format=json&nojsoncallback=1", "query")
    }
}
