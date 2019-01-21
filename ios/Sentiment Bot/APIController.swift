//
//  APIController.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/9/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit
import JWTDecode


class APIController {
    
    static let shared = APIController()
    
    //Signup User
    func signUp(firstName: String, lastName: String, email: String, password: String, completion: @escaping (ErrorMessage?) -> Void = {_  in }){
        let url = baseUrl.appendingPathComponent("users")
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        let userParams = ["firstName": firstName, "lastName": lastName, "email": email, "password": password] as [String: Any]
        do {
            let json = try JSONSerialization.data(withJSONObject: userParams, options: .prettyPrinted)
            request.httpBody = json
        } catch {
            NSLog("Error encoding JSON")
            return
        }
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if let error = error {
                NSLog("There was an error signup up the user: \(error)")
                return
            }
            
            guard let data = data else {
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code from the http request: \(httpResponse.statusCode)")
                let errorMessage = try! JSONDecoder().decode(ErrorMessage.self, from: data)
                completion(errorMessage)
                return
            }
            
            NSLog("Successfully signed up User")
            
            self.logIn(email: email, password: password, completion: { (_) in
                completion(nil)
            })
            
            }.resume()
    }
    
    //Login User
    func logIn(email: String, password: String, completion: @escaping (ErrorMessage?) -> Void) {
        let url = baseUrl.appendingPathComponent("tokens")
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        let userParams = ["email": email, "password": password] as [String: Any]
        do {
            let json = try JSONSerialization.data(withJSONObject: userParams, options: .prettyPrinted)
            request.httpBody = json
        } catch {
            NSLog("Error encoding JSON")
        }
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if let error = error {
                NSLog("There was an error logging in the user: \(error)")
                return
            }
            
            guard let data = data else {
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code from the http request: \(httpResponse.statusCode)")
                let errorMessage = try! JSONDecoder().decode(ErrorMessage.self, from: data)
                completion(errorMessage)
                return
            }
            
            do {
                let jwtToken = try JSONDecoder().decode(JWT.self, from: data)
                let jwt = try decode(jwt: jwtToken.jwt)
                let userId = jwt.body["id"] as! Int
                let token = jwt.string
                self.saveCurrentUser(userId: userId, token: token)
            } catch {
                NSLog("Error decoding JSON Web Token \(error)")
                return
            }
            
            NSLog("Successfully logged in User")
            
            completion(nil)
        }.resume()
    }
    
    //Get User through userId
    func getUser(userId: Int, completion: @escaping (User?, Error?) -> Void) {
        let url = baseUrl.appendingPathComponent("users")
                         .appendingPathComponent("\(userId)")
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.get.rawValue
        
        guard let token = UserDefaults.standard.token else {
            NSLog("No JWT Token Set to User Defaults")
            return
        }
        
        request.setValue(token, forHTTPHeaderField: "Authorization")
    
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error with getting user: \(error)")
                completion(nil, error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code from the http request: \(httpResponse.statusCode)")
                completion(nil, error)
                return
            }
            
            
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                completion(user, nil)
            } catch {
                NSLog("Error with network request: \(error)")
                completion(nil, error)
                return
            }
            
            NSLog("Successfully fetched User")
            
            
            }.resume()
        
    }
    
    //Join a Team
    func joinTeam(code: Int, completion: @escaping (Team?, Error?) -> Void) {
        let url = baseUrl.appendingPathComponent("join")
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        let teamCredentials = ["code": code] as [String: Any]
        
        guard let token = UserDefaults.standard.token else {
            NSLog("No JWT Token Set to User Defaults")
            return
        }
        
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        do {
            let json = try JSONSerialization.data(withJSONObject: teamCredentials, options: .prettyPrinted)
            request.httpBody = json
        } catch {
            NSLog("Error encoding JSON")
            completion(nil, error)
        }
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if let error = error {
                NSLog("There was an error sending team code to server: \(error)")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code from the http request: \(httpResponse.statusCode)")
                completion(nil, error)
                return
            }
            
            do {
                let team = try JSONDecoder().decode(Team.self, from: data)
                completion(team, nil)
            } catch {
                NSLog("Error decoding team \(error)")
                completion(nil, error)
                return
            }
            
            NSLog("User successfully joined Team")
        
            }.resume()
    }
    
    //Get User Survey Responses
    func getUserResponses(userId: Int, completion: @escaping ([Response]?, Error?) -> Void) {
        let url = baseUrl.appendingPathComponent("users")
                         .appendingPathComponent("\(userId)")
                         .appendingPathComponent("responses")
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.get.rawValue
        
        guard let token = UserDefaults.standard.token else {
            NSLog("No JWT Token Set to User Defaults")
            return
        }

        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error with getting user responses: \(error)")
                completion(nil, error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code from the http request: \(httpResponse.statusCode)")
                completion(nil, error)
                return
            }
            
            
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            do {
                let responses = try JSONDecoder().decode([Response].self, from: data)
                completion(responses, nil)
            } catch {
                NSLog("Error with network request: \(error)")
                completion(nil, error)
                return
            }
            
            NSLog("Successfully fetched all User Responses")
            
            
        }.resume()
    }
    
    //Google OAuth Sign In
    func googleSignIn(email: String, fullName: String, imageUrl: URL, completion: @escaping (ErrorMessage?) -> Void) {
        let fullNameArr = fullName.components(separatedBy: " ")
        let url = baseUrl.appendingPathComponent("oauth")
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        let googleSignInParams = ["email": email, "firstName": fullNameArr[0], "lastName": fullNameArr[1], "imageUrl": imageUrl.absoluteString] as [String: Any]
        
        do {
            let json = try JSONSerialization.data(withJSONObject: googleSignInParams, options: .prettyPrinted)
            request.httpBody = json
        } catch {
            NSLog("Error encoding JSON")
            return
        }
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if let error = error {
                NSLog("There was an error sending Google Sign In Credentials to server: \(error)")
                return
            }
            
            guard let data = data else {
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code from the http request: \(httpResponse.statusCode)")
                let errorMessage = try! JSONDecoder().decode(ErrorMessage.self, from: data)
                completion(errorMessage)
                return
            }
            
            do {
                let jwtToken = try JSONDecoder().decode(JWT.self, from: data)
                let jwt = try decode(jwt: jwtToken.jwt)
                let userId = jwt.body["id"] as! Int
                let token = jwt.string
                self.saveCurrentUser(userId: userId, token: token)
            } catch {
                NSLog("Error decoding JSON Web Token \(error)")
                return
            }
            
            NSLog("Successfully Google Signed in User")
            completion(nil)
            }.resume()
    }
    
    // Get Team Members of a team
    func getTeamMembers(teamId: Int, completion: @escaping ([User]?, Error?) -> Void) {
        let url = baseUrl.appendingPathComponent("teams")
            .appendingPathComponent("\(teamId)")
            .appendingPathComponent("users")
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.get.rawValue
        
        guard let token = UserDefaults.standard.token else {
            NSLog("No JWT Token Set to User Defaults")
            return
        }
        
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error with getting team members: \(error)")
                completion(nil, error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code from the http request: \(httpResponse.statusCode)")
                completion(nil, error)
                return
            }
            
            
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                completion(users, nil)
            } catch {
                NSLog("Error with network request: \(error)")
                completion(nil, error)
                return
            }
            
            NSLog("Successfully fetched Team members")
            
            
            }.resume()
    }
    
    //Get Managing Team as Manager
    func getManagingTeam(userId: Int, completion: @escaping (Team?, Error?) -> Void) {
        let url = baseUrl.appendingPathComponent("users")
            .appendingPathComponent("\(userId)")
            .appendingPathComponent("teams")
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.get.rawValue
        
        guard let token = UserDefaults.standard.token else {
            NSLog("No JWT Token Set to User Defaults")
            return
        }
        
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error with getting user team: \(error)")
                completion(nil, error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code from the http request: \(httpResponse.statusCode)")
                completion(nil, error)
                return
            }
            
            
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            do {
                let team = try JSONDecoder().decode([Team].self, from: data).first
                completion(team, nil)
            } catch {
                NSLog("Error with network request: \(error)")
                completion(nil, error)
                return
            }
            
            NSLog("Successfully fetched User Team")
            
            
            }.resume()
    }
    
    //Send Survey to Server -> APN -> User's Mobile Phone
    func sendSurveyNotification() {
        //This will be inside
        let emojis = ["😄","😃"]
        localNotificationHelper.getAuthorizationStatus { (status) in
            switch status {
            case .authorized:
                self.localNotificationHelper.sendSurveyNotification(emojis: emojis, schedule: "Daily")
            case .notDetermined:
                self.localNotificationHelper.requestAuthorization(completion: { (granted) in
                    
                    if (granted) {
                        self.localNotificationHelper.sendSurveyNotification(emojis: emojis, schedule: "Daily")
                    }
                })
            default:
                return
            }
        }
    }
    
    //Helper Functions

    //Get Image
    func getImage(url: URL, completion: @escaping (UIImage?, Error?) -> Void = {_,_ in}) {
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error \(error)")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, error)
                return
            }
            let image = UIImage(data: data)
            completion(image, error);
        }.resume()
    }
    
    //Save JSON Web Token and Associated User
    private func saveCurrentUser(userId: Int, token: String) {
        UserDefaults.standard.set(token, forKey: UserDefaultsKeys.token.rawValue)
        UserDefaults.standard.set(userId, forKey: UserDefaultsKeys.userId.rawValue)
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
    
    func logout() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
    
    
    
    
    
    let localNotificationHelper = LocalNotificationHelper()
    //let baseUrl = URL(string: "http://localhost:3000/api")!
    //let baseUrl = URL(string: "https://sentimentbot-1.herokuapp.com/api")!
    let baseUrl = URL(string: "http://localhost:3000/api")!
}
