//
//  WatchViewModel.swift
//  watches WatchKit Extension
//
//  Created by Ivan Nazarov on 07.09.2022.
//

import Foundation
import WatchConnectivity

class WatchViewModel: NSObject, ObservableObject {
    var session: WCSession
    @Published var score = 0
    @Published var hole = 1
    
    // Add more cases if you have more receive method
    enum WatchReceiveMethod: String {
        case sendScoreToNative
        case sendHoleToNative
    }
    
    // Add more cases if you have more sending method
    enum WatchSendMethod: String {
        case sendScoreToFlutter
        case sendHoleToFlutter
    }
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
    }
    
    func sendDataMessage(for method: WatchSendMethod, data: [String: Any] = [:]) {
        sendMessage(for: method.rawValue, data: data)
    }
    
}

extension WatchViewModel: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    // Receive message From AppDelegate.swift that send from iOS devices
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            guard let method = message["method"] as? String, let enumMethod = WatchReceiveMethod(rawValue: method) else {
                return
            }
            
            switch enumMethod {
            case .sendScoreToNative:
                self.score = (message["data"] as? Int) ?? 0
            case .sendHoleToNative:
                self.hole = (message["data"] as? Int) ?? 1
            }
        }
    }
    
    func sendMessage(for method: String, data: [String: Any] = [:]) {
        guard session.isReachable else {
            return
        }
        let messageData: [String: Any] = ["method": method, "data": data]
        session.sendMessage(messageData, replyHandler: nil, errorHandler: nil)
    }
    
}
