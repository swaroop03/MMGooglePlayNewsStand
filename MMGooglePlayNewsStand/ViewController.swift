//
//  ViewController.swift
//  MMGooglePlayNewsStand
//
//  Created by mukesh mandora on 25/08/15.
//  Copyright (c) 2015 madapps. All rights reserved.
//

import UIKit

class ViewController: UIViewController,MMPlayPageControllerDelegate {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
   
    @IBOutlet weak var showDemoBut: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        initPlayStand()
        showDemoBut.tintColor=UIColor.white
        showDemoBut.setImage(UIImage(named: "news")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.normal)
        showDemoBut.backgroundColor=UIColor(hexString: "4caf50")
        showDemoBut.layer.cornerRadius=showDemoBut.frame.size.width/2
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initPlayStand(){
        self.present(appDelegate.walkthrough!, animated: true, completion: nil)
        
        let stb = UIStoryboard(name: "Main", bundle: nil)
        
        
        let page_zero = stb.instantiateViewController(withIdentifier: "stand_one") as! MMSampleTableViewController
        let page_one = stb.instantiateViewController(withIdentifier: "stand_one") as! MMSampleTableViewController
        let page_two = stb.instantiateViewController(withIdentifier: "stand_one")as! MMSampleTableViewController
        let page_three = stb.instantiateViewController(withIdentifier: "stand_one") as! MMSampleTableViewController
        let page_four = stb.instantiateViewController(withIdentifier: "stand_one") as! MMSampleTableViewController
        let page_five = stb.instantiateViewController(withIdentifier: "stand_one") as! MMSampleTableViewController
        
        //header Color
        page_zero.tag=1
        page_one.tag=2
        page_two.tag=3
        page_three.tag=4
        page_four.tag=5
        page_five.tag=6
        
        // Attach the pages to the master
        appDelegate.walkthrough?.delegate = self
        appDelegate.walkthrough?.addViewControllerWithTitleandColor(vc:page_zero, title: "Highlights", color: UIColor(hexString: "9c27b0"))
        appDelegate.walkthrough?.addViewControllerWithTitleandColor(vc:page_one, title: "Sports", color:UIColor(hexString: "009688"))
       
        appDelegate.walkthrough?.addViewControllerWithTitleandColor(vc:page_two, title: "Entertainment", color:UIColor(hexString: "673ab7"))
        

        appDelegate.walkthrough?.addViewControllerWithTitleandColor(vc:page_three, title: "Technology", color: UIColor(hexString: "ff9800"))
        
        appDelegate.walkthrough?.addViewControllerWithTitleandColor(vc:page_four, title: "Business", color: UIColor(hexString: "03a9f4"))
        
        appDelegate.walkthrough?.addViewControllerWithTitleandColor(vc:page_five, title: "World", color: UIColor(hexString: "4caf50"))
        

    }

    @IBAction func showDemoAction(sender: AnyObject) {
        
        initPlayStand()
    }
    
}

