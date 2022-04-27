//
//  TaskService.swift
//  TWTaskTracker
//
//  Created by Alan Taylor on 27/04/2022.
//

import Foundation
import UIKit

// MARK: - Task Service Protocol

protocol TaskServiceProtocol {
    func getAllTasks(completion: @escaping (Result<[Task], APIError>) -> Void)
    
    //TODO: Add addNewTask protocol
}

// MARK: - Room Service
class TaskService: TaskServiceProtocol {
    private let httpClient: HTTPClientProtocol
    
    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }
    
    func getAllTasks(completion: @escaping (Result<[Task], APIError>) -> Void) {
        let serviceUrl = "https://yat.teamwork.com/projects/api/v3/tasks.json"
        let request = GetAllTasksRequest(serviceUrl: serviceUrl)
        self.httpClient.execute(request: request, completion: completion)
    }
    //TODO: Add addNewTask protocol
}
