//: [Previous](@previous)

import Foundation

enum DecodingError: Error {
   case unknown
   case invalidRange
}

struct Employee: Codable {
   var name: String
   var age: Int
   var address: String?
   
    // 대상 속성(address)만 Custom Key Mapping
     enum CodingKeys: String, CodingKey {
         case name
         case age
         case address = "homeAddress"
     }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        
        age = try container.decode(Int.self, forKey: .age)
        guard (30...60).contains(age) else {
            throw DecodingError.invalidRange
        }
        
        address = try container.decodeIfPresent(String.self, forKey: .address)
    }
}

let jsonStr = """
{
"name" : "John",
"age" : 30,
"homeAddress" : "Seoul"
}
"""

guard let jsonData = jsonStr.data(using: .utf8) else {
   fatalError()
}

let decoder = JSONDecoder()

do {
   let e = try decoder.decode(Employee.self, from: jsonData)
   dump(e)
} catch {
   print(error)
}



//: [Next](@next)
