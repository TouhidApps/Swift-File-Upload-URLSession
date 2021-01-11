//
//  FileUploadManager.swift
//  URLSession-File-Upload
//
//  Created by Touhid on 7/1/21.
//

import Foundation

class FileUploadManager : NSObject {
    
    func convertFormField(named name: String, value: String, using boundary: String) -> String {
      var fieldString = "--\(boundary)\r\n"
      fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
      fieldString += "\r\n"
      fieldString += "\(value)\r\n"

      return fieldString
    } // convertFormField

    func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
      let data = NSMutableData()

      data.appendString("--\(boundary)\r\n")
      data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
      data.appendString("Content-Type: \(mimeType)\r\n\r\n")
      data.append(fileData)
      data.appendString("\r\n")

      return data as Data
    } // convertFileData
    
    // File Upload Request
    func uploadRequest(urlPath: String, imageData: Data?, imageDataFieldName: String, formFields: [String : String]) {
        
        let boundary = "Boundary-\(UUID().uuidString)"

        var request = URLRequest(url: URL(string: urlPath)!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let httpBody = NSMutableData()

        for (key, value) in formFields {
          httpBody.appendString(convertFormField(named: key, value: value, using: boundary))
        }

        if let iData = imageData {
            httpBody.append(convertFileData(fieldName: imageDataFieldName,
                                            fileName: "imagename.png",
                                            mimeType: "image/png",
                                            fileData: iData,
                                            using: boundary))
        }
        
        httpBody.appendString("--\(boundary)--")

        request.httpBody = httpBody as Data

     //   print(String(data: httpBody as Data, encoding: .utf8)!)

        URLSession.shared.dataTask(with: request) { data, response, error in
          // Handle the response here
            guard let data = data, error == nil else { return }
            let dataString = String(NSString(data: data, encoding: String.Encoding.utf8.rawValue) ?? "")

            print("Print response: \(dataString)")
            
        }.resume()
         
        
    } // uploadRequest
    
} // FileUploadManager

extension NSMutableData {
  func appendString(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}
