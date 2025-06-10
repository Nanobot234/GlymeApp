//
//  GlymeApp.swift
//  Glyme
//
//  Created by Nana Bonsu on 4/11/25.
//

import SwiftUI
//import FirebaseAI
//import FirebaseCore

///TBD, the following, possibly to be used later on but
//class AppDelegate: NSObject, UIApplicationDelegate {
//  func application(_ application: UIApplication,
//                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//    FirebaseApp.configure()
//
//    return true
//  }
//}
//@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

 
@main
struct GlymeApp: App {
    
    @StateObject private var cameraViewModel = CameraViewModel()
    @StateObject private var openaiViewModel = OpenAIViewModel() // Using OpenAIViewModel for nutrition data
    
   // @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//    init() {
//        FirebaseApp.configure() // Configure Firebase
//    
//    }
    
    var body: some Scene {
        WindowGroup {
            
            
            CameraContentView()
                .environmentObject(cameraViewModel)
                .environmentObject(openaiViewModel)
        }
    }
}

