//
//  FavoritesCollectionViewController.swift
//  MVVM-Movie-App
//
//  Created by Enes Talha Yılmaz on 16.04.2023.
//

import UIKit
import CoreData

private let reuseIdentifier = "Cell"

class FavoritesCollectionViewController: UICollectionViewController {
    
    var favorites:[GameViewModel]!
    var favoritesId:[Int]!

    //Deneme Daha Sonra DI olacak

    var favoritesViewModel = FavoritesViewModel()


    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        reloadVMs()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        reloadVMs()
        
        
    }
    func reloadVMs(){
        favoritesId = favoritesViewModel.getFavGameList()
            favoritesViewModel.getGamesByID(id:favoritesId,completion: { hjh in
                if let favorites = hjh{
                    self.favorites = favorites
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()

                    }
                }
           })
        
         
    }

    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return favorites?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Configure the cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favGameListCell", for: indexPath) as! FavoriteGameCollectionViewCell
        cell.gameID = favorites[indexPath.row].id
        cell.configureCell(game: favorites[indexPath.row])
        cell.initialSetup()
        cell.favCollectionVC = self
        
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let game = favorites[indexPath.row]
        let detailsPage = DetailsViewController.instantiate()

        detailsPage.gameVM = game
        detailsPage.configureDetails()
        navigationController?.pushViewController(detailsPage, animated: true)
    }

    

}
