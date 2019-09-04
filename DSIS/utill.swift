//
//  utill.swift
//  DSIS
//
//  Created by 주성호 on 04/09/2019.
//  Copyright © 2019 주성호. All rights reserved.
//

import Foundation
import UIKit

//Common Value (X이전, X이후)
var statusBarHeight: CGFloat = 0 // 20, 44
var navigationBarHeight: CGFloat = 0 // 44, 97 = 44+53(일반적인 NavigationBar + LargeTitle)
var homeIndicatorHeight: CGFloat = 0 // 0, 34
var tabBarHeight: CGFloat = 0 // 49, 49
var layoutMargin: CGFloat = 0 // 0, 16 - 둘다 16으로 놓는게 레이아웃 구성하기 편함
var TitleBarHeight: CGFloat = 0 //view.frame.height/8
var phoneMode: CGFloat = 0

//UIColor
let MainColor = UIColor(red: 100/255, green: 180/255, blue: 246/255, alpha: 1) //주로 사용할 컬러
//struct
struct CafeteriaInfo: Decodable { //학식파싱 전체형식
    let cafeteria_professor_sh: [BuildingMenu] //교수회관(승학)
    let cafeteria_student_sh: [BuildingMenu] //학생회관(승학)
    let cafeteria_library_sh: [BuildingMenu] //도서관(승학)
    let cafeteria_domitory_bm: [BuildingMenu] //기숙사(부민)
    let cafeteria_professor_bm: [BuildingMenu] //교수회관(부민)
    let cafeteria_student_bm: [BuildingMenu] //학생회관(부민)
    let cafeteria_domitory_sh: [BuildingMenu] //기숙사(승학)
}
struct BuildingMenu: Decodable { //학시파싱 세부형식
    let setMenu: String //세트
    let oneMenu: String //단품
    let snackMenu: String //스낵
    let date: String //날짜
}

//extension
extension UIColor { //UIColor 컴포넌트로 hex코드를 추가
    convenience init(hex: Int) {
        let components = (
            R : CGFloat((hex >> 16) & 0xff) / 255,
            G : CGFloat((hex >> 08) & 0xff) / 255,
            B : CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
}
