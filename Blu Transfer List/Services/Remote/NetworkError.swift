//
//  NetworkError.swift
//  Blu Transfer List
//
//  Created by Amir Hormozi on 8/2/25.
//

enum NetworkError: String, Error {
    case invalidURL = "Cant access to server"
    case requestFailed = "cant access to server"
    case invalidResponse = "Server error"
}
