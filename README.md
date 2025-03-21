# **Imporgent** 📊
**Your Personal Eisenhower Matrix App**

Imporgent is a productivity app designed to help you prioritize tasks using the Eisenhower Matrix. By categorizing tasks into four quadrants—**Urgent & Important**, **Not Urgent & Important**, **Urgent & Not Important**, and **Not Urgent & Not Important**—you can focus on what truly matters and eliminate distractions.

---

## **Features Implemented So Far** 🛠️

### **Core Data Integration**
- **`TaskItem` Entity**: Stores task details like `title`, `details`, `deadline`, `urgencyScore`, `importanceScore`, `quadrant`, and `isCompleted`.
- **`PersistenceController`**: Manages Core Data operations, including a preview instance for testing.

### **Matrix View**
- **Grid Layout**: Displays tasks in a 2x2 grid representing the four quadrants.
- **Quadrant View**: Shows tasks for each quadrant with proper styling and accessibility support.
- **Task Card**: Represents individual tasks with a clean, modern design.

### **Task Input & Editing**
- **TaskInputView**: A form for adding and editing tasks with smart categorization based on urgency and importance.
- **TaskDetailView**: A dedicated view for displaying task details, with an **Edit button** to navigate to `TaskInputView`.

### **Navigation**
- **Seamless Transitions**: Uses `NavigationStack` and `sheet` for smooth navigation between `MatrixView`, `TaskDetailView`, and `TaskInputView`.

### **Temporary Patch for Previews**
- Previews are temporarily disabled to allow testing on a physical device. We’ll revisit this later!

---

## **Goals Going Forward** 🚀

### **1. Add Reminders Functionality** ⏰
- Allow users to set reminders for tasks.
- Integrate with `NotificationCenter` to schedule local notifications.
- Add a reminder toggle and date picker in `TaskInputView`.

### **2. Implement a Separate Tasks View** 📝
- Create a checklist-style view similar to Apple’s Reminders app.
- Display all tasks in a list with checkboxes for completion.
- Allow sorting and filtering by quadrant, deadline, or completion status.

### **3. Fix Previews** 🖼️
- Resolve the `buildExpression` errors in the previews.
- Ensure previews work with Core Data and optional properties.

### **4. Enhance UI/UX** 🎨
- Add animations and transitions for a polished user experience.
- Improve accessibility with dynamic type support and VoiceOver compatibility.

### **5. Add Analytics & Insights** 📊
- Provide insights into task completion rates and quadrant distribution.
- Visualize productivity trends over time using charts.

---

## **Tentative Timeline** ⏳

### **Phase 1: Core Functionality (Completed)**
- Set up Core Data and basic views (`MatrixView`, `TaskInputView`, `TaskDetailView`).
- Implement navigation and task management.

### **Phase 2: Reminders & Checklist View**
- Add reminders functionality with local notifications.
- Implement a checklist-style tasks view for a more traditional task management experience.

### **Phase 3: Polish & Refinement**
- Fix previews and ensure compatibility with Core Data.
- Enhance UI/UX with animations, accessibility features, and visual flourishes.

### **Phase 4: Analytics & Insights**
- Add productivity insights and visualizations.
- Allow users to track their progress over time.

### **Phase 5: Launch Preparation**
- Perform thorough testing and bug fixes.
- Prepare for App Store submission (e.g., app icon, screenshots, description).

---

## **How to Get Started** 🛠️

### **Prerequisites**
- Xcode 15+.
- iOS 17+ (for SwiftUI features like `NavigationStack`).

### **Installation**
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/Imporgent.git
   ```
2. Open the project in Xcode:
   ```bash
   cd Imporgent
   open Imporgent.xcodeproj
   ```
3. Build and run the app on your iPhone or simulator.

---

## **Contributing** 🤝
Contributions are welcome! If you’d like to contribute to Imporgent, please follow these steps:
1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Submit a pull request with a detailed description of your changes.

---

## **License** 📜
Imporgent is released under the **MIT License**. See the [LICENSE](LICENSE) file for details.

---

## **Acknowledgments** 🙏
- Inspired by the **Eisenhower Matrix** for task prioritization.
- Built with ❤️ using SwiftUI and Core Data.

---

## **Contact** 📧
Have questions or feedback? Reach out to [Trevor Drozd] at [trcharlesd@gmail.com].

---

Let’s make productivity simple and fun with **Imporgent**! 🚀

---
