import UIKit

extension UIFont {
	class func bubblegumSansRegular(size: CGFloat) -> UIFont {
	  return UIFont(name: "BubblegumSans-Regular", size: size) ?? .systemFont(ofSize: size)
	}
}
