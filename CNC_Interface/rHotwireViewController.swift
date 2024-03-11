//
//  rHotwire.swift
//  CNC_Interface
//
//  Created by Ruedi Heimlicher on 01.07.2022.
//  Copyright © 2022 Ruedi Heimlicher. All rights reserved.
//

import Cocoa

var outletdaten:[String:AnyObject] = [:]

@objc class rPfeil_Taste:NSButton
{
    required init?(coder  aDecoder : NSCoder)
    {
        print("rPfeil_Taste required init")
        super.init(coder: aDecoder)
        
    }
    
    override func mouseDown(with theEvent: NSEvent)
    {
        let pfeiltag:Int = self.tag
        super.mouseDown(with: theEvent)
      }
    
    @objc func reportPfeiltaste(pfeiltag:Int)
    {
        print("reportPfeiltaste")
    }
}


@objc class rHotwireViewController: rViewController
{
      
   var hintergrundfarbe:NSColor = NSColor()
   //rTSP_NN* nn;
   var nn:rTSP_NN!
    var micro:Int!
    //var AVR = rAVRview()
    
   var CNC_PList:NSMutableDictionary!
   
   var ProfilTable: NSTableView!          
   var ProfilDaten: NSMutableArray!   
   
    var motorsteps = 47
    var speed = 6
   /*
   var ProfilDatenOA: NSArray    
   var ProfilDatenUA: NSArray                 
    var ProfilDatenOB: NSArray                  
   var ProfilDatenUB: NSArray
*/
   
   //var   Scale: Double!;
   //var   cncposition: Int!
   //var   cncstatus: Double!

   var GraphEnd: Int!
   /*
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
   var   motorsteps: Int!
   var   micro: Int!
*/
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
   
   @IBOutlet weak var intpos0Feld: NSStepper!
   //@IBOutlet weak var StepperTab: rTabview!
    
   //@IBOutlet weak var TaskTab: rTabview!
   @IBOutlet weak var  ProfilFeld: NSTextField!
    
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
   
   @IBOutlet weak var  EinlaufCheckbox: NSButton!
   @IBOutlet weak var  AuslaufCheckbox: NSButton!
   
   @IBOutlet weak var  AbbrandCheckbox: NSButton!
   
   @IBOutlet weak var  ScalePop: NSPopUpButton!
   @IBOutlet weak var  Profil1Pop: NSPopUpButton!
   @IBOutlet weak var  Profil2Pop: NSPopUpButton!
   
   @IBOutlet  weak var  CNCTable: NSTableView!
   @IBOutlet  weak var  CNCScroller: NSScrollView!

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

   @IBOutlet weak var PWMFeld: NSTextField! 
   @IBOutlet weak var PWMStepper: NSStepper! 

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
    
    

   @IBAction func reportManRight(_ sender: rPfeil_Taste)
   {
      print("swift reportManRight: \(sender.tag)")
       cnc_seite1check = CNC_Seite1Check.state.rawValue as Int
       cnc_seite2check = CNC_Seite2Check.state.rawValue as Int
       outletdaten["cnc_seite1check"] = CNC_Seite1Check.state.rawValue as Int as AnyObject
       outletdaten["cnc_seite2check"] = CNC_Seite2Check.state.rawValue as Int as AnyObject
       outletdaten["speed"] = SpeedFeld.integerValue as AnyObject
       outletdaten["micro"] = micro as AnyObject
print("outletdaten: \(outletdaten)")
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

    /*******************************************************************/
    // CNC
    /*******************************************************************/
    @IBAction func report_Motorsteps(_ sender: NSSegmentedControl)
    {
        print("report_Motorsteps")
       let stepsindex = sender.selectedSegment
       motorsteps = sender.tag(forSegment: stepsindex)
        var NotificationDic = [String:Int]()
        
       
        NotificationDic["motorsteps"] = motorsteps
        
        
        let nc = NotificationCenter.default
        nc.post(name:Notification.Name(rawValue:"motorsteps"),
        object: nil,
        userInfo: NotificationDic)

    }

    @IBAction func report_Microsteps(_ sender: NSPopUpButton)
    {
        print("report_Microsteps")
       let stepsindex = sender.indexOfSelectedItem
        motorsteps = sender.selectedTag()
        var NotificationDic = [String:Int]()
        
       
        NotificationDic["micro"] = motorsteps
        
        
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
      
 
       
      Auslauftiefe.integerValue = 10
      
       hotwireplist =  readHotwire_PList()
      
       outletdaten["cnc_seite1check"] = CNC_Seite1Check.state.rawValue as Int as AnyObject
       outletdaten["cnc_seite2check"] = CNC_Seite2Check.state.rawValue as Int as AnyObject
       
       var stepsindex = CNC_StepsSegControl.selectedSegment
       motorsteps = CNC_StepsSegControl.tag(forSegment:stepsindex)
       outletdaten["motorsteps"] = CNC_StepsSegControl.tag(forSegment:stepsindex)  as AnyObject

       micro = CNC_microPop.selectedItem?.tag
       
      if (hotwireplist["koordinatentabelle"] != nil)
      {
         print("koordinatentabelle: \(hotwireplist["koordinatentabelle"] )")
      }
       
      if (hotwireplist["pwm"] != nil)
      {
         let plistpwm = hotwireplist["pwm"] as! Int 
         print("plistpwm: \(plistpwm)")
         DC_PWM.integerValue = hotwireplist["pwm"] as! Int
         DC_Slider.integerValue = hotwireplist["pwm"] as! Int
         DC_Stepper.integerValue = hotwireplist["pwm"] as! Int
         
      }
      else
      {
         DC_PWM.integerValue = 10
         DC_Slider.integerValue = 10
         DC_Stepper.integerValue = 10

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
       
       settingsNotificationDic["schnittsettigs"] = hotwireplist as AnyObject
       
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
            print("zeile: \(zeile)")
         }
         print("0: \(plistData["0"])")
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
   
    
   @objc func usbstatusAktion(_ notification:Notification) 
   {
      let info = notification.userInfo
      guard let status = info?["usbstatus"] as? Int else 
      { 
         print("Basis usbstatusAktion: kein status\n")
         return  
         
      }// 
      //print("Hotwire usbstatusAktion:\t \(status)")
      usbstatus = Int32(status)
   }


} // end Hotwire
