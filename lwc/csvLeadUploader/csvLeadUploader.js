import { LightningElement, track } from 'lwc';
import uploadLeads from '@salesforce/apex/CSVLeadUploadController.uploadLeads';

export default class CsvLeadUploader extends LightningElement {
    @track showFileUpload = false; // Controla la visualización del área de carga
    @track uploadMessage = ''; // Mensaje de estado para la carga
    @track showSpinner = false; // Controla la visualización del spinner
    fileContent; // Almacena el contenido del archivo CSV

    // Muestra el área de carga de archivos
    handleButtonClick() {
        this.showFileUpload = true;
    }

    // Maneja la seleccion de archivo
    handleFileChange(event) {
        const file = event.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = () => {
                this.fileContent = reader.result; // Almacena el contenido del archivo como texto
                this.uploadMessage = `Archivo ${file.name} cargado correctamente.`;
            };
            reader.readAsText(file);
        }
    }

    // Procesa el archivo y lo carga en Salesforce
    handleFileUpload() {
        if (this.fileContent) {
            this.showSpinner = true;
            // Llamar a Apex para procesar el archivo CSV
            uploadLeads({ csvFileContent: this.fileContent })
                .then(result => {
                    this.showSpinner = false;
                    this.uploadMessage = `Carga exitosa: ${result} registros de Leads creados.`;
                })
                .catch(error => {
                    this.showSpinner = false;
                    this.uploadMessage = `Error en la carga: ${error.body.message}`;
                });
        } else {
            this.uploadMessage = 'Por favor, selecciona un archivo antes de cargar.';
        }
    }
}
