//
//  Server.swift
//  WHM Mobile Manager
//
//  Created by Keith Duvall on 2/8/16.
//  Copyright © 2016 Duvalltech. All rights reserved.
//

import RealmSwift

// MARK: - Server object model
class Server: Object {
	dynamic var account		: Account?
	dynamic var timestamp	: NSDate?
	
	dynamic var hostname	: String = ""
	dynamic var ip			: String = ""
	
	dynamic var cores		: Int = 2
	dynamic var whmVersion	: String?
	dynamic var	apiVersion	: String = "1.0.0.0"
	
	let disks		= List<Disk>()
	let ips			= List<IP>()
	let services	= List<Service>()
	
	let loadHistory = List<ServerLoad>()
	var load: ServerLoad? { return loadHistory.last }
	
	override static func indexedProperties() -> [String] {
		return [
			"timestamp",
			"hostname",
			"ip",
			"cores",
			"whmVersion",
			"apiVersion"
		]
	}
}

class IP: Object {
	dynamic var server		: Server?
	dynamic var timestamp	: NSDate?
	
	dynamic var ip			: String = ""
	dynamic var interface	: String = ""
	dynamic var publicip	: String = ""
	dynamic var netmask		: String = ""
	dynamic var network		: String = ""
	
	dynamic var active		: Bool = false
	dynamic var dedicated	: Bool = false
	dynamic var main		: Bool = false
	dynamic var removable	: Bool = false
	dynamic var inuse		: Bool = false
	dynamic var configured	: Bool = false
	
	override static func indexedProperties() -> [String] {
		return [
			"timestamp",
			"ip",
			"interface",
			"publicip",
			"network",
			"active",
			"dedicated",
			"main",
			"inuse"
		]
	}
}
class Disk: Object {
	dynamic var server			: Server?
	dynamic var timestamp		: NSDate?
	
	dynamic var disk			: String?
	dynamic var filesystem		: String?
	dynamic var mount			: String = ""
	
	dynamic var totalBytes		: Int = 0
	dynamic var availableBytes	: Int = 0
	dynamic var usedBytes		: Int = 0
	dynamic var usedPercent		: Int = 0
	
	override static func indexedProperties() -> [String] {
		return [
			"timestamp",
			"mount",
			"disk",
			"filesystem",
			"totalBytes",
			"availableBytes",
			"usedBytes",
			"usedPercent"
		]
	}
}

class ServerLoad: Object {
	dynamic var server		: Server?
	dynamic var timestamp	: NSDate?
	
	dynamic var one			: Double = 0.0
	dynamic var five		: Double = 0.0
	dynamic var fifteen		: Double = 0.0
	
	override static func indexedProperties() -> [String] {
		return [
			"timestamp"
		]
	}
}

class Service: Object {
	dynamic var timestamp: NSDate?
	dynamic var server: Server?
	dynamic var backgroundMonitoring = true
	
	dynamic var name: String = ""
	dynamic var displayName: String = ""
	dynamic var installed: Bool = false
	dynamic var enabled: Bool = false
	dynamic var monitored: Bool = false
	dynamic var running: Bool = false
	
	override static func indexedProperties() -> [String] {
		return [
			"timestamp",
			"backgroundMonitoring",
			"name",
			"displayName",
			"installed",
			"enabled",
			"monitored",
			"running"
		]
	}
}



