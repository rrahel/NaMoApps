//
//  Compass_meTest.swift
//  Compass.meTest
//
//  Created by Kogler Christian on 20.01.18.
//  Copyright © 2018 Cemi Rrahel. All rights reserved.
//

import XCTest
@testable import Compass_me

class Compass_meTest: XCTestCase {
    
    var locationAdjuster : LocationAdjuster? = nil
    var myLat = CGFloat(100.0)
    var myLng = CGFloat(100.0)
    var myHeading = (0.0)
    
    var friendLat = CGFloat(200.0)
    var friendLng = CGFloat(200.0)
    var friendHeading = (0.0)
    
    override func setUp() {
        super.setUp()
        locationAdjuster = LocationAdjuster(findFriend: FindFriend())
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let friendLocation = LocationAdjuster.FriendLocation(currentLocation: LocationAdjuster.GeographicCoordinates(longitude: friendLng, latitude: friendLat), heading: 0.0)
        let myLocation = LocationAdjuster.FriendLocation(currentLocation: LocationAdjuster.GeographicCoordinates(longitude: myLng, latitude: myLat), heading: 0.0)
        let distance = locationAdjuster!.calculateDistance(myLocation: myLocation, friendLocation: friendLocation)
        XCTAssert(distance != 0.0)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
