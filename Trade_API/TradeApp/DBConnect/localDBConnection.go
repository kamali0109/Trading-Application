package dbconnect

import (
	"database/sql"
	"fmt"
	"log"

	_ "github.com/go-sql-driver/mysql"
)

func LocalDbConnect() (*sql.DB, error) {
	log.Println("LocalDbConnect(+)")
	connString := fmt.Sprintf("%s:%s@tcp(%s:%d)/%s?allowNativePasswords=true",
		"root", "Kamali0109", "192.168.1.59", 3307, "kamali")
	db, err := sql.Open("mysql", connString)
	if err != nil {
		log.Println(err.Error(), "open connection error")
	} else {
		log.Println("DB Connected...")
	}
	log.Println("LocalDbConnect(-)")
	return db, nil
}
