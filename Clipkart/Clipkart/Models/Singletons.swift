//
//  NetworkMonitor.swift
//  Clipkart
//
//  Created by pratik.nalawade on 25/10/24.
//

import Foundation
import Network

enum ConnectionType: String {
    case wifi
    case cellular
    case ethernet
    case unknown
}

internal class NetworkMonitor {
    
    static public let shared = NetworkMonitor()
    private var monitor: NWPathMonitor
    private var queue: DispatchQueue
    var netOn: Bool = true
    var connType: ConnectionType = .unknown
    
    private init() {
        self.monitor = NWPathMonitor()
        self.queue = DispatchQueue(label: "NetworkMonitor")
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            let currentConnection = self.netOn
            self.netOn = path.status == .satisfied
            self.connType = self.checkConnectionTypeForPath(path)
            if currentConnection != self.netOn {
                DispatchQueue.main.async {
                    let dictionary = ["": self.connType.rawValue]
                    NotificationCenter.default.post(name: .connectionUpdated, object: dictionary)
                }
            }
        }
        
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        self.monitor.cancel()
    }
    
    func checkConnectionTypeForPath(_ path: NWPath) -> ConnectionType {
        if path.usesInterfaceType(.wifi) {
            return .wifi
        } else if path.usesInterfaceType(.wiredEthernet) {
            return .ethernet
        } else if path.usesInterfaceType(.cellular) {
            return .cellular
        }
        return .unknown
    }
}

extension NSNotification.Name {
    
    // Logout
    static let logout = Notification.Name("Logout")
    
    // Connection
    static let connectionUpdated = Notification.Name("ConnectionUpdated")
}

class SessionManager {
    static let shared = SessionManager()

    var currentUser: UserTags? = nil
    var isLoggedIn: Bool = false

    private init() {}
}
