import { LightningElement, api } from 'lwc';

export default class LwcClientlow extends LightningElement {
    @api msg = 'Salesforce Flow invoked by LWC.';
}