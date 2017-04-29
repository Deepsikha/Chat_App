//
//  GroupAddCell.swift
//  Chat_App
//
//  Created by Developer88 on 4/25/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit
@objc protocol CheckedCollectionviewDelegate {
    @objc optional func SettingsDidSelectCollectionViewCell(collectionView: UICollectionView, didSelectRowAtIndexPath indexPath: IndexPath)
}

class GroupAddCell: UICollectionViewCell {

    @IBOutlet var imgpic: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var btnCancel: UIButton!
    
    var indexPath: IndexPath!
    var Celldelegate: CheckedCollectionviewDelegate!
    var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgpic.layer.cornerRadius = imgpic.frame.width / 2
        self.imgpic.layer.borderColor = UIColor.blue.cgColor
        self.imgpic.layer.borderWidth = 1
        self.btnCancel.layer.cornerRadius = btnCancel.frame.width / 2
        self.btnCancel.layer.borderColor = UIColor.white.cgColor
        self.btnCancel.layer.borderWidth = 1.5

    }
    
    func setUpCustom(collectionView: UICollectionView, indexPath: IndexPath, CustomDelegate: CheckedCollectionviewDelegate) {
        self.Celldelegate = CustomDelegate
        self.indexPath = indexPath
        self.collectionView = collectionView
    }
    
    @IBAction func handleBtnCancel(_ sender: Any) {
        Celldelegate.SettingsDidSelectCollectionViewCell?(collectionView: self.collectionView, didSelectRowAtIndexPath: self.indexPath)
        
    }

}
