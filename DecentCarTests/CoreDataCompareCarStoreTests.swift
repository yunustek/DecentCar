//
//  CoreDataCompareCarStoreTests.swift
//  DecentCarTests
//
//  Created by Yunus Tek on 1.02.2023.
//

@testable import DecentCar
import XCTest

final class CoreDataCompareCarStoreTests: XCTestCase {

    func test_retrieve_deliversEmptyOnEmptyCache() {
        expectToRetrieve(makeSUT(), expectedResult: [])
    }

    func test_insert_searchTerm() {
        expectToInsert(makeSUT(), with: 0)
    }

    func test_retrieve_deliversValuesOnNonEmptyCache() {
        let sut = makeSUT()
        let ids: [Int64] = [10, 11]
        expectToInsert(sut, with: ids[0])
        expectToInsert(sut, with: ids[1])
        expectToRetrieve(sut, expectedResult: ids)
    }

    func test_delete_itemFromCache() {
        let sut = makeSUT()
        let id: Int64 = 12
        expectToInsert(sut, with: id)
        expectToDelete(sut, with: id)
    }
}

// MARK: - Helpers

extension CoreDataCompareCarStoreTests {

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> CompareCarStore {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataCompareCarStore(storeURL: storeURL)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    private func expectToRetrieve(_ sut: CompareCarStore, expectedResult: [Int64], file: StaticString = #filePath, line: UInt = #line) {

        sut.retrieve { retrieveResult in
            switch retrieveResult {
            case .success(let values):
                XCTAssertEqual(values.count, expectedResult.count)
            case .failure(let error):
                XCTFail("Expected to retrieve empty ids, got \(error) instead", file: file, line: line)
            }
        }
    }

    private func expectToInsert(_ sut: CompareCarStore, with id: Int64, file: StaticString = #filePath, line: UInt = #line) {
        sut.insert(id) { result in
            switch result {
            case .failure(let error):
                XCTAssertNil(error, file: file, line: line)
            case .success:
                break
            }
        }
    }

    private func expectToDelete(_ sut: CompareCarStore, with id: Int64, file: StaticString = #filePath, line: UInt = #line) {
        sut.delete(where: id) { result in
            switch result {
            case .failure(let error):
                XCTAssertNil(error, file: file, line: line)
            case .success:
                break
            }
        }
    }
}
