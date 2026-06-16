public with sharing class EmptyClass {
    
    public class SC368IMIntegrationWrapper{
        
        public class MainRequestwrapper{
            public Requestwrapper docPortalRequest;
        }

        public class Requestwrapper {
            public Contractwrapper Contracts;
        }

        public class Contractwrapper {
            public string ContractNumber; public string MCFDContractNumber; public string Contractversion; public String Startdate;
            public string ContractorLegalName;
            public string Enddate;
            public string ICMProviderID;
            public string Total;
            public string Contractstatus
            public string ContractRecordtype;
            public String Caresetting;
            public String ResposibilitycenterName;
            public String TerminationDate;
            public string SHSSType;
            public string AmendmentEffectivedate;
            public TransitionInSchedulewrapper TransitionInSchedule;
            public List<Servicepaymentswrapper> Servicepayments;
            public List<ContractProgramServiceswrapper> ContractProgramservices;
            public string Isrenewal;
            public string IsNopayment;
            public String Renewalversion;
            public string Idir;
            public String RatechangEffectiveDate;

            public Contractwrapper () {
                ContractNumber = ';
                MCFDContractNumber = ";
                Contractversion = ";
                StartDate = ';
                ContractorLegalName = '';
                Endate = • ;
                IMProviderID = ';
                Total = "";
                Contractstatus ='';
                ContractRecordtype = '';
                Caresetting = '';
                ResposibilityCenterName = '';
                TerminationDate = '';
                TransitionInSchedule = new TransitionInSchedulewrapper();
                Servicepayments = new List<ServicePaymentswrapper>() ;
                ContractProgramservices = new List<ContractProgramServiceswrapper>();
                IsRenewal = 'false':
                IsNoPayment = 'false';
                Renewalversion ='';
                Idir='';
                RateChangeEffectivedate = '':
            }
        }

        public class TransitionInSchedulewrapper {
            public string TransitionInPeriod; 
            public String TransitionInPaymentType; 
            public string TotalTransitionPaymentMaximum;
            public string TransitionPaymentMaxFacilityCosts;
            public string TransitionPaymentMaxstaffing;
            public string TransitionPaymentMaxSupplemental;
            public String TotalPaymentAtEndofFirstMonth;
            public string TotalPaymentAtEndofSecondMonth;

            public TransitionInSchedulewrapper(){
                TransitionInPeriod=''; 
                TransitionInPaymentType=''; 
                TotalTransitionPaymentMaximum='';
                TransitionPaymentMaxFacilityCosts='';
                TransitionPaymentMaxstaffing='';
                TransitionPaymentMaxSupplemental='';
                TotalPaymentAtEndofFirstMonth='';
                TotalPaymentAtEndofSecondMonth='';
            }
        }

        public class Servicepayments {
            public string TransitionIn; 
            public String TransitionInPaymentType; 
            public string TotalTransitionPaymentMax;
            public string TransitionPaymentMaxFacilityCost;

            public Servicepayments(){
                TransitionIn=''; 
                TransitionInPaymentType=''; 
                TotalTransitionPaymentMax='';
                TransitionPaymentMaxFacilityCost='';
            }
        }
    }
}


        public class DebugWrapper {
            public string status; 
            public String statusCode; 
            public string TotalTransitionPaymentMaximum;
            public string TransitionPaymentMaxFacilityCosts;
            public string TransitionPaymentMaxstaffing;
            public string TransitionPaymentMaxSupplemental;
            public String TotalPaymentAtEndofFirstMonth;
            public string TotalPaymentAtEndofSecondMonth;

            public DebugWrapper setSuccess(){
                this.status = 'Success';
                this.statusCode = '200';
                return this;
            }

            public DebugWrapper setError(){
                this.status = 'Error';
                this.statusCode = '400';
                return this;
            }
        }