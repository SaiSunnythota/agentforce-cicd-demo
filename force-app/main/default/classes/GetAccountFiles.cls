public class GetAccountFiles {

    public class FileResult {
        @InvocableVariable public String contentDocumentId;
        @InvocableVariable public String title;
        @InvocableVariable public String fileType;
    }

    @InvocableMethod(label='Get Account Files' description='Returns files linked to an Account')
    public static List<List<FileResult>> getAccountFiles(List<Id> accountIds) {
        
        List<List<FileResult>> allResults = new List<List<FileResult>>();
        
        for (Id accountId : accountIds) {
            List<FileResult> fileList = new List<FileResult>();
            
            for (ContentDocumentLink cdl : [
                SELECT ContentDocumentId, ContentDocument.Title, ContentDocument.FileType
                FROM ContentDocumentLink
                WHERE LinkedEntityId = :accountId
            ]) {
                FileResult fr = new FileResult();
                fr.contentDocumentId = cdl.ContentDocumentId;
                fr.title = cdl.ContentDocument.Title;
                fr.fileType = cdl.ContentDocument.FileType;
                fileList.add(fr);
            }
            
            allResults.add(fileList);
        }
        
        return allResults;
    }
}