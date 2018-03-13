### 要求
- Xcode 8.3+
- Swift 3.2
- iOS 9.0+

### 分析
- .framework可以是静态库也可以是动态库，主要封装了代码文件。
- .bundle文件中主要存放framework用到的资源文件，如.storyboard、.xib、.png和音视频等。

### 实例
> 以封装一个IconButton自定义控件为例

- 新建一个空白工程，取名为`DemoBundleFramework`
![新建一个工程](https://upload-images.jianshu.io/upload_images/1334681-8389fd612a1015e2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 新建一个Framework的新Target，命名为`IconButton`
![新建一个Framework](https://upload-images.jianshu.io/upload_images/1334681-ffb1d19d8f7b8611.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 新建一个Bundle的新Target，命名为`IconButtonBundle`
![新建一个Bundle](https://upload-images.jianshu.io/upload_images/1334681-40d4cc312f6b490b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**注意：这个Bundle中主要存放Framework中的xib等资源文件。**

- 创建完成的工程目录结构如下：
![工程目录结构](https://upload-images.jianshu.io/upload_images/1334681-53e6b040308694da.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)

- 将Framework的最低系统版本改为9.0，因为稍后会用到xib布局里的StackView
![系统版本改为9.0](https://upload-images.jianshu.io/upload_images/1334681-c159515447052891.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 创建IconButton.swift和IconButton.xib

![将swift文件放入IconButton文件夹下](https://upload-images.jianshu.io/upload_images/1334681-ce4e1d4671f28584.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![将xib文件放入IconButtonBundle文件夹下](https://upload-images.jianshu.io/upload_images/1334681-24ceebfab7d33173.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- IconButton.xib实现
![里边放置了4个UIView控件，稍后用到](https://upload-images.jianshu.io/upload_images/1334681-b056e58f1d171f59.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- IconButton.swift实现
```
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
```
**当然，本文重点要演示的是如何在.framework中打包.bundle文件，所以以上IconButton实现代码不做解释，相信读者很容易理解。**

- 下面演示如何将.bundle打包到.framework中，并在代码中正确调用

![编译IconButtonBundle](https://upload-images.jianshu.io/upload_images/1334681-35e0965a82a840e9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![编译成功会生成IconButtonBundle.bundle文件](https://upload-images.jianshu.io/upload_images/1334681-e8a92797466951c7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/400)

![Debug](https://upload-images.jianshu.io/upload_images/1334681-a0c7696046546a54.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 将Products下生成的.bundle拖入工程并连接到IconButton的target中
![注意选择Create folder refrences](https://upload-images.jianshu.io/upload_images/1334681-ae308605a6ebd452.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![这样每次改动重新编译生成.bundle，都会被自动引入到framework中](https://upload-images.jianshu.io/upload_images/1334681-2a431d6490b21a71.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 下面重点说说.bundle的使用
大家都知道，.bundle中放了我们要用到.xib和.png等资源文件，但如何正确加载它们呢？
```
// 先拿到.bundle文件在被使用工程中的实际位置，
// 一般是在Bundle.main（使用者工程路径）下的Frameworks文件夹下的xxx.framwork下
let path = Bundle.main.path(forResource: "Frameworks/IconButton.framework/IconButtonBundle", ofType: "bundle")

// 创建资源bundle实例对象
let bundle = Bundle(path: path)

// 加载nib文件（一个xib文件中可能有多个nib文件）
let xibs = bundle.loadNibNamed("IconButton", owner: nil, options: nil)

// 根据传入的position值，加载对应的nib控件
let button = xibs[Int(position.rawValue)] as? IconButtonItem
```

- 上面是如何加载并使用.xib文件，下面演示如何使用.png文件
```
UIImage(named: "xxx", in: bundle, compatibleWith: nil)
```

- 上述工作准备完成后，选择IconButton，编译生成IconButton.framework
![编译生成含有bundle文件的framework](https://upload-images.jianshu.io/upload_images/1334681-e1710936294c1319.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/400)

- 在Demo工程中使用framework

![将IconButton.framework加入工程中](https://upload-images.jianshu.io/upload_images/1334681-7e5b59b6e84fca2b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![在Storyboard上使用](https://upload-images.jianshu.io/upload_images/1334681-76cd466c6fc8ac94.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![可视化的配置属性](https://upload-images.jianshu.io/upload_images/1334681-c4d9d4e19ffc0f70.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 代码中验证
```
class ViewController: UIViewController {
	@IBOutlet weak var iconButton: IconButton!

	@IBAction func positionChanged(_ sender: UISegmentedControl) {
		iconButton.iconPosition = UInt(sender.selectedSegmentIndex)
	}
}
```
![最终效果](https://upload-images.jianshu.io/upload_images/1334681-bc393f9c0ca56d70.gif?imageMogr2/auto-orient/strip)

**说明：当然，你可以手动替换.framework中的.bundle文件中的图片等资源，这里不做演示了。**

- 最终你的.framework和.bundle文件所在的目录（被打包到app中）
![最终目录](https://upload-images.jianshu.io/upload_images/1334681-efe616b7c72aa654.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)

![.bundle中内容](https://upload-images.jianshu.io/upload_images/1334681-5bfbabd4c94cde30.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/400)

> 以上就是简单演示了如何生成并使用一个含有bundle文件的framework，如果对你有帮助，欢迎加关注和点赞👍~

### Carthage
- 如果你的framework要支持carthage自动编译，就得在工程中做如下设置

![Manage Schemes](https://upload-images.jianshu.io/upload_images/1334681-98e6a76057a37920.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![勾选shared](https://upload-images.jianshu.io/upload_images/1334681-c5ed90b36c4f337a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
- 编译
```
cd 工程目录
carthage build --no-skip-current
```
![编译成功](https://upload-images.jianshu.io/upload_images/1334681-9cc29827bfb40604.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

> 关于更多Carthage，可以参考我这篇文章https://www.jianshu.com/p/76b9ff09f99c

### 简书
> https://www.jianshu.com/p/ad07419980c7
