//
//  ViewController.swift
//  snowDay
//
//  Created by Theo Chemel on 3/26/18.
//  Copyright © 2018 Theo Chemel. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    var barHeights = [UIView: CGFloat]()
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var percentChanceLabel: UILabel!
    @IBOutlet weak var forecastLabel: UILabel!
    @IBOutlet weak var firstDivider: UIView!
    @IBOutlet weak var graphView: UIView!
    
    
    
    override func viewDidLoad() {
        
        let precipValues = [0.05, 0.15, 0.3, 0.45, 0.63, 0.98, 0.96, 0.64, 0.61, 0.64, 0.63, 0.25]

        super.viewDidLoad()
        var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(43.923, -70)
        pullForecast(location: currentLocation)
        
        headerView.layer.shadowColor = UIColor(red: 15/255, green: 69/255, blue: 114/255, alpha: 0.5).cgColor
        headerView.layer.shadowOpacity = 1
        headerView.layer.shadowOffset = CGSize.zero
        headerView.layer.shadowRadius = 10
        
        percentChanceLabel.layer.shadowColor = UIColor(red: 15/255, green: 69/255, blue: 114/255, alpha: 0.5).cgColor
        percentChanceLabel.layer.shadowOpacity = 1
        percentChanceLabel.layer.shadowOffset = CGSize(width: 3, height: 3)
        percentChanceLabel.layer.shadowRadius = 4
        
        forecastLabel.layer.shadowColor = UIColor(red: 15/255, green: 69/255, blue: 114/255, alpha: 0.5).cgColor
        forecastLabel.layer.shadowOpacity = 0.75
        forecastLabel.layer.shadowOffset = CGSize(width: 3, height: 3)
        forecastLabel.layer.shadowRadius = 2
        
        firstDivider.layer.shadowColor = UIColor(red: 15/255, green: 69/255, blue: 114/255, alpha: 0.5).cgColor
        firstDivider.layer.shadowOpacity = 0.75
        firstDivider.layer.shadowOffset = CGSize(width: 3, height: 3)
        firstDivider.layer.shadowRadius = 2
        
        let line = UIView(frame: CGRect(x: 10, y: graphView.frame.height - 40, width: graphView.frame.width - 20, height: 2))
        line.backgroundColor = UIColor(red: 87/255, green: 87/255, blue: 87/255, alpha: 1)
        line.layer.shadowColor = UIColor(red: 15/255, green: 69/255, blue: 114/255, alpha: 0.5).cgColor
        line.layer.shadowOpacity = 0.75
        line.layer.shadowOffset = CGSize(width: 3, height: 3)
        line.layer.shadowRadius = 2
        graphView.addSubview(line)
        line.backgroundColor = UIColor.black
        
        for x in 0..<precipValues.count {
            
            let bar = UIView(frame: CGRect(x:(line.frame.width / CGFloat(precipValues.count)) * CGFloat(x), y: line.frame.maxY - 6, width: line.frame.width / CGFloat(precipValues.count) - 5, height: 0))
            bar.layer.anchorPoint = CGPoint(x: 0, y: 0)
            bar.backgroundColor = UIColor(red: 15/255, green: 69/255, blue: 114/255, alpha: 0.5)
            bar.layer.cornerRadius = 4
            bar.tag = 1
            graphView.addSubview(bar)
            barHeights[bar] = -1 * ((graphView.frame.height - 60 / 1) * CGFloat(precipValues[x]))
            
        }


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    
    
    func pullForecast(location: CLLocationCoordinate2D){
        
        let forecast = stormForecast()
        
        let latitudeString = String(location.latitude)
        let longitudeString = String(location.longitude)
        
        let scheme = "https"
        let host = "00a65h7u93.execute-api.us-east-2.amazonaws.com"
        let path = "/dev/test"
        let queryItems = [URLQueryItem(name: "latitude", value: latitudeString), URLQueryItem(name: "longitude", value: longitudeString)]
        
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
            }
            
            do {
                guard let decodedJSON = try JSONSerialization.jsonObject(with: testJSONData!, options: []) as? [String: Any] else {
                    print("error converting to JSON")
                    throw(error!)
                }
                print(decodedJSON["timeForecastRecieved"])
                forecast.timeForecastRecieved = Date(timeIntervalSince1970: decodedJSON["timeForecastRecieved"] as! Double)
                forecast.stormPossible = (decodedJSON["stormPossible"] as! Bool)
                print(forecast.stormPossible)
                
                if forecast.stormPossible == true {
                    forecast.startTime = Date(timeIntervalSince1970: decodedJSON["startTime"] as! Double)
                    forecast.endTime = Date(timeIntervalSince1970: decodedJSON["endTime"] as! Double)
                    forecast.peakIntensity = decodedJSON["peakIntensity"] as? Float
                    forecast.peakIntensityTime = Date(timeIntervalSince1970: decodedJSON["peakIntensityTime"] as! Double)
                    forecast.totalAccumulation = decodedJSON["totalAccumulation"] as? Float
                    forecast.averageProbability = decodedJSON["averageProbability"] as? Float
                }
                
            } catch {
                print("error")
            }
            print(forecast.totalAccumulation)
            
        }
        
        task.resume()
        return
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        print("viewDidAppear")
        reloadView()

    }
    
    func reloadView() {
        percentChanceLabel.frame.origin.x = view.frame.width
        forecastLabel.frame.origin.x = view.frame.width
        firstDivider.frame.origin.x = view.frame.width
        UIView.animate(withDuration: 0.3, animations: {
            self.percentChanceLabel.frame.origin.x = 16
        })
        UIView.animate(withDuration: 0.3, delay: 0.1, animations: {
            self.forecastLabel.frame.origin.x = 16
        })
        UIView.animate(withDuration: 0.3, delay: 0.2, animations: {
            self.firstDivider.frame.origin.x = 80
        })
        
        for x in 0..<graphView.subviews.count {
            print(x)
            print(graphView.subviews[x])
            if graphView.subviews[x].tag == 1 {
                UIView.animate(withDuration: 0.3, delay: 0.2, animations: {
                    self.graphView.subviews[x].frame = CGRect(x: self.graphView.subviews[x].frame.minX, y: self.graphView.subviews[x].frame.minY, width: self.graphView.subviews[x].frame.width, height: self.barHeights[self.graphView.subviews[x]]!)
                })
            }
        }
        
        print(percentChanceLabel.frame.origin.x)
    }




}

