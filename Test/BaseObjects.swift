//
//  BaseObjects.swift
//  WHM Mobile Manager
//
//  Created by Keith Duvall on 10/26/15.
//  Copyright © 2015 Duvalltech. All rights reserved.
//

import RealmSwift

// MARK: - Preferences
class Preference: Object {
	dynamic var key: String = ""
	
	dynamic var string: String?
	dynamic var date: NSDate?
	dynamic var data: NSData?
	let bool = RealmOptional<Bool>()
	let int = RealmOptional<Int>()
	let double = RealmOptional<Double>()
	let float = RealmOptional<Float>()
	
	override static func primaryKey() -> String? {
		return "key"
	}
}

// MARK: - Error Log Object
class ErrorLogEntry: Object {
	dynamic var timestamp	: NSDate	= NSDate()
	dynamic var fileName	: String	= ""
	dynamic var lineNumber	: Int		= -1
	dynamic var errorDesc	: String	= ""
	dynamic var errorCode	: String	= ""
	
	dynamic var accountName	: String	= ""
	dynamic var command		: String	= ""
	dynamic var params		: String	= ""
	dynamic var whmVersion	: String	= ""
	dynamic var apiVersion	: String	= ""
	
	override static func indexedProperties() -> [String] {
		return ["timestamp", "fileName", "lineNumber", "accountName", "name", "whmVersion", "apiVersion"]
	}
}

// MARK: - Privilege Metadata Object
class PrivilegeMeta: Object {
	dynamic var name		: String = ""
	dynamic var desc		: String?
	dynamic var longDesc	: String?
	dynamic var whmPath		: String?
	dynamic var timestamp	: NSDate = NSDate()
	
	var commands: [Command] {
		return linkingObjects(Command.self, forProperty: "privilege")
	}
	override static func primaryKey() -> String? {
		return "name"
	}
	override static func indexedProperties() -> [String] {
		return ["timestamp"]
	}
}

// MARK: - WHM Command Object
class Command: Object {
	dynamic var name: String = ""
	dynamic var privilege: PrivilegeMeta?
	dynamic var minVersion: String?
	dynamic var maxVersion: String?
	dynamic var timestamp: NSDate?
	
	override static func primaryKey() -> String? {
		return "name"
	}
	override static func indexedProperties() -> [String] {
		return ["timestamp", "minVersion", "maxVersion"]
	}
}

// MARK: - Command Log Object
class CommandLog: Object {
	dynamic var cmdString: String = ""
	dynamic var apiVersion: String = ""
	dynamic var whmVersion: String = ""
	dynamic var result: Bool = false
	dynamic var reason: String = ""
	dynamic var account: Account?
	dynamic var timestamp: NSDate?
	
	override static func indexedProperties() -> [String] {
		return ["cmdString", "apiVersion", "whmVersion", "result", "timestamp"]
	}
}

// MARK: - Preference object model accessor methods
class Prefs {
	var realm: Realm!
	init() throws {
		realm = try Realm()
	}
	
	func serverTimeout(timeout: Int? = nil) throws -> Int {
		let defaultValue = 15
		if let timeout = timeout {
			
			let pref = Preference()
			pref.key = "serverTimeout"
			pref.int.value = timeout
			
			try realm.write {
				self.realm.add(pref, update: true)
			}
			return timeout
		}
		else {
			return realm.objectForPrimaryKey(Preference.self, key: "serverTimeout")?.int.value ?? defaultValue
		}
	}
	func pollingInterval(interval: Int? = nil) throws -> Int {
		let defaultValue = 3
		if let interval = interval {

			let pref = Preference()
			pref.key = "pollingInterval"
			pref.int.value = interval
			
			try realm.write {
				self.realm.add(pref, update: true)
			}
			return interval
		}
		else {
			return realm.objectForPrimaryKey(Preference.self, key: "pollingInterval")?.int.value ?? defaultValue
		}
	}
	func pollingEnabled(enabled: Bool? = nil) throws -> Bool {
		let defaultValue = false
		if let enabled = enabled {
			
			let pref = Preference()
			pref.key = "pollingEnabled"
			pref.bool.value = enabled
			
			try realm.write {
				self.realm.add(pref, update: true)
			}
			return enabled
		}
		else {
			return realm.objectForPrimaryKey(Preference.self, key: "pollingEnabled")?.bool.value ?? defaultValue
		}
	}
	func allowSelfSignedCertificates(allow: Bool? = nil) throws -> Bool {
		let defaultValue = true
		if let allow = allow {
			
			let pref = Preference()
			pref.key = "allowSelfSignedCertificates"
			pref.bool.value = allow
			
			try realm.write {
				self.realm.add(pref, update: true)
			}
			return allow
		}
		else {
			return
				realm.objectForPrimaryKey(Preference.self, key: "allowSelfSignedCertificates")?.bool.value
					?? defaultValue
		}
	}
}


