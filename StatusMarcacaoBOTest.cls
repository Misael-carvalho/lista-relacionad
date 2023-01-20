@isTest
private with sharing class StatusMarcacaoBOTest {
    
    @TestSetup
    static void makeData(){
        
        Pedido_SObjectSetupOrderTest.orderMockup();
        
        OrderItem idOrder = [SELECT Id FROM OrderItem limit 1];
        
        StatusdeMarcacao__c lstMar = new StatusdeMarcacao__c();
        lstMar.Name = 'Test';
        lstMar.ProdutodoContrato__c = idOrder.Id;
        
        insert lstMar;
        
    }
    @isTest
    static void StatusMarcacaoTest(){
        List<String> lista = new List<String>{  'Aguardando Chamada para Pátio',
                                                'Aguardando Entrada do Veículo',
                                                'Aguardando no Pátio',
                                                'Aguardando no Posto',
                                                'Aguardando Ordem de Produção',
                                                'Carregamento Externo',
                                                'Na Fábrica',
                                                'Saiu da fábrica', 
            									''
                                              };
                    
        StatusdeMarcacao__c lstMar = [SELECT Id, ProdutodoContrato__c, Name, StatusMarcacao__c FROM StatusdeMarcacao__c Limit 1];
        ID ids = lstMar.id;
        
        Map<Id, StatusdeMarcacao__c> novo = new Map<Id, StatusdeMarcacao__c>();
        
        Test.startTest();
            for(String lst : lista){
                lstMar.StatusMarcacao__c = lst;
                novo.put(ids, lstMar);
                StatusMarcacaoBO.atualizarStatus( novo);
            }
        Test.stopTest();
    }
}