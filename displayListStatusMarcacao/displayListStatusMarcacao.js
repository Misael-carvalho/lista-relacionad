import { LightningElement, wire, api } from 'lwc';
import  lstMarcacao  from '@salesforce/apex/StatusMarcacaoBO.lstMarcacao';

const columns = [
    { label: 'Nro Premarcação', fieldName: 'NumeroPreMarcacao__c', hideDefaultActions: true},
    { label: 'Transportadora', fieldName: 'Transportadora__c' , hideDefaultActions: true },
    { label: 'Placa', fieldName: 'Placa__c', hideDefaultActions: true },
    { label: 'Motorista', fieldName: 'Motorista__c', hideDefaultActions: true },
    { label: 'Status de Marcação', fieldName: 'StatusMarcacao__c', hideDefaultActions: true  },
    { label: 'Data do Status', fieldName: 'DatadoStatus__c', hideDefaultActions: true  },
    { label: 'Destinatário', fieldName: 'Destinatario__c', hideDefaultActions: true  },
    { label: 'Quantidade Prevista', fieldName: 'QuantidadePrevista__c', hideDefaultActions: true  },
];

export default class DisplayListStatusMarcacao extends LightningElement {
    @api recordId;
    error;
    records = [];
    columns = columns;

    get hasRecords(){
        return this.records && this.records.length > 0 ? true : false;
    }

    @wire(lstMarcacao, {
        orderItemId: "$recordId"
    })listInfo({ error, data }) {
        console.log(JSON.stringify(error), JSON.stringify(data));
        if (data) {
            this.records = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.records = [];
        }
    }
}