
import UIKit
import Alamofire
import AlamofireImage
class TeamCell: UICollectionViewCell {

    @IBOutlet weak var addToFavouriteButtonOutlet: UIButton!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var teamPic: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func prepareForReuse() {
        super.prepareForReuse()

    }
    
    func configureCell(withData data: ImageInfo)
    {
        let URL = NSURL(fileURLWithPath: data.webformatURL) as URL
        teamPic.af_setImage(withURL: URL)
        teamNameLabel.text = data.id
        
    }

}
