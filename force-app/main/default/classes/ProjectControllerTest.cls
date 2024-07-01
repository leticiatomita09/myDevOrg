@isTest
public class ProjectControllerTest {
    @isTest
    static void testCreateProjectData() {
        // Setup test data
        String projectName = 'Test Project';
        List<ProjectController.MilestoneWrapper> milestones = new List<ProjectController.MilestoneWrapper>();

        ProjectController.MilestoneWrapper milestone1 = new ProjectController.MilestoneWrapper();
        milestone1.name = 'Milestone 1';
        milestone1.toDos = new List<ProjectController.ToDoWrapper>();
        ProjectController.ToDoWrapper toDo1 = new ProjectController.ToDoWrapper();
        toDo1.name = 'Task 1';
        toDo1.status = 'Not Started';
        milestone1.toDos.add(toDo1);

        ProjectController.MilestoneWrapper milestone2 = new ProjectController.MilestoneWrapper();
        milestone2.name = 'Milestone 2';
        milestone2.toDos = new List<ProjectController.ToDoWrapper>();
        ProjectController.ToDoWrapper toDo2 = new ProjectController.ToDoWrapper();
        toDo2.name = 'Task 2';
        toDo2.status = 'In Progress';
        milestone2.toDos.add(toDo2);

        milestones.add(milestone1);
        milestones.add(milestone2);

        String milestonesJSON = JSON.serialize(milestones);

        // Test the method
        Test.startTest();
        Project__c createdProject = ProjectController.createProjectData(projectName, milestonesJSON);
        Test.stopTest();

        // Verify the results
        System.assertNotEquals(null, createdProject, 'Project should be created');
        System.assertEquals(projectName, createdProject.Name, 'Project name should match');

        List<Milestone__c> milestoneRecords = [SELECT Id, Name, Project__c FROM Milestone__c WHERE Project__c = :createdProject.Id];
        System.assertEquals(2, milestoneRecords.size(), 'There should be 2 milestones');

        List<To_Do_Item__c> toDoRecords = [SELECT Id, Name, Milestone__c, Status__c FROM To_Do_Item__c WHERE Milestone__c IN :milestoneRecords];
        System.assertEquals(2, toDoRecords.size(), 'There should be 2 to-do items');
    }

    @isTest
    static void testCreateProjectDataWithBlankName() {
        String projectName = '';
        String milestonesJSON = '[{"name":"Milestone 1","toDos":[{"name":"Task 1","status":"Not Started"}]}]';

        // Test the method and expect an exception
        try {
            Test.startTest();
            ProjectController.createProjectData(projectName, milestonesJSON);
            Test.stopTest();
            System.assert(false, 'Expected an exception to be thrown due to blank project name');
        } catch (AuraHandledException e) {
            System.assertEquals('Project name cannot be blank.', e.getMessage(), 'Expected exception message for blank project name');
        } catch (Exception e) {
            System.assert(false, 'Expected an AuraHandledException, but got: ' + e.getMessage());
        }
    }

    @isTest
    static void testCreateProjectDataWithBlankMilestoneName() {
        String projectName = 'Test Project';
        String milestonesJSON = '[{"name":"","toDos":[{"name":"Task 1","status":"Not Started"}]}]';

        // Test the method and expect an exception
        try {
            Test.startTest();
            ProjectController.createProjectData(projectName, milestonesJSON);
            Test.stopTest();
            System.assert(false, 'Expected an exception to be thrown due to blank milestone name');
        } catch (AuraHandledException e) {
            System.assertEquals('Milestone name cannot be blank.', e.getMessage(), 'Expected exception message for blank milestone name');
        } catch (Exception e) {
            System.assert(false, 'Expected an AuraHandledException, but got: ' + e.getMessage());
        }
    }

    @isTest
    static void testCreateProjectDataWithBlankToDoName() {
        String projectName = 'Test Project';
        String milestonesJSON = '[{"name":"Milestone 1","toDos":[{"name":"","status":"Not Started"}]}]';

        // Test the method and expect an exception
        try {
            Test.startTest();
            ProjectController.createProjectData(projectName, milestonesJSON);
            Test.stopTest();
            System.assert(false, 'Expected an exception to be thrown due to blank to-do name');
        } catch (AuraHandledException e) {
            System.assertEquals('To-Do item name cannot be blank.', e.getMessage(), 'Expected exception message for blank to-do name');
        } catch (Exception e) {
            System.assert(false, 'Expected an AuraHandledException, but got: ' + e.getMessage());
        }
    }
}
