import { LightningElement, wire , api, track } from 'lwc';
import getSobjectList from '@salesforce/apex/CustomLookupGenController.getSobjectList';

export default class CustomLookupGenericDemo extends LightningElement {

    @wire(getSobjectList,{objectName:, searchKeyword:})
}