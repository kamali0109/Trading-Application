package trading

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"io"

	"log"
	"net/http"

	dbconnect "trade_API_Folder/TradeApp/DBConnect"
)

type UpdateTrade struct {
	AdminStatus string `json:"admin_status"`
	TradeId     int `json:"trade_id"`
}

type PutTradeDetails1 struct {
	Status   string `json:"status"`
	Response string `json:"response"`
	ErrMsg   string `json:"errMsg"`
}

func UpdateTradeStatus1(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "POST")
	w.Header().Set("Access-Control-Allow-Headers", "Accept,Content-Type,Content-Length,Accept-Encoding,X-CSRF-Token,Authorization")

	log.Println("UpdateTradeStatusAPI(+)")

	var lreq interface{}
	var lresp PutTradeDetailsResp

	if r.Method == http.MethodPost {
		lbody, lErr01 := io.ReadAll(r.Body)

		if lErr01 != nil {
			log.Println("UTSA:01", lErr01)
			lresp.Status = "E"
			lresp.ErrMsg = "Error while reading the body"
		} else {

			var updateTrade UpdateTradeStruct
			var billerUpdateTrade BillerUpdateTradeStruct

			lErr02 := json.Unmarshal(lbody, &updateTrade)
			if lErr02 == nil {

				lreq = updateTrade
			} else {

				lErr03 := json.Unmarshal(lbody, &billerUpdateTrade)
				if lErr03 == nil {

					lreq = billerUpdateTrade
				} else {
					log.Println("UTSA:02", lErr03)
					lresp.Status = "E"
					lresp.ErrMsg = "Failed to unmarshal request"
					fmt.Fprint(w, lresp)
					return
				}
			}

			db, lErr04 := dbconnect.LocalDbConnect()

			if lErr04 != nil {
				log.Println("UTSA:03", lErr04)
				lresp.Status = "E"
				lresp.ErrMsg = lErr04.Error()
			} else {
				defer db.Close()

				switch v := lreq.(type) {
				case UpdateTradeStruct:
					err := UpdateAdminStatus(db, v)
					if err != nil {
						log.Println("UTSA:04", err)
						lresp.Status = "E"
						lresp.ErrMsg = err.Error()
					} else {
						lresp.Status = "S"
						lresp.Response = "Admin status updated successfully"
					}

				}
			}
		}
	} else {
		lresp.Status = "E"
		lresp.ErrMsg = "Method Not Allowed"
	}

	lResp, lErr06 := json.Marshal(lresp)
	if lErr06 != nil {
		log.Println("UTSA:06", lErr06)
	} else {
		fmt.Fprint(w, string(lResp))
	}

	log.Println("UpdateTradeStatusAPI(-)")
}

func UpdateAdminStatus(db *sql.DB, pReq UpdateTradeStruct) error {
	log.Println("UpdateAdminStatus(+)")

	lUpdateString := `UPDATE trade_master SET admin_status = ?, updated_date = Now(), updated_by = ? WHERE trade_id = ?`

	lStmt, lErr01 := db.Prepare(lUpdateString)
	if lErr01 != nil {
		log.Println("UTAS01", lErr01)
		return lErr01
	}
	defer lStmt.Close()

	_, lErr02 := lStmt.Exec(pReq.AdminStatus, pReq.TradeId, pReq.TradeId)
	if lErr02 != nil {
		log.Println("UTAS02", lErr02)
		return lErr02
	}

	log.Println("UpdateAdminStatus(-)")
	return nil
}
