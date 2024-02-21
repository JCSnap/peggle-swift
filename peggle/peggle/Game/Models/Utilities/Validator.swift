//
//  Validator.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 4/2/24.
//

import Foundation

struct Validator {
    static func isNameInvalid(_ name: String) -> Bool {
        isWhiteSpacesOrNewlines(str: name) || consistInvalidCharacters(str: name) || isTooLong(str: name)
    }
}

extension Validator {
    private static func isWhiteSpacesOrNewlines(str: String) -> Bool {
        str.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    // Characters not defined in the 3.2 Unicode standards
    private static func consistInvalidCharacters(str: String) -> Bool {
        let invalidCharacters = CharacterSet.illegalCharacters
        return str.rangeOfCharacter(from: invalidCharacters) != nil
    }

    private static func isTooLong(str: String) -> Bool {
        let maxLength = Constants.defaultMaxLevelNameLength
        return str.count > maxLength
    }
}
