//
//  ELBibleChooseBookChapterTableViewCell.swift
//  TemplateApp
//
//  Created by kelci huang on 2018-12-01.
//  Copyright © 2018 kelci huang. All rights reserved.
//

import UIKit

class SettingsChooseDateTableViewCell: UITableViewCell {

    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var bookFullNameLabel: UILabel!
    @IBOutlet weak var chapterListTopPaddingView: UIView!
    @IBOutlet weak var chapterListView: UIView!
    
    @IBOutlet weak var alChapterListTopPaddingViewHeight: NSLayoutConstraint!
    @IBOutlet weak var alChapterListViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
