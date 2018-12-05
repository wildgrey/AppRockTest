//
//  AppRockManager.swift
//  AppRockTest
//
//  Created by Sergey Vishnyov on 12/4/18.
//  Copyright © 2018 Sergey Vishnyov. All rights reserved.
//

import UIKit
import CoreLocation

class AppRockManager: NSObject, CLLocationManagerDelegate {
    static let sharedInstance = AppRockManager()
    
    let locationManager = CLLocationManager()
    var location: CLLocation!
    var currentTemperature: Int!
    var currentCity: String!
    private var isDataLoaded: Bool!
    private var isDataLoading: Bool!
    private var loadingViewController: LoadingViewController!
    
    // MARK: - Location Methods

    func initLocationManager() {
        self.isDataLoaded = false
        self.isDataLoading = false
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }

    func isLoactionEnabled() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                return true
            }
        } else {
            print("Location services are not enabled")
            return false
        }
    }
    
    // MARK: - Location Delegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latitude: CLLocationDegrees = (locationManager.location?.coordinate.latitude)!
        let longitude: CLLocationDegrees = (locationManager.location?.coordinate.longitude)!
        let location = CLLocation(latitude: latitude, longitude: longitude)
        self.location = location
//        print("locations = \(latitude) \(longitude)")
//        locationManager.stopUpdatingLocation()
        if (!self.isDataLoaded && !self.isDataLoading) {
            self.isDataLoading = true
            self.getCity()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clErr = error as? CLError {
            switch clErr {
            case CLError.locationUnknown:
                print("location unknown")
            case CLError.denied:
                print("denied")
            default:
                print("other Core Location error")
            }
        } else {
            print("other error:", error.localizedDescription)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            break
        case .authorizedWhenInUse:
            NotificationCenter.default.post(name: Notification.Name("didChangeAuthorizationWhenInUse"), object: nil)
            break
        case .authorizedAlways:
            break
        case .restricted:
            break
        case .denied:
            break
        default:
            break
        }
    }
    
    // MARK: - API
    private func getCity() {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                return
            } else if let country = placemarks?.first?.country,
                let city = placemarks?.first?.locality {
                print(country)
                print(city)
                self.currentCity = city
                self.getWeather()
            } else {
                //
            }
        })
    }
    
    private func getWeather() {
        DispatchQueue.global(qos: .userInitiated).async {
            let url = NSURL(string:"https://api.openweathermap.org/data/2.5/weather?lat=\(self.location.coordinate.latitude)&lon=\(self.location.coordinate.longitude)&appid=e7b2054dc37b1f464d912c00dd309595&units=Metric")
            var request = URLRequest(url:url! as URL)
            request.httpMethod = "GET"
            let dataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if error != nil {
                    print(error as Any)
//                self.hideLoadingViewController()
                } else {
                    do {
                        let parsedData = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                        let currentConditions = parsedData["main"] as! [String:Any]
                        let currentTemperature = currentConditions["temp"] as! Int
                        print(currentTemperature)
                        self.currentTemperature = currentTemperature
                        
                        self.isDataLoaded = true
                        self.isDataLoading = false
                        DispatchQueue.main.async {
                            self.hideLoadingViewController()
                        }
                    } catch let error as NSError {
                        print(error)
//                    self.hideLoadingViewController()
                    }
                }
            })
            dataTask.resume()
        }
    }
    
    func isDataLoaded(_ : Any?) -> Bool {
        return self.isDataLoaded
    }

    // MARK: - Actions

    func showLoadingViewController () {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.loadingViewController = storyboard.instantiateViewController(withIdentifier: "LoadingViewController") as? LoadingViewController
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController?.present(self.loadingViewController, animated: false, completion: nil)
    }

    func hideLoadingViewController () {
        if self.loadingViewController != nil {
            self.loadingViewController.dismiss(animated: false, completion: nil)
        }
    }

}
