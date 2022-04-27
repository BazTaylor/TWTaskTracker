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
    //TODO: Add getAllTasks protocol
    //TODO: Add addNewTask protocol
}

// MARK: - Room Service
class TaskService: TaskServiceProtocol {
    
    private let httpClient: HTTPClientProtocol
    
    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }
    
    //TODO: Add getAllTasks protocol
    //TODO: Add addNewTask protocol
}
