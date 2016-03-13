//
//  WHMResellerObjects.swift
//  WHM Mobile Manager
//
//  Created by Keith Duvall on 1/15/16.
//  Copyright © 2016 Duvalltech. All rights reserved.
//

import Foundation
import RealmSwift

class ResellerAccountUsage: Object {
	dynamic var cpAccount: CPanelAccount?
	dynamic var timestamp: NSDate?
	
	dynamic var user: String = ""
	
	dynamic var bwLimit: Int = 0
	dynamic var diskLimit: Int = 0
	
	dynamic var bwUsed: Int = 0
	dynamic var diskUsed: Int = 0
	
	dynamic var bwAllocated: Int = 0
	dynamic var diskAllocated: Int = 0
	
	dynamic var diskOverselling: Bool = false
	dynamic var bwOverselling: Bool = false
	
	let accountsLimit = RealmOptional<Int>()
	let accounts = List<CPanelAccount>()
	
}

