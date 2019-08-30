//
//  PronosticoTableViewCell.swift
//  WeatherTest
//
//  Created by Tomas Moran on 29/08/2019.
//  Copyright © 2019 Tomas Moran. All rights reserved.
//

import UIKit

class PronosticoTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(withData data:PronosticoModel) {
        self.timeLabel.text = data.time
        self.dateLabel.text = data.temp
        self.iconImage.image = UIImage(named: data.weatherIcon ?? "dunno")
    }

}
