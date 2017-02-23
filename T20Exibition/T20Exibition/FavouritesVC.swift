import UIKit

class FavouritesVC: UIViewController {

    var favData = [ImageInfo]()
    
    @IBOutlet weak var favouriteCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.favouriteCollection.delegate = self
        self.favouriteCollection.dataSource = self

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

class FavouriteCell : UICollectionViewCell {
    
    
    @IBOutlet weak var favPics: UIImageView!
    
    
    
}

extension FavouritesVC : UICollectionViewDataSource ,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return favData.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteCell", for: indexPath) as! FavouriteCell
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        
        guard let favCell = cell as? FavouriteCell else { return }
        
        let picURL = URL(string : favData[indexPath.row].previewURL)
        favCell.favPics.af_setImage(withURL: picURL!)
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: 108, height: 129)
    }
    
    
}
