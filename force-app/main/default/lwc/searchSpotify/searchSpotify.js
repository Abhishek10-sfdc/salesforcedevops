import { LightningElement, track } from 'lwc';
import doSpotifyCallout from '@salesforce/apex/spotifyCalloutController.doSpotifyCallout';
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class SearchSpotify extends LightningElement {
    @track searchTrack = '';
    @track responseObj;
    @track trackData;
    @track trackurl;
    displayResult = false;

    trackInputHandler(event){
        this.searchTrack = event.target.value;
    }

    async searchTrackHandler(event){
        let isInputValidated = this.validateTrack();
            if(isInputValidated){
                try{
                let responseString = await doSpotifyCallout({searchSongKey: this.searchTrack});
                this.responseObj = JSON.parse(responseString);
                this.displayResult = true;
                this.trackData = responseObj.tracks.items[0];
                this.trackurl = this.trackData.album.images[0].url;
                console.error('this.responseObj---->'+this.responseObj);
            }catch{
                console.error('Error occurred');
                this.showToast('Error', 'Something wrong', 'error');
            }
        }else{
            this.showToast('Error', 'Something went wrong.', 'error');
        }
       
    }

    validateTrack(){
        let isValid = true;
        let inputElement = this.template.querySelector('lightning-input');
        if(inputElement.value === '' && !inputElement.checkValidity()){
            inputElement.reportValidity();
            isValid = false;
        }
        return isValid;
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
        title: title,
        message: message,
        variant: variant
        });
        this.dispatchEvent(event);
    }

    get artistName(){
        let artistNameArr = his.trackData.artists.map(item => item.Name);
        let artistNameStr = artistNameArr.join(", ");
        return artistNameStr;
    }
}