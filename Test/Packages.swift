//
//  PackageObjects.swift
//  WHM Mobile Manager
//
//  Created by Keith Duvall on 1/12/16.
//  Copyright © 2016 Duvalltech. All rights reserved.
//

import Foundation
import RealmSwift

class Package: Object {
	dynamic var account: Account?
	dynamic var timestamp: NSDate?
	
	var cpAccounts: [CPanelAccount] {
		return linkingObjects(CPanelAccount.self, forProperty: "package")
	}
	
	dynamic var name: String = ""
	dynamic var featureList: FeatureList?
	dynamic var theme: String = ""
	dynamic var language: String = ""
	
	dynamic var bwLimit: Int = 0
	dynamic var diskLimit: Int = 0
	
	dynamic var allowCgi: Bool = false
	dynamic var allowShell: Bool = false
	dynamic var allowDigestAuth: Bool = false
	dynamic var dedicatedIp: Bool = false
	dynamic var allowFrontpage: Bool = false
	
	dynamic var packageExtensions: String?
	
	let maxOutboundEmail				= RealmOptional<Int>()
	let maxOutboundEmailFailedPercent	= RealmOptional<Int>()
	
	let maxAddonDomains		= RealmOptional<Int>()
	let maxFtpAccounts		= RealmOptional<Int>()
	let maxEmailLists		= RealmOptional<Int>()
	let maxParkedDomains	= RealmOptional<Int>()
	let maxPopAccounts		= RealmOptional<Int>()
	let maxDatabases		= RealmOptional<Int>()
	let maxSubDomains		= RealmOptional<Int>()
	
	override static func indexedProperties() -> [String] {
		return ["timestamp", "name", "bwLimit", "diskLimit"]
	}
}

class FeatureList: Object {
	dynamic var account: Account?
	var packages: [Package] {
		return linkingObjects(Package.self, forProperty: "featureList")
	}
	dynamic var timestamp: NSDate?
	
	dynamic var name: String = ""
	let features = List<Feature>()
	
	override static func indexedProperties() -> [String] {
		return ["timestamp", "name"]
	}
}

class Feature: Object {
	dynamic var account: Account?
	dynamic var featureList: FeatureList?
	dynamic var timestamp: NSDate?
	
	dynamic var name: String  = ""
	dynamic var displayName: String  = ""
	
	dynamic var disabled: Bool = false
	dynamic var on: Bool = false
}

