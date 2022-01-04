using MedicalStore.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Mvc;
using vtsMMC.Models;


namespace vtsMMC.Controllers
{
    public class SearchController : Controller
    {
        JsonResult json = new JsonResult();

        public JsonResult GetCtrlProductData()
        {
            clsProduct obj = new clsProduct();
            List<clsProduct> objList = obj.GetSearchData();
            json.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            json.Data = objList;
            return json;
        } 
        public JsonResult GetCtrlRackData()
        {
            clsRack obj = new clsRack();
            List<clsRack> objList = obj.GetSearchData();
            json.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            json.Data = objList; return json;
        } 
        public JsonResult GetCtrlPurchaseMasterData()
        {
            clsPurchaseMaster obj = new clsPurchaseMaster();
            List<clsPurchaseMaster> objList = obj.GetAllData();
            json.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            json.Data = objList; return json;
        }
        public JsonResult GetCtrlPurchaseDetailData()
        {
            clsPurchaseDetail obj = new clsPurchaseDetail();
            List<clsPurchaseDetail> objList = obj.GetAllData();
            json.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            json.Data = objList; return json;
        }
        public JsonResult GetCtrlProductTypeData()
        {
            clsProductType obj = new clsProductType();
            List<clsProductType> objList = obj.GetSearchData();
            json.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            json.Data = objList; return json;
        }
        public JsonResult GetCtrlProductReturnData()
        {
            clsProductReturn obj = new clsProductReturn();
            List<clsProductReturn> objList = obj.GetSearchData();
            json.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            json.Data = objList; return json;
        }
        public JsonResult GetCtrlOpeningStockData()
        {
            clsOpeningStock obj = new clsOpeningStock();
            List<clsOpeningStock> objList = obj.GetSearchData();
            json.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            json.Data = objList; return json;
        }
        public JsonResult GetCtrlExpensesTypeData()
        {
            clsExpensesType obj = new clsExpensesType();
            List<clsExpensesType> objList = obj.GetSearchData();
            json.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            json.Data = objList; return json;
        }
        public JsonResult GetCtrlExpensesData()
        {
            clsExpenses obj = new clsExpenses();
            List<clsExpenses> objList = obj.GetSearchData();
            json.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            json.Data = objList; return json;
        }
        public JsonResult GetCtrlContactTypeData()
        {
            clsContactType obj = new clsContactType();
            List<clsContactType> objList = obj.GetSearchData();
            json.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            json.Data = objList; return json;
        }
        public JsonResult GetCtrlContactData()
        {
            clsContact obj = new clsContact();
            List<clsContact> objList = obj.GetSearchData();
            json.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            json.Data = objList; return json;
        }
        public JsonResult GetCtrlCompanyData()
        {
            clsCompany obj = new clsCompany();
            List<clsCompany> objList = obj.GetSearchData();
            json.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            json.Data = objList; return json;
        }
        public JsonResult GetCtrlUsersData()
        {
            clsUsers obj = new clsUsers();
            List<clsUsers> objList = obj.GetSearchData();
            json.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            json.Data = objList; return json;
        }
        public JsonResult GetCtrlStrengthData()
        {
            clsStrength obj = new clsStrength();
            List<clsStrength> objList = obj.GetSearchData();
            json.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            json.Data = objList; return json;
        }
        public JsonResult GetCtrlSalesMasterData()
        {
            clsSalesMaster obj = new clsSalesMaster();
            List<clsSalesMaster> objList = obj.GetSearchData();
            json.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            json.Data = objList; return json;
        }
        public JsonResult GetCtrlSalesDetailData()
        {
            clsSalesDetail obj = new clsSalesDetail();
            List<clsSalesDetail> objList = obj.GetSearchData();
            json.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            json.Data = objList; return json;
        }
        public JsonResult GetCtrlProductInventoryData()
        {
            clsStock obj = new clsStock();
            List<clsStock> objList = obj.GetAllProductStock();
            json.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            json.Data = objList; return json;
        }
        public JsonResult GetCtrlDepartmentData()
        {
            clsDepartment obj = new clsDepartment();
            List<clsDepartment> objList = obj.GetAllData();
            json.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            json.Data = objList; return json;
        }
        public JsonResult GetCtrlFeeTypeData()
        {
            clsFeeType obj = new clsFeeType();
            List<clsFeeType> objList = obj.GetAllData();
            json.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            json.Data = objList; return json;
        }
        public JsonResult GetCtrlDoctorFeeData()
        {
            clsDoctorFee obj = new clsDoctorFee();
            List<clsDoctorFee> objList = obj.GetAllData();
            json.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            json.Data = objList; return json;
        }
        public JsonResult GetCtrlDoctorTimingData()
        {
            clsDoctorTiming obj = new clsDoctorTiming();
            List<clsDoctorTiming> objList = obj.GetSearchData();
            json.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            json.Data = objList; return json;
        }
        public JsonResult GetCtrlRoomData()
        {
            clsRoom obj = new clsRoom();
            List<clsRoom> objList = obj.GetAllData();
            json.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            json.Data = objList; return json;
        }
        public JsonResult GetCtrlPatientRegData()
        {
            clsPatientReg obj = new clsPatientReg();
            List<clsPatientReg> objList = obj.GetAllData();
            json.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            json.Data = objList; return json;
        }
        public JsonResult GetCtrlDiagnosticTestData()
        {
            clsDiagnosticTest obj = new clsDiagnosticTest();
            List<clsDiagnosticTest> objList = obj.GetSearchData();
            json.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            json.Data = objList; return json;
        }
        public JsonResult GetCtrlDailyOPDTokenData()
        {
            clsDailyOPDToken obj = new clsDailyOPDToken();
            List<clsDailyOPDToken> objList = obj.GetTodayOPDToken();
            json.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            json.Data = objList; return json;
        }
        public JsonResult GetCtrlOutDoorPatientTestData()
        {
            clsOutDoorPatientTest obj = new clsOutDoorPatientTest();
            List<clsOutDoorPatientTest> objList = obj.GetSearchData();
            json.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            json.Data = objList; return json;
        }
        public JsonResult GetCtrlEmplyeeWagesData()
        {
            clsEmployeeWages obj = new clsEmployeeWages();
            List<clsEmployeeWages> objList = obj.GetAllWagesData();
            json.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            json.Data = objList; return json;
        }
        //public JsonResult GetCtrlRoleFormAssignData()
        //{
        //    clsRoleFormAssign obj = new clsRoleFormAssign();
        //    List<clsRoleFormAssign> objList = obj.GetAllData();
        //    json.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
        //    json.Data = objList; return json;
        //}
        public JsonResult GetCtrlAssetTypeData()
        {
            clsLabAssetType obj = new clsLabAssetType();
            List<clsLabAssetType> objList = obj.GetAllData();
            json.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            json.Data = objList; return json;
        }
        public JsonResult GetCtrlAssetData()
        {
            clsLabAsset obj = new clsLabAsset();
            List<clsLabAsset> objList = obj.GetAllData();
            json.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            json.Data = objList; return json;
        }
        public JsonResult GetCtrlAssetInventoryData()
        {
            clsLabAssetInventory obj = new clsLabAssetInventory();
            List<clsLabAssetInventory> objList = obj.GetAllData();
            json.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            json.Data = objList; return json;
        }

        public JsonResult GetCtrlStaffData()
        {
            clsContact obj = new clsContact();
            List<clsContact> objList = obj.GetSearchData().Where(x => x.ContactTypeID != 3).ToList();
            json.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            json.Data = objList; return json;
        }
        public JsonResult GetCtrlDoctorsData()
        {
            clsContact obj = new clsContact();
            List<clsContact> objList = obj.GetSearchData().Where(x => x.ContactTypeID == 3).ToList();
            json.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            json.Data = objList; return json;
        }
        public JsonResult GetCtrlOrganizationData()
        {
            clsOrganization obj = new clsOrganization();
            List<clsOrganization> objList = obj.GetSearchData().ToList();
            json.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            json.Data = objList; return json;
        }
        

        public JsonResult GetCtrlPaymentList()
        {
            clsSupplierLedger obj = new clsSupplierLedger();
            List<clsSupplierLedger> objList = obj.GetAllPayments();
            return Json(new { data = objList }, JsonRequestBehavior.AllowGet);

        }
        
    }
}
