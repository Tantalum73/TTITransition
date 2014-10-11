TTITransition
=============

Modal transition between ViewControllers – Easy and beautifully 

Two transitions are implemented: "overlay" and "full".

##Overlay Transition:##
![Alt text](/Images/Overlay_Transition.gif?raw=true "Optional Title" = 400x708) 

##Full Transition:##
![Alt text](/Images/Full_Transition.gif?raw=true "Optional Title" = 200x354 loop=infinite)

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