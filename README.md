TTITransition
=============

Modal transition between ViewControllers – Easy and beautifully 

Three transitions are implemented: "slide", "overlay", "full", "fold", "spinn", "scale" and "hang into", perfect for AlertViewish views – more is about to come.

##Slide Transition:##
![Slide Transition Screencast](/Images/Slide_Transition.gif?raw=true "Slide Transition Screencast" = 250px)

##Overlay Transition:##
![Overlay Transition Screencast](/Images/Overlay_Transition.gif?raw=true "Overlay Transition Screencast"  = 250px) 

##Full Transition:##
![Full Transition Screencast](/Images/Full_Transition.gif?raw=true "Full Transition Screencast" loop=infinite  = 250px)

##Fold Transition:##
![Fold Transition Screencast](/Images/Fold_Transition.gif?raw=true "Fold Transition Screencast" loop=infinite  = 250px)

##Hang Into Transition:##
![Hang In Transition Screencast](/Images/Hang_In_Transition.gif?raw=true "Hang Into Transition Screencast" loop=infinite  = 250px)

##Scale Transition:##
![Scale Transition Screencast](/Images/Scale_Transition.gif?raw=true "Scale Transition Screencast" loop=infinite  = 250px)

##Spinn Transition:##
![Spinn Transition Screencast](/Images/Spinn_Transition.gif?raw=true "Spinn Transition Screencast" loop=infinite  = 250px)



##How to use##
```Objective-C
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *destination = segue.destinationViewController;
    
    //Make sure this property is not released immediately!
    //For example use a property or instance variable!
    _transitionDelegate = [TTITransitioningDelegate new];
    _transitionDelegate.fromPoint = CGPointMake(self.view.frame.origin.x+(self.view.frame.size.width/2), self.view.frame.origin.y+(self.view.frame.size.height/2));
    
    if([segue.identifier isEqualToString:@"ShowFull"]) {
        _transitionDelegate.transitionType = TTIFullTransition;
    }
    else if([segue.identifier isEqualToString:@"ShowOverlay"]) {
        
        _transitionDelegate.transitionType = TTIOverlayTransition;
    }
    else if([segue.identifier isEqualToString:@"ShowSlide"]) {
        
        _transitionDelegate.transitionType = TTISlideTransition;
    }
    else if([segue.identifier isEqualToString:@"ShowFold"]) {
        /*Works best under UINavigationBar or above UIToolbar*/
        _transitionDelegate.transitionType = TTIFoldTransition;
    }
    else if([segue.identifier isEqualToString:@"ShowHangIn"]) {
        
        _transitionDelegate.transitionType = TTIHangInTransition;
    }
    else if([segue.identifier isEqualToString:@"ShowSpinn"]) {
        
        _transitionDelegate.transitionType = TTISpinnTransition;
    }
    else if([segue.identifier isEqualToString:@"ShowScale"]) {
        
        _transitionDelegate.transitionType = TTIScaleTransition;
    }
    destination.transitioningDelegate = _transitionDelegate;
}

```
Just set the transitioningDelegate of the presented ViewController to an instance of TTITransitioningDelegate and let the segue-magic happen (or present the ViewController manually).
Also make sure that the property, holding the TTITransitioningDelegate instance, is not released as long as the new ViewController is presented!
You can do so, by using a property or an local instance variable.

##Customization##
You can change the point from which the new ViewController fades in by setting the `_transitionDelegate.fromPoint` property to the CGPoint you like.

This point also specified where the presented ViewController will fade out to. 
if you want them to fade into a different direction, just change the `_transitionDelegate.fromPoint` property before the ViewController is dismissed.

More properties can be customized, individual for the given transition.
##Related##
I use this transition-technique in my own app.
Please take a look at [TourTime](https://anerma.de/TourTime/), the app that measures the time you need to get from one location to another without draining your battery.
- [Website](https://anerma.de/TourTime/)
- [AppStore](https://itunes.apple.com/app/id848979893)
