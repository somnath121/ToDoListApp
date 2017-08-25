import UIKit
import RealmSwift

final class TodoItem: Object {
    dynamic var taskName = ""
    dynamic var taskCompletionStatus = false
}
