//
//  ImagePreviewVC.swift
//  T20Exibition
//
//  Created by appinventiv on 18/02/17.
//  Copyright © 2017 appinventiv. All rights reserved.
//

import UIKit

class ImagePreviewVC: UIViewController {

    var imageColor : UIColor!
    var titleText : String!
    
    @IBOutlet weak var enlargedImage: UIImageView!
    @IBOutlet weak var teamTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillLayoutSubviews() {
        enlargedImage.backgroundColor = imageColor
        teamTitle.text = titleText
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIView.animate(withDuration: 0.75, animations: { () -> Void in
            UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
        
            UIView.setAnimationTransition(UIViewAnimationTransition.flipFromLeft, for: self.navigationController!.view!, cache: false)
        })
    }


}
