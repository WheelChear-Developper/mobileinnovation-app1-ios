//
//  Configuration.swift
//  mobileinnovation-app1
//
//  Created by M.Amatani on 2017/08/12.
//  Copyright © 2017年 Mobile Innovation. All rights reserved.
//

import UIKit

class Configuration: NSObject {

    func configurationSet_Bool(value :Bool, keyName: String) {

        UserDefaults.standard.set(value, forKey: keyName)
    }
    func configurationGet_Bool(keyName: String) -> Bool {

        let userDefaults = UserDefaults.standard
        userDefaults.register(defaults: [keyName: false])
        return userDefaults.bool(forKey: keyName)
    }

    func configurationSet_String(value :String, keyName: String) {

        UserDefaults.standard.set(value, forKey: keyName)
    }
    func configurationGet_String(keyName: String) -> String {

        let userDefaults = UserDefaults.standard
        userDefaults.register(defaults: [keyName: ""])
        return userDefaults.string(forKey: keyName)!
    }

    func configurationSet_CDouble(value :CDouble, keyName: String) {

        UserDefaults.standard.set(value, forKey: keyName)
    }
    func configurationGet_CDouble(keyName: String) -> CDouble {

        let userDefaults = UserDefaults.standard
        userDefaults.register(defaults: [keyName: 0])
        return userDefaults.double(forKey: keyName)
    }

    func configurationSet_URL(value :URL, keyName: String) {

        UserDefaults.standard.set(value, forKey: keyName)
    }
    func configurationGet_URL(keyName: String) -> URL {

        let userDefaults = UserDefaults.standard
        userDefaults.register(defaults: [keyName: ""])
        return userDefaults.url(forKey: keyName)!
    }
}
