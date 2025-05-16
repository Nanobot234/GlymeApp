//
//  GlymeApp.swift
//  Glyme
//
//  Created by Nana Bonsu on 4/11/25.
//

import SwiftUI

@main
struct GlymeApp: App {
    
    @StateObject private var cameraViewModel = CameraViewModel()
    
    var body: some Scene {
        WindowGroup {
            CameraContentView()
                .environmentObject(cameraViewModel)
        }
    }
}
