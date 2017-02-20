import  UIKit
extension UIView {
    
    var getTableViewCell : UITableViewCell?{
        
        var subview = self
        
        while !(subview is UITableViewCell){
            
            guard let s = subview.superview  else { return nil }
            subview = s
            
        }
        
        return subview as? UITableViewCell
        
    }
    
    var getCollectionViewCell : UICollectionViewCell?{
        
        var subview = self
        
        while !(subview is UICollectionViewCell){
            
            guard let s = subview.superview  else { return nil}
            subview = s
            
        }
        
        return subview as? UICollectionViewCell
        
    }
    
    var getTableViewHeaderFooterView : UITableViewHeaderFooterView?{
        
        var subview = self
        
        while !(subview is UITableViewHeaderFooterView){
            
            guard let s = subview.superview  else { return nil}
            subview = s
            
        }
        
        return subview as? UITableViewHeaderFooterView
        
    }
    

}

extension UIColor
{
    static var randomColor : UIColor{
        
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }
    
}
