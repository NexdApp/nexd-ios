//
//  RswiftTests.swift
//  nexd
//
//  Created by Tobias Schröpf on 10.05.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

@testable import nexd
import XCTest

class RswiftTest: XCTestCase {
    func testRessources() {
        do {
          try R.validate()
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
