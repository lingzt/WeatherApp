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
    var geoCoder : CLGeocoder = CLGeocoder()
    var cityInfor: CityInfor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        weatherLabel.text = "Temperature Information"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NetworkTools.fetchCityInfor{ (cityInfor) -> () in
            self.cityInfor = cityInfor
            self.weatherLabel.text = cityInfor.current_observation.temperature_string
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        geoCoder.reverseGeocodeLocation(location) { (placemarks, _) in
            guard let placemark = placemarks?.first else {
                self.cityLabel.text = "Could not receive your location information"
                return
            }
            let apiParam = self.updateLocation(from: placemark)
        }
    }
    
    func updateLocation(from placemark: CLPlacemark) -> String {
        var apiParam = ""
        
        if let locality = placemark.locality, let administrativeArea = placemark.administrativeArea {
            cityLabel.text = "\(locality),  \(administrativeArea)"
            apiParam = "\(locality)/\(administrativeArea)"
        }
        return apiParam
    }
    
    
    
    


}

