//
//  NetworkManager.swift
//  Blu Transfer List
//
//  Created by Amir Hormozi on 8/2/25.
//

import Foundation

struct NetworkManager {
    private func buildURLRequest(apiConfig: APIConfigProtocol) throws -> URLRequest {
        guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else { throw NetworkError.invalidURL }
        guard let url = URL(string: baseURL + apiConfig.url) else { throw NetworkError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = apiConfig.method.rawValue
        request.allHTTPHeaderFields = apiConfig.header
        return request
    }
    
    private func makeRequest(request: URLRequest) async throws -> HTTPResponse<Data> {
        let (data, response) = try await URLSession.shared.data(for: request)
        let httpResponse = HTTPResponse(data: data, response: response)
        guard let httpResponseHandler = httpResponse.response as? HTTPURLResponse, httpResponseHandler.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        return httpResponse
    }
    
    private func decodeRequest<T: Decodable>(data: Data) throws -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decodedData = try decoder.decode(T.self, from: data)
        return decodedData
    }
    
    func performRequest<T: Decodable>(apiConfig: APIConfigProtocol) async throws -> T {
        let request = try buildURLRequest(apiConfig: apiConfig)
        
        let httpResponse = try await makeRequest(request: request)
        let decodedData: T = try decodeRequest(data: httpResponse.data)
        return decodedData
    }
}

