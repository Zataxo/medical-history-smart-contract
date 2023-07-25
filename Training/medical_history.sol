// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./utils.sol";
contract MedicalHistory {
    // event for tracking patient status
    event TrackPatient(string _message);
    event UpdatingData(string _message);
    // patient struct
    struct Patient{
        PatientStatus status;
        address pAddress;
        string name;
        uint age;
        string[] conditions;
        string[] allergies;
        string[] medications;
        string[] procedures;
    }
    mapping (address=> Patient) public patients;
    // restricting updating data to only patient who created it
    modifier onlyPatientCanUpdated(address _msgSender) {
        Patient memory patient = patients[_msgSender];
        require(patient.age != 0,"Other patient can not modify others");
        _;
    }

    // Create new patient
    function createPatient(
        string calldata _name,
        uint _age,
        string[] calldata _conditions,
        string[] calldata _allergies,
        string[] calldata _medications,
        string[] calldata _procedures) external {
            Patient memory patient = Patient({
                status:PatientStatus.waiting,
                pAddress:msg.sender,
                name:_name,
                age:_age,
                conditions:_conditions,
                allergies:_allergies,
                medications:_medications,
                procedures:_procedures
            });
            patients[msg.sender] = patient;

        }
    // update patient data
    function updatePatientData(
        string[] memory _conditions,
        string[] memory _allergies,
        string[] memory _medications,
        string[] memory _procedures
    ) external 
     onlyPatientCanUpdated(msg.sender) 
     {
        
        Patient storage patient = patients[msg.sender];
        patient.conditions = _conditions;
        patient.allergies = _allergies;
        patient.medications = _medications;
        patient.procedures = _procedures;

        emit UpdatingData("Patient Updated his Data");
       
    }
    // patien enter to doctor
    function patientEntrance() external  onlyPatientCanUpdated(msg.sender){
        Patient storage patient = patients[msg.sender];

        patient.status = PatientStatus.treating;

        emit TrackPatient("Patient Status Changed : Trating");

    }
    // patien finished 
    function finishTreatment() external  onlyPatientCanUpdated(msg.sender){
        Patient storage patient = patients[msg.sender];

        patient.status = PatientStatus.finished;

        emit TrackPatient("Patient Status Changed : Finished");

    }
    // get patient data
    function getPatientData(address _patientAddress) external view returns (
        string memory,
        address ,
        string memory ,
        uint age,
        string[] memory ,
        string[] memory ,
        string[] memory ,
        string[] memory )
        {
            Patient memory patient = patients[_patientAddress];

            return(Utils.getEnumValue(patient.status),patient.pAddress,patient.name,patient.age,
            patient.conditions,patient.allergies,patient.medications,
            patient.procedures);

        }
}