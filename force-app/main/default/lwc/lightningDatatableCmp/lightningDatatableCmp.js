import { LightningElement, wire } from 'lwc';
import getContactList from '@salesforce/apex/DatatableController.getContactList'
const columns = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Account Name', fieldName: 'accountName',type: 'customNameType', typeAttributes:{
            accountName: {
                fieldName:'accountName'}
    }},
    { label: 'Title', fieldName: 'Title', cellAttributes:{
        class:{
            fieldName: 'titleColor'
        }
    }},
    { label: 'Rank', fieldName: 'Rank__c', type: 'customRankType', 
        typeAttributes:{
            rankIcon : {
                fieldName:'rankIcon'
            }
        }
     },
    { label: 'Phone', fieldName: 'Phone', type: 'tel' },
    { label: 'Email', fieldName: 'Email', type: 'email' },
    { label: 'Company', fieldName: 'Company__c', type: 'customImageType', 
        typeAttributes:{
            imageUrl : {
                fieldName: 'Company__c'
            }
        },
        cellAttributes:{
            class: 'slds-text-align_center'
        }
     }
];

export default class LightningDatatableCmp extends LightningElement {
    columns = columns;
    contactData = [];

    @wire(getContactList)
    conData({data,error}){
        if(data){
            //this.contactData = data;
            console.log('Number(true)'+Number(true));
            console.log('Number(false)'+Number(false));
            console.log('Number([]])'+Number([]));
            console.log('Number(undefined)'+Number(undefined));
            this.contactData = data.map(item => {
                let accountName = item.Account.Name;
                let accountLink = "/"+item.AccountId;
                let titleColor = "slds-text-color_success";
                let rankIcon = item.Rank__c > 7 ? 'utility:connected_apps' : 'utility:connected_apps'
                return {...item, accountName, accountLink, titleColor, rankIcon}
            })
        }
        if(error){
            console.error(error);
        }
    }
}