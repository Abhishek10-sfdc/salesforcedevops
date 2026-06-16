import { LightningElement, wire, track, api } from 'lwc';
import searchLookupRecord from '@salesforce/apex/customLookupController.searchLookupRecord'
const DELAY = 400;
export default class CustomLookupGenericCmp extends LightningElement {

    @api objectName;
    @track searchValue;
    @track lookupData = [];
    @api objectLabel;
    @api objectIcon;
    @track timeOutDelay;
    @track selectedOutputRec = {
        selectedRecId: '',
        selectedRecName: ''
    }
    @track showLookupList = true;

    @wire(searchLookupRecord, {objectApiName:"$objectName", searchKey:"$searchValue"})
    lookupOutput({data,error}){
        if(data){
            this.lookupData= data;
        }
        if(error){
            console.error(error);
        }
    }

    inputHandler(event){
        window.clearTimeout(this.timeOutDelay);
        let searchVal = event.target.value;
        this.timeOutDelay = setTimeout(() => {
            this.searchValue = searchVal;
            this.showLookupList = true;
        }, DELAY)
    }

    selectHandler(event){
        let selectedId = event.currentTarget.dataset.item;
        // `event.currentTarget` | The element **with the event handler**            
        // `event.target`        | The element that **actually triggered** the event |

        let selectedRec = this.lookupData.find(rec => rec.Id === selectedId);
        this.selectedOutputRec = {
            selectedRecId: selectedRec.Id,
            selectedRecName: selectedRec.Name
        }
        this.showLookupList = false;
    }

    get showLookupOutput(){
        return this.selectedOutputRec.selectedRecId == '' ? false : true;
    }

    removeHandler(event){
        this.selectedOutputRec = {
            selectedRecId: '',
            selectedRecName: ''
        }
        this.showLookupList = true;
        this.searchValue = '';
    }
}