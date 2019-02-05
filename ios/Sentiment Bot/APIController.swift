//
//  APIController.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/9/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit
import JWTDecode

//This will be modularized and refactored one day
// MVP is prioritized
//For now use code folding to make scrolling managable
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
                NSLog("Error retrieving data from server(signUp)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code from the http request: \(httpResponse.statusCode)")
                do {
                    let errorMessage = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    completion(errorMessage)
                } catch {
                    NSLog("Error decoding ErrorMessage(signUp) \(error)")
                    return
                }
                return
            }
            
            NSLog("Successfully signed up User")
            
            self.logIn(email: email, password: password, completion: completion)
            
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
                NSLog("Error retrieving data from server(logIn)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code from the http request: \(httpResponse.statusCode)")
                do {
                    let errorMessage = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    completion(errorMessage)
                } catch {
                    NSLog("Error decoding ErrorMessage(logIn) \(error)")
                    return
                }
 
                return
            }
            
            do {
                let jwtToken = try JSONDecoder().decode(JWT.self, from: data)
                let jwt = try decode(jwt: jwtToken.jwt)
                let userId = jwt.body["id"] as! Int
                let teamId = 0000 //jwt.body["teamid"] as! Int
                let token = jwt.string
                self.saveCurrentUser(userId: userId, teamId: teamId, token: token)
            } catch {
                NSLog("Error decoding JSON Web Token \(error)")
                return
            }
            
            NSLog("Successfully logged in User")
            
            completion(nil)
        }.resume()
    }
    
    //Get User through userId
    func getUser(userId: Int, completion: @escaping (User?, ErrorMessage?) -> Void) {
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
                return
            }
            
            guard let data = data else {
                NSLog("Error retrieving data from server(getUser)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code from the http request: \(httpResponse.statusCode)")
                do {
                    let errorMessage = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    completion(nil, errorMessage)
                } catch {
                    NSLog("Error decoding ErrorMessage(getUser) \(error)")
                    return
                }
                return
            }
            
            
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                completion(user, nil)
            } catch {
                NSLog("Error with network request: \(error)")
                return
            }
            
            NSLog("Successfully fetched User")
            
            
            }.resume()
        
    }
    
    //Join a Team

    func joinTeam(code: Int, completion: @escaping (Team?, ErrorMessage?) -> Void) {
        let url = baseUrl.appendingPathComponent("join")
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        let teamParams = ["code": code] as [String: Any]
        
        guard let token = UserDefaults.standard.token else {
            NSLog("No JWT Token Set to User Defaults")
            return
        }
        
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        do {
            let json = try JSONSerialization.data(withJSONObject: teamParams, options: .prettyPrinted)
            request.httpBody = json
        } catch {
            NSLog("Error encoding JSON")
            return
        }
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if let error = error {
                NSLog("There was an error sending team code to server: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("Error retrieving data from server(joinTeam)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code from the http request: \(httpResponse.statusCode)")
                do {
                    let errorMessage = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    completion(nil, errorMessage)
                } catch {
                    NSLog("Error decoding ErrorMessage(joinTeam) \(error)")
                    return
                }
                return
            }
            
            do {
                let team = try JSONDecoder().decode(Team.self, from: data)
                completion(team, nil)
            } catch {
                NSLog("Error decoding team \(error)")
                return
            }

            NSLog("User successfully joined Team")
        
            }.resume()
    }
    
    func createFeelzyResponse(userId: Int, surveyId: Int, mood: String, emoji: String, completion: @escaping (Response?, ErrorMessage?) -> Void) {
        let url = baseUrl.appendingPathComponent("users")
                         .appendingPathComponent("\(userId)")
                         .appendingPathComponent("responses")
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        if mood == "om.apple.UNNotificationDefaultActionIdentifier" || emoji == "c" {
            NSLog("User dismissed the notification")
            return
        }
        
        
        let longitude = UserDefaults.standard.longitude!
        let latitude = UserDefaults.standard.latitude!
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let date = df.string(from: Date())
        
        let deviceToken = UserDefaults.standard.deviceToken!
        
        let responseParams = ["emoji": emoji, "mood": mood, "longitude": longitude, "latitude": latitude, "date": date, "surveyId": surveyId, "deviceToken": deviceToken] as [String: Any]
        
        //request.setValue(token, forHTTPHeaderField: "Authorization")
        
        do {
            let json = try JSONSerialization.data(withJSONObject: responseParams, options: .prettyPrinted)
            request.httpBody = json
        } catch {
            NSLog("Error encoding JSON")
            return
        }
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if let error = error {
                NSLog("There was an error sending response params to server: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("Error retrieving data from server(createFeelzyResponse)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code from the http request: \(httpResponse.statusCode)")
                do {
                    let errorMessage = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    completion(nil, errorMessage)
                } catch {
                    NSLog("Error decoding ErrorMessage(createFeelzyResponse) \(error)")
                    return
                }
                return
            }
            
            do {
                let response = try JSONDecoder().decode(Response.self, from: data)
                completion(response, nil)
            } catch {
                NSLog("Error decoding response \(error)")
                return
            }
            
            NSLog("User successfully created a response(feelzy)")
            
            }.resume()
    }
    
    func saveDeviceToken(userId: Int, deviceToken: String, completion: @escaping (ErrorMessage?) -> Void ) {
        let url = baseUrl.appendingPathComponent("saveDeviceToken")
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        let teamParams = ["deviceToken": deviceToken, "id": userId] as [String: Any]
        
        guard let token = UserDefaults.standard.token else {
            NSLog("No JWT Token Set to User Defaults")
            return
        }
        
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        do {
            let json = try JSONSerialization.data(withJSONObject: teamParams, options: .prettyPrinted)
            request.httpBody = json
        } catch {
            NSLog("Error encoding JSON")
            return
        }
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if let error = error {
                NSLog("There was an error sending device token to server: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("Error retrieving data from server(saveDeviceToken)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code from the http request: \(httpResponse.statusCode)")
                do {
                    let errorMessage = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    completion(errorMessage)
                } catch {
                    NSLog("Error decoding ErrorMessage(saveDeviceToken) \(error)")
                    return
                }
                return
            }
            
            
            NSLog("User successfully saved device token for future push notifcations")
            
            }.resume()
    }
    
    //Get User Survey Responses
    func getUserResponses(userId: Int, completion: @escaping ([Response]?, ErrorMessage?) -> Void) {
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
                return
            }
            
            guard let data = data else {
                NSLog("Error retrieving data from server(getUserResponses)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code from the http request: \(httpResponse.statusCode)")
                do {
                    let errorMessage = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    completion(nil, errorMessage)
                } catch {
                    NSLog("Error decoding ErrorMessage(getUserResponses) \(error)")
                    return
                }
                return
            }
            
            do {
                let responses = try JSONDecoder().decode([Response].self, from: data)
                completion(responses, nil)
            } catch {
                NSLog("Error with network request: \(error)")
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
                NSLog("Error retrieving data from server(googleSignIn)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code from the http request: \(httpResponse.statusCode)")
                do {
                    let errorMessage = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    completion(errorMessage)
                } catch {
                    NSLog("Error decoding ErrorMessage(googleSignIn) \(error)")
                    return
                }
                return
            }
            
            do {
                let jwtToken = try JSONDecoder().decode(JWT.self, from: data)
                let jwt = try decode(jwt: jwtToken.jwt)
                let userId = jwt.body["id"] as! Int
                let teamId = 0000 //jwt.body["teamid"] as! Int
                let token = jwt.string
                self.saveCurrentUser(userId: userId, teamId: teamId, token: token)
            } catch {
                NSLog("Error decoding JSON Web Token \(error)")
                return
            }
            
            NSLog("Successfully Google Signed in User")
            completion(nil)
            }.resume()
    }
    
    // Get Team Members of a team
    func getTeamMembers(teamId: Int, completion: @escaping ([User]?, ErrorMessage?) -> Void) {
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
                return
            }
            
            guard let data = data else {
                NSLog("Error retrieving data from server(getTeamMembers)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code from the http request: \(httpResponse.statusCode)")
                do {
                    let errorMessage = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    completion(nil, errorMessage)
                } catch {
                    NSLog("Error decoding ErrorMessage(getTeamMembers) \(error)")
                    return
                }
                return
            }

            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                completion(users, nil)
            } catch {
                NSLog("Error with network request: \(error)")
                return
            }
            
            NSLog("Successfully fetched Team members")
            
            
            }.resume()
    }
    
    func getTeam(teamId: Int, completion: @escaping (Team?, ErrorMessage?) -> Void) {
        let url = baseUrl.appendingPathComponent("teams")
            .appendingPathComponent("\(teamId)")
        
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
                NSLog("Error with getting team: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("Error retreiving data from server(getTeam)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code from the http request: \(httpResponse.statusCode)")
                do {
                    let errorMessage = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    completion(nil, errorMessage)
                } catch {
                    NSLog("Error decoding ErrorMessage(getTeam) \(error)")
                    return
                }
                return
            }
            
            do {
                let team = try JSONDecoder().decode(Team.self, from: data)
                completion(team, nil)
            } catch {
                NSLog("Error with network request: \(error)")
                return
            }
            
            NSLog("Successfully fetched Team")
            
            
            }.resume()
    }
    
    //Get Managing Team as Manager
    func getManagingTeam(userId: Int, completion: @escaping (Team?, ErrorMessage?) -> Void) {
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
                return
            }
            
            guard let data = data else {
                NSLog("Error retreiving data from server(getManagingTeam)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code from the http request: \(httpResponse.statusCode)")
                do {
                    let errorMessage = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    completion(nil, errorMessage)
                } catch {
                    NSLog("Error decoding ErrorMessage(getTeamMembers) \(error)")
                    return
                }
                return
            }
            
            do {
                let team = try JSONDecoder().decode([Team].self, from: data).first
                completion(team, nil)
            } catch {
                NSLog("Error with network request: \(error)")
                return
            }
            
            NSLog("Successfully fetched Manager's Team")
            
            
            }.resume()
    }
    
    //Get Team Responses
    func getTeamResponses(teamId: Int, completion: @escaping ([Response]?, ErrorMessage?) -> Void) {
        let url = baseUrl.appendingPathComponent("teams")
            .appendingPathComponent("\(teamId)")
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
                NSLog("Error with getting team responses: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("Error retrieving data from server(getTeamResponses)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code from the http request: \(httpResponse.statusCode)")
                do {
                    let errorMessage = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    completion(nil, errorMessage)
                } catch {
                    NSLog("Error decoding ErrorMessage(getTeamResponses) \(error)")
                    return
                }
                return
            }
            
            do {
                let responses = try JSONDecoder().decode([Response].self, from: data)
                completion(responses, nil)
            } catch {
                NSLog("Error with network request: \(error)")
                return
            }
            
            NSLog("Successfully fetched all Team Responses")
            
            
            }.resume()
    }
    
    //Get Survey
    //Includes Associates Feelings
    func getSurvey(teamId: Int, completion: @escaping (Survey?, ErrorMessage?) -> Void) {
        let url = baseUrl.appendingPathComponent("teams")
            .appendingPathComponent("\(teamId)")
            .appendingPathComponent("surveys")
        
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
                NSLog("Error with getting team survey: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("Error retrieving data from server(getSurvey)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code from the http request: \(httpResponse.statusCode)")
                do {
                    let errorMessage = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    completion(nil, errorMessage)
                } catch {
                    NSLog("Error decoding ErrorMessage(getSurvey) \(error)")
                    return
                }
                return
            }
            
            do {
                let survey = try JSONDecoder().decode([Survey].self, from: data).first
                completion(survey, nil)
            } catch {
                NSLog("Error with network request: \(error)")
                return
            }
            
            NSLog("Successfully fetched Team's Survey")
            
            
            }.resume()
    }
    
    //Change Survey Schedule
    func changeSurveySchedule(surveyId: Int, time: String, schedule: String, completion: @escaping (Survey?, ErrorMessage?) -> Void) {
        let url = baseUrl.appendingPathComponent("surveys")
            .appendingPathComponent("\(surveyId)")

        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.put.rawValue
        
        let params = ["schedule": schedule, "time": time] as [String : Any]
        
        guard let token = UserDefaults.standard.token else {
            NSLog("No JWT Token Set to User Defaults")
            return
        }
        
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        do {
            let json = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            request.httpBody = json
        } catch {
            NSLog("Error encoding JSON")
            return
        }
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if let error = error {
                NSLog("There was an error sending update survey's schedule request to server: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("Error retrieving data from server(changeSurveySchedule)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code from the http request: \(httpResponse.statusCode)")
                do {
                    let errorMessage = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    completion(nil, errorMessage)
                } catch {
                    NSLog("Error decoding ErrorMessage(changeSurveySchedule) \(error)")
                    return
                }
                return
            }
            
            do {
                let survey = try JSONDecoder().decode(Survey.self, from: data)
                completion(survey, nil)
            } catch {
                NSLog("Error with network request: \(error)")
                return
            }
            
            NSLog("Manager successfully changed schedule of survey to \(schedule)")
            
            }.resume()
    }
    
    //Create a team if one doesn't exist
    func createTeam(userId: Int, teamName: String, completion: @escaping (ErrorMessage?) -> Void) {
        let url = baseUrl.appendingPathComponent("users")
            .appendingPathComponent("\(userId)")
            .appendingPathComponent("teams")
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        let params = ["teamName": teamName] as [String: Any]
        
        guard let token = UserDefaults.standard.token else {
            NSLog("No JWT Token Set to User Defaults")
            return
        }
        
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        do {
            let json = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            request.httpBody = json
        } catch {
            NSLog("Error encoding JSON")
            return
        }
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if let error = error {
                NSLog("There was an error sending params to server: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("Error retrieving data from server(createTeam)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code from the http request: \(httpResponse.statusCode)")
                do {
                    let errorMessage = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    completion(errorMessage)
                } catch {
                    NSLog("Error decoding ErrorMessage(createTeam) \(error)")
                    return
                }
                return
            }
            
            NSLog("Manager successfully created team")
            completion(nil)
            
            }.resume()
    }
    
    func getFeelingsForSurvey(surveyId: Int, completion: @escaping ([Feeling]?, ErrorMessage?) -> Void) {
        let url = baseUrl.appendingPathComponent("surveys")
            .appendingPathComponent("\(surveyId)")
            .appendingPathComponent("feelings")
        
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
                NSLog("Error with getting team survey: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("Error retrieving data from server(getFeelingsForSurvey)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code from the http request: \(httpResponse.statusCode)")
                do {
                    let errorMessage = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    completion(nil, errorMessage)
                } catch {
                    NSLog("Error decoding ErrorMessage(getFeelingsForSurvey) \(error)")
                    return
                }
                return
            }
            
            do {
                let feelings = try JSONDecoder().decode([Feeling].self, from: data)
                completion(feelings, nil)
            } catch {
                NSLog("Error with network request: \(error)")
                return
            }
            
            NSLog("Successfully fetched Survey Feelings")
          
            
            }.resume()
    }
    
    //Create a feeling option for Survey
    func createFeelingForSurvey(mood: String, emoji: String, surveyId: Int, completion: @escaping (Feeling?, ErrorMessage?) -> Void) {
        let url = baseUrl.appendingPathComponent("surveys")
                         .appendingPathComponent("\(surveyId)")
                         .appendingPathComponent("feelings")
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        
        guard let token = UserDefaults.standard.token else {
            NSLog("No JWT Token Set to User Defaults")
            return
        }
        let params = ["mood": mood, "emoji": emoji] as [String: Any]
        
        request.setValue(token, forHTTPHeaderField: "Authorization")
        do {
            let json = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            request.httpBody = json
        } catch {
            NSLog("Error encoding JSON")
            return
        }
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if let error = error {
                NSLog("There was an error sending surveyParams to server: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("Error retrieving data from server(createFeelingForSurvey)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code from the http request: \(httpResponse.statusCode)")
                do {
                    let errorMessage = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    completion(nil, errorMessage)
                } catch {
                    NSLog("Error decoding ErrorMessage(createFeelingForSurvey) \(error)")
                    return
                }
                return
            }
            
            
            do {
                let feeling = try JSONDecoder().decode(Feeling.self, from: data)
                completion(feeling, nil)
            } catch {
                NSLog("Error with network request: \(error)")
                return
            }

            NSLog("Manager successfully created Feeling for Survey")
            
            
            }.resume()
    }
    
    //Remove Feeling option from Survey
    func removeFeelingFromSurvey(feelingId: Int, completion: @escaping (ErrorMessage?) -> Void) {
        let url = baseUrl.appendingPathComponent("feelings")
            .appendingPathComponent("\(feelingId)")

        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.delete.rawValue
        
        guard let token = UserDefaults.standard.token else {
            NSLog("No JWT Token Set to User Defaults")
            return
        }
        
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if let error = error {
                NSLog("There was an error sending delete feeling request to server: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("Error retrieving data from server(removeFeelingFromSurvey)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code from the http request: \(httpResponse.statusCode)")
                do {
                    let errorMessage = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    completion(errorMessage)
                } catch {
                    NSLog("Error decoding ErrorMessage(removeFeelingFromSurvey) \(error)")
                    return
                }
                return
            }
            
            NSLog("Manager successfully deleted Feeling from Survey")
            
            }.resume()
    }
    
    //Remove Team Member or Leave Team
    func removeMemberFromTeam(teamId: Int, userId: Int, completion: @escaping (ErrorMessage?) -> Void) {
        let url = baseUrl.appendingPathComponent("teams")
            .appendingPathComponent("\(teamId)")
            .appendingPathComponent("users")
            .appendingPathComponent("\(userId)")
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.delete.rawValue
        
        guard let token = UserDefaults.standard.token else {
            NSLog("No JWT Token Set to User Defaults")
            return
        }
        
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if let error = error {
                NSLog("There was an error sending delete team member request to server: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("Error retrieving data from server(removeMemberFromTeam)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code from the http request: \(httpResponse.statusCode)")
                do {
                    let errorMessage = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    completion(errorMessage)
                } catch {
                    NSLog("Error decoding ErrorMessage(removeMemberFromTeam) \(error)")
                    return
                }
                return
            }
            
            NSLog("Manager successfully deleted team member from team")
            completion(nil)
            
            }.resume()
    }
    
    
    //Update Profile Image
    //Example:
    //let capturePhotoImage = self.capturePhotoView.image
    //let imageData = capturePhotoImage!.pngData()
    //Another Example:
    //       let image = UIImage(named: "GoogleSignIn")
    //        let imageData = image!.pngData()
    //        APIController.shared.updateProfileImage(imageData: imageData!) { (errorMessage) in
    //
    //        }
    func uploadProfilePicture(imageData: Data, completion: @escaping (ErrorMessage?) -> Void) {
        let encodedImageData = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        let url = baseUrl.appendingPathComponent("upload")
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        
        guard let token = UserDefaults.standard.token else {
            NSLog("No JWT Token Set to User Defaults")
            return
        }
        
        request.setValue(token, forHTTPHeaderField: "Authorization")
        let postString = "image=\(encodedImageData)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
             if let error = error {
                NSLog("There was an error sending image data to server: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("Error retrieving data from server(updateProfileImage)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code from the http request: \(httpResponse.statusCode)")
                do {
                    let errorMessage = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    completion(errorMessage)
                } catch {
                    NSLog("Error decoding ErrorMessage(updateProfileImage) \(error)")
                    return
                }
                return
            }
            NSLog("Successfully Changed Profile Picture")
            completion(nil)
        }
        task.resume()
    }
    
    func uploadResponseSelfie(responseId: Int, imageData: Data, completion: @escaping (ErrorMessage?) -> Void) {
        let encodedImageData = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        let url = baseUrl.appendingPathComponent("upload_response_image")
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        
        guard let token = UserDefaults.standard.token else {
            NSLog("No JWT Token Set to User Defaults")
            return
        }
        
        request.setValue(token, forHTTPHeaderField: "Authorization")
        let postString = "image=\(encodedImageData)&responseId=\(responseId)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("There was an error sending image data to server: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("Error retrieving data from server(uploadResponseSelfie)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code from the http request: \(httpResponse.statusCode)")
                do {
                    let errorMessage = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    completion(errorMessage)
                } catch {
                    NSLog("Error decoding ErrorMessage(uploadResponseSelfie) \(error)")
                    return
                }
                return
            }
            
            NSLog("Successfully Changed Response(Feelzy) Selfie")
            
            completion(nil)
        }
        task.resume()
    }
    
    //Send Survey to Server -> APN -> User's Mobile Phone
    func sendSurveyNotification(token: String, completion: @escaping (ErrorMessage?) -> Void) {
        let url = baseUrl.appendingPathComponent("push")
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        let teamParams = ["token": token] as [String: Any]
        
        guard let token = UserDefaults.standard.token else {
            NSLog("No JWT Token Set to User Defaults")
            return
        }
        
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        do {
            let json = try JSONSerialization.data(withJSONObject: teamParams, options: .prettyPrinted)
            request.httpBody = json
        } catch {
            NSLog("Error encoding JSON")
            return
        }
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if let error = error {
                NSLog("There was an error sending team code to server: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("Error retrieving data from server(joinTeam)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code from the http request: \(httpResponse.statusCode)")
                do {
                    let errorMessage = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    completion(errorMessage)
                } catch {
                    NSLog("Error decoding ErrorMessage(joinTeam) \(error)")
                    return
                }
                return
            }
            
            NSLog("User successfully joined Team")
            
            }.resume()
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
    private func saveCurrentUser(userId: Int, teamId: Int, token: String) {
        UserDefaults.standard.set(token, forKey: UserDefaultsKeys.token.rawValue)
        UserDefaults.standard.set(userId, forKey: UserDefaultsKeys.userId.rawValue)
        UserDefaults.standard.set(teamId, forKey: UserDefaultsKeys.teamId.rawValue)
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.token.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.teamId.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userId.rawValue)
    }
    
    
    
    
    let locationHelper = LocationHelper()
    let baseUrl = URL(string: "https://sentimentbot-1.herokuapp.com/api")!
    //let baseUrl = URL(string: "http://192.168.1.152:3000/api")!
}
