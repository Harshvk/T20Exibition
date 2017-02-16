
import UIKit

class HomePageVC: UIViewController {

    
    
    static var favourite = [IndexPath]()
    
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
        
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    
    
        return 3
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
    
        guard let cell = countryWiseTable.dequeueReusableCell(withIdentifier: "LeagueCell", for: indexPath) as? LeagueCell
            else{fatalError("Cell not found")}

        
        
        let nib = UINib(nibName: "TeamCell", bundle: nil)
        cell.leagueTeamCollection.register(nib, forCellWithReuseIdentifier: "TeamCell")
        
        cell.leagueTeamCollection.dataSource = self
        cell.leagueTeamCollection.delegate = self

        
    
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 142
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let header = countryWiseTable.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeaderView") as? SectionHeaderView
        else{fatalError("Header not found")}
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 33
    }
}

extension HomePageVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return 15
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCell", for: indexPath)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: 100, height: 121)
        
    }
    
    
}
