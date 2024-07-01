public with sharing class ProjectController {
    @AuraEnabled
    public static Project__c createProjectData(String projectName, String milestonesJSON) {
        System.debug('Project Name: ' + projectName);
        System.debug('milestonesJSON: ' + milestonesJSON);

        if (String.isBlank(projectName)) {
            throw new AuraHandledException('Project name cannot be blank.');
        }

        if (String.isBlank(milestonesJSON)) {
            throw new AuraHandledException('Milestones cannot be null or empty.');
        }

        List<MilestoneWrapper> milestones = (List<MilestoneWrapper>) JSON.deserialize(milestonesJSON, List<MilestoneWrapper>.class);
        System.debug('Deserialized Milestones: ' + milestones);

        Project__c project = new Project__c(Name = projectName);
        insert project;

        List<Milestone__c> milestoneRecords = new List<Milestone__c>();
        List<To_Do_Item__c> toDoRecords = new List<To_Do_Item__c>();

        for (MilestoneWrapper mw : milestones) {
            System.debug('Milestone Wrapper: ' + mw);
            if (String.isBlank(mw.name)) {
                throw new AuraHandledException('Milestone name cannot be blank.');
            }

            Milestone__c milestone = new Milestone__c(Name = mw.name, Project__c = project.Id);
            milestoneRecords.add(milestone);
        }

        insert milestoneRecords;

        for (Integer i = 0; i < milestoneRecords.size(); i++) {
            MilestoneWrapper mw = milestones[i];
            Milestone__c milestone = milestoneRecords[i];

            if (mw.toDos != null) {
                for (ToDoWrapper tdw : mw.toDos) {
                    System.debug('To-Do Wrapper: ' + tdw);
                    if (String.isBlank(tdw.name)) {
                        throw new AuraHandledException('To-Do item name cannot be blank.');
                    }

                    To_Do_Item__c toDo = new To_Do_Item__c(Name = tdw.name, Milestone__c = milestone.Id, Status__c = tdw.status);
                    toDoRecords.add(toDo);
                }
            }
        }

        insert toDoRecords;

        return project;
    }

    public class MilestoneWrapper {
        @AuraEnabled public String name;
        @AuraEnabled public List<ToDoWrapper> toDos;
    }

    public class ToDoWrapper {
        @AuraEnabled public String name;
        @AuraEnabled public String status;
    }
}