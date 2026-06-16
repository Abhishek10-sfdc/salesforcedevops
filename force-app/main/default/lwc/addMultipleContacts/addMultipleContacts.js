import { LightningElement, wire, track, api } from 'lwc';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import GENDERIDENTITY_FIELD from '@salesforce/schema/Contact.GenderIdentity';
import { ShowToastEvent  } from 'lightning/platformShowToastEvent';
import createContacts from '@salesforce/apex/addMultipleContactController.createContacts';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class AddMultipleContacts extends LightningElement {

    @track contacts = [];
    @api recordId;

    connectedCallback(){
        this.addContactHandler();
    }

    @wire(getObjectInfo,{ objectApiName: CONTACT_OBJECT })
    contactObjectInfo;

    @wire(getPicklistValues, { recordTypeId: '$contactObjectInfo.data.defaultRecordTypeId', fieldApiName: GENDERIDENTITY_FIELD})
    genderIdentityFieldData;

    get genderIdentityOptions(){
        return this.genderIdentityFieldData?.data?.values;
    }

    addContactHandler(event){
        this.contacts.push({
            tempId: Date.now()
        });
    }

    deleteHandler(event){
        if(this.contacts.length == 1){
            this.showToast('Error',`Last Contact can't be removed`,'error');
            return;
        }
        let tempConId= event.target?.dataset.tempId;
        this.contacts = this.contacts.filter(item => item.tempId != tempConId)
    }

    inputHandler(event){
        let tempConId= event.target?.dataset.tempId;
        let conRecRow = this.contacts.find(item => item.tempId == tempConId);
        conRecRow[event.target.name] = event.target.value;
        console.log(JSON.stringify(this.contacts))
    }

    showToast(title,message,mode){
        const evt=new ShowToastEvent ({
            title,
            message,
            mode
        });
        this.dispatchEvent(evt);
    }

    async submitHandler(event){
        let isSubmitAllowed = this.inputValidationHandler();
        if(isSubmitAllowed){
            this.contacts = this.contacts.map(item => {
                return {
                    ...item,
                    AccountId: this.recordId
                };
            });
            let responseData = await createContacts({conList:this.contacts})
            if(responseData.isSuccess){
                this.showToast('Success','Contacts added successfully','success');
                this.dispatchEvent(new CloseActionScreenEvent());
            }else{
                this.showToast('Error',responseData.errorMessage,'error');
            }
        }else{
            this.showToast('Error','Please check the errors before proceeding','error');
        }
    }

    inputValidationHandler(){
        let isValid = true;
        let allInput = this.template.querySelectorAll('lightning-input , lightning-combobox');
        allInput.forEach(input => {
            if(!input.checkValidity()){
                isValid = false;
                input.reportValidity();
            }
        });
        return isValid;
    }
}
