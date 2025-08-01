//
//  NetworkManager.swift
//  ArtGallery
//
//  Created by Varshitha VRaj on 20/07/25.
//

import Foundation


enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol APIRequest {
    var url: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
}


class NetworkService {
    private let requestBuilder: RequestBuilderProtocol
    private let responseParser: ResponseParserProtocol
    private let session: URLSession

    init(
        requestBuilder: RequestBuilderProtocol = RequestBuilder(),
        responseParser: ResponseParserProtocol = ResponseParser(),
        session: URLSession = .shared
    ) {
        self.requestBuilder = requestBuilder
        self.responseParser = responseParser
        self.session = session
    }

    func request<T: Decodable>(
        _ apiRequest: APIRequest,
        responseType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let request = requestBuilder.buildRequest(from: apiRequest) else {
            completion(.failure(.invalidURL))
            return
        }

        let task = session.dataTask(with: request) { data, _, error in
            if let _ = error {
                completion(.failure(.requestFailed))
                return
            }

            guard let data = data else {
                completion(.failure(.requestFailed))
                return
            }

            completion(self.responseParser.parse(data, as: responseType))
        }

        task.resume()
    }
}



protocol RequestBuilderProtocol {
    func buildRequest(from apiRequest: APIRequest) -> URLRequest?
}

class RequestBuilder: RequestBuilderProtocol {
    func buildRequest(from apiRequest: APIRequest) -> URLRequest? {
        guard let url = URL(string: apiRequest.url) else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = apiRequest.method.rawValue
        apiRequest.headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        request.httpBody = apiRequest.body

        return request
    }
}

protocol ResponseParserProtocol {
    func parse<T: Decodable>(_ data: Data, as type: T.Type) -> Result<T, NetworkError>
}

class ResponseParser: ResponseParserProtocol {
    func parse<T: Decodable>(_ data: Data, as type: T.Type) -> Result<T, NetworkError> {
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return .success(decoded)
        } catch {
            return .failure(.decodingFailed)
        }
    }
}
