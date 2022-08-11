//
//  QuizViewController.swift
//  QuizWise
//
//  Created by Sankeeth Naguleswaran on 2022-08-09.
//

import UIKit

class QuizViewController: UIViewController {
    
    @IBOutlet weak var mainQuizContainer: UIView!
    @IBOutlet weak var quizImageView: UIImageView!
    @IBOutlet weak var option1ButtonOutlet: UIButton!
    @IBOutlet weak var option2ButtonOutlet: UIButton!
    @IBOutlet weak var option3ButtonOutlet: UIButton!
    @IBOutlet weak var option4ButtonOutlet: UIButton!
    @IBOutlet weak var nextFinishButtonOutlet: UIButton!
    @IBOutlet weak var questionStatusLabelOutlet: UILabel!
    @IBOutlet weak var scoreStatusLabelOutlet: UILabel!
    @IBOutlet weak var exitButtonOutlet: UIButton!
    
    var optionButtons = [UIButton]()
    var questions: [AnyObject]?
    var totalQuestions: Int = 0
    var questionStatus: Int = 1
    var correctAnswers: Int = 0
    var isCorrect: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        //Assigning option buttons to the array
        optionButtons = [option1ButtonOutlet, option2ButtonOutlet, option3ButtonOutlet, option4ButtonOutlet]


        //MARK: - Interface Design
        //Container shape
        mainQuizContainer.layer.cornerRadius = 30

        //Option button design
        for button in optionButtons {
            button.layer.cornerRadius = 6
            button.layer.borderWidth = 3
        }

        //Finish/next button design
        nextFinishButtonOutlet.layer.cornerRadius = 6

        resetUpdateOptionButtonBorderColor()
        totalQuestions = (questions?.count)!
        getQuestions()
        
    }
    
    func getQuestions() {
        assignQuestionToTheQuizContainer()
        updateUI()
    }
    
    func resetUpdateOptionButtonBorderColor() {
        for button in optionButtons {
            button.layer.borderColor = UIColor.gray.cgColor
        }
    }
    
    func assignQuestionToTheQuizContainer() {
        let question = questions![questionStatus - 1]
        
        let questionImage = question["image_url"] as? String ?? ""
        ImageHelper.loadImageOrPlaceholder(from: questionImage, target: quizImageView, placeholder: "quiz image placeholder")
        
        let choices = question["choices"] as? [String] ?? []
        var choiceArrayIndex: Int = 0
        for button in optionButtons {
            button.setTitle(choices[choiceArrayIndex], for: .normal)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            choiceArrayIndex += 1
        }
    }
    
    func updateUI() {
        nextFinishButtonOutlet.setTitle( (questions?.count == questionStatus) ? "Finish" : "Next >", for: .normal)
        scoreStatusLabelOutlet.text = "Score \(correctAnswers)/\(questionStatus)"
        questionStatusLabelOutlet.text = "Question \(questionStatus)/\(totalQuestions)"
        nextFinishButtonOutlet.isEnabled = true
    }
    
    @IBAction func optionButtonClicked(_ sender: UIButton) {
        isCorrect = false
        nextFinishButtonOutlet.isEnabled = true

        optionButtonsInteraction(is: false)
        checkAnswer(for: sender)

    }
    
    func optionButtonsInteraction(is Enabled: Bool) {
        for button in optionButtons {
            button.isUserInteractionEnabled = Enabled
        }
    }
    
    func checkAnswer(for sender: UIButton) {
        let question = questions![questionStatus - 1]
        
        let pickedAnswer: String = sender.currentTitle!
        let correctAnswer: String = question["answer"] as? String ?? ""
        
        isCorrect = (pickedAnswer == correctAnswer)
        
        if isCorrect {
            sender.layer.borderColor = UIColor.green.cgColor
            updateUI()
        } else {
            sender.layer.borderColor = UIColor.red.cgColor
            
            for button in optionButtons {
                if button.currentTitle == correctAnswer {
                    button.layer.borderColor = UIColor.green.cgColor
                }
            }
        }
    }
    
    @IBAction func nextFinishButtonPressed(_ sender: UIButton) {
        nextFinishButtonOutlet.isEnabled = false
        
        if option1ButtonOutlet.isUserInteractionEnabled {
            // Validation - Choose an answer to move to the next quiz
        } else if (questions?.count)! == questionStatus {
            if isCorrect {
                correctAnswers += 1
            }
            
            performSegue(withIdentifier: "toResultViewController", sender: self)
        } else {
            if isCorrect{
                correctAnswers += 1
            }
            
            questionStatus += 1
            assignQuestionToTheQuizContainer()
            resetUpdateOptionButtonBorderColor()
            optionButtonsInteraction(is: true)
            updateUI()
        }
    }
    
    @IBAction func quitButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toResultViewController", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResultViewController" {
            let destinationViewController = segue.destination as! ResultViewController
            destinationViewController.modalPresentationStyle = .fullScreen
            destinationViewController.correctAnswerWithTotalQuestions = [correctAnswers, totalQuestions]
            destinationViewController.delegate = self
        }
    }
}


extension QuizViewController: RestartQuiz {
    func restartQuizAgain() {
        questionStatus = 1
        correctAnswers = 0
        assignQuestionToTheQuizContainer()
        resetUpdateOptionButtonBorderColor()
        optionButtonsInteraction(is: true)
        updateUI()
    }
}
