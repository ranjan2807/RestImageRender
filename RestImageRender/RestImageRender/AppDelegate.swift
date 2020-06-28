//
//  AppDelegate.swift
//  RestImageRender
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import UIKit
import Swinject

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	/// app screen window
    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

	/// app main coordinator
    var appCoordinator: Coordinator?

	/// swinject container helps in injecting dependency safely
	lazy fileprivate var container: Container = {
		let contTemp = Container()

		// register coordinator dependency to create instance of app coordinator
		contTemp.register(Coordinator.self) { _ in
			AppCoordinator(window: self.window)
		}
		return contTemp
	} ()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

		// Inject the app coordinator using swinject conatiner
		appCoordinator = container.resolve(Coordinator.self)
		// start the coordinator
        appCoordinator?.start()

        return true
    }
}
