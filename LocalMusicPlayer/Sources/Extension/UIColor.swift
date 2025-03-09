import UIKit

extension UIColor {
    func colorWithMinimumSaturation(_ saturation: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var currentSaturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        getHue(&hue, saturation: &currentSaturation, brightness: &brightness, alpha: &alpha)

        if currentSaturation < saturation {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
        }

        return self
    }
}
