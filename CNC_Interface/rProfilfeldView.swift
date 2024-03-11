//
//  rDrehknopf.swift
//  Robot_Interface
//
//  Created by Ruedi Heimlicher on 18.08.2019.
//  Copyright © 2019 Ruedi Heimlicher. All rights reserved.
//
import Cocoa
import Foundation

class rProfilfeldView: NSView
{
    // von Profilgrah
    var  DatenArray :  NSArray  = NSArray()
    var  RahmenArray :  NSArray  = NSArray()
    var  StartPunktA :  NSPoint  = NSZeroPoint
    var  EndPunktA :  NSPoint  = NSZeroPoint
    var  StartPunktB :  NSPoint  = NSZeroPoint
    var  EndPunktB :  NSPoint  = NSZeroPoint
    var  oldMauspunkt :  NSPoint  = NSZeroPoint
    var  scale  :  Double  = 0
    var  mausistdown :  Int  = 0
    var  Klickpunkt :  Int  = 0
    var  Klickseite :  Int  = 0
    var  klickrange :  NSRange  = NSRange()
    var  KlicksetA :  NSMutableIndexSet  = NSMutableIndexSet()
    var  startklickpunkt :  Int  = 0
    var  stepperposition :  Int  = 0
    var  anzahlmaschen :  Int  = 0
    var  graphstatus :  Int  = 0
    var  screen  :  Int  = 0
    var  GraphOffset :  Int  = 0

    func setDatenArray(derDatenArray:NSArray) 
    {
        DatenArray=derDatenArray
    }
    func setRahmenArray(derRahmenArray:NSArray)
    {
        RahmenArray=derRahmenArray
    }
    func setScale(derScalefaktor : CGFloat ) 
    {
        scale = derScalefaktor
    }
    func setStepperposition(pos : Int )
    {
        
    }
    func setAnzahlMaschen (anzahl : Int )
    {
        anzahlmaschen = anzahl
    }
    func getDatenArray() -> NSArray
    {
        return DatenArray
    }
    func acceptsFirstResponder() -> ObjCBool {return true}
    func canBecomeKeyView ()->ObjCBool {return true}
    
    func keyDown (derEvent : NSEvent ) {}
    
    func mausistDown() {}
    
    func setKlickpunkt (derPunkt : Int )
    {
        Klickpunkt=derPunkt
        startklickpunkt=derPunkt
    }
    func setKlickrange (derRange : NSRange ) 
    {
        klickrange = derRange
    }
    func setGraphOffset (offset : Int )
    {
        GraphOffset = offset
    }
    func setgraphstatus (status : Int ) 
    {
        graphstatus = status
    }
    func GitterZeichnenMitMaschen (anzahl : Int ) {}
    func GitterZeichnen ()
    {
        
    var Gittermass:Double  = scale*10;
          
        var breite:CGFloat = bounds.size.width;
        let w:CGFloat = bounds.size.width
        let h:CGFloat = bounds.size.height
      
        if ((NSGraphicsContext.current?.isDrawingToScreen) != nil)
        {
            print("ProfilGraph drawRect screen")
            screen = 1
            anzahlmaschen = Int(breite/Gittermass)
        }
        else
        {
            anzahlmaschen = 28
            breite = Double(anzahlmaschen) * Gittermass;
            screen = 0
        }
        var  HorizontaleLinie:NSBezierPath = NSBezierPath()
        var  i:Int = 0
        
        // waagrechte Linien
        let anzvertikal:Int = Int((h/Gittermass))
        for i in 0..<anzvertikal
        {
            var A:NSPoint = NSMakePoint(0, 1+Gittermass*Double(i))
            var B:NSPoint = NSMakePoint(w, 1+Gittermass*Double(i))
            HorizontaleLinie.move(to:A)
            HorizontaleLinie.line(to:B)
            
        }
        
    }

    // end Profilgraph
    
   var weg: NSBezierPath = NSBezierPath()
   var kreuz: NSBezierPath = NSBezierPath()
   var achsen: NSBezierPath = NSBezierPath()
   var mittelpunkt:NSPoint = NSZeroPoint
   var winkel:CGFloat = 0
   var hyp:CGFloat = 0
   var hgfarbe:NSColor = NSColor()
    
    
   required init?(coder  aDecoder : NSCoder)
   {
      super.init(coder: aDecoder)
      //Swift.print("JoystickView init")
      //   NSColor.blue.set() // choose color
      // let achsen = NSBezierPath() // container for line(s)
      let w:CGFloat = bounds.size.width
      let h:CGFloat = bounds.size.height
      let mittex:CGFloat = bounds.size.width / 2
      let mittey:CGFloat = bounds.size.height / 2
      mittelpunkt = NSMakePoint(mittex, mittey)
      hyp = bounds.size.height / 2
      //Swift.print("JoystickView init mittex: \(mittex) mittey: \(mittey) hyp: \(hyp)")
      achsen.move(to: NSMakePoint(0, mittey)) // start point
      achsen.line(to: NSMakePoint(w, mittey)) // destination
      achsen.move(to: NSMakePoint(mittex, 0)) // start point
      achsen.line(to: NSMakePoint(mittex, h)) // destination
      achsen.lineWidth = 1  // hair line
      //achsen.stroke()  // draw line(s) in color
      if let joystickident = self.identifier
      {
       //  Swift.print("JoystickView ident: \(joystickident) raw: \(joystickident.rawValue)")
         
      }
      else
      {
         Swift.print("JoystickView no ident")
      }
      
   }
   
   // https://stackoverflow.com/questions/21751105/mac-os-x-convert-between-nsview-coordinates-and-global-screen-coordinates
   override func draw(_ dirtyRect: NSRect) 
   {
      // https://stackoverflow.com/questions/36596545/how-to-draw-a-dash-line-border-for-nsview
      super.draw(dirtyRect)
      
      // dash customization parameters
      let dashHeight: CGFloat = 1
      let dashColor: NSColor = .gray
      
      // setup the context
      let currentContext = NSGraphicsContext.current!.cgContext
      currentContext.setLineWidth(dashHeight)
      //currentContext.setLineDash(phase: 0, lengths: [dashLength])
      currentContext.setStrokeColor(dashColor.cgColor)
      
      // draw the dashed path
      currentContext.addRect(bounds.insetBy(dx: dashHeight, dy: dashHeight))
      currentContext.strokePath()
      /*
       NSColor.blue.set() // choose color
       let achsen = NSBezierPath() // container for line(s)
       let w:CGFloat = bounds.size.width
       let h:CGFloat = bounds.size.height
       let mittex:CGFloat = bounds.size.width / 2
       let mittey:CGFloat = bounds.size.height / 2
       achsen.move(to: NSMakePoint(0, mittey)) // start point
       achsen.line(to: NSMakePoint(w, mittey)) // destination
       achsen.move(to: NSMakePoint(mittex, 0)) // start point
       achsen.line(to: NSMakePoint(mittex, h)) // destination
       achsen.lineWidth = 1  // hair line
       achsen.stroke()  // draw line(s) in color
       */
      NSColor.blue.set() // choose color
      achsen.stroke() 
      NSColor.red.set() // choose color
      kreuz.stroke()
      NSColor.green.set() // choose color
      
      weg.lineWidth = 2
      weg.stroke()  // draw line(s) in color
   }
   
   override func mouseDown(with theEvent: NSEvent) 
   {
      
      super.mouseDown(with: theEvent)
      //let ident  = self.identifier as! String
       let ident  = self.identifier
      
      Swift.print("rJoystickView mouseDown ident: \(ident)")
      var identstring = ""
      if let rawident:String = ident?.rawValue
      {
         identstring = rawident
      }
      else
      {
         identstring = "13"
      }
      
      let location = theEvent.locationInWindow
      //    Swift.print(location)
      //    NSPoint lokalpunkt = [self convertPoint: [anEvent locationInWindow] fromView: nil];
      let lokalpunkt = convert(theEvent.locationInWindow, from: nil)
      //    Swift.print(lokalpunkt)
      
      
      // setup the context
      // setup the context
      let dashHeight: CGFloat = 1
      let dashColor: NSColor = .green
      
      
      //    NSColor.blue.set() // choose color
      // https://stackoverflow.com/questions/47738822/simple-drawing-with-mouse-on-cocoa-swift
      //clearWeg()
      var userinformation:[String : Any]
      if kreuz.isEmpty
      {
         kreuz.move(to: lokalpunkt)
         // kreuz zeichnen
         kreuz.line(to: NSMakePoint(lokalpunkt.x, lokalpunkt.y+5))
         kreuz.line(to: lokalpunkt)
         kreuz.line(to: NSMakePoint(lokalpunkt.x+5, lokalpunkt.y))
         kreuz.line(to: lokalpunkt)
         kreuz.line(to: NSMakePoint(lokalpunkt.x, lokalpunkt.y-5))
         kreuz.line(to: lokalpunkt)
         kreuz.line(to: NSMakePoint(lokalpunkt.x-5, lokalpunkt.y))
         kreuz.line(to: lokalpunkt)
      
         // zurueck zu localpunkt
         weg.move(to: lokalpunkt)
         
         userinformation = ["message":"mousedown", "punkt": lokalpunkt, "index": weg.elementCount, "first": 1, "ident" :identstring] as [String : Any]
         //userinformation["ident"] = self.identifier
      }
      else
      {
         weg.line(to: lokalpunkt)
         
         userinformation = ["message":"mousedown", "punkt": lokalpunkt, "index": weg.elementCount, "first": 0, "ident" :identstring] as [String : Any]
         //userinformation["ident"] = self.identifier
      }
      
      let nc = NotificationCenter.default
      nc.post(name:Notification.Name(rawValue:"joystick"),
              object: nil,
              userInfo: userinformation)
      needsDisplay = true   
   }
   
   override func rightMouseDown(with theEvent: NSEvent) 
   {
      self.clearWeg()
      Swift.print("rJoystickView right mouse")
      let location = theEvent.locationInWindow
      Swift.print(location)
      needsDisplay = true
   }
   
   
   override func mouseDragged(with theEvent: NSEvent) 
   {
      Swift.print("rJoystickView mouseDragged ")
      let location = theEvent.locationInWindow
      //Swift.print(location)
      var lokalpunkt = convert(theEvent.locationInWindow, from: nil)
      var userinformation:[String : Any]
      Swift.print("rJoystickView mouseDragged weg.elementCount: \(weg.elementCount)" )
      if (lokalpunkt.x >= self.bounds.size.width)
      {
         lokalpunkt.x = self.bounds.size.width
      }
      if (lokalpunkt.x <= 0)
      {
         lokalpunkt.x = 0
      }
      
      if (lokalpunkt.y > self.bounds.size.height)
      {
         lokalpunkt.y = self.bounds.size.height
      }
      if (lokalpunkt.y <= 0)
      {
         lokalpunkt.y = 0
      }     
      
      weg.line(to: lokalpunkt)
      
      needsDisplay = true
      userinformation = ["message":"mousedown", "punkt": lokalpunkt, "index": weg.elementCount, "first": -1] as [String : Any]
      userinformation["ident"] = self.identifier
      
      let nc = NotificationCenter.default
      nc.post(name:Notification.Name(rawValue:"joystick"),
              object: nil,
              userInfo: userinformation)
      
      
   }
   
   func clearWeg()
   {
      weg.removeAllPoints()
      kreuz.removeAllPoints()
      needsDisplay = true
      
   }
   /*
    override func rotate(byDegrees angle: CGFloat) 
    {
    var transform = NSAffineTransform()
    transform.rotate(byDegrees: angle)
    weg.transform(using: transform as AffineTransform)
    }
    */
   override func keyDown(with theEvent: NSEvent)
   {
      Swift.print( "Key Pressed" )
      Swift.print(theEvent.keyCode)
   }
   
} // rJoystickView

