//
//  ImagePreviewVC.swift
//  T20Exibition
//
//  Created by appinventiv on 18/02/17.
//  Copyright © 2017 appinventiv. All rights reserved.
//

import UIKit
import AlamofireImage
class ImagePreviewVC: UIViewController {

    //MARK: Properties
    var imageURL : String!
    var titleText : String!
    
    //MARK: IBOutlets
    @IBOutlet weak var enlargedImage: UIImageView!
    @IBOutlet weak var teamTitle: UILabel!
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.moveView))
        enlargedImage.addGestureRecognizer(panGesture)
        enlargedImage.isUserInteractionEnabled = true
    }

    override func viewWillLayoutSubviews() {
        
        let url = URL(string: imageURL)
        enlargedImage.af_setImage(withURL: url!)
        teamTitle.text = titleText
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        

    }
    func moveView(pan : UIPanGestureRecognizer){
        
        let newPoint = pan.translation(in: self.enlargedImage)
        pan.location(in: self.enlargedImage)
        switch pan.state {
        case .began:
            print("began")
        case .changed:
            self.enlargedImage.transform = CGAffineTransform(translationX: newPoint.x, y: newPoint.y)
        case .ended:
            print("ended")

        default:
            print("default")

        }
        
    }


}
