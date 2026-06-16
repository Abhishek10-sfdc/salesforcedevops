import { LightningElement, wire, track, api } from 'lwc';
import getContactList from '@salesforce/apex/contactController.getContactList';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';
import { refreshApex } from '@salesforce/apex';
const columns = [
    { label: 'First Name', fieldName: 'FirstName', type: 'text' },
    { label: 'Last Name', fieldName: 'LastName', type: 'text' },
    { label: 'Email', fieldName: 'Email', type: 'email' },
    { label: 'Gender', fieldName: 'GenderIdentity', type: 'text' },
    { label: 'End Date', fieldName: 'End_Date__c', type: 'date'}
];

export default class PlatformEventRefreshDatatable extends LightningElement {
    columns = columns;
    @track contactData = [];
    @track wiredContactResult
    @api recordId;
    channelName = '/event/RefreshDatatableEvt__e';
    subscription = null;

    connectedCallback(){
        this.subscribeToEvent();
        const sayHello = (name) => {
            console.log('Hello',name())
        };

        const world  =() => {
            console.log('World')
        };
        sayHello(world());
    }

    //-1 → Receive new events only
    //handleEvent → Callback method when an event is received
    subscribeToEvent(){
        subscribe(this.channelName, -1, this.handleEvent)
        .then(response=>{
            this.subscription = response;
        });
    }

    handleEvent = event => {
        const refreshRecEvent = event.data.payload;
        if(refreshRecEvent.AccountRecId__c == this.recordId && refreshRecEvent.EndDateChanged__c){
            refreshApex(this.wiredContactResult);
        }
    }

    disconnectedCallback() {
        unsubscribe(this.subscription, () => {});
    }

    @wire(getContactList, {accId : '$recordId'})
    getConData(result){
        this.wiredContactResult = result;
        if(result.data){
            this.contactData=result.data;
        }
        if(result.error){
            console.log(result.error);
        }
    }


}