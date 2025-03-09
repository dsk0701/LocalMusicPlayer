import UIKit

extension UIImage {
    func getAverageColor(withAlpha alpha: CGFloat = 1.0) -> UIColor {
        // Work within the RGB colorspace
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var rgba = [UInt8](repeating: 0, count: 4)
        let context = CGContext(data: &rgba, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)

        // Draw our image down to 1x1 pixels
        context?.draw(cgImage!, in: CGRect(x: 0, y: 0, width: 1, height: 1))

        // Check if image alpha is 0
        if rgba[3] == 0 {
            let imageAlpha = CGFloat(rgba[3]) / 255.0
            let multiplier = imageAlpha / 255.0

            var averageColor = UIColor(red: CGFloat(rgba[0]) * multiplier / 255.0,
                                       green: CGFloat(rgba[1]) * multiplier / 255.0,
                                       blue: CGFloat(rgba[2]) * multiplier / 255.0,
                                       alpha: imageAlpha)

            // Improve color
            averageColor = averageColor.colorWithMinimumSaturation(0.15)

            // Return average color
            return averageColor
        } else {
            // Get average
            var averageColor = UIColor(red: CGFloat(rgba[0]) / 255.0,
                                       green: CGFloat(rgba[1]) / 255.0,
                                       blue: CGFloat(rgba[2]) / 255.0,
                                       alpha: alpha)

            // Improve color
            averageColor = averageColor.colorWithMinimumSaturation(0.15)

            // Return average color
            return averageColor
        }
    }

    func getMostUsedColor() -> UIColor? {
        let sortedColors = getColorsSortedByFrequency()
        return sortedColors.isEmpty ? nil : sortedColors[0]
    }

    func getBrandColor() -> UIColor? {
        let sortedColors = getColorsSortedByFrequency()
        // 「ベースカラー（70％）」「メインカラー（25％）」「アクセントカラー（5％）」
        let brandColorIndex = lround(Double(sortedColors.count) * (80.0 / 100.0))
        return sortedColors.count > brandColorIndex ? sortedColors[brandColorIndex] : nil
    }

    func getColorsSortedByFrequency() -> [UIColor] {
        guard let cgImage = cgImage else { return [] }

        let width = cgImage.width
        let height = cgImage.height

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue

        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: colorSpace, bitmapInfo: bitmapInfo) else { return [] }

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        guard let pixelData = context.data else { return [] }

        var colorFrequency: [UIColor: Int] = [:]

        for y in 0 ..< height {
            for x in 0 ..< width {
                let offset = (y * width + x) * 4
                let red = CGFloat(pixelData.load(fromByteOffset: offset, as: UInt8.self)) / 255.0
                let green = CGFloat(pixelData.load(fromByteOffset: offset + 1, as: UInt8.self)) / 255.0
                let blue = CGFloat(pixelData.load(fromByteOffset: offset + 2, as: UInt8.self)) / 255.0
                let alpha = CGFloat(pixelData.load(fromByteOffset: offset + 3, as: UInt8.self)) / 255.0

                let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
                colorFrequency[color, default: 0] += 1
            }
        }

        let sortedColors = colorFrequency.sorted { $0.value > $1.value }
        return sortedColors.isEmpty ? [] : sortedColors.map { $0.key }
    }
}
