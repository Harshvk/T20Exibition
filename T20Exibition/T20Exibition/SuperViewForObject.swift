import  UIKit
class SuperViewForObject {
    

    func getDesiredViewCell(givenObjectName : Any,desiredViewName : String) -> Any{
        
      var given = givenObjectName
        switch desiredViewName {
        case "UITableViewCell":
            
            while !(given is UITableViewCell){
                
                given = (given as AnyObject).superview as Any
                
            }
        case "UICollectionViewCell":
            
            while !(given is UICollectionViewCell){
                
                given = (given as AnyObject).superview as Any
                
            }
            
        default:
            print("Cell Not Found")
        }

        return  given
    }
    
    

}
