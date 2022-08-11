//
//  ResultViewController.swift
//  QuizWise
//
//  Created by Sankeeth Naguleswaran on 2022-08-09.
//

import UIKit

protocol RestartQuiz {
    func restartQuizAgain()
}

class ResultViewController: UIViewController {

    var delegate: RestartQuiz?

    //Outlet declaration
    @IBOutlet weak var mainQuizContainer: UIView!
    @IBOutlet weak var mainMenuOutlet: UIButton!
    @IBOutlet weak var restartQuizOutlet: UIButton!
    @IBOutlet weak var totalQuestionsLabel: UILabel!
    @IBOutlet weak var correctAnswersLabel: UILabel!
    @IBOutlet weak var marksLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultViewContainer: UIView!
    @IBOutlet weak var lowerContainer: UIView!

    var correctAnswerWithTotalQuestions: [Int]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        //Container shape
        mainQuizContainer.layer.cornerRadius = 30

        //Button setup
        mainMenuOutlet.layer.cornerRadius = 15
        mainMenuOutlet.layer.borderWidth = 3
        mainMenuOutlet.layer.borderColor = UIColor(red:0.38, green:0.52, blue:0.73, alpha:1.0).cgColor
        restartQuizOutlet.layer.cornerRadius = 15
        restartQuizOutlet.layer.borderWidth = 3
        restartQuizOutlet.layer.borderColor = UIColor(red:0.38, green:0.52, blue:0.73, alpha:1.0).cgColor

        //Set result labels with values
        if let receivedScores = self.correctAnswerWithTotalQuestions {
            let correctAnswers = receivedScores[0]
            let totalQuestions = receivedScores[1]
            let percentage = Int(round((Double(correctAnswers)/Double(totalQuestions)) * 100))
            
            totalQuestionsLabel.text = String(totalQuestions)
            correctAnswersLabel.text = String(correctAnswers)
            marksLabel.text = "\(correctAnswers)/\(totalQuestions)"

            if percentage >= 45 {
                resultLabel.textColor = UIColor.green
                resultLabel.text = "Pass"
            } else {
                resultLabel.textColor = UIColor.red
                resultLabel.text = "Fail"
            }
        }
    }

    @IBAction func restartQuizButtonPressed(_ sender: UIButton) {
        delegate?.restartQuizAgain()

        dismiss(animated: true, completion: nil)
    }

    @IBAction func mainMenuButtonPressed(_ sender: UIButton) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }

}
