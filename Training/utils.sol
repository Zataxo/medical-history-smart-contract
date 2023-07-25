// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;   
enum PatientStatus{
    waiting,
    treating,
    finished
}
library Utils {
function getEnumValue(PatientStatus _value) external pure returns (string memory){
    
    return uint(_value) == 0?"Waiting":uint(_value) == 1?"Treating":"Finished";
}
}