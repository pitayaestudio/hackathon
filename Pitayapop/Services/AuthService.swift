//
//  AuthService.swift
//  Pitayapop
//
//  Created by Brenda Saavedra on 6/22/17.
//  Copyright © 2017 Pitaya Estudio. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias Completion = (_ errMsg: String?, _ data:AnyObject?)-> Void

class AuthService{
    private static let _instance = AuthService()
    
    static var instance:AuthService{
        return _instance
    }
    
    func loginWithCredential(_ credential: AuthCredential, onComplete:Completion?){
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print ("loginWithCredential Error:: " + error.debugDescription)
                self.handleFirebaseError(error! as NSError, onComplete: onComplete)
            } else {
                print ("BSC:: successfully auth Firebase")
                self.saveUserInKeychain((user?.uid)!, isLoginWithFB: true)
                onComplete?(nil,user)
            }
        })
    }
    
    func loginWithEmail(_ email:String, password:String, onComplete:Completion?){
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                if let errorCode = AuthErrorCode(rawValue:error!._code){
                    if errorCode == AuthErrorCode.userNotFound {
                        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                            if error != nil {
                                self.handleFirebaseError(error! as NSError, onComplete: onComplete)
                            }else{
                                if user?.uid != nil {
                                    //Sign in
                                    Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                                        if error != nil{
                                            self.handleFirebaseError(error! as NSError, onComplete: onComplete)
                                        }else{
                                            self.saveUserInKeychain((user?.uid)!, isLoginWithFB: false)
                                            onComplete?(nil,user)
                                        }
                                    })
                                }
                            }
                        })
                    }
                }else{
                    self.handleFirebaseError(error! as NSError, onComplete: onComplete)
                }
            }else{
                //Successfully logged in
                onComplete?(nil,user)
            }
        })
    }
    
    func handleFirebaseError(_ error:NSError, onComplete:Completion?){
        print(error.debugDescription)
        if let errorCode = AuthErrorCode(rawValue: error.code){
            switch errorCode {
             
            case .emailAlreadyInUse, .accountExistsWithDifferentCredential:
                onComplete?("Could not create account. Email already in use", nil)
                break
                
            case .invalidEmail:
                onComplete?("Invalid email address", nil)
                break
                
            case .wrongPassword:
                onComplete?("Invalid password", nil)
                break
                
            default:
                onComplete?("There was a problem, try again", nil)
                break
            }
        }
    }
    
    func saveUserInKeychain(_ userID: String, isLoginWithFB: Bool){
        //DataService.instance.saveUser(uid: userID, isLoginWithFB: isLoginWithFB)
        //KeychainWrapper.standard.set(userID, forKey: KEY_UID)
    }
    
    func signOut(){
        try! Auth.auth().signOut()
       // KeychainWrapper.standard.removeObject(forKey: KEY_UID)
    }
    
}

