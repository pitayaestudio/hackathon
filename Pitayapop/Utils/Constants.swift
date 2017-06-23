//
//  Constants.swift
//  Pitayapop
//
//  Created by Brenda Saavedra on 22/06/17.
//  Copyright © 2017 Pitaya Estudio. All rights reserved.
//

import Foundation
import KeychainSwift

typealias JSONStandard = [String: AnyObject]
let keychain = KeychainSwift()
let appDel = UIApplication.shared.delegate as! AppDelegate

let SHADOW_GRAY: CGFloat = 120.0 / 155.0
let SEGUE_FEEDVC = "FeedVC"
let SEGUE_SIGNINVC = "SignInVC"
