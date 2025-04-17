package trading

import (
	"fmt"
	"log"
	dbconnect "trade_API_Folder/TradeApp/DBConnect"
)

type TradeMasterDetailsStruct struct {
	Client_id    string `json:"client_id"`
	Trade_id     int `json:"trade_id"`
	Amount       string `json:"amount"`
	Trade_type   string `json:"trade_type"`
	Quantity     string `json:"quantity"`
	Trade_price  string `json:"trade_price"`
	Trade_date   string `json:"trade_date"`
	Order_status string `json:"order_status"`
	Admin_status string `json:"admin_status"`
	Bo_status    string `json:"bo_status"`
	Stock_name   string `json:"stock_name"`
	Isin         string `json:"isin"`
}

func getTradeMasterDetails(lclientId string) ([]TradeMasterDetailsStruct, error) {
	log.Println("GetScriptmasterDetailsAPI(+)")
	var lTradeMasterDetailsStructRec TradeMasterDetailsStruct

	var lTradeMasterDetailsStructArr []TradeMasterDetailsStruct
	var lwhere string

	fmt.Println("lclient", lclientId)

	if lclientId == "" {
		lwhere = "tm.script_id =sm.scrip_id"
	} else {
		lwhere = "tm.script_id =sm.scrip_id and tm.client_id = " + `'` + lclientId + `'`
		fmt.Println("where", lwhere)
	}

	lDb, lErr := dbconnect.LocalDbConnect()

	if lErr != nil {
		return lTradeMasterDetailsStructArr, fmt.Errorf("TGSMDA :001" + lErr.Error())
	} else {
		defer lDb.Close()
		lSqlString :=
			// 			` select  tm.client_id,tm.trade_type,tm.quantity,tm.trade_price,tm.trade_date,tm.order_status,tm.admin_status,tm.bo_status,sm.stock_name,sm.isin
			//  from trade_master tm,script_master sm
			//  where tm.script_id =sm.scrip_id and tm.client_id=?
			//  `
			"select tm.client_id,tm.trade_id,tm.amount,tm.trade_type,tm.quantity,tm.trade_price,tm.trade_date,tm.order_status,tm.admin_status,tm.bo_status,sm.stock_name,sm.isin from trade_master tm,script_master2 sm where " + lwhere

		fmt.Println("lSqlString", lSqlString)
		lRows, lErr := lDb.Query(lSqlString)

		if lErr != nil {
			return lTradeMasterDetailsStructArr, fmt.Errorf(lErr.Error())
		} else {
			defer lRows.Close()
			for lRows.Next() {
				lErr := lRows.Scan(
					&lTradeMasterDetailsStructRec.Client_id,
					&lTradeMasterDetailsStructRec.Trade_id,
					&lTradeMasterDetailsStructRec.Amount,
					&lTradeMasterDetailsStructRec.Trade_type,
					&lTradeMasterDetailsStructRec.Quantity,
					&lTradeMasterDetailsStructRec.Trade_price,
					&lTradeMasterDetailsStructRec.Trade_date,
					&lTradeMasterDetailsStructRec.Order_status,
					&lTradeMasterDetailsStructRec.Admin_status,
					&lTradeMasterDetailsStructRec.Bo_status,
					&lTradeMasterDetailsStructRec.Stock_name,
					&lTradeMasterDetailsStructRec.Isin,
				)

				if lErr != nil {
					return lTradeMasterDetailsStructArr, fmt.Errorf(lErr.Error())
				} else {
					log.Println(lTradeMasterDetailsStructArr)
					lTradeMasterDetailsStructArr = append(lTradeMasterDetailsStructArr, lTradeMasterDetailsStructRec)
				}
			}
		}
	}
	log.Println("GetScriptmasterDetailsAPI(-)")
	return lTradeMasterDetailsStructArr, nil
}
