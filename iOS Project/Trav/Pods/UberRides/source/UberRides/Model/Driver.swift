//
//  Driver.swift
//  UberRides
//
//  Copyright © 2016 Uber Technologies, Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

// MARK: Driver

/**
 *  Contains information for an Uber driver dispatched for a ride request.
 */
@objc(UBSDKDriver) public class Driver: NSObject, Codable {
    
    /// The first name of the driver.
    @objc public private(set) var name: String
    
    /// The URL to the photo of the driver.
    @objc public private(set) var pictureURL: URL

    /// The formatted phone number for calling the driver.
    @objc public private(set) var phoneNumber: String

    /// The formatted phone number for sending a SMS to the driver.
    @objc public private(set) var smsNumber: String?
    
    /// The driver's star rating out of 5 stars.
    @objc public private(set) var rating: Double

    enum CodingKeys: String, CodingKey {
        case name        = "name"
        case pictureURL  = "picture_url"
        case phoneNumber = "phone_number"
        case smsNumber   = "sms_number"
        case rating      = "rating"
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        pictureURL = try container.decode(URL.self, forKey: .pictureURL)
        phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        smsNumber = try container.decodeIfPresent(String.self, forKey: .smsNumber)
        rating = try container.decode(Double.self, forKey: .rating)
    }
}
