//
//  TransitionModel.swift
//  MMGooglePlayNewsStand
//
//  Created by mukesh mandora on 27/08/15.
//  Copyright (c) 2015 madapps. All rights reserved.
//

import UIKit

class TransitionModel: NSObject , UIViewControllerAnimatedTransitioning , UIViewControllerTransitioningDelegate {
    
    var isPresenting = false as Bool
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8;
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if(isPresenting){
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! MMPlayStandPageViewController
            
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! DetailViewController

            toVC.view.alpha=0
            transitionContext.containerView.addSubview(toVC.view)
            
            let snapshot = UIView()
            snapshot.backgroundColor=UIColor.white
//            snapshot.frame = fromVC.tableView.framesForRowAtIndexPath(fromVC.tableView.indexPathForSelectedRow()!)
            snapshot.frame = fromVC.getframeindexpathOfController()
            snapshot.frame=CGRect(x:16, y:snapshot.frame.origin.y, width:snapshot.frame.width-32, height:snapshot.frame.height)
//            NSLog("%@", snapshot)
            toVC.dismissFrame = snapshot.frame
            transitionContext.containerView.addSubview(snapshot)
            
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                
                
                snapshot.frame = fromVC.view.frame
                
                
            }, completion: { (Bool) -> Void in
                UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    toVC.view.alpha=1
                    
                }, completion: { (Bool) -> Void in
                    snapshot.alpha=0;
                    snapshot.removeFromSuperview()
                })
                
                transitionContext.completeTransition(true)
            })
            
        }
        else{
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! DetailViewController
            
            _ = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! MMPlayStandPageViewController
            
            let snapshot = UIView()
            snapshot.backgroundColor=UIColor.white
            snapshot.frame = fromVC.view.frame
            transitionContext.containerView.addSubview(snapshot)
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                
                
                fromVC.view.alpha=0
                snapshot.frame = fromVC.dismissFrame
                fromVC.navBar.frame=CGRect(x:0, y:-64, width:fromVC.view.frame.width, height:64)
                
                
                }, completion: { (Bool) -> Void in
                    UIView.animate(withDuration: 0.2, animations: { () -> Void in
                        snapshot.alpha=0;
                       
                    })
                    snapshot.removeFromSuperview()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })

        }
        
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresenting=true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        
        isPresenting=false
        return self
    }
   
}
