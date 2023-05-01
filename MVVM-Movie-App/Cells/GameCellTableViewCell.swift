//
//  GameCellTableViewCell.swift
//  MVVM-Movie-App
//
//  Created by Enes Talha Yılmaz on 15.04.2023.
//

import UIKit
import Kingfisher

class GameCellTableViewCell: UITableViewCell {

    @IBOutlet var gameicon: UIImageView!
    @IBOutlet var favoritesBtn: UIButton!
    @IBOutlet var gameName: UILabel!
    @IBOutlet var ratings: UILabel!
    @IBOutlet var released: UILabel!
    var gameVM:GameViewModel!
    var gameListVM:GameListViewModel!

    var id = 546456
    var addedToFav = false
    
    override func awakeFromNib() {
        super.awakeFromNib()        // Initialization code
    }
    func configure(game:GameViewModel,gameList:GameListViewModel,starState:Bool){
        addedToFav = !starState
        gameVM = game
        released.text = game.released
        ratings.text = String(game.ratings)
        gameName.text = game.name
        gameListVM = gameList
        id=game.id
        gameicon.kf.setImage(with: URL(string:game.gameIcon),placeholder: nil)
        gameicon.layer.cornerRadius = 10
        UpdateFavsView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
   
    @IBAction func addFavoritesBtn(_ sender: UIButton) {
        UpdateFavs()
    }
    func UpdateFavs(){
        if(!addedToFav){
            ChangeFavBtnSelected()  
        }
        else{
            ChangeFavBtnUnSelected()
        }
    }
    func UpdateFavsView(){
        if(!addedToFav){
            favoritesBtn.setImage(UIImage(systemName: "star.fill"), for: .normal)
            addedToFav=true
        }
        else{
            favoritesBtn.setImage(UIImage(systemName: "star"), for: .normal)
            addedToFav=false        }
    }
    func ChangeFavBtnSelected(){
        if !gameListVM.checkIfItemExists(id: self.id)
        {
            gameListVM.addFavGame(id: self.id)
            favoritesBtn.setImage(UIImage(systemName: "star.fill"), for: .normal)
            addedToFav=true
        }
        
        
    }
    func ChangeFavBtnUnSelected(){
        gameListVM.coreService?.deleteFavGame(gameId: id)
        favoritesBtn.setImage(UIImage(systemName: "star"), for: .normal)
        addedToFav=false

    }
}
