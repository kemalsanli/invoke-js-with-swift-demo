/* Injecting  |--====---          */

function getUserProfilePicture() {
    const profilePictureUrl = document.getElementsByClassName("avatar avatar-user width-full border color-bg-default")[0].currentSrc;
    toSwift(profilePictureUrl);
}

function getHostname() {
    const host = document.location.host ;
    toSwift(host);
}

function toSwift(string) {
    window.webkit.messageHandlers.someNameThatIsNotImportant.postMessage(string);
}
