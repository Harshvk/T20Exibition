class DataModel{
    
    
    let name : String!
    let value : [[String:Any]]!
 
    init(withJSON data : [String:Any])
    {
        name = data["Name"] as! String
        value = data["Value"] as! [[String : Any]]
    }
}
