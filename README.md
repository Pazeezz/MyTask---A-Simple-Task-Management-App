
# MyTask - A Simple Task Management App

MyTask is a minimal and intuitive task management app built with SwiftUI. It allows users to add, edit, and delete tasks, while also enabling the marking of tasks as complete or incomplete. The app features a clean UI and seamless task management, perfect for everyday use.

## Features
- **Add Tasks**: Add tasks with a title and description.
- **Edit Tasks**: Easily edit tasks by clicking on the task text.
- **Complete Tasks**: Mark tasks as complete by tapping the circle next to the task.
- **Delete Tasks**: Delete tasks by clicking the trash icon next to each task.
- **Real-Time Task Update**: Task states are instantly updated and reflected in the UI.

## Screenshots

### 1. Empty Task List

When there are no tasks, the app displays a friendly "Nothing to show yet" message with an empty tray icon:

![Empty Task List](./mnt/data/Simulator Screenshot - iPhone 16 Pro - 2024-10-18 at 21.39.13.png)

### 2. Add New Task

You can add a new task by tapping the plus icon. A form will appear allowing you to enter a task title and description:

![Add New Task](./mnt/data/Simulator Screenshot - iPhone 16 Pro - 2024-10-18 at 21.47.48.png)

### 3. Task List View

Once tasks are added, they appear in a list, showing their title and description. You can mark tasks as complete or delete them:

![Task List View](./mnt/data/Simulator Screenshot - iPhone 16 Pro - 2024-10-18 at 21.47.54.png)

### 4. Completed Tasks

Tapping the circle icon marks the task as complete, and the circle turns into a green checkmark:

![Completed Task](./mnt/data/Simulator Screenshot - iPhone 16 Pro - 2024-10-18 at 21.48.00.png)

### 5. Mixed Task States

The app supports mixed task states where some tasks are complete while others are still pending:

![Mixed Task States](./mnt/data/Simulator Screenshot - iPhone 16 Pro - 2024-10-18 at 21.48.15.png)

## Code Overview

### Task Model
The `MyTask` struct defines the task model with properties like `id`, `title`, `description`, and `isComplete`.

```swift
struct MyTask: Identifiable, Hashable, Codable {
    var id: String = UUID().uuidString
    var title: String
    var description: String
    var isComplete: Bool
}
```

### ViewModel
The `ViewModel` class is responsible for managing the task list. It allows for adding, editing, deleting, and updating the completion state of tasks.

```swift
class ViewModel: ObservableObject {
    @Published var tasks: [MyTask] = []
    
    func updateTask(task: MyTask) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isComplete.toggle()
        }
    }
    
    func editTask(updatedTask: MyTask) {
        if let index = tasks.firstIndex(where: { $0.id == updatedTask.id }) {
            tasks[index] = updatedTask
        }
    }
    
    func deleteTask(task: MyTask) {
        if let index = tasks.firstIndex(where: {$0.id == task.id}){
            tasks.remove(at: index)
        }
    }
}
```

### Task Views
- **AddNewTask**: Allows users to input and add new tasks.
- **EditTask**: Provides a form to edit existing tasks.
- **ContentView**: The main task list view that displays all tasks and handles task completion, deletion, and navigation.

```swift
struct ContentView: View {
    @StateObject var viewModel: ViewModel = ViewModel()
    @State var displayAddNewTask: Bool = false
    @State var displayEditTask: Bool = false
    @State var selectedTask: MyTask?
    
    var body: some View {
        NavigationStack {
            ZStack {
                List(viewModel.tasks) { task in
                    // Task row layout here
                }
                
                if viewModel.tasks.isEmpty {
                    VStack {
                        Image(systemName: "tray")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)

                        Text("Nothing to show yet.")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .multilineTextAlignment(.center)
                }
            }
            .navigationTitle("My Tasks")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        displayAddNewTask.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}
```

## How to Run
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/MyTask.git
   cd MyTask
   ```
2. Open the project in Xcode:
   ```bash
   open MyTask.xcodeproj
   ```
3. Run the app on your iOS simulator or device.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
