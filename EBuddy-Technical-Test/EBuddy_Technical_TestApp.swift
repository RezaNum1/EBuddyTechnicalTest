//
//  EBuddy_Technical_TestApp.swift
//  EBuddy-Technical-Test
//
//  Created by Reza Harris on 27/11/24.
//

import SwiftUI
import Firebase

@main
struct EBuddy_Technical_TestApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authenticationVM: AuthenticationViewModel = AuthenticationViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authenticationVM)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    #if DEVELOPMENT
      print("Scheme: Development")
    #elseif STAGING
      print("Scheme: Staging")
    #else
      print("Scheme: -")
    #endif

    return true
  }
}
