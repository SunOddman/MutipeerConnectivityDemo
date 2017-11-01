//
//  MCManager.swift
//  MutipeerConnectivityDemo
//
//  Created by 海底捞lzx on 2017/3/28.
//  Copyright © 2017年 海底捞. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol MCManagerDelegate {
    func changeState(peerID: MCPeerID, state: MCSessionState)
    func receiveMsg(data: Data, fromPeer: MCPeerID)
}

class MCManager: NSObject {
    var peerID: MCPeerID
    var session: MCSession
    var browser: MCBrowserViewController
    var advertiser: MCAdvertiserAssistant?
    
    let serviseType: String = "haidilao-type"
    var delegate: MCManagerDelegate?
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        self.peerID = MCPeerID(displayName: UIDevice.current.name)
        self.session = MCSession(peer: self.peerID)
        
        self.browser = MCBrowserViewController(serviceType: serviseType, session: self.session)
        super.init()
        
        self.session.delegate = self
    }
    
    func setupSession(displayName: String) {
    }
    
    func setupMCBrowser() {
    }
    
    func isAdvertiseSelf(shouldAdvertise: Bool) {
        if shouldAdvertise {
            self.advertiser = MCAdvertiserAssistant(serviceType: serviseType, discoveryInfo: nil, session: self.session)
            self.advertiser?.start()
        } else {
            self.advertiser?.stop()
            self.advertiser = nil
        }
    }
}

extension MCManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        self.delegate?.changeState(peerID: peerID, state: state)
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            self.delegate?.receiveMsg(data: data, fromPeer: peerID)
        }
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    /*
    //MARK: optional
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        
    }
    */
    
}
