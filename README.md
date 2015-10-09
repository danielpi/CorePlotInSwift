#Core Plot in Swift

I like programs that display information graphically. I keep wanting to be able to present charted information in my own programs. Core-Plot looks to be the best open source, Cocoa based charting library available. However whenever I try to use it I get bogged down trying to figure out how to get even basic charts to work. 

This project is my attempt to experiment with the framework, make some sense of it and record that information for later.

## Initial Setup
I'm using Cocoapods to manage CorePlot. The Pods Directory is included in this git repository so the example should work no matter what. The steps required to get a project working from scratch are

1. Install Homebrew
2. Use brew to install a clean version of Ruby

    brew install ruby
    
3. Use gem to install cocoapods

    gem install cocoapods
    
4. Create Podfile and add the coreplot dependency
5. Tell cocoapods to do its thing

    pod install
    
6. You need to use a bridging header to be able to access Core Plot from Swift. Create a header file called <app name>-Bridging-Header.h and add the following line to the bottom of it

    #import "CorePlot.h"
    
7. Then in your build settings you need to set the Swift Compiler - Code Generation > Objective-C Bridging Header to point to the file you have just made. So give it the following path

    <app name>/<app name>-Bridging-Header.h
    
8. Now you can add a Custom view to your interface. Change the class to CPTGraphHostingView

9. 
    
## Example projects
Core Plot is a very flexible framework for creating all sorts of charts. I'll try and create several example projects that explore different charting options.

### Real Time Example
I have a stream of data coming in. I want to display that in the app.
- How do I get the basic chart in place?
- Can a theme be used and re-used in other projects?
- How do I scroll the graph so that all the data is always in view
- How can I scroll the chart so that a fixed times worth of data is shown (e.g., a scrolling window)
- Many more questions