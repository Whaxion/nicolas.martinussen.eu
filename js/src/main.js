import {randomNumber} from "./utils";

let currentText = "";
let currentPos = 0;

function main() {
    setTimeout(eraseText, randomNumber(2000, 3500));
}

function writeText(){
    let textWriting = document.getElementById("text-writing");
    if(!currentText || currentText.length <= 0){
        if(++currentPos >= texts.length){
            currentPos = 0;
        }
        currentText = texts[currentPos];
    }
    textWriting.innerText += currentText.charAt(0);
    currentText = currentText.slice(1);
    if(currentText.length <= 0){
        setTimeout(eraseText, randomNumber(2000, 3500));
    } else {
        setTimeout(writeText, randomNumber(50, 100));
    }
}

function eraseText(){
    let textWriting = document.getElementById("text-writing");
    if(textWriting.innerText.length > 0){
        textWriting.innerText = textWriting.innerText.slice(0, -1);
        setTimeout(eraseText, randomNumber(50, 100));
    } else {
        let time = timeBeforeWriting;
        if(time == -1){
            time = randomNumber(1000, 1500);
        }
        setTimeout(writeText, time);
    }
}

window.onload = main;
