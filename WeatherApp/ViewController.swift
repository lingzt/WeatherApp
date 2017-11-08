//
//  ViewController.swift
//  WeatherApp
//
//  Created by Ling on 11/7/17.
//  Copyright © 2017 Ling. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController , CLLocationManagerDelegate{

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    
    let locationManager = CLLocationManager()
    var geoCoder: CLGeocoder = CLGeocoder()
    var cityInfor: CityInfor?
    var apiParam = String() {
        didSet {
            updateWeather(location: apiParam)
        }  
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        weatherLabel.text = "Temperature Information"
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        geoCoder.reverseGeocodeLocation(location) { (placemarks, _) in
            guard let placemark = placemarks?.first else {
                self.cityLabel.text = "can not locate user"
                return
            }
            self.updateLocation(from: placemark)
        }
    }
    
    func updateLocation(from placemark: CLPlacemark) {
        
        guard let locality = placemark.locality, let administrativeArea = placemark.administrativeArea else {
            self.cityLabel.text = "can not locate user"
            self.weatherLabel.text =  "Temperature Unavailable"
            return
        }
            cityLabel.text = "\(locality),  \(administrativeArea)"
            let str = "\(administrativeArea)/\(locality)"
            apiParam = str.replacingOccurrences(of: " ", with: "_")
    }
    
    func updateWeather(location: String) {
        if apiParam != String(){
            NetworkTools.fetchCityInfor(location){ (cityInfor) -> () in
            self.cityInfor = cityInfor
            self.weatherLabel.text = cityInfor.current_observation.temperature_string
            }
        }
    }
}

