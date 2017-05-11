
import UIKit
import FMDB

let sharedInstance = ModelManager()

class ModelManager: NSObject {
    
    var database: FMDatabase? = nil

    class func getInstance() -> ModelManager
    {
        if(sharedInstance.database == nil)
        {
            sharedInstance.database = FMDatabase(path: Util.getPath("Socket_chat.sqlite"))
        }
        return sharedInstance
    }
    
    func addData(_ tblName: String,_ columns: String,_ values : String) -> Bool {
        sharedInstance.database?.open()
        let val = String(values.characters.filter { !"\n".characters.contains($0) })
        let isInserted = sharedInstance.database!.executeStatements("INSERT OR REPLACE INTO \(tblName) (\(columns)) VALUES (\(val))")
//        sharedInstance.database?.close()
        return isInserted
        
    }
    
    func updateData(_ tblName: String,_ changeField: String,_ condition: String) -> Bool {
        sharedInstance.database?.open()
        let isUpdated = sharedInstance.database!.executeStatements("UPDATE \(tblName) set \(changeField) WHERE \(condition)")
//        sharedInstance.database?.close()
        return isUpdated
    }
    
    func deleteData(_ studentInfo: AnyObject) -> Bool {
        //        sharedInstance.database!.open()
        //        let isDeleted = sharedInstance.database!.executeUpdate("DELETE FROM student_info WHERE RollNo=?", withArgumentsIn: [studentInfo.RollNo])
        //        sharedInstance.database!.close()
        //        return isDeleted
        return true
        
    }
    
    func senddataserver(_ tableName : String) -> NSMutableArray{
        sharedInstance.database?.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM \(tableName) where ack = 0", withArgumentsIn: nil)
        _ = sharedInstance.database!.executeQuery("", withArgumentsIn: nil)
        let marrStudentInfo : NSMutableArray = NSMutableArray()
        var dic = [String:Any]()
        if (resultSet != nil) {
            while resultSet.next() {
                
                for i in 0..<resultSet.columnCount() {
                    if resultSet.columnName(for: i) == "sender_id" || resultSet.columnName(for: i) == "receiver_id" {
                        dic[resultSet.columnName(for: i)] = Int(resultSet.string(forColumn: resultSet.columnName(for: i)))
                    } else {
                        dic[resultSet.columnName(for: i)] = resultSet.string(forColumn: resultSet.columnName(for: i))
                    }
                }
                marrStudentInfo.add(dic)
            }
        }
//        sharedInstance.database?.close()
        return marrStudentInfo
    }
    
    func getlatest(_ tableName : String , _ sender_id : Int , _ receiver_id : Int) -> NSMutableArray{
        sharedInstance.database?.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM \(tableName) where sender_id = \(sender_id) and receiver_id = \(receiver_id) or sender_id = \(receiver_id) and receiver_id = \(sender_id) ORDER BY rowid DESC LIMIT 1", withArgumentsIn: nil)
        let marrStudentInfo : NSMutableArray = NSMutableArray()
        var dic = [String:Any]()
        if (resultSet != nil) {
            while resultSet.next() {
                
                for i in 0..<resultSet.columnCount() {
                    if resultSet.columnName(for: i) == "sender_id" || resultSet.columnName(for: i) == "receiver_id" {
                        dic[resultSet.columnName(for: i)] = Int(resultSet.string(forColumn: resultSet.columnName(for: i)))
                    } else {
                        dic[resultSet.columnName(for: i)] = resultSet.string(forColumn: resultSet.columnName(for: i))
                    }
                }
                marrStudentInfo.add(dic)
            }
        }
//        sharedInstance.database?.close()

        return marrStudentInfo
    }
    
    func getack (_ tableName : String , _ reciver_id : String,_ data : String) -> Int {
        sharedInstance.database?.open()
        var c = 0
        let q = "SELECT * FROM \(tableName) where sender_id = \(reciver_id) and \(data)"
        let resultSet = sharedInstance.database!.executeQuery(q, withArgumentsIn: nil)
        while(resultSet?.next())! {
            c = c + 1
        }
        print(resultSet!)
//        sharedInstance.database?.close()
        return c
    }
    

    func getData(_ tableName : String,_ sender_id : String,_ reciever_id : String) -> NSMutableArray {
        sharedInstance.database!.open()
        let q = "SELECT * FROM \(tableName) where sender_id = \(sender_id) and receiver_id = \(reciever_id) or sender_id = \(reciever_id) and receiver_id = \(sender_id)"
        print(q)
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(q, withArgumentsIn: nil)
        let marrStudentInfo : NSMutableArray = NSMutableArray()
        _ = [String]()
        if (resultSet != nil) {
            while resultSet.next() {
                var dic:[String:Any]? = [:]
                for i in 0..<resultSet.columnCount() {
                    dic?[String(resultSet.columnName(for: i))] = resultSet.string(forColumn: resultSet.columnName(for: i))
                }
                marrStudentInfo.add(dic!)
                //                for _ in 0..<resultSet.columnCount() {
                //                    msg.append(String(describing: resultSet))
                //                }
            }
        }
//        sharedInstance.database?.close()
        return marrStudentInfo
    }
    
    func check(_ tableName: String,_ param : String,_ id: Int) -> Bool{
        sharedInstance.database?.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM \(tableName) where \(param) = \(id)",withArgumentsIn: nil)
        if (resultSet.next() == true) {
            return true
        }
        else {
            return false
        }
//        sharedInstance.database?.close()

    }
    
    
    func getAllData(_ tableName : String) -> NSMutableArray {
        sharedInstance.database?.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM \(tableName) where user_id <> \(AppDelegate.senderId)", withArgumentsIn: nil)
        let marrStudentInfo : NSMutableArray = NSMutableArray()
        if (resultSet != nil) {
            while resultSet.next() {
                var dic:[String:Any]? = [:]
                for i in 0..<resultSet.columnCount() {
                    if resultSet.columnName(for : i).lowercased().contains("id"){
                        dic?[String(resultSet.columnName(for: i))] = Int(resultSet.string(forColumn: resultSet.columnName(for: i)))
                    } else {
                        dic?[String(resultSet.columnName(for: i))] = resultSet.string(forColumn: resultSet.columnName(for: i))
                    }
                }
                marrStudentInfo.add(dic!)
            }
        }
        return marrStudentInfo
    }
    
    func exec(_ query :String) -> [String:Any] {
        sharedInstance.database?.open()

        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(query, withArgumentsIn: nil)
        var dic = [String:Any]()

        if (resultSet != nil) {
            while resultSet.next() {
                
                for i in 0..<resultSet.columnCount() {
                    dic[resultSet.columnName(for: i)] = resultSet.string(forColumn: resultSet.columnName(for: i))
                }
            }
        }
        return dic
    }
    
    func getCount(_ tblName: String,_ condition: String,_ countCol: String) -> [String:Any] {
        sharedInstance.database?.open()

        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT COUNT(\(countCol)) FROM \(tblName) WHERE \(condition)", withArgumentsIn: nil)
        var dic = [String:Any]()
        if (resultSet != nil) {
            while resultSet.next() {
                
                for i in 0..<resultSet.columnCount() {
                    dic[resultSet.columnName(for: i)] = resultSet.string(forColumn: resultSet.columnName(for: i))
                }
            }
        }
//        sharedInstance.database?.close()
        return dic
    }
    
}
