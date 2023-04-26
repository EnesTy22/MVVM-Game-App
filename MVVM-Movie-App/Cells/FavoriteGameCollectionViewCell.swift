//
//  FavoriteGameCollectionViewCell.swift
//  MVVM-Movie-App
//
//  Created by Enes Talha Yılmaz on 16.04.2023.
//

import UIKit
import CoreData

class FavoriteGameCollectionViewCell: UICollectionViewCell {
    @IBOutlet var favImage: UIImageView!
    @IBOutlet var favGameName: UILabel!
    var gameID:Int!
    var favCollectionVC:FavoritesCollectionViewController!
    override class func awakeFromNib() {
    
        super.awakeFromNib()
    }
    func initialSetup(){
        favImage.layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.6
    }
    func configureCell(game:GameViewModel){
        
        favGameName.text = game.name
        favImage.kf.setImage(with: URL(string:game.gameIcon)!)
    }
    @IBAction func removeFromFavBtn(_ sender: Any) {
        
        favCollectionVC.favoritesViewModel.deleteFavGame(gameId: gameID)
        favCollectionVC.reloadVMs()
    }
    
}
