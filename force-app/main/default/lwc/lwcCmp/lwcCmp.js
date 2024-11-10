import { LightningElement, api } from 'lwc';

export default class LwcCmp extends LightningElement {
    @api msg = 'You are viewing a Salesforce hosted LWC.';

    userSaysHi() {
        // eslint-disable-next-line no-alert
        alert("Hi, I'm LWC... its a pleasure to meet you!");
    }
}