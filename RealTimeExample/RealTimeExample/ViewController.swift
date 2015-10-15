//
//  ViewController.swift
//  RealTimeExample
//
//  Created by Daniel Pink on 9/10/2015.
//  Copyright © 2015 Daniel Pink. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var graphView: CPTGraphHostingView!
    
    let graph = CPTXYGraph(frame: CGRectZero)
    let theme = MyTheme()
    var data = [Double]()
    var max = 0.0
    var min = 0.0
    
    var timer: NSTimer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Setting up graph
        
        graph.applyTheme(theme)
        
        graph.title = "CPU Load or Something"
        
        // Setup Scatter Plot Space
        let plotSpace = graph.defaultPlotSpace as! CPTXYPlotSpace
        plotSpace.allowsUserInteraction = true
        plotSpace.delegate = self
        
        // Grid line styles
        
        // Axes
        
        // Create a Plot that uses the data source method
        let plot = CPTScatterPlot()
        plot.identifier = "Scatter Plot"
        
        //plot.dataLineStyle = redLineStyle
        plot.delegate = self
        plot.dataSource = self
        
        graph.addPlot(plot)
        
        graph.paddingLeft = 60
        graph.paddingTop = 30
        graph.paddingRight = 30
        graph.paddingBottom = 30
        graph.plotAreaFrame!.masksToBorder = false
        
        // Auto scale the plot space to fit the plot data
        // Extend the y range by 10% for neatness
        plotSpace.scaleToFitPlots([plot])
        plotSpace.xRange = CPTPlotRange(location: 0, length: 10)
        plotSpace.yRange = CPTPlotRange(location: 0, length: 20)
        
        // This stops you from scrolling off into ranges that can't have values.
        plotSpace.globalXRange = CPTPlotRange(location: 0, length: 64000)
        plotSpace.globalYRange = CPTPlotRange(location: 0, length: 30)

        
        self.graphView.hostedGraph = graph
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "update", userInfo: nil, repeats: true)
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func update() {
        var avg = [Double](count: 1, repeatedValue: 0)
        getloadavg(&avg, 1)
        
        data += avg
        if avg[0] > max {
            max = avg[0]
        }
        if avg[0] < min {
            min = avg[0]
        }
        
        graph.reloadData()
        print(avg)
        
        
        let plotSpace = graph.defaultPlotSpace as! CPTXYPlotSpace
        // To rescale the plot to include everything in the data array use the following.
        //plotSpace.scaleToFitPlots([graph.plotAtIndex(0)!])
        
        // If you want a view that tracks the latest 20 values use the following.
        plotSpace.xRange = CPTPlotRange(location: data.count - 20, length: 20)
        plotSpace.yRange = CPTPlotRange(location: 0, length: max * 1.1)
        
    }

}

extension ViewController: CPTPlotDataSource, CPTPlotSpaceDelegate {
    //-(NSUInteger)numberOfRecordsForPlot:(nonnull CPTPlot *)plot;
    func numberOfRecordsForPlot(plot: CPTPlot) -> UInt {
        return UInt(data.count)
    }
    
    func numberForPlot(plot: CPTPlot, field fieldEnum: UInt, recordIndex idx: UInt) -> AnyObject? {
        
        switch fieldEnum {
        case 0:
            return idx
        case 1:
            return data[Int(idx)]
        default:
            return 0
        }
    }
}
