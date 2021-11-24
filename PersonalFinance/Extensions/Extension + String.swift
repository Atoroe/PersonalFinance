import Foundation

extension String {
    func matches(_ regex: String) -> Bool {
        self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    var digits: String {
            return components(separatedBy: CharacterSet.decimalDigits.inverted)
                .joined()
        }
}

