import SwiftUI

struct MyTask: Identifiable, Hashable, Codable {
    var id: String = UUID().uuidString
    var title: String
    var description: String
    var isComplete: Bool
}

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

struct ContentView: View {
    @StateObject var viewModel: ViewModel = ViewModel()
    @State var displayAddNewTask: Bool = false
    @State var displayEditTask: Bool = false
    @State var selectedTask: MyTask?
    
    var body: some View {
        NavigationStack {
            ZStack {
                List(viewModel.tasks) { task in
                    HStack {
                        Image(systemName: task.isComplete ? "checkmark.circle" : "circle")
                            .foregroundColor(task.isComplete ? .green : .blue)
                        
                        VStack(alignment: .leading) {
                            Text(task.title)
                                .font(.headline)
                            Text(task.description)
                                .font(.subheadline)
                        }
                        .onTapGesture {
                            selectedTask = task
                            displayEditTask.toggle()
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.deleteTask(task: task)
                        }){
                            Image(systemName: "trash")
                                .foregroundStyle(.red)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .onTapGesture {
                        viewModel.updateTask(task: task)
                    }
                }
                
                if viewModel.tasks.isEmpty {
                    VStack(alignment: .center) {
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
            .sheet(isPresented: $displayAddNewTask) {
                AddNewTask(tasks: $viewModel.tasks)
            }
            .sheet(item: $selectedTask) { task in
                EditTask(task: task, onSave: { updatedTask in
                    viewModel.editTask(updatedTask: updatedTask)})
            }
        }
    }
}

struct EditTask: View {
    @State var task: MyTask
    var onSave: (MyTask) -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $task.title)
                TextField("Description", text: $task.description)
            }
            .navigationTitle("Edit Task")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .tint(.red)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        onSave(task)
                        dismiss()
                    }
                    .disabled(task.title.isEmpty || task.description.isEmpty)
                }
            }
        }
    }
}

struct AddNewTask: View {
        @State var title: String = ""
        @State var description: String = ""
        @Binding var tasks: [MyTask]
        @Environment(\.dismiss) var dismiss
        
        var body: some View {
            NavigationStack {
                Form {
                    TextField("Title", text: $title)
                        .autocorrectionDisabled()
                    TextField("Description", text: $description)
                        .autocorrectionDisabled()
                }
                .navigationTitle("New Task")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                        .tint(.red)
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Add") {
                            let newTask = MyTask(title: title, description: description, isComplete: false)
                            tasks.append(newTask)
                            dismiss()
                        }
                        .disabled(title.isEmpty || description.isEmpty)
                    }
                }
            }
        }
    }


#Preview {
    ContentView()
}
