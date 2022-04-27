//
//  HTTPClient.swift
//  TWTaskTracker
//
//  Created by Alan Taylor on 26/04/2022.
//

import Foundation

/**
 Convenience enum for HTTP methods.
 To be used instead of manually setting string values for the URLRequest.
 */
enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
    case patch = "PATCH"
}

/**
 Convenience struct which could be used for setting arrays of headers for different request types.
 */
struct HTTPHeaders {
    
    var headers = [String : String]()
    
    init(headers: [String : String] = [String : String]()) {
        self.headers = headers
    }
    
    mutating func setHeader(header: String, value: String) {
        self.headers[header] = value
    }
    
    mutating func addHeaders(headers: [String : String]) {
        self.headers = self.headers.merging(headers, uniquingKeysWith: { (_, last) in last })
    }
}

extension HTTPHeaders: Equatable {
    static func == (lhs: HTTPHeaders, rhs: HTTPHeaders) -> Bool {
        return lhs.headers == rhs.headers
    }
}

extension HTTPHeaders {
    static func initWithJsonHeaders(withAuthToken credentials: String? = nil) -> HTTPHeaders {
        var httpHeaders = ["Content-Type": "application/json",
                           "Accept": "application/json"]
        if let credentials = credentials {
            let authData = (credentials).data(using: .utf8)!.base64EncodedString()
            httpHeaders["Authorization"] = "Basic \(authData)"
        }
        
        return HTTPHeaders(headers: httpHeaders)
    }
    
    static func initWithImageHeaders(withAuthToken token: String? = nil) -> HTTPHeaders {
        var httpHeaders = ["Content-Type": "application/octet-stream"]
        if let token = token {
            httpHeaders["Authorization"] = token
        }
        return HTTPHeaders(headers: httpHeaders)
    }
}

// MARK: - URLSession/Configuration/Response Extensions

/**
 Convenience extension for check if a response code corresponds to a SUCCESS or not.
 */
extension URLResponse {
    var httpStatusCode: Int {
        guard let response = self as? HTTPURLResponse else {
            print("URLResponse.statusCode -> Error: \(String(describing: self))")
            return -999
        }
        return response.statusCode
    }
    
    func isSuccessful() -> Bool {
        return (200...299).contains(self.httpStatusCode)
    }
}

extension URLSessionConfiguration {
    static var roomManagerAPISessionConfiguration: URLSessionConfiguration {
        // https://useyourloaf.com/blog/urlsessionconfiguration-quick-guide/
        let configuration = URLSessionConfiguration.default
        configuration.allowsCellularAccess = true
        configuration.allowsConstrainedNetworkAccess = true
        configuration.allowsExpensiveNetworkAccess = true
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 120
        //configuration.httpAdditionalHeaders = ["User-Agent": UserAgent.shared.userAgentString]
        return configuration
    }
}

extension URLSession {
    // May also need to look into the delegateQueue here. Detailed here also: https://useyourloaf.com/blog/urlsessionconfiguration-quick-guide/
    // Looks like this will ensure the delegateQueue is using the Main thread?
    // Should we keep all that off the main UI thread and dispatch back to the UI thread once all processing is done?
    static let roomManagerAPISession = URLSession(configuration: URLSessionConfiguration.roomManagerAPISessionConfiguration, delegate: nil, delegateQueue: OperationQueue.main)
}

// MARK: - HTTPClient Protocol

protocol HTTPClientProtocol {
    func execute<T>(request: T, completion: @escaping (Result<T.ModelType, APIError>) -> Void) where T : APIRequest
}

extension HTTPClientProtocol {
    fileprivate func processResponse<T>(forRequest apiRequest: T, data: Data?, response: URLResponse?, error: Error?) -> Result<T.ModelType, APIError> where T : APIRequest {
        // Check for an error
        if let error = error {
            print("Error: \(error.localizedDescription)")
            return .failure(.error(error: error))
        }
        
        // Ensure response object is not nil
        guard let response = response else {
            print("Response Error: \(String(describing: response))")
            return .failure(.noResponse)
        }
        
        // Ensure there is data to parse
        guard let data = data else {
            print("Data Error: \(String(describing: data))")
            return .failure(.noData)
        }
        
        // Check if response if not successful
        if !response.isSuccessful() {
            print(String.init(data: data, encoding: .utf8) ?? "Data could not be converted to String")
            
            if let errorMessage = try? JSONDecoder().decode(ErrorMessage.self, from: data) {
                // Attempt to parse error message from API
                return .failure(.api(message: errorMessage.message, responseCode: response.httpStatusCode))
            } else {
                // Could not parse an error message, return the error code.
                return .failure(.api(message: nil, responseCode: response.httpStatusCode))
            }
        }
        // Response should be fine
        return apiRequest.decode(data)
    }
}

// MARK: - HTTPClient

class HTTPClient: HTTPClientProtocol {
    
    private var session: URLSession
    
    init(session: URLSession = URLSession.roomManagerAPISession) {
        self.session = session
    }
    
    func createRequest(url: URL, httpMethod: HTTPMethod, headers: HTTPHeaders?, body: Data?) -> URLRequest {
        var request = URLRequest.init(url: url)
        request.httpMethod = httpMethod.rawValue
        if let headers = headers {
            for (header, value) in headers.headers {
                request.setValue(value, forHTTPHeaderField: header)
            }
        }
        if let body = body {
            request.httpBody = body
        }
        return request
    }
    
    func execute<T>(request: T, completion: @escaping (Result<T.ModelType, APIError>) -> Void) where T : APIRequest {
        let urlRequest = self.createRequest(url: request.url, httpMethod: request.httpMethod, headers: request.headers, body: request.body)
        let task = self.session.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let result = self?.processResponse(forRequest: request, data: data, response: response, error: error) else {
                print("HTTPClient Error: self was nil after request was completed.")
                completion(.failure(.unknown))
                return
            }
            completion(result)
        }
        task.resume()
    }
}

