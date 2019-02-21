//
//  NoteboardNoteTableViewCell.swift
//  tempproject
//
//  Created by Jaspreet Kaur on 2019-02-20.
//  Copyright © 2019 kelci huang. All rights reserved.
//

import UIKit

class NoteboardNoteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var noteBodyLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
