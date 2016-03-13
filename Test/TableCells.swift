
import UIKit

// MARK: - Base UITableViewCell Subclass
/**
Base class for custom UITableViewCells
*/
@IBDesignable
class CustomCellBase: UITableViewCell {
	
	var indexPath: NSIndexPath?
	
	@IBInspectable var selectedBackgroundColor: UIColor = UIColor ( red: 0.0, green: 0.0, blue: 1.0, alpha: 0.5 ).colorWithAlphaComponent(0.5) {
		didSet { makeSelectedView() }
	}
	
	var selectedBgView: UIView?
	var setupComplete = false
	
	override func awakeFromNib() {
		super.awakeFromNib()
		commonInit()
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		commonInit()
	}
	
	func commonInit() {
		// MARK: - Full Width Separators
		preservesSuperviewLayoutMargins = false
		separatorInset = UIEdgeInsetsZero
		layoutMargins = UIEdgeInsetsZero
		
		// MARK: - Accessory Type
		accessoryType = .None
		
		// MARK: - Selection Styles
		if selectedBgView == nil { makeSelectedView() }
		selectionStyle = UITableViewCellSelectionStyle.Default
		selectedBackgroundView = selectedBgView
	}
	func addDisclosure() {
		accessoryType = .DisclosureIndicator
	}
	func removeDisclosure() {
		accessoryType = .None
	}
	private func makeSelectedView() {
		selectedBgView = UIView()
		selectedBgView?.frame = contentView.bounds
		selectedBgView?.backgroundColor = selectedBackgroundColor
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}
}

// MARK: - Title
/**
Cell with (sub)title
*/
class CellWithTitle: CustomCellBase {
	@IBOutlet var title: UILabel?
	@IBOutlet var subTitle: UILabel?
}
