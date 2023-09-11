//
//  SwiftUI_ECAApp.swift
//  SwiftUI_ECA
//
//  Created by Shi Er Lee on 8/9/22.
//

import SwiftUI
import Firebase
import FirebaseAuth

//class AppDelegate: NSObject, UIApplicationDelegate {
//  func application(_ application: UIApplication,
//                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
////    FirebaseApp.configure()
//
//    return true
//  }
//}

@main
struct SwiftUI_ECAApp: App {
  // register app delegate for Firebase setup
    @StateObject var viewModel = ViewModel()
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

  var body: some Scene {
    WindowGroup {
        SplashScreenView()
            .environmentObject(viewModel)
    }
  }
    
    init() {
        setupAuthentication()
    }
    
}

extension SwiftUI_ECAApp {
    private func setupAuthentication() {
        FirebaseApp.configure()
    }
}
