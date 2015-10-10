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
    
    var timer: NSTimer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Setting up graph
        
        graph.applyTheme(theme)
        
        graph.title = "Battery Voltage"
        
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
        
        graph.paddingLeft = 0
        graph.paddingTop = 0
        graph.paddingRight = 0
        graph.paddingBottom = 0
        
        // Auto scale the plot space to fit the plot data
        // Extend the y range by 10% for neatness
        //CPTXYPlotSpace *plotSpace = (id)graph.defaultPlotSpace;
        //[plotSpace scaleToFitPlots:[NSArray arrayWithObjects:wahooHeartRateLinePlot, nil]];
        plotSpace.scaleToFitPlots([plot])
        //plotSpace?.xRange = CPTPlotRange(location: 0, length: 10)
        //plotSpace.yRange = CPTPlotRange(location: 0, length: 200)
        
        
        // Restrict y range to a global range
        
        //CPTPlotRange *globalYRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(260.0f)];
        //plotSpace.globalYRange = globalYRange;
        let globalYRange = CPTPlotRange(location: 0.0, length: 260)
        plotSpace.globalYRange = globalYRange
        
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
        graph.reloadData()
        print(avg)
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
