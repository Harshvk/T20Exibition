
import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage

class HomePageVC: UIViewController {
    
    typealias JsonDict = [[String:Any]]
    
    //MARK: Properties
    var rowsToHide = [IndexPath]()
    var sectionsToHide = [Int]()
    var collectionPicsData = [[[ImageInfo]]]()

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
        
        //Hitting Server
        fetchData()

    }
    

    //Function to Hit Server
    private func fetchData() {
        
        for sec in GivenJSON.data.indices{
            collectionPicsData.append([])
            for (index,value) in (GivenJSON.data[sec]["Value"] as! JsonDict).enumerated(){
                
                                collectionPicsData[sec].append([])
                
                                WebServices().fetchDataFromPixabay(withQuery: value["Sub Category"] as! String,
                                                                   success: {(input: [ImageInfo]) -> Void in
                                                                    
                                                                    self.collectionPicsData[sec][index] = input
                                                                    print("Hit")
                                                                    self.countryWiseTable.reloadData()

                                },failure: {(error: Error) -> Void in
            
                                    print(error)
                                })
                
                            }
                    }
               }
}
    


//MARK: TableView Delegates and DataSource
extension HomePageVC : UITableViewDelegate , UITableViewDataSource
    
{
    //returns number of section in table view
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return collectionPicsData.count
    }
    
    //returns number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        
        if sectionsToHide.contains(section){
            
            return 0
        
        }else{
            
            return collectionPicsData[section].count
            
        }
        
        
    }
    
    //returns cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueCell", for: indexPath) as? LeagueCell
            else{fatalError("Cell not found")}
        
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
        
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeaderView") as? SectionHeaderView
            else{fatalError("Header not found")}
        
        //setting button tag to section
        header.showAndHideSectionBtn.tag = section
        
        //Adding Target to showAndHideSectionBtn
        header.showAndHideSectionBtn.addTarget(self, action: #selector(showAndHideSectionBtnTapped), for: .touchUpInside)
        
        //Providing Title to Header
        header.titleLable.text = GivenJSON.data[section]["Category"] as? String
        if sectionsToHide.contains(section)
        {
            
            header.showAndHideSectionBtn.isSelected = true
            
        }else{
            
            header.showAndHideSectionBtn.isSelected = false
            
        }
        
        return header
    }
    
    //returns height for header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 33
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? LeagueCell else{ return }
        
        //Registering nib to CollectionView
        let nib = UINib(nibName: "TeamCell", bundle: nil)
        tableViewCell.leagueTeamCollection.register(nib, forCellWithReuseIdentifier: "TeamCell")
        
        //Setting up datasource and delegate of Collection View
        tableViewCell.leagueTeamCollection.dataSource = self
        tableViewCell.leagueTeamCollection.delegate = self
        
        //Adding targert to showAndHideDetailsBtn
        tableViewCell.showAndHideDetailsBtn.addTarget(self, action: #selector(showAndHideDetailsBtnTapped), for: .touchUpInside)
        
        //saving indexPath for tableViewCell
        tableViewCell.tableIndexPath = indexPath
        
        let data = GivenJSON.data[indexPath.section]["Value"] as! JsonDict
        
        //Displaying label of table cell
        tableViewCell.leagueNameLabel.text = data[indexPath.row]["Sub Category"] as! String?
        
        if rowsToHide.contains(indexPath){
            
            tableViewCell.showAndHideDetailsBtn.isSelected = true
            
        }else{
            
            tableViewCell.showAndHideDetailsBtn.isSelected = false

        }
    }
    
    
    
    //Actions to be performed when showAndHideDetailsBtn is Tapped
    @objc private func showAndHideDetailsBtnTapped(btn : UIButton){
        
        guard let cell = btn.getTableViewCell as? LeagueCell
            else{ return }
        
        if btn.isSelected{
            
            rowsToHide = rowsToHide.filter(){ (index: IndexPath) -> Bool in
                
                return index != cell.tableIndexPath
                
            }
            
            btn.isSelected = false
            
        }
        else{
            rowsToHide.append(cell.tableIndexPath)
            
            btn.isSelected = true
        }
        print(rowsToHide)
        countryWiseTable.reloadRows(at: [cell.tableIndexPath], with: UITableViewRowAnimation.automatic)
    }
    
     //Actions to be performed when showAndHideSectionBtn is Tapped
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
      
        let tableCell = collectionView.getTableViewCell as! LeagueCell
        
            return collectionPicsData[tableCell.tableIndexPath.section][tableCell.tableIndexPath.row].count
       
    }
    
    //returns cells for item
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCell", for: indexPath) as? TeamCell
            else{ fatalError("Cell not found") }

        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        
        let tableCell = collectionView.getTableViewCell as! LeagueCell
        
        guard  let collectionViewCell = cell as? TeamCell else { return }
        
        //Adding target to addToFavouriteButtonOutlet
        collectionViewCell.addToFavouriteButtonOutlet.addTarget(self, action: #selector(addToFavouriteBtnTapped), for: .touchUpInside)
        
        //configuring Collection View Cell
        collectionViewCell.configureCell(withData: collectionPicsData[tableCell.tableIndexPath.section][tableCell.tableIndexPath.row][indexPath.row])

        collectionViewCell.addToFavouriteButtonOutlet.isSelected = collectionPicsData[tableCell.tableIndexPath.section][tableCell.tableIndexPath.row][indexPath.row].isFav
    }
    
    //returns size for item
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: 100, height: 121)
        
    }
    
    //defining what to be done when item is selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! TeamCell
        
        //Making instance of ImagePreviewVC
        guard let previewImage = self.storyboard?.instantiateViewController(withIdentifier: "ImagePreviewVC") as? ImagePreviewVC
            else{ return }
        
        let tableCell = collectionView.getTableViewCell as! LeagueCell
        
        //Transfering data before pushing Navigation Controller
        previewImage.titleText = cell.teamNameLabel.text
        previewImage.imageURL = collectionPicsData[tableCell.tableIndexPath.section][tableCell.tableIndexPath.row][indexPath.row].webformatURL
        
        //Pushing Navigation Controller
        self.navigationController!.pushViewController(previewImage, animated: true)
        
    }
    
    //Actions to be performed when addToFavourateBtn is Tapped
    @objc private func addToFavouriteBtnTapped(btn: UIButton ){
        
        guard let collectionCell = btn.getCollectionViewCell as? TeamCell
            else{ return }
        
        guard let tableCell = btn.getTableViewCell as? LeagueCell
            else{ return }
        
        let collectionIndexPath = tableCell.leagueTeamCollection.indexPath(for: collectionCell)
        
        if btn.isSelected{
            
            btn.isSelected = false
            collectionPicsData[tableCell.tableIndexPath.section][tableCell.tableIndexPath.row][(collectionIndexPath?.row)!].isFav = false
            
        }else{
            btn.isSelected = true
            
            collectionPicsData[tableCell.tableIndexPath.section][tableCell.tableIndexPath.row][(collectionIndexPath?.row)!].isFav = true
            
        }
        
    }
    
    
    
}
