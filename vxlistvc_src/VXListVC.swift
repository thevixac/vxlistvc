
import UIKit

class VXListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tView : UITableView = UITableView()
    var rowTitles : NSMutableArray
    var rowVCs : Array< Void -> UIViewController>
    
    func setup() {

    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        print("well")
        rowTitles = NSMutableArray()
        //rowVCs = NSMutableArray()
        rowVCs = []

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        tView.backgroundColor =  UIColor.greenColor()
        self.view.addSubview(self.tView)
    }

    required init?(coder aDecoder: NSCoder) {
        rowTitles = NSMutableArray()

        rowVCs = []
        super.init(coder: aDecoder)
        print("vxlistvc init with coder")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blueColor();
        self.tView.frame = self.view.frame
        self.tView.delegate = self
        self.tView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addRow(title : NSString, vcCreator:() -> UIViewController) {
//        rowVCs.addObject(vcCreator)
        rowVCs.append(vcCreator)
        rowTitles.addObject(title)
        
    }
    /*
    func addRow(title : NSString, vc: UIViewController) {
        print("adding row \(title)")
        rowTitles.addObject(title)
        rowVCs.addObject(vc)
        self.tView.reloadData()
    }*/
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowTitles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = UITableViewCell()
        item.textLabel?.text = rowTitles.objectAtIndex(indexPath.row) as! String
        return item
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = rowVCs[indexPath.row]() as! UIViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
