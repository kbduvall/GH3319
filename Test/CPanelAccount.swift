//
//  CPanelAccountObjects.swift
//  WHM Mobile Manager
//
//  Created by Keith Duvall on 1/2/16.
//  Copyright © 2016 Duvalltech. All rights reserved.
//

import RealmSwift

class CPanelAccount: Object {
	dynamic var user			: String = ""
	dynamic var domain			: String = ""
	
	dynamic var account: Account?
	dynamic var server: Server?
	dynamic var timestamp: NSDate?
	
	dynamic var owner			: String = ""
	dynamic var email			: String = ""
	
	dynamic var ip				: String = ""
	
	dynamic var isReseller		: Bool = false
	dynamic var resellerUsage	: ResellerAccountUsage?
	
	dynamic var partition		: String?
	dynamic var package			: Package?
	dynamic var shell			: String?
	dynamic var theme			: String?
	dynamic var created			: NSDate?
	
	dynamic var backupRaw: Int = -1
	
	dynamic var locked			: Bool = false
	dynamic var suspended		: Bool = false
	dynamic var suspendReason	: String?
	dynamic var suspendTime		: NSDate?
	
	dynamic var bwLimit			: Int = 0
	dynamic var bwUsed			: Int = 0
	
	dynamic var diskLimit			: Int = 0
	dynamic var diskUsed			: Int = 0
	dynamic var diskUsageOverview	: CPanelAccountDiskUsageOverview?
	
	let maxOutboundEmail				= RealmOptional<Int>()
	let maxOutboundEmailFailedPercent	= RealmOptional<Int>()
	let minOutboundEmailFailedMessages	= RealmOptional<Int>()
	
	let maxAddonDomains					= RealmOptional<Int>()
	let maxFtpAccounts					= RealmOptional<Int>()
	let maxEmailLists					= RealmOptional<Int>()
	let maxParkedDomains				= RealmOptional<Int>()
	let maxPopAccounts					= RealmOptional<Int>()
	let maxDatabases					= RealmOptional<Int>()
	let maxSubDomains					= RealmOptional<Int>()
	
	let domains = List<CPanelDomain>()
	
	var backup: Backup {
		get {
			return Backup(rawValue: backupRaw) ?? .Unknown
		}
		set {
			backupRaw = newValue.rawValue
		}
	}
	enum Backup: Int {
		case Unknown = -1
		case Off
		case On
		case Legacy
	}
	
	override static func indexedProperties() -> [String] {
		return ["timestamp", "user", "domain", "owner", "bwUsed", "diskUsed", "ip", "isReseller", "created", "suspended", "suspendTime"]
	}
	
	func deleteChildren() {
		do {
			let realm = try Realm()
			let useLocalTransaction = !realm.inWriteTransaction
			
			if useLocalTransaction { realm.beginWrite() }
			
			if let rUsage = resellerUsage {
				realm.delete(rUsage)
			}
			if let dUsage = diskUsageOverview {
				realm.delete(realm.objects(CPanelAccountFolder).filter("account == %@", self))
				realm.delete(dUsage)
			}
			realm.delete(domains)
			
			if useLocalTransaction { try realm.commitWrite() }
		}
		catch let error as NSError {
			print(error.localizedDescription)
		}
	}
}

class CPanelAccountDiskUsageOverview: Object {
	dynamic var account: CPanelAccount?
	dynamic var timestamp: NSDate?
	
	var totalUsed: Int {
		return fileUsage + mysql + pgsql + mailman + mailarchives
	}
	
	dynamic var quota: Int = 0
	
	dynamic var fileUsage: Int = 0
	dynamic var homeFolder: CPanelAccountFolder?
	
	dynamic var mysql: Int = 0
	dynamic var pgsql: Int = 0
	
	var mail: Int { return homeFolder?.children.filter("name == 'mail'").first?.containedUsage ?? 0 }
	dynamic var mailman: Int = 0
	dynamic var mailarchives: Int = 0
	
	override static func indexedProperties() -> [String] {
		return ["timestamp", "quota", "fileUsage", "mysql", "pgsql"]
	}
}

class CPanelAccountFolder: Object {
	dynamic var cPanelAccount: CPanelAccount?
	dynamic var parent: CPanelAccountFolder?
	
	dynamic var timestamp: NSDate?
	
	dynamic var name: String = ""
	dynamic var owner: String = ""
	
	dynamic var usage: Int = 0
	dynamic var containedUsage: Int = 0
	
	dynamic var contents: Int = -1
	
	let children = List<CPanelAccountFolder>()
	var childCount: Int {
		return (contents < 0) ? children.count : contents
	}
	
	override static func indexedProperties() -> [String] {
		return ["timestamp", "name", "owner", "usage", "containedUsage", "contents"]
	}
}

class CPanelDomain: Object {
	dynamic var cPanelAccount: CPanelAccount?
	dynamic var timestamp: NSDate?
	
	dynamic var name: String = ""
	dynamic var mainDomain: Bool = false
	dynamic var deleted: Bool = false
	dynamic var bwUsed: Int = 0
	
	override static func indexedProperties() -> [String] {
		return ["timestamp", "domainName", "mainDomain", "deleted", "bwUsed"]
	}
}


