//
//  SNProject+CoreDataClass.swift
//  shonichi
//
//  Created by 黄彦璋 on 2020/8/14.
//  Copyright © 2020 seiya studio. All rights reserved.
//
//

import Foundation
import CoreData

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
    
}

enum DecoderConfigurationError: Error {
  case missingManagedObjectContext
}

public class SNProject: NSManagedObject, Codable {

    enum CodingKeys: CodingKey {
        case createdTime, dancerName, id, modifiedTime, aggregatesFormation, aggregatesStoryboard, aggregatesSong
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.createdTime = try container.decode(Date.self, forKey: .createdTime)
        self.dancerName = try container.decode(String.self, forKey: .dancerName)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.modifiedTime = try container.decode(Date.self, forKey: .modifiedTime)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(createdTime, forKey: .createdTime)
        try container.encode(dancerName, forKey: .dancerName)
        try container.encode(id, forKey: .id)
        try container.encode(modifiedTime, forKey: .modifiedTime)
    }
    
}
