import { LightningElement, api } from 'lwc';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';

export default class CalculatorLwcInFlow extends LightningElement {

    @api inputNumber1 = '';
    @api inputNumber2 = '';
    @api outputResult = '';

    calculateHandler(event){
        let operationName = event.target.name;
        if(operationName === 'add'){
            this.outputResult = Number(this.inputNumber1) + Number(this.inputNumber2);
        }else if(operationName === 'sub'){
            this.outputResult = Number(this.inputNumber1) - Number(this.inputNumber2);
        }else if(operationName === 'mul'){
            this.outputResult = Number(this.inputNumber1) * Number(this.inputNumber2);
        }else if(operationName === 'div'){
            this.outputResult = Number(this.inputNumber1) / Number(this.inputNumber2);
        }

        let attributeChangeEvent = new FlowAttributeChangeEvent('outputResult', this.outputResult);
        this.dispatchEvent(attributeChangeEvent);
    }

}