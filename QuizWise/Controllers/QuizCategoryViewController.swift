//
//  QuizCategoryViewController.swift
//  QuizWise
//
//  Created by Sankeeth Naguleswaran on 2022-08-09.
//

import UIKit

class QuizCategoryViewController: UIViewController {
    
    @IBOutlet weak var upperContainer: UIView!
    @IBOutlet weak var startButtonOutlet: UIButton!
    @IBOutlet weak var quizCategoryTitle: UILabel!
    @IBOutlet weak var quizCategoryDescription: UILabel!
    @IBOutlet weak var quizCategoryImage: UIImageView!
    
    var quizCategory: AnyObject?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        //Upper container setup
        upperContainer.layer.cornerRadius = 30
        upperContainer.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        startButtonOutlet.layer.cornerRadius = 10
        startButtonOutlet.layer.borderWidth = 2.5
        startButtonOutlet.layer.borderColor = UIColor.gray.cgColor
        
        quizCategoryTitle.text = quizCategory!["title"]! as? String
        quizCategoryDescription.text = quizCategory!["description"]! as? String
        
        let quizCategoryImageURL: String = quizCategory!["cover_image_url"]! as? String ?? ""
        ImageHelper.loadImageOrPlaceholder(from: quizCategoryImageURL, target: quizCategoryImage, placeholder: "quiz category placeholder")
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toQuizViewController" {
            let destinationVC = segue.destination as! QuizViewController
            destinationVC.questions = quizCategory!["quizzes"]! as? [AnyObject]
        }

    }
}
