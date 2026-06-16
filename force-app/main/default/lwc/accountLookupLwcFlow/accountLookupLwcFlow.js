import { LightningElement, api, track } from 'lwc';
import ACCOUNTTYE_FIELD from '@salesforce/schema/Account.Account_Type__c'
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';

export default class AccountLookupLwcFlow extends LightningElement {

    @api reByAccType='';
    @api selectedAccountId='';

    get filterValue(){
        return {
            criteria: [
                {
                    fieldPath: 'Account_Type__c',
                    operator: 'eq',
                    value: this.reByAccType
                }
            ]
        };
    }

    handleChange(event){
        this.selectedAccountId = event.detail.recordId;

        let attChangeEvt = new FlowAttributeChangeEvent('selectedAccountId',this.selectedAccountId);
        this.dispatchEvent(attChangeEvt);
    }
}