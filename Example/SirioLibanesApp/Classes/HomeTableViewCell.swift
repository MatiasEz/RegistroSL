//
//  HomeTableViewCell.swift
//  SirioLibanesApp_Example
//
//  Created by Federico Bustos Fierro on 2/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var colorbox: UIView!
    @IBOutlet weak var cardboard: UIView!
    @IBOutlet open weak var hoy: UIButton!
    @IBOutlet open weak var redes: UIButton!
    @IBOutlet open weak var titlecustomLabel: UILabel!
    @IBOutlet open weak var descriptioncustomLabel: UILabel!
    open var asociatedDictionary : [AnyHashable: Any] = [:]
    @IBOutlet open weak var dateLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.backgroundView?.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        self.cardboard.layer.cornerRadius = 10
    }

}
