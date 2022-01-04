
var app = angular.module("modPatientReg", ['ui.bootstrap']);

app.controller("ctrlPatientReg", function ($scope, $http, $modal, $log) {
    $scope.itemsPerPage = 15;
    $scope.currentPage = 0;
    $scope.ModalAddMsg = "Add New PatientReg";
    $scope.ModalUpdateMsg = "Update PatientReg";
    $scope.Field1Name = "PatientReg";
    $scope.GetAllData = function () {
        $scope.CheckSH = true;

        $http({
            method: "get",
            url: "GetData"
        }).then(function (response) {
            $scope.alldata = response.data;
            $scope.CheckSH = false;

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
    $scope.GetPatientInfo = function (PID) {
        $http({
            method: "get",
            url: "../PatientReg/GetDataByID/" + PID
        }).then(function (response) {
            $scope.ddPatientReg = response.data;
        }, function () {
            alert("Error Occur");
        })
    };
    $scope.GetAvailableRoomNo = function (PatientID) {
        $http({
            method: "get",
            url: "../Room/GetAvailableRoomByPatientID/"+PatientID
        }).then(function (response) {
            $scope.ddRooms = response.data;
        }, function () {
            alert("Error Occur");
        })
    };
    $scope.GetPatientTest = function (PatientID) {
        $http({
            method: "get",
            url: "../PatientDiagnosticTest/GetDataByPatientID/" + PatientID
        }).then(function (response) {
            $scope.ddPatientTestsList = response.data;
        }, function () {
            alert("Error Occur");
        })
    };
    $scope.GetPaymentsOfPatient = function (PatientID) {
        $http({
            method: "get",
            url: " GetPayByPID/" + PatientID
        }).then(function (response) {
            $scope.ddPatPaymentList = response.data; 
        }, function () {
            alert("Error Occur");
        })
    };
    $scope.showForm = function (id, CheckStr, objPatientReg) {
        var modalName = "modal-form.html";
        $scope.userForm = objPatientReg;
         
        $scope.userForm.ePatientID = objPatientReg.PatientID;
        $scope.userForm.eDoctorID = objPatientReg.DoctorID;
        $scope.userForm.eRoomID = objPatientReg.RoomID;
        $scope.userForm.ePatientRegNo = objPatientReg.PatientRegNo;
        $scope.userForm.eFirstName = objPatientReg.FirstName;
        $scope.userForm.eLastName = objPatientReg.LastName;
        $scope.userForm.eMiddleName = objPatientReg.MiddleName;
        $scope.userForm.eTakeCareName = objPatientReg.TakeCareName;
        $scope.userForm.eTakeCareRelation = objPatientReg.TakeCareRelation;
        $scope.userForm.ePatientCNIC = objPatientReg.PatientCNIC;
        $scope.userForm.eTakeCareCNIC = objPatientReg.TakeCareCNIC;
        $scope.userForm.eDateOfBirth = objPatientReg.DateOfBirth;
        $scope.userForm.eGender = objPatientReg.Gender;
        $scope.userForm.eAge = objPatientReg.Age;
        $scope.userForm.eMaritalStatus = objPatientReg.MaritalStatus;
        $scope.userForm.eAddress = objPatientReg.Address;
        $scope.userForm.eCity = objPatientReg.City;
        $scope.userForm.eState = objPatientReg.State;
        $scope.userForm.eCountry = objPatientReg.Country;
        $scope.userForm.eOccupation = objPatientReg.Occupation;
        $scope.userForm.eTelephone = objPatientReg.Telephone;
        $scope.userForm.eMobileNo = objPatientReg.MobileNo;
        $scope.userForm.eGuardianName = objPatientReg.GuardianName;
        $scope.userForm.eGuardianContactNo = objPatientReg.GuardianContactNo;
        $scope.userForm.eReferBy = objPatientReg.ReferBy;
        $scope.userForm.eAnaesthetist = objPatientReg.Anaesthetist;
        $scope.userForm.eDiagnosis = objPatientReg.Diagnosis;
        $scope.userForm.eAdmissionDate = objPatientReg.AdmissionDate;
        $scope.userForm.eSurgeryDate = objPatientReg.SurgeryDate;
        $scope.userForm.eDischargeDate = objPatientReg.DischargeDate;
        $scope.userForm.eIsDischarge = objPatientReg.IsDischarge;
        $scope.userForm.eRemarks = objPatientReg.Remarks;


        if (CheckStr == "View") {
            //$scope.GetPatientInfo(id);
            modalName = "PatientRegViewmodal.html";
        }
        else if (CheckStr == "AllotedRoom") {
            $scope.GetAvailableRoomNo(id);
            $scope.RoomID = objPatientReg.RoomID;
            $scope.RoomNo = objPatientReg.Room;
            console.log(objPatientReg);
            modalName = "AllotedRoomform.html";
        }
        else if (CheckStr == "PatientTest") {
            $scope.GetPatientTest(id);
            $scope.TitleInfo = objPatientReg.PatientRegNo + ' ' + objPatientReg.FirstName + ' ' + objPatientReg.LastName;
            modalName = "PatientTestView.html";
        }
        else if (CheckStr == "PatientPayments") {  
            $scope.TitleInfo = objPatientReg.PatientRegNo + ' ' + objPatientReg.FirstName + ' ' + objPatientReg.LastName;
            modalName = "PatientPaymentsView.html";
            $scope.GetPaymentsOfPatient(id);
        } 
        //if (CheckStr != "IsSurgery") {
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
            }
        );
       // }

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
        console.log("Msg :"+$scope.DisplayMsg);
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
    
    $scope.cancel = function () {
        $modalInstance.dismiss('cancel');
    };
    $scope.form = {};
    $scope.UpdateRecord = function () {
        console.log('user form is in scope');
        $modalInstance.close('closed');
        $scope.PatientRegStyle = {};
        $scope.PatientRegStyle.PatientRegStyleID = varID;
        $scope.PatientRegStyle.PatientRegStyle1 = $scope.userForm.Field1;

        if (varID > 0) {
            MethodName = "UpdateData";
        }
        $http({
            method: "post",
            url: MethodName,
            datatype: "json",
            data: JSON.stringify($scope.PatientRegStyle)
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
                iconName = "times";
            }
            $scope.showMessage(msg, mode, iconName);

            $scope.GetAllData();
            $scope.Field1 = "";
        })
    };
    $scope.AllotedRoomForm = function () {
        if ($scope.form.userForm.$valid) { 
            $modalInstance.close('closed');
            $scope.PatientReg = {};
            $scope.PatientReg.PatientID = varID;
            $scope.PatientReg.RoomID = $scope.form.userForm.RoomID;
            var MethodName = "AllocateRoom";

            $http({
                method: "post",
                url: MethodName,
                datatype: "json",
                data: JSON.stringify($scope.PatientReg)
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
                    iconName = "times";
                }
                $scope.showMessage(msg, mode, iconName);

                $scope.GetAllData();
            })
        } else {
            console.log('userform is not in scope');
        }
    };
    $scope.submitForm = function () {
        if ($scope.form.userForm.$valid) {
            console.log('user form is in scope');
            $modalInstance.close('closed');
            $scope.PatientRegStyle = {};
            $scope.PatientRegStyle.PatientRegStyleID = varID;
            $scope.PatientRegStyle.PatientRegStyle1 = $scope.form.userForm.Field1;
            var MethodName = "InsertData";
        
            $http({
                method: "post",
                url: MethodName,
                datatype: "json",
                data: JSON.stringify($scope.PatientRegStyle)
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
                    iconName = "times";
                }
                $scope.showMessage(msg, mode, iconName);

                $scope.GetAllData();
                $scope.Field1 = "";
            })
        } else {
            console.log('userform is not in scope');
        }
    };
    $scope.deleteForm = function () {
        console.log('user form is in scope');
        $modalInstance.close('closed');
        $scope.PatientRegStyle = {};
          
        if (varID > 0) {
            $scope.PatientRegStyle.PatientRegStyleID = varID;
            $http({
                method: "post",
                url: "DeleteData",
                datatype: "json",
                data: JSON.stringify($scope.PatientRegStyle)
            }).then(function (response) {
                var msg = "";
                var mode = "";
                var IconName = "";
                if ((response.data) != "0") {
                    msg = "Data Successfully Deleted";
                    mode = "success";
                    IconName = "check";
                }
                else {
                    msg = "Data Not Successfully Deleted";
                    mode = "danger";
                    IconName = "times";
                }
                $scope.showMessage(msg, mode, IconName);

                $scope.GetAllData();
                $scope.Field1 = "";
            })
        }
    };
};

angular.module('modPatientReg').filter('pagination', function () {
    return function (input, start) {
        start = parseInt(start, 10);
        return input.slice(start);
    };
});