//
//  FavoritesViewModel.swift
//  MVVM-Movie-App
//
//  Created by Enes Talha Yılmaz on 17.04.2023.
//

import Foundation
import CoreData

class FavoritesViewModel{
    
    let coreService = CoreService()
    let webService = WebService()
    var favGameList:[Int] = []
    
    func getFavGameList()->[Int]{
        favGameList.removeAll()
        let nsFavGameLists = coreService?.getFavGameList() ?? []
        nsFavGameLists.map { favGameList.append($0.value(forKey: "gameId") as! Int)
        }
        return favGameList
    }
    func deleteFavGame(gameId:Int){
        CoreService()?.deleteFavGame(gameId: gameId)
    }
    func getGamesByID(id: [Int],completion: @escaping ([GameViewModel]?)->()){
        var findedGames:[GameViewModel]=[]
        webService.getGamesByID(idList: id) { findedGamesClosure in
                findedGamesClosure!.map{findedGames.append(GameViewModel($0))}
                completion(findedGames)
            
        }
        completion(findedGames)
        
        
    }
}
