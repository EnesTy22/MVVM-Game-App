//
//  ViewController.swift
//  MVVM-Movie-App
//
//  Created by Enes Talha Yılmaz on 13.04.2023.
//

import UIKit

class GameListViewController: UIViewController{
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var contentView: UIView!
    
    let searchController = UISearchController()
    
    var currentViewControllerIndex = 0
    var gameListSlide = ["ererer","dfpdf","osfdosd"]
    var favList :[Int] = []
    var gameListVM = GameListViewModel()
    var webService = WebService()
    var sliderSize = 3
    var isSearched = false
    var oldHeightConstraint :CGFloat!
    
    override func viewDidLoad() {
        let heightConstraint = contentView.constraints.first { $0.firstAttribute == .height }
        oldHeightConstraint = heightConstraint!.constant
        tableView.delegate = self
        tableView.dataSource = self
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        if let statusBarFrame = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame {
                let statusBarView = UIView(frame: statusBarFrame)
            statusBarView.backgroundColor = UIColor.darkGray
                view.addSubview(statusBarView)
            }
        searchControllerSetup()
        setup()
        favList = gameListVM.getFavGameList()
        navigationItem.searchController = searchController
        tableView.register(UINib(nibName: "GameCellTableViewCell",bundle:nil), forCellReuseIdentifier: "GameCellTableViewCell")
       
    }
    func searchControllerSetup(){
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false

        if let searchTextField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            searchTextField.backgroundColor = UIColor.white
            searchTextField.textAlignment = .center // Arama metni alanını ortalamak için
// Burada istediğiniz arka plan rengini atayabilirsiniz.
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        favList = gameListVM.getFavGameList()
        
        tableView.reloadData()
        //configurePageViewController()

    }
    func setup(){
        webService.getGames(url: URL(string:"https://api.rawg.io/api/games?key=9ccbf0ced77642ca8ccdbc5dd4aad4b6")!) { games in
            if let gameLists = games{
                DispatchQueue.main.async {
                    
                    for game in gameLists{
                        let newGame = GameViewModel(game)
                        self.gameListVM.games.append(newGame)
                    }
                    self.tableView.reloadData()
                    self.configurePageViewController()
                }
                
            }
        }
    }
    func configurePageViewController(){
        guard let pageViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: CustomPageViewController.self)) as? CustomPageViewController else{
            return
        }
        pageViewController.delegate = self
        pageViewController.dataSource = self
        addChild(pageViewController)
        
        pageViewController.didMove(toParent: self)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(pageViewController.view)
        
        let views: [String:Any] = ["pageView":pageViewController.view]
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[pageView]-0-|",options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[pageView]-0-|",options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        
        guard let startingViewController = detailViewControllerAt(index:currentViewControllerIndex) else{
            return
        }
        
        pageViewController.setViewControllers([startingViewController], direction: .forward, animated: true)
    }
    
    func detailViewControllerAt(index:Int)->DataViewController?{
        
        if index >= gameListSlide.count || gameListSlide.count == 0{
            return nil
        }
        guard let dataViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: DataViewController.self)) as? DataViewController else{
            return nil
        }
        dataViewController.index = index
        
        if (gameListVM.games.count != 0)
        {
            dataViewController.game = gameListVM.games[dataViewController.index]
            dataViewController.configure()
            dataViewController.displayImage = gameListVM.games[dataViewController.index].gameIcon
        }
        return dataViewController
    }
    
    
    
}
extension GameListViewController:UIPageViewControllerDelegate,UIPageViewControllerDataSource{
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentViewControllerIndex
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        
        return gameListSlide.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let dataViewController = viewController as? DataViewController
        guard var currentIndex = dataViewController?.index else{
            return nil
        }
        currentViewControllerIndex = currentIndex
        if (currentIndex == 0 ){
            return nil
        }
        currentIndex -= 1
        return detailViewControllerAt(index: currentIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let dataViewController = viewController as? DataViewController
        guard var currentIndex = dataViewController?.index else{
            return nil
        }
        
        if (currentIndex == gameListSlide.count ){
            return nil
        }
        currentIndex += 1
        currentViewControllerIndex = currentIndex
        return detailViewControllerAt(index: currentIndex)
    }
    
    
}
extension GameListViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearched{
            print()
            return gameListVM.filteredGameArray.count
        }
        return (gameListVM.numbersOfRowsInSection() - sliderSize)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCellTableViewCell",for: indexPath) as! GameCellTableViewCell
        var game :GameViewModel
        if isSearched{
             game = gameListVM.filteredGameArray[indexPath.row]
        }
        else{
             game = gameListVM.games[indexPath.row + sliderSize]

        }
        var starState = false
        if favList.contains(game.id){
            starState=true
        }
       
        cell.configure(game: game,gameList: gameListVM,starState: starState)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var game:GameViewModel
        if isSearched{
            game = gameListVM.filteredGameArray[indexPath.row]
        }
        else{
            game = gameListVM.games[indexPath.row+sliderSize]
        }
        
        let detailsPage = DetailsViewController.instantiate()

        gameListVM.getGamesByID(id:[ game.id]) { GameViewModel in
            detailsPage.gameVM = GameViewModel?.first
            DispatchQueue.main.async {
                detailsPage.configureDetails()
                self.navigationController?.pushViewController(detailsPage, animated: true)

            }
            
        }
//

    }
}
extension GameListViewController: UISearchResultsUpdating,UISearchControllerDelegate {
    
    func didDismissSearchController(_ searchController: UISearchController) {
        onCloseSearchController()
    }
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else
        {
            return
        }
        if (searchText.count > 3)
        {
            gameListVM.filteredGameArray = gameListVM.games.filter {
                return $0.name.lowercased().contains(searchText.lowercased())
            }
            onOpenSearchController()
        }
    }
    func onOpenSearchController(){
        let heightConstraint = contentView.constraints.first { $0.firstAttribute == .height }
        heightConstraint?.constant = 0
        isSearched = true
        contentView.isHidden = true
        tableView.reloadData()
    }
    func onCloseSearchController(){
        let heightConstraint = contentView.constraints.first { $0.firstAttribute == .height }
        heightConstraint?.constant = oldHeightConstraint
        isSearched = false
        contentView.isHidden = false
        tableView.reloadData()
    }
    
    
    
    
}
