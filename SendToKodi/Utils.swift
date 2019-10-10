

import Cocoa

struct Utils {
    
    static func generateRequestDataFromUrl(_ url: URL) -> Data! {
        return ("{\"jsonrpc\": \"2.0\", \"method\": \"Player.Open\", \"params\": " +
            "{\"item\": {\"file\" : \"plugin://plugin.video.sendtokodi/?\(url)\" }}, \"id\" : \"0\"}")
            .data(using: String.Encoding.utf8)
    }
    
    static func sendRequestToKodi(_ url: URL, completionHandler: (() -> ())?, errorHandler: ((Error) -> ())?) {
        let session = URLSession.shared
        let hostname = UserDefaults(suiteName: USER_DEFAULTS_SUITE)!.string(forKey: "kodi_hostname")!
        
        let requestData = self.generateRequestDataFromUrl(url)
        
        let request = NSMutableURLRequest(url: URL(string: "http://\(hostname):8080/jsonrpc")!)
        request.httpMethod = "POST"
        request.setValue("application/json",         forHTTPHeaderField: "Accept")
        request.setValue("application/json",         forHTTPHeaderField: "Content-Type")
        request.setValue(String(describing: requestData?.count), forHTTPHeaderField: "Content-Length")
        request.httpBody = requestData
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            data, response, error in
            
            if let error = error {
                errorHandler?(error)
            }
            else {
                completionHandler?()
            }
        })
        task.resume()
    }
}
