//
//  RecipeBookApp.swift
//  RecipeBook
//
//  Created by Kainoa Jim on 11/29/22.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct RecipeBookApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var recipesVM = RecipesViewModel()
    
    
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
