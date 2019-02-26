//
//  ELBibleChooseBookChapterTableViewCell.swift
//  TemplateApp
//
//  Created by kelci huang on 2018-12-01.
//  Copyright © 2018 kelci huang. All rights reserved.
//

import UIKit

class SettingsChooseDateTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateSubLabel: UILabel!
    @IBOutlet weak var dateListTopPaddingView: UIView!
    @IBOutlet weak var dateListView: UIView!
    
    @IBOutlet weak var alDateListTopPaddingViewHeight: NSLayoutConstraint!
    @IBOutlet weak var alDateHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
