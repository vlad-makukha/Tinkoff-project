//
//  TinkoffChatTests.swift
//  TinkoffChatTests
//
//  Created by Владислав Макуха on 09.12.2021.
//

import XCTest
@testable import Tinkoff_Chat

class TinkoffChatTests: XCTestCase {

    func testCoreDataServiceSaveChannels() throws {
        
        // Given
        let channels: [Channel] = [
            Channel(identifier: "123", name: "VladM", lastMessage: nil, lastActivity: nil),
            Channel(identifier: "321", name: "MVlad", lastMessage: "thanks", lastActivity: Date())
        ]
        
        // When
        CoreDataServiceMock.shared.saveChannels(channels: channels)
        
        // Then
        XCTAssertEqual(CoreDataServiceMock.shared.saveChannelsCount, 1)
        XCTAssertEqual(CoreDataServiceMock.shared.saveChannels, [channels])
    }
    
    func testPicturesManagerLoadPicuresLinks() throws {
        
        // Given
        let picturesManager = PicturesServiceMock(requestSender: RequestSender())
        
        // When
        picturesManager.loadPicuresLinks { _, _ in }
        
        // Then
        XCTAssertEqual(picturesManager.loadPicuresLinksCount, 1)
    }
    
    func testPicturesManagerLoadPicture() throws {
        
        // Given
        let url = URL(string: "https://apple.com/")!
        let picturesManager = PicturesServiceMock(requestSender: RequestSender())
        
        // When
        picturesManager.loadPictureStub = { _ in }
        picturesManager.loadPicture(from: url) { _, _ in }
        
        // Then
        XCTAssertEqual(picturesManager.loadPictureCount, 1)
        XCTAssertEqual(picturesManager.recivedURLs, [url])
    }
    
    func testNetworkRequestSender() throws {
        
        // Given
        let url = URL(string: "https://apple.com/")!
        let requestSenderMock = RequestSenderMock()
        let pictureManager = PicturesManager(requestSender: requestSenderMock)
        
        // When
        pictureManager.loadPicture(from: url) { _, _ in }
        
        // Then
        XCTAssertEqual(requestSenderMock.sendCount, 1)
        XCTAssertEqual(requestSenderMock.urlRequests.first?.url, url)
    }

}
