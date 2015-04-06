TTITransition
=============

Modal (interactive) transition between ViewControllers – Easy and beautifull.

###NEW: Interactive Transitioning###
See below for details.




Following transitions are implemented: "slide", "overlay", "full", "fold", "spinn", "scale" and "hang into", perfect for AlertViewish views – more are about to come.

##Slide Transition:##
![Slide Transition Screencast](/Images/TTITransitionSlide.gif?raw=true "Slide Transition Screencast" = 200px)

##Overlay Transition:##
![Overlay Transition Screencast](/Images/TTITransitionOverlay.gif?raw=true "Overlay Transition Screencast"  = 200px) 


##Fold Transition:##
![Fold Transition Screencast](/Images/TTITransitionFold.gif?raw=true "Fold Transition Screencast" loop=infinite  = 200px)

##Hang Into Transition:##
![Hang In Transition Screencast](/Images/TTITransitionHangInto.gif?raw=true "Hang Into Transition Screencast" loop=infinite  = 200px)

##Fall Into Transition:##
![Fall In Transition Screencast](/Images/TTITransitionFallInto.gif?raw=true "Fall Into Transition Screencast" loop=infinite  = 250px)

##Full Transition:##
![Full Transition Screencast](/Images/TTITransitionFull.gif?raw=true "Full Transition Screencast" loop=infinite  = 250px)

##Scale Transition:##
![Scale Transition Screencast](/Images/TTITransitionScale.gif?raw=true "Scale Transition Screencast" loop=infinite  = 220px)

##Spinn Transition:##
![Spinn Transition Screencast](/Images/TTITransitionSpinn.gif?raw=true "Spinn Transition Screencast" loop=infinite  = 220px)




##How to use##
Just set the transitioningDelegate of the presented ViewController to an instance of TTITransitioningDelegate (import it with `#import "TTITransitioningDelegate.h"`) and let the segue-magic happen (or present the ViewController manually using ```presentViewController:animated:```).

###Interaction###
If you want you presented ViewController to be dismissable by a gesture, just set the ```interactive``` property of your ```TTITransitioningDelegate``` to ```YES``` and chose the ```UIGestureRecognizer```of your convenience just by setting the ```gestureType``` property.

You can chose between the following gestures:
* ```TTIGestureRecognizerPinch``` a pinch gesture
* ```TTIGestureRecognizerLeftEdge``` a swipe gesture form the left edge of the screen (might sound familiar if you think about a UINavigationController)
* ```TTIGestureRecognizerRightEdge``` the same as the previous one, from the right edge
* ```TTIGestureRecognizerPullUpDown``` and ```TTIGestureRecognizerPullLeftRight``` a pan gesture – When you have specified the ```rectForPanGestureToStart``` property, the user can dismiss the new ViewController by using a pan gesture starting in the specified ```CGRect```.
* ```TTIGestureRecognizerPanToEdge``` a pan gesture that slides the ViewController to the ```toPoint``` that you have specified.

That is all you have to do. Just set the two properties and you are good to go. Your ViewController will be dismissable by the gesture of your choice.

Also make sure that the property, holding the TTITransitioningDelegate instance, is **not released** as long as the new ViewController is presented!
You can do so, by using a property or an local instance variable.


```Objective-C
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *destination = segue.destinationViewController;
    
    //Make sure this property is not released immediately!
    //For example use a property or instance variable!
    _transitionDelegate = [TTITransitioningDelegate new];
    _transitionDelegate.fromPoint = CGPointMake(self.view.frame.origin.x+(self.view.frame.size.width/2), self.view.frame.origin.y+(self.view.frame.size.height/2));
    
    if([segue.identifier isEqualToString:@"ShowFull"]) {
        _transitionDelegate.transitionType = TTITransitionTypeFull;
        _transitionDelegate.interactive = YES;
        _transitionDelegate.gestureType = TTIGestureRecognizerPinch;
    }
    else if([segue.identifier isEqualToString:@"ShowOverlay"]) {
        _transitionDelegate.transitionType = TTITransitionTypeOverlay;
        _transitionDelegate.interactive = YES;
        _transitionDelegate.gestureType = TTIGestureRecognizerPullUpDown;
        //Example for a toPoint
        _transitionDelegate.toPoint = CGPointMake(200, 200);
        
        //Set it here or in the presented UIViewController
        _transitionDelegate.rectForPanGestureToStart = CGRectMake(0, 0, 100, 100);
    }
     else if([segue.identifier isEqualToString:@"ShowFallIn"]) {
        _transitionDelegate.transitionType = TTITransitionTypeFallIn;
        _transitionDelegate.interactive = YES;
        _transitionDelegate.gestureType = TTIGestureRecognizerPanToEdge;
        _transitionDelegate.toPoint = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, 0);
    }
    //... just set the transition and gesture type you want
    destination.transitioningDelegate = _transitionDelegate;
}

```

**Tip:**
If you want to see the actual ```tintColor``` in the performing transition, you can set this property in the ```viewDidLoad()``` of the newly presented ViewController.

##Customization##
You can change the point from which the new ViewController fades in by setting the `_transitionDelegate.fromPoint` property to the CGPoint you like.

The ```_transitionDelegate.toPoint``` specified where the presented ViewController will fade out to. 
If you want them to fade into a different direction just change the `_transitionDelegate.toPoint` property before the ViewController is dismissed.

You can also change the ```UIGestureRecognizer```type by setting the desired ```gestureType```
##Related##
I use this transition-technique in my own app.
Please take a look at [TourTime](https://anerma.de/TourTime/), the app that measures the time you need to get from one location to another without draining your battery.
- [Website](https://anerma.de/TourTime/)
- [AppStore](https://itunes.apple.com/app/id848979893)

##Credits##
###Please read through the next passage as well###
Please feel free to use and have fun with **TTITransition**. If you do so, I would appreciate if you send me some kind of notification.
Also please be so kind and leave a short link in your app.

##License##
TTITransition is published under MIT License

    Copyright (c) 2015 Andreas Neusüß (@Klaarname)
    Permission is hereby granted, free of charge, to any person obtaining a copy of
    this software and associated documentation files (the "Software"), to deal in
    the Software without restriction, including without limitation the rights to use,
    copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
    Software, and to permit persons to whom the Software is furnished to do so,
    subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.