//
//  Services.swift
//  MVVM-Movie-App
//
//  Created by Enes Talha Yılmaz on 14.04.2023.
//

import Foundation

struct Resource<T>{
    let url:URL
    let parse:(Data)->T?
}
struct WebService{
    let baseURL="https://api.rawg.io/api/games?key=9ccbf0ced77642ca8ccdbc5dd4aad4b6"
    func idSpesificURL(id:Int)->String{"https://api.rawg.io/api/games/\(id)?key=9ccbf0ced77642ca8ccdbc5dd4aad4b6"}

    func load<T>(resource : Resource<T>,completion:@escaping(T?)->()){
        
        URLSession.shared.dataTask(with: resource.url){data,response,error in
            if let data = data{
                DispatchQueue.main.async {
                    completion(resource.parse(data))
                }
                completion(nil)
            }
            else{
                completion(nil)
            }
            
        }.resume()
        
    }
    func getGames(url:URL,completion: @escaping ([Game]?)->())
        {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error{
                    print(error.localizedDescription)
                    completion(nil)
                }else if let data = data{
                    let games = try? JSONDecoder().decode(GameList.self, from: data)
                    if let gameList = games{
                        completion(gameList.results)
                    }
                    
                }
            }.resume()
        }
    func getGamesByID(idList:[Int],completion: @escaping ([Game]?)->())
        {
            var index=0
            var favGameList :[Game] = []
            for id in idList
            {

                URLSession.shared.dataTask(with: URL(string:idSpesificURL(id: id))!) { data, response, error in
                    if let error = error{
                        print(error.localizedDescription)
                        completion(nil)
                    }else if let data = data{
                        let games = try? JSONDecoder().decode(Game.self, from: data)
                        if let game = games{
                            favGameList.append(game)
                            
                        }
                        
                    }
                    index+=1
                    if(index == idList.count){
                        completion(favGameList)

                    }
                }.resume()
            }
            
            
            
        }
}
