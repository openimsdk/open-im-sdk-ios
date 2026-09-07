//
//  SwiftExampleApp.swift
//  SwiftExample
//
//  Created for OpenIM iOS SDK Standalone Swift Example.
//

import SwiftUI
import OpenIMSDK

@main
struct SwiftExampleApp: App {
    @StateObject private var service = OpenIMService.shared

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(service)
                .onAppear {
                    service.initializeSDK()
                }
        }
    }
}
