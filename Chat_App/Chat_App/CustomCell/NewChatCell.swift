//
//  NewChatCell.swift
//  Chat_App
//
//  Created by devloper65 on 4/20/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class NewChatCell: UITableViewCell {

    @IBOutlet var imgContact: UIImageView!
    @IBOutlet var lblContact: UILabel!
    @IBOutlet var lblStatus: UILabel!
    @IBOutlet var lblName: UILabel!
    
    var imageURL: URL!
    var parent: UIViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgContact.layer.cornerRadius = self.imgContact.frame.height / 2
       
    }
    
    override func prepareForReuse() {
        self.imgContact.image = nil
        self.lblStatus.text = nil
        self.lblContact.text = nil
        self.lblName.text = nil
        let tapges = UITapGestureRecognizer(target: self, action: #selector(openProfile))
        self.imgContact.addGestureRecognizer(tapges)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func openProfile(){
        let vw = UIView(frame: CGRect(x: Double((UIScreen.main.bounds.width / 2) - 100), y: Double((UIScreen.main.bounds.height / 2) - 100), width: 200, height: 200))
        vw.backgroundColor = UIColor.black
        let imgVw = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
//        imgVw.contentMode = .scaleAspectFit
        imgVw.sd_setImage(with: imageURL!, placeholderImage: nil, options: .progressiveDownload) { (image, err, cache, url) in
            
        }
        vw.addSubview(imgVw)
        (parent as! NewChatVC).view.addSubview(vw)
        (parent as! NewChatVC).tap = UITapGestureRecognizer(target: (parent as! NewChatVC), action: #selector((parent as! NewChatVC).taphandler))
        parent.view.addGestureRecognizer((parent as! NewChatVC).tap)
    }
}
