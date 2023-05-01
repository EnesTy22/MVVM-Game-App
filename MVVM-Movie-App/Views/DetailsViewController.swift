//
//  DetailsViewController.swift
//  MVVM-Movie-App
//
//  Created by Enes Talha Yılmaz on 21.04.2023.
//

import UIKit
import Kingfisher
class DetailsViewController: UIViewController {

    @IBOutlet weak var imageViewer: UIImageView!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var metaCriticRate: UILabel!
    @IBOutlet weak var gameName: UILabel!
    
    var gameVM:GameViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDetails()
        imageViewer.kf.setImage(with: URL(string:gameVM.gameIcon))
        releaseDate.text = gameVM.released
        metaCriticRate.text = String(gameVM.ratings)
        details.text = gameVM.description
        gameName.text = gameVM.name        // Do any additional setup after loading the view.
    }
    
    func configureDetails(){
        //details.text = game
        //imageViewer.kf.setImage(with: URL(string:gameVM.gameIcon))
        //releaseDate.text = gameVM.released
        //metaCriticRate.text = String(gameVM.ratings)
        //gameName.text = gameVM.name
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
