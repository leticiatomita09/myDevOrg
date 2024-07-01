# Detailed Documentation for Project Creation Component

## Design Decisions

### 1. Component Structure
- The Lightning Web Component (LWC) is designed to handle multi-step project creation.
- Steps include Project details, Milestones and To-Do Items, and Review.
- This structure ensures user-friendly interaction by guiding users through the creation process.

### 2. Data Handling
- Project and milestone data is captured via forms.
- Data is validated at each step to ensure completeness before proceeding.
- Apex controller (`ProjectController`) manages backend logic to create records in Salesforce.

### 3. UI/UX
- Utilizes Salesforce Lightning Design System (SLDS) for consistent styling.
- Includes a progress indicator for better user navigation and experience.
- Responsive and accessible design considerations.

## Implementation Steps

### 1. Apex Controller
- Created `ProjectController` to handle server-side logic for creating projects, milestones, and to-do items.
- Utilizes wrapper classes to deserialize JSON data for milestones and to-do items.
- Ensures data integrity with checks for non-blank names for projects, milestones, and to-do items.

### 2. Lightning Web Component (LWC)
- **HTML Template**: Contains the structure of the form, divided into three steps: Project, Milestones & To-Do Items, and Review.
- **JavaScript Controller**: Manages component state, handles user input, and coordinates navigation between steps.
- **CSS**: Custom styles to enhance the visual presentation of the component.

### 3. Field Relationships
- **Project**: Main object, related to milestones via master-detail relationship.
- **Milestone**: Related to both the project (parent) and to-do items (children).
- **To-Do Item**: Related to milestones, each to-do item tracks a specific task within a milestone.

### 4. App and Tabs
- Created a new Salesforce app for project management.
- Added two tabs: "Create Project" and "Projects".
- "Create Project" tab directs users to the project creation form.
- "Projects" tab lists all projects with their statuses and completion percentages.

## User Instructions

### 1. Creating a Project
- Navigate to the "Create Project" tab in the Salesforce app.
- Enter the project name and click "Next".
- Add milestones by entering their names.
- For each milestone, add to-do items with names and statuses.
- Review the project details.
- Click "Create Project" to save.

### 2. Navigation
- Use "Next" and "Back" buttons to move between steps.
- Ensure all required fields are filled before proceeding.

### 3. Validation
- The component will disable navigation if required fields are empty.
- Error messages will be shown if project creation fails due to backend issues.

### 4. Viewing Projects
- Navigate to the "Projects" tab to view a list of all projects.
- Check the status and completion percentage of each project.

## Deployable SFDX Project with Deployment Manifest

### 1. Project Structure
- The project is structured as an SFDX project with separate folders for Apex classes, LWC components, and configuration files.

### 2. Deployment Manifest
- A `package.xml` file lists all components needed for deployment.
- Ensure all metadata components are included for a successful deployment.

### Example Deployment Manifest (`package.xml`)

```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
    <types>
        <members>ProjectController</members>
        <name>ApexClass</name>
    </types>
    <types>
        <members>Project_Management_App</members>
        <name>CustomApplication</name>
    </types>
    <types>
        <members>Milestone__c.Perc_Complete__c</members>
        <members>Milestone__c.Project__c</members>
        <members>Milestone__c.Status__c</members>
        <members>Milestone__c.To_Do_Items_Completed__c</members>
        <members>Milestone__c.Total_To_Do_Items__c</members>
        <members>Project__c.Milestones_Completed__c</members>
        <members>Project__c.Perc_Complete__c</members>
        <members>Project__c.Status__c</members>
        <members>Project__c.Total_Milestone__c</members>
        <members>To_Do_Item__c.Milestone__c</members>
        <members>To_Do_Item__c.Status__c</members>
        <name>CustomField</name>
    </types>
    <types>
        <members>Milestone__c</members>
        <members>Project__c</members>
        <members>To_Do_Item__c</members>
        <name>CustomObject</name>
    </types>
    <types>
        <members>Create_Project</members>
        <members>Projects</members>
        <name>CustomTab</name>
    </types>
    <types>
        <members>projectCreation</members>
        <name>LightningComponentBundle</name>
    </types>
    <version>60.0</version>
</Package>
```

## Files Included in the Project

### 1. Apex Controller: `ProjectController.cls`
- Handles backend logic for project, milestone, and to-do item creation.

### 2. LWC Bundle: `projectCreation`
- **HTML**: Structure of the project creation form.
- **JavaScript**: Logic for handling form data and navigation.
- **CSS**: Custom styles for the component.

### 3. Custom Tabs
- **Create_Project.tab**: Custom tab for project creation form.
- **Projects.tab**: Custom tab for listing all projects.

### 4. Custom Application
- **Project_Management_App.app**: Custom Salesforce app for managing projects.

## Deployment Instructions

### 1. Ensure Salesforce CLI is installed.

### 2. Authenticate to your Salesforce org:
```sh
sfdx force:auth:web:login
```
### 3. Navigate to the project directory.
### Deploy the project:
```sh
sfdx force:source:deploy -x manifest/package.xml
```
### Conclusion

This document provides a comprehensive overview of the project creation component, detailing design decisions, implementation steps, user instructions, and deployment procedures. The included manifest and deployment instructions ensure that the component can be easily deployed to any Salesforce org.