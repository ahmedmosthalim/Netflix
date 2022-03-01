//
//  MoviesGenresTableViewCell.swift
//  Netflix
//
//  Created by Ahmed Mostafa on 07/02/2022.
//

import UIKit

class MoviesGenresTableViewCell: UITableViewCell {

    @IBOutlet weak var genreLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
