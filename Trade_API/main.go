package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"time"
	registation "trade_API_Folder/TradeApp/Registation"
	trading "trade_API_Folder/TradeApp/Trading"
)

func main() {

	f, err := os.OpenFile("logfolder/logfile"+time.Now().Format("02012006.15.04.05.000000000")+".txt", os.O_RDWR|os.O_CREATE|os.O_APPEND, 0666)
	if err != nil {
		log.Fatalf("error opening file: %v", err)
	} else {
		defer f.Close()
		mw := io.MultiWriter(os.Stdout, f)
		// mw :=
		log.SetOutput(mw)

	}

	detials, err := registation.GetClientMasterDetails()

	fmt.Println(detials, err)

	//Insert....

	// insertDetials := registation.ClientDetailsStruct{
	// 	Client_Id:    "FT0002",
	// 	First_name:   "biller",
	// 	Last_name:    "b",
	// 	Email:        "biller@gmail.com",
	// 	Phone_number: "9829783247",
	// 	Pan_card:     "EDCBA0021F",
	// 	Nominee_name: "Nbiller",
	// 	Kyc_status:   "N",
	// 	Password:     "biller@123",
	// 	Role:         "biller",
	// }

	// lErr := registation.InsertClientDetails(insertDetials)
	// print(lErr)

	// for i := 0; i < len(detials); i++ {
	// 	fmt.Println(detials[i])
	// 	lErr := registation.InsertClientDetails(detials[i])
	// 	print(lErr)
	// }

	//update
	// updateClientRec := registation.UpdateClientStruct{KycStatus: "P", ClientId: "FT0003"}

	// for i, detials := range detials {

	// 	fmt.Println(detials, i)

	// 	lErr := registation.UpdateClientDetails(detials)

	// 	print(lErr)
	// }

	http.HandleFunc("/postClientDetails", registation.PostRegisterClientMasterAPI)
	http.HandleFunc("/verifyClientDetails", registation.LoginVerifyClientDetialsAPI)
	http.HandleFunc("/updateClientDetails", registation.PutClientMasterAPI)
	http.HandleFunc("/getClientDetails", registation.GetClientMasterAPI)
	http.HandleFunc("/getScriptMasterDetails", trading.GetScriptMasterDetailsAPI)
	http.HandleFunc("/postTradeHistoryAPI", trading.PostTradeHistoryAPI)
	http.HandleFunc("/postPurchaseTrade", trading.PurchaseTradeAPI)
	http.HandleFunc("/updatetrade", trading.UpdateTradeStatus1)
	http.HandleFunc("/updatebilling", trading.UpdateBillingStatus)
	http.HandleFunc("/tradedelete", trading.TradeDeleteApi)
	log.Println(registation.GenerateClientId())

	log.Println("Server Started")
	// registation.VerifyClientDetials(registation.LoginClientDetailsReqStruct{ClientId: "FT0001", Password: "admin@123"})
	http.ListenAndServe(":12345", nil)

}
