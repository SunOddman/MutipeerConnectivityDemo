//
//  ViewController.swift
//  MutipeerConnectivityDemo
//
//  Created by 海底捞lzx on 2017/3/28.
//  Copyright © 2017年 海底捞. All rights reserved.
//

import UIKit
import MultipeerConnectivity


class ViewController: UIViewController {

    let mcManager: MCManager = MCManager()
    
    
    var strReceiveMsg: String = ""
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        /*if self.strReceiveMsg.characters.count > 1 {
            let nsRange = NSMakeRange(self.strReceiveMsg.characters.count - 1, 1)
            self.txtOutput.scrollRangeToVisible(nsRange)
        }*/
        self.txtOutput.setNeedsLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.mcManager.delegate = self
        IQKeyboardManager.sharedManager().enable = true
        self.txtInput.delegate = self
    }

    // MARK:- 启用发现
    @IBAction func switchIsVisibleChange(_ sender: UISwitch) {
        self.mcManager.isAdvertiseSelf(shouldAdvertise: sender.isOn)
    }

    // MARK:- 连接设备
    @IBAction func btnConnectClick(_ sender: UIButton) {
        self.mcManager.browser.delegate = self
        self.present(self.mcManager.browser, animated: true) { 
            
        }
    }
    
    // MARK:- 发送消息
    @IBOutlet weak var txtInput: UITextField! // 输入
    @IBOutlet weak var txtOutput: UITextView! // 输出
    
    // 发送
    @IBAction func btnSendMsg(_ sender: UIButton) {
        sendMsg()
    }
    
    func sendMsg() {
        let data: Data = (txtInput.text ?? "").data(using: String.Encoding.utf8) ?? Data()
        let peers: Array = mcManager.session.connectedPeers
        
        try? mcManager.session.send(data, toPeers: peers, with: .reliable)
        
        self.strReceiveMsg += "\n----------------------\n PeerID: 我  \(Date())\n \(txtInput.text ?? "")"
        self.txtOutput.text = self.strReceiveMsg
        /*
        let nsRange = NSMakeRange(self.strReceiveMsg.characters.count - 1, 1)
        self.txtOutput.scrollRangeToVisible(nsRange)
        */
        
        
        txtInput.text = ""
    }
    
    
}

extension ViewController: MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        self.mcManager.browser.dismiss(animated: true) { 
            
        }
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        self.mcManager.browser.dismiss(animated: true) {
            
        }
    }
}

extension ViewController: MCManagerDelegate {
    func changeState(peerID: MCPeerID, state: MCSessionState) {
        
    }
    
    func receiveMsg(data: Data, fromPeer: MCPeerID) {
        print(Thread.current)
        let receiveString: String = String(data: data, encoding: String.Encoding.utf8) ?? ""
        self.strReceiveMsg += "\n----------------------\n PeerID:\(fromPeer.displayName)  \(Date())\n \(receiveString)"
        self.txtOutput.text = self.strReceiveMsg
        /*
        let nsRange = NSMakeRange(self.strReceiveMsg.characters.count - 1, 1)
        self.txtOutput.scrollRangeToVisible(nsRange)
        */
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.sendMsg()
        return true
    }
}


