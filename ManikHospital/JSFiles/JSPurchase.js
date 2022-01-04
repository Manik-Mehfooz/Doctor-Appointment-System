
var app = angular.module("modPurchase", ['ui.bootstrap']);

app.controller("ctrlPurchase", function ($scope, $http, $modal, $log) {
    $scope.itemsPerPage = 20;
    $scope.currentPage = 0;
    $scope.ModalAddMsg = "Add New Purchase";
    $scope.ModalUpdateMsg = "Update Purchase";
    $scope.Field1Name = "Purchase";
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
    $scope.GetProductsOfPO = function (POID) {
        $http({
            method: "get",
            url: "../Purchase/GetProductByPOID/" + POID
        }).then(function (response) {
            $scope.ddProductsOfPO = response.data;
        }, function () {
            alert("Error Occur");
        })
    };
    $scope.showForm = function (id, CheckStr, objPurchase) {
        var modalName = "modal-form.html";
        if (CheckStr == "DELT") {
            modalName = "delete-form.html";
        }
        
        $scope.message = "Show Form Button Clicked";
        if (id > 0) {
            console.log("The Values is:");
            console.log(objPurchase);
            if (CheckStr == "View") {
                $scope.GetProductsOfPO(id);
                modalName = "ProductsForPO.html";
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
        $scope.PurchaseStyle = {};
        $scope.PurchaseStyle.PurchaseStyleID = varID;
        $scope.PurchaseStyle.PurchaseStyle1 = $scope.userForm.Field1;

        if (varID > 0) {
            MethodName = "UpdateData";
        }
        $http({
            method: "post",
            url: MethodName,
            datatype: "json",
            data: JSON.stringify($scope.PurchaseStyle)
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
            $scope.PurchaseStyle = {};
            $scope.PurchaseStyle.PurchaseStyleID = varID;
            $scope.PurchaseStyle.PurchaseStyle1 = $scope.form.userForm.Field1;
            var MethodName = "InsertData";
        
            $http({
                method: "post",
                url: MethodName,
                datatype: "json",
                data: JSON.stringify($scope.PurchaseStyle)
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
        $scope.PurchaseStyle = {};
          
        if (varID > 0) {
            $scope.PurchaseStyle.PurchaseStyleID = varID;
            $http({
                method: "post",
                url: "DeleteData",
                datatype: "json",
                data: JSON.stringify($scope.PurchaseStyle)
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

angular.module('modPurchase').filter('pagination', function () {
    return function (input, start) {
        start = parseInt(start, 10);
        return input.slice(start);
    };
});