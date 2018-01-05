//
//  MasterViewController.swift
//  SAA012Poetry
//
//  Created by Apple on 2017/12/30.
//  Copyright © 2017年 SAA. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil

    struct poetry
    {
        var id : Int32
        var title : String
        var dynasty : String
        var author : String
        var content : String
        
        init(id:Int32,title:String,dynasty:String,author:String,content:String)
        {
            self.id = id
            self.title = title
            self.dynasty = dynasty
            self.author = author
            self.content = content
        }
        
        func getDescription() ->String
        {
            return "\(id)"+title+dynasty+author
        }
    }
    
    
    var pData = [poetry]()

    @IBAction func btnClearDataTap(_ sender: UIButton) {
        
        presetdata()
        let context = self.fetchedResultsController.managedObjectContext
        for p in pData
        {
            
        let newEvent = Event(context: context)
        newEvent.timestamp = Date()
        newEvent.id = p.id
        newEvent.title = p.title
        newEvent.dynasty = p.dynasty
        newEvent.author = p.author
        newEvent.content = p.content
        
        // Save the context.
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        //navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc
    func insertNewObject(_ sender: Any) {
        let context = self.fetchedResultsController.managedObjectContext
        let newEvent = Event(context: context)
             
        // If appropriate, configure the new managed object.
        newEvent.timestamp = Date()
        newEvent.id = 1

        // Save the context.
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
            let object = fetchedResultsController.object(at: indexPath)
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let event = fetchedResultsController.object(at: indexPath)
        configureCell(cell, withEvent: event)
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = fetchedResultsController.managedObjectContext
            context.delete(fetchedResultsController.object(at: indexPath))
                
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func configureCell(_ cell: UITableViewCell, withEvent event: Event) {
        cell.textLabel!.text = "\(event.id). \(event.title!)    \(event.dynasty!) (\(event.author!))"//event.timestamp!.description + "\(event.id+200)"
    }

    // MARK: - Fetched results controller

    var fetchedResultsController: NSFetchedResultsController<Event> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
             // Replace this implementation with code to handle the error appropriately.
             // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             let nserror = error as NSError
             fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }    
    var _fetchedResultsController: NSFetchedResultsController<Event>? = nil

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
            case .insert:
                tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            case .delete:
                tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            default:
                return
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                tableView.insertRows(at: [newIndexPath!], with: .fade)
            case .delete:
                tableView.deleteRows(at: [indexPath!], with: .fade)
            case .update:
                configureCell(tableView.cellForRow(at: indexPath!)!, withEvent: anObject as! Event)
            case .move:
                configureCell(tableView.cellForRow(at: indexPath!)!, withEvent: anObject as! Event)
                tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    /*
     // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
     
     func controllerDidChangeContent(controller: NSFetchedResultsController) {
         // In the simplest, most efficient, case, reload the table view.
         tableView.reloadData()
     }
     */
    
    
    func presetdata()
    {
        pData.removeAll()
        pData.append(poetry(id: 1,title: "江南",dynasty: "",author: "汉乐府",content: """
江南可采莲，
莲叶何田田。
鱼戏莲叶间，
鱼戏莲叶东，
鱼戏莲叶西，
鱼戏莲叶南，
鱼戏莲叶北。
"""))
        pData.append(poetry(id: 2,title: "长歌行",dynasty: "",author: "汉乐府",content: """
青青园中葵，
朝露待日晞。
阳春布德泽，
万物生光辉。
常恐秋节至，
焜黄华叶衰。
百川东到海，
何时复西归？
少壮不努力，
老大徒伤悲。
"""))
        pData.append(poetry(id: 3,title: "敕勒歌",dynasty: "",author: "北朝民歌",content: """
敕勒川，
阴山下。
天似穹庐，
笼盖四野。
天苍苍，
野茫茫，
风吹草低见牛羊。
"""))
        pData.append(poetry(id: 4,title: "咏鹅",dynasty: "唐",author: "骆宾王",content: """
鹅、鹅、鹅，
曲项向天歌。
白毛浮绿水，
红掌拨清波。
"""))
        pData.append(poetry(id: 5,title: "风",dynasty: "唐",author: "李峤",content: """
解落三秋叶，
能开二月花。
过江千尺浪，
入竹万竿斜。
"""))
        pData.append(poetry(id: 6,title: "咏柳",dynasty: "唐",author: "贺知章",content: """
碧玉妆成一树高，
万条垂下绿丝绦。
不知细叶谁裁出，
二月春风似剪刀。
"""))
        pData.append(poetry(id: 7,title: "回乡偶书",dynasty: "唐",author: "贺知章",content: """
少小离家老大回，
乡音无改鬓毛催。
儿童相见不相识，
笑问客从何处来。
"""))
        pData.append(poetry(id: 8,title: "凉州词",dynasty: "唐",author: "王之涣",content: """
黄河远上白云间，
一片孤城万仞山。
羌笛何须怨杨柳，
春风不度玉门关。
"""))
        pData.append(poetry(id: 9,title: "登鹳雀楼",dynasty: "唐",author: "王之涣",content: """
白日依山尽，
黄河入海流。
欲穷千里目，
更上一层楼。
"""))
        pData.append(poetry(id: 10,title: "春晓",dynasty: "唐",author: "孟浩然",content: """
春眠不觉晓，
处处闻啼鸟。
夜来风雨声，
花落知多少。
"""))
        pData.append(poetry(id: 11,title: "凉州词",dynasty: "唐",author: "王翰",content: """
葡萄美酒夜光杯，
欲饮琵琶马上催。
醉卧沙场君莫笑，
古来征战几人回？
"""))
        pData.append(poetry(id: 12,title: "出塞",dynasty: "唐",author: "王昌龄",content: """
秦时明月汉时关，
万里长征人未还。
但使龙城飞将在，
不教胡马度阴山。
"""))
        pData.append(poetry(id: 13,title: "芙蓉楼送辛渐",dynasty: "唐",author: "王昌龄",content: """
寒雨连江夜入吴，
平明送客楚山孤。
洛阳亲友如相问，
一片冰心在玉壶。
"""))
        pData.append(poetry(id: 14,title: "鹿柴",dynasty: "唐",author: "王维",content: """
空山不见人，
但闻人语响。
返景入深林，
复照青苔上。
"""))
        pData.append(poetry(id: 15,title: "送元二使安西",dynasty: "唐",author: "王维",content: """
渭城朝雨浥轻尘，
客舍青青柳色新。
劝君更尽一杯酒，
西出阳关无故人。
"""))
        pData.append(poetry(id: 16,title: "九月九日忆山东兄弟",dynasty: "唐",author: "王维",content: """
独在异乡为异客，
每逢佳节倍思亲。
遥知兄弟登高处，
遍插茱萸少一人。
"""))
        pData.append(poetry(id: 17,title: "静夜思",dynasty: "唐",author: "李白",content: """
床前明月光，
疑是地上霜。
举头望明月，
低头思故乡。
"""))
        pData.append(poetry(id: 18,title: "古朗月行",dynasty: "唐",author: "李白",content: """
小时不识月，
呼作白玉盘。
又疑瑶台镜，
飞在青云端。
"""))
        pData.append(poetry(id: 19,title: "望庐山瀑布",dynasty: "唐",author: "李白",content: """
日照香炉生紫烟，
遥看瀑布挂前川。
飞流直下三千尺，
疑是银河落九天。
"""))
        pData.append(poetry(id: 20,title: "赠汪伦",dynasty: "唐",author: "李白",content: """
李白乘舟将欲行，
忽闻岸上踏歌声。
桃花潭水深千尺，
不及汪伦送我情。
"""))
        pData.append(poetry(id: 21,title: "黄鹤楼送孟浩然之广陵",dynasty: "唐",author: "李白",content: """
故人西辞黄鹤楼，
烟花三月下扬州。
孤帆远影碧空尽，
唯见长江天际流。
"""))
        pData.append(poetry(id: 22,title: "早发白帝城",dynasty: "唐",author: "李白",content: """
朝辞白帝彩云间，
千里江陵一日还。
两岸猿声啼不住，
轻舟已过万重山。
"""))
        pData.append(poetry(id: 23,title: "望天门山",dynasty: "唐",author: "李白",content: """
天门中断楚江开，
碧水东流至此回。
两岸青山相对出，
孤帆一片日边来。
"""))
        pData.append(poetry(id: 24,title: "别董大",dynasty: "唐",author: "高适",content: """
千里黄云白日曛，
北风吹雁雪纷纷。
莫愁前路无知己，
天下谁人不识君。
"""))
        pData.append(poetry(id: 25,title: "绝句",dynasty: "唐",author: "杜甫",content: """
两个黄鹂鸣翠柳，
一行白鹭上青天。
窗含西岭千秋雪，
门泊东吴万里船。
"""))
        pData.append(poetry(id: 26,title: "春夜喜雨",dynasty: "唐",author: "杜甫",content: """
好雨知时节，
当春乃发生。
随风潜入夜，
润物细无声。
野径云俱黑，
江船火独明。
晓看红湿处，
花重锦官城。
"""))
        pData.append(poetry(id: 27,title: "绝句",dynasty: "唐",author: "杜甫",content: """
迟日江山丽，
春风花草香。
泥融飞燕子，
沙暖睡鸳鸯。
"""))
        pData.append(poetry(id: 28,title: "江畔独步寻花",dynasty: "唐",author: "杜甫",content: """
黄师塔前江水东，
春光懒困倚微风。
桃花一簇开无主，
可爱深红爱浅红？
"""))
        pData.append(poetry(id: 29,title: "枫桥夜泊",dynasty: "唐",author: "张继",content: """
月落乌啼霜满天，
江枫渔火对愁眠。
姑苏城外寒山寺，
夜半钟声到客船。
"""))
        pData.append(poetry(id: 30,title: "滁州西涧",dynasty: "唐",author: "韦应物",content: """
独怜幽草涧边生，
上有黄鹂深树鸣。
春潮带雨晚来急，
野渡无人舟自横。
"""))
        pData.append(poetry(id: 31,title: "游子吟",dynasty: "唐",author: "孟郊",content: """
慈母手中线，
游子身上衣。
临行密密缝，
意恐迟迟归。
谁言寸草心，
报得三春晖！
"""))
        pData.append(poetry(id: 32,title: "早春呈水部张十八员外",dynasty: "唐",author: "韩愈",content: """
天街小雨润如酥，
草色遥看近却无。
最是一年春好处，
绝胜烟柳满皇都。
"""))
        pData.append(poetry(id: 33,title: "渔歌子",dynasty: "唐",author: "张志和",content: """
西塞山前白鹭飞，
桃花流水鳜鱼肥。
青箬笠，绿蓑衣，
斜风细雨不须归。
"""))
        pData.append(poetry(id: 34,title: "塞下曲",dynasty: "唐",author: "卢纶",content: """
月黑雁飞高，
单于夜遁逃。
欲将轻骑逐，
大雪满弓刀。
"""))
        pData.append(poetry(id: 35,title: "望洞庭",dynasty: "唐",author: "刘禹锡",content: """
湖光秋月两相和，
潭面无风镜未磨。
遥望洞庭山水色，
白银盘里一青螺。
"""))
        pData.append(poetry(id: 36,title: "浪淘沙",dynasty: "唐",author: "刘禹锡",content: """
九曲黄河万里沙，
浪淘风簸自天涯。
如今直上银河去，
同到牵牛织女家。
"""))
        pData.append(poetry(id: 37,title: "赋得古原草送别",dynasty: "唐",author: "白居易",content: """
离离原上草，
一岁一枯荣。
野火烧不尽，
春风吹又生。
"""))
        pData.append(poetry(id: 38,title: "池上",dynasty: "唐",author: "白居易",content: """
小娃撑小艇，
偷采白莲回。
不解藏踪迹，
浮萍一道开。
"""))
        pData.append(poetry(id: 39,title: "忆江南",dynasty: "唐",author: "白居易",content: """
江南好，
风景旧曾谙。
日出江花红胜火，
春来江水绿如蓝。
能不忆江南？
"""))
        pData.append(poetry(id: 40,title: "小儿垂钓",dynasty: "唐",author: "胡令能",content: """
蓬头稚子学垂纶，
侧坐莓苔草映身。
路人借问遥招手，
怕得鱼惊不应人。
"""))
        pData.append(poetry(id: 41,title: "悯农",dynasty: "唐",author: "李绅",content: """
锄禾日当午，
汗滴禾下土。
谁知盘中餐，
粒粒皆辛苦。
"""))
        pData.append(poetry(id: 42,title: "悯农",dynasty: "唐",author: "李绅",content: """
春种一粒粟，
秋收万颗子。
四海无闲田，
农夫犹饿死。
"""))
        pData.append(poetry(id: 43,title: "江雪",dynasty: "唐",author: "柳宗元",content: """
千山鸟飞绝，
万径人踪灭。
孤舟蓑笠翁，
独钓寒江雪。
"""))
        pData.append(poetry(id: 44,title: "寻隐者不遇",dynasty: "唐",author: "贾岛",content: """
松下问童子，
言师采药去。
只在此山中，
云深不知处。
"""))
        pData.append(poetry(id: 45,title: "山行",dynasty: "唐",author: "杜牧",content: """
远上寒山石径斜，
白云生处有人家。
停车坐爱枫林晚，
霜叶红于二月花。
"""))
        pData.append(poetry(id: 46,title: "清明",dynasty: "唐",author: "杜牧",content: """
清明时节雨纷纷，
路上行人欲断魂。
借问酒家何处有，
牧童遥指杏花村。
"""))
        pData.append(poetry(id: 47,title: "江南春",dynasty: "唐",author: "杜牧",content: """
千里莺啼绿映红，
水村山郭酒旗风。
南朝四百八十寺，
多少楼台烟雨中。
"""))
        pData.append(poetry(id: 48,title: "蜂",dynasty: "唐",author: "罗隐",content: """
不论平地与山尖，
无限风光尽被占。
采得百花成蜜后，
为谁辛苦为谁甜？
"""))
        pData.append(poetry(id: 49,title: "江上渔者",dynasty: "宋",author: "范仲淹",content: """
江上往来人，
但爱鲈鱼美。
君看一叶舟，
出没风波里。
"""))
        pData.append(poetry(id: 50,title: "元日",dynasty: "宋",author: "王安石",content: """
爆竹声中一岁除，
春风送暖入屠苏。
千门万户曈曈日，
总把新桃换旧符。
"""))
        pData.append(poetry(id: 51,title: "泊船瓜洲",dynasty: "宋",author: "王安石",content: """
京口瓜洲一水间，
钟山只隔数重山。
春风又绿江南岸，
明月何时照我还?
"""))
        pData.append(poetry(id: 52,title: "书湖阴先生壁",dynasty: "宋",author: "王安石",content: """
茅檐长扫净无苔，
花木成畦手自栽。
一水护田将绿绕，
两山排闼送青来。
"""))
        pData.append(poetry(id: 53,title: "六月二十七日望湖楼醉书",dynasty: "宋",author: "苏轼",content: """
黑云翻墨未遮山，
白雨跳珠乱入船。
卷地风来忽吹散，
望湖楼下水如天。
"""))
        pData.append(poetry(id: 54,title: "饮湖上初晴后雨",dynasty: "宋",author: "苏轼",content: """
水光潋滟晴方好，
山色空濛雨亦奇。
欲把西湖比西子，
淡妆浓抹总相宜。
"""))
        pData.append(poetry(id: 55,title: "惠崇春江晓景",dynasty: "宋",author: "苏轼",content: """
竹外桃花三两枝，
春江水暖鸭先知。
蒌蒿满地芦芽短，
正是河豚欲上时。
"""))
        pData.append(poetry(id: 56,title: "题西林壁",dynasty: "宋",author: "苏轼",content: """
横看成岭侧成峰，
远近高低各不同。
不识庐山真面目，
只缘身在此山中。
"""))
        pData.append(poetry(id: 57,title: "夏日绝句",dynasty: "宋",author: "李清照",content: """
生当作人杰，
死亦为鬼雄。
至今思项羽，
不肯过江东。
"""))
        pData.append(poetry(id: 58,title: "三衢道中",dynasty: "宋",author: "曾几",content: """
梅子黄时日日晴，
小溪泛尽却山行。
绿阴不减来时路，
添得黄鹂四五声。
"""))
        pData.append(poetry(id: 59,title: "示儿",dynasty: "宋",author: "陆游",content: """
死去元知万事空，
但悲不见九州同。
王师北定中原日，
家祭无忘告乃翁。
"""))
        pData.append(poetry(id: 60,title: "秋夜将晓出篱门迎凉有感",dynasty: "宋",author: "陆游",content: """
三万里河东入海，
五千仞岳上摩天。
遗民泪尽胡尘里，
南望王师又一年。
"""))
        pData.append(poetry(id: 61,title: "四时田园杂兴",dynasty: "宋",author: "范成大",content: """
昼出耘田夜绩麻，
村庄儿女各当家。
童孙未解供耕织，
也傍桑阴学种瓜。
"""))
        pData.append(poetry(id: 62,title: "四时田园杂兴",dynasty: "宋",author: "范成大",content: """
梅子金黄杏子肥，
麦花雪白菜花稀。
日长篱落无人过，
唯有蜻蜓蛱蝶飞。
"""))
        pData.append(poetry(id: 63,title: "小池",dynasty: "宋",author: "杨万里",content: """
泉眼无声惜细流，
树阴照水爱晴柔。
小荷才露尖尖角，
早有蜻蜓立上头。
"""))
        pData.append(poetry(id: 64,title: "晓出净慈寺送林子方",dynasty: "宋",author: "杨万里",content: """
毕竟西湖六月中，
风光不与四时同。
接天莲叶无穷碧，
映日荷花别样红。
"""))
        pData.append(poetry(id: 65,title: "春日",dynasty: "宋",author: "朱熹",content: """
胜日寻芳泗水滨，
无边光景一时新。
等闲识得东风面，
万紫千红总是春。
"""))
        pData.append(poetry(id: 66,title: "观书有感",dynasty: "宋",author: "朱熹",content: """
半亩方塘一鉴开，
天光云影共徘徊。
问渠那得清如许？
为有源头活水来。
"""))
        pData.append(poetry(id: 67,title: "题临安邸",dynasty: "宋",author: "林升",content: """
山外青山楼外楼，
西湖歌舞几时休？
暖风熏得游人醉，
直把杭州作汴州。
"""))
        pData.append(poetry(id: 68,title: "游园不值",dynasty: "宋",author: "叶绍翁",content: """
应怜屐齿印苍苔，
小扣柴扉久不开。
春色满园关不住，
一枝红杏出墙来。
"""))
        pData.append(poetry(id: 69,title: "乡村四月",dynasty: "宋",author: "翁卷",content: """
绿遍山原白满川，
子规声里雨如烟。
乡村四月闲人少，
才了蚕桑又插田。
"""))
        pData.append(poetry(id: 70,title: "墨梅",dynasty: "元",author: "王冕",content: """
吾家洗砚池头树，
个个花开淡墨痕。
不要人夸好颜色，
只留清气满乾坤。
"""))
        pData.append(poetry(id: 71,title: "石灰吟",dynasty: "明",author: "于谦",content: """
千锤万凿出深山，
烈火焚烧若等闲。
粉骨碎身全不怕，
要留清白在人间。
"""))
        pData.append(poetry(id: 72,title: "竹石",dynasty: "清",author: "郑燮",content: """
咬定青山不放松。
立根原在破岩中。
千磨万击还坚劲，
任尔东西南北风。
"""))
        pData.append(poetry(id: 73,title: "所见",dynasty: "清",author: "袁枚",content: """
牧童骑黄牛，
歌声振林樾。
意欲捕鸣蝉，
忽然闭口立。
"""))
        pData.append(poetry(id: 74,title: "村居",dynasty: "清",author: "高鼎",content: """
草长莺飞二月天，
拂堤杨柳醉春烟。
儿童散学归来早，
忙趁东风放纸鸢。
"""))
        pData.append(poetry(id: 75,title: "己亥杂诗",dynasty: "清",author: "龚自珍",content: """
九州生气恃风雷，
万马齐喑究可哀。
我劝天公重抖擞，
不拘一格降人才。
"""))
        
        /*
         
         pData.append(poetry(id: 5,title: "风",dynasty: "唐",author: "李",content: """
         解落三秋叶，
         能开二月花。
         过江千尺浪，
         入竹万竿斜。
         """))
         */
    }
    

}

