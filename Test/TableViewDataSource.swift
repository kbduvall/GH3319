

import UIKit
import RealmSwift

/**
A code block used to map a Realm `Object` to the corresponding Table Cell fields

- parameter cell: A `CustomCellBase` object to fill
- parameter item: The Realm `Object` to pull the data from
*/
typealias ItemToCellMappingBlock = (cell: CustomCellBase, item: Object) -> Void

class TableViewDataSource<O: Object>: NSObject, UITableViewDataSource {
	var data: Results<O>
	
	var sortKey: String? {
		didSet {
			if sortKey != nil {
				data = data.sorted(sortKey!, ascending: sortAsc)
			}
		}
	}
	var sortAsc: Bool = true {
		didSet {
			if sortKey != nil {
				data = data.sorted(sortKey!, ascending: sortAsc)
			}
		}
	}
	
	var identifier: String
	var mappingBlock: ItemToCellMappingBlock?
	
	var useIndex = false
	var indexKey: String?
	/**
	Initializes the datasource.
	
	 - parameter data: A `Realm` `Results<Object>` object
	 - parameter identifier: The Reuse Identifier for the table cells
	 - parameter mappingBlock: The code block used to map the values in `Object` to the fields in the table cell.
	*/
	init(data: Results<O>, reuseIdentifier identifier: String, mappingBlock: ItemToCellMappingBlock) {
		self.data = data
		self.identifier = identifier
		self.mappingBlock = mappingBlock
	}
	subscript(indexPath: NSIndexPath?) -> O? {
		get {
			guard let indexPath = indexPath else { return nil }
			return data[(useIndex) ? indexPath.section : indexPath.row]
		}
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return (useIndex && data.count > 0) ? 1 : data.count
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return (useIndex) ? data.count : 1
	}

	func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
		if !useIndex || indexKey == nil || tableView.style == .Grouped { return nil }
		
		var output: [String] = []
		var orig: [Character] = []
		
		orig = data
			.filter({
				return ($0.valueForKey(indexKey!) as? String != nil)
					&& ($0.valueForKey(indexKey!) as! String != "")
			})
			.map({
				return ($0.valueForKey(indexKey!) as! String).uppercaseString.characters.first!
			})
		
		let unique = Array(Set(orig)).sort({$0 < $1})
		
		let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
		for char in alphabet.characters {
			if let _ = unique.indexOf(char) {
				output.append(String(char))
			}
			output.append(" ")
		}
		return output
	}
	
	func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
		if !useIndex || tableView.style == .Grouped { return 0 }
		guard let indexKey = indexKey else { return 0 }
		var t = title
		var i = index

		while i-- > 0 && t == " " {
			t = sectionIndexTitlesForTableView(tableView)![i]
		}
		if i == 0 { return 0 }
		
		let predicate = NSPredicate(format: "%K BEGINSWITH[c] %@", indexKey, t)
		if let index = data.indexOf(predicate) {
			return index
		}
		
		return data.count - 1
	}
	
	func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return tableView.delegate?.canEditRow(tableView, indexPath: indexPath) ?? false
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let item = data[(useIndex) ? indexPath.section : indexPath.row]
		if let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as? CustomCellBase, mapper = mappingBlock {
			cell.indexPath = indexPath
			mapper(cell: cell, item: item)
			return cell
		}
		let cell = CustomCellBase(style: UITableViewCellStyle.Value2, reuseIdentifier: identifier)
		cell.textLabel?.text = "Unable To Load Cell Data"
		return cell
	}
}




