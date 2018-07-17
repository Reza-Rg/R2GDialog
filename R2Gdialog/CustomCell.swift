//
//  CustomCell.swift
//  R2Gdialog
//
//  Created by RezaRg on 7/17/18.
//  Copyright © 2018 Reza Rg. All rights reserved.
//

import Foundation
import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet var dialogName : UILabel!
    @IBOutlet weak var labelHolderView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let color = self.labelHolderView!.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        self.labelHolderView?.backgroundColor = color
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let color = self.labelHolderView!.backgroundColor
        super.setSelected(selected, animated: animated)
        self.labelHolderView?.backgroundColor = color
    }
    
}
