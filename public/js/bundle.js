(function(){'use strict';function randomNumber(min, max) {
    return Math.random() * (max - min) + min;
}let texts = [
    "étudiant en informatique.",
    "développeur web."
];
let currentText = "";
let currentPos = 0;

function main() {
    setTimeout(eraseText, randomNumber(2000, 3500));
}

function writeText(){
    let iAmA = document.getElementById("i-am-a");
    if(!currentText || currentText.length <= 0){
        if(++currentPos >= texts.length){
            currentPos = 0;
        }
        currentText = texts[currentPos];
    }
    iAmA.innerText += currentText.charAt(0);
    currentText = currentText.slice(1);
    if(currentText.length <= 0){
        setTimeout(eraseText, randomNumber(2000, 3500));
    } else {
        setTimeout(writeText, randomNumber(50, 100));
    }
}

function eraseText(){
    let iAmA = document.getElementById("i-am-a");
    if(iAmA.innerText.length > 0){
        iAmA.innerText = iAmA.innerText.slice(0, -1);
        setTimeout(eraseText, randomNumber(50, 100));
    } else {
        setTimeout(writeText, randomNumber(1000, 1500));
    }
}

window.onload = main;}());