public with sharing class CSVLeadUploadController {

    @AuraEnabled
    public static Integer uploadLeads(String csvFileContent) {
        List<Lead> leadsToInsert = new List<Lead>();
        String[] rows = csvFileContent.split('\n');

        // Lee el CSV y determinar los campos
        String headerRow = rows[0];
        String[] headers = headerRow.split(',');

        // Recorrer cada fila y crear registros de Lead
        for (Integer i = 1; i < rows.size(); i++) {
            String row = rows[i];
            if (String.isBlank(row)) {
                continue;
            }
            
            Lead newLead = createLeadFromRow(row, headers);
            if (newLead != null) {
                leadsToInsert.add(newLead);
            }
        }

        // Verificar permisos CRUD 
        if (leadsToInsert.size() > 0) {
            if (Schema.sObjectType.Lead.isCreateable()) {
                insert leadsToInsert;
            } else {
                // Si usuario no tiene permisos y lanza un error
                throw new SecurityException('No tienes permisos para crear registros de Lead.');
            }
        }

        return leadsToInsert.size(); // retorna el numero de registros insertados
    }

    // Metodo que toma una fila del CSV y crea el registro del obj
    private static Lead createLeadFromRow(String row, String[] headers) {
        String[] fields = row.split(',');

        // Crear el Lead y asigna los valores 
        Lead newLead = new Lead();
        for (Integer j = 0; j < headers.size(); j++) {
            mapFieldToLead(headers[j], fields[j], newLead);
        }

        return newLead;
    }

    // Metodo que mapea los campo
    private static void mapFieldToLead(String header, String value, Lead lead) {
        String fieldName = header.trim();
        String fieldValue = value.trim();

        if (fieldName == 'LastName') {
            lead.LastName = fieldValue;
        }
        
        if (fieldName == 'Company') {
            lead.Company = fieldValue;
        }
        if (fieldName == 'Status') {
            lead.Status = fieldValue;
        }
    }
}