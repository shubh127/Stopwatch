//
//  ViewController.swift
//  Stopwatch
//
//  Created by Shubham Behal on 11/01/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var miliSecondsLabel: UILabel!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnLap: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var minutes = 0
    var seconds = 0
    var miliSeconds = 0
    var timer = Timer()
    var lappedTimes : [String] = []
    
    var isStarted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lappedTimes.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lapCell", for: indexPath)
        cell.textLabel?.text = lappedTimes[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }

    @IBAction func onStartClick(_ sender: Any) {
        if(isStarted){
            isStarted = false
            btnLap.setTitle("Reset",for: .normal)
            btnStart.setTitle("Start",for: .normal)
            timer.invalidate()
        }else{
            isStarted = true
            btnLap.setTitle("Lap",for: .normal)
            btnStart.setTitle("Stop",for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(count), userInfo: nil, repeats: true)
        }
    }
    
    @objc fileprivate func count(){
        miliSeconds += 1
        if (miliSeconds == 60){
            seconds += 1
            miliSeconds = 0
        }
        if(seconds == 60){
            minutes += 1
            seconds = 0
            miliSeconds = 0
        }
        miliSecondsLabel.text = String(format: "%02d", miliSeconds)
        secondsLabel.text =  String(format: "%02d", seconds)
        minutesLabel.text =  String(format: "%02d", minutes)
    }
    
    @IBAction func onLapClick(_ sender: Any) {
        if(isStarted){
            let currentTime = String(format: "%02d:%02d.%02d", minutes, seconds, miliSeconds)
            lappedTimes.append(currentTime)
            let indexPath = IndexPath(row: lappedTimes.count - 1, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }else{
            minutes = 0
            seconds = 0
            miliSeconds = 0
            lappedTimes = []
            timer.invalidate()
            miliSecondsLabel.text = String(format: "%02d", miliSeconds)
            secondsLabel.text =  String(format: "%02d", seconds)
            minutesLabel.text =  String(format: "%02d", minutes)
            tableView.reloadData()
            btnLap.setTitle("Lap",for: .normal)
        }
    }
}

