//
//  CarMapperTests.swift
//  DecentCarTests
//
//  Created by Yunus Tek on 30.01.2023.
//

@testable import DecentCar
import XCTest

final class CarMapperTests: XCTestCase {

    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let json = makeJson([[:]])
        let samples = [199, 201, 300, 400, 500]

        try samples.forEach { code in
            XCTAssertThrowsError(
                try CarMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }

    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() throws {
        let invalidJSON = anyData()

        XCTAssertThrowsError(
            try CarMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }

    func test_map_deliversCarsOn200HTTPResponseWithJSONItems() throws {

        let json = makeJson([[
            "id": 1,
            "make": "Audi",
            "model": "A8",
            "price": 16000,
            "firstRegistration": "02-2008",
            "mileage": 0,
            "fuel": "Gasoline",
            "images": [
                ["url": "https://loremflickr.com/g/480/640/audi"]
            ],
            "description": "No description available.",
            "modelline": "quattro",
            "seller": [
                "type": "Private",
                "phone": "+123456789",
                "city": "Rosenheim"
            ],
            "colour" : "Brown"
        ]])

        let result = try CarMapper.map(json, from: HTTPURLResponse(statusCode: 200))

        let car = Car(id: 1,
                      make: .audi,
                      model: .audi_a8,
                      price: 16000,
                      firstRegistration: "02-2008",
                      mileage: 0,
                      fuel: .gasoline,
                      images: [Image(url: "https://loremflickr.com/g/480/640/audi")],
                      description: "No description available.",
                      modelline: .audi_quattro,
                      seller: Seller(type: .private,
                                     phone: "+123456789",
                                     city: .rosenheim),
                      colour: .brown)

        XCTAssertEqual(result, [car])
    }
}

// MARK: - Helpers

extension CarMapperTests {

    private func makeJson(_ values: [[String: Any]]) -> Data {
        return try! JSONSerialization.data(withJSONObject: values)
    }
}
