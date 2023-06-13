-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema domaciproizvodi
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema domaciproizvodi
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `domaciproizvodi` DEFAULT CHARACTER SET utf8 ;
USE `domaciproizvodi` ;

-- -----------------------------------------------------
-- Table `domaciproizvodi`.`Category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `domaciproizvodi`.`Category` (
  `categoryName` VARCHAR(100) NOT NULL,
  `descriprion` VARCHAR(500) NULL,
  `image` VARCHAR(5000) NULL,
  PRIMARY KEY (`categoryName`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `domaciproizvodi`.`State`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `domaciproizvodi`.`State` (
  `idState` INT NOT NULL,
  `nameState` VARCHAR(60) NOT NULL,
  PRIMARY KEY (`idState`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `domaciproizvodi`.`City`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `domaciproizvodi`.`City` (
  `postalCode` INT NOT NULL,
  `cityName` VARCHAR(60) NOT NULL,
  `State_idState` INT NOT NULL,
  PRIMARY KEY (`postalCode`, `State_idState`),
  INDEX `fk_City_State_idx` (`State_idState` ASC) VISIBLE,
  CONSTRAINT `fk_City_State`
    FOREIGN KEY (`State_idState`)
    REFERENCES `domaciproizvodi`.`State` (`idState`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `domaciproizvodi`.`Address`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `domaciproizvodi`.`Address` (
  `idAddress` VARCHAR(45) NOT NULL,
  `streetName1` VARCHAR(100) NOT NULL,
  `streetNumber1` VARCHAR(45) NOT NULL,
  `streetName2` VARCHAR(100) NULL,
  `streetNumber2` VARCHAR(45) NULL,
  `City_postalCode` INT NOT NULL,
  `City_State_idState` INT NOT NULL,
  PRIMARY KEY (`idAddress`, `City_postalCode`, `City_State_idState`),
  INDEX `fk_Address_City1_idx` (`City_postalCode` ASC, `City_State_idState` ASC) VISIBLE,
  CONSTRAINT `fk_Address_City1`
    FOREIGN KEY (`City_postalCode` , `City_State_idState`)
    REFERENCES `domaciproizvodi`.`City` (`postalCode` , `State_idState`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `domaciproizvodi`.`User`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `domaciproizvodi`.`User` (
  `idUser` INT NOT NULL,
  `username` VARCHAR(60) NOT NULL,
  `email` VARCHAR(60) NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `surname` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `telephone` VARCHAR(20) NULL,
  `activity` TINYINT NULL,
  `Address_idAddress` VARCHAR(45) NOT NULL,
  `Address_City_postalCode` INT NOT NULL,
  `Address_City_State_idState` INT NOT NULL,
  PRIMARY KEY (`idUser`, `Address_idAddress`, `Address_City_postalCode`, `Address_City_State_idState`),
  INDEX `fk_User_Address1_idx` (`Address_idAddress` ASC, `Address_City_postalCode` ASC, `Address_City_State_idState` ASC) VISIBLE,
  CONSTRAINT `fk_User_Address1`
    FOREIGN KEY (`Address_idAddress` , `Address_City_postalCode` , `Address_City_State_idState`)
    REFERENCES `domaciproizvodi`.`Address` (`idAddress` , `City_postalCode` , `City_State_idState`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `domaciproizvodi`.`Producer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `domaciproizvodi`.`Producer` (
  `idProducer` INT NOT NULL,
  `nameProducer` VARCHAR(200) NOT NULL,
  `emailProducer` VARCHAR(60) NOT NULL,
  `telephoneProducer` VARCHAR(20) NOT NULL,
  `User_idUser` INT NOT NULL,
  PRIMARY KEY (`idProducer`, `User_idUser`),
  INDEX `fk_Producer_User1_idx` (`User_idUser` ASC) VISIBLE,
  CONSTRAINT `fk_Producer_User1`
    FOREIGN KEY (`User_idUser`)
    REFERENCES `domaciproizvodi`.`User` (`idUser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `domaciproizvodi`.`Bill`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `domaciproizvodi`.`Bill` (
  `idBill` INT NOT NULL,
  `billNumber` VARCHAR(45) NOT NULL,
  `date` DATE NOT NULL,
  `amount` DECIMAL(6,2) NOT NULL,
  PRIMARY KEY (`idBill`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `domaciproizvodi`.`Order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `domaciproizvodi`.`Order` (
  `idOrder` INT NOT NULL,
  `dateOrder` DATE NOT NULL,
  `totalAmount` DECIMAL(8,2) NULL,
  `status` TINYINT NULL,
  `Bill_idBill` INT NOT NULL,
  `User_idUser` INT NOT NULL,
  `User_Address_idAddress` VARCHAR(45) NOT NULL,
  `User_Address_City_postalCode` INT NOT NULL,
  `User_Address_City_State_idState` INT NOT NULL,
  PRIMARY KEY (`idOrder`, `Bill_idBill`, `User_idUser`, `User_Address_idAddress`, `User_Address_City_postalCode`, `User_Address_City_State_idState`),
  INDEX `fk_Order_Bill1_idx` (`Bill_idBill` ASC) VISIBLE,
  INDEX `fk_Order_User1_idx` (`User_idUser` ASC, `User_Address_idAddress` ASC, `User_Address_City_postalCode` ASC, `User_Address_City_State_idState` ASC) VISIBLE,
  CONSTRAINT `fk_Order_Bill1`
    FOREIGN KEY (`Bill_idBill`)
    REFERENCES `domaciproizvodi`.`Bill` (`idBill`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Order_User1`
    FOREIGN KEY (`User_idUser` , `User_Address_idAddress` , `User_Address_City_postalCode` , `User_Address_City_State_idState`)
    REFERENCES `domaciproizvodi`.`User` (`idUser` , `Address_idAddress` , `Address_City_postalCode` , `Address_City_State_idState`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `domaciproizvodi`.`OrderItem`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `domaciproizvodi`.`OrderItem` (
  `idOrderItem` INT NOT NULL,
  `quantity` DECIMAL NULL,
  `Order_idOrder` INT NOT NULL,
  PRIMARY KEY (`idOrderItem`, `Order_idOrder`),
  INDEX `fk_OrderItem_Order1_idx` (`Order_idOrder` ASC) VISIBLE,
  CONSTRAINT `fk_OrderItem_Order1`
    FOREIGN KEY (`Order_idOrder`)
    REFERENCES `domaciproizvodi`.`Order` (`idOrder`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `domaciproizvodi`.`Product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `domaciproizvodi`.`Product` (
  `idProduct` INT NOT NULL,
  `productName` VARCHAR(100) NOT NULL,
  `productCol` DECIMAL NOT NULL,
  `description` VARCHAR(200) NULL,
  `date` DATE NULL,
  `price` DECIMAL(6,2) NOT NULL,
  `image` VARCHAR(5000) NULL,
  `Category_categoryName` VARCHAR(100) NOT NULL,
  `Producer_idProducer` INT NOT NULL,
  `OrderItem_idOrderItem` INT NOT NULL,
  PRIMARY KEY (`idProduct`, `Category_categoryName`, `Producer_idProducer`, `OrderItem_idOrderItem`),
  INDEX `fk_Product_Category1_idx` (`Category_categoryName` ASC) VISIBLE,
  INDEX `fk_Product_Producer1_idx` (`Producer_idProducer` ASC) VISIBLE,
  INDEX `fk_Product_OrderItem1_idx` (`OrderItem_idOrderItem` ASC) VISIBLE,
  CONSTRAINT `fk_Product_Category1`
    FOREIGN KEY (`Category_categoryName`)
    REFERENCES `domaciproizvodi`.`Category` (`categoryName`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Product_Producer1`
    FOREIGN KEY (`Producer_idProducer`)
    REFERENCES `domaciproizvodi`.`Producer` (`idProducer`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Product_OrderItem1`
    FOREIGN KEY (`OrderItem_idOrderItem`)
    REFERENCES `domaciproizvodi`.`OrderItem` (`idOrderItem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
