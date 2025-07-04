public without sharing class GoogleApiHelper {
    
    private static GoogleApi googleApi = new GoogleApi();
    
    public static GoogleApiWrapper.Location getGeocode(String address) {
        
        HttpRequest request;
        HttpResponse response;
        
        try {
            
            request = googleApi.geocode(address);
            response = new Http().send(request);
            
            Integer statusCode = response.getStatusCode();
            String responseBody = response.getBody();
            
            if(statusCode == 200 || statusCode == 201) {
                
                GoogleApiWrapper.GeocodeResponse result = (GoogleApiWrapper.GeocodeResponse) JSON.deserialize(responseBody, GoogleApiWrapper.GeocodeResponse.Class);
                
                if(result != null && !result.results.isEmpty() && result.results[0].geometry != null && result.results[0].geometry.location != null) {
                    return result.results[0].geometry.location;
                    
                } else {
                    Logger.error('Bad Response From API').setHttpRequestDetails(request).setHttpResponseDetails(response);
                }
                
            } else {
                Logger.error('Bad Response From API').setHttpRequestDetails(request).setHttpResponseDetails(response);
            }
            
        } catch(Exception ex) {
            Logger.error('Exception', ex).setHttpRequestDetails(request).setHttpResponseDetails(response);
        }
        
        Logger.saveLog();
        
        return null;
    }
    
    @AuraEnabled
    public static GoogleApiWrapper.BuildingInsightsResponse getBuildingInsights(Decimal latitude, Decimal longitude) {
        
        HttpRequest request;
        HttpResponse response;
        String errorMessage;
        
        try {
            
            request = googleApi.buildingInsights(latitude, longitude);
            response = new Http().send(request);
            
            Integer statusCode = response.getStatusCode();
            String responseBody = response.getBody();
            
            if(statusCode == 200 || statusCode == 201) {                
                GoogleApiWrapper.BuildingInsightsResponse result = (GoogleApiWrapper.BuildingInsightsResponse) JSON.deserialize(responseBody, GoogleApiWrapper.BuildingInsightsResponse.Class);
                
                return result;
                
            } else {
                Logger.error('Bad Response From API').setHttpRequestDetails(request).setHttpResponseDetails(response);
                
                errorMessage = 'Bad Response From API. Status Code: ' + statusCode + ', Response Body: ' + responseBody;
            }
            
        } catch(Exception ex) {
            Logger.error('Exception', ex).setHttpRequestDetails(request).setHttpResponseDetails(response);
            
            errorMessage = 'Exception: ' + ex.getMessage();
        }
        
        Logger.saveLog();
        
        if(String.isNotBlank(errorMessage)) { 
            throw new GenericException(errorMessage);        
        }
        
        return null;
    }
}