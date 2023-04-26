//
//  DataViewController.swift
//  MVVM-Movie-App
//
//  Created by Enes Talha Yılmaz on 19.04.2023.
//

import UIKit
import Kingfisher
class DataViewController: UIViewController {

    @IBOutlet var lbl: UILabel!
    var displayImage:String?
    var game : GameViewModel?
    
    @IBOutlet var imageViewer: UIImageView!
    var index = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer()
        self.view.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(tapEvent))
        //imageViewer?.kf.setImage(with: URL(string:game.gameIcon)!)
    }
    
   
    @objc func tapEvent(){
        let detailsPage = DetailsViewController.instantiate()

        detailsPage.gameVM = game
        detailsPage.configureDetails()
        navigationController?.pushViewController(detailsPage, animated: true)
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
