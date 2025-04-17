package trading

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"strings"
)

type ClientRequest struct {
	ClientId string `json:"clientId"`
}

type TradeMasterDetailsRespStruct struct {
	TradeMasterDetailsStructArr []TradeMasterDetailsStruct `json:"tradeMasterDetailsStructArr"`
	Status                      string                     `json:"status"`
	ErrMsg                      string                     `json:"errMsg"`
}


func PostTradeHistoryAPI(w http.ResponseWriter, r *http.Request) {
	// Set CORS headers
	(w).Header().Set("Access-Control-Allow-Origin", "*")
	(w).Header().Set("Access-Control-Allow-Credentials", "true")
	(w).Header().Set("Access-Control-Allow-Methods", "POST,OPTIONS")
	(w).Header().Set("Access-Control-Allow-Headers", "USER,Accept,Content-Type,Content-Length,Accept-Encoding,X-CSRF-Token,Authorization")
	log.Println("PostClientMasterAPI(+)")

	var lTradeMasterDetailsRespStruct TradeMasterDetailsRespStruct
	var lReqClient ClientRequest 

	if strings.EqualFold(r.Method, http.MethodPost) {
		lTradeMasterDetailsRespStruct.Status = "S"
		// Read the body of the request
		lBody, lErr := ioutil.ReadAll(r.Body)
		if lErr != nil {
			lTradeMasterDetailsRespStruct.Status = "E"
			lTradeMasterDetailsRespStruct.ErrMsg = "TRPTHA: 001" + lErr.Error()
		} else {
			// Unmarshal the body into the ClientRequest struct
			lErr := json.Unmarshal(lBody, &lReqClient)
			if lErr != nil {
				log.Println("TRPTHA: 001: 002" + lErr.Error())
				lTradeMasterDetailsRespStruct.Status = "E"
				lTradeMasterDetailsRespStruct.ErrMsg = lErr.Error()
			} else {
				// Use the clientId from the request struct
				lApiResponse, lErr := getTradeMasterDetails(lReqClient.ClientId)

				if lErr != nil {
					log.Println("REPCMA: 003" + lErr.Error())
					lTradeMasterDetailsRespStruct.Status = "E"
					lTradeMasterDetailsRespStruct.ErrMsg = lErr.Error()
				} else {
					lTradeMasterDetailsRespStruct.Status = "S"
					lTradeMasterDetailsRespStruct.TradeMasterDetailsStructArr = lApiResponse
				}
			}
		}
	} else {
		lTradeMasterDetailsRespStruct.Status = "E"
		lTradeMasterDetailsRespStruct.ErrMsg = "Invalid Method"
	}

	// Marshal the response struct to JSON and send it back
	lResponse, lErr := json.Marshal(lTradeMasterDetailsRespStruct)

	if lErr != nil {
		fmt.Fprintf(w, "Error Taking Data: "+lErr.Error())
	} else {
		fmt.Fprintf(w, string(lResponse))
	}
}
