public with sharing class CSVAccountUploadController {

    @AuraEnabled
    public static Integer uploadAccounts(String csvFileContent) {
        List<Account> accountsToInsert = new List<Account>();
        String[] rows = csvFileContent.split('\n');

        // Lee el CSV y determinar los campos
        String headerRow = rows[0];
        String[] headers = headerRow.split(',');

        // Recorrer cada fila y crear registros de Account
        for (Integer i = 1; i < rows.size(); i++) {
            String row = rows[i];
            if (String.isBlank(row)) {
                continue;
            }
            
            Account newAccount = createAccountFromRow(row, headers);
            if (newAccount != null) {
                accountsToInsert.add(newAccount);
            }
        }

        // Verificar permisos CRUD
        if (accountsToInsert.size() > 0) {
            if (Schema.sObjectType.Account.isCreateable()) {
                insert accountsToInsert;
            } else {
                // Si usuario no tiene permisos y lanza un error
                throw new SecurityException('No tienes permisos para crear registros de Account.');
            }
        }

        return accountsToInsert.size(); // retorna el numero de registros insertados
    }

    // Metodo que toma una fila del CSV y crea el registro del obj
    private static Account createAccountFromRow(String row, String[] headers) {
        String[] fields = row.split(',');

        // Crear el Account y asigna los valores 
        Account newAccount = new Account();
        for (Integer j = 0; j < headers.size(); j++) {
            mapFieldToAccount(headers[j], fields[j], newAccount);
        }

        return newAccount;
    }

    // Metodo que mapea los campo
    private static void mapFieldToAccount(String header, String value, Account account) {
        String fieldName = header.trim();
        String fieldValue = value.trim();

        if (fieldName == 'Account Name') {
            account.Name = fieldValue; // campo account name
        }
        
        if (fieldName == 'Phone') {
            account.Phone = fieldValue; // campo phone
        }
    }
}