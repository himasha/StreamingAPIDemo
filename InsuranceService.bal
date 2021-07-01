import ballerina/http;

service /insurance on new http:Listener(9098) {

@http:ResourceConfig {
        consumes: ["application/json"]
    }

resource function post rate(@http:Payload json customer )
            returns json | error {

     
 json loanIDAsJson = check customer.event.loanApplicationID;
 string loanID =  loanIDAsJson.toString();          
 int creditScore =  getCreditScore(loanID);
 float insuranceRate = getInsuranceRate(creditScore);
        
json payload = {
  "loanApplicationID" : check customer.event.loanApplicationID,
  "insuranceRate" : insuranceRate
};
return payload;
 }

}

function getCreditScore(string loanID) returns int{

  int creditScore = 0;
// Ideally retrieve a given customer's creditscore from shared storage/service
if(loanID == "1111"){
creditScore = 620;
}
if(loanID == "2222"){
creditScore = 700;
}
if(loanID == "3333"){
 creditScore =660;
}
return creditScore ;
 }

function getInsuranceRate(int creditScore) returns float{
float insuranceRate = 0.0;
if(creditScore == 620){
insuranceRate = 1.2;
}
if(creditScore == 700){
insuranceRate =  0.6;
}
if(creditScore == 660){
insuranceRate = 1;
}
return insuranceRate;
}

