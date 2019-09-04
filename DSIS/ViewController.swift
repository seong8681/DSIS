//
//  ViewController.swift
//  DSISPrototype
//
//  Created by simgeunwoong on 2019/08/12.
//  Copyright © 2019 Underside_simgeunwoong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let mainButtonLabel: [String] = ["게시판", "교내식당", "교내지도", "도서관", "배달", "개발자", "ThisStopIS", "학사일정", "디스이즈웹", "학생정보"]
    
    override func viewDidAppear(_ animated: Bool) {
        //        navigationController?.navigationBar.color
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        print("viewHeight =", view.frame.height)
        print("statusBarHeight =", statusBarHeight)
        print("homeIndicatorHeight =", homeIndicatorHeight)
        let buttonHeight: CGFloat = (view.frame.height-statusBarHeight-homeIndicatorHeight) / CGFloat(mainButtonLabel.count)
        for buttonIndex in 0..<mainButtonLabel.count {
            let mainButton = UIButton()
            mainButton.frame = CGRect(x: 0, y: statusBarHeight+CGFloat(buttonIndex)*buttonHeight, width: view.frame.width, height: buttonHeight)
            mainButton.layer.borderWidth = 0.5
            mainButton.layer.borderColor = UIColor.black.cgColor
            mainButton.tag = buttonIndex
            mainButton.setTitle(mainButtonLabel[buttonIndex], for: .normal)
            mainButton.setTitleColor(UIColor.black, for: .normal)
            mainButton.addTarget(self, action: #selector(self.mainButtonTouch(sender:)), for: .touchUpInside)
            view.addSubview(mainButton)
        }
    }
    @objc func mainButtonTouch(sender: UIButton) {
        print("mainButtonTouch")
        switch sender.tag {
        case 7: // 학사일정
            let vc = SchduleViewController()
//            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        default:
            return
        }
    }
    override func loadView() {
        super.loadView()
        commonValueUpdate()
    }
    func commonValueUpdate() {
        print("commonValueUpdate")
        //Common Value Update
        TitleBarHeight = view.frame.height/8
        switch UIScreen.main.bounds.size.height {
        case 812.0: //아이폰X,Xs - 가로 375
            statusBarHeight = 44
            navigationBarHeight = 97
            homeIndicatorHeight = 34
            tabBarHeight = 49
            layoutMargin = 16
            phoneMode = 2
        case 896.0 : //아이폰 XsM,XR - 가로 414
            statusBarHeight = 44
            navigationBarHeight = 97
            homeIndicatorHeight = 34
            tabBarHeight = 49
            layoutMargin = 16
            phoneMode = 2
        default: //그외 : 아이폰se,6,6s,7,8,plus
            statusBarHeight = 20
            navigationBarHeight = 44
            homeIndicatorHeight = 16
            tabBarHeight = 49
            layoutMargin = 16
            phoneMode = 1
        }
    }
}
