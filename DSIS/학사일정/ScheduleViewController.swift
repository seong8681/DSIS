//
//  ScheduleViewController.swift
//  DSIS
//
//  Created by 주성호 on 04/09/2019.
//  Copyright © 2019 주성호. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

struct CalendarInfo: Decodable {
    let result: [Content]
}

struct Content: Decodable {
    let date: String // 날짜
    let calendar: String // 일정
}

struct schedule {
    let date : String
    let calendar : String
}

class SchduleViewController : UIViewController {
    
    var ScheduleContent : Array<Array<schedule> > = Array<Array<schedule> >()
    let background = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0..<12 {
            ScheduleContent.append([schedule(date: "", calendar: "")])
            ScheduleContent[i].removeAll()
        }
        // 학사일정 파싱
        getSchdule()
        
        TitleBarHeight = view.frame.height / 4
        
        let navigationBar = UILabel()
        navigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: TitleBarHeight)
        navigationBar.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        navigationBar.text = "학사일정"
        navigationBar.font = UIFont.boldSystemFont(ofSize: 30)
        navigationBar.textAlignment = .center
        navigationBar.textColor = .white
        view.addSubview(navigationBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: layoutMargin, y: navigationBar.frame.height/2.6, width: 44, height: 44)
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.addTarget(self, action: #selector(self.backButtonTouchUpInside(sender:)), for: .touchUpInside)
        view.addSubview(backButton)
        
        background.frame = CGRect(x: 0, y: navigationBar.frame.height, width: view.frame.width, height: view.frame.height - navigationBar.frame.height)
        background.backgroundColor = .white
        background.contentSize.height = (95.5 * 12) + (20 * 12) + 60
        view.addSubview(background)
    }
    
    @objc func backButtonTouchUpInside(sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getSchdule() {
        Alamofire.request("http://dsisteam.com/thisis/Calendar/Calendar_json_new.php").responseJSON { (response)in
            guard let data = response.data else {return}
            do {
                let calenarInfo = try JSONDecoder().decode(CalendarInfo.self, from: data)
                //                print("cafeInfo\n\(calenarInfo)")
                //                print("\(calenarInfo.result.count)")
                for i in 0..<calenarInfo.result.count {
                    let str = calenarInfo.result[i].date
                    let start = str.index(str.startIndex, offsetBy: 5), end = str.index(str.startIndex, offsetBy: 7)
                    let range = start..<end
                    let index = Int(str.substring(with: range))
                    self.ScheduleContent[index! - 1].append(schedule(date: calenarInfo.result[i].date, calendar: calenarInfo.result[i].calendar))
                }
                DispatchQueue.main.async {
                    self.viewSchedule()
                }
            } catch let jsonErr {
                print("Error = \(jsonErr)")
            }
        }
    }
    
    func viewSchedule() {
        let contentColor = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
        let Height : CGFloat = 95.5, Width = self.view.frame.width / 8
        let month = Calendar.current.component(.month, from: .init())
        var i = month - 1, index : Int = 0
        
        var cal = [UILabel]()
        for _ in 0..<12 {
            cal.append(UILabel())
        }
        
        for i in 0..<12 {
            if i != 0 {
                cal[i].frame = CGRect(x: Width, y: cal[i-1].frame.maxY + 20, width: Width * 6, height: Height)
            }
            else {
                cal[0].frame = CGRect(x: Width, y: 40, width: Width * 6, height: Height)
            }
            cal[i].backgroundColor = contentColor
            self.background.addSubview(cal[i])
        }
//        while true {
//            let cal = [UILabel]()
//            let content = UITextView()
//            content.frame = CGRect(x: self.view.frame.width / 8, y: 40 + (CGRect(i) * Height), width: self.view.frame, height: <#T##CGFloat#>)
//        }
    }
}
