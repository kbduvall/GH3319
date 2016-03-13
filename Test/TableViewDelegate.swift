
import UIKit

extension UITableViewDelegate {
	func canEditRow(tableView: UITableView, indexPath: NSIndexPath) -> Bool {
		let actions = self.tableView?(tableView, editActionsForRowAtIndexPath: indexPath)
		return (actions != nil && actions!.count > 0)
	}
}

class TableViewDelegate: NSObject, UITableViewDelegate {
	
	/**
	Block to perform on row selection
	
	- parameter tableView: The UITableView instance
	- parameter indexPath: The indexPath of the selected row
	*/
	var rowSelectedAction: ((tableView: UITableView, indexPath: NSIndexPath) -> Void)?
	var rowHeightBlock: ((tableView: UITableView, indexPath: NSIndexPath) -> CGFloat)?
	
	var willDisplayCell: ((tableView: UITableView, cell: UITableViewCell, indexPath: NSIndexPath) -> Void)?
	
	/**
	Table row actions
	
	- parameter tableView: The UITableView instance
	- parameter indexPath: The indexPath of the selected row
	- returns: An array of [UITableViewRowAction] or nil
	*/
	var rowActions: ((tableView: UITableView, indexPath: NSIndexPath) -> [UITableViewRowAction]?)?
	
	func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		cell.backgroundColor = (tableView.style == .Grouped) ? UIColor.whiteColor() : UIColor.clearColor()
		willDisplayCell?(tableView: tableView, cell: cell, indexPath: indexPath)
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return rowHeightBlock?(tableView: tableView, indexPath: indexPath) ?? tableView.rowHeight
	}
	
	func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
		return (rowSelectedAction != nil) ? indexPath : nil
	}

	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if rowSelectedAction != nil {
			rowSelectedAction!(tableView: tableView, indexPath: indexPath)
		}
		
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		
	}

	func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
		if rowActions != nil {
			return rowActions!(tableView: tableView, indexPath: indexPath)
		}
		return nil
	}
}
