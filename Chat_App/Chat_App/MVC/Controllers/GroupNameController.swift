//
//  GroupNameController.swift
//  Chat_App
//
//  Created by devloper65 on 4/26/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class GroupNameController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var collectionGroup: UICollectionView!
    
    var media: [String] = ["Help.png","","","","","","","","","","","","","",""]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        collectionGroup.delegate = self
        collectionGroup.dataSource = self
        collectionGroup.register(UINib(nibName:"GroupAddCell",bundle:nil), forCellWithReuseIdentifier: "GroupAddCell")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Collection Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return media.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionGroup.dequeueReusableCell(withReuseIdentifier: "GroupAddCell", for: indexPath) as! GroupAddCell
        
        cell.imgpic.image = UIImage(named: media[indexPath.item])
        return cell
        
    }
    
    func collectionView(_ collectionView : UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let cellSize: CGSize = CGSize(width: 70, height: 90)
        return cellSize
    }

}
