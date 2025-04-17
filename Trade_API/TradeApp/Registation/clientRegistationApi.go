package registation

import (
	"fmt"
	"log"
	"strconv"
	"strings"

	dbconnect "trade_API_Folder/TradeApp/DBConnect"
)

type ClientDetailsStruct struct {
	Client_Id    string `json:"clientId"`
	First_name   string `json:"first_name"`
	Last_name    string `json:"last_name"`
	Email        string `json:"email"`
	Phone_number string `json:"phone_number"`
	Pan_card     string `json:"pan_card"`
	Nominee_name string `json:"nominee_name"`
	Kyc_status   string `json:"kyc_status"`
	Password     string `json:"password,omitempty"`
	Role         string `json:"role"`
	Created_by   string `json:"created_by,omitempty"`
	Updated_by   string `json:"updated_by,omitempty"`
	Created_date string `json:"created_date,omitempty"`
	Updated_date string `json:"updated_date,omitempty"`
}

type UpdateClientStruct struct {
	KycStatus string `json:"kyc_status"`
	ClientId  string `json:"client_id"`
}

// Select
func GetClientMasterDetails() ([]ClientDetailsStruct, error) {
	log.Println("GetCoreSettingValue(+)")
	var lClientDetailsRec ClientDetailsStruct
	var lClientDetailsArr []ClientDetailsStruct

	lDb, lErr := dbconnect.LocalDbConnect()
	if lErr != nil {
		return lClientDetailsArr, fmt.Errorf("REGCMV:001 " + lErr.Error())
	} else {
		defer lDb.Close()
		lSqlString := `SELECT nvl(client_Id,'') ,nvl(first_name,''),nvl(last_name,''),nvl(email,''),nvl(phone_number,''),nvl(pan_card,''),nvl(nominee_name,''),nvl(kyc_status,''),nvl(password,''),nvl(role,''),nvl(updated_date,''),nvl(created_date,''),nvl(created_by,''),nvl(updated_by,'')
						FROM client`

		lRows, lErr := lDb.Query(lSqlString)

		if lErr != nil {
			return lClientDetailsArr, fmt.Errorf("REGCMV:002 " + lErr.Error())
		}
		defer lRows.Close()
		for lRows.Next() {
			lErr := lRows.Scan(
				&lClientDetailsRec.Client_Id,
				&lClientDetailsRec.First_name,
				&lClientDetailsRec.Last_name,
				&lClientDetailsRec.Email,
				&lClientDetailsRec.Phone_number,
				&lClientDetailsRec.Pan_card,
				&lClientDetailsRec.Nominee_name,
				&lClientDetailsRec.Kyc_status,
				&lClientDetailsRec.Password,
				&lClientDetailsRec.Role,
				&lClientDetailsRec.Created_by,
				&lClientDetailsRec.Updated_by,
				&lClientDetailsRec.Created_date,
				&lClientDetailsRec.Updated_date,
			)
			// fmt.Println(client_details, "client_details")
			// fmt.Println(err, "err")
			if lErr != nil {
				return lClientDetailsArr, fmt.Errorf("REGCMV:003 " + lErr.Error())
			} else {

				// fmt.Println(lClientDetailsRec.Client_Id)
				// lClient_Id := strings.Split(lClientDetailsRec.Client_Id, "FT")[1]
				// fmt.Println(lClient_Id)

				// lClientIdvalue, err := strconv.Atoi(lClient_Id)

				// fmt.Println(lClientIdvalue+2, err)
				// lClientIdsvalue := strconv.Itoa(lClientIdvalue + 2)
				// fmt.Println(lClientIdsvalue)

				// lClientDetailsRec.Client_Id = "FT000" + lClientIdsvalue

				// lClientDetailsRec.Kyc_status = "Y"

				lClientDetailsArr = append(lClientDetailsArr, lClientDetailsRec)
			}
		}
		log.Println("GetCoreSettingValue(-)")
		return lClientDetailsArr, nil
	}

}

// Insert

// func GenerateClientId() {
// 	Client_Id := "FT0000"
// 	for i := 0; i < lReqRec.SubTaskCount; i++ {
// 		currentChar := string('A' + i) // Convert the index to a character ('A', 'B', 'C', ...)
// 		lCode := Client_Id[:2]
// 		lTaskId := Client_Id[3:] + currentChar
// 		lTaskId = Client_Id + lCode + lTaskId
// 	}
// }

func GenerateClientId() (string, error) {
	log.Println("GetQueriesDetails +")
	// create local variable to hold savings Amount
	var ClientId string
	var lClientId string
	// Establish DB Connection
	lDb, lErr := dbconnect.LocalDbConnect()
	if lErr != nil {
		log.Println("GenerateClientId:001", lErr.Error())
		return lClientId, fmt.Errorf("GenerateClientId:001" + lErr.Error())
	} else {
		defer lDb.Close()
		lCoreString := ` select NVL(MAX(client_Id),'') client_Id 
from client cm `
		lStmt, lErr := lDb.Prepare(lCoreString)
		if lErr != nil {
			log.Println("GenerateClientId:002", lErr.Error())
			return lClientId, fmt.Errorf("GenerateClientId:002" + lErr.Error())
		} else {
			defer lStmt.Close()

			// Execute the prepared statement
			lRows, lErr := lStmt.Query()
			// lRows, lErr := lDb.Query(lCoreString)
			if lErr != nil {
				log.Println("GenerateClientId:003", lErr.Error())
				return lClientId, fmt.Errorf("GenerateClientId:003" + lErr.Error())
			} else {
				defer lRows.Close()
				for lRows.Next() {
					lErr := lRows.Scan(&ClientId)
					if lErr != nil {
						log.Println("GenerateClientId:004", lErr.Error())
						return lClientId, fmt.Errorf("GenerateClientId:004" + lErr.Error())
					} else {
						log.Println("ClientId******8", ClientId)
						if ClientId == "" {
							lClientId = "FT0001"
						} else {
							ClientId = strings.Trim(ClientId, "FT")
							pTopicId, _ := strconv.Atoi(ClientId)
							pTopicId += 1
							lClientId = fmt.Sprintf("FT%04d", pTopicId)
							log.Println("lClientId", lClientId)
						}
					}
				}
			}
		}
	}
	log.Println("GenerateClientId -")
	return lClientId, nil
}

func PostClientDetails(pClientDeailsRec ClientDetailsStruct) (string, error) {

	log.Println("InsertClientDetails(+)")
	var Client_Id string

	lDb, lErr := dbconnect.LocalDbConnect()

	if lErr != nil {
		log.Println("REPCD:001" + lErr.Error())
		return Client_Id, fmt.Errorf("REPCD:001" + lErr.Error())

	} else {
		defer lDb.Close()

		lClient_Id, lErr := GenerateClientId()
		if lErr != nil {
			log.Println("REPCD:002" + lErr.Error())
			return lClient_Id, fmt.Errorf("REPCD:002" + lErr.Error())
		} else {
			Client_Id = lClient_Id
		}
		if pClientDeailsRec.Role == "" {
			pClientDeailsRec.Role = "client"
		}
		fmt.Println("Password", pClientDeailsRec.Password)

		if strings.Contains(pClientDeailsRec.Password, "%") {
			pClientDeailsRec.Password = strings.ReplaceAll(pClientDeailsRec.Password, "%", "%%")

		}
		fmt.Println("Password", pClientDeailsRec.Password)
		lInsertString := `insert into client (client_Id ,first_name,last_name,email,phone_number,pan_card,nominee_name,kyc_status,password,role,created_by,updated_by,updated_date,created_date) values(?,?,?,?,?,?,?,?,?,?,?,?,now(),now())`

		log.Println(Client_Id)
		lResult, lErr := lDb.Exec(
			lInsertString,
			Client_Id,
			pClientDeailsRec.First_name,
			pClientDeailsRec.Last_name,
			pClientDeailsRec.Email,
			pClientDeailsRec.Phone_number,
			pClientDeailsRec.Pan_card,
			pClientDeailsRec.Nominee_name,
			"N",
			pClientDeailsRec.Password,
			pClientDeailsRec.Role,
			Client_Id,
			Client_Id,
		)
		if lErr != nil {
			log.Println("REPCD :003 ", lErr.Error())
			return lClient_Id, fmt.Errorf("REPCD :003" + lErr.Error())
		} else {
			pClientDeailsRows, _ := lResult.RowsAffected()
			log.Printf("Inserted Row(s): %d\n", pClientDeailsRows)
		}
	}
	log.Println("InsertClientDetails(-)")
	return Client_Id, nil
}

type ClientVerifyStruct struct {
	ClientStatus     string              `json:"clientStatus"`
	ClientDetailsRec ClientDetailsStruct `json:"clientDetailsRec"`
}

// (LoginClientDetailsRespStruct, error)
func VerifyClientDetials(pLoginClientDetailsReqStruct LoginClientDetailsReqStruct) (lClientVerifyStruct ClientVerifyStruct, lErr error) {
	log.Println("VerifyClientDetials(+)")
	// var lLoginClientDetailsRespStruct LoginClientDetailsRespStruct
	lDb, lErr := dbconnect.LocalDbConnect()

	if lErr != nil {
		log.Println("REVCD:001" + lErr.Error())
		// return lLoginClientDetailsRespStruct, fmt.Errorf("REVCD:001" + lErr.Error())
	} else {
		defer lDb.Close()

		lSqlString := ` select case when count(*)>0 then (select case when count(*) > 0 then
"S" else "IP" end as Password from client where client_Id =? and password =?) 
 else "IC" end as clientStatus ,nvl(client_Id,"") as client_Id ,nvl(first_name,"")as first_name ,nvl(last_name,"")as last_name ,nvl(email,"") as email ,nvl(phone_number,"") as phone_number ,nvl(pan_card,"") as pan_card ,nvl(nominee_name,"") as nominee_name ,nvl(kyc_status,"") as kyc_status ,nvl(role,"")
 from client
 where client_Id =?`

		lRows, lErr := lDb.Query(lSqlString, pLoginClientDetailsReqStruct.ClientId, pLoginClientDetailsReqStruct.Password, pLoginClientDetailsReqStruct.ClientId)

		fmt.Println("lRows", lRows)
		fmt.Println("lErr", lErr)

		if lErr != nil {
			return lClientVerifyStruct, fmt.Errorf(lErr.Error())
		} else {
			defer lRows.Close()
			for lRows.Next() {
				lErr := lRows.Scan(
					&lClientVerifyStruct.ClientStatus,
					&lClientVerifyStruct.ClientDetailsRec.Client_Id,
					&lClientVerifyStruct.ClientDetailsRec.First_name,
					&lClientVerifyStruct.ClientDetailsRec.Last_name,
					&lClientVerifyStruct.ClientDetailsRec.Email,
					&lClientVerifyStruct.ClientDetailsRec.Phone_number,
					&lClientVerifyStruct.ClientDetailsRec.Pan_card,
					&lClientVerifyStruct.ClientDetailsRec.Nominee_name,
					&lClientVerifyStruct.ClientDetailsRec.Kyc_status,
					&lClientVerifyStruct.ClientDetailsRec.Role,
				)

				if lErr != nil {
					return lClientVerifyStruct, fmt.Errorf(lErr.Error())
				} else {
					log.Println(lClientVerifyStruct)

				}

			}
		}

		// if lErr != nil {
		// 	return lLoginClientDetailsRespStruct, fmt.Errorf("REVCD :002" + lErr.Error())
		// } else {
		// 	defer lRows.Close()
		// 	for lRows.Next() {
		// 		lErr := lRows.Scan(
		// 			&pLoginClientDetailsReqStruct.ClientId,
		// 			&pLoginClientDetailsReqStruct.Password,
		// 		)
		// 		if lErr != nil {
		// 			return lLoginClientDetailsRespStruct, fmt.Errorf(lErr.Error())
		// 		}else{

		// 		}
		// 	}
		// }

	}
	return lClientVerifyStruct, nil
}

//Update

func UpdateClientDetails(pUpdateClientArr []UpdateClientStruct) error {
	log.Println("UpdateClientDetails(+)")
	lDb, lErr := dbconnect.LocalDbConnect()
	if lErr != nil {
		log.Println("REUCD: 001", lErr.Error())
		return fmt.Errorf("REUCD: 001", lErr.Error())

	} else {
		defer lDb.Close()

		for _, details := range pUpdateClientArr {
			lSqlString := `UPDATE client SET kyc_status=? WHERE client_Id=?`
			lResult, lErr := lDb.Exec(lSqlString, details.KycStatus, details.ClientId)
			fmt.Println(lResult, lErr)

			if lErr != nil {
				log.Println("REUCD: 002", lErr.Error())
				return fmt.Errorf("REUCD: 002", lErr.Error())
			} else {
				pUpdatedRows, _ := lResult.RowsAffected()
				log.Println("Updated Row(s): %d \n", pUpdatedRows)
			}
		}

		// lSqlString := `UPDATE client_master SET kyc_status=? WHERE client_Id=?`

		// lResult, lErr := lDb.Exec(lSqlString, pUpdateClientArr[].KycStatus, pClientRec.Client_Id)

		// if lErr != nil {
		// 	log.Println("REUCD: 002", lErr.Error())
		// 	return fmt.Errorf("REUCD: 002", lErr.Error())
		// } else {
		// 	pUpdatedRows, _ := lResult.RowsAffected()
		// 	log.Println("Updated Row(s): %d \n", pUpdatedRows)
		// }
		log.Println("UpdateClientDetails(-)")
		return nil
	}

}
