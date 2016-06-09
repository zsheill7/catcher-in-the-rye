//
//  Utilities.swift
//  CatcherInTheRye
//
//  Created by Apple on 5/30/16.
//  Copyright © 2016 zsheill7. All rights reserved.
//

import Foundation

extension Array {
    func randomElement() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}
