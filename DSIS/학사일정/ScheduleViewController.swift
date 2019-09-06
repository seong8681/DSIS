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
        background.backgroundColor = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
        background.contentSize.height = (90 * 18) + (20 * 12) + 60
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
        let Width = self.view.frame.width / 8
        let month = Calendar.current.component(.month, from: .init())
        var i = month - 1, index : Int = 0
        
        var contentView = [UILabel]()
        for _ in 0..<12 {
            contentView.append(UILabel())
        }
        
        while true {
            let Height = 90 + CGFloat((ScheduleContent[i].count - 1) * 50);
            let count = ScheduleContent[i].count
            if i == month - 1 {
                contentView[i].frame = CGRect(x: Width, y: 40, width: Width * 6, height: Height)
            }
            else {
                if i == 0 {
                    contentView[i].frame = CGRect(x: Width, y: contentView[11].frame.maxY + 20, width: Width * 6, height: Height)
                }
                else {
                    contentView[i].frame = CGRect(x: Width, y: contentView[i-1].frame.maxY + 20, width: Width * 6, height: Height)
                }
            }
//            contentView[i].layer.shadowColor = UIColor.black.cgColor
            contentView[i].layer.shadowRadius = 5.0
            contentView[i].layer.shadowOpacity = 0.1
            contentView[i].layer.shadowOffset = CGSize(width: 10, height: 20)
            contentView[i].layer.masksToBounds = false
            contentView[i].backgroundColor = .white
            self.background.addSubview(contentView[i])
            if count != 0 { // 일정이 있는경우
                for cnt in 0..<count {
                    let textLabel = UILabel()
                    textLabel.frame = CGRect(x: layoutMargin, y: 20 + (CGFloat(cnt) * 50), width: contentView[i].frame.width-32, height: 50)
                    textLabel.backgroundColor = .clear
                    contentView[i].addSubview(textLabel)
                    let date = UITextView()
                    date.frame = CGRect(x: 0, y: 0, width: contentView[i].frame.width-32, height: 25)
                    date.isEditable = false
                    date.isScrollEnabled = false
                    date.font = UIFont.boldSystemFont(ofSize: 13)
                    date.backgroundColor = .clear
                    date.text = "\(ScheduleContent[i][cnt].date) : "
                    let cal = UITextView()
                    cal.frame = CGRect(x: 0, y: date.frame.maxY, width: contentView[i].frame.width-32, height: 25)
                    cal.isEditable = false
                    cal.isScrollEnabled = false
                    cal.font = UIFont.systemFont(ofSize: 13)
                    cal.backgroundColor = .clear
                    cal.text = "\(ScheduleContent[i][cnt].calendar)"
                    textLabel.addSubview(date)
                    textLabel.addSubview(cal)
                }
            }
            else { // 일정이 없는경우
                let text = UITextView()
                text.frame = CGRect(x: layoutMargin, y: 5, width: contentView[i].frame.width-32, height: 35)
                text.font = UIFont.boldSystemFont(ofSize: 13)
                text.isEditable = false
                text.isScrollEnabled = false
                text.text = "일정 없음!"
                contentView[i].addSubview(text)
            }
            i += 1
            i %= 12
            if i == month - 1 {
                break
            }
        }
    }
}
