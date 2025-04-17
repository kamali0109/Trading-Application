package trading

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"strings"
)

type ScriptMasterDetailsStruct struct {
	Script_Id    string `json:"scrip_id"`
	Stock_name   string `json:"stock_name"`
	Isin         string `json:"isin"`
	Segment_code string `json:"segment_code"`
	Price        string `json:"price"`
	Created_by   string `json:"created_by"`
	Created_date string `json:"created_date"`
	Updated_by   string `json:"updated_by"`
	Updated_date string `json:"updated_date"`
}

func GetScriptMasterDetailsAPI(w http.ResponseWriter, r *http.Request) {
	(w).Header().Set("Access-Control-Allow-Origin", "*")
	(w).Header().Set("Access-Control-Allow-Credentials", "true")
	(w).Header().Set("Access-Control-Allow-Methods", "GET,OPTIONS")
	(w).Header().Set("Access-Control-Allow-Headers", "USER,Accept,Content-Type,Content-Length,Accept-Encoding,X-CSRF-Token,Authorization")
	log.Println("GetStackMasterDetailsAPI(+)")
	var lGetScriptMasterDetailsRespStruct GetScriptMasterDetailsRespStruct

	if strings.EqualFold(r.Method, http.MethodGet) {
		lGetScriptMasterDetailsRespStruct.Status = "S"

		lGetScriptMasterDetails, lErr := GetScriptMasterDetails()

		if lErr != nil {
			lGetScriptMasterDetailsRespStruct.Status = "E"
			lGetScriptMasterDetailsRespStruct.ErrMsg = "TGSNDA :001" + lErr.Error()

		} else {
			lGetScriptMasterDetailsRespStruct.Status = "S"
			lGetScriptMasterDetailsRespStruct.ErrMsg = ""
			lGetScriptMasterDetailsRespStruct.ScriptMasterDetailsArr = lGetScriptMasterDetails
		}

	} else {
		lGetScriptMasterDetailsRespStruct.Status = "E"
		lGetScriptMasterDetailsRespStruct.ErrMsg = "Invalid Method"
	}

	lResponse, lErr := json.Marshal(lGetScriptMasterDetailsRespStruct)
	if lErr != nil {
		fmt.Fprintf(w, "Error taking data"+lErr.Error())
	} else {
		fmt.Fprintf(w, string(lResponse))
	}

}
