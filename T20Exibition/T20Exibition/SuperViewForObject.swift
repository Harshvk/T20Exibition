import  UIKit
extension UIView {
    

    enum superviewType{
        
        case UITableViewCell,UICollectionViewCell
        
    }
    
    static func getDesiredViewCell(givenObjectName : Any,desiredViewName : superviewType) -> Any{
        
      var given = givenObjectName
        switch desiredViewName {
        case .UITableViewCell :
            
            while !(given is UITableViewCell){
                
                given = (given as AnyObject).superview as Any
                
            }
        case .UICollectionViewCell :
            
            while !(given is UICollectionViewCell){
                
                given = (given as AnyObject).superview as Any
                
            }
            
        }

        return  given
    }
    
    

}
