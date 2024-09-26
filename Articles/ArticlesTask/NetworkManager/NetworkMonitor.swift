//
//  NetworkMonitor.swift
//  ArticlesTask
//
//  Created by Sivaji Palla on 25/09/24.
//

import Foundation
import Network

import Foundation
import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private var monitor: NWPathMonitor
    private var isConnected: Bool = false
    
    var isConnectedToInternet: Bool {
        return isConnected
    }
    
    private init() {
        monitor = NWPathMonitor()
        monitor.start(queue: DispatchQueue.global(qos: .background))
        
        monitor.pathUpdateHandler = { path in
            self.isConnected = (path.status == .satisfied)
            print("Network status changed: \(self.isConnected ? "Connected" : "Not connected")")
        }
    }
    
    deinit {
        monitor.cancel()
    }
}
