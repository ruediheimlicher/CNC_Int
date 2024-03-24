//
//  rHotwire.swift
//  CNC_Interface
//
//  Created by Ruedi Heimlicher on 01.07.2022.
//  Copyright © 2022 Ruedi Heimlicher. All rights reserved.
//

import Cocoa
import Foundation

var outletdaten:[String:AnyObject] = [:]

@objc class rPfeil_Feld:NSImageView
{
    var releasediconarray:[NSImage] = []
    var pressediconarray:[NSImage] = []
    /*
      richtung:
      right: 1
      up: 2
      left: 3
      down: 4
      */

    
    var pfeilrechtsreleased :NSImage = NSImage(named:NSImage.Name(rawValue: "pfeil_rechts_grau"))!
    var pfeilrechtspressed :NSImage = NSImage(named:NSImage.Name(rawValue: "pfeil_rechts"))!
    
    
    
    var feldklickcounter = 0;
    
     
    func acceptsFirstResponder() -> ObjCBool {return true}
    func canBecomeKeyView ()->ObjCBool {return true}
    required init?(coder  aDecoder : NSCoder)
    {
        //print("rPfeil_Taste required init")
        super.init(coder: aDecoder)
        
        releasediconarray.append(NSImage(named:NSImage.Name(rawValue: "pfeil_rechts_grau"))!)
        releasediconarray.append(NSImage(named:NSImage.Name(rawValue: "pfeil_up_grau"))!)
        releasediconarray.append(NSImage(named:NSImage.Name(rawValue: "pfeil_links_grau"))!)
        releasediconarray.append(NSImage(named:NSImage.Name(rawValue: "pfeil_down_grau"))!)

        pressediconarray.append(NSImage(named:NSImage.Name(rawValue: "pfeil_rechts"))!)
        pressediconarray.append(NSImage(named:NSImage.Name(rawValue: "pfeil_up"))!)
        pressediconarray.append(NSImage(named:NSImage.Name(rawValue: "pfeil_links"))!)
        pressediconarray.append(NSImage(named:NSImage.Name(rawValue: "pfeil_down"))!)

        /*
        var imageView = NSImageView(frame: CGRect(origin: .zero, size: pfeilrechtspressed.size))
        imageView.image = pfeilrechtsreleased
        imageView.alphaValue = 1.0
        pfeilrechtspressed = imageView.image!
        imageView = NSImageView(frame: CGRect(origin: .zero, size: pfeilrechtsreleased.size))
        imageView.image = pfeilrechtsreleased
        imageView.alphaValue = 0.1
        pfeilrechtsreleased = imageView.image!
         */
        self.image = releasediconarray[self.tag-1]
    }
    override func mouseDown(with theEvent: NSEvent)
    {
        super.mouseDown(with: theEvent)
        let startPoint = theEvent.locationInWindow
            print(startPoint) //for top left it prints (0, 900)
        feldklickcounter += 1
        print("swift Pfeil_Feld mouseDown  feldklickcounter: \(feldklickcounter)")
        let pfeiltag:Int = self.tag
        self.image = pressediconarray[self.tag-1]
        
        var userinformation:[String : Any]
        userinformation = ["richtung":pfeiltag,  "push": 1 ] as [String : Any]

        let nc = NotificationCenter.default
        nc.post(name:Notification.Name(rawValue:"pfeilfeld" ),
                 object: nil,
                 userInfo: userinformation)

        
    }
    
    override func mouseUp(with theEvent: NSEvent)
    {
        super.mouseUp(with: theEvent)
        let startPoint = theEvent.locationInWindow
            print(startPoint) //for top left it prints (0, 900)
        feldklickcounter += 1
        print("swift Pfeil_Feld mouseUp  feldklickcounter: \(feldklickcounter)")
        let pfeiltag:Int = self.tag
        self.image = releasediconarray[self.tag-1]
        var userinformation:[String : Any]
        userinformation = ["richtung":pfeiltag,  "push": 0 , ] as [String : Any]

        let nc = NotificationCenter.default
        nc.post(name:Notification.Name(rawValue:"pfeilfeld"),
                 object: nil,
                 userInfo: userinformation)

    }

    
} //rPfeil_Feld



@objc class rPfeil_Taste:NSButton
{
    var mousedowncounter = 0;
    
    
    
    required init?(coder  aDecoder : NSCoder)
    {
        //print("rPfeil_Taste required init")
        super.init(coder: aDecoder)
        
    }
    
    override func mouseDown(with theEvent: NSEvent)
    {
        super.mouseDown(with: theEvent)
        //mousedowncounter += 1
        print("swift Pfeil_Taste mouseDown  mousedowncounter: \(mousedowncounter)")
        let pfeiltag:Int = self.tag
        
        
        var userinformation:[String : Any]
        userinformation = ["richtung":pfeiltag,  "push": 1 , "mousedowncounter":mousedowncounter] as [String : Any]

        let nc = NotificationCenter.default
        nc.post(name:Notification.Name(rawValue:"pfeil" ),
                 object: nil,
                 userInfo: userinformation)

        self.mouseUp(with:theEvent)
        
    }
    
    @objc override func mouseUp(with theEvent: NSEvent)
    {
        super.mouseUp(with: theEvent)
        print("swift Pfeiltaste mouseup")
        let pfeiltag:Int = self.tag
        
        /*
          richtung:
          right: 1
          up: 2
          left: 3
          down: 4
          */
        var userinformation:[String : Any]
        userinformation = ["richtung":pfeiltag,  "push": 0 , "mousedowncounter":mousedowncounter] as [String : Any]

        let nc = NotificationCenter.default
        nc.post(name:Notification.Name(rawValue:"pfeil"),
                 object: nil,
                 userInfo: userinformation)

        
    }

    
    @objc func reportPfeiltaste(pfeiltag:Int)
    {
        print("reportPfeiltaste")
    }
}


@objc class rHotwireViewController: rViewController, NSTableViewDataSource, NSTableViewDelegate
{
      
   var hintergrundfarbe:NSColor = NSColor()
   //rTSP_NN* nn;
   var nn:rTSP_NN!
   // var micro:Int!
    //var AVR = rAVRview()
    
   var CNC_PList:NSMutableDictionary!
   
   //var ProfilTable: NSTableView!
   //var ProfilDaten: NSMutableArray!
   
    var motorsteps = 47
    var speed = 6
    var quelle:Int = 0
    
    let  FIRST_BIT = 0 // in 'position' von reportStopKnopf: Abschnitt ist first
    let  LAST_BIT = 1 // in 'position' von reportStopKnopf: Abschnitt ist last

   var  oldMauspunkt :  NSPoint  = NSZeroPoint
   /*
   var ProfilDatenOA: NSArray
   var ProfilDatenUA: NSArray
    var ProfilDatenOB: NSArray
   var ProfilDatenUB: NSArray
*/
   
   //var   Scale: Double!;
   var   cncposition: Int!
   //var   cncstatus: Double!

   var GraphEnd: Int!
   
   var   CNC_busy: Int!
   var   ProfilTiefe: Int!
   var   ProfilZoom: Double!
   var   mitOberseite: Int!
   var   mitUnterseite: Int!
   var   mitEinlauf: Int!
   var   mitAuslauf: Int!
   var   flipH: Int!
   var   flipV: Int!
   var   reverse: Int!
   var   einlauflaenge: Int!
   var   einlauftiefe: Int!
   var   einlaufrand: Int!
   var   auslauflaenge: Int!
   var   auslauftiefe: Int!
   var   auslaufrand: Int!

   struct RumpfDaten
   {
      var breitea = 30
      var breiteb = 16
      var einstichtiefe = 16
      var elementlaenge = 560
      var hoehea = 15
      var hoeheb = 8
      var portalabstand = 690
      var radiusa = 8
      var radiusb = 4
      var rand = 10
      var rumpfabstand = 50
      var rumpfauslauf = 15
      var rumpfblockbreite = 80
      var rumpfblockhoehe = 40
      var rumpfeinlauf = 15
      var rumpfmicro = 1
      var rumpfoffsetx = 8.5
      var rumpfoffsety = 0.0
      var rumpfportalabstand = 690
      var rumpfpwm = 92
      var rumpfspeed = 7
    var   motorsteps = 48
       var speed = 7
   }
    
    var hotwireplist:[String:AnyObject] = [:]
   var RahmenDic:[String:Double] = [:]
   
   var KoordinatenTabelle = [[String:Double]]()
    var  BlockKoordinatenTabelle = [[String:Double]]()
    var  BlockrahmenArray = [String]()
    var CNC_DatenArray = [String:Double]()
    var SchnittdatenArray = [[Int]]()
    var KoordinatenFormatter = NumberFormatter()
    
    
    
    @IBOutlet weak var  PfeilfeldLinks: rPfeil_Feld!
   
   @IBOutlet weak var intpos0Feld: NSStepper!
   //@IBOutlet weak var StepperTab: rTabview!
    
   //@IBOutlet weak var TaskTab: rTabview!
   //@IBOutlet weak var  ProfilFeld: NSTextField!
    
    @IBOutlet weak var  CNC_Tabview:  rDeviceTabViewController!
    
   @IBOutlet weak var  GFKFeldA: NSTextField!
   @IBOutlet weak var  GFKFeldB: NSTextField!

    
   @IBOutlet weak var  ProfilTiefeFeldA: NSTextField!
   @IBOutlet weak var  ProfilTiefeFeldB: NSTextField!

   @IBOutlet weak var  Einlauflaenge: NSTextField!
   @IBOutlet weak var  Einlauftiefe: NSTextField!

   @IBOutlet weak var  Auslauflaenge: NSTextField!
   @IBOutlet weak var  Auslauftiefe: NSTextField!

   @IBOutlet weak var  ProfilBOffsetYFeld: NSTextField!
   @IBOutlet weak var  ProfilBOffsetXFeld: NSTextField!
    
   @IBOutlet weak var  ProfilWrenchFeld: NSTextField! // Schränkung
   @IBOutlet weak var  ProfilWrenchEinheitRadio: NSTextField!
   @IBOutlet weak var  HorizontalSchieberFeld: NSTextField!
   @IBOutlet weak var  VertikalSchieberFeld: NSTextField!
   @IBOutlet weak var  HorizontalSchieber: NSTextField!
   @IBOutlet weak var  VertikalSchieber: NSTextField!
    
   @IBOutlet weak var  SpeedStepper: NSStepper!
   @IBOutlet weak var  SpeedFeld: NSTextField!

   @IBOutlet weak var  ProfilNameFeldA: NSTextField!
   @IBOutlet weak var  ProfilNameFeldB: NSTextField!

   @IBOutlet weak var  StopKoordinate: NSTextField!
   @IBOutlet weak var  StartKoordinate: NSTextField!
   @IBOutlet weak var  Adresse: NSTextField!
   @IBOutlet weak var  Cmd: NSTextField!
   @IBOutlet weak var  CNCKnopf: NSTextField!
   @IBOutlet weak var  OberseiteCheckbox: NSButton!
   @IBOutlet weak var  UnterseiteCheckbox: NSButton!
   @IBOutlet weak var  OberseiteTaste: NSButton!
   @IBOutlet weak var  UnterseiteTaste: NSButton!
    
    @IBOutlet weak var  AndereSeiteTaste: NSButton!
   
   @IBOutlet weak var  EinlaufCheckbox: NSButton!
   @IBOutlet weak var  AuslaufCheckbox: NSButton!
   
   @IBOutlet weak var  AbbrandCheckbox: NSButton!
   
   @IBOutlet weak var  ScalePop: NSPopUpButton!
   @IBOutlet weak var  Profil1Pop: NSPopUpButton!
   @IBOutlet weak var  Profil2Pop: NSPopUpButton!
   
   @IBOutlet  var  CNC_Table: NSTableView!
   @IBOutlet  weak var  CNC_Scroller: NSScrollView!

   // CNC
   @IBOutlet weak var CNC_Preparetaste: NSButton!
   @IBOutlet weak var CNC_Starttaste: NSButton!
   @IBOutlet weak var CNC_Stoptaste: NSButton!
   @IBOutlet weak var CNC_Sendtaste: NSButton!
   @IBOutlet weak var CNC_Terminatetaste: NSButton!
   @IBOutlet weak var CNC_Neutaste: NSButton!
   @IBOutlet weak var CNC_Halttaste: NSButton!
   @IBOutlet weak var DC_Taste: NSButton!
   @IBOutlet weak var DC_Stepper: NSStepper!
   @IBOutlet weak var DC_Slider: NSSlider!
   @IBOutlet weak var DC_PWM: NSTextField!
   @IBOutlet weak var CNC_StepsSegControl: NSSegmentedControl!
   @IBOutlet weak var CNC_microPop: NSPopUpButton!

   @IBOutlet weak var CNC_Uptaste: NSButton!
   @IBOutlet weak var CNC_Downtaste: NSButton!
   @IBOutlet weak var CNC_Lefttaste: NSButton!
   @IBOutlet weak var CNC_busySpinner: NSProgressIndicator!
    
   @IBOutlet weak var CNC_Linkstaste: NSButton!
    
   @IBOutlet weak var CNC_Righttaste: NSButton!
    
   @IBOutlet weak var CNC_Seite1Check: NSButton!
    @objc var  cnc_seite1check:Int = 0
   @IBOutlet weak var CNC_Seite2Check: NSButton!
    @objc var  cnc_seite2check:Int = 0
   @IBOutlet weak var CNC_BlockKonfigurierenTaste: NSButton!
   @IBOutlet weak var CNC_BlockAnfuegenTaste: NSButton!

    
   @IBOutlet weak var  Pfeiltaste: rPfeil_Taste!
    
   @IBOutlet weak var IndexFeld: NSTextField!
   @IBOutlet weak var IndexStepper: NSStepper!

   @IBOutlet weak var WertAXFeld: NSTextField!
   @IBOutlet weak var WertAXStepper: NSStepper!
   @IBOutlet weak var WertAYFeld: NSTextField!
   @IBOutlet weak var WertAYStepper: NSStepper!
    
   @IBOutlet weak var WertBXFeld: NSTextField!
   @IBOutlet weak var WertBXStepper: NSStepper!
   @IBOutlet weak var WertBYFeld: NSTextField!
   @IBOutlet weak var WertBYStepper: NSStepper!
    
   @IBOutlet weak var ABBindCheck: NSButton!

   @IBOutlet weak var LagePop: NSPopUpButton!
   @IBOutlet weak var WinkelFeld: NSTextField!
   @IBOutlet weak var WinkelStepper: NSStepper!

 //  @IBOutlet weak var PWMFeld: NSTextField!
 //  @IBOutlet weak var PWMStepper: NSStepper!

   @IBOutlet weak var AbbrandFeld: NSTextField!

   @IBOutlet weak var GleichesProfilRadioKnopf: NSButton!
   @IBOutlet weak var WertFeld: NSTextField!
    
   @IBOutlet weak var PositionFeld: NSTextField!
   @IBOutlet weak var AnzahlFeld: NSTextField!
   @IBOutlet weak var PositionXFeld: NSTextField!
   @IBOutlet weak var PositionYFeld: NSTextField!
    
   @IBOutlet weak var SaveChangeTaste: NSButton!
   @IBOutlet weak var ShiftAllTaste: NSButton!
    
   @IBOutlet weak var Blockoberkante: NSTextField!
   @IBOutlet weak var OberkantenStepper: NSStepper!
   @IBOutlet weak var Blockbreite: NSTextField!
   @IBOutlet weak var Blockdicke: NSTextField!
    
   @IBOutlet weak var RumpfBlockbreite: NSTextField!
   @IBOutlet weak var RumpfBlockhoehe: NSTextField!

    
   @IBOutlet weak var Einlaufrand: NSTextField!
   @IBOutlet weak var Auslaufrand: NSTextField!
   @IBOutlet weak var AnschlagLinksIndikator: NSBox!
   @IBOutlet weak var AnschlagUntenIndikator: NSBox!
    
   @IBOutlet weak var Basisabstand: NSTextField!  // Abstand CNC zu Block
   @IBOutlet weak var Portalabstand: NSTextField!
   @IBOutlet weak var Spannweite: NSTextField!  //
    
   @IBOutlet weak var startdelayFeld: NSTextField!  //
    
   //@IBOutlet weak var USBKontrolle!
    
   @IBOutlet weak var HomeTaste: NSButton!

   @IBOutlet weak var SeitenVertauschenTaste: NSButton!
   @IBOutlet weak var NeuesElementTaste: NSButton!
    
   @IBOutlet weak var AbmessungX: NSTextField!
   @IBOutlet weak var AbmessungY: NSTextField!
    
   @IBOutlet weak var red_pwmFeld: NSTextField!

   @IBOutlet weak var LinkeRechteSeite: NSSegmentedControl!
    
   @IBOutlet weak var VersionFeld: NSTextField!
   @IBOutlet weak var DatumFeld: NSTextField!
   @IBOutlet weak var SlaveVersionFeld: NSTextField!


   @IBOutlet weak var ManufactorerFeld:  NSTextField!
    @IBOutlet weak var ProductFeld:  NSTextField!
    @IBOutlet weak var MinimaldistanzFeld:  NSTextField!
    
    @IBOutlet weak var BlockbreiteFeld:  NSTextField!
    @IBOutlet weak var BlockbreiteStepper:  NSTextField!
    
    @IBOutlet weak var  ProfilFeld: rProfilfeldView!
    
    // Rumpf
    @IBOutlet weak var RandFeld:  NSTextField!
    @IBOutlet weak var EinlaufFeld:  NSTextField!
    @IBOutlet weak var BreiteAFeld:  NSTextField!
    @IBOutlet weak var HoeheAFeld:  NSTextField!
    @IBOutlet weak var RadiusAFeld:  NSTextField!
    @IBOutlet weak var AuslaufFeld:  NSTextField!
    @IBOutlet weak var BreiteBFeld:  NSTextField!
    @IBOutlet weak var HoeheBFeld:  NSTextField!
    @IBOutlet weak var RadiusBFeld:  NSTextField!
    @IBOutlet weak var EinstichtiefeFeld:  NSTextField!
    //@IBOutlet weak var RumpfblockhoeheFeld:  NSTextField!
    @IBOutlet weak var RumpfabstandFeld:  NSTextField! // Abstand CNC zu Block
    @IBOutlet weak var ElementlaengeFeld:  NSTextField! // Laenge des Rumpfabschnittes
    @IBOutlet weak var RumpfOffsetXFeld:  NSTextField!
    @IBOutlet weak var RumpfOffsetYFeld:  NSTextField!
    @IBOutlet weak var RumpfportalabstandFeld:  NSTextField!
    
    @IBOutlet weak var Schalendickefeld:  NSTextField!
    @IBOutlet weak var NutCheckbox:  NSButton!
    

    @IBOutlet weak var  RumpfteilTaste:  NSSegmentedControl!
    
    let MANRIGHT    = 1
    let MANUP       = 2
    let MANLEFT     = 3
    let MANDOWN     = 4

/*
    @objc func stepsAktion(_ notification:Notification)
       {
          print("stepsAktion: \(notification)")
          steps = notification.userInfo?["motorsteps"] as! Int
          print("stepsAktion steps: \(steps)")
          steps_Feld.integerValue = steps
       }

       @objc func microAktion(_ notification:Notification)
       {
          print("microAktion: \(notification)")
          micro = notification.userInfo?["micro"] as! Int
          print("Aktion micro: \(micro)")
   //       micro_Feld.integerValue = micro
       }
*/
    
    @objc func DC_Funktion(pwm:UInt8 )
     {
        usb_schnittdatenarray.removeAll()
        //print("DCAktion: \(notification)")
         print("DCAktion  pwm: \(pwm)")
        Stepperposition = 0;
        var wertarray = [UInt8](repeating: 0, count: Int(BufferSize()))
        
        wertarray[16] = 0xE2
        wertarray[24] = 0xE2
        wertarray[18]=0; // indexh, indexl ergibt abschnittnummer
        wertarray[20]=pwm; // pwm
        
        usb_schnittdatenarray.append(wertarray)
        writeCNCAbschnitt()
        teensy.clear_data()

     }

    
    @objc func MausGraphAktion(_ notification:Notification)
    {
        let info = notification.userInfo
        //print("Hotwire mausGraphAktion:\t \(String(describing: info))")
        self.view.window?.makeFirstResponder(self.ProfilFeld)
        CNC_Table.deselectAll(nil)
        
        //   [[[self view]window]makeFirstResponder: ProfilGraph];
        let mauspunktstring = notification.userInfo?["mauspunkt"] as! String
        let MausPunkt:NSPoint = NSPointFromString(mauspunktstring);
        print("Hotwire mausGraphAktion MausPunkt:\t \(MausPunkt)")
        
        WertAXFeld.doubleValue = MausPunkt.x
        WertAYFeld.doubleValue = MausPunkt.y
        
        WertAXStepper.doubleValue = MausPunkt.x
        WertAYStepper.doubleValue = MausPunkt.y
        
        WertBXFeld.doubleValue = MausPunkt.x
        WertBYFeld.doubleValue = MausPunkt.y
        
        WertBXStepper.doubleValue = MausPunkt.x
        WertBYStepper.doubleValue = MausPunkt.y
        
        
        
        
        let offsetx:Double = ProfilBOffsetXFeld.doubleValue
        let offsety:Double = ProfilBOffsetYFeld.doubleValue
        
        //print("mausgraphaktion offsetx: \(offsetx) offsety: \(offsety)")
        
        var oldPosDic:[String:Double] = [:]
        
        var oldax:Double = MausPunkt.x;
        var olday:Double = MausPunkt.y;
        print("mausgraphaktion oldax: \(oldax) olday: \(olday)")
        var  oldbx:Double = oldax + offsetx;
        var  oldby:Double = olday + offsety;
        print("mausgraphaktion oldbx: \(oldbx) oldby: \(oldby)")
        var  oldpwm :Double =  DC_PWM.doubleValue
        //print("KoordinatenTabelle: \(KoordinatenTabelle) count: \(KoordinatenTabelle.count)")
        
        let c = KoordinatenTabelle.isEmpty
        
        print("Mausgraphaktion start KoordinatenTabelle: \(KoordinatenTabelle) ")
        
        if (KoordinatenTabelle.isEmpty == false)
        {
            oldPosDic = KoordinatenTabelle.last!
            oldax = oldPosDic["ax"] ?? 0
            olday = oldPosDic["ay"] ?? 0
            oldbx = oldPosDic["bx"] ?? 0
            oldby = oldPosDic["by"] ?? 0
            
            print("mausgraphaktion oldax a: \(oldax) olday: \(olday)")
            print("mausgraphaktion oldbx b: \(oldbx) oldby: \(oldby)")
            
            if (oldPosDic["pwm"]! > 0)
            {
                //NSLog(@"oldpwm VOR: %d",oldpwm);
                var  temppwm = oldPosDic["pwm"]
                if (temppwm == oldpwm)
                {
                    oldpwm = temppwm!;
                }
                //NSLog(@"oldpwm: %d temppwm: %d",oldpwm,temppwm);
            }
            CNC_Stoptaste.isEnabled = true
        }
        else // Start
        {
            // oldbx += offsetx;
            //oldby += offsety;
        }
        
        DC_Stepper.doubleValue = oldpwm
        DC_PWM.doubleValue = oldpwm
        
        //NSLog(@"oldax: %1.1f olday: %1.1f",oldax,olday);
        
        var deltax = MausPunkt.x-oldax;
        var deltay = MausPunkt.y-olday;
        
        //NSLog(@"deltax: %1.1f deltay: %1.1f",deltax, deltay);
        
        var neueZeileDic = [String:Double]()
        
        neueZeileDic["ax"] = MausPunkt.x
        neueZeileDic["ay"] = MausPunkt.y
        neueZeileDic["bx"] = oldbx + deltax
        neueZeileDic["by"] = oldby + deltay
        
        neueZeileDic["index"] = Double(KoordinatenTabelle.count)
        neueZeileDic["pwm"] = oldpwm
        print("neueZeileDic: \(neueZeileDic)")
        
        if (CNC_Starttaste.state.rawValue > 0)
        {
            oldMauspunkt = MausPunkt
            
            var tempDic:[String:Double] = [:]
            tempDic["ax"] = MausPunkt.x
            tempDic["ay"] = MausPunkt.y
            tempDic["bx"] = MausPunkt.x + offsetx
            tempDic["by"] = MausPunkt.y + offsety
            tempDic["index"] = Double(KoordinatenTabelle.count)
            tempDic["pwm"] = oldpwm
            print("tempDic: \(tempDic)")
            /*
             NSDictionary* tempDic = [NSDictionary dictionaryWithObjectsAndKeys:
             [NSNumber numberWithFloat:MausPunkt.x], @"ax",
             [NSNumber numberWithFloat:MausPunkt.y], @"ay",
             [NSNumber numberWithFloat:MausPunkt.x + offsetx], @"bx",
             [NSNumber numberWithFloat:MausPunkt.y + offsety],@"by",
             [NSNumber numberWithInt:[KoordinatenTabelle count]],@"index",
             [NSNumber numberWithInt:oldpwm],@"pwm",NULL];
             */
            //NSLog(@"tempDic: %@",[tempDic description]);
            
            switch (KoordinatenTabelle.count)
            {
            case 0:
                IndexFeld.integerValue = KoordinatenTabelle.count
                IndexStepper.integerValue = KoordinatenTabelle.count
                IndexStepper.maxValue = Double(KoordinatenTabelle.count)
                //      [KoordinatenTabelle addObject:tempDic];
                KoordinatenTabelle.append(neueZeileDic)
                break;
                
            default:
                print("tempDic 2: \(tempDic)")
                KoordinatenTabelle.remove(at: 0)
                KoordinatenTabelle.insert(tempDic, at:0)
                //KoordinatenTabelle.replaceSubrange(0 ... 0, with: tempDic)
                
                IndexFeld.integerValue = 0
                IndexStepper.integerValue = 0
                break;
                
            }//switch
            
        }
        else if (CNC_Stoptaste.state.rawValue > 0)
        {
            
            var tempDic:[String:Double] = [:]
            tempDic["ax"] = MausPunkt.x
            tempDic["ay"] = MausPunkt.y
            tempDic["bx"] = MausPunkt.x + offsetx
            tempDic["by"] = MausPunkt.y + offsety
            tempDic["index"] = Double(KoordinatenTabelle.count)
            tempDic["pwm"] = oldpwm
            
            print("if CNC_Stoptaste state > 0 tempDic: \(tempDic)")
            /*
             NSDictionary* tempDic = [NSDictionary dictionaryWithObjectsAndKeys:
             [NSNumber numberWithFloat:MausPunkt.x], @"ax",
             [NSNumber numberWithFloat:MausPunkt.y], @"ay",
             [NSNumber numberWithFloat:MausPunkt.x + offsetx], @"bx",
             [NSNumber numberWithFloat:MausPunkt.y + offsety], @"by",
             [NSNumber numberWithInt:[KoordinatenTabelle count]],@"index",
             [NSNumber numberWithInt:oldpwm],@"pwm",NULL];
             */
            //NSLog(@"if CNC_Stoptaste state tempDic: %@",[tempDic description]);
            
            
            if (KoordinatenTabelle.count > 1)
            {
                //[KoordinatenTabelle replaceObjectAtIndex:[KoordinatenTabelle count]-1 withObject:tempDic];
                //if (GraphEnd)
                
                IndexFeld.integerValue = KoordinatenTabelle.count
                IndexStepper.integerValue = KoordinatenTabelle.count
                IndexStepper.maxValue = Double(KoordinatenTabelle.count)
                /*
                 [IndexFeld setIntValue:[KoordinatenTabelle count]];
                 [IndexStepper setIntValue:[IndexFeld intValue]];
                 [IndexStepper setMaxValue:[IndexFeld intValue]];
                 */
                //   [KoordinatenTabelle addObject:tempDic];
                KoordinatenTabelle.append(neueZeileDic)
                
                //[KoordinatenTabelle replaceObjectAtIndex:[KoordinatenTabelle count]-1 withObject:tempDic];
                
            }
            else
            {
                
                IndexFeld.integerValue = KoordinatenTabelle.count
                IndexStepper.integerValue = KoordinatenTabelle.count
                IndexStepper.maxValue = Double(KoordinatenTabelle.count)
                KoordinatenTabelle.append(neueZeileDic)
                
                /*
                 [IndexFeld setIntValue:[KoordinatenTabelle count]];
                 [IndexStepper setIntValue:[IndexFeld intValue]];
                 [IndexStepper setMaxValue:[IndexFeld intValue]];
                 //[KoordinatenTabelle addObject:tempDic];
                 [KoordinatenTabelle addObject:neueZeileDic];
                 */
            }
            
            
        }
        else
        {
            
            /*
             if (fabs(MausPunkt.x - oldMauspunkt.x) > [CNC steps]*0x7F) // Groesser als int16_t
             {
             NSLog(@"zu grosser Schritt X");
             
             }
             */
            
            var tempDic:[String:Double] = [:]
            tempDic["ax"] = MausPunkt.x
            tempDic["ay"] = MausPunkt.y
            tempDic["bx"] = MausPunkt.x + offsetx
            tempDic["by"] = MausPunkt.y + offsety
            tempDic["index"] = Double(KoordinatenTabelle.count)
            tempDic["pwm"] = oldpwm
            print("tempDic 3: \(tempDic)")
            /*
             NSDictionary* tempDic = [NSDictionary dictionaryWithObjectsAndKeys:
             [NSNumber numberWithFloat:MausPunkt.x], @"ax",
             [NSNumber numberWithFloat:MausPunkt.y], @"ay",
             [NSNumber numberWithFloat:MausPunkt.x + offsetx], @"bx",
             [NSNumber numberWithFloat:MausPunkt.y + offsety], @"by",
             [NSNumber numberWithInt:[KoordinatenTabelle count]],@"index",
             [NSNumber numberWithInt:oldpwm],@"pwm",
             NULL];
             */
            
            print("if CNC_Stoptaste state == 0 tempDic: \(tempDic)")
            IndexFeld.integerValue = KoordinatenTabelle.count
            IndexStepper.integerValue = KoordinatenTabelle.count
            IndexStepper.maxValue = Double(KoordinatenTabelle.count)
            KoordinatenTabelle.append(neueZeileDic)
            /*
             [IndexFeld setIntValue:[KoordinatenTabelle count]];
             [IndexStepper setIntValue:[IndexFeld intValue]];
             [IndexStepper setMaxValue:[IndexFeld intValue]];
             //[KoordinatenTabelle addObject:tempDic];
             [KoordinatenTabelle addObject:neueZeileDic];
             */
        }
        oldMauspunkt=MausPunkt;
        //NSLog(@"Mausklicktabelle: %@",[KoordinatenTabelle description]);
        
        //NSDictionary* RahmenDic = [self RahmenDic];
        let maxX:Double = RahmenDic["maxx"] ?? 100
        var minX:Double = RahmenDic["minx"] ?? 10
        
        let maxY:Double = RahmenDic["maxy"] ?? 100
        var minY:Double = RahmenDic["miny"] ?? 10
        
        
        //      float maxY=[[RahmenDic objectForKey:@"maxy"]floatValue];
        //      float minY=[[RahmenDic objectForKey:@"miny"]floatValue];
        //   NSLog(@"maxX: %2.2f minX: %2.2f * maxY: %2.2f minY: %2.2f",maxX,minX,maxY,minY);
        
        //  [AbmessungX setIntValue:maxX - minX];
        //  [AbmessungY setIntValue:maxY - minY];
        
        ProfilFeld.DatenArray = KoordinatenTabelle as NSArray
        //[ProfilGraph setDatenArray:KoordinatenTabelle];
        //ProfilFeld.needsDisplay = true
        ProfilFeld.setNeedsDisplay(ProfilFeld.frame)
        //[Profilfeld setNeedsDisplay:YES];
        
        print("Mausgraphaktion end KoordinatenTabelle: \(KoordinatenTabelle) ")

        CNC_Table.reloadData()
        
        if (KoordinatenTabelle.count > 0)
        {
            let rowindexset =  IndexSet(integer: KoordinatenTabelle.count)
            CNC_Table.selectRowIndexes(rowindexset, byExtendingSelection: false)
            //          CNCTable.scrollRowToVisible(KoordinatenTabelle.count - 1)
        }
        
        
    }
    
   @objc func MausDragAktion(_ notification:Notification)
    {
        let info = notification.userInfo
        print("Hotwire MausDragAktion")
        print("Hotwire MausDragAktion:\t \(String(describing: info))")
        let mauspunktstring = notification.userInfo?["mauspunkt"] as! String
       let MausPunkt:NSPoint = NSPointFromString(mauspunktstring);

        
        
    }

   @objc func MausKlickAktion(_ notification:Notification)
    {
        let info = notification.userInfo
        print("Hotwire MausKlickAktion:\t \(String(describing: info))")
        
     //   self.view.window?.addObserver(self, forKeyPath: "firstResponder", options: [.initial, .new], context: nil)

        self.view.window?.makeFirstResponder(self.ProfilFeld)

        var klickIndex = info?["klickpunkt"] as! Int

        if klickIndex > 0x0FFF
        {
            klickIndex -= 0xF000
        }
        var NotificationDic = [String:Any]()
        var tempZeilenDic = KoordinatenTabelle[klickIndex]
        
        IndexFeld.integerValue = klickIndex
        IndexStepper.integerValue = klickIndex
        
        WertAXFeld.doubleValue = tempZeilenDic["ax"] ?? 0
        WertAYFeld.doubleValue = tempZeilenDic["ay"] ?? 0

        WertAXStepper.doubleValue = tempZeilenDic["ax"] ?? 0
        WertAYStepper.doubleValue = tempZeilenDic["ay"] ?? 0

        WertBXFeld.doubleValue = tempZeilenDic["bx"] ?? 0
        WertBYFeld.doubleValue = tempZeilenDic["by"] ?? 0

        WertBXStepper.doubleValue = tempZeilenDic["bx"] ?? 0
        WertBYStepper.doubleValue = tempZeilenDic["by"] ?? 0
        
        self.ProfilFeld.needsDisplay = true
        var rowIndexSet = NSIndexSet.init(index: klickIndex)
        
        CNC_Table.selectRowIndexes(IndexSet.init(rowIndexSet), byExtendingSelection: false)

        
    } // MausKlickAktion

    @objc class func cncoutletdaten() -> NSDictionary
    {
        return outletdaten as NSDictionary
    }
    
   // @objc func reportPfeiltaste
    
    /*
      richtung:
      right: 1
      up: 2
      left: 3
      down: 4
      */

    /*
    @objc func updateSteps()
     {
        print("stepsAktion: \()")
        steps = notification.userInfo?["motorsteps"] as! Int
        print("stepsAktion steps: \(steps)")
        //steps_Feld.integerValue = steps
     }

     @objc func updateMicro()
     {
   //     print("stepsAktion: \(notification)")
        micro = notification.userInfo?["micro"] as! Int
        print("Aktion micro: \(micro)")
        //micro_Feld.integerValue = micro
     }
*/
   // MARK: NEU-Taste
    @IBAction func reportNeuTaste(_ sender: NSButton)
    {
        print("swift reportNeuTaste")
        CNC_Halttaste.state = NSControl.StateValue(rawValue: 0)
        CNC_Halttaste.isEnabled = false
        CNC_Sendtaste.isEnabled = false
        CNC_Starttaste.isEnabled = true
        CNC_Starttaste.state = NSControl.StateValue(rawValue: 0)
        CNC_Stoptaste.isEnabled = false
        NeuesElementTaste.isEnabled = false
        PositionFeld.stringValue = ""
        //ProfilFeld.viewWithTag(1001).stringValue = ""
        DC_Taste.isEnabled = false
        HomeTaste.state = NSControl.StateValue(rawValue: 0)
        KoordinatenTabelle.removeAll()
        CNC_Table.reloadData()
        CNC_Table.needsDisplay = true
        
        IndexFeld.stringValue = ""
        IndexStepper.integerValue = 0
        WertAXFeld.stringValue = ""
        WertAXStepper.integerValue = 0
        
        WertAYFeld.stringValue = ""
        WertAYStepper.integerValue = 0

        WertBXFeld.stringValue = ""
        WertBXStepper.integerValue = 0

        WertBYFeld.stringValue = ""
        WertBYStepper.integerValue = 0

        if (BlockrahmenArray != nil && BlockrahmenArray.count > 0)
        {
            BlockrahmenArray.removeAll()
            ProfilFeld.setRahmenArray(derRahmenArray: BlockrahmenArray as NSArray)
        }
        BlockKoordinatenTabelle.removeAll()
        CNC_DatenArray.removeAll()
        SchnittdatenArray.removeAll()
        
        ProfilFeld.stepperposition = -1
        ProfilFeld.setDatenArray(derDatenArray: KoordinatenTabelle as NSArray)
        ProfilFeld.needsDisplay = true
        
        var HomeSchnittdatenArray = [String:Any]()
        var ManArray = [String:Double]()
        var PositionA = NSMakePoint(0, 0)
        var PositionB = NSMakePoint(0, 0)
        
        ManArray["ax"] = PositionA.x
        ManArray["ay"] = PositionA.y
        ManArray["bx"] = PositionB.x
        ManArray["by"] = PositionB.y
        
        let neucode:UInt8  = 0xF1
        var tempDic = [String:Int]()
        tempDic["code"] = Int(neucode)
        tempDic["position"] = 3
        tempDic["cncposition"] = 0
        tempDic["home"] = 0
     //   var tempSteuerdatenDic = [String:Any]()
      // tempSteuerdatenDic = AVR?.tool_SteuerdatenVonDic(tempDic) as! [String : Double]
        
        var tempSchnittdatenArray:[Int] = ((AVR?.tool_CNC_SchnittdatenArrayVonSteuerdaten(tempDic))) as! [Int]
        let nc = NotificationCenter.default
        var NotificationDic = [String:Any]()
        
        NotificationDic["cncposition"] = 0
        NotificationDic["home"] = 0
        
        NotificationDic["schnittdatenarray"] = tempSchnittdatenArray
        
        print("swift reportNeuTaste NotificationDic: \(NotificationDic)")

        nc.post(name:Notification.Name(rawValue:"usbschnittdaten"),
        object: nil,
        userInfo: NotificationDic)

        print("swift reportNeuTaste")
 
        
        
        //       KoordinatenTabelle.append(AVR?.schnittdatenVonDic(tempSteuerdatenDic) as! [String : Double]  )
    }
    
    @objc  @IBAction func reportStopTaste(_ sender: NSButton)
    {
        print("swift reportStopTaste")
        if CNC_Starttaste.state == NSControl.StateValue.on
        {
            CNC_Starttaste.state = NSControl.StateValue.off
        }
        let stepsindex = CNC_StepsSegControl.selectedSegment
        motorsteps = CNC_StepsSegControl.tag(forSegment:stepsindex)
        outletdaten["motorsteps"] = CNC_StepsSegControl.tag(forSegment:stepsindex)  as AnyObject
        micro = CNC_microPop.selectedItem?.tag ?? 1
        speed = SpeedFeld.integerValue
        pwm = DC_PWM.integerValue
        
        cnc_seite1check = CNC_Seite1Check.state.rawValue as Int
        cnc_seite2check = CNC_Seite2Check.state.rawValue as Int
        outletdaten["cnc_seite1check"] = CNC_Seite1Check.state.rawValue as Int as AnyObject
        outletdaten["cnc_seite2check"] = CNC_Seite2Check.state.rawValue as Int as AnyObject
        outletdaten["speed"] = speed as AnyObject
        outletdaten["micro"] = micro as AnyObject
        outletdaten["boardindex"] = boardindex as AnyObject
        outletdaten["pwm"] = pwm as AnyObject
        var zoomfaktor = ProfilTiefeFeldA.doubleValue / 1000
        outletdaten["zoom"] = zoomfaktor as AnyObject
        // Daten leeren
        CNC_DatenArray.removeAll()
        SchnittdatenArray.removeAll()
        HomeTaste.state = NSControl.StateValue.off
        DC_Taste.state = NSControl.StateValue.off
        
        
        
        
        if KoordinatenTabelle.count <= 1
        {
            let warnung = NSAlert.init()
            warnung.messageText = "Zuwenig Elemente in KoordinatenTabelle"
            warnung.addButton(withTitle: "OK")
            let antwort = warnung.runModal()
            CNC_Stoptaste.state = NSControl.StateValue.off
        }
        ProfilFeld.setgraphstatus(status: 1)
        
        let tempSchnittdatenArray = AVR?.stopFunktion(KoordinatenTabelle, outletdaten: outletdaten)
        
        print("tempSchnittdatenArray: \(tempSchnittdatenArray)")
        
        for i in 0..<tempSchnittdatenArray!.count
        {
            let temparray = tempSchnittdatenArray![i] as! [Int]
            print("i: \(i) temparray: \(temparray)")
          SchnittdatenArray.append(temparray)
        }
     print("reportStopTaste SchnittdatenArray: \(SchnittdatenArray)")
        // code am Anfang und Schluss einfuegen
        var lastposition:Int = 0
        lastposition |= (1<<LAST_BIT)
        let anzdaten = SchnittdatenArray.count
        SchnittdatenArray[anzdaten-1][17] = lastposition
        
        AnzahlFeld.integerValue = SchnittdatenArray.count
        PositionFeld.integerValue = 0
        
        IndexFeld.integerValue = anzdaten
        IndexStepper.integerValue = anzdaten
        
        CNC_Sendtaste.isEnabled = true
        DC_Taste.state = NSControl.StateValue.off
    }

    @IBAction func reportUSB_sendArray(_ sender:NSButton)
    {
        print("reportUSB_sendArray")
        if SchnittdatenArray.count == 0
        {
            let warnung = NSAlert.init()
            warnung.messageText = "reportUSB_sendArray SchnittdatenArray ist leer"
            warnung.addButton(withTitle: "OK")
            let antwort = warnung.runModal()
            //CNC_Stoptaste.state = NSControl.StateValue.off
            return
        }// leer
        
        if SpeedFeld.integerValue == 0
        {
            let warnung = NSAlert.init()
            warnung.messageText = "reportUSB_sendArray speed ist 0"
            warnung.addButton(withTitle: "OK")
            let antwort = warnung.runModal()
            //CNC_Stoptaste.state = NSControl.StateValue.off
            return
        }
        usbstatus = 1
        var delayok = 0
        if usbstatus > 0
        {
            if (SchnittdatenArray[0][1] <= 0x7F) || (SchnittdatenArray[0][9] <= 0x7F)
            {
                AnschlagLinksIndikator.fillColor = NSColor.green
            }
            
            if (SchnittdatenArray[0][3] <= 0x7F) || (SchnittdatenArray[0][11] <= 0x7F)
            {
                AnschlagUntenIndikator.fillColor = NSColor.green
            }

            var a:NSApplication.ModalResponse
            var delayok = 0
            if DC_Taste.state == NSControl.StateValue.off
            {
                
                let warnung = NSAlert.init()
                warnung.messageText = "reportUSB_sendArray speed ist 0"
                warnung.addButton(withTitle: "Einschalten")
                warnung.addButton(withTitle: "Ignorieren")
                warnung.addButton(withTitle: "Abbrechen")
                let s1 = "Der Heizdraht ist noch nicht eingeschaltet."
                let s2 = "Nach dem Einschalten den Vorgang erneut starten."
                let informationString = ("\(s1)\n\(s2)")
                warnung.informativeText = informationString
                let antwort = warnung.runModal()
                //CNC_Stoptaste.state = NSControl.StateValue.off
                switch (antwort)
                {
                case .alertFirstButtonReturn: // first button
                        DC_Taste.state = NSControl.StateValue.on
                    let dc_pwm = UInt8(DC_Taste.intValue)
                    self.DC_Funktion(pwm: dc_pwm)
                    delayok = 1
                case .alertSecondButtonReturn:
                    print("second")
                    // pwm entfernen
                    for i in 0..<SchnittdatenArray.count
                    {
                        SchnittdatenArray[i][20] = 0
                    }
                case .alertThirdButtonReturn:
                    print("third")
                    return
                default:
                    break
                }

            }
          }// if usbstatus
        else
        {
            let warnung = NSAlert.init()
            warnung.messageText = "CNC Schnit starten"
            warnung.addButton(withTitle: "Einstecken und einschalten")
            warnung.addButton(withTitle: "Zurück")
            //warnung.addButton(withTitle: "Abbrechen")
            let s1 = "Der Heizdraht ist noch nicht eingeschaltet."
            let s2 = "Nach dem Einschalten den Vorgang erneut starten."
            let informationString = ("\(s1)\n\(s2)")
            warnung.informativeText = informationString
            let antwort = warnung.runModal()

        }
        
        print("reportUSB_sendArray cncposition: \(cncposition) \nschnittdatenarray 0: \(SchnittdatenArray[0])")
        CNC_Halttaste.isEnabled = true
        CNC_Stoptaste.state = NSControl.StateValue.off
        PositionFeld.integerValue = 0
        ProfilFeld.stepperposition = 0
        ProfilFeld.needsDisplay = true
        
        let nc = NotificationCenter.default
        var SchnittdatenDic = [String:Any]()
        
        SchnittdatenDic["pwm"] = pwm
        SchnittdatenDic["schnittdatenarray"] = SchnittdatenArray
        
        
        SchnittdatenDic["cncposition"] = 0
        if HomeTaste.state == NSControl.StateValue.off
        {
            SchnittdatenDic["home"] = 1
        }
        else
        {
            SchnittdatenDic["home"] = 0
        }
        SchnittdatenDic["art"] = 0
        SchnittdatenDic["delayok"] = delayok
        
        if delayok > 0
        {
            print("swift reportUSB_sendArray mit delay")
            let sel = #selector(sendDelayedArrayWithDic(schnittdatendic:))
            self.perform(#selector(sendDelayedArrayWithDic(schnittdatendic: )), with: SchnittdatenDic, afterDelay: 6)
        }
        else
        {
            print("swift reportUSB_sendArray ohne delay")
            nc.post(name:Notification.Name(rawValue:"usbschnittdaten"),
            object: nil,
            userInfo: SchnittdatenDic)

        }
        
        print("swift reportUSB_sendArray NotificationDic: \(SchnittdatenDic)")
/*
        nc.post(name:Notification.Name(rawValue:"usbschnittdaten"),
        object: nil,
        userInfo: NotificationDic)
*/
        
        
        
    }//reportUSB_sendArray
    
    @objc func sendDelayedArrayWithDic(schnittdatendic:[String:Any])
    {
        print("sendDelayedAction")
        let nc = NotificationCenter.default
        nc.post(name:Notification.Name(rawValue:"usbschnittdaten"),
        object: nil,
        userInfo: schnittdatendic)

    }
    
    @IBAction func reportAndereSeiteAnfahren(_ sender: NSButton)
    {
        print("swift reportAndereSeiteAnfahren")
          
        
    }
    
   @IBAction func reportManRight(_ sender: rPfeil_Taste)
   {
      //print("swift reportManRight: \(sender.tag)")
       
       AnschlagLinksIndikator.layer?.backgroundColor = NSColor.green.cgColor
       
       cnc_seite1check = CNC_Seite1Check.state.rawValue as Int
       cnc_seite2check = CNC_Seite2Check.state.rawValue as Int
       outletdaten["cnc_seite1check"] = CNC_Seite1Check.state.rawValue as Int as AnyObject
       outletdaten["cnc_seite2check"] = CNC_Seite2Check.state.rawValue as Int as AnyObject
       outletdaten["speed"] = SpeedFeld.integerValue as AnyObject
       outletdaten["micro"] = micro as AnyObject
       outletdaten["boardindex"] = boardindex as AnyObject
       print("outletdaten: \(outletdaten)")
       var pfeildaten:[String:Int] = [:]
       pfeildaten["cnc_seite1check"] = (CNC_Seite1Check.state.rawValue)
       pfeildaten["cnc_seite2check"] = (CNC_Seite2Check.state.rawValue)
       pfeildaten["speed"] = SpeedFeld.integerValue
       pfeildaten["micro"] = micro
       pfeildaten["motorsteps"] = motorsteps
       pfeildaten["boardindex"] = boardindex
       print("pfeildaten: \(pfeildaten)")
       
       
       
       AVR?.manRichtung(1, mousestatus:1, pfeilstep:100)
   }
    
    @IBAction func reportManUp(_ sender: rPfeil_Taste)
    {
       print("swift reportManUp: \(sender.tag)")
        cnc_seite1check = CNC_Seite1Check.state.rawValue as Int
        cnc_seite2check = CNC_Seite2Check.state.rawValue as Int
        outletdaten["cnc_seite1check"] = CNC_Seite1Check.state.rawValue as Int as AnyObject
        outletdaten["cnc_seite2check"] = CNC_Seite2Check.state.rawValue as Int as AnyObject
        outletdaten["speed"] = SpeedFeld.integerValue as AnyObject
        outletdaten["micro"] = micro as AnyObject


        AVR?.manRichtung(2, mousestatus:1, pfeilstep:100)
    }

    @IBAction func reportManLeft(_ sender: rPfeil_Taste)
    {
       print("swift reportManLeft: \(sender.tag)")
        cnc_seite1check = CNC_Seite1Check.state.rawValue as Int
        cnc_seite2check = CNC_Seite2Check.state.rawValue as Int
        outletdaten["cnc_seite1check"] = CNC_Seite1Check.state.rawValue as Int as AnyObject
        outletdaten["cnc_seite2check"] = CNC_Seite2Check.state.rawValue as Int as AnyObject
        outletdaten["speed"] = SpeedFeld.integerValue as AnyObject
        outletdaten["micro"] = micro as AnyObject


        AVR?.manRichtung(3, mousestatus:1, pfeilstep:100)
    }

    @IBAction func reportManDown(_ sender: rPfeil_Taste)
    {
       print("swift reportManDown: \(sender.tag)")
        cnc_seite1check = CNC_Seite1Check.state.rawValue as Int
        cnc_seite2check = CNC_Seite2Check.state.rawValue as Int
        outletdaten["cnc_seite1check"] = CNC_Seite1Check.state.rawValue as Int as AnyObject
        outletdaten["cnc_seite2check"] = CNC_Seite2Check.state.rawValue as Int as AnyObject
        outletdaten["speed"] = SpeedFeld.integerValue as AnyObject
        outletdaten["micro"] = micro as AnyObject


        AVR?.manRichtung(4, mousestatus:1, pfeilstep:100)
    }
    
    @IBAction func report_Shift(_ sender: NSButton)
    {
        print("swift report_Shift: \(sender.tag)")
        let knopftag = sender.tag
        var dx:Double = 0
        var dy:Double = 0
        let shiftschritt = 4
        
        switch knopftag
        {
        case 1:// rechts
            print("right")
            dx = Double(shiftschritt)
            dy = 0
        case 2: // up
            print("up")
            dx = 0
            dy = Double(shiftschritt)
        case 3: // left
            print("left")
            dx = Double(shiftschritt) * -1
            dy = 0
        case 4: // down
            print("down")
            dx = 0
            dy = Double(shiftschritt) * -1

            
            
        default:
            return
        }// switch tag

        
        var rahmenarray = [String:Double]()
        
        if KoordinatenTabelle.count > 0
        {
            for i in 0..<KoordinatenTabelle.count
            {
                var tempzeilendic = KoordinatenTabelle[i]
                KoordinatenTabelle[i]["ax"]! += dx
                KoordinatenTabelle[i]["ay"]! += dy
                KoordinatenTabelle[i]["bx"]! += dx
                KoordinatenTabelle[i]["by"]! += dy

                if  tempzeilendic["abrax"] == nil // kein abbran
                {
                    //print("kein abbrand")
                    continue
                }
                else
                {
                    KoordinatenTabelle[i]["abrax"]! += dx
                    KoordinatenTabelle[i]["abray"]! += dy
                    KoordinatenTabelle[i]["abrbx"]! += dx
                    KoordinatenTabelle[i]["abrby"]! += dy

                }
                
            }// for i
        }// if KoordinatenTabelle.count > 0
        
        ProfilFeld.setDatenArray(derDatenArray: KoordinatenTabelle as NSArray)
          
        if BlockKoordinatenTabelle.count > 0
        {
            for i in 0..<BlockKoordinatenTabelle.count
            {
                let tempzeilendic = BlockKoordinatenTabelle[i]
                BlockKoordinatenTabelle[i]["ax"]! += dx
                BlockKoordinatenTabelle[i]["ay"]! += dy
                BlockKoordinatenTabelle[i]["bx"]! += dx
                BlockKoordinatenTabelle[i]["by"]! += dy
            }
            
            
        }// if BlockKoordinatenTabelle.count > 0
        
 
        if BlockrahmenArray.count > 0
        {
            for i in 0..<BlockrahmenArray.count
            {
                var  temppunkt = NSPointFromString(BlockrahmenArray[i])
                temppunkt.x += dx
                temppunkt.y += dy
                BlockrahmenArray[i] = NSStringFromPoint(temppunkt)
            }
            
            ProfilFeld.setRahmenArray(derRahmenArray: BlockrahmenArray as NSArray)
        }// if BlockrahmenArray.count > 0
        

        
        CNC_Table.reloadData()
        ProfilFeld.needsDisplay = true
        
    }
    
   
    

    @IBAction func report_Home(_ sender: NSButton)
    {
        print("swift report_Home: \(sender.tag)")
        let nc = NotificationCenter.default
        var NotificationDic = [String:Int]()

        var AnfahrtArray = [[String:Double]]()
       
        // Startpunkt ist aktuelle Position. Lage: 3
        var PositionA:NSPoint = NSMakePoint(CGFloat(0), CGFloat(0))
        var PositionB:NSPoint = NSMakePoint(CGFloat(0), CGFloat(0))
        var index:Int = 0
        let zeilendicA:[String:Double] = ["ax": PositionA.x, "ay":PositionA.y, "bx": PositionB.x, "by":PositionB.y, "index":Double(index), "lage":3]
        AnfahrtArray.append(zeilendicA)
        
        PositionA.x -= 500
        PositionB.x -= 500
        index += 1
        let zeilendicB:[String:Double] = ["ax": PositionA.x, "ay":PositionA.y, "bx": PositionB.x, "by":PositionB.y, "index":Double(index), "lage":3]
        AnfahrtArray.append(zeilendicB)
        
        let zoomfaktor = 1
        
        var HomeSchnittdatenArray = [[String:Double]]()
        
        AVR?.homeSenkrechtSchicken()
        
    }
    
    /*******************************************************************/
    // CNC
    /*******************************************************************/
    @IBAction func report_Motorsteps(_ sender: NSSegmentedControl)
    {
        print("report_Motorsteps")
       let stepsindex = sender.selectedSegment
        motorsteps = sender.tag(forSegment: stepsindex)
        var NotificationDic = [String:Int]()
        let view = self.view.superview
        
       
        NotificationDic["motorsteps"] = motorsteps
        
        
        let nc = NotificationCenter.default
        /*
        nc.post(name:Notification.Name(rawValue:"motorsteps"),
        object: nil,
        userInfo: NotificationDic)
         */
        nc.post(name:Notification.Name(rawValue:"steps"),
        object: nil,
        userInfo: NotificationDic)

    }

    @IBAction func report_Microsteps(_ sender: NSPopUpButton)
    {
        print("report_Microsteps")
       let stepsindex = sender.indexOfSelectedItem
        micro = sender.selectedTag()
        var NotificationDic = [String:Int]()
        
       
        NotificationDic["micro"] = micro
        
        
        let nc = NotificationCenter.default
        nc.post(name:Notification.Name(rawValue:"micro"),
        object: nil,
        userInfo: NotificationDic)

    }

    

   @objc func HWManRichtung(richtung: Int,mousestatus: Int,pfeilstep: Int)
   {
      print("ManRichtung richtung:m\(richtung) mousestatus: \(mousestatus) pfeilstep: \(pfeilstep)")
   }

   
   override func viewDidAppear()
   {
      print ("Hotwire viewDidAppear new")
      // AndereSeiteTaste.target = self
      // AndereSeiteTaste.action = #selector(AVR?.reportAndereSeiteAnfahren(_ :))

     }
    
    
   override func viewDidLoad()
   {
      super.viewDidLoad()
      // Do view setup here.
      self.view.window?.acceptsMouseMovedEvents = true
      //let view = view[0] as! NSView
      self.view.wantsLayer = true
      
      hintergrundfarbe  = NSColor.init(red: 0.25,
                                       green: 0.85,
                                       blue: 0.85,
                                       alpha: 0.25)
      
      self.view.layer?.backgroundColor = hintergrundfarbe.cgColor
      
       AnschlagLinksIndikator.wantsLayer = true
       AnschlagLinksIndikator?.layer?.backgroundColor = NSColor.green.cgColor
 
       AnschlagUntenIndikator.wantsLayer = true
       AnschlagUntenIndikator?.layer?.backgroundColor = NSColor.green.cgColor

       // CNC_Table
       CNC_Table.dataSource = self
       CNC_Table.delegate = self
       CNC_Table.rowHeight = 13
       CNC_Table.gridStyleMask = .solidVerticalGridLineMask
       CNC_Table.usesAlternatingRowBackgroundColors = true
       
       CNC_busy = 0
       // https://www.swiftbysundell.com/articles/formatting-numbers-in-swift/
       
       //          let cx = formater.string(from: NSNumber(value: Double(zeilendaten[1])))// /INTEGERFAKTOR))
        // von CNC_Mill
       //         let cx = formater.string(from: NSNumber(value: Double(zeilendaten[1])))// /INTEGERFAKTOR))

       /*
        var zeilendic = [String:String]()
          zeilendic["ind"] = String(Int(zeilendaten[0]))
          zeilendic["X"] = cx
          zeilendic["Y"] = cy
          zeilendic["Z"] = cz
          //cx: Optional("3.985") cy: Optional("26.298")
          //      print("zeilendic: \(zeilendic)")
          CNC_DatendicArray.append(zeilendic)

        
        */
       
       KoordinatenFormatter.numberStyle = .decimal
       KoordinatenFormatter.maximumFractionDigits = 2
       KoordinatenFormatter.groupingSeparator = "."
       KoordinatenFormatter.minimumFractionDigits = 2
       
       let objCInstance = AVR

       AndereSeiteTaste.target = objCInstance
       AndereSeiteTaste.action = #selector(AVR?.reportAndereSeiteAnfahren(_ :))
       
       
       NotificationCenter.default.addObserver(self, selector:#selector(usbstatusAktion(_:)),name:NSNotification.Name(rawValue: "usb_status"),object:nil)

       NotificationCenter.default.addObserver(self, selector:#selector(PfeilAktion(_:)),name:NSNotification.Name(rawValue: "pfeil"),object:nil)

       NotificationCenter.default.addObserver(self, selector:#selector(PfeilFeldAktion(_:)),name:NSNotification.Name(rawValue: "pfeilfeld"),object:nil)

       NotificationCenter.default.addObserver(self, selector:#selector(MausKlickAktion(_:)),name:NSNotification.Name(rawValue: "mausklick"),object:nil)
       NotificationCenter.default.addObserver(self, selector:#selector(MausGraphAktion(_:)),name:NSNotification.Name(rawValue: "mauspunkt"),object:nil)

       NotificationCenter.default.addObserver(self, selector:#selector(PfeilFeldAktion(_:)),name:NSNotification.Name(rawValue: "pfeilfeld"),object:nil)

      Auslauftiefe.integerValue = 10
      
       hotwireplist =  readHotwire_PList()
      
       outletdaten["cnc_seite1check"] = CNC_Seite1Check.state.rawValue as Int as AnyObject
       outletdaten["cnc_seite2check"] = CNC_Seite2Check.state.rawValue as Int as AnyObject
       
       var stepsindex = CNC_StepsSegControl.selectedSegment
       motorsteps = CNC_StepsSegControl.tag(forSegment:stepsindex)
       outletdaten["motorsteps"] = CNC_StepsSegControl.tag(forSegment:stepsindex)  as AnyObject

       micro = CNC_microPop.selectedItem?.tag ?? 1
       
      if (hotwireplist["koordinatentabelle"] != nil)
      {
         print("PList koordinatentabelle: \(hotwireplist["koordinatentabelle"] )")
      }
       
      if (hotwireplist["pwm"] != nil)
      {
         let plistpwm = hotwireplist["pwm"] as! Int
         print("plistpwm: \(plistpwm)")
         DC_PWM.integerValue = hotwireplist["pwm"] as! Int
         DC_Slider.integerValue = hotwireplist["pwm"] as! Int
         DC_Stepper.integerValue = hotwireplist["pwm"] as! Int
         pwm = plistpwm
      }
      else
      {
         DC_PWM.integerValue = 10
         DC_Slider.integerValue = 10
         DC_Stepper.integerValue = 10
         pwm  = 10

      }
      if (hotwireplist["speed"] != nil)
      {
         let plistspeed = hotwireplist["speed"]  as! Int
         print("speed: \(plistspeed )")
         SpeedFeld.integerValue = plistspeed
         SpeedStepper.integerValue = plistspeed
      }
      else
      {
         SpeedFeld.integerValue = 7
         SpeedStepper.integerValue = 7
      }
 
      if (hotwireplist["abbranda"] != nil)
      {
         let plistabbranda = hotwireplist["abbranda"]  as! Double
         print("speed: \(plistabbranda )")
         AbbrandFeld.doubleValue = plistabbranda
      }
      else
      {
         AbbrandFeld.doubleValue = 1.7
      }

      if (hotwireplist["profilnamea"] != nil)
      {
         let plistprofilnamea = hotwireplist["profilnamea"]  as! String
         print("plistprofilnamea: \(plistprofilnamea )")
         ProfilNameFeldA.stringValue = plistprofilnamea
      }
      else
      {
        
         ProfilNameFeldA.stringValue = "Clark_Y"
      }

      if (hotwireplist["profilnameb"] != nil)
      {
         let plistprofilnameb = hotwireplist["profilnameb"]  as! String
         print("plistprofilnamea: \(plistprofilnameb )")
         ProfilNameFeldB.stringValue = plistprofilnameb
      }
      else
      {
         ProfilNameFeldB.stringValue = "Clark_Y"
      }

      if (hotwireplist["profiltiefea"] != nil)
      {
         let plistwert = hotwireplist["profiltiefea"]  as! Int
         ProfilTiefeFeldA.integerValue = plistwert
      }
      else
      {
         ProfilTiefeFeldA.integerValue = 101
      }

      if (hotwireplist["profiltiefeb"] != nil)
      {
         let plistwert = hotwireplist["profiltiefeb"]  as! Int
         ProfilTiefeFeldB.integerValue = plistwert
      }
      else
      {
         ProfilTiefeFeldB.integerValue = 141
      }

      if (hotwireplist["profilboffsetx"] != nil)
      {
         let plistwert = hotwireplist["profilboffsetx"]  as! Int
         ProfilBOffsetXFeld.integerValue = plistwert
      }
      else
      {
         ProfilBOffsetXFeld.integerValue = 1
      }

      if (hotwireplist["profilboffsety"] != nil)
      {
         let plistwert = hotwireplist["profilboffsety"]  as! Int
         ProfilBOffsetYFeld.integerValue = plistwert
      }
      else
      {
         ProfilBOffsetYFeld.integerValue = 1
      }

      // Wrench Profil B
      if (hotwireplist["profilwrench"] != nil)
      {
         let plistwert = hotwireplist["profilwrench"]  as! Int
         ProfilWrenchFeld.integerValue = plistwert
      }
      else
      {
         ProfilWrenchFeld.integerValue = 1
      }
      
      if (hotwireplist["einlauflaenge"] != nil)
      {
         let plistwert = hotwireplist["einlauflaenge"]  as! Int
         Einlauflaenge.integerValue = plistwert
      }
      else
      {
         Einlauflaenge.integerValue = 1
      }

      if (hotwireplist["einlauftiefe"] != nil)
      {
         let plistwert = hotwireplist["einlauftiefe"]  as! Int
         Einlauftiefe.integerValue = plistwert
      }
      else
      {
         Einlauftiefe.integerValue = 1
      }

      if (hotwireplist["auslauflaenge"] != nil)
      {
         let plistwert = hotwireplist["auslauflaenge"]  as! Int
         Auslauflaenge.integerValue = plistwert
      }
      else
      {
         Auslauflaenge.integerValue = 1
      }

      if (hotwireplist["auslauftiefe"] != nil)
      {
         let plistwert = hotwireplist["auslauflaenge"]  as! Int
         Auslauftiefe.integerValue = plistwert
      }
      else
      {
         Auslauftiefe.integerValue = 1
      }

      if (hotwireplist["basisabstand"] != nil)
      {
         let plistwert = hotwireplist["basisabstand"]  as! Int
         Basisabstand.integerValue = plistwert
      }
      else
      {
         Basisabstand.integerValue = 1
      }

      if (hotwireplist["portalabstand"] != nil)
      {
         let plistwert = hotwireplist["portalabstand"]  as! Int
         Portalabstand.integerValue = plistwert
      }
      else
      {
         PositionFeld.integerValue = 1
      }
     
      if (hotwireplist["spannweite"] != nil)
      {
         let plistwert = hotwireplist["spannweite"]  as! Int
         Spannweite.integerValue = plistwert
      }
      else
      {
         Spannweite.integerValue = 1
      }

      if (hotwireplist["auslauf"] != nil)
      {
         let plistwert = hotwireplist["auslauf"]  as! Int
         AuslaufFeld.integerValue = plistwert
      }
      else
      {
         AuslaufFeld.integerValue = 1
      }

       outletdaten["speed"] = SpeedFeld.integerValue as AnyObject
       //outletdaten["steps"] = steps_Feld.integerValue as AnyObject
       var NotificationDic = [String:Int]()
       
       NotificationDic["micro"] = micro
       NotificationDic["motorsteps"] = motorsteps
       
       
       let nc = NotificationCenter.default
       nc.post(name:Notification.Name(rawValue:"micro"),
       object: nil,
       userInfo: NotificationDic)

       nc.post(name:Notification.Name(rawValue:"motorsteps"),
       object: nil,
       userInfo: NotificationDic)
       
       
       var settingsNotificationDic = [String:AnyObject]()
       
       settingsNotificationDic["schnittsettings"] = hotwireplist as AnyObject
       
       nc.post(name:Notification.Name(rawValue:"settings"),
       object: nil,
        userInfo: settingsNotificationDic)


       
       
      
   }//viewDidLoad
    
   
    // TODO: *** *** *** *** *** *** reportHome
   // @objc IBAction reportHome:(id)sender
    
    @IBAction func reportHome(_ sender: NSButton)
    {
        
        
        print("reportHome")
        //AVR!.reportHome(nil)
        AVR!.goHome()
   

    }
    
    @IBAction func reportDC_Stepper(_ sender: NSStepper)
    {
        print("reportDC_Stepper wert: \(sender.integerValue)")
        DC_PWM.integerValue = sender.integerValue
        DC_Slider.integerValue = sender.integerValue
        if CNC_busy > 0
        {
            if DC_Taste.state == NSControl.StateValue.on
            {
                let dataDic = ["pwm":sender.integerValue]
                self.DCAktion(datadic:dataDic)
            }
            else
            {
                let dataDic = ["pwm":0]
                self.DCAktion(datadic:dataDic)

            }
        }
   }
    
    
    @IBAction func reportDC_Taste(_ sender: NSButton)
    {
        
       print("reportDC_Taste state");
      
        if sender.state ==  NSControl.StateValue.on
       {
            let dataDic = ["pwm":DC_PWM.integerValue]
            self.DCAktion(datadic:dataDic)

       }
       else
       {
           let dataDic = ["pwm":0]
           self.DCAktion(datadic:dataDic)
       }

    }

                    @objc func DCAktion(datadic:[String:Any])
                    {
                        usb_schnittdatenarray.removeAll()
                        //print("DCAktion: \(notification)")
                        //let info = notification.userInfo
                        guard let pwm = datadic["pwm"] else
                        {
                            print("DCAktion: kein pwm")
                            return
                        }
                        print("DCAktion  pwm: \(pwm)")
                        Stepperposition = 0;
                        var wertarray = [UInt8](repeating: 0, count: Int(BufferSize()))
                        
                        wertarray[16] = 0xE2
                        wertarray[24] = 0xE2
                        wertarray[18]=0; // indexh, indexl ergibt abschnittnummer
                        wertarray[20]=pwm as! UInt8; // pwm
                        
                        usb_schnittdatenarray.append(wertarray)
                        writeCNCAbschnitt()
                        teensy.clear_data()
                        
                    }
                    @objc func readHotwire_PList() -> [String:AnyObject]
                    {
                        var dateiname = ""
                        var dateisuffix = ""
                        var urlstring:String = ""
                        var hotwireplist:[String] = []
                        var USBPfad = NSHomeDirectory() + "/Documents" + "/CNCDaten"
                        var PListName:String = "/CNC.plist"
                        USBPfad += PListName
                        print("readHotwire_PList: \(USBPfad)")
                        var USB_URL = NSURL.fileURL(withPath:USBPfad)
                        
                        var propertyListFormat =  PropertyListSerialization.PropertyListFormat.xml //Format of the Property List.
                        var plistData: [String: AnyObject] = [:] //Our data

      if FileManager.default.fileExists(atPath: USBPfad)
      {
         print("PList da")
      }
      // https://stackoverflow.com/questions/24045570/how-do-i-get-a-plist-as-a-dictionary-in-swift
      if let plistXML = FileManager.default.contents(atPath: USBPfad)
      {
         do
         {//convert the data to a dictionary and handle errors.
              plistData = try PropertyListSerialization.propertyList(from: plistXML, options: .mutableContainersAndLeaves, format: &propertyListFormat) as! [String:AnyObject]

          } catch {
              print("Error reading plist: \(error), format: \(propertyListFormat)")
          }
         
         //print("xml: \(plistXML) anz: \(plistXML.count)")
         for zeile in plistData
         {
     //       print("zeile: \(zeile)")
         }
     //    print("0: \(plistData["0"])")
       }
      
      
      // von CNC_Mill
      
    
      
      
      /*
      do
      {
         guard let fileURL = openFile() else { return  }
         
         urlstring = fileURL.absoluteString
         dateiname = urlstring.components(separatedBy: "/").last ?? "-"
         print("report_readSVG fileURL: \(fileURL)")
         
         dateiname = dateiname.components(separatedBy: ".").first ?? "-"
         
         //USBPfad.stringValue = dateiname

      }
      catch
      {
         print("readCNC_PList  error: \(error)")
         
         /* error handling here */
         return
      }
*/
      return plistData
   }
   
   @objc func MauspunktAktion(_ notification:Notification)
   {
       let info = notification.userInfo
      print("MauspunktAktion : info: \(notification.userInfo) \(info)")

   }
    
   @objc func usbstatusAktion(_ notification:Notification)
   {
       //        userinformation = ["message":"usbstart", "usbstatus": usbstatus, "boardindex":boardindex] as [String : Any]
       
       let info = notification.userInfo
       print(" usbstatusAktion: info: \(notification.userInfo) \(info)")
      guard let status = info?["usbstatus"] as? Int else
      {
         print(" usbstatusAktion: kein status\n")
         return
         
      }//
       guard let rawboardindex = info?["boardindex"] as? Int else
       {
          print("Basis rawboardindex: kein rawboardindex\n")
          return
          
       }//

      print("Hotwire usbstatusAktion:\t \(status)")
      usbstatus = Int(status)
      boardindex = rawboardindex
      
       
   }
  
    @objc func PfeilFeldAktion(_ notification:Notification)
    {
        let info = notification.userInfo
        print(" PfeilFeldAktion: info: \(notification.userInfo) \(info)")
        if (info?["richtung"] != nil)
        {
            quelle = info?["richtung"] as! Int
            
            if info?["push"] != nil
            {
                mausistdown = info?["push"] as!Int
            } // if push
        }// if richtung
        else
        {
            NSSound.beep()
            quelle = 0
            mausistdown = 0
            return
        }
        if mausistdown > 0
        {
            switch quelle
            {
            case MANDOWN:
                print("PfeilFeldAktion MANDOWN")
            case MANUP:
                print("PfeilFeldAktion MANUP")
                AnschlagUntenIndikator.layer?.backgroundColor = NSColor.green.cgColor
            case MANLEFT:
                print("PfeilFeldAktion MANLEFT")
            case MANRIGHT:
                print("PfeilFeldAktion MANRIGHT")
                AnschlagLinksIndikator.layer?.backgroundColor = NSColor.green.cgColor
                
                
            default:
                break
            }// switch quelle
            //AVR?.homeSenkrechtSchicken()
            AVR?.manFeldRichtung(Int32(quelle), mousestatus:Int32(mausistdown), pfeilstep:700)
        } // mausistdown > 0
        else // Button released
        {
            print("swift PfeilFeldAktion Button released quelle: \(quelle)")
            AVR?.manFeldRichtung(Int32(quelle), mousestatus:Int32(mausistdown), pfeilstep:80)
        }
        
        
    }
    
    @objc func PfeilAktion(_ notification:Notification)
    {
        let info = notification.userInfo
        print(" PfeilAktion: info: \(notification.userInfo) \(info)")
        if  let mauscounter = info?["mousedownconter"]
        {
            let mc = mauscounter as! Int
            print(" PfeilAktion: mauscounter: \(mc)")
        }
        else
        {
            
        }
        
        if (info?["richtung"] != nil)
        {
            quelle = info?["richtung"] as! Int
            
            if info?["push"] != nil
            {
                mausistdown = info?["push"] as!Int
            } // if push
        }// if richtung
        else
        {
            NSSound.beep()
            quelle = 0
            mausistdown = 0
            return
        }
        
        if mausistdown > 0
        {
            switch quelle
            {
            case MANDOWN:
                print("PfeilAktion MANDOWN")
            case MANUP:
                print("PfeilAktion MANUP")
                AnschlagUntenIndikator.layer?.backgroundColor = NSColor.green.cgColor
            case MANLEFT:
                print("PfeilAktion MANLEFT")
            case MANRIGHT:
                print("PfeilAktion MANRIGHT")
                AnschlagLinksIndikator.layer?.backgroundColor = NSColor.green.cgColor
                
                
            default:
                break
            }// switch quelle
            AVR?.manRichtung(Int32(quelle), mousestatus:Int32(mausistdown), pfeilstep:700)
            
        } // mausistdown > 0
        else // Button released
        {
            print("swift Pfeilaktion Button released quelle: \(quelle)")
            AVR?.manRichtung(Int32(quelle), mousestatus:Int32(mausistdown), pfeilstep:80)
        }
        
        
    }// Pfeilaktion


    func numberOfRows(in tableView: NSTableView) -> Int {
        
       return (KoordinatenTabelle.count)
       
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
       let zeile = KoordinatenTabelle[row]
       //print("p: \(zeile)")
        let key = NSUserInterfaceItemIdentifier(tableColumn!.identifier.rawValue)
       let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(tableColumn!.identifier.rawValue), owner: self) as? NSTableCellView
        let keystring = KoordinatenFormatter.string(from:zeile[key.rawValue]! as NSNumber)
        //cell?.textField?.doubleValue = zeile[key.rawValue]! // ohne formatter
        cell?.textField?.stringValue = keystring!
       
       return cell
    }
} // end Hotwire

/*
//MARK: dataTable
extension rHotwireViewController
{
   func numberOfRows(in tableView: NSTableView) -> Int {
      return (KoordinatenTabelle.count)
      
   }
   
   func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
      let zeile = KoordinatenTabelle[row]
      //print("p: \(person)")
       let key = tableColumn!.identifier.rawValue
      let cell = tableView.makeView(withIdentifier: (tableColumn!.identifier), owner: self) as? NSTableCellView
       cell?.textField?.doubleValue = zeile[key]!
      
      return cell
   }
}
*/
