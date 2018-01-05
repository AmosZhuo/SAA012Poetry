//
//  DetailViewController.swift
//  SAA012Poetry
//
//  Created by Apple on 2017/12/30.
//  Copyright © 2017年 SAA. All rights reserved.
//

import UIKit
import CoreData


class DetailViewController: UIViewController,NSFetchedResultsControllerDelegate {
    var event:Event!
    var fController:NSFetchedResultsController<Event>!
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet weak var detailDescriptionAuthor: UILabel!
    @IBOutlet weak var detailDescriptionContent: UILabel!
    
    
    
    func configureView() {
        // Update the user interface for the detail item.
        //indexCurr = (detailItem?.id)!
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = "\(detail.id). \(detail.title!)"
            }
            if let label = detailDescriptionAuthor {
                label.text = "\(detail.dynasty!) (\(detail.author!))"
            }
            if let label = detailDescriptionContent {
                label.lineBreakMode = NSLineBreakMode.byWordWrapping
                label.numberOfLines = 0
                label.text = detail.content!+"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
                
                
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
        preparedIcon()
    }
    
    func preparedIcon()
    {
        let bt1 = UIButton(type:UIButtonType.roundedRect)
        let rect = CGRect(x:200,y:670,width:32,height:32)
        bt1.frame = rect
        
        let image = UIImage(named:"star-2")
        bt1.setBackgroundImage(image, for: UIControlState())
        //bt1.setTitle("Tap", for: UIControlState())
        //bt1.setTitleColor(UIColor.white, for: UIControlState())
        //bt1.titleLabel?.font = UIFont(name:"Arial",size:24)
        //bt1.addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControlEvents#>)
       
        self.view.addSubview(bt1)
        
        let btNext = UIButton(type:UIButtonType.roundedRect)
        let rectNext = CGRect(x:330,y:670,width:32,height:32)
        btNext.frame = rectNext
        
        let imageNext = UIImage(named:"next")
        btNext.setBackgroundImage(imageNext, for: UIControlState())
        //btNext.setTitle("Tap", for: UIControlState())
        //btNext.setTitleColor(UIColor.white, for: UIControlState())
        //btNext.titleLabel?.font = UIFont(name:"Arial",size:24)
        btNext.addTarget(self, action: #selector(DetailViewController.btnNextTap(_:)), for: UIControlEvents.touchUpInside)
        
        self.view.addSubview(btNext)

        let btPrevious = UIButton(type:UIButtonType.roundedRect)
        let rectPrevious = CGRect(x:50,y:670,width:32,height:32)
        btPrevious.frame = rectPrevious
        
        let imagePrevious = UIImage(named:"previous")
        btPrevious.setBackgroundImage(imagePrevious, for: UIControlState())
        //btNext.setTitle("Tap", for: UIControlState())
        //btNext.setTitleColor(UIColor.white, for: UIControlState())
        //btNext.titleLabel?.font = UIFont(name:"Arial",size:24)
        btPrevious.addTarget(self, action: #selector(DetailViewController.btnPreviousTap(_:)), for: UIControlEvents.touchUpInside)
        
        self.view.addSubview(btPrevious)

        
    }
    @objc
    func btnPreviousTap(_ button:UIButton)
    {
        //detailDescriptionAuthor.text = "hihihi"
        var toIndex:Int
        
        toIndex = Int((detailDescriptionLabel.text!).split{$0=="."}[0])! - Int(2)
        fetchCoreData(intIndex: toIndex)
    }
    
    
    @objc
    func btnNextTap(_ button:UIButton)
    {
        //detailDescriptionAuthor.text = "hihihi"
        var toIndex:Int
        toIndex = Int((detailDescriptionLabel.text!).split{$0=="."}[0])!
        fetchCoreData(intIndex: toIndex)
    }
    
    func fetchCoreData (intIndex:Int){
        //加载AppDelegate
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        let request = NSFetchRequest<Event>(entityName:"Event")
        
        let sortDesc = NSSortDescriptor(key:"id",ascending:true)
        request.sortDescriptors=[sortDesc]
        
        let fController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        //fController.delegate = self
        do{
            try fController.performFetch()
            let detail = fController.fetchedObjects![intIndex]
            //userInfo = object as! UserInfo
            
            //lblInfo.text = object.userAccount! + "\(String(describing: fController.fetchedObjects?.count))"
            
            detailDescriptionLabel.text = "\(detail.id). \(detail.title!)"
                
            detailDescriptionAuthor.text = "\(detail.dynasty!) (\(detail.author!))"
                
            detailDescriptionContent.lineBreakMode = NSLineBreakMode.byWordWrapping
            detailDescriptionContent.numberOfLines = 0
            detailDescriptionContent.text = detail.content!+"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
                    
                    
       
            
            
        }catch{
            print(error)
        }
        
        //userInfo = appDel.persistentContainer.viewContext.fetch(request)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Event? {
        didSet {
            // Update the view.
            configureView()
        }
    }

    

}

