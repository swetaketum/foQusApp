//
//  DataClass.swift
//  foQus
//
//  Created by Swetaketu Majumder on 28.02.18.
//  Copyright © 2018 Optys Tech Corporation. All rights reserved.
//

import Foundation

struct Welcome: Codable {
    let data: WelcomeData
    let success: Bool
}

struct WelcomeData: Codable {
    let id: Int
    let experimentName, instrumentName: String
    let labID: Int
    let datafiles: [Datafile]
    
    enum CodingKeys: String, CodingKey {
        case id
        case experimentName = "experiment_name"
        case instrumentName = "instrument_name"
        case labID = "lab_id"
        case datafiles
    }
}

struct Datafile: Codable {
    let id: Int
    let date, fileName: String
    let experimentID: Int
    let createdOn: String
    let analytes: [Analyte]
    
    enum CodingKeys: String, CodingKey {
        case id, date
        case fileName = "file_name"
        case experimentID = "experiment_id"
        case createdOn = "created_on"
        case analytes
    }
}

struct Analyte: Codable {
    let id: Int
    let analyteName: String
    let rt: Double
    let auc: Int
    let normalizedAuc, fwhm: JSONNull?
    let peakWidth: Double
    let fileID: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case analyteName = "analyte_name"
        case rt, auc
        case normalizedAuc = "normalized_auc"
        case fwhm
        case peakWidth = "peak_width"
        case fileID = "file_id"
    }
}

// MARK: Convenience initializers

extension Welcome {
    init(data: Data) throws {
        self = try JSONDecoder().decode(Welcome.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension WelcomeData {
    init(data: Data) throws {
        self = try JSONDecoder().decode(WelcomeData.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Datafile {
    init(data: Data) throws {
        self = try JSONDecoder().decode(Datafile.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Analyte {
    init(data: Data) throws {
        self = try JSONDecoder().decode(Analyte.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: Encode/decode helpers

class JSONNull: Codable {
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
