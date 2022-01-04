
var app = angular.module("modSearch", ['ui.bootstrap']);

app.controller("ctrlSearch", function ($scope, $http, $modal, $log) {
    $scope.itemsPerPage = 15;
    $scope.currentPage = 0;
    $scope.GetCtrlProductData = function () {
        $scope.CheckSH = true;
        $http({
            method: "get",
            url: "../Search/GetCtrlProductData"
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

    $scope.GetCtrlSaleReturnData = function () {
        $scope.CheckSH = true;
        $http({
            method: "get",
            url: "../Search/GetCtrlSaleReturnData"
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

    $scope.GetCtrlRackData = function () {
        $scope.CheckSH = true;
        $http({
            method: "get",
            url: "../Search/GetCtrlRackData"
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

    $scope.GetCtrlPurchaseRequisitionDetailData = function () {
        $scope.CheckSH = true;
        $http({
            method: "get",
            url: "../Search/GetCtrlPurchaseRequisitionDetailData"
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

    $scope.GetCtrlPurchaseRequisitionData = function () {
        $scope.CheckSH = true;
        $http({
            method: "get",
            url: "../Search/GetCtrlPurchaseRequisitionData"
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

    $scope.GetCtrlPurchaseOrderReturnData = function () {
        $scope.CheckSH = true;
        $http({
            method: "get",
            url: "../Search/GetCtrlPurchaseOrderReturnData"
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

    $scope.GetCtrlPurchaseMasterData = function () {
        $scope.CheckSH = true;
        $http({
            method: "get",
            url: "../Search/GetCtrlPurchaseMasterData"
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

    $scope.GetCtrlPurchaseDetailData = function () {
        $scope.CheckSH = true;
        $http({
            method: "get",
            url: "../Search/GetCtrlPurchaseDetailData"
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

    $scope.GetCtrlProductTypeData = function () {
        $scope.CheckSH = true;
        $http({
            method: "get",
            url: "../Search/GetCtrlProductTypeData"
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

    $scope.GetCtrlProductReturnData = function () {
        $scope.CheckSH = true;
        $http({
            method: "get",
            url: "../Search/GetCtrlProductReturnData"
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

    $scope.GetCtrlProductInventoryData = function () {
        $scope.CheckSH = true;
        $http({
            method: "get",
            url: "../Search/GetCtrlProductInventoryData"
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

    $scope.GetCtrlProductData = function () {
        $scope.CheckSH = true;
        $http({
            method: "get",
            url: "../Search/GetCtrlProductData"
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

    $scope.GetCtrlPackSizeData = function () {
        $scope.CheckSH = true;
        $http({
            method: "get",
            url: "../Search/GetCtrlPackSizeData"
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

    $scope.GetCtrlOpeningStockData = function () {
        $scope.CheckSH = true;
        $http({
            method: "get",
            url: "../Search/GetCtrlOpeningStockData"
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

    $scope.GetCtrlMedicalStoreData = function () {
        $scope.CheckSH = true;
        $http({
            method: "get",
            url: "../Search/GetCtrlMedicalStoreData"
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

    $scope.GetCtrlExpensesTypeData = function () {
        $scope.CheckSH = true;
        $http({
            method: "get",
            url: "../Search/GetCtrlExpensesTypeData"
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

    $scope.GetCtrlExpensesData = function () {
        $scope.CheckSH = true;
        $http({
            method: "get",
            url: "../Search/GetCtrlExpensesData"
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

    $scope.GetCtrlErrorLogData = function () {
        $scope.CheckSH = true;
        $http({
            method: "get",
            url: "../Search/GetCtrlErrorLogData"
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

    $scope.GetCtrlContactTypeData = function () {
        $scope.CheckSH = true;
        $http({
            method: "get",
            url: "../Search/GetCtrlContactTypeData"
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

    $scope.GetCtrlContactData = function () {
        $scope.CheckSH = true;
        $http({
            method: "get",
            url: "../Search/GetCtrlContactData"
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

    $scope.GetCtrlCompanyData = function () {
        $scope.CheckSH = true;
        $http({
            method: "get",
            url: "../Search/GetCtrlCompanyData"
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

    $scope.GetCtrlCityData = function () {
        $scope.CheckSH = true;
        $http({
            method: "get",
            url: "../Search/GetCtrlCityData"
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

    $scope.GetCtrlBarCodeGenerateData = function () {
        $scope.CheckSH = true;
        $http({
            method: "get",
            url: "../Search/GetCtrlBarCodeGenerateData"
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

    $scope.GetCtrlAreaData = function () {
        $scope.CheckSH = true;
        $http({
            method: "get",
            url: "../Search/GetCtrlAreaData"
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

    $scope.GetCtrlUsersData = function () {
        $scope.CheckSH = true;
        $http({
            method: "get",
            url: "../Search/GetCtrlUsersData"
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

    $scope.GetCtrlStrengthData = function () {
        $scope.CheckSH = true;
        $http({
            method: "get",
            url: "../Search/GetCtrlStrengthData"
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

    $scope.GetCtrlStoreInformationData = function () {
        $scope.CheckSH = true;
        $http({
            method: "get",
            url: "../Search/GetCtrlStoreInformationData"
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

    $scope.GetCtrlCurrentStopTableData = function () {
        $scope.CheckSH = true;
        $http({
            method: "get",
            url: "../Search/GetCtrlCurrentStopTableData"
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

    $scope.GetCtrlSalesMasterData = function () {
        $scope.CheckSH = true;
        $http({
            method: "get",
            url: "../Search/GetCtrlSalesMasterData"
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

    $scope.GetCtrlSalesDetailData = function () { 
        $scope.CheckSH = true;
        $http({
            method: "get",
            url: "../Search/GetCtrlSalesDetailData"
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

    $scope.GetCtrlDepartmentData = function () {
        $scope.CheckSH = true;
        $http({
            method: "get",
            url: "../Search/GetCtrlDepartmentData"
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

    $scope.GetCtrlFeeTypeData = function () {
        $scope.CheckSH = true;
        $http({
            method: "get",
            url: "../Search/GetCtrlFeeTypeData"
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

    $scope.GetCtrlDoctorFeeData = function () {
        $scope.CheckSH = true;
        $http({
            method: "get",
            url: "../Search/GetCtrlDoctorFeeData"
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

    $scope.GetCtrlDoctorTimingData = function () {
        $scope.CheckSH = true;
        $http({
            method: "get",
            url: "../Search/GetCtrlDoctorTimingData"
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

    $scope.GetCtrlRoomData = function () {
        $scope.CheckSH = true;
        $http({
            method: "get",
            url: "../Search/GetCtrlRoomData"
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

    $scope.GetCtrlPatientRegData = function () {
        $scope.CheckSH = true;
        $http({
            method: "get",
            url: "../Search/GetCtrlPatientRegData"
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

    $scope.GetCtrlDiagnosticTestData = function () {
        $scope.CheckSH = true;
        $http({
            method: "get",
            url: "../Search/GetCtrlDiagnosticTestData"
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
     
    $scope.GetCtrlDailyOPDTokenData = function () {
        $scope.CheckSH = true;
        $http({
            method: "get",
            url: "../Search/GetCtrlDailyOPDTokenData"
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

    $scope.GetCtrlOutDoorPatientTestData = function () {
        $scope.CheckSH = true;
        $http({
            method: "get",
            url: "../Search/GetCtrlOutDoorPatientTestData"
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

    $scope.GetCtrlEmplyeeWagesData = function () {
        $scope.CheckSH = true;
        $http({
            method: "get",
            url: "../Search/GetCtrlEmplyeeWagesData"
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

    $scope.showForm = function (id, CheckStr, objSearch) {
        var modalName = "modal-form.html";
        if (CheckStr == "DELT") {
            modalName = "delete-form.html";
        }

        $scope.message = "Show Form Button Clicked";
        if (id > 0) {
            if (CheckStr != "DELT") {
                $scope.userForm = objSearch;
                modalName = "Editmodal-form.html";
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

angular.module('modSearch').filter('pagination', function () {
    return function (input, start) {
        start = parseInt(start, 10);
        return input.slice(start);
    };
});

var ModalInstanceCtrl = function ($scope, $http, $modalInstance, userForm, varID) {

    $scope.cancel = function () {
        $modalInstance.dismiss('cancel');
    };

    //$scope.form = {};
    //$scope.UpdateRecord = function () {
    //    console.log('user form is in scope');
    //    $modalInstance.close('closed');
    //    $scope.BodyStyle = {};
    //    $scope.BodyStyle.BodyStyleID = varID;
    //    $scope.BodyStyle.BodyStyle1 = $scope.userForm.Field1;

    //    if (varID > 0) {
    //        MethodName = "UpdateData";
    //    }
    //    $http({
    //        method: "post",
    //        url: MethodName,
    //        datatype: "json",
    //        data: JSON.stringify($scope.BodyStyle)
    //    }).then(function (response) {
    //        var msg = "";
    //        var mode = "";
    //        var iconName = "";
    //        if (varID > 0) {
    //            Operation = "Updated";
    //        }
    //        if ((response.data) != "0") {
    //            msg = "Data Successfully " + Operation;
    //            mode = "success";
    //            iconName = "check";
    //        }
    //        else {
    //            msg = "Data Not Successfully " + Operation;
    //            mode = "danger";
    //            iconName = "times";
    //        }
    //        $scope.showMessage(msg, mode, iconName);

    //        $scope.GetAllData();
    //        $scope.Field1 = "";
    //    })
    //};
    //$scope.submitForm = function () {
    //    if ($scope.form.userForm.$valid) {
    //        console.log('user form is in scope');
    //        $modalInstance.close('closed');
    //        $scope.BodyStyle = {};
    //        $scope.BodyStyle.BodyStyleID = varID;
    //        $scope.BodyStyle.BodyStyle1 = $scope.form.userForm.Field1;
    //        var MethodName = "InsertData";

    //        $http({
    //            method: "post",
    //            url: MethodName,
    //            datatype: "json",
    //            data: JSON.stringify($scope.BodyStyle)
    //        }).then(function (response) {
    //            var msg = "";
    //            var mode = "";
    //            var iconName = "";
    //            var Operation = "Inserted";
    //            if ((response.data) != "0") {
    //                msg = "Data Successfully " + Operation;
    //                mode = "success";
    //                iconName = "check";
    //            }
    //            else {
    //                msg = "Data Not Successfully " + Operation;
    //                mode = "danger";
    //                iconName = "times";
    //            }
    //            $scope.showMessage(msg, mode, iconName);

    //            $scope.GetAllData();
    //            $scope.Field1 = "";
    //        })
    //    } else {
    //        console.log('userform is not in scope');
    //    }
    //};
    //$scope.deleteForm = function () {
    //    console.log('user form is in scope');
    //    $modalInstance.close('closed');
    //    $scope.BodyStyle = {};

    //    if (varID > 0) {
    //        $scope.BodyStyle.BodyStyleID = varID;
    //        $http({
    //            method: "post",
    //            url: "DeleteData",
    //            datatype: "json",
    //            data: JSON.stringify($scope.BodyStyle)
    //        }).then(function (response) {
    //            var msg = "";
    //            var mode = "";
    //            var IconName = "";
    //            if ((response.data) != "0") {
    //                msg = "Data Successfully Deleted";
    //                mode = "success";
    //                IconName = "check";
    //            }
    //            else {
    //                msg = "Data Not Successfully Deleted";
    //                mode = "danger";
    //                IconName = "times";
    //            }
    //            $scope.showMessage(msg, mode, IconName);

    //            $scope.GetAllData();
    //            $scope.Field1 = "";
    //        })
    //    }
    //};

};

