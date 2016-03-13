//
//  Account.swift
//  WHM Mobile Manager
//
//  Created by Keith Duvall on 2/8/16.
//  Copyright © 2016 Duvalltech. All rights reserved.
//

import RealmSwift

// MARK: - Account object model
class Account: Object {
	dynamic var hostname: String = ""
	dynamic var username: String = ""
			var password: String?
	
	dynamic var temporary: Bool = true
	dynamic var monitor: Bool = false
	
	var name: String { return "\(username)@\(hostname)" }
	
	
	dynamic var port: Int = 2087
	
	dynamic var server: Server?
	
	let privileges			= List<Privilege>()
	let commandLog			= List<CommandLog>()
	let packages			= List<Package>()
	let featureLists		= List<FeatureList>()
	
	let cPanelAccounts		= List<CPanelAccount>()
	
	dynamic var timestamp: NSDate?
	
	var totalBwUsage: Int { return cPanelAccounts.sum("bwUsed") }
	var totalDiskUsage: Int { return cPanelAccounts.sum("diskUsed") }
	
	override static func ignoredProperties() -> [String] {
		return ["password", "name"]
	}
	override static func indexedProperties() -> [String] {
		return ["timestamp", "temporary", "monitor", "username", "hostname"]
	}
}

// MARK: - WHM User Priviliges
class Privilege: Object {
	dynamic var meta	: PrivilegeMeta?
	dynamic var allowed	: Bool = false
	
	dynamic var account: Account?
	dynamic var timestamp: NSDate?
	
	override static func indexedProperties() -> [String] {
		return ["timestamp", "allowed"]
	}
}



