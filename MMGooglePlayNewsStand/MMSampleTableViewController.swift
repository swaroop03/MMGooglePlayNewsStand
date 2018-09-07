//
//  MMSampleTableViewController.swift
//  MMGooglePlayNewsStand
//
//  Created by mukesh mandora on 25/08/15.
//  Copyright (c) 2015 madapps. All rights reserved.
//

import UIKit

@objc protocol scrolldelegateForYAxis{
    
    @objc optional func scrollYAxis(offset:CGFloat , translation:CGPoint)              // If the skipRequest(sender:) action is connected to a button, this function is called when that button is pressed.
    
    @objc optional func getframeindexpathOfController()->CGRect
}

class MMSampleTableViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,MMPlayPageScroll ,UIScrollViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    let header: UIView!
    let headerImage: UIImageView!
    var trans:CGPoint
    var imageArr:[UIImage]!
    var transitionManager : TransitionModel!
    var preventAnimation = Set<NSIndexPath>()
    
    //     weak var scrolldelegate:scrolldelegateForYAxis?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var tag = 0 as Int
    override func viewDidLoad() {
        
        transitionManager = TransitionModel()
        super.viewDidLoad()
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        self.tableView.decelerationRate=UIScrollViewDecelerationRateFast
        header.frame=CGRect(x:0, y:0, width:self.view.frame.width, height:200);
        headerImage.frame=CGRect(x:header.center.x-30, y:header.center.y-30, width:60, height:60)
        headerImage.layer.cornerRadius=headerImage.frame.width/2
        
        
       
        headerImage.tintColor=UIColor.white
        
        
        header.backgroundColor=UIColor.clear
        
        //        header.addSubview(headerImage)
        initHeadr()
        self.view.addSubview(headerImage)
        self.tableView.tableHeaderView=header;
        // Do any additional setup after loading the view.
        self.setNeedsStatusBarAppearanceUpdate()
        
        imageArr.append(UIImage(named: "ironman.jpg")!)
        imageArr.append(UIImage(named: "worldbg.jpg")!)
        imageArr.append(UIImage(named: "sportsbg.jpg")!)
        imageArr.append(UIImage(named: "applebg.png")!)
        imageArr.append(UIImage(named: "businessbg.jpg")!)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        header=UIView()
        headerImage=UIImageView()
        headerImage.backgroundColor=UIColor(hexString: "109B96")
        headerImage.contentMode=UIViewContentMode.center
        headerImage.clipsToBounds=true
        trans=CGPoint(x:0, y:0)
        imageArr = Array()
        super.init(coder: aDecoder)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func initHeadr(){
        //header Color
  
        switch ( tag){
        case 1:
             headerImage.backgroundColor=UIColor(hexString: "9c27b0")
            headerImage.image=UIImage(named: "highlights")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            break
            
        case 2:
             headerImage.backgroundColor=UIColor(hexString: "009688")
              headerImage.image=UIImage(named: "sports")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            break
            
        case 3:
             headerImage.backgroundColor=UIColor(hexString: "673ab7")
              headerImage.image=UIImage(named: "movie")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            break
            
        case 4:
             headerImage.backgroundColor=UIColor(hexString: "ff9800")
              headerImage.image=UIImage(named: "tech")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            break
            
        case 5:
             headerImage.backgroundColor=UIColor(hexString: "03a9f4")
              headerImage.image=UIImage(named: "business")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            break
            
        default:
             headerImage.backgroundColor=UIColor(hexString: "4caf50")
             headerImage.image=UIImage(named: "world")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            break
        }
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !preventAnimation.contains(indexPath as NSIndexPath) {
            preventAnimation.insert(indexPath as NSIndexPath)
            TipInCellAnimator.animate(cell: cell)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NewsCellTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NewsCellTableViewCell
        
        cell.headerImage.image=imageArr[indexPath.row]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = self.storyboard?.instantiateViewController(withIdentifier: "detail") as! DetailViewController
        detail.modalPresentationStyle = UIModalPresentationStyle.custom;
        detail.transitioningDelegate = transitionManager;
        appDelegate.walkthrough?.present(detail, animated: true, completion: nil)
//        self.presentViewController(detail, animated: true, completion: nil)

    }
    
    //MARK:  - Scroll delegate
    
    func walkthroughDidScroll(position:CGFloat, offset:CGFloat) {
        //        NSLog("In controller%f %f", offset,position)
        
    }
    
    private func scrollViewDidScroll(scrollView: UIScrollView) {
        
        trans = CGPoint(x:scrollView.contentOffset.x, y:scrollView.contentOffset.y);
        appDelegate.walkthrough!.scrollYAxis(offset: scrollView.contentOffset.y, translation: trans)
    }
    
    
    
    
}

