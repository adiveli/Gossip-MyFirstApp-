//
//  newsCell.swift
//  Gossip
//
//  Created by Adi Veliman on 02/09/2017.
//  Copyright © 2017 Adi Veliman. All rights reserved.
//

import UIKit
//import 'UIImage+Gif.swift'
import SwiftyGif





class newsCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    var gifs : [UIImage] = []

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let gif1 = UIImage(gifName: "gossipAgain.gif")
        let gif2 = UIImage(gifName: "manWalking.gif")
        let gif3 = UIImage(gifName: "lightning.gif")
        gifs.append(gif1)
        gifs.append(gif2)
        gifs.append(gif3)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionCell", for: indexPath) as! CustomCollectionCell
        
        let gifmanager = SwiftyGifManager(memoryLimit:20)
        
        cell.newsImage.translatesAutoresizingMaskIntoConstraints = false
        cell.newsImage.layer.cornerRadius = cell.newsImage.frame.size.width / 2;
        cell.newsImage.clipsToBounds = true;
        
        cell.newsImage.setGifImage(gifs[indexPath.row], manager: gifmanager)
        
        cell.layer.backgroundColor = UIColor.clear.cgColor
        
        
        
        return cell
    }

}
