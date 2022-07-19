//
//  CommunicationManager.swift
//  Food
//
//  Created by Jia Chen Yee on 20/7/22.
//

import Foundation
import WatchConnectivity

class CommunicationManager: NSObject, WCSessionDelegate {
    
    var session: WCSession?
    
    var onReceiveMessage: ((Data) -> Void)?
    
    func createWCSession() {
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    
    func sendData(data: Data) {
        print("Sent data to watch")
        session?.sendMessageData(data, replyHandler: nil)
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        onReceiveMessage?(messageData)
    }
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    #endif
    
}
