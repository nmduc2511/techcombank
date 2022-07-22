//
//  MenuItemCell.swift
//  Foody
//
//  Created by duc nguyen on 21/07/2022.
//

import UIKit
import SDWebImage

class MenuItemCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bindingData(_ obj: Any) {
        let drink = obj as? DrinkModel
        titleLabel.text = drink?.title
        descriptionLabel.text = drink?.description
        imgView.sd_setImage(with: URL(string: drink?.url ?? ""), completed: nil)
    }
}
