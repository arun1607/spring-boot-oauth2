#### Overview 

Sample application to demonstrate OAuth2 authentication using spring boot. This POC uses H2 as database to store user 
credentials.

The secured resource is single end point which returns currently authenticated user details.

This application uses JWT with asymmetric encryption. The auth server uses private key to sign the JWT and

resource server uses public key to decrypt it and read authorities.

The access token expiry time is configured in database script. It can be changed in script.

##### Running the application

1. Generate keystore and associated public key using following command. It will put the required files in appropriate 
locations in auth server and resource server. 

    `./crypto_generator.sh`

2. Build required jars by running following command 

    `mvn package`
    
3. Start auth server using below command. It will start the server on port 8085

    `java -jar auth-server/target/auth-server-1.0.0.jar`
    
4. Start user api using below command. It will start the server on port 8090

    ` java -jar user-api/target/user-api-1.0.0.jar`
    
5. Get new access token by using below command
    
    `curl -u clientId:secret -X POST localhost:8085/oauth/token\?grant_type=password\&username=user\&password=pass`
    
    The above command should output something like below
    ```text
    {
        "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1NTc0OTM3ODgsInVzZXJfbmFtZSI6InVzZXIiLCJhdXRob3JpdGllcyI6WyJST0xFX1VTRVIiXSwianRpIjoiOWMzODA5N2MtYTUxZC00Y2IzLThiYWMtNThiYjJkMGRhYzJhIiwiY2xpZW50X2lkIjoiY2xpZW50SWQiLCJzY29wZSI6WyJyZWFkIiwid3JpdGUiXX0.ctkJw0OmtLc-Pegsz-AQvP6fhKU2nTbRz9dO2cipp5jM1DvaSaRqKNWWc3z_2tnCYhOImiAevI3PSZE3fR9ZAyvdGTYqDSXh_oCAcQ-IzK9KzZW64KHH6pNOevzbSW0qeYwBdD3PuU1g40UUlntyNUGeXcgcktK5rWyAOEp_cuII9-AEOSf2awjC-hCi2vqdMgnrs6mTKKU8jMO0hfCSJQrV1G4AWyQPMSNSKDb_d4Y4P72B8jixTXNT-aR4Vbh1jErcHVHB_GCwoDGhQoLExNnzplNp3DOy0VA8Ah_2xqBkYTpLF4Pwc8q51sIAn7LVocEvmreP89d6iQhqmelGHw",
        "expires_in": 299,
        "jti": "9c38097c-a51d-4cb3-8bac-58bb2d0dac2a",
        "refresh_token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX25hbWUiOiJ1c2VyIiwic2NvcGUiOlsicmVhZCIsIndyaXRlIl0sImF0aSI6IjljMzgwOTdjLWE1MWQtNGNiMy04YmFjLTU4YmIyZDBkYWMyYSIsImV4cCI6MTU2MDA4NTQ4OCwiYXV0aG9yaXRpZXMiOlsiUk9MRV9VU0VSIl0sImp0aSI6IjMwOTllOTk2LWNkZjUtNDFhNy1iZGJlLTllOTgzNGZkMzgxYyIsImNsaWVudF9pZCI6ImNsaWVudElkIn0.p3PzCg32NMK2MJZFoCBhdt_s3qtXrRB5jVqVqKpssZ2PM5W2KCD0kswbCR1_4lqxSPRR-QVBxeqBBPU2ZAerDIV-1RGeOFlAm8XQkCjAm1UWN1wNW3piA0nNqfeku2a2XdlX6nL1Yv507-MmQ_cwrCFNkI-3zD_qzw9DYoZQGn6VS8x4K48xEOW5fFxrhA803_PCju6ooJlbFqsXhGrvPlS5Exv-XoXuCsfqqPUf7EDrp5ebvZkpOKVenuzEda5Mryf2FBib5IekoPnJ0S3FSFYneGZQWDQROY85x7LcH-vbeo5c1aEbzDkz-mgHZv38aOo2EO2Hig8wGOrmWzI9KQ",
        "scope": "read write",
        "token_type": "bearer"
    }
    ```
    
6. Use the above generated access token to access user api resource as shown below

    `http GET localhost:8090/me 'Authorization:Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1NTc0OTQxNTQsInVzZXJfbmFtZSI6InVzZXIiLCJhdXRob3JpdGllcyI6WyJST0xFX1VTRVIiXSwianRpIjoiN2QzOTY4NWItMDE2Mi00ZGRhLTljYmUtOTk2ZjkzNjYxZWE1IiwiY2xpZW50X2lkIjoiY2xpZW50SWQiLCJzY29wZSI6WyJyZWFkIiwid3JpdGUiXX0.b89XgI_6KKwLCom33lTZrwSd9fw57pVmQzpX7WJhNRwYVEFJgV8JzmNJx-t6A5RGNJuH_cUE3zYBxtlOgRlkPqlVDYX-ODXxqrSBgYInoKVsAcjvIuXbWrbz_MkuGle1iyGW9RAyNxc3Yyogokul1Cuw74V3jpfINDsjESmVAvo0FOG33zjKl0Xkcc-sZa2gaVdOS_qCcR0RO7pEJIQyQsJpfrDXsxfUy4y5GY1IYclHphAJYky_yyEo3kowYvp_meVYdfMYVjfmdtVYyd4RftklSsVDUoZ-MveOF4fOZPutUgpD92dgwWjgILzumQ2rINtcLPb014bqI7tyblLcPw'`
    
    The above command should generate response something similar to response given below 
    
    ```text
       {
           "authenticated": true,
           "authorities": [
               {
                   "authority": "ROLE_USER"
               }
           ],
           "clientOnly": false,
           "credentials": "",
           "details": {
               "decodedDetails": null,
               "remoteAddress": "0:0:0:0:0:0:0:1",
               "sessionId": null,
               "tokenType": "Bearer",
               "tokenValue": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1NTc0OTQxNTQsInVzZXJfbmFtZSI6InVzZXIiLCJhdXRob3JpdGllcyI6WyJST0xFX1VTRVIiXSwianRpIjoiN2QzOTY4NWItMDE2Mi00ZGRhLTljYmUtOTk2ZjkzNjYxZWE1IiwiY2xpZW50X2lkIjoiY2xpZW50SWQiLCJzY29wZSI6WyJyZWFkIiwid3JpdGUiXX0.b89XgI_6KKwLCom33lTZrwSd9fw57pVmQzpX7WJhNRwYVEFJgV8JzmNJx-t6A5RGNJuH_cUE3zYBxtlOgRlkPqlVDYX-ODXxqrSBgYInoKVsAcjvIuXbWrbz_MkuGle1iyGW9RAyNxc3Yyogokul1Cuw74V3jpfINDsjESmVAvo0FOG33zjKl0Xkcc-sZa2gaVdOS_qCcR0RO7pEJIQyQsJpfrDXsxfUy4y5GY1IYclHphAJYky_yyEo3kowYvp_meVYdfMYVjfmdtVYyd4RftklSsVDUoZ-MveOF4fOZPutUgpD92dgwWjgILzumQ2rINtcLPb014bqI7tyblLcPw"
           },
           "name": "user",
           "oauth2Request": {
               "approved": true,
               "authorities": [],
               "clientId": "clientId",
               "extensions": {},
               "grantType": null,
               "redirectUri": null,
               "refresh": false,
               "refreshTokenRequest": null,
               "requestParameters": {
                   "client_id": "clientId"
               },
               "resourceIds": [],
               "responseTypes": [],
               "scope": [
                   "read",
                   "write"
               ]
           },
           "principal": "user",
           "userAuthentication": {
               "authenticated": true,
               "authorities": [
                   {
                       "authority": "ROLE_USER"
                   }
               ],
               "credentials": "N/A",
               "details": null,
               "name": "user",
               "principal": "user"
           }
       }
    ```
    
    
    
