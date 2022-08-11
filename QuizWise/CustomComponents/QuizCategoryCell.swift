//
//  QuizCategoryCell.swift
//  QuizWise
//
//  Created by Sankeeth Naguleswaran on 2022-08-09.
//

import UIKit

class QuizCategoryCell: UITableViewCell {

    // MARK:- Outlets
    @IBOutlet weak var quizCategoryTitle: UILabel!
    @IBOutlet weak var quizCategoryDescription: UILabel!
    @IBOutlet weak var quizCategoryImage: UIImageView!
    @IBOutlet weak var quizCellContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        quizCellContainer.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
