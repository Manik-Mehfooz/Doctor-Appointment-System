
var app = angular.module("modDashboard", ['ui.bootstrap']);

app.controller("ctrlDashboard", function ($scope, $http, $modal, $log) {
    $scope.itemsPerPage = 5;
    $scope.currentPage = 0;
    $scope.ModalAddMsg = "Add New Dashboard";
    $scope.ModalUpdateMsg = "Update Dashboard";
    $scope.Field1Name = "Dashboard";
    $scope.GetInvoicesDetail = function () {
        $http({
            method: "get",
            url: "../Users/GetTodayInvoices"
        }).then(function (response) {
            $scope.ddSaleDetail = response.data;
        }, function () {
            alert("Error Occur");
        })
    };
    
    $scope.showForm = function (id, CheckStr, objDashboard) {
        modalName = "InvoiceSalesView.html";


        if (CheckStr == "ViewSale") {
            $scope.GetInvoicesDetail();
            modalName = "InvoiceSalesView.html";
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
        $scope.SalesStyle = {};
        $scope.SalesStyle.SalesStyleID = varID;
        $scope.SalesStyle.SalesStyle1 = $scope.userForm.Field1;

        if (varID > 0) {
            MethodName = "UpdateData";
        }
        $http({
            method: "post",
            url: MethodName,
            datatype: "json",
            data: JSON.stringify($scope.SalesStyle)
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
    $scope.submitForm = function () {
        if ($scope.form.userForm.$valid) {
            console.log('user form is in scope');
            $modalInstance.close('closed');
            $scope.SalesStyle = {};
            $scope.SalesStyle.SalesStyleID = varID;
            $scope.SalesStyle.SalesStyle1 = $scope.form.userForm.Field1;
            var MethodName = "InsertData";
        
            $http({
                method: "post",
                url: MethodName,
                datatype: "json",
                data: JSON.stringify($scope.SalesStyle)
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
        $scope.SalesStyle = {};
          
        if (varID > 0) {
            $scope.SalesStyle.SalesStyleID = varID;
            $http({
                method: "post",
                url: "DeleteData",
                datatype: "json",
                data: JSON.stringify($scope.SalesStyle)
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

angular.module('modDashboard').filter('pagination', function () {
    return function (input, start) {
        start = parseInt(start, 10);
        return input.slice(start);
    };
});