//
//  APIRequest.swift
//  TWTaskTracker
//
//  Created by Alan Taylor on 26/04/2022.
//

import Foundation

/**
 Protocol defining what is required for all API Request
 */
protocol APIRequest {
    /**
     Generic associated Type which class conforming to this protocol will need to alias.
     */
    associatedtype ModelType
    
    /**
     API request URL
     */
    var url: URL { get }
    /**
     API request HTTP Method i.e. GET, POST, etc.
     */
    var httpMethod: HTTPMethod { get }
    /**
     API Request Headers
     */
    var headers: HTTPHeaders? { get }
    /**
     API Request Body
     */
    var body: Data? { get }
    
    /**
     Decode the response Data to a ModelType
     */
    func decode(_ data: Data) -> Result<ModelType, APIError>
}

