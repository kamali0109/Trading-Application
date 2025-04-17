package registation

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"strings"
)

type GetClientDetailsRespStruct struct {
	ClientMasterArr []ClientDetailsStruct `json:"clientMasterArr"`
	Status          string                `json:"status"`
	ErrMsg          string                `json:"errMsg"`
}

type PostClientDetailsRespStruct struct {
	Status    string `json:"status"`
	Response  string `json:"response"`
	Client_Id string `json:"client_Id"`
	ErrMsg    string `json:"errMsg"`
}
type PutClientDetailsRespStruct struct {
	Status   string `json:"status"`
	Response string `json:"response"`
	ErrMsg   string `json:"errMsg"`
}

type LoginClientDetailsReqStruct struct {
	ClientId string `json:"clientId"`
	Password string `json:"password"`
}
type LoginClientDetailsRespStruct struct {
	Status          string              `json:"status"`
	ClientMasterRec ClientDetailsStruct `json:"clientMasterRec"`

	ErrMsg string `json:"errMsg"`
}

//GET Method API

func GetClientMasterAPI(w http.ResponseWriter, r *http.Request) {

	(w).Header().Set("Access-Control-Allow-Origin", "*")
	(w).Header().Set("Access-Control-Allow-Credentials", "true")
	(w).Header().Set("Access-Control-Allow-Methods", "GET,OPTIONS")
	(w).Header().Set("Access-Control-Allow-Headers", "USER,Accept,Content-Type,Content-Length,Accept-Encoding,X-CSRF-Token,Authorization")
	log.Println("GetClientMasterAPI(+)")

	var lClientDetailsRespStruct GetClientDetailsRespStruct

	if strings.EqualFold(r.Method, http.MethodGet) {
		lClientDetailsRespStruct.Status = "S"

		lGetClientMasterDetails, lErr := GetClientMasterDetails()

		if lErr != nil {
			lClientDetailsRespStruct.Status = "E"
			lClientDetailsRespStruct.ErrMsg = lErr.Error()
		} else {
			lClientDetailsRespStruct.Status = "S"
			lClientDetailsRespStruct.ErrMsg = ""
			lClientDetailsRespStruct.ClientMasterArr = lGetClientMasterDetails

		}

	} else {
		lClientDetailsRespStruct.Status = "E"
		lClientDetailsRespStruct.ErrMsg = "Invalid Method"
	}
	lResponse, lErr := json.Marshal(lClientDetailsRespStruct)

	if lErr != nil {
		fmt.Fprintf(w, "Error taking data"+lErr.Error())
	} else {
		fmt.Fprintf(w, string(lResponse))
	}

}

//Post API Method

func PostRegisterClientMasterAPI(w http.ResponseWriter, r *http.Request) {
	(w).Header().Set("Access-Control-Allow-Origin", "*")
	(w).Header().Set("Access-Control-Allow-Credentials", "true")
	(w).Header().Set("Access-Control-Allow-Methods", "POST,OPTIONS")
	(w).Header().Set("Access-Control-Allow-Headers", "USER,Accept,Content-Type,Content-Length,Accept-Encoding,X-CSRF-Token,Authorization")
	log.Println("PostClientMasterAPI(+)")

	var lPostClientDetailsRespStruct PostClientDetailsRespStruct
	var lClientMasterDetails ClientDetailsStruct

	if strings.EqualFold(r.Method, http.MethodPost) {
		lPostClientDetailsRespStruct.Status = "S"
		lBody, lErr := ioutil.ReadAll(r.Body)
		if lErr != nil {
			lPostClientDetailsRespStruct.Status = "E"
			lPostClientDetailsRespStruct.ErrMsg = "REPCMA: 001" + lErr.Error()

		} else {
			lErr := json.Unmarshal(lBody, &lClientMasterDetails)
			if lErr != nil {
				log.Println("REPCMA: 002" + lErr.Error())
				lPostClientDetailsRespStruct.Status = "E"
				lPostClientDetailsRespStruct.ErrMsg = lErr.Error()
			} else {

				lClientId, lErr := PostClientDetails(lClientMasterDetails)

				if lErr != nil {
					log.Println("REPCMA: 003" + lErr.Error())
					lPostClientDetailsRespStruct.Status = "E"
					lPostClientDetailsRespStruct.ErrMsg = lErr.Error()
				} else {
					lPostClientDetailsRespStruct.Status = "S"
					lPostClientDetailsRespStruct.Client_Id = lClientId
					lPostClientDetailsRespStruct.Response = "Register Successfully"

				}

			}
		}

	} else {
		lPostClientDetailsRespStruct.Status = "E"
		lPostClientDetailsRespStruct.ErrMsg = "Invalid Method"
	}

	lResponse, lErr := json.Marshal(lPostClientDetailsRespStruct)

	if lErr != nil {
		fmt.Fprintf(w, "Error Taking Data"+lErr.Error())
	} else {
		fmt.Fprintf(w, string(lResponse))
	}

}

func LoginVerifyClientDetialsAPI(w http.ResponseWriter, r *http.Request) {
	(w).Header().Set("Access-Control-Allow-Origin", "*")
	(w).Header().Set("Access-Control-Allow-Credentials", "true")
	(w).Header().Set("Access-Control-Allow-Methods", "POST,OPTIONS")
	(w).Header().Set("Access-Control-Allow-Headers", "USER,Accept,Content-Type,Content-Length,Accept-Encoding,X-CSRF-Token,Authorization")
	log.Println("LoginVerifyClientDetialsAPI(+)")
	var lLoginClientDetailsRespStruct LoginClientDetailsRespStruct

	var lLoginClientDetailsReqStruct LoginClientDetailsReqStruct
	var lClientDetials ClientDetailsStruct

	if strings.EqualFold(r.Method, http.MethodPost) {

		lLoginClientDetailsRespStruct.Status = "S"
		lBody, lErr := ioutil.ReadAll(r.Body)

		if lErr != nil {
			lLoginClientDetailsRespStruct.Status = "E"
			lLoginClientDetailsRespStruct.ErrMsg = "RELVCD :001" + lErr.Error()

		} else {

			lErr := json.Unmarshal(lBody, &lLoginClientDetailsReqStruct)
			if lErr != nil {
				log.Println("REPCMA: 002" + lErr.Error())
				lLoginClientDetailsRespStruct.Status = "E"
				lLoginClientDetailsRespStruct.ErrMsg = lErr.Error()

			} else {
				lResponse, lErr := VerifyClientDetials(lLoginClientDetailsReqStruct)

				if lErr != nil {
					log.Println("REPCMA: 003" + lErr.Error())
					lLoginClientDetailsRespStruct.Status = "E"
					lLoginClientDetailsRespStruct.ErrMsg = lErr.Error()
				} else {
					lLoginClientDetailsRespStruct.Status = lResponse.ClientStatus

					if lResponse.ClientStatus == "S" {
						lLoginClientDetailsRespStruct.ErrMsg = "Login SuccessFully"
						lLoginClientDetailsRespStruct.ClientMasterRec = lResponse.ClientDetailsRec

					} else if lResponse.ClientStatus == "IC" {
						lLoginClientDetailsRespStruct.ClientMasterRec = lClientDetials
						lLoginClientDetailsRespStruct.ErrMsg = "Invalid ClientID"

					} else if lResponse.ClientStatus == "IP" {
						lLoginClientDetailsRespStruct.ClientMasterRec = lClientDetials
						lLoginClientDetailsRespStruct.ErrMsg = "Invalid Password"
					} else {
						lLoginClientDetailsRespStruct.ClientMasterRec = lClientDetials
						lLoginClientDetailsRespStruct.ErrMsg = "Something Went to Wrong"
					}

				}
			}
		}

	} else {
		lLoginClientDetailsRespStruct.Status = "E"
		lLoginClientDetailsRespStruct.ErrMsg = "Invalid Method"
	}
	lApiResponse, lErr := json.Marshal(lLoginClientDetailsRespStruct)

	if lErr != nil {
		fmt.Fprintf(w, "Error Taking Data"+lErr.Error())
	} else {
		fmt.Fprintf(w, string(lApiResponse))
	}

}

//PUT Method

func PutClientMasterAPI(w http.ResponseWriter, r *http.Request) {
	(w).Header().Set("Access-Control-Allow-Origin", "*")
	(w).Header().Set("Access-Control-Allow-Credentials", "true")
	(w).Header().Set("Access-Control-Allow-Methods", "PUT,OPTIONS")
	(w).Header().Set("Access-Control-Allow-Headers", "USER,Accept,Content-Type,Content-Length,Accept-Encoding,X-CSRF-Token,Authorization")
	log.Println("PutClientMasterAPI(+)")

	var lPutClientDetailsRespStruct PutClientDetailsRespStruct
	var lUpdateClientStruct []UpdateClientStruct

	if strings.EqualFold(r.Method, http.MethodPut) {
		lPutClientDetailsRespStruct.Status = "S"

		lBody, lErr := ioutil.ReadAll(r.Body)
		if lErr != nil {
			log.Println("REPCMA :001" + lErr.Error())
			lPutClientDetailsRespStruct.Status = "E"
			lPutClientDetailsRespStruct.ErrMsg = lErr.Error()
		} else {
			lErr = json.Unmarshal(lBody, &lUpdateClientStruct)
			if lErr != nil {
				log.Println("REPCMA :002" + lErr.Error())
				lPutClientDetailsRespStruct.Status = "E"
				lPutClientDetailsRespStruct.ErrMsg = lErr.Error()

			} else {
				lErr = UpdateClientDetails(lUpdateClientStruct)
				if lErr != nil {
					log.Println("REPCMA :003" + lErr.Error())
					lPutClientDetailsRespStruct.Status = "E"
					lPutClientDetailsRespStruct.ErrMsg = lErr.Error()
				} else {
					lPutClientDetailsRespStruct.Status = "S"
					lPutClientDetailsRespStruct.Response = "KYC Status Updated Successfully"
				}
			}
		}

	} else {
		lPutClientDetailsRespStruct.Status = "E"
		lPutClientDetailsRespStruct.ErrMsg = "InValid Method"
	}
	lResponse, lErr := json.Marshal(lPutClientDetailsRespStruct)

	if lErr != nil {
		fmt.Fprintf(w, "Error Taking Data"+lErr.Error())
	} else {
		fmt.Fprintf(w, string(lResponse))
	}

}
