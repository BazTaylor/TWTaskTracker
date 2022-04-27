//
//  ViewController.swift
//  TWTaskTracker
//
//  Created by Alan Taylor on 26/04/2022.
//

import UIKit

class ViewController: UIViewController {

    let httpClient = HTTPClient()
    var taskService: TaskService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAllTasks()
    }

    func getAllTasks() {
        self.taskService = TaskService(httpClient: self.httpClient)
        self.taskService?.getAllTasks{ [weak self] result in
            switch result {
            case .success(let tasks):
                print(tasks)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}

