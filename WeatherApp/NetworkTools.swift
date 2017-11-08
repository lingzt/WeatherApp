//
//  NetworkTools.swift
//  WeatherApp
//
//  Created by Ling on 11/8/17.
//  Copyright © 2017 Ling. All rights reserved.
//

import UIKit

struct CityInfor: Decodable {
    let current_observation: WeatherConditions
}

struct WeatherConditions: Decodable {
    let temperature_string: String
}

class NetworkTools: NSObject {
    static func fetchCityInfor(_ location: String, completionHandler: @escaping (CityInfor) -> ()) {
        
        let urlString = "http://api.wunderground.com/api/c0e05755af646c85/conditions/q/"
        guard let url = URL(string: urlString + location + ".json") else {
            let weather = WeatherConditions(temperature_string: "Temperature Unavailable")
            completionHandler(CityInfor(current_observation:weather ))
            return
        }

        URLSession.shared.dataTask(with:url, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                print(error)
                return
            }
            do {
                guard let data = data else {
                    print("no data received")
                    return
                }
                let decoder = JSONDecoder()
                let cityInfor = try decoder.decode(CityInfor.self, from: data)
                DispatchQueue.main.async(execute: { () -> Void in
                    completionHandler(cityInfor)
                })
            } catch let error{
                print(error)
            }
        }) .resume()
    }
}
