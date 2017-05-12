//
//  CallIntermediate.swift
//  Chat_App
//
//  Created by Developer88 on 5/12/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit


class CallIntermediate: UIViewController {

    @IBOutlet weak var imgvw: UIImageView!
    
    @IBOutlet weak var clng: UILabel!
    @IBOutlet weak var rjct0: UIButton!
    @IBOutlet weak var rjct1: UIButton!
    @IBOutlet weak var acpt: UIButton!
    
    static var calling : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(CallIntermediate.calling) {
            self.acpt.isHidden =  true
            self.rjct1.isHidden = true
            self.clng.isHidden = true
            self.rjct0.isHidden = false
        } else {
            self.acpt.isHidden =  false
            self.rjct1.isHidden = false
            self.clng.isHidden = false

            self.rjct0.isHidden = true
        }
        
    }

    @IBAction func accpt(_ sender: Any) {
        
        self.navigationController?.pushViewController(VChatController(), animated: false)
    }
    
    @IBAction func rjct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
