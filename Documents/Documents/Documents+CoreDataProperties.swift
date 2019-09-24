//
//  Documents+CoreDataProperties.swift
//  Documents
//
//  Created by Cassidy Pelchat on 9/19/19.
//  Copyright © 2019 Cassidy Pelchat. All rights reserved.
//

import Foundation
import CoreData


extension Documents {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Documents> {
        return NSFetchRequest<Documents>(entityName: "Documents")
    }

    @NSManaged public var name: String?
    @NSManaged public var content: String?
    @NSManaged public var size: Double
    @NSManaged public var modified: NSDate?

}

