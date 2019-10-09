//
//  TouchFrameworkView.swift
//  TouchFramework
//
//  Created by Das on 10/9/19.
//  Copyright © 2019 Arunabh Das. All rights reserved.
//

import UIKit

class TouchFrameworkView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var subheadLabel: UILabel!
    
    
    let nibName = "TouchFrameworkView"
    var contentView: UIView!

    // MARK: Set Up View
    public override init(frame: CGRect) {
     // For use in code
      super.init(frame: frame)
      setUpView()
    }

    public required init?(coder aDecoder: NSCoder) {
       // For use in Interface Builder
       super.init(coder: aDecoder)
      setUpView()
    }
    
    private func setupView() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.nibName, bundle: bundle)
        self.contentView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        contentView.center = self.center
        contentView.autoresizingMask = []
        contentView.translatesAutoresizingMaskIntoConstraints = true
        
        headlineLabel.text = ""
        subheadLabel.text = ""
    }
}
