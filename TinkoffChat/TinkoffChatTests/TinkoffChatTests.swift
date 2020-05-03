//
//  TinkoffChatTests.swift
//  TinkoffChatTests
//
//  Created by Элла Чурсина on 13.02.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import XCTest
@testable import TinkoffChat

class TinkoffChatTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

final class ChannelsSorterTests: XCTestCase {
    
    private var channelsSorter: IChannelsSorter!
    
    // MARK: -Lifecycle
    
    override func setUp() {
        self.channelsSorter = ChannelsSorter()
    }
    
    // MARK: -Tests
    
    func testThatChannelsSorterReturnsSortedByDate() {
        //Given
        let firstChannel = Channel(identifier: "1", name: "SomeChannel1", lastMessage: "SomeMessage", lastActivity: Date(timeIntervalSinceNow: -800))
        let secondChannel = Channel(identifier: "2", name: "SomeChannel2", lastMessage: "SomeMessage", lastActivity: Date(timeIntervalSinceNow: -700))
        let thirdChannel = Channel(identifier: "3", name: "SomeChannel3", lastMessage: "SomeMessage", lastActivity: Date(timeIntervalSinceNow: -1400))
        
        let expectedResult = [secondChannel, firstChannel, thirdChannel]
        
        let unsorted  = [firstChannel, secondChannel, thirdChannel]
        
        let result = channelsSorter.sort(unsorted, isActive: false)
    
        XCTAssertEqual(expectedResult, result)
    }
    
    func testThatChannelsSorterReturnsSortedByActiveState() {
        //Given
        let firstChannel = Channel(identifier: "1", name: "SomeChannel1", lastMessage: "SomeMessage", lastActivity: Date(timeIntervalSinceNow: -300))
        let secondChannel = Channel(identifier: "2", name: "SomeChannel2", lastMessage: "SomeMessage", lastActivity: Date())
        let thirdChannel = Channel(identifier: "3", name: "SomeChannel3", lastMessage: "SomeMessage", lastActivity: Date(timeIntervalSinceNow: -700))
        
        let expectedResult = [secondChannel, firstChannel]
        
        let unsorted  = [firstChannel, secondChannel, thirdChannel]
        
        let result = channelsSorter.sort(unsorted, isActive: true)
    
        XCTAssertEqual(expectedResult, result)
    }
}
