//
//  VChatController.swift
//  Chat_App
//
//  Created by Developer88 on 4/29/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit
import AVFoundation
import WebRTC


class VChatController: UIViewController, ARDAppClientDelegate, RTCEAGLVideoViewDelegate {
    
    func videoView(_ videoView: RTCEAGLVideoView, didChangeVideoSize size: CGSize) {
        
    }


    @IBOutlet weak var remote: RTCEAGLVideoView!
    @IBOutlet weak var localview: RTCEAGLVideoView!
    
    var roomName = "567439746"
    var client: ARDAppClient?
    var localVideoTrack: RTCVideoTrack?
    var remoteVideoTrack: RTCVideoTrack?
    var captureController:ARDCaptureController = ARDCaptureController()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.disconnect()
        self.client=ARDAppClient(delegate: self)
        //self.client?.serverHostUrl="https://apprtc.appspot.com"
        let settingsModel = ARDSettingsModel()
        client!.connectToRoom(withId: self.roomName as String!, settings: settingsModel, isLoopback: false, isAudioOnly: false, shouldMakeAecDump: false, shouldUseLevelControl: false)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disconnect()
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    @IBAction func endbtn(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func appClient(_ client: ARDAppClient!, didChange state: ARDAppClientState) {
        switch (state) {
        case .connected:
            print("Client connected.");
        case .connecting:
            print("Client connecting.");
        case .disconnected:
            print("Client disconnected.");
            self.remoteDisconnected();
        }
    }
    
    public func appClient(_ client: ARDAppClient!, didError error: Error!) {
        let alert = UIAlertView(title: "Error", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "close")
        alert.show()
        self.disconnect()
    }
    
    func appClient(_ client: ARDAppClient!, didReceiveLocalVideoTrack localVideoTrack: RTCVideoTrack!) {
        self.localVideoTrack?.remove(self.localview!)
        self.localview?.renderFrame(nil)
        self.localVideoTrack=localVideoTrack
        self.localVideoTrack?.add(self.localview!)
        
    }
    
    public func appClient(_ client: ARDAppClient!, didCreateLocalCapturer localCapturer: RTCCameraVideoCapturer!) {
        let settingsModel = ARDSettingsModel()
        captureController = ARDCaptureController(capturer: localCapturer, settings: settingsModel)
        captureController.startCapture()
    }
    
    
    func appClient(_ client: ARDAppClient!, didReceiveRemoteVideoTrack remoteVideoTrack: RTCVideoTrack!) {
        self.remoteVideoTrack=remoteVideoTrack
        self.remoteVideoTrack?.add(self.remote!)
    }
    
    
    
    func appclient(_ client: ARDAppClient!, didRotateWithLocal localVideoTrack: RTCVideoTrack!, remoteVideoTrack: RTCVideoTrack!) {
        
    }
    
    public func appClient(_ client: ARDAppClient!, didGetStats stats: [Any]!) {
        
    }
    
    public func appClient(_ client: ARDAppClient!, didChange state: RTCIceConnectionState) {
        
    }
    
    //    MARK: RTCEAGLVideoViewDelegate


    func remoteDisconnected(){
        if(remoteVideoTrack != nil){
            remoteVideoTrack?.remove(remote)
        }
        remoteVideoTrack = nil
    }
    
    func disconnect(){
        if let _ = self.client{
            self.localVideoTrack?.remove(self.localview!)
            self.remoteVideoTrack?.remove(self.remote!)
            self.localVideoTrack=nil
            self.remoteVideoTrack=nil
            self.client?.disconnect()
        }
    }
    
    func showAlertWithMessage(_ message: String){
        let alertView: UIAlertController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let alertAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alertView.addAction(alertAction)
        self.present(alertView, animated: true, completion: nil)
    }

}
