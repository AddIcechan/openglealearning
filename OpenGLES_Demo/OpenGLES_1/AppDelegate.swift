//
//  AppDelegate.swift
//  OpenGLES_1
//
//  Created by ADDICE on 2018/3/29.
//  Copyright © 2018年 ADDICE. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.rootViewController = GLKDemoController()
        
        window?.makeKeyAndVisible()
        
        return true
    }


}

