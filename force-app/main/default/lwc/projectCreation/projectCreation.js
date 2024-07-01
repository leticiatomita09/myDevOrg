import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createProjectData from '@salesforce/apex/ProjectController.createProjectData';

export default class ProjectCreation extends LightningElement {
    @track projectName = '';
    @track milestones = [];
    @track currentStep = '1';
    @track isLoading = false;

    statusOptions = [
        { label: 'Not Started', value: 'Not Started' },
        { label: 'In Progress', value: 'In Progress' },
        { label: 'Complete', value: 'Complete' }
    ];

    get isProjectStep() {
        return this.currentStep === '1';
    }

    get isMilestonesToDoStep() {
        return this.currentStep === '2';
    }

    get isReviewStep() {
        return this.currentStep === '3';
    }

    get isProjectNameEmpty() {
        return !this.projectName.trim();
    }

    get areMilestonesIncomplete() {
        return this.milestones.some(milestone => !milestone.name.trim() || milestone.toDos.some(toDo => !toDo.name.trim() || !toDo.status));
    }

    handleProjectNameChange(event) {
        this.projectName = event.target.value;
    }

    handleMilestoneChange(event) {
        const id = event.target.dataset.id;
        const milestone = this.milestones.find(milestone => milestone.id === id);
        if (milestone) {
            milestone.name = event.target.value;
        }
    }

    handleToDoChange(event) {
        const milestoneId = event.target.dataset.milestoneId;
        const toDoId = event.target.dataset.todoId;
        const milestone = this.milestones.find(milestone => milestone.id === milestoneId);
        if (milestone) {
            const toDo = milestone.toDos.find(toDo => toDo.id === toDoId);
            if (toDo) {
                toDo.name = event.target.value;
            }
        }
    }

    handleToDoStatusChange(event) {
        const milestoneId = event.target.dataset.milestoneId;
        const toDoId = event.target.dataset.todoId;
        const milestone = this.milestones.find(milestone => milestone.id === milestoneId);
        if (milestone) {
            const toDo = milestone.toDos.find(toDo => toDo.id === toDoId);
            if (toDo) {
                toDo.status = event.detail.value;
            }
        }
    }

    addMilestone() {
        const id = `milestone-${Date.now()}`;
        this.milestones.push({ id, name: '', toDos: [] });
    }

    addToDo(event) {
        const milestoneId = event.target.dataset.id;
        const milestone = this.milestones.find(milestone => milestone.id === milestoneId);
        if (milestone) {
            const toDoId = `todo-${Date.now()}`;
            milestone.toDos.push({ id: toDoId, name: '', status: 'Not Started' });
        }
    }

    goToNextStep() {
        if (this.currentStep === '1' && !this.isProjectNameEmpty) {
            this.currentStep = '2';
        } else if (this.currentStep === '2' && !this.areMilestonesIncomplete) {
            this.currentStep = '3';
        }
    }

    goToPreviousStep() {
        if (this.currentStep === '3') {
            this.currentStep = '2';
        } else if (this.currentStep === '2') {
            this.currentStep = '1';
        }
    }

    handleCreate() {
        if (!this.projectName.trim()) {
            console.error('Project name cannot be blank');
            return;
        }
        this.isLoading = true;

        const milestoneData = this.milestones.map(milestone => ({
            name: milestone.name.trim() || 'Unnamed Milestone',
            toDos: milestone.toDos.map(toDo => ({
                name: toDo.name.trim() || 'Unnamed To-Do',
                status: toDo.status
            }))
        }));

        createProjectData({ 
            projectName: this.projectName.trim(), 
            milestonesJSON: JSON.stringify(milestoneData)
        })
        .then(result => {
            console.log('Project created:', result);
            this.projectName = '';
            this.milestones = [];
            this.currentStep = '1';

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Project created successfully',
                    variant: 'success'
                })
            );
        })
        .catch(error => {
            console.error('Error creating records:', error);

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Error creating project',
                    variant: 'error'
                })
            );
        })
        .finally(() => {
            this.isLoading = false;
        });
    }
}