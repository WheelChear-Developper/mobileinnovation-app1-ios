import UIKit
import SwiftyJSON

/**
 //GETリクエストを非同期で送信
 let urlString: String = "https://proport.me?tomo=1&age=12"
 HttpRequestController().sendGetRequestAsynchronous(urlString: urlString, funcs:{(parsedData: [String : Any]) in
    print(parsedData)
 })
 
 //GETリクエストを同期で送信
 let urlString: String = "https://proport.me?tomo=1&age=12"
 let parsedData: [String : Any] = HttpRequestController().sendGetRequestSynchronous(urlString: urlString)
 print(parsedData)
 
 //POSTリクエストを非同期で送信
 let urlString: String = "https://proport.me"
 let post: String = "tomo=1&age=12"
  HttpRequestController().sendPostRequestAsynchronous(urlString: urlString, post: post, funcs:{(parsedData: [String : Any]) in
    print(parsedData)
 })
 
 //POSTリクエストを同期で送信
 let urlString: String = "https://proport.me"
 let post: String = "tomo=1&age=12"
 let parsedData: [String : Any] = HttpRequestController().sendPostRequestSynchronous(urlString: urlString, post: post)
 print(parsedData)
 
 //画像読み込みを非同期で送信
 let urlString: String = ""
 HttpRequestController().sendImageRequestAsynchronous(urlString: urlString, funcs: {(img: UIImage) in
    print("画像のサイズは\(img.size)")
 })
 */

class HttpRequestController {
    let condition = NSCondition()

    func getDomain() -> String {

        let path = Bundle.main.path(forResource: "propaty", ofType: "plist")
        let dictionary = NSDictionary(contentsOfFile: path!)
        #if DEBUG
            // 本体のAPP_CODE取得
            let domainName: AnyObject = dictionary?.object(forKey: "DomainName_Staging") as AnyObject
        #else
            // 本体のAPP_CODE取得
            let domainName: AnyObject = dictionary?.object(forKey: "DomainName_Production") as AnyObject
        #endif

        return domainName as! String
    }
    
    /**
     GETリクエストを非同期で送信
     
     - Parameters:
         - urlString: String型のURL
         - funcs: 非同期で処置が完了した後に実行される関数
     */
    func sendGetRequestAsynchronous(urlString: String, funcs: @escaping (JSON) -> Void){
        var parsedData: JSON = [:]
        var encURL: NSURL = NSURL()
        encURL = NSURL(string:urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
        var r: URLRequest = URLRequest(url: encURL as URL)
        r.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: r) { (data, response, error) in
            
            if error == nil {
                parsedData = JSON(data!)

                funcs(parsedData)
            } else {
                funcs([:])
            }
        }
        task.resume()
    }
    
    /**
     GETリクエストを同期で送信
     
     - Parameter urlString: String型のURL
     - Returns: String型のキーと、Any型の値を持ったDictionary型
     */
    func sendGetRequestSynchronous(urlString: String) -> JSON{
        var parsedData: JSON = [:]
        var encURL: NSURL = NSURL()
        encURL = NSURL(string:urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
        var r = URLRequest(url: encURL as URL)
        r.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: r) { (data, response, error) in
            
            if error == nil {
                parsedData = JSON(data!)
            }
            
            self.condition.signal()
            self.condition.unlock()
        }
        self.condition.lock()
        task.resume()
        self.condition.wait()
        self.condition.unlock()
        
        return parsedData
    }
    
    /**
     POSTリクエストを非同期で送信
     
     - Parameters:
         - urlString: String型のURL
         - post: String型のpost情報(key=value&key2=value2のように指定する)
         - funcs: 非同期で処置が完了した後に実行される関数
     */
    func sendPostRequestAsynchronous(urlString: String, post: String, funcs: @escaping (JSON) -> Void){
        var parsedData: JSON = [:]
        var encURL: NSURL = NSURL()
        encURL = NSURL(string:urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
        var r = URLRequest(url: encURL as URL)
        r.httpMethod = "POST"
        r.httpBody = post.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: r) { (data, response, error) in
            
            if error == nil {
                parsedData = JSON(data!)
            }
            funcs(parsedData)
        }
        task.resume()
    }
    
    /**
     POSTリクエストを同期で送信
     
     - Parameters:
         - urlString: String型のURL
         - post: String型のpost情報(key=value&key2=value2のように指定する)
     
     - Returns: String型のキーと、Any型の値を持ったDictionary型
     */
    func sendPostRequestSynchronous(urlString: String, post: String) -> JSON{
        var parsedData: JSON = [:]
        var encURL: NSURL = NSURL()
        encURL = NSURL(string:urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
        var r = URLRequest(url: encURL as URL)
        r.httpMethod = "POST"
        r.httpBody = post.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: r) { (data, response, error) in
            
            if error == nil {
                parsedData = JSON(data!)
            }
            
            self.condition.signal()
            self.condition.unlock()
        }
        self.condition.lock()
        task.resume()
        self.condition.wait()
        self.condition.unlock()
        
        return parsedData
    }
    
    /**
     画像読み込みを非同期で送信
     
     - Parameters:
        - urlString: String型のURL
        - funcs: 非同期で処置が完了した後に実行される関数
     */
    func sendImageRequestAsynchronous(urlString: String, funcs: @escaping (UIImage) -> Void){
        var encURL: NSURL = NSURL()
        encURL = NSURL(string: urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
        let r = URLRequest(url: encURL as URL)
        NSURLConnection.sendAsynchronousRequest(r, queue:OperationQueue.main){(res, data, err) in
            let httpResponse = res as? HTTPURLResponse
            var image: UIImage = UIImage()
            if data != nil && httpResponse!.statusCode != 404 {
                image = UIImage(data: data!)!
            }
            //関数実行
            funcs(image)
        }
    }
}
