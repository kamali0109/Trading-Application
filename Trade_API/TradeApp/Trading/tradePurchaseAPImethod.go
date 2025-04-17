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

type TradePurchaseDetails struct {
	ClientId   string `json:"clientId"`
	Isin       string `json:"isin"`
	TradeType  string `json:"tradeType"`
	Quantity   string `json:"quantity"`
	TradePrice string `json:"tradePrice"`
	Amount     string `json:"amount"`
}

type TradePurchaseDetailsResp struct {
	Status string `json:"status"`
	Msg    string `json:"msg"`
}

type UpdateTradeStruct struct {
	AdminStatus string `json:"admin_status"`
	TradeId     int    `json:"trade_id"`
}

type BillerUpdateTradeStruct struct {
	BoStatus string `json:"bo_status"`
	TradeId  int    `json:"trade_id"`
}

type PutTradeDetailsResp struct {
	Status   string `json:"status"`
	Response string `json:"response"`
	ErrMsg   string `json:"errMsg"`
}

func PurchaseTradeAPI(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Access-control-Allow-origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "POST")
	w.Header().Set("Access-Control-Allow-Headers", "Accept,Content-Type,Content-Length,Accept-Encoding,X-CSRF-Token,Authorization")

	log.Println("PurchaseTradeApi(+)")

	var lreq TradePurchaseDetails
	var lresp TradePurchaseDetailsResp

	if r.Method == http.MethodPost {
		lbody, lErr01 := io.ReadAll(r.Body)

		if lErr01 != nil {
			log.Println("TPTA:01", lErr01)
			lresp.Status = "E"
			lresp.Msg = "Error while converting the body to byte"
		} else {
			//unmarshalling
			lErr02 := json.Unmarshal(lbody, &lreq)

			if lErr02 != nil {
				log.Println("TPTA:02", lErr02)
				lresp.Status = "E"
				lresp.Msg = lErr02.Error()
			} else {
				db, lErr03 := dbconnect.LocalDbConnect()

				if lErr03 != nil {
					log.Println("TPTA:03", lErr03)
					lresp.Status = "E"
					lresp.Msg = lErr03.Error()
				} else {
					defer db.Close()

					lErr04 := InsertIntoTradeMaster(db, lreq)
					if lErr04 != nil {
						log.Println("TPTA:04", lErr04)
						lresp.Status = "E"
						lresp.Msg = lErr04.Error()
					} else {
						lresp.Status = "S"
						lresp.Msg = "Successfully inserted in trade_master"
					}
				}
			}

		}
	} else {
		lresp.Status = "E"
		lresp.Msg = "Method Not Allowed"
	}
	lResp, lErr05 := json.Marshal(lresp)
	if lErr05 != nil {
		log.Println("TETEA:05", lErr05)
	} else {
		fmt.Fprint(w, string(lResp))
	}
	log.Println("PurchaseTradeApi(-)")

}

func InsertIntoTradeMaster(db *sql.DB, pReq TradePurchaseDetails) error {

	log.Println("InsertIntoTradeMaster(+)")

	lInsertString := `insert into trade_master (client_id,script_id,trade_type,quantity,trade_price,trade_date,updated_date,created_date,created_by,updated_by,order_status,admin_status,bo_status,amount) values(?,?,?,?,?,Now(),Now(),Now(),?,?,"Y","P","P",?)`

	lStmt, lErr01 := db.Prepare(lInsertString)

	if lErr01 != nil {
		log.Println("TIIT01", lErr01)
		return lErr01
	}
	defer lStmt.Close()
	lScripId, lErr02 := GetScriptId(db, pReq.Isin)

	if lErr02 != nil {
		log.Println("TIIT02", lErr02)
		return lErr02
	}

	_, lErr03 := lStmt.Exec(pReq.ClientId, lScripId, pReq.TradeType, pReq.Quantity, pReq.TradePrice, pReq.ClientId, pReq.ClientId, pReq.Amount)

	if lErr03 != nil {
		log.Println("TIIT02", lErr03)
		return lErr02
	}
	log.Println("InsertIntoTradeMaster(-)")
	return nil
}

func GetScriptId(db *sql.DB, pIsin string) (int, error) {
	log.Println("GetScriptId(+)")

	var lScriptId int
	lSelectString := `select scrip_id from script_master2 where isin =?`

	lStmt, lErr01 := db.Prepare(lSelectString)
	if lErr01 != nil {
		log.Println("TGSI01", lErr01)
		return lScriptId, lErr01
	}
	defer lStmt.Close()

	lErr02 := lStmt.QueryRow(pIsin).Scan(&lScriptId)
	if lErr02 != nil {
		if lErr02 == sql.ErrNoRows {
			log.Printf("No record found for ISIN: %s", pIsin)
			return lScriptId, fmt.Errorf("ISIN %s not found in the database", pIsin)
		}
		log.Println("TGSI02", lErr02)
		return lScriptId, lErr02
	}

	log.Println("GetScriptId(-)")
	return lScriptId, nil
}
