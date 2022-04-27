//
//  TaskServiceRequests.swift
//  TWTaskTracker
//
//  Created by Alan Taylor on 27/04/2022.
//

import Foundation
import UIKit

class GetAllTasksRequest: APIRequest {
    typealias ModelType = [Task]
    
    var url: URL
    var httpMethod: HTTPMethod
    var headers: HTTPHeaders?
    var body: Data?
    
    init(serviceUrl: String) {
        self.url = URL(string: serviceUrl)!
        self.httpMethod = .get
        self.headers = HTTPHeaders.initWithJsonHeaders(withAuthToken: "yat@triplespin.com:yatyatyat27")
    }
    
    func decode(_ data: Data) -> Result<[Task], APIError> {
        do {
            let motorsResponse = try JSONDecoder().decode(TaskResponse.self, from: data)
            print(motorsResponse.tasks.count)
            return .success(motorsResponse.tasks)
        } catch {
            print(String(describing: error))
            return .failure(.decodeError(error: error))
        }
    }
}
