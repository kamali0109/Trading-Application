package trading

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	dbconnect "trade_API_Folder/TradeApp/DBConnect"
	// localdb "Goapi/LocalDb"
)

type tradeDeleteApiReq struct {
        TradeId int `json:"trade_id"`
}

type tradeDeleteApiResp struct {
        Status string `json:"status"`
        Msg    string `json:"msg"`
}

func TradeDeleteApi(w http.ResponseWriter, r *http.Request) {
        w.Header().Set("Access-Control-Allow-Origin", "*")
        w.Header().Set("Access-Control-Allow-Methods", "POST")
        w.Header().Set("Access-Control-Allow-Headers", "Accept,Content-Type,Content-Length,Accept-Encoding,X-CSRF-Token,Authorization")

        log.Println("TradeDeleteApi (+)")

        var ltradeDeleteApiReq tradeDeleteApiReq
        var ltradeDeleteApiResp tradeDeleteApiResp

        if r.Method == http.MethodPost {
                // Read the request body
                lbody, err := io.ReadAll(r.Body)
                if err != nil {
                        log.Println("Error reading request body:", err)
                        ltradeDeleteApiResp.Status = "E"
                        ltradeDeleteApiResp.Msg = "Error reading request body"
                        return
                }

                // Parse the request body into a struct
                err = json.Unmarshal(lbody, &ltradeDeleteApiReq)
                if err != nil {
                        log.Println("Error parsing request body:", err)
                        ltradeDeleteApiResp.Status = "E"
                        ltradeDeleteApiResp.Msg = "Error parsing request body"
                        return
                }

                // Connect to the database
                db, err :=dbconnect.LocalDbConnect()
                if err != nil {
                        log.Println("Error connecting to database:", err)
                        ltradeDeleteApiResp.Status = "E"
                        ltradeDeleteApiResp.Msg = "Error connecting to database"
                        return
                }
                defer db.Close()

                // Delete the trade
                err = DeleteTrade(db, ltradeDeleteApiReq.TradeId)
                if err != nil {
                        log.Println("Error deleting trade:", err)
                        ltradeDeleteApiResp.Status = "E"
                        ltradeDeleteApiResp.Msg = "Error deleting trade"
                        return
                }

                ltradeDeleteApiResp.Status = "S"
                ltradeDeleteApiResp.Msg = "Trade deleted successfully"
        }

        // Marshal the response
        lResp, err := json.Marshal(ltradeDeleteApiResp)
        if err != nil {
                log.Println("Error marshalling response:", err)
                http.Error(w, "Internal Server Error", http.StatusInternalServerError)
                return
        }

        w.Header().Set("Content-Type", "application/json")
        fmt.Fprint(w, string(lResp))
        log.Println("TradeDeleteApi (-)")
}

func DeleteTrade(db *sql.DB, tradeId int) error {
        sqlString := "DELETE FROM trade_master WHERE trade_id = ?"
        _, err := db.Exec(sqlString, tradeId)
        return err
}

