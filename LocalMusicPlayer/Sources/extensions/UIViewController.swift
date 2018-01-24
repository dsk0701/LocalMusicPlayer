import UIKit

extension UIViewController {

    var navCon: NavigationController? {
        if let nc = navigationController as? NavigationController {
            return nc
        }
        return nil
    }
}
