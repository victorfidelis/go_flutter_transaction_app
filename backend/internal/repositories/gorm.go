package repositories

import (
	"backend/internal/app/models"
	"fmt"
	"sync"

	"backend/internal/config"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var (
	db     *gorm.DB
	dbOnce sync.Once
	dbErr  error
)

func GetGorm() (*gorm.DB, error) {
	dbOnce.Do(func() {

		db, dbErr = connectDatabase()
		if dbErr != nil {
			return
		}

		sqlDB, _ := db.DB()
		sqlDB.SetMaxIdleConns(10)
		sqlDB.SetMaxOpenConns(100)

		dbErr = autoMigrate()
		if dbErr != nil {
			return
		}
	})
	return db, dbErr
}

func connectDatabase() (*gorm.DB, error) {
	dsn := fmt.Sprintf("host=%s user=%s password=%s dbname=%s port=%s sslmode=disable",
		config.DbConfig.Host, config.DbConfig.User, config.DbConfig.Password, config.DbConfig.Name,
		config.DbConfig.Port)
	fmt.Println(dsn)

	DB, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})

	fmt.Println(err)
	if err != nil {
		return nil, err
	}

	return DB, nil
}

func autoMigrate() error {
	return db.AutoMigrate(
		&models.Transaction{},
	)
}
