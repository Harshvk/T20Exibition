
import UIKit

class HomePageVC: UIViewController {

    
    
    var favourite = [[IndexPath]]()
    var rowsToHide = [IndexPath]()
    @IBOutlet weak var countryWiseTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let leagueCellNib = UINib(nibName: "LeagueCell", bundle: nil)
        countryWiseTable.register(leagueCellNib, forCellReuseIdentifier: "LeagueCell")
        
        let sectionHeaderNib = UINib(nibName: "SectionHeaderView", bundle: nil)
        countryWiseTable.register(sectionHeaderNib, forHeaderFooterViewReuseIdentifier: "SectionHeaderView")
        
        countryWiseTable.delegate = self
        countryWiseTable.dataSource = self
    
        self.automaticallyAdjustsScrollViewInsets = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
}

extension HomePageVC : UITableViewDelegate , UITableViewDataSource

{
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return JSON.data.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    
    
        let data = DataModel(withJSON: JSON.data[section])
        return data.value.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
    
        guard let cell = countryWiseTable.dequeueReusableCell(withIdentifier: "LeagueCell", for: indexPath) as? LeagueCell
            else{fatalError("Cell not found")}
        if rowsToHide.contains(indexPath){
            
            cell.showAndHideDetailsBtn.isSelected = true
        }
        else{
            cell.showAndHideDetailsBtn.isSelected = false
        }
        
        let data = DataModel(withJSON: JSON.data[indexPath.section])
        
        let tabelData = DataModel(withJSON: data.value[indexPath.row])
        
        cell.configureCell(tabelData)
        
        let nib = UINib(nibName: "TeamCell", bundle: nil)
        
        cell.leagueTeamCollection.register(nib, forCellWithReuseIdentifier: "TeamCell")
        
        cell.showAndHideDetailsBtn.addTarget(self, action: #selector(showAndHideDetailsBtnTapped), for: .touchUpInside)
        
        cell.leagueTeamCollection.dataSource = self
        cell.leagueTeamCollection.delegate = self

        
    
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if rowsToHide.contains(indexPath){
            
            return 21
            
        }
        else{
            
        return 142
            
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let header = countryWiseTable.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeaderView") as? SectionHeaderView
        else{fatalError("Header not found")}
        
        let data = DataModel(withJSON: JSON.data[section])
        header.titleLable.text = data.name
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 33
    
    }
    
    func showAndHideDetailsBtnTapped(btn : UIButton){
        
        let cell = UIView.getDesiredViewCell(givenObjectName: btn, desiredViewName: .UITableViewCell) as! LeagueCell
        
        if btn.isSelected{
            
            rowsToHide.remove(at: rowsToHide.index(of: countryWiseTable.indexPath(for: cell)!)!)
            btn.isSelected = false
            
        }
        else{
            rowsToHide.append(countryWiseTable.indexPath(for: cell)!)
        
            btn.isSelected = true
           
            

        }
         countryWiseTable.reloadRows(at: [countryWiseTable.indexPath(for: cell)!], with: UITableViewRowAnimation.automatic)
    }
}

extension HomePageVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        
        
        return 15
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCell", for: indexPath) as! TeamCell
        cell.addToFavouriteButtonOutlet.addTarget(self, action: #selector(addToFavourateBtnTapped), for: .touchUpInside)
        cell.teamPic.backgroundColor = UIColor.getRandomColor
        let tableCell = UIView.getDesiredViewCell(givenObjectName: collectionView, desiredViewName: .UITableViewCell) as! LeagueCell
        let tableIndexPath = countryWiseTable.indexPath(for: tableCell)
        
        if favourite.contains(where: {      (a : [IndexPath]) -> Bool in
            
            return a == [tableIndexPath!,indexPath]
            
        }){
    
        cell.addToFavouriteButtonOutlet.isSelected = true
        }
        else
        {
            cell.addToFavouriteButtonOutlet.isSelected = false

        }
    
        return cell
 
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: 100, height: 121)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! TeamCell
        
        let previewImage = self.storyboard?.instantiateViewController(withIdentifier: "ImagePreviewVC") as! ImagePreviewVC
        previewImage.titleText = cell.teamNameLabel.text
        previewImage.imageColor = cell.teamPic.backgroundColor
     
        UIView.animate(withDuration: 0.75, animations: { () -> Void in
            UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
            self.navigationController!.pushViewController(previewImage, animated: false)
            UIView.setAnimationTransition(UIViewAnimationTransition.flipFromRight, for: self.navigationController!.view!, cache: false)
        })
        
    }
    
    func addToFavourateBtnTapped(btn: UIButton ){
        
        
        
        let collectionCell = UIView.getDesiredViewCell(givenObjectName: btn,desiredViewName : .UICollectionViewCell) as! TeamCell
         let tableCell = UIView.getDesiredViewCell(givenObjectName: btn,desiredViewName : .UITableViewCell) as! LeagueCell
       
        
        let tableIndexPath = countryWiseTable.indexPath(for: tableCell)
        
        let collectionIndexPath = tableCell.leagueTeamCollection.indexPath(for: collectionCell)
        
        if btn.isSelected{
            
            btn.isSelected = false
            self.favourite.remove(at: favourite.index(where: { (a : [IndexPath]) -> Bool in
                return a == [tableIndexPath!,collectionIndexPath!]
            })!)
            
        }else{
            btn.isSelected = true
            self.favourite.append([tableIndexPath!,collectionIndexPath!])
            
        }
        print(self.favourite)
        
    }
    
   
    
}
