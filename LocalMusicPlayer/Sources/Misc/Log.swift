import Foundation

final class Log {

    enum Level: Int, CustomStringConvertible {
        case debug
        case info
        case warning
        case error

        public var description: String {
            switch self {
            case .debug:
                return "Debug"
            case .info:
                return "Info"
            case .warning:
                return "Warning"
            case .error:
                return "Error"
            }
        }
    }

    class func d(_ message: Any = "", function: StaticString = #function, file: StaticString = #file, line: Int = #line) {
        outputLog(level: .debug, "\(message)", functionName:  function, fileName: file, lineNumber: line)
    }

    class func i(_ message: Any = "", function: StaticString = #function, file: StaticString = #file, line: Int = #line) {
        outputLog(level: .info, "\(message)", functionName:  function, fileName: file, lineNumber: line)
    }

    class func w(_ message: Any = "", function: StaticString = #function, file: StaticString = #file, line: Int = #line) {
        outputLog(level: .warning, "\(message)", functionName:  function, fileName: file, lineNumber: line)
    }

    class func e(_ message: Any = "", function: StaticString = #function, file: StaticString = #file, line: Int = #line) {
        outputLog(level: .error, "\(message)", functionName:  function, fileName: file, lineNumber: line)
    }

    private class func outputLog(
        level: Level = .debug,
        _ message: Any = "",
        functionName: StaticString = #function,
        fileName: StaticString = #file,
        lineNumber: Int = #line
    ) {
#if DEBUG
        print("[\(level)][\((String(describing: fileName) as NSString).lastPathComponent):\(lineNumber)][\(functionName)] \(message)")
#endif
    }
}
