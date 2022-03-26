//
//  RegExp.swift
//  shonichi
//
//  Created by 黄彦璋 on 2020/7/9.
//  Copyright © 2020 seiya studio. All rights reserved.
//

import Foundation


var characterNameRegExp: NSRegularExpression = NSRegularExpression("[\\u3040-\\u309F\\u30A0-\\u30FF\\u31F0-\\u31FF\\u4e00-\\u9fa5]+ [\\u3040-\\u309F\\u30A0-\\u30FF\\u31F0-\\u31FF\\u4e00-\\u9fa5]+")

var chineseCharRegExp: NSRegularExpression = NSRegularExpression("[\\u4e00-\\u9fa5]")


var simpleDurationRegExp: NSRegularExpression = NSRegularExpression("\\d:\\d\\d\\.\\d\\d\\d")

var mdTitleRegExp: NSRegularExpression =  NSRegularExpression("# \\S+\\n")

var storyboardChapterRegExp: NSRegularExpression =
    NSRegularExpression("(?<=# 分镜表\\n).+(?!# \\S+\\n)"); // dotAll: true


// https://www.hackingwithswift.com/articles/108/how-to-use-regular-expressions-in-swift
extension NSRegularExpression {
    convenience init(_ pattern: String) {
        do {
            try self.init(pattern: pattern)
        } catch {
            preconditionFailure("Illegal regular expression: \(pattern).")
        }
    }
}

extension NSRegularExpression {
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}

extension String {
    static func ~= (lhs: String, rhs: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: rhs) else { return false }
        let range = NSRange(location: 0, length: lhs.utf16.count)
        return regex.firstMatch(in: lhs, options: [], range: range) != nil
    }
}
