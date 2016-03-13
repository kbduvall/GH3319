
import UIKit
import RealmSwift

class ViewController: UIViewController {
	@IBOutlet var tableView: UITableView!
	@IBOutlet var label: UILabel!
	
	var delegate = TableViewDelegate()
	var dataSource: TableViewDataSource<Service>!

	var realm: Realm?
	var goodAccount: Account!
	var badAccount: Account!
	var services: Results<Service>!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		realm = try? Realm()
		
		goodAccount = realm?.objects(Account.self).filter("hostname = 'good'").first
		badAccount = realm?.objects(Account.self).filter("hostname = 'bad'").first

		services = goodAccount.server!.services.sorted("displayName")
		label.text = goodAccount.hostname
		
		setupTable()
	}

	@IBAction func showGood(sender: AnyObject) {
		refreshTable(goodAccount)
	}
	
	@IBAction func showBad(sender: AnyObject) {
		refreshTable(badAccount)
	}
	
	func setupTable() {
		dataSource = TableViewDataSource(data: services, reuseIdentifier: "CellWithTitle") { cell, item in
			if let cell = cell as? CellWithTitle, service = item as? Service {
				cell.title?.text = service.displayName
				cell.subTitle?.text = service.name
			}
		}
		dataSource.useIndex = true
		dataSource.indexKey = "displayName"
		
		tableView.dataSource = dataSource
		tableView.delegate = delegate
	}
	
	func refreshTable(account: Account) {
		services = account.server!.services.sorted("displayName")
		label.text = account.hostname
		dataSource.data = services
		tableView.reloadData()
	}
	
}

