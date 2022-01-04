
var app = angular.module("modVehicle", ['ui.bootstrap']);

app.controller("ctrlVehicle", function ($scope, $http, $modal, $log) {
    $scope.itemsPerPage = 5;
    $scope.currentPage = 0;
    $scope.ModalAddMsg = "Add New Vehicle";
    $scope.ModalUpdateMsg = "Update Vehicle";
    $scope.GetContact = function () {
        $http({
            method: "get",
            url: "../Contact/GetData"
        }).then(function (response) {
            $scope.ddContact = response.data;
        }, function () {
            alert("Error Occur");
        })
    };
    $scope.GetContactByType = function (typeName) {
        $http({
            method: "get",
            url: "../Contact/GetContactByType/"+typeName
        }).then(function (response) {
            if (typeName == "AdminAndStaff") {
                $scope.ddContactAdminStaff = response.data;
            }
            else if (typeName == "CUSTOMER") {
                $scope.ddContactCustomer = response.data;
            }
            else {
                $scope.ddContactAgent = response.data;
            }
        }, function () {
            alert("Error Occur");
        })
    };
    $scope.GetMake = function () {
        $http({
            method: "get",
            url: "../Maker/GetData"
        }).then(function (response) {
            $scope.ddMake = response.data;
        }, function () {
            alert("Error Occur");
        })
    };
    $scope.GetModel = function () {
        $http({
            method: "get",
            url: "../Model/GetData"
        }).then(function (response) {
            $scope.ddModel = response.data;
        }, function () {
            alert("Error Occur");
        })
    };
    $scope.GetColor = function () {
        $http({
            method: "get",
            url: "../Color/GetData"
        }).then(function (response) {
            $scope.ddColor = response.data;
        }, function () {
            alert("Error Occur");
        })
    };
    $scope.GetFuelType = function () {
        $http({
            method: "get",
            url: "../FuelType/GetData"
        }).then(function (response) {
            $scope.ddFuelType = response.data;
        }, function () {
            alert("Error Occur");
        })
    };
    $scope.GetStatus = function () {
        $http({
            method: "get",
            url: "../Status/GetData"
        }).then(function (response) {
            $scope.ddStatus = response.data;
        }, function () {
            alert("Error Occur");
        })
    };
    $scope.GetBodyStyle = function () {
        $http({
            method: "get",
            url: "../BodyStyle/GetData"
        }).then(function (response) {
            $scope.ddBodyStyle = response.data;
        }, function () {
            alert("Error Occur");
        })
    };
    $scope.GetTransmission = function () {
        $http({
            method: "get",
            url: "../Transmission/GetData"
        }).then(function (response) {
            $scope.ddTransmission = response.data;
        }, function () {
            alert("Error Occur");
        })
    };
    $scope.GetCylender = function () {
        $http({
            method: "get",
            url: "../Cylender/GetData"
        }).then(function (response) {
            $scope.ddCylender = response.data;
        }, function () {
            alert("Error Occur");
        })
    };
    $scope.GetALLVehFeatures = function () {
        $http({
            method: "get",
            url: "../Features/GetData"
        }).then(function (response) {
            $scope.ALLFeatures = response.data;
        }, function () {
            alert("Error Occur");
        })
    };
    $scope.GetFeaturesByVehID = function (VehID) {
        $http({
            method: "get",
            url: "../Vehicle/GetFeaturesByVehID/"+VehID
        }).then(function (response) {
            $scope.SelectedVehicleFeatures = response.data;
        }, function () {
            alert("Error Occur");
        })
    };
    $scope.GetSelectOrUnSelectedFeaturesByVehID = function (VehID) {
        $http({
            method: "get",
            url: "../Vehicle/GetSelectOrUnSelectedFeaturesByVehID/" + VehID
        }).then(function (response) {
            $scope.SelectedorUnselectedVehicleFeatures = response.data;
        }, function () {
            alert("Error Occur");
        })
    };
    $scope.GetExpensesType = function () {
        $http({
            method: "get",
            url: "../ExpensesType/GetData"
        }).then(function (response) {
            $scope.ddExpensesType = response.data;
        }, function () {
            alert("Error Occur");
        })
    };
    $scope.GetVehicle = function () {
        $http({
            method: "get",
            url: "../Vehicle/GetData"
        }).then(function (response) {
            $scope.ddVehicle = response.data;
        }, function () {
            alert("Error Occur");
        })
    };
    $scope.GetVehicleList = function (SaleMethod) {
        var urlValue = "";
        if (SaleMethod != "Installment") {
            urlValue = "../rptVehicleDetail/BindVehicleList"
        }
        else {
            urlValue = "../RptVehicleInstallments/BindVehicleList"
        }
        $http({
            method: "get",
            url: urlValue
        }).then(function (response) {
            $scope.ddVehicleList = response.data;
        }, function () {
            alert("Error Occur");
        })
    };
    $scope.GetVehTotalExpensesAmount = function (VehID) {
        $http({
            method: "get",
            url: "../Vehicle/GetVehTotalExpenses/"+VehID
        }).then(function (response) {
            $scope.TotalVehExpenseAmount = response.data;
        }, function () {
            alert("Error Occur");
        })
    };
    $scope.GetVehicleExpenses = function (VehID) {
        $http({
            method: "get",
            url: "../Vehicle/GetVehExpensesByID/" + VehID
        }).then(function (response) {
            $scope.ddVehicleExp = response.data;
        }, function () {
            alert("Error Occur");
        })
    };
    $scope.GetAutoGeneratedSaleINVNo = function () {
        $http({
            method: "get",
            url: "../Vehicle/AutoGenerateSaleINVNo"
        }).then(function (response) {
            $scope.SaleINVNumber = response.data;
        }, function () {
            alert("Error Occur");
        })
    };
    $scope.GetVehicleInstallmentsForPaid = function (VehID) {
        $http({
            method: "get",
            url: "../Instalments/GetInstallmentByVehicleIDPaid/"+VehID
        }).then(function (response) {
            $scope.VehicleInstallmentsForPaid = response.data;
        }, function () {
            alert("Error Occur");
        })
    };
    $scope.GetVehicleInstallmentsForUnPaid = function (VehID) {
        $http({
            method: "get",
            url: "../Instalments/GetInstallmentByVehicleIDUnPaid/" + VehID
        }).then(function (response) {
            $scope.VehicleInstallmentsForUnPaid = response.data;
        }, function () {
            alert("Error Occur");
        })
    };
    $scope.GetVehicleSaleDetail = function (VehID) {
        $http({
            method: "get",
            url: "../Vehicle/GetSaleDetail/" + VehID
        }).then(function (response) {
            $scope.VehicleSaleDetail = response.data;
        }, function () {
            alert("Error Occur");
        })
    };
    $scope.GetAllData = function () {
        $scope.CheckSH = true;
        $scope.GetContact();
        $scope.GetMake();
        $scope.GetModel();
        $scope.GetColor();
        $scope.GetFuelType();
        $scope.GetBodyStyle();
        $scope.GetTransmission();
        $scope.GetCylender();
        $scope.GetExpensesType();
        $scope.GetVehicle();
        $scope.GetStatus();
        $http({
            method: "get",
            url: "GetData"
        }).then(function (response) {
            $scope.alldata = response.data;
            $scope.CheckSH = false;


            $scope.currentPage = 0;
            //$scope.itemsPerPage = 3;
            //$scope.datalists = response.data;

            $scope.range = function () {
                var rangeSize = $scope.pageCount() + 1;
                console.log('Page count is :' + rangeSize);
                var ps = [];
                var start;

                start = $scope.currentPage;
                if (start > $scope.pageCount() - rangeSize) {
                    start = $scope.pageCount() - rangeSize + 1;
                }

                for (var i = start; i < start + rangeSize; i++) {
                    ps.push(i);
                }
                return ps;
            };
            $scope.prevPage = function () {
                if ($scope.currentPage > 0) {
                    $scope.currentPage--;
                }
            };
            $scope.DisablePrevPage = function () {
                return $scope.currentPage === 0 ? "disabled" : "";
            };
            $scope.pageCount = function () {
                //return Math.ceil($scope.alldata.length / $scope.itemsPerPage) - 1;
                return Math.ceil($scope.alldata.length / $scope.itemsPerPage) - 1;
            };
            $scope.nextPage = function () {
                if ($scope.currentPage < $scope.pageCount()) {
                    $scope.currentPage++;
                }
            };
            $scope.DisableNextPage = function () {
                return $scope.currentPage === $scope.pageCount() ? "disabled" : "";
            };
            $scope.setPage = function (n) {
                $scope.currentPage = n;
            };

        }, function () {
            alert("Error Occur");
        })
    };
    $scope.showForm = function (id, CheckStr, objVehicle) {
        var modalName = "Vehiclemodal-form.html";
        $scope.GlobalVehID = 0;
        if (CheckStr == "DELT") {
            modalName = "delete-form.html";
        }

        $scope.message = "Show Form Button Clicked";
        if (id > 0) {
            console.log("The Values is:");
            console.log(objVehicle);
            if (CheckStr == "AddInstalments") {
                modalName = "VehicleInstalmentmodal-form.html";
                $scope.GetVehicleInstallmentsForPaid(id);
                $scope.GetVehicleInstallmentsForUnPaid(id);
                $scope.SelectedVehicle = objVehicle.ModelName + ' ' + objVehicle.ModelYear + ' Color ' + objVehicle.ColorName;
            }
            else if (CheckStr == "AddFeatures") {
                modalName = "AddFeatures.html";
                //$scope.GetALLVehFeatures();
                $scope.GetSelectOrUnSelectedFeaturesByVehID(id);
                $scope.GlobalVehID = id;
            }
            else if (CheckStr == "AddImages") {
                modalName = "AddImage.html";

            }
            else if (CheckStr == "SaleVeh") {
                $scope.SelectedVehicle = objVehicle.ModelName + ' ' + objVehicle.ModelYear + ' Color ' + objVehicle.ColorName;
                modalName = "VehicleSalemodal-form.html";
                $scope.GetContactByType("CUSTOMER");
                $scope.GetContactByType("AGENT");
                $scope.GetContactByType("AdminAndStaff");
                $scope.GetVehTotalExpensesAmount(id);
                $scope.GetAutoGeneratedSaleINVNo();

                //$scope.userForm.SaleAmount = $scope.totalVehExpenseAmount;



                //$scope.SelectedVehicle = objVehicle.ModelName + ' ' + objVehicle.ModelYear + ' Color ' + objVehicle.ColorName;
            }
            else if (CheckStr == "AddExpenses") {
                modalName = "VehicleExpensesmodal-form.html";
                $scope.SelectedVehicle = objVehicle.ModelName + ' ' + objVehicle.ModelYear + ' Color ' + objVehicle.ColorName;
            }
            else if ((CheckStr == "EDIT") || (CheckStr == "DETAIL")) {
                $scope.userForm = objVehicle;

                // $scope.userForm.eVehicleID = objVehicle.VehicleID;
                $scope.userForm.eContactID = objVehicle.ContactID;
                $scope.userForm.eStockNo = objVehicle.StockNo;
                $scope.userForm.eMakerID = objVehicle.MakerID;
                $scope.userForm.eModelID = objVehicle.ModelID;
                $scope.userForm.eColorID = objVehicle.ColorID;
                $scope.userForm.eFuelTypeID = objVehicle.FuelTypeID;
                $scope.userForm.eBodyStyleID = objVehicle.BodyStyleID;
                $scope.userForm.eTransmissionID = objVehicle.TransmissionID;
                $scope.userForm.eCylinderID = objVehicle.CylinderID;
                $scope.userForm.eMileage = objVehicle.Mileage;
                $scope.userForm.eEngineNo = objVehicle.EngineNo;
                $scope.userForm.eChasisNo = objVehicle.ChasisNo;
                $scope.userForm.ePurchaseDate = objVehicle.PurchaseDate;
                $scope.userForm.ePurchaseAmount = objVehicle.PurchaseAmount;
                $scope.userForm.ePurchaseNotes = objVehicle.PurchaseNotes;
                $scope.userForm.ePurchaseStatus = objVehicle.PurchaseStatus;
                $scope.userForm.ePurchaseNumber = objVehicle.PurchaseNumber;
                $scope.userForm.ePurchaseCity = objVehicle.PurchaseCity;
                $scope.userForm.ePurchaseState = objVehicle.PurchaseState;
                $scope.userForm.eHolder = objVehicle.Holder;
                $scope.userForm.eHolderContact = objVehicle.HolderContact;
                $scope.userForm.eOtherNotes = objVehicle.OtherNotes;
                $scope.userForm.eStatus = objVehicle.Status;

                modalName = "VehicleEditmodal-form.html";

                if (CheckStr == "DETAIL") {
                    modalName = "VehicleViewmodal-form.html";
                    $scope.userForm.ePicture1 = objVehicle.Picture1;
                    $scope.userForm.ePicture2 = objVehicle.Picture2;
                    $scope.userForm.ePicture3 = objVehicle.Picture3;
                    $scope.userForm.ePicture4 = objVehicle.Picture4;
                    $scope.userForm.ePicture5 = objVehicle.Picture5;


                    $scope.SelectedVehicle = objVehicle.ModelName + ' ' + objVehicle.ModelYear + ' Color ' + objVehicle.ColorName;

                    $scope.GetFeaturesByVehID(id);
                    $scope.GetVehicleExpenses(id);
                    $scope.GetVehicleSaleDetail(id);
                    $scope.GlobalVehID = id;
                }
            }
        }
        console.log($scope.message);
        var modalInstance = $modal.open({
            templateUrl: "../HtmlPages/" + modalName,
            controller: ModalInstanceCtrl,
            scope: $scope,
            backdrop: false,
            resolve: {
                userForm: function () {
                    return $scope.userForm;
                },
                varID: function () {
                    return id;
                }
            }
        });

        modalInstance.result.then(function (selectedItem) {
            $scope.selected = selectedItem;
        }, function () {
            $log.info('Modal dismissed at: ' + new Date());
        });

    };
    $scope.showMessage = function (Msg, AlertMode, AlertIcon) {
        $scope.DisplayMsg = Msg;
        $scope.DisplayMode = AlertMode;
        $scope.DisplayIcon = AlertIcon;
        $scope.message = "Show Message Alert !";
        console.log($scope.message);
        console.log("Msg :" + $scope.DisplayMsg);
        console.log("Alert Mode :" + $scope.DisplayMode);

        var modalInstance = $modal.open({
            templateUrl: '../HtmlPages/modal-message.html',
            controller: ModalInstanceCtrl,
            scope: $scope,
            backdrop: false,
            resolve: {
                userForm: function () {
                    return "";
                },
                varID: function () {
                    return 0;
                }
            }
        });

        modalInstance.result.then(function (selectedItem) {
            $scope.selected = selectedItem;
        }, function () {
            $log.info('Modal dismissed at: ' + new Date());
        });
    };
});

var ModalInstanceCtrl = function ($scope, $http, $modalInstance, userForm, varID) {

    // Features Selection

    $scope.selection = [];
    $scope.toggleSelection = function toggleSelection(FeatureID) {
        var idx = $scope.selection.indexOf(FeatureID);
        if (idx > -1) {
            $scope.selection.splice(idx, 1);
        }
        else {
            $scope.selection.push(FeatureID);
        }
        console.log($scope.selection);
    };

    // End Features Selection

    // Vehicle Images

    $scope.stepsModel = [];
    $scope.imageUpload = function (event) {
        var files = event.target.files; //FileList object

        for (var i = 0; i < files.length; i++) {
            var file = files[i];
            var reader = new FileReader();
            reader.onload = $scope.imageIsLoaded;
            reader.readAsDataURL(file);
        }
    }
    $scope.imageIsLoaded = function (e) {
        $scope.$apply(function () {
            $scope.stepsModel.push(e.target.result);
        });
    }

    // End Vehicle Images

    $scope.cancel = function () {
        $modalInstance.dismiss('cancel');
    };
    $scope.form = {};
    $scope.UpdateRecord = function () {
        console.log('user form is in scope');
        $modalInstance.close('closed');
        $scope.Vehicle = {};
        $scope.Vehicle.VehicleID = varID;

        $scope.userForm.VehicleID = objVehicle.eVehicleID;
        $scope.userForm.ContactID = objVehicle.eContactID;
        $scope.userForm.StockNo = objVehicle.eStockNo;
        $scope.userForm.MakerID = objVehicle.eMakerID;
        $scope.userForm.ModelID = objVehicle.eModelID;
        $scope.userForm.ColorID = objVehicle.eColorID;
        $scope.userForm.FuelTypeID = objVehicle.eFuelTypeID;
        $scope.userForm.BodyStyleID = objVehicle.eBodyStyleID;
        $scope.userForm.TransmissionID = objVehicle.eTransmissionID;
        $scope.userForm.CylinderID = objVehicle.eCylinderID;
        $scope.userForm.Mileage = objVehicle.eMileage;
        $scope.userForm.EngineNo = objVehicle.eEngineNo;
        $scope.userForm.ChasisNo = objVehicle.eChasisNo;
        $scope.userForm.PurchaseDate = objVehicle.ePurchaseDate;
        $scope.userForm.PurchaseAmount = objVehicle.ePurchaseAmount;
        $scope.userForm.PurchaseNotes = objVehicle.ePurchaseNotes;
        $scope.userForm.PurchaseStatus = objVehicle.ePurchaseStatus;
        $scope.userForm.PurchaseNumber = objVehicle.ePurchaseNumber;
        $scope.userForm.PurchaseCity = objVehicle.ePurchaseCity;
        $scope.userForm.PurchaseState = objVehicle.ePurchaseState;
        $scope.userForm.Holder = objVehicle.eHolder;
        $scope.userForm.HolderContact = objVehicle.eHolderContact;
        $scope.userForm.OtherNotes = objVehicle.eOtherNotes;
        //$scope.userForm.Status = objVehicle.eStatus;
        $scope.userForm.Status = "New"

        $scope.userForm.Picture1 = objVehicle.ePicture1;
        $scope.userForm.Picture2 = objVehicle.ePicture2;
        $scope.userForm.Picture3 = objVehicle.ePicture3;
        $scope.userForm.Picture4 = objVehicle.ePicture4;
        $scope.userForm.Picture5 = objVehicle.ePicture5;

        if (varID > 0) {
            MethodName = "UpdateData";
        }
        $http({
            method: "post",
            url: MethodName,
            datatype: "json",
            data: JSON.stringify($scope.Vehicle)
        }).then(function (response) {
            var msg = "";
            var mode = "";
            var iconName = "";
            if (varID > 0) {
                Operation = "Updated";
            }
            if ((response.data) != "0") {
                msg = "Data Successfully " + Operation;
                mode = "success";
                iconName = "check";
            }
            else {
                msg = "Data Not Successfully " + Operation;
                mode = "danger";
                iconName = "close";
            }
            $scope.showMessage(msg, mode, iconName);

            $scope.GetAllData();
            $scope.Field1 = "";
        })
    };
    $scope.submitForm = function () {
        if ($scope.form.userForm.$valid) {
            console.log('user form is in scope');
            $modalInstance.close('closed');
            $scope.Vehicle = {};
            $scope.Vehicle.VehicleID = varID;

            $scope.Vehicle.VehicleID = $scope.form.userForm.VehicleID;
            $scope.Vehicle.ContactID = $scope.form.userForm.ContactID;
            $scope.Vehicle.StockNo = $scope.form.userForm.StockNo;
            $scope.Vehicle.MakerID = $scope.form.userForm.MakerID;
            $scope.Vehicle.ModelID = $scope.form.userForm.ModelID;
            $scope.Vehicle.ColorID = $scope.form.userForm.ColorID;
            $scope.Vehicle.FuelTypeID = $scope.form.userForm.FuelTypeID;
            $scope.Vehicle.BodyStyleID = $scope.form.userForm.BodyStyleID;
            $scope.Vehicle.TransmissionID = $scope.form.userForm.TransmissionID;
            $scope.Vehicle.CylinderID = $scope.form.userForm.CylinderID;
            $scope.Vehicle.Mileage = $scope.form.userForm.Mileage;
            $scope.Vehicle.EngineNo = $scope.form.userForm.EngineNo;
            $scope.Vehicle.ChasisNo = $scope.form.userForm.ChasisNo;
            $scope.Vehicle.PurchaseDate = $scope.form.userForm.PurchaseDate;
            $scope.Vehicle.PurchaseAmount = $scope.form.userForm.PurchaseAmount;
            $scope.Vehicle.PurchaseNotes = $scope.form.userForm.PurchaseNotes;
            $scope.Vehicle.PurchaseStatus = $scope.form.userForm.PurchaseStatus;
            $scope.Vehicle.PurchaseNumber = $scope.form.userForm.PurchaseNumber;
            $scope.Vehicle.PurchaseCity = $scope.form.userForm.PurchaseCity;
            $scope.Vehicle.PurchaseState = $scope.form.userForm.PurchaseState;
            $scope.Vehicle.Holder = $scope.form.userForm.Holder;
            $scope.Vehicle.HolderContact = $scope.form.userForm.HolderContact;
            $scope.Vehicle.OtherNotes = $scope.form.userForm.OtherNotes;
            //$scope.Vehicle.Status = $scope.form.userForm.Status;
            $scope.Vehicle.StatusID = "1";


            $scope.Vehicle.Picture1 = 'NoImage.png';
            $scope.Vehicle.Picture2 = 'NoImage.png';
            $scope.Vehicle.Picture3 = 'NoImage.png';
            $scope.Vehicle.Picture4 = 'NoImage.png';
            $scope.Vehicle.Picture5 = 'NoImage.png';


            //$scope.Vehicle.Picture1 = $scope.form.userForm.Picture1;
            //$scope.Vehicle.Picture2 = $scope.form.userForm.Picture2;
            //$scope.Vehicle.Picture3 = $scope.form.userForm.Picture3;
            //$scope.Vehicle.Picture4 = $scope.form.userForm.Picture4;
            //$scope.Vehicle.Picture5 = $scope.form.userForm.Picture5;

            var MethodName = "InsertData";

            $http({
                method: "post",
                url: MethodName,
                datatype: "json",
                data: JSON.stringify($scope.Vehicle)
            }).then(function (response) {
                var msg = "";
                var mode = "";
                var iconName = "";
                var Operation = "Inserted";
                if ((response.data) != "0") {
                    msg = "Data Successfully " + Operation;
                    mode = "success";
                    iconName = "check";
                }
                else {
                    msg = "Data Not Successfully " + Operation;
                    mode = "danger";
                    iconName = "close";
                }
                $scope.showMessage(msg, mode, iconName);

                $scope.GetAllData();
                $scope.Field1 = "";
            })
        } else {
            console.log('userform is not in scope');
        }
    };
    $scope.submitVehExpenses = function () {
        if ($scope.form.userForm.$valid) {
            console.log('user form is in scope');
            $modalInstance.close('closed');
            $scope.VehicleExpenses = {};
            //$scope.VehicleExpenses.ExpenseID = varID;

            $scope.VehicleExpenses.VehicleID = varID;
            $scope.VehicleExpenses.VendorID = $scope.form.userForm.VendorID;
            $scope.VehicleExpenses.ExpenseTypeID = $scope.form.userForm.ExpenseTypeID;
            $scope.VehicleExpenses.ExpenseDate = $scope.form.userForm.ExpenseDate;
            $scope.VehicleExpenses.Amount = $scope.form.userForm.Amount;
            $scope.VehicleExpenses.ExpenseNote = $scope.form.userForm.ExpenseNote;
            $scope.VehicleExpenses.EnteredBy = "Admin";
            $scope.VehicleExpenses.EnteredDate = new Date().toDateString();
            $scope.VehicleExpenses.UpdatedBy = "N/A";
            $scope.VehicleExpenses.UpdatedDate = new Date().toDateString();
            $scope.VehicleExpenses.DeletedBy = "N/A";
            $scope.VehicleExpenses.DeletedDate = new Date().toDateString();
            $scope.VehicleExpenses.IsDeleted = 0;

            var MethodName = "InsertVehExpenses";

            $http({
                method: "post",
                url: MethodName,
                datatype: "json",
                data: JSON.stringify($scope.VehicleExpenses)
            }).then(function (response) {
                var msg = "";
                var mode = "";
                var iconName = "";
                var Operation = "Inserted";
                if ((response.data) != "0") {
                    msg = "Data Successfully " + Operation;
                    mode = "success";
                    iconName = "check";
                }
                else {
                    msg = "Data Not Successfully " + Operation;
                    mode = "danger";
                    iconName = "close";
                }
                $scope.showMessage(msg, mode, iconName);

                //$scope.GetAllData();
                //$scope.Field1 = "";
            })
        } else {
            console.log('userform is not in scope');
        }
    };
    $scope.AddVehFeatures = function () {
        if ($scope.form.userForm.$valid) {
            console.log('user form is in scope');
            $modalInstance.close('closed');

            var MethodName = "InsertVehFeatures/" + varID;

            $http({
                method: "post",
                url: MethodName,
                datatype: "json",
                data: JSON.stringify($scope.selection)
            }).then(function (response) {
                var msg = "";
                var mode = "";
                var iconName = "";
                var Operation = "Inserted";
                if ((response.data) != "0") {
                    msg = "Data Successfully " + Operation;
                    mode = "success";
                    iconName = "check";
                }
                else {
                    msg = "Data Not Successfully " + Operation;
                    mode = "danger";
                    iconName = "close";
                }
                $scope.showMessage(msg, mode, iconName);

                //$scope.GetAllData();
                //$scope.Field1 = "";
            })
        } else {
            console.log('userform is not in scope');
        }
    };
    $scope.deleteForm = function () {
        console.log('user form is in scope');
        $modalInstance.close('closed');
        $scope.Vehicle = {};

        if (varID > 0) {
            $scope.Vehicle.VehicleID = varID;
            $http({
                method: "post",
                url: "DeleteData",
                datatype: "json",
                data: JSON.stringify($scope.Vehicle)
            }).then(function (response) {
                var msg = "";
                var mode = "";
                var IconName = "";
                if ((response.data) != "0") {
                    msg = "Data Successfully Deleted";
                    mode = "danger";
                    IconName = "check";
                }
                else {
                    msg = "Data Not Successfully Deleted";
                    mode = "danger";
                    IconName = "close";
                }
                $scope.showMessage(msg, mode, IconName);

                $scope.GetAllData();
                $scope.Field1 = "";
            })
        }
    };
    $scope.AddSaleVehicle = function () {
        if ($scope.form.userForm.$valid) {
            console.log('user form is in scope');
            $modalInstance.close('closed');
            $scope.VehicleSale = {};
            
            //$scope.VehicleSale.VehicleSaleID = $scope.form.userForm.VehicleSaleID;
            $scope.VehicleSale.VehicleID = varID;
            $scope.VehicleSale.CustomerID = $scope.form.userForm.CustomerID;
            $scope.VehicleSale.SaleInvoiceNumber = $scope.SaleINVNumber;
            $scope.VehicleSale.AgentID = $scope.form.userForm.AgentID;
            $scope.VehicleSale.SaleDate = $scope.form.userForm.SaleDate;
            $scope.VehicleSale.SaleMethod = $scope.form.userForm.SaleMethod;
            //$scope.VehicleSale.SaleAmount = $scope.form.userForm.SaleAmount;
            $scope.VehicleSale.SaleAmount = $scope.TotalVehExpenseAmount;
            $scope.VehicleSale.DepositPer = $scope.form.userForm.DepositPer;
            $scope.VehicleSale.DepositPayment = $scope.form.userForm.DepositPayment;
            $scope.VehicleSale.DepositPaymentType = $scope.form.userForm.DepositPaymentType;
            $scope.VehicleSale.PaymentCollectID = $scope.form.userForm.PaymentCollectID;
            $scope.VehicleSale.NoOfInstalments = $scope.form.userForm.NoOfInstalments;
            $scope.VehicleSale.Remarks = $scope.form.userForm.Remarks;


            var MethodName = "InsertSaleVehicle";

            $http({
                method: "post",
                url: MethodName,
                datatype: "json",
                data: JSON.stringify($scope.VehicleSale)
            }).then(function (response) {
                var msg = "";
                var mode = "";
                var iconName = "";
                var Operation = "Inserted";
                if ((response.data) != "0") {
                    msg = "Data Successfully " + Operation;
                    mode = "success";
                    iconName = "check";
                }
                else {
                    msg = "Data Not Successfully " + Operation;
                    mode = "danger";
                    iconName = "close";
                }
                $scope.showMessage(msg, mode, iconName);

                $scope.GetAllData();
                //$scope.Field1 = "";
            })
        } else {
            console.log('userform is not in scope');
        }
    };
    $scope.AddVehInstalment = function () {

        var MethodName = "InsertVehInstalment/" + varID;

        $http({
            method: "post",
            url: MethodName,
            datatype: "json",
            data: JSON.stringify($scope.selection)
        }).then(function (response) {
            var msg = "";
            var mode = "";
            var iconName = "";
            var Operation = "Inserted";
            if ((response.data) != "0") {
                msg = "Data Successfully " + Operation;
                mode = "success";
                iconName = "check";
            }
            else {
                msg = "Data Not Successfully " + Operation;
                mode = "danger";
                iconName = "close";
            }
            $scope.GetVehicleInstallmentsForPaid(varID);
            $scope.GetVehicleInstallmentsForUnPaid(varID);
            $scope.showMessage(msg, mode, iconName);

            //$scope.GetAllData();
            
            //$scope.Field1 = "";
        })
    };
};

angular.module('modVehicle').filter('pagination', function () {
    return function (input, start) {
        start = parseInt(start, 10);
        return input.slice(start);
    };
});
