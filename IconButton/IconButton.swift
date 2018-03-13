//
//  IconButton.swift
//  DemoBundleFramework
//
//  Created by zhuxuhong on 2018/3/12.
//  Copyright © 2018年 GuessMe. All rights reserved.
//

import UIKit

public final class IconButtonItem: UIView{
	public enum Position: UInt {
		case left = 0, right = 1, top = 2, bottom = 3
	}
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var iconImageView: UIImageView!
	
	
	public override func awakeFromNib() {
		super.awakeFromNib()
		
		backgroundColor = .clear
	}
	
	static func item(withFrame frame: CGRect = .zero,
	                   icon: UIImage?,
	                   title: String?,
	                   iconPosition position: Position) -> IconButtonItem{
		guard
			let path = Bundle.main.path(forResource: "Frameworks/IconButton.framework/IconButtonBundle", ofType: "bundle"),
			let bundle = Bundle(path: path),
			let xibs = bundle.loadNibNamed("IconButton", owner: nil, options: nil),
			let button = xibs[Int(position.rawValue)] as? IconButtonItem else{
			return IconButtonItem()
		}
		button.frame = frame
		button.titleLabel.text = title
		button.iconImageView.image = icon
		return button
	}
}

@IBDesignable
public final class IconButton: UIView {
	
// MARK: - IBOutlets
	@IBInspectable
	public var iconPosition: UInt = 0{
		didSet{
			iconPosition = iconPosition > 3 ? 3 : iconPosition
			makeButtonItem()
		}
	}
	@IBInspectable
	public var iconImage: UIImage? = nil{
		didSet{
			item.iconImageView.image = iconImage
		}
	}
	@IBInspectable
	public var title: String? = nil{
		didSet{
			item.titleLabel.text = title
		}
	}
	
	private var item: IconButtonItem!
	
// MARK: - Properties
	
// MARK: - Initial Method
	private func setupUI() {
		item.titleLabel.text = title
		item.iconImageView.image = iconImage
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		makeButtonItem()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		makeButtonItem()
	}
 
// MARK: - Lifecycle Method
	override public func awakeFromNib() {
		super.awakeFromNib()		
		setupUI()
	}
	
// MARK: - Action & IBOutletAction
	
// MARK: - Override Method
	
// MARK: - Private method
	private func makeButtonItem(){
		item?.removeFromSuperview()
		item = IconButtonItem.item(withFrame: bounds, icon: iconImage, title: title, iconPosition: IconButtonItem.Position(rawValue: iconPosition)!)
		item.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		addSubview(item)
	}

// MARK: - Public Method
}
