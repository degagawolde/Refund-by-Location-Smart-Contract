const RefundContract = artifacts.require("RefundContract") ;
  
contract("RefundContract" , () => {
    it("Refund Contract Testing" , async () => {
       const refundContract = await RefundContract.deployed() ;
       await refundContract.setEmployeeAccount(
        "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4",0,0,5,1,0 ) ;
       const result = await refundContract.getEmployees() ;
       assert(result.length > 0) ;
    });
});