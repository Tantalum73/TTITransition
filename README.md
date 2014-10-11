TTITransition
=============

Modal transition between ViewControllers – Easy and beautifully 

Two transitions are implemented: "overlay" and "full".

##Overlay Transition:##
![Overlay Transition Screencast](/Images/Overlay_Transition.gif?raw=true "Overlay Transition Screencast") 

##Full Transition:##
![Full Transition Screencast](/Images/Full_Transition.gif?raw=true "Full Transition Screencast" loop=infinite)

##How to use##
```Objective-C
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *destination = segue.destinationViewController;
    
    _transitionDelegate = [TTITransitioningDelegate new];
    _transitionDelegate.fromPoint = CGPointMake(self.view.frame.origin.x+(self.view.frame.size.width/2), self.view.frame.origin.y+(self.view.frame.size.height/2));
    if([segue.identifier isEqualToString:@"ShowFull"]) {
        _transitionDelegate.transitionType = TTIFullTransition;
    }
    else if([segue.identifier isEqualToString:@"ShowOverlay"]) {
        
        _transitionDelegate.transitionType = TTIOverlayTransition;
    }
    
    destination.transitioningDelegate = _transitionDelegate;
}
```
Just set the transitioningDelegate of the presented ViewController to an instance of TTITransitioningDelegate and let the segue-magic happen (or present the ViewController manually).

##Customization##
You can change the point from which the new ViewController fades in by setting the `_transitionDelegate.fromPoint` property to the CGPoint you like.

This point also specified where the presented ViewController will fade out to. 
if you want them to fade into a different direction, just change the `_transitionDelegate.fromPoint` property before the ViewController is dismissed.


##Related##
I use this transition-technique in my own app.
Please take a look at [TourTime](https://anerma.de/TourTime/), the app that measures the time you need to get from one location to another without draining your battery.
- [Website](https://anerma.de/TourTime/)
- [AppStore](https://itunes.apple.com/app/id848979893)
