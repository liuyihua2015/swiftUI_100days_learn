//
//  iDineApp.swift
//  iDine
//
//  Created by liuyihua on 2021/12/28.
//

import SwiftUI

@main
struct iDineApp: App {
    @StateObject var order = Order()
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(order)
        }
    }
}
