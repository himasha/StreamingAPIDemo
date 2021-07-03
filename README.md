# StreamingAPIDemo
In the following use-case, a typical bank that has partnered with an insurance provider through Open Finance concepts, exposes a managed WebSocket API using WSO2 API Manager. The subscribers of this API can receive approved loan requests that require mortgage insurance, with bundled mortgage insurance quotes specific to each borrower. This would allow the bank employees to streamline the loan approval process and present the borrowers with seamless housing loans plus insurance policies.

![Open Finance - GitDG](https://user-images.githubusercontent.com/9687840/123907431-80d82180-d993-11eb-9b50-d93e8b509817.png)

# Prerequisites
1. Download WSO2 API Manager 4.0(Zip archive) from https://wso2.com/api-manager/#
2. Download WSO2 Streaming Integrator 4.0 listed under 'Other components' of https://wso2.com/api-manager/#
3. Dowloand the Streaming Integrator tooling from https://wso2.com/integration/streaming-integrator/
4. Follow the prerequisites of https://apim.docs.wso2.com/en/latest/use-cases/streaming-tutorials/expose-a-kafka-topic-as-a-managed-websocket-api/#prerequisites to download and install Kafka, setting port offsets in API Manager, enabling service catalog in Streaming Integrator and finally starting up all the servers.
5. Extract the Streaming Integrator Tooling pack to a preferred location. Hereafter, the extracted location is referred to as <SI_TOOLING_HOME>.

   Navigate to the <SI_TOOLING_HOME>/bin directory and issue the appropriate command depending on your operating system to start the Streaming Integration tooling.

      For Windows: tooling.bat

      For Linux/MacOS: ./tooling.sh

Access the Streaming Integration Tooling via the http://<HOST_NAME>:<TOOLING_PORT>/editor URL.
6. Open the deployment.toml file of WSO2 API Manager and update the port(s) of the websocket server endpoints with below port numbers. This is assuming that the port offset for API Manager was set to '5' as listed in step 4.   
    
    ws_endpoint = "ws://localhost:9104"
    wss_endpoint = "wss://localhost:8104"
    
7. Run the sample Insurance backendservice(InsuranceService.bal) in Ballerina . (https://ballerina.io/1.0/learn/how-to-deploy-and-run-ballerina-programs/#running-standalone-source-code) 

# Deploying Artifacts
 1. Open Streaming Integrator tooling and import (or create new with following content) 'HomeLoanRequestApp.siddhi' and 'PMIQuoteProviderApp.siddhi'.
 2. Go to 'Deploy' -> 'Deploy to Server'.
 3. Add a new server representing your Streaming Integrator server (Following are the default vaules such as Host:localhost,HTTPS Port:9443,User Name/Password)
 4. Deploy above siddhi apps to the created server. 
 When service catalog feature is enabled through Prerequisites step 4, the deployed Siddhi App with Async API specification will be automatically made available in WSO2 API Manager. 
 
 # Creating a managed Websocket API
 1. Log into WSO2 API Manager publisher portal and go to 'Services' tab and you should be able to view your developed service listed. Click on the + icon to create a managed Websocket API out of it like below. 
 <img width="1071" alt="SC" src="https://user-images.githubusercontent.com/9687840/123909248-589df200-d996-11eb-9ea9-3fdfc02b133d.png">
 2. Go to 'Subscriptions' section of the API Publisher and attach required subscription policies specyfing the number of events etc.
 3. Go to 'Topics' section of the API Publisher click on the 'Insurance' topic and under 'URL Mapping' add '/insurance'. 
 4. Go to 'Deployments' section and deploy a new revision.
 5. Go to 'Lifecycle' section of the API publisher and 'publish' the API.

# Try it out
1. Log in to API Developer portal and subscribe to the published API by creating an application and generating a token under production.
2. Install  wscat client. (npm install -g wscat)
3. Connect to the Websocket API similar to below. Make sure that the context you list is the API context that was provided when creating the API. 
    
      wscat -c ws://localhost:9104/quote/insurance/1.0.0 -H "Authorization: Bearer [accesstoken]" 
    
    <img width="1438" alt="Screen Shot 2021-06-28 at 10 40 06 AM" src="https://user-images.githubusercontent.com/9687840/123910334-ecbc8900-d997-11eb-9b3c-1362d814fc34.png">

4.To run the Kafka command line client, issue the following command from the <KAFKA_HOME> directory.

    bin/kafka-console-producer.sh --broker-list localhost:9092 --topic loan_request_topic
    
5. In the same terminal, publish events similar to below format. (Please note that PMI quotes will be provided only to loan requests with less than 20% down payment from the house value ). Make sure the backend service (InsuranceService.bal) has the necessary values as credit scores/insurance rates are hardcoded.

    {"event":{ "loanAppID":"1111", "customerID":"81454", "houseValue":10000, "downPayment":50}}
    

6. Once events are published to first Kafka topic you can view following output through the subscribed Websocket API.

<img width="1435" alt="Screen Shot 2021-06-28 at 10 42 01 AM" src="https://user-images.githubusercontent.com/9687840/123910810-9734ac00-d998-11eb-8432-005b5ad0c129.png">



