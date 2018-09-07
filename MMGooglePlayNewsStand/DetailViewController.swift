//
//  DetailViewController.swift
//  MMGooglePlayNewsStand
//
//  Created by mukesh mandora on 27/08/15.
//  Copyright (c) 2015 madapps. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var textViewDemo: UITextView!
    @IBOutlet weak var textHeightConstraint: NSLayoutConstraint!
    var navBar = UIView()
    var dismissFrame = CGRect.zero
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textHeightConstraint.constant = 450
        
        
        let navBut = UIButton(type: UIButtonType.system)
        let navTitle = UILabel()
        navBar.frame=CGRect(x:0, y:0, width:self.view.bounds.width, height:64)
        navBut.frame=CGRect(x:0, y:16, width:45, height:45)
        navTitle.frame=CGRect(x:55 , y:20, width:self.view.bounds.width-50, height:30)
        
        navBar.backgroundColor = UIColor(hexString: "673ab7")
        navBut.setTitleColor(UIColor.white, for: UIControlState.normal)
        navBut.tintColor=UIColor.white
        navBut.setImage(UIImage(named: "back")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.normal)
        navBut.addTarget(self, action: #selector(DetailViewController.dismiss as (DetailViewController) -> () -> ()), for: UIControlEvents.touchUpInside)
        navTitle.textColor=UIColor.white
        navTitle.font=UIFont(name: "Roboto-Medium", size: 20)
        navTitle.text="Detail Page"
        
        navBar.addSubview(navBut)
        navBar.addSubview(navTitle)
        view.addSubview(navBar)
        
    }
    @objc func dismiss(){
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
