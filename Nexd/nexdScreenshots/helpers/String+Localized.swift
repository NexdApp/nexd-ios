//
//  String+Localized.swift
//  nexdScreenshots
//
//  Created by Tobias Schröpf on 17.06.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Foundation

extension String {
    func parseLanguage() -> String? {
        return components(separatedBy: "-").first
    }

    func localized(for language: String? = deviceLanguage.parseLanguage()) -> String {
        guard let language = language else {
            return self
        }

        guard let path = Bundle.tests.path(forResource: language, ofType: "lproj") else {
            return self
        }

        return Bundle(path: path)!.localizedMockString(self)
    }
}

extension Bundle {
    static var tests: Bundle {
        return Bundle(for: ScreenshotTests.self)
    }

    func localizedMockString(_ stringId: String) -> String {
        return NSLocalizedString(stringId, tableName: "LocalizableMock", bundle: self, value: "", comment: "")
    }
}
