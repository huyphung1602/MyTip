//
//  Purchased+CoreDataProperties.swift
//  MyTip
//
//  Created by Quoc Huy on 10/3/16.
//  Copyright © 2016 Quoc Huy. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Purchased {

    @NSManaged var totalAmount: String?
    @NSManaged var paidDate: String?

}
