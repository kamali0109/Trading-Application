package trading

import (
	"fmt"
	"log"
	dbconnect "trade_API_Folder/TradeApp/DBConnect"
)

type GetScriptMasterDetailsRespStruct struct {
	ScriptMasterDetailsArr []ScriptMasterDetailsStruct `json:"scriptMasterDetailsArr"`
	Status                 string                      `json:"status"`
	ErrMsg                 string                      `json:"errMsg"`
}

func GetScriptMasterDetails() ([]ScriptMasterDetailsStruct, error) {
	log.Println("GetScriptmasterDetailsAPI(+)")
	var lScriptMasterDetailsRec ScriptMasterDetailsStruct

	var lScriptMasterDetailsArr []ScriptMasterDetailsStruct

	lDb, lErr := dbconnect.LocalDbConnect()

	if lErr != nil {
		return lScriptMasterDetailsArr, fmt.Errorf("TGSMDA :001" + lErr.Error())
	} else {
		defer lDb.Close()
		lSqlString := ` select nvl(scrip_id,""),nvl(stock_name,""),nvl(isin,""),nvl(segment_code,""),nvl(price,0.00),nvl(created_by,""),nvl(created_date,""),nvl(updated_by,""),nvl(updated_date,"") from script_master2 sm `

		lRows, lErr := lDb.Query(lSqlString)

		if lErr != nil {
			return lScriptMasterDetailsArr, fmt.Errorf(lErr.Error())
		} else {
			defer lRows.Close()
			for lRows.Next() {
				lErr := lRows.Scan(
					&lScriptMasterDetailsRec.Script_Id,
					&lScriptMasterDetailsRec.Stock_name,
					&lScriptMasterDetailsRec.Isin,
					&lScriptMasterDetailsRec.Segment_code,
					&lScriptMasterDetailsRec.Price,
					&lScriptMasterDetailsRec.Created_by,
					&lScriptMasterDetailsRec.Created_date,
					&lScriptMasterDetailsRec.Updated_by,
					&lScriptMasterDetailsRec.Updated_date,
				)

				if lErr != nil {
					return lScriptMasterDetailsArr, fmt.Errorf(lErr.Error())
				} else {
					log.Println(lScriptMasterDetailsArr)
					lScriptMasterDetailsArr = append(lScriptMasterDetailsArr, lScriptMasterDetailsRec)
				}
			}
		}
	}
	log.Println("GetScriptmasterDetailsAPI(-)")
	return lScriptMasterDetailsArr, nil
}
