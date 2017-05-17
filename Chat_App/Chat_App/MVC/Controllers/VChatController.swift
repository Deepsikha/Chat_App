

import UIKit
import AVFoundation
import WebRTC
import SocketRocket

class VChatController: UIViewController,RTCEAGLVideoViewDelegate,ARDAppClientDelegate,SRWebSocketDelegate {
    
    //Views, Labels, and Buttons
    @IBOutlet weak var remoteView:RTCEAGLVideoView?
    @IBOutlet weak var localView:RTCEAGLVideoView?
    @IBOutlet weak var footerView:UIView?
    @IBOutlet weak var urlLabel:UILabel?
    @IBOutlet weak var buttonContainerView:UIView?
    @IBOutlet weak var audioButton:UIButton?
    @IBOutlet weak var videoButton:UIButton?
    @IBOutlet weak var hangupButton:UIButton?
    //Auto Layout Constraints used for animations
    @IBOutlet weak var remoteViewTopConstraint:NSLayoutConstraint?
    @IBOutlet weak var remoteViewRightConstraint:NSLayoutConstraint?
    @IBOutlet weak var remoteViewLeftConstraint:NSLayoutConstraint?
    @IBOutlet weak var remoteViewBottomConstraint:NSLayoutConstraint?
    @IBOutlet weak var localViewWidthConstraint:NSLayoutConstraint?
    @IBOutlet weak var localViewHeightConstraint:NSLayoutConstraint?
    @IBOutlet weak var  localViewRightConstraint:NSLayoutConstraint?
    @IBOutlet weak var  localViewBottomConstraint:NSLayoutConstraint?
    @IBOutlet weak var  footerViewBottomConstraint:NSLayoutConstraint?
    @IBOutlet weak var  buttonContainerViewLeftConstraint:NSLayoutConstraint?
    
    var   roomUrl:NSString?;
    var   client:ARDAppClient?;
    var   _roomName:NSString=NSString(format: "")
    var   localVideoTrack:RTCVideoTrack?;
    var   remoteVideoTrack:RTCVideoTrack?;
    var   localVideoSize:CGSize?;
    var   remoteVideoSize:CGSize?;
    var   isZoom:Bool = false; //used for double tap remote view
    var   captureController:ARDCaptureController = ARDCaptureController()
    static var roomName : String!
    static var duration: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isZoom = false;
        self.audioButton?.layer.cornerRadius=20.0
        self.videoButton?.layer.cornerRadius=20.0
        self.hangupButton?.layer.cornerRadius=20.0
        let tapGestureRecognizer:UITapGestureRecognizer=UITapGestureRecognizer(target: self, action:#selector(VChatController.toggleButtonContainer) )
        tapGestureRecognizer.numberOfTapsRequired=1
        self.view.addGestureRecognizer(tapGestureRecognizer)
        let zoomGestureRecognizer:UITapGestureRecognizer=UITapGestureRecognizer(target: self, action:#selector(VChatController.zoomRemote) )
        zoomGestureRecognizer.numberOfTapsRequired=2
        self.view.addGestureRecognizer(zoomGestureRecognizer)
        self.remoteView?.delegate=self
        self.localView?.delegate=self
        NotificationCenter.default.addObserver(self, selector: #selector(VChatController.orientationChanged(_:)), name: NSNotification.Name(rawValue: "UIDeviceOrientationDidChangeNotification"), object: nil)
        AppDelegate.websocket.delegate = self as! SRWebSocketDelegate
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.localViewBottomConstraint?.constant=0.0
        self.localViewRightConstraint?.constant=0.0
        self.localViewHeightConstraint?.constant=self.view.frame.size.height
        self.localViewWidthConstraint?.constant=self.view.frame.size.width
        self.footerViewBottomConstraint?.constant=0.0
        self.disconnect()
        self.client=ARDAppClient(delegate: self)
        //self.client?.serverHostUrl="https://apprtc.appspot.com"
        var settingsModel = ARDSettingsModel()
        client!.connectToRoom(withId: VChatController.roomName as String!, settings: settingsModel, isLoopback: false, isAudioOnly: false, shouldMakeAecDump: false, shouldUseLevelControl: false)
        
        //self.client!.connectToRoom(withId: self.roomName! as String, options: nil)
    }
    
    override func  viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        NotificationCenter.default.removeObserver(self)
        self.disconnect()
    }
    
    override var  shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.allButUpsideDown
    }
    
    func applicationWillResignActive(_ application:UIApplication){
        self.disconnect()
    }
    
    func orientationChanged(_ notification:Notification){
        if let _ = self.localVideoSize {
            self.videoView(self.localView!, didChangeVideoSize: self.localVideoSize!)
        }
        if let _ = self.remoteVideoSize {
            self.videoView(self.remoteView!, didChangeVideoSize: self.remoteVideoSize!)
        }
    }
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Appclient Delegate
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
        self.localVideoTrack?.remove(self.localView!)
        self.localView?.renderFrame(nil)
        self.localVideoTrack=localVideoTrack
        self.localVideoTrack?.add(self.localView!)
        
    }
    
    public func appClient(_ client: ARDAppClient!, didCreateLocalCapturer localCapturer: RTCCameraVideoCapturer!) {
        let settingsModel = ARDSettingsModel()
        captureController = ARDCaptureController(capturer: localCapturer, settings: settingsModel)
        captureController.startCapture()
    }
    
    
    func appClient(_ client: ARDAppClient!, didReceiveRemoteVideoTrack remoteVideoTrack: RTCVideoTrack!) {
        self.remoteVideoTrack=remoteVideoTrack
        self.remoteVideoTrack?.add(self.remoteView!)
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.localViewBottomConstraint?.constant=28.0
            self.localViewRightConstraint?.constant=28.0
            self.localViewHeightConstraint?.constant=self.view.frame.size.height/4
            self.localViewWidthConstraint?.constant=self.view.frame.size.width/4
            self.footerViewBottomConstraint?.constant = -80.0
        })
    }
    
    func appclient(_ client: ARDAppClient!, didRotateWithLocal localVideoTrack: RTCVideoTrack!, remoteVideoTrack: RTCVideoTrack!) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(VChatController.updateUIForRotation), object: nil)
        // Hack for rotation to get the right video size
        self.perform(#selector(VChatController.updateUIForRotation), with: nil, afterDelay: 0.2)
    }
    
    public func appClient(_ client: ARDAppClient!, didGetStats stats: [Any]!) {
        
    }
    
    public func appClient(_ client: ARDAppClient!, didChange state: RTCIceConnectionState) {
        
    }
    
    //MARK:- Websocket Delegate
    func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!) {
        let dic = convertToDictionary(text: message as! String)
        print(dic!)
        do {
            var _:[String:Any]!
            var _: Data!
            switch dic!["type"] as! String {
            case "declineVCall":
                self.disconnect()
                var viewControllers = navigationController?.viewControllers
                viewControllers?.removeLast(2)
                navigationController?.setViewControllers(viewControllers!, animated: true)
                break
            default:
                break
            }
        }
    }
    
    
    //MARK:- VideoView Delegate
    func videoView(_ videoView: RTCEAGLVideoView, didChangeVideoSize size: CGSize) {
        let orientation: UIInterfaceOrientation = UIApplication.shared.statusBarOrientation
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            let containerWidth: CGFloat = self.view.frame.size.width
            let containerHeight: CGFloat = self.view.frame.size.height
            let defaultAspectRatio: CGSize = CGSize(width: 4, height: 3)
            if videoView == self.localView {
                self.localVideoSize = size
                let aspectRatio: CGSize = size.equalTo(CGSize.zero) ? defaultAspectRatio : size
                var videoRect: CGRect = self.view.bounds
                if (self.remoteVideoTrack != nil) {
                    videoRect = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width / 4.0, height: self.view.frame.size.height / 4.0)
                    if orientation == UIInterfaceOrientation.landscapeLeft || orientation == UIInterfaceOrientation.landscapeRight {
                        videoRect = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.height / 4.0, height: self.view.frame.size.width / 4.0)
                    }
                }
                let videoFrame: CGRect = AVMakeRect(aspectRatio: aspectRatio, insideRect: videoRect)
                self.localViewWidthConstraint!.constant = videoFrame.size.width
                self.localViewHeightConstraint!.constant = videoFrame.size.height
                if (self.remoteVideoTrack != nil) {
                    self.localViewBottomConstraint!.constant = 28.0
                    self.localViewRightConstraint!.constant = 28.0
                }
                else{
                    self.localViewBottomConstraint!.constant = containerHeight/2.0 - videoFrame.size.height/2.0
                    self.localViewRightConstraint!.constant = containerWidth/2.0 - videoFrame.size.width/2.0
                }
            }
            else if videoView == self.remoteView {
                self.remoteVideoSize = size
                let aspectRatio: CGSize = size.equalTo(CGSize.zero) ? defaultAspectRatio : size
                let videoRect: CGRect = self.view.bounds
                var videoFrame: CGRect = AVMakeRect(aspectRatio: aspectRatio, insideRect: videoRect)
                if self.isZoom {
                    let scale: CGFloat = max(containerWidth / videoFrame.size.width, containerHeight / videoFrame.size.height)
                    videoFrame.size.width *= scale
                    videoFrame.size.height *= scale
                }
                self.remoteViewTopConstraint!.constant = (containerHeight / 2.0 - videoFrame.size.height / 2.0)
                self.remoteViewBottomConstraint!.constant = (containerHeight / 2.0 - videoFrame.size.height / 2.0)
                self.remoteViewLeftConstraint!.constant = (containerWidth / 2.0 - videoFrame.size.width / 2.0)
                self.remoteViewRightConstraint!.constant = (containerWidth / 2.0 - videoFrame.size.width / 2.0)
            }
            self.view.layoutIfNeeded()
        })
        
    }
    //MARK:- Outlet Method
    @IBAction func audioButtonPressed (_ sender:UIButton){
        sender.isSelected = !sender.isSelected
        self.client?.toggleAudioMute()
    }
    
    @IBAction func videoButtonPressed(_ sender:UIButton){
        sender.isSelected = !sender.isSelected
        self.client?.toggleVideoMute()
    }
    
    @IBAction func hangupButtonPressed(_ sender:UIButton){
        self.disconnect()
        var viewControllers = navigationController?.viewControllers
        viewControllers?.removeLast(2)
        navigationController?.setViewControllers(viewControllers!, animated: true)
        _ = ModelManager.getInstance().addData("call", "type,sender_id,receiver_id,time,duration", "\'video\',\(AppDelegate.senderId),\(ChatController.reciever_id!),'\(Date().addingTimeInterval(5.5))\',\(VChatController.duration)")

        do {
            let json = try JSONSerialization.data(withJSONObject: ["type":"declineVideoCall","receiver_id": ChatController.reciever_id], options: .prettyPrinted)
            AppDelegate.websocket.send(json)
        } catch {
            
        }
        
    }
    
    //MARK:- Custom Method
    func disconnect() {
        if let _ = self.client{
            self.localVideoTrack?.remove(self.localView!)
            self.remoteVideoTrack?.remove(self.remoteView!)
            self.localView?.renderFrame(nil)
            self.remoteView?.renderFrame(nil)
            self.localVideoTrack=nil
            self.remoteVideoTrack=nil
            self.client?.disconnect()
        }
    }
    
    func remoteDisconnected() {
        self.remoteVideoTrack?.remove(self.remoteView!)
        self.remoteView?.renderFrame(nil)
        if self.localVideoSize != nil {
            self.videoView(self.localView!, didChangeVideoSize: self.localVideoSize!)
        }
    }
    
    func toggleButtonContainer() {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            if (self.buttonContainerViewLeftConstraint!.constant <= -40.0) {
                self.buttonContainerViewLeftConstraint!.constant=20.0
                self.buttonContainerView!.alpha=1.0;
            }
            else {
                self.buttonContainerViewLeftConstraint!.constant = -40.0;
                self.buttonContainerView!.alpha=0.0;
            }
            self.view.layoutIfNeeded();
        })
    }
    
    func zoomRemote() {
        //Toggle Aspect Fill or Fit
        self.isZoom = !self.isZoom;
        self.videoView(self.remoteView!, didChangeVideoSize: self.remoteVideoSize!)
    }
    
    func updateUIForRotation(){
        let statusBarOrientation:UIInterfaceOrientation = UIApplication.shared.statusBarOrientation;
        let deviceOrientation:UIDeviceOrientation  = UIDevice.current.orientation
        if (statusBarOrientation.rawValue==deviceOrientation.rawValue){
            if let  _ = self.localVideoSize {
                self.videoView(self.localView!, didChangeVideoSize: self.localVideoSize!)
            }
            if let _ = self.remoteVideoSize {
                self.videoView(self.remoteView!, didChangeVideoSize: self.remoteVideoSize!)
            }
        }
        else{
            print("Unknown orientation Skipped rotation");
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
