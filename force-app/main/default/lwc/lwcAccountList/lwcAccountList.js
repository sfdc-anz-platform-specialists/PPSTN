import { LightningElement, wire, api } from "lwc";
import getAccounts from "@salesforce/apex/AccountController.getAccountList";
import { refreshApex } from "@salesforce/apex";
import { updateRecord } from "lightning/uiRecordApi";

import { ShowToastEvent } from "lightning/platformShowToastEvent";
import ID_FIELD from "@salesforce/schema/Account.Id";
import NAME_FIELD from "@salesforce/schema/Account.Name";
import WEBSITE_FIELD from "@salesforce/schema/Account.Website";
import TYPE_FIELD from "@salesforce/schema/Account.Type";
import PPSTN_CLIENTID_FIELD from "@salesforce/schema/Account.PPSTN_ClientID__c";
import PPSTN_COR_FIELD from "@salesforce/schema/Account.PPSTN_COR__c";
import PPSTN_LICENSE_TYPE_SF_FIELD from "@salesforce/schema/Account.PPSTN_License_Type_SF__c";


const COLS = [
  { label: "Name", fieldName: "Name", editable: true },
  { label: "PPSTN ClientId", fieldName: "PPSTN_ClientID__c" },
  { label: "PPSTN COR", fieldName: "PPSTN_COR__c",editable:true },
  { label: "PPSTN License", fieldName: "PPSTN_License_Type_SF__c",editable:true }

];

export default class LWCAccountList extends LightningElement {
  @api recordId;
  columns = COLS;
  draftValues = [];

  @wire(getAccounts, {})
  account;

  handleSave(event) {
    const fields = {};
    fields[ID_FIELD.fieldApiName] = event.detail.draftValues[0].Id;
    fields[NAME_FIELD.fieldApiName] = event.detail.draftValues[0].Name;
    fields[WEBSITE_FIELD.fieldApiName] = event.detail.draftValues[0].Website;
    fields[TYPE_FIELD.fieldApiName] = event.detail.draftValues[0].Type;
    fields[PPSTN_CLIENTID_FIELD.fieldApiName] = event.detail.draftValues[0].PPSTN_ClientID__c;
    fields[PPSTN_COR_FIELD.fieldApiName] = event.detail.draftValues[0].PPSTN_COR__c;
    fields[PPSTN_LICENSE_TYPE_SF_FIELD.fieldApiName] = event.detail.draftValues[0].PPSTN_License_Type_SF__c;

    const recordInput = { fields };
    updateRecord(recordInput)
      .then(() => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Success",
            message: "Client updated",
            variant: "success"
          })
        );
        // Display fresh data in the datatable
        return refreshApex(this.account).then(() => {
          // Clear all draft values in the datatable
          this.draftValues = [];
        });
      })
      .catch((error) => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Error updating or reloading record",
            message: error.body.message,
            variant: "error"
          })
        );
      });
  }
}