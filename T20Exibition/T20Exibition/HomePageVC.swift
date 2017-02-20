
import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage

class HomePageVC: UIViewController {
    
    
    //MARK: Properties
    var favourites = [[IndexPath]]()
    var rowsToHide = [IndexPath]()
    var sectionsToHide = [Int]()
    var collectionPicsData = [JSON]()
    
    
    //MARK: IBOutlets
    @IBOutlet weak var countryWiseTable: UITableView!
    
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initialSetup()
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: Private Functions
    private func initialSetup(){
        
        //Registering Nib to TableView
        let leagueCellNib = UINib(nibName: "LeagueCell", bundle: nil)
        countryWiseTable.register(leagueCellNib, forCellReuseIdentifier: "LeagueCell")
        
        let sectionHeaderNib = UINib(nibName: "SectionHeaderView", bundle: nil)
        countryWiseTable.register(sectionHeaderNib, forHeaderFooterViewReuseIdentifier: "SectionHeaderView")
        
        //Setting up DataSource and Delegates of TableView
        countryWiseTable.delegate = self
        countryWiseTable.dataSource = self
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        fetchData(withQuery: "cars")
        
        
    }
    
    
    func fetchData(withQuery query: String){
        
        let URL = "https://pixabay.com/api/"
        
        let parameters = ["key" : "4609013-414f9bf36c6d94eeea32485fa",
                          
                          "q" : query
            
        ]
        print("hiii")
        
        Alamofire.request(URL,
                          method: .get,
                          parameters: parameters,
                          encoding: URLEncoding.default,
                          headers: nil).responseJSON{(response:DataResponse<Any>) in
                            
                            
                            if let value = response.value as? [String:Any] {
                                
                                print("hit")
                                
                                let json = JSON(value)
                                
                                self.collectionPicsData = json["hits"].array!
                            } else if let error = response.error {
                                
                                print(error)
                            }
                            
                            
        }
        
        
    }
    
}

//MARK: TableView Delegates and DataSource
extension HomePageVC : UITableViewDelegate , UITableViewDataSource
    
{
    //returns number of section in table view
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 10
    }
    
    //returns number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if sectionsToHide.contains(section)
        {
            
            return 0
            
        }else{
            
            return 5
            }
        
    }
    
    //returns cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        guard let cell = countryWiseTable.dequeueReusableCell(withIdentifier: "LeagueCell", for: indexPath) as? LeagueCell
            else{fatalError("Cell not found")}
        
        
        
        if rowsToHide.contains(indexPath){
            
            cell.showAndHideDetailsBtn.isSelected = true
        }
        else
        {
            cell.showAndHideDetailsBtn.isSelected = false
        }
        
        //Registering nib to CollectionView
        let nib = UINib(nibName: "TeamCell", bundle: nil)
        cell.leagueTeamCollection.register(nib, forCellWithReuseIdentifier: "TeamCell")
        
        //Adding target to showAndHideDetailsBtn
        cell.showAndHideDetailsBtn.addTarget(self, action: #selector(showAndHideDetailsBtnTapped), for: .touchUpInside)
        
        //Setting up Delegate and DataSource for Collection View
        cell.leagueTeamCollection.dataSource = self
        cell.leagueTeamCollection.delegate = self
        
        return cell
    }
    
    //returns height for row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if rowsToHide.contains(indexPath){
            
            return 21
            
        }
        else{
            
            return 142
            
        }
    }
    
    //returns Header for section
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let header = countryWiseTable.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeaderView") as? SectionHeaderView
            else{fatalError("Header not found")}
        header.showAndHideSectionBtn.tag = section
        header.showAndHideSectionBtn.addTarget(self, action: #selector(showAndHideSectionBtnTapped), for: .touchUpInside)
        
        if sectionsToHide.contains(section)
        {
            
            header.showAndHideSectionBtn.isSelected = true
            
        }else{
            
            header.showAndHideSectionBtn.isSelected = false
            
        }
        
        //        let data = DataModel(withJSON: JSON.data[section])
        //        header.titleLable.text = data.name
        
        return header
    }
    
    //returns height for header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 33
        
    }
    
    
    
    //Actions to be performed when showAndHideDetailsBtn is Tapped
    @objc private func showAndHideDetailsBtnTapped(btn : UIButton){
        
        guard let cell = btn.getTableViewCell as? LeagueCell
            else{ return }
        
        if btn.isSelected{
            
            rowsToHide = rowsToHide.filter(){ (index: IndexPath) -> Bool in
                
                return index != countryWiseTable.indexPath(for: cell)!
                
            }
            
            btn.isSelected = false
            
        }
        else{
            rowsToHide.append(countryWiseTable.indexPath(for: cell)!)
            
            btn.isSelected = true
        }
        countryWiseTable.reloadRows(at: [countryWiseTable.indexPath(for: cell)!], with: UITableViewRowAnimation.automatic)
    }
    
    
    @objc private func showAndHideSectionBtnTapped(btn: UIButton){
        
        if btn.isSelected{
            
            btn.isSelected = false
            
            sectionsToHide = sectionsToHide.filter({$0 != btn.tag})
            
        }else{
            
            btn.isSelected = true
            sectionsToHide.append(btn.tag)
            
        }
        print(sectionsToHide)
        countryWiseTable.reloadSections([btn.tag], with: .automatic)
    }
}
//MARK: CollectionView Delegates and DataSource
extension HomePageVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    //returns number of items in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return collectionPicsData.count
    }
    
    //returns cells for item
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCell", for: indexPath) as? TeamCell
            else{ fatalError("Cell not found") }
        
        cell.addToFavouriteButtonOutlet.addTarget(self, action: #selector(addToFavouriteBtnTapped), for: .touchUpInside)
        
        cell.teamPic.backgroundColor = UIColor.randomColor
        
        
        
        let tableCell = collectionView.getTableViewCell as! LeagueCell
        let tableIndexPath = countryWiseTable.indexPath(for: tableCell)
        
        let modeledData = ImageInfo(withJSON: self.collectionPicsData[indexPath.row])
        cell.configureCell(withData: modeledData)
        if favourites.contains(where:
            
            { (a : [IndexPath]) -> Bool in
                
                return a == [tableIndexPath!,indexPath]
        }
            ){
            
            cell.addToFavouriteButtonOutlet.isSelected = true
        }
        else
        {
            cell.addToFavouriteButtonOutlet.isSelected = false
            
        }
        
        return cell
        
    }
    
    //returns size for item
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: 100, height: 121)
        
    }
    
    //defining what to be done when item is selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! TeamCell
        
        guard let previewImage = self.storyboard?.instantiateViewController(withIdentifier: "ImagePreviewVC") as? ImagePreviewVC
            else{ return }
        
        previewImage.titleText = cell.teamNameLabel.text
        previewImage.imageColor = cell.teamPic.backgroundColor
        
        UIView.animate(withDuration: 0.75, delay: 0.0, options: .curveEaseInOut, animations:
            {() -> Void in
                
                self.navigationController!.pushViewController(previewImage, animated: false)
                UIView.setAnimationTransition(UIViewAnimationTransition.flipFromRight, for: self.navigationController!.view!, cache: false)
        },
                       completion: nil)
        
    }
    
    //Actions to be performed when addToFavourateBtn is Tapped
    @objc private func addToFavouriteBtnTapped(btn: UIButton ){
        
        guard let collectionCell = btn.getCollectionViewCell as? TeamCell
            else{ return }
        
        guard let tableCell = btn.getTableViewCell as? LeagueCell
            else{ return }
        
        let tableIndexPath = countryWiseTable.indexPath(for: tableCell)
        
        let collectionIndexPath = tableCell.leagueTeamCollection.indexPath(for: collectionCell)
        
        if btn.isSelected{
            
            btn.isSelected = false
            favourites = favourites.filter({ (indices: [IndexPath]) -> Bool in
                return indices != [tableIndexPath!,collectionIndexPath!]
            })
            
        }else{
            btn.isSelected = true
            self.favourites.append([tableIndexPath!,collectionIndexPath!])
            
        }
        print(self.favourites)
        
    }
    
    
    
}
