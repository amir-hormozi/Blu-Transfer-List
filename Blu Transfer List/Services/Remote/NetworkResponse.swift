//
//  NetworkResponse.swift
//  Blu Transfer List
//
//  Created by Amir Hormozi on 8/2/25.
//

import Foundation

struct HTTPResponse<T> {
    let data: T
    let response: URLResponse
}
