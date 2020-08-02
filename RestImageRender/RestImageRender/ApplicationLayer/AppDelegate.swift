//
//  AppDelegate.swift
//  RestImageRender
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	/// app screen window
    var window: UIWindow?

	/// app main coordinator
    var appCoordinator: Coordinator?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

		window = UIWindow(frame: UIScreen.main.bounds)

		// Inject the app coordinator using app conatiner
		appCoordinator = AppResolver
			.resolve(Coordinator.self,
		name: "rir.AppDelegate.AppCoordinator",
		argument: self.window)
		// start the coordinator
        appCoordinator?.start()

        return true
    }
}
