//
//  GameListViewModel.swift
//  MVVM-Movie-App
//
//  Created by Enes Talha Yılmaz on 14.04.2023.
//

import Foundation
struct GameListViewModel{
    var games : [GameViewModel] = []
    var coreService = CoreService()
    
}
extension GameListViewModel{
    
        func checkIfItemExists(id:Int)->(Bool){
            return coreService?.checkIfItemExist(id: id) ?? false
        }
    
        func getFavGameList()->[Int]{
            var favGameList:[Int] = []
            let nsFavGameLists = coreService?.getFavGameList() ?? []
            nsFavGameLists.map { favGameList.append($0.value(forKey: "gameId") as! Int)
        }
        return favGameList
    }
    func deleteFavGame(gameId:Int){
        CoreService()?.deleteFavGame(gameId: gameId)
    }
        func addFavGame(id:Int)
        {
            coreService?.addFavGame(id: id)
        }
        func numbersOfRowsInSection()->Int{
            return self.games.count
        }
        func articleAtIndex(index :Int)->GameViewModel{
            return games[index]
        }
    
}
struct GameViewModel{
    private let game : Game
    var id : Int{
        return self.game.id
    }
    var name :String{
        return self.game.name
    }
    var ratings:Double{
        return self.game.rating
    }
    var released:String{
        return self.game.released
    }
    var gameIcon:String{
        return self.game.background_image
    }
}
extension GameViewModel{
    
    init(_ game:Game){
        self.game = game
    }
}
