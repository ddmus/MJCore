//
//  MJHttpEndpoints.swift
//  MJCore
//
//  Created by Martin Janák on 03/05/2018.
//

import Foundation

public protocol MJHttpEndpoints {
    var domainUrl: String { get }
    var path: String { get }
    var method: MJHttpMethod { get }
    func getPayloadData() throws -> Data?
}
