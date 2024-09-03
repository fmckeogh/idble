//
//  HedyApp.swift
//  Hedy
//
//  Created by Ferdia McKeogh on 16/04/2022.
//

import SwiftUI
import IOBluetooth
import Foundation
import AppKit

// MAC of WH-1000XM3
let DEVICE_MAC = "CC-98-8B-22-9E-49"

@main
struct HedyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(height: 0)
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // hide from dock
        NSApp.setActivationPolicy(.prohibited)
        
        // register observer for screen locking
        DistributedNotificationCenter.default.addObserver(
            forName: Notification.Name("com.apple.screenIsLocked"),
            object: nil,
            queue: nil,
            using: self.locked_handler(notification:)
        )
        
        // register observer for screen unlocking
        DistributedNotificationCenter.default.addObserver(
            forName: Notification.Name("com.apple.screenIsUnlocked"),
            object: nil,
            queue: nil,
            using: self.unlocked_handler(notification:)
        )
        
        print("Ready")
    }
    
    // Locked observer handler method
    func locked_handler(notification: Notification) {
        disconnect()
    }
    
    // Unlocked observer handler method
    func unlocked_handler(notification: Notification) {
        connect()
    }
    
    // Disconnects the device with DEVICE_MAC
    func disconnect() {
        guard let bluetoothDevice = IOBluetoothDevice(addressString: DEVICE_MAC) else {
            print("Device not found")
            return
        }

        if !bluetoothDevice.isPaired() {
            print("Device not paired")
            return
        }

        if bluetoothDevice.isConnected() {
            bluetoothDevice.closeConnection()
            print("Disconnected")
        }
    }

    // Connects the device with DEVICE_MAC
    func connect() {
        guard let bluetoothDevice = IOBluetoothDevice(addressString: DEVICE_MAC) else {
            print("Device not found")
            return
        }

        if !bluetoothDevice.isPaired() {
            print("Device not paired")
            return
        }

        if !bluetoothDevice.isConnected() {
            bluetoothDevice.openConnection()
            print("Connected")
        }
    }
    
}
