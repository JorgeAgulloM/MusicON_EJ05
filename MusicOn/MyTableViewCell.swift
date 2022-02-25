//
//  MyTableViewCell.swift
//  MusicOn
//
//  Created by Jorge Agullo Martin on 24/2/22.
//

import UIKit

protocol MyCellDelegate {
    func callPressed(name: String)
}

class MyTableViewCell: UITableViewCell {

    @IBOutlet weak var titleCell: UILabel!
    @IBOutlet weak var authorCell: UILabel!
    @IBOutlet weak var imageSound: UIImageView!
    @IBOutlet weak var iconSound: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
