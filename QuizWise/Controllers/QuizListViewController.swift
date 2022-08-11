//
//  QuizListViewController.swift
//  QuizWise
//
//  Created by Sankeeth Naguleswaran on 2022-08-09.
//

import UIKit

class QuizListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var upperContainer: UIView!
    @IBOutlet weak var quizCategoryTableView: UITableView!
    
    var quizData: [Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        //Upper container setup
        upperContainer.layer.cornerRadius = 30
        upperContainer.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        quizCategoryTableView.delegate = self
        quizCategoryTableView.dataSource = self
        
        loadQuizData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let quizCategoryCell = tableView.dequeueReusableCell(withIdentifier: "QuizCategoryCell", for: indexPath) as! QuizCategoryCell
        
        let quizCategory = quizData![indexPath.item] as AnyObject
        
        quizCategoryCell.quizCategoryTitle.text = quizCategory["title"]! as? String
        quizCategoryCell.quizCategoryDescription.text = quizCategory["description"]! as? String
        
        let quizCategoryImageURL: String = quizCategory["cover_image_url"]! as? String ?? ""
        ImageHelper.loadImageOrPlaceholder(from: quizCategoryImageURL, target: quizCategoryCell.quizCategoryImage, placeholder: "quiz category placeholder")
        
        return quizCategoryCell
    }
    
    func loadQuizData() {
        let url = URL(string: "http://de.aliyun.champloo.tech:8000/quiz-wise/get_public_records")
        guard let requestUrl = url else { fatalError() }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        let postString = "{ \"query\": {} }";
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                let quizDict = dataString.toJSON() as? [String: Any]
                self.quizData = quizDict!["records"] as? [Any]
                
                DispatchQueue.main.async {
                    self.quizCategoryTableView.reloadData()
                }
            }
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toQuizCategoryViewController" {
            let destinationVC = segue.destination as! QuizCategoryViewController
            let selectedRow = quizCategoryTableView.indexPathForSelectedRow!.row
            
            destinationVC.quizCategory = quizData![selectedRow] as AnyObject
        }

    }
}

extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}
