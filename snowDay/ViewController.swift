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
    @IBOutlet weak var graphLine: UIView!
    
    
    
    override func viewDidLoad() {
        
        let precipValues = [0.05, 0.15, 0.3, 0.45, 0.63, 0.98, 0.96, 0.64, 0.61, 0.64, 0.63, 0.25]

        super.viewDidLoad()
        var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(43.923, -70)
        pullForecast(location: currentLocation)
        
        
        setupShadows(view: headerView, opacity: 1, radius: 10, offset: CGSize.zero)
        setupShadows(view: percentChanceLabel, opacity: 1, radius: 4, offset: CGSize(width: 3, height: 3))
        setupShadows(view: forecastLabel, opacity: 0.75, radius: 2, offset: CGSize(width: 2, height: 3))
        setupShadows(view: firstDivider, opacity: 0.75, radius: 2, offset: CGSize(width: 3, height: 3))
        
        graphLine.backgroundColor = UIColor(red: 87/255, green: 87/255, blue: 87/255, alpha: 1)
        setupShadows(view: graphLine, opacity: 0.75, radius: 2, offset: CGSize(width: 3, height: 3))


        
        headerView.isHidden = true
        percentChanceLabel.isHidden = true
        forecastLabel.isHidden = true
        firstDivider.isHidden = true


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
                let decoder = JSONDecoder()
                let serverResponse = try decoder.decode(ServerResponse.self, from: data!)
                DispatchQueue.main.sync {
                    self.reloadView(serverResponse: serverResponse)
                }
                print(serverResponse)
                
            } catch {
                print("decoding error")
                print(error)
            }
        }
        
        task.resume()
        return
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

    }
    
    func reloadView(serverResponse: ServerResponse) {
        
        for x in 0..<serverResponse.precipInfo.count {
            let bar = UIView(frame: CGRect(x:(graphLine.frame.width / CGFloat(serverResponse.precipInfo.count)) * CGFloat(x), y: graphLine.frame.maxY - 6, width: graphLine.frame.width / CGFloat(serverResponse.precipInfo.count) - 5, height: 0))
            bar.layer.anchorPoint = CGPoint(x: 0, y: 0)
            bar.backgroundColor = UIColor(red: 15/255, green: 69/255, blue: 114/255, alpha: 0.5)
            bar.layer.cornerRadius = 4
            bar.tag = 1
            graphView.addSubview(bar)
            barHeights[bar] = -1 * ((graphView.frame.height - 60 / 1) * CGFloat(serverResponse.precipInfo[x]))
            
        }
        percentChanceLabel.frame.origin.x = view.frame.width
        if serverResponse.stormPossible == true {
            percentChanceLabel.text = String(serverResponse.averageProbability)
            forecastLabel.text = String(serverResponse.totalAccumulation) + "inches of snow expected"
        } else {
            percentChanceLabel.text = "0%"
            forecastLabel.text = "No Storm Expected"
            graphLine.isHidden = true
        }
        forecastLabel.frame.origin.x = view.frame.width
        firstDivider.frame.origin.x = view.frame.width
        headerView.isHidden = false
        percentChanceLabel.isHidden = false
        forecastLabel.isHidden = false
        firstDivider.isHidden = false

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
            if graphView.subviews[x].tag == 1 {
                UIView.animate(withDuration: 0.3, delay: 0.2, animations: {
                    self.graphView.subviews[x].frame = CGRect(x: self.graphView.subviews[x].frame.minX, y: self.graphView.subviews[x].frame.minY, width: self.graphView.subviews[x].frame.width, height: self.barHeights[self.graphView.subviews[x]]!)
                })
            }
        }
        
    }
    
    func setupShadows(view: UIView, opacity: Float, radius: CGFloat, offset: CGSize) {
        view.layer.shadowColor = UIColor(red: 15/255, green: 69/255, blue: 114/255, alpha: 0.5).cgColor
        view.layer.shadowOpacity = opacity
        view.layer.shadowOffset = offset
        view.layer.shadowRadius = radius
        
    }




}

