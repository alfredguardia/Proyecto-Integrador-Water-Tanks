@isTest
private class CSVUpload_Test {

    @isTest
    static void testUploadLeads() {
        // Crear un archivo CSV para Leads
        String csvContent = 'LastName,Company,Status\nJoe,NTT DATA,New\nAndre,CAPCOM,New';
        
        // Llamar al metodo para Leads
        Test.startTest();
        Integer recordsInserted = CSVLeadUploadController.uploadLeads(csvContent);
        Test.stopTest();
        
        // Assert: Verificar que se hayan insertado los registros correctos
        List<Lead> leads = [SELECT Id, Name, Company, Status FROM Lead WHERE Company IN ('NTT DATA', 'CAPCOM')];
        System.assertEquals(2, leads.size(), 'Se deben haber creado 2 registros de Lead.');
        
        // Verificar los valores de los registros
        System.assertEquals('Joe', leads[0].LastName);
        System.assertEquals('NTT DATA', leads[0].Company);
        System.assertEquals('New', leads[0].Status);
        System.assertEquals('Andre', leads[1].LastName);
        System.assertEquals('CAPCOM', leads[1].Company);
        System.assertEquals('New', leads[1].Status);
    }

    @isTest
    static void testUploadAccounts() {
        // Crear un archivo CSV para Accounts
        String csvContent = 'Account Name,Phone\NTT DATA,(123) 456-7890\nCAPCOM,(234) 567-8901';
        
        // Llama al metodo para Account
        Test.startTest();
        Integer recordsInserted = CSVAccountUploadController.uploadAccounts(csvContent);
        Test.stopTest();
        
        // Assert: Verificar que se hayan insertado los registros correctos
        List<Account> accounts = [SELECT Id, Name, Phone FROM Account WHERE Name IN ('NTT DATA', 'CAPCOM')];
        System.assertEquals(2, accounts.size(), 'Se deben haber creado 2 registros de Account.');
        
        // Verificar valores de registros
        System.assertEquals('NTT DATA', accounts[0].Name);
        System.assertEquals('(123) 456-7890', accounts[0].Phone);
        System.assertEquals('CAPCOM', accounts[1].Name);
        System.assertEquals('(234) 567-8901', accounts[1].Phone);
    }

    @isTest
    static void testUploadWithNoData() {
        // Archivo CSV vacío para Leads y Account
        String csvContent = '';
        
        // Llama al metodo para Leads
        Test.startTest();
        Integer recordsInserted = CSVLeadUploadController.uploadLeads(csvContent);
        Test.stopTest();
        
        // Assert: Verificar que no se hayan insertado registros
        System.assertEquals(0, recordsInserted, 'No deben haberse creado registros de Lead.');
        
        // Llamar al metodo para Accounts
        Test.startTest();
        recordsInserted = CSVAccountUploadController.uploadAccounts(csvContent);
        Test.stopTest();
        
        // Assert: Verificar que no se hayan insertado registros
        System.assertEquals(0, recordsInserted, 'No deben haberse creado registros de Account.');
    }
}
