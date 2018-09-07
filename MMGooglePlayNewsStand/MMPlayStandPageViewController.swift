//
//  MMPlayStandPageViewController.swift
//  MMGooglePlayNewsStand
//
//  Created by mukesh mandora on 25/08/15.
//  Copyright (c) 2015 madapps. All rights reserved.
//

import UIKit
// MARK: - Protocols -

/**
Page Delegate:
This delegate performs basic operations such as dismissing the pagecontroller or call whatever action on page change.
Probably the container is presented by this delegate.
**/

@objc protocol MMPlayPageControllerDelegate{
    
    @objc optional func containerCloseButtonPressed()              // If the skipRequest(sender:) action is connected to a button, this function is called when that button is pressed.
    @objc optional func containerNextButtonPressed()               //
    @objc optional func containerPrevButtonPressed()               //
    @objc optional func containerPageDidChange(pageNumber:Int)     // Called when current page changes
    
}

/**
Scroll Page:
The page represents any page added to the container.
At the moment it's only used to perform custom animations on didScroll.
**/
@objc protocol MMPlayPageScroll{
    // While sliding to the "next" slide (from right to left), the "current" slide changes its offset from 1.0 to 2.0 while the "next" slide changes it from 0.0 to 1.0
    // While sliding to the "previous" slide (left to right), the current slide changes its offset from 1.0 to 0.0 while the "previous" slide changes it from 2.0 to 1.0
    // The other pages update their offsets whith values like 2.0, 3.0, -2.0... depending on their positions and on the status of the walkthrough
    // This value can be used on the previous, current and next page to perform custom animations on page's subviews.
    
    @objc func walkthroughDidScroll(position:CGFloat, offset:CGFloat)   // Called when the main Scrollview...scrolls
}


@objc class MMPlayStandPageViewController: UIViewController,UIScrollViewDelegate,scrolldelegateForYAxis,UIGestureRecognizerDelegate {
    
    // MARK: - Public properties -
    
    weak var delegate:MMPlayPageControllerDelegate?
    
   
    var check:NSString!
    var menuBut:UIButton!
    var searchBut:UIButton!
    var navTitle : UILabel!
    var horiScroll:UIScrollView!
    var currentColor:UIColor!
    var showStatus = false as Bool
    //ScrollView State
    var lastOffset:CGFloat!
    
    var currentPage:Int{    // The index of the current page (readonly)
        get{
            let page = Int((scrollview.contentOffset.x / view.bounds.size.width))
            return page
        }
        
        
        
    }
    
    // MARK: - Private properties -
    
    private let scrollview:UIScrollView!
    private let bannerImage:JBKenBurnsView!
    private let bannerAlpha:UIView!
    private let bannerThin:UIView!
    private let navBar:UIView!
    private let indicatorcolor:UIView!
    private var controllers:[UIViewController]!
    private var labels:[UILabel]!
    private var titles:[NSString]!
    private var colors:[UIColor]!
    private var lastViewConstraint:NSArray?
    
    required init?(coder aDecoder: NSCoder) {
        // Setup the scrollview
        scrollview = UIScrollView()
        scrollview.showsHorizontalScrollIndicator = false
        scrollview.showsVerticalScrollIndicator = false
        scrollview.isPagingEnabled = true
        scrollview.isScrollEnabled=true
        scrollview.decelerationRate=UIScrollViewDecelerationRateFast
        
        // Controllers as empty array
        controllers = Array()
        titles = Array()
        colors = Array()
        labels = Array()
        navTitle = UILabel()
        //ImageView
        bannerImage=JBKenBurnsView();
        bannerAlpha=UIView();
        bannerThin=UIView();
        //NavBut
        navBar=UIView();
        indicatorcolor=UIView();
        menuBut =  UIButton(type: UIButtonType.system)
        searchBut = UIButton(type: UIButtonType.system)
        super.init(coder: aDecoder)
    }
    
    
    func createHorizontalScroller(){
       
        var x , y ,buffer:CGFloat
        
        
        horiScroll=UIScrollView();
        horiScroll.frame=CGRect(x:0, y:145, width:self.view.frame.width, height:64)
        
        view.insertSubview(horiScroll, aboveSubview: scrollview);
        
        x=0;y=0;buffer=10
       
        
        for i in 0..<titles.count {
            
            var titleLabel:UILabel!
            var bottomView:UIView!
            titleLabel=UILabel();
            
            
            //Label
            titleLabel.font=UIFont(name: "Roboto-Medium", size: 14)
            titleLabel.text=titles[i].uppercased as String
            titleLabel.isUserInteractionEnabled=true
            let lblWidth:CGFloat
            lblWidth = titleLabel.intrinsicContentSize.width + 32
            
            titleLabel.frame=CGRect(x:x, y:16, width:lblWidth, height:34)
            titleLabel.textAlignment=NSTextAlignment.center
            titleLabel.tag=i+1
            titleLabel.textColor=UIColor.white
            
            //Bottom
            bottomView=UIView()
            bottomView.backgroundColor=UIColor.white
            
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
            tap.delegate = self
            titleLabel.addGestureRecognizer(tap)
            
            
            horiScroll.addSubview(titleLabel)
            labels.append(titleLabel)
            
            x+=lblWidth+buffer
        }
        horiScroll.showsHorizontalScrollIndicator=false;
        horiScroll.backgroundColor=UIColor.clear;
        horiScroll.contentSize=CGSize(width:x, height:64)
        horiScroll.contentInset = UIEdgeInsetsMake(0, self.view.center.x-25, 0, 0.0);
        horiScroll.contentOffset=CGPoint(x:-(self.view.center.x-50), y:y)
//        horiScroll.delegate = self
        horiScroll.translatesAutoresizingMaskIntoConstraints = false
        
        if(titles.count != 0){
            indicatorcolor.frame=CGRect(x:labels[0].frame.origin.x,
                                        y:61,
                                        width:labels[0].intrinsicContentSize.width+32,
                                        height:3)
            indicatorcolor.backgroundColor=colors[0]
            horiScroll.addSubview(indicatorcolor)
        }
        
        self.view.bringSubview(toFront: horiScroll)

    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        scrollview = UIScrollView()
        controllers = Array()
        titles = Array()
        colors = Array()
        bannerImage=JBKenBurnsView();
        bannerAlpha=UIView();
        bannerThin=UIView();
        labels = Array()
        navTitle = UILabel()
        //NavBut
        indicatorcolor=UIView();
        navBar=UIView();
        menuBut =  UIButton(type: UIButtonType.system)
        searchBut = UIButton(type: UIButtonType.system)
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // Initialize UIScrollView
        
        scrollview.delegate = self
        scrollview.backgroundColor=UIColor.clear
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        
        view.insertSubview(scrollview, at: 0) //scrollview is inserted as first view of the hierarchy
        
        // Set scrollview related constraints
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[scrollview]-0-|", options:[], metrics: nil, views: ["scrollview":scrollview]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[scrollview]-0-|", options:[], metrics: nil, views: ["scrollview":scrollview]))
        
       
        bannerImage.frame=CGRect(x:0, y:0, width:self.view.frame.width, height:250)
        view.insertSubview(bannerImage, belowSubview: scrollview);
        view.insertSubview(bannerAlpha, aboveSubview: bannerImage);
        view.insertSubview(bannerThin, aboveSubview: bannerAlpha);
//        bannerImage.image=UIImage(named: "bg.jpg");
        bannerImage.clipsToBounds=true
//        bannerImage.contentMode=UIViewContentMode.ScaleAspectFill
        
        
        bannerImage.backgroundColor=UIColor.clear
        bannerAlpha.frame=bannerImage.frame;
        bannerAlpha.alpha=0.3;
        bannerThin.frame=bannerImage.frame;
        bannerThin.alpha=0.3;
        bannerAlpha.backgroundColor=UIColor.black
        bannerThin.backgroundColor=UIColor.black
        
        //NavBut
        navBar.frame=CGRect(x:0, y:0, width:self.view.frame.width, height:64);
        navBar.backgroundColor=UIColor.clear
        
        
        
        menuBut.frame = CGRect(x:16, y:27 , width:20, height:20)
        menuBut.tintColor=UIColor.white
        menuBut.setImage(UIImage(named: "menu")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.normal)
        
        navTitle.frame = CGRect(x:50, y:21 , width:100, height:30)
        navTitle.text = "Read Now"
        navTitle.textColor=UIColor.white
        navTitle.alpha=0;
        navTitle.font=UIFont(name: "Roboto-Medium", size: 20)
        
        searchBut.frame = CGRect(x:self.view.frame.width-40, y:27 , width:20, height:20)
        searchBut.setImage(UIImage(named: "search")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.normal)
        searchBut.tintColor=UIColor.white
        
        navBar.addSubview(menuBut)
        navBar.addSubview(searchBut)
        navBar.addSubview(navTitle)
        view.insertSubview(navBar, aboveSubview: scrollview);
        
       self.setNeedsStatusBarAppearanceUpdate()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return showStatus
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        createHorizontalScroller()
        currentColor=colors[0]
        self.bannerAlpha.mdInflateAnimated(from: CGPoint(x:self.bannerImage.center.x , y:self.bannerImage.center.y), backgroundColor: self.currentColor, duration: 0.6, completion: nil)
        var images :[UIImage]!
        images=Array()
        images.append(UIImage(named: "ironman.jpg")!)
        images.append(UIImage(named: "worldbg.jpg")!)
        images.append(UIImage(named: "sportsbg.jpg")!)
        images.append(UIImage(named: "applebg.png")!)
        images.append(UIImage(named: "businessbg.jpg")!)
        bannerImage.animate(withImages: images, transitionDuration:6, initialDelay: 0, loop: true, isLandscape: true)

    }
    
    
    // MARK: - Tap Gesture
    
    
    func handleTap(sender:UIGestureRecognizer){
        
        scrollview.scrollRectToVisible(controllers[sender.view!.tag-1].view.frame, animated: true)
        currentColor=colors[sender.view!.tag-1]
        // Notify delegate about the new page
        
        if(navBar.backgroundColor != UIColor.clear){
            UIView.animate(withDuration:0.2, animations: { () -> Void in
                self.indicatorcolor.frame=CGRect(x:self.labels[sender.view!.tag-1].frame.origin.x,
                                                 y:61,
                                                 width:self.labels[sender.view!.tag-1].intrinsicContentSize.width+32,
                                                 height:3)
                self.indicatorcolor.backgroundColor=UIColor.white
                self.horiScroll.scrollRectToVisible(self.labels[sender.view!.tag-1].frame, animated: true)
                self.navBar.backgroundColor=self.currentColor
                self.horiScroll.backgroundColor=self.currentColor
            })
            
            
        }
        else{
            
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.indicatorcolor.frame=CGRect(x:self.labels[sender.view!.tag-1].frame.origin.x,
                                                 y:61,
                                                 width:self.labels[sender.view!.tag-1].intrinsicContentSize.width+32,
                                                 height:3)
                self.indicatorcolor.backgroundColor=self.currentColor
//                self.horiScroll.scrollRectToVisible(self.labels[sender.view!.tag-1].frame, animated: true)
                
                //Center Content
                self.horiScroll.setContentOffset(CGPoint(x:-(self.view.center.x-50)+self.labels[sender.view!.tag-1].center.x-self.labels[sender.view!.tag-1].frame.size.width/2, y:0), animated: true)
                
                
            })
            
        }
        self.bannerAlpha.mdInflateAnimated(from: CGPoint(x:self.bannerImage.center.x , y:self.bannerImage.center.y), backgroundColor: self.currentColor, duration: 0.6, completion: nil)
    }
    
    /**
    addViewController
   
    */
    func addViewController(vc:UIViewController)->Void{
        
        controllers.append(vc)
        
        // Setup the viewController view
        
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        scrollview.addSubview(vc.view)
        
        // Constraints
        
        let metricDict = ["w":vc.view.bounds.size.width,"h":vc.view.bounds.size.height]
        
        // - Generic cnst
        
        
        vc.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[view(h)]", options:[], metrics: metricDict, views: ["view":vc.view]))
        vc.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[view(w)]", options:[], metrics: metricDict, views: ["view":vc.view]))
        scrollview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]|", options:[], metrics: nil, views: ["view":vc.view]))
        
        // cnst for position: 1st element
        
        if controllers.count == 1{
            scrollview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]", options:[], metrics: nil, views: ["view":vc.view,]))
            
            // cnst for position: other elements
            
        }else{
            
            let previousVC = controllers[controllers.count-2]
            let previousView = previousVC.view;
            
            scrollview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"H:[previousView]-0-[view]", options:[], metrics: nil, views: ["previousView":previousView as Any,"view":vc.view]))
            
            if let cst = lastViewConstraint{
                scrollview.removeConstraints(cst as! [NSLayoutConstraint])
            }
            lastViewConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:[view]-0-|", options:[], metrics: nil, views: ["view":vc.view]) as NSArray
            scrollview.addConstraints(lastViewConstraint! as! [NSLayoutConstraint])
            
        }
    }
    
    func addViewControllerWithTitleandColor(vc:UIViewController , title:NSString , color:UIColor)->Void{
        
        controllers.append(vc)
        titles.append(title)
        colors.append(color)
        //        NSLog("%@",titles)
        // Setup the viewController view
        
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        scrollview.addSubview(vc.view)
        
        // Constraints
        
        let metricDict = ["w":vc.view.bounds.size.width,"h":vc.view.bounds.size.height]
        
        // - Generic cnst
        
        
        vc.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"V:[view(h)]", options:[], metrics: metricDict, views: ["view":vc.view]))
        vc.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"H:[view(w)]", options:[], metrics: metricDict, views: ["view":vc.view]))
        scrollview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]|", options:[], metrics: nil, views: ["view":vc.view,]))
        
        // cnst for position: 1st element
        
        if controllers.count == 1{
            scrollview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]", options:[], metrics: nil, views: ["view":vc.view,]))
            
            // cnst for position: other elements
            
        }else{
            
            let previousVC = controllers[controllers.count-2]
            let previousView = previousVC.view;
            
            scrollview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[previousView]-0-[view]", options:[], metrics: nil, views: ["previousView":previousView,"view":vc.view]))
            
            if let cst = lastViewConstraint{
                scrollview.removeConstraints(cst as! [NSLayoutConstraint])
            }
            lastViewConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:[view]-0-|", options:[], metrics: nil, views: ["view":vc.view]) as NSArray
            scrollview.addConstraints(lastViewConstraint! as! [NSLayoutConstraint])
            
        }
    }
    
    
    /**
    Update the UI to reflect the current walkthrough situation
    **/
    
    private func updateUI(){
        
        // Get the current page
        //        NSLog("up %d",currentPage);
        //        pageControl?.currentPage = currentPage
        
        currentColor=colors[currentPage]
        // Notify delegate about the new page
        
        if(navBar.backgroundColor != UIColor.clear){
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.indicatorcolor.frame=CGRect(x:self.labels[self.currentPage].frame.origin.x, y:61, width:self.labels[self.currentPage].intrinsicContentSize.width+32, height:3)
                self.indicatorcolor.backgroundColor=UIColor.white
                self.horiScroll.scrollRectToVisible(self.labels[self.currentPage].frame, animated: true)
                
                self.navBar.backgroundColor=self.currentColor
                self.horiScroll.backgroundColor=self.currentColor
                
            })
            
            
        }
        else{
            
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.indicatorcolor.frame=CGRect(x: self.labels[self.currentPage].frame.origin.x, y:61, width:self.labels[self.currentPage].intrinsicContentSize.width+32, height:3)
                self.indicatorcolor.backgroundColor=self.currentColor
                
                //Center Content
                self.horiScroll.setContentOffset(CGPoint(x:-(self.view.center.x-50)+self.labels[self.currentPage].center.x-self.labels[self.currentPage].frame.size.width/2, y:0), animated: true)
                
                
            })
            
        }
        self.bannerAlpha.mdInflateAnimated(from: CGPoint(x:self.bannerImage.center.x , y:self.bannerImage.center.y), backgroundColor: self.currentColor, duration: 0.6, completion: nil)
        
        
        
        
    }
    
    
    // MARK: - Scrollview Delegate -
    
    func scrollViewDidScroll(_ sv: UIScrollView) {
        
        
        for i in 0..<controllers.count {
            
            if let vc = controllers[i] as? MMPlayPageScroll{
                
                let mx = ((scrollview.contentOffset.x + view.bounds.size.width) - (view.bounds.size.width * CGFloat(i))) / view.bounds.size.width
                
                // While sliding to the "next" slide (from right to left), the "current" slide changes its offset from 1.0 to 2.0 while the "next" slide changes it from 0.0 to 1.0
                // While sliding to the "previous" slide (left to right), the current slide changes its offset from 1.0 to 0.0 while the "previous" slide changes it from 2.0 to 1.0
                // The other pages update their offsets whith values like 2.0, 3.0, -2.0... depending on their positions and on the status of the walkthrough
                // This value can be used on the previous, current and next page to perform custom animations on page's subviews.
                
                // print the mx value to get more info.
                // println("\(i):\(mx)")
                
                // We animate only the previous, current and next page
                //                NSLog("%f %f", scrollview.contentOffset.x,mx)
                if(mx < 2 && mx > -2.0){
                    
                    vc.walkthroughDidScroll(position: scrollview.contentOffset.x, offset: mx)
                    
                }
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateUI()
    }
    
    
    
    /* WIP */
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        print("CHANGE")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("SIZE")
    }
    
    
    //MARK Y-axis
    func scrollYAxis(offset:CGFloat ,translation:CGPoint) {
        if(offset > 0){
            var horiScrollTransform : CATransform3D! = CATransform3DIdentity
            var navBarTransform : CATransform3D! = CATransform3DIdentity
            var imageTransform : CATransform3D! = CATransform3DIdentity
            //        NSLog("Hello Y-Axis %f",offset)
            for i in 0..<controllers.count {
                if(controllers[i] is (MMSampleTableViewController)){
                    let temp=controllers[i] as! MMSampleTableViewController
                    temp.tableView.contentOffset=CGPoint(x:0, y:offset)
                    
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        if(offset > 10){
                            temp.headerImage.alpha=0
                        }
                        else {
                            temp.headerImage.alpha=1
                        }
                        
                        
                    })
                }
                if( currentPage == i){
                    //Color Change
                    
                    if(lastOffset > offset){
                        if(offset < 100   ){
                            
                            showStatus =  false
                            setNeedsStatusBarAppearanceUpdate()
                            self.horiScroll.setContentOffset(CGPoint(x:-(self.view.center.x-50)+self.labels[self.currentPage].center.x-self.labels[self.currentPage].frame.size.width/2, y:0), animated: true)
                            UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: { () -> Void in
                                self.horiScroll.contentInset = UIEdgeInsetsMake(0, self.view.center.x-25, 0, 0.0);
//                                self.horiScroll.setContentOffset(CGPointMake(-(self.view.center.x-50), 0), animated: true)
                                self.horiScroll.backgroundColor=UIColor.clear
                                self.navBar.backgroundColor=UIColor.clear
                                self.indicatorcolor.backgroundColor=self.currentColor;
                                
                                 self.navTitle.alpha=0;
                                
                                
                                }, completion: nil)
                            
                            
                        }
                        
                    }
                    else{
                            if(offset > 220   ){
                                UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: { () -> Void in
                                    self.horiScroll.backgroundColor=self.currentColor
                                    self.navBar.backgroundColor=self.currentColor
                                    self.navTitle.alpha=1;
                                    self.indicatorcolor.backgroundColor=UIColor.white
                                    self.horiScroll.contentInset = UIEdgeInsetsMake(0, 0, 0, 0.0);
                                    //                            horiScroll.contentOffset=CGPointMake(0, 0)
                                    self.horiScroll.scrollRectToVisible(self.labels[self.currentPage].frame, animated: true)

                                    }, completion: nil)
                                
                            
                        }
                        
                        
                    }
                    
                    //Translation
                    if(offset > 0){
                        horiScrollTransform=CATransform3DTranslate(horiScrollTransform, 0, -offset, 0)
                        horiScroll.layer.transform=horiScrollTransform
                        
                        let x = bannerImage.frame.origin.x
                        let w = bannerImage.bounds.width
                        let h = bannerImage.bounds.height
                        let y = -((offset - bannerImage.frame.origin.y) / 75) * 25
                        imageTransform=CATransform3DTranslate(imageTransform, 0, -offset, 0)
                        
                        bannerImage.frame = CGRect(x:x, y:y, width:w, height:h)
                        bannerAlpha.frame = CGRect(x:x, y:y, width:w, height:h)
                        bannerThin.frame = CGRect(x:x, y:y, width:w, height:h)
//                        bannerImage.layer.transform=imageTransform
//                        bannerAlpha.layer.transform=imageTransform
//                        bannerThin.layer.transform=imageTransform
                        if(offset > 100){
                            showStatus =  true
                            setNeedsStatusBarAppearanceUpdate()

                            navBarTransform=CATransform3DTranslate(navBarTransform, 0, -offset+100, 0)
                            navBar.layer.transform=navBarTransform
                        }
                        else{
                            
                        }
                        
                    }
                    
                    
                }
            }
            
            
        }
        lastOffset=offset
        
    }
    func getframeindexpathOfController()-> CGRect{
         let temp = controllers[currentPage] as! MMSampleTableViewController
        
        return temp.tableView.framesForRowAtIndexPath(indexpath: temp.tableView.indexPathForSelectedRow! as NSIndexPath)
    }
    
}

