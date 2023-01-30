//: [Previous](@previous)

import Foundation

struct Person: Codable {
   var firstName: String
   var lastName: String
   var age: Int
   var address: String?
}

let jsonStr = """
{
"firstName" : "John",
"age" : 30,
"lastName" : "Doe",
"address" : "Seoul"
}
"""

guard let jsonData = jsonStr.data(using: .utf8) else {
   fatalError()
}

//
let decoder = JSONDecoder()

do {
    let p = try decoder.decode(Person.self, from: jsonData)
    dump(p) // 딕셔너리를 콘솔에 찍을 때 유용
} catch {
    print(error)
}
//


//: [Next](@next)

// swift 객체(struct) -> JSON Encoding -> 바이너리 -> URLRequest -> 바이너리 -> JSON Decoding -> swift 객체(struct)

