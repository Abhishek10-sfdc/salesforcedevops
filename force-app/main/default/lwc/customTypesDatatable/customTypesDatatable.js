import { LightningElement } from 'lwc';
import LightningDatatable from "lightning/datatable";
import customNameTemplate from './customName.html';
import customRankTemplate from './customRank.html';
import customImageTemplate from './customImage.html';

export default class CustomTypesDatatable extends LightningDatatable  {
    static customTypes = {
        customNameType:{
            template: customNameTemplate,
            standardCellLayout: true,
            typeAttributes: ["accountName"],
        },
        customRankType:{
            template: customRankTemplate,
            standardCellLayout: false,
            typeAttributes: ["rankIcon"],
        },
        customImageType:{
            template: customImageTemplate,
            standardCellLayout: true,
            typeAttributes: ["imageUrl"],
        }
    }
}