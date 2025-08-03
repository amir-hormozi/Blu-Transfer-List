//
//  APICofig.swift
//  Blu Transfer List
//
//  Created by Amir Hormozi on 8/2/25.
//

protocol APIConfigProtocol {
    var url: String { set get}
    var method: RequestMethod { set get}
    var header: [String: String] { set get}
}
