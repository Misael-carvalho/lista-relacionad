/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 12-08-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class StatusMarcacaoBO {

    public static void checkPrevisao(Map<Id, StatusdeMarcacao__c > mpNew){

        Set<Id> idPrevisao = new Set<Id>();
        Set<Id> idGestao = new Set<Id>();
        Map<Id, Previsao_Entrega_Produto__c> mapPrevisao = new Map<Id, Previsao_Entrega_Produto__c>();
        Map<Id, Clientefinalentrega__c> mapGestao = new Map<Id, Clientefinalentrega__c>();


        for(StatusdeMarcacao__c stm : mpNew.values()){
            if(stm.ShipmentId__c != null){
                if(stm.ShipmentId__c.startswith('a1F')){
                    stm.PrevisaoEntrega__c = stm.ShipmentId__c;
                    idPrevisao.add(stm.ShipmentId__c);
                } else {
                    stm.GestaoCarteira__c = stm.ShipmentId__c;
                    idGestao.add(stm.ShipmentId__c);
                }
            }
        }

        if(idPrevisao.size()>0){
            mapPrevisao = new Map<Id, Previsao_Entrega_Produto__c>([SELECT Id, Produto_Pedido__c FROM Previsao_Entrega_Produto__c WHERE Id in :idPrevisao]);
        }
        if(idGestao.size()>0){
            mapGestao = new Map<Id, Clientefinalentrega__c>([SELECT Id, ProdutoContrato__c FROM Clientefinalentrega__c WHERE Id in :idGestao]);
        }

        for(StatusdeMarcacao__c stm : mpNew.values()){
            if(stm.ShipmentId__c != null){
                if(stm.ShipmentId__c.startswith('a1F')){
                    stm.ProdutodoContrato__c = mapPrevisao.get(stm.ShipmentId__c).Produto_Pedido__c;
                } else {
                    stm.ProdutodoContrato__c = mapGestao.get(stm.ShipmentId__c).ProdutoContrato__c;
                }
            }
        }
    }

    public static void atualizarStatus(Map<Id, StatusdeMarcacao__c > mpNew){

        Set<String> statusIds = new Set<String>();
        Map<Id, List<OrderItem>> mapaOrderItem = new Map<Id, List<OrderItem>>();
        List<StatusdeMarcacao__c> stMarcacao = new List<StatusdeMarcacao__c> ();
        List<OrderItem> itensAtualizar = new List<OrderItem>();

        for(StatusdeMarcacao__c stm : mpNew.values()){

            if(string.isBlank(stm.StatusMarcacao__c)) 
                continue;

            if( stm.StatusMarcacao__c  == 'Aguardando Chamada para Pátio' || 
                stm.StatusMarcacao__c  == 'Aguardando Entrada do Veículo' ||
                stm.StatusMarcacao__c  == 'Aguardando no Pátio' ||
                stm.StatusMarcacao__c  == 'Aguardando no Posto' ||
                stm.StatusMarcacao__c  == 'Aguardando Ordem de Produção' ||
                stm.StatusMarcacao__c  == 'Carregamento Externo' ||
                stm.StatusMarcacao__c  == 'Na Fábrica'||
                stm.StatusMarcacao__c  == 'Saiu da fábrica'
            ){
                statusIds.add(stm.ProdutodoContrato__c);
                stMarcacao.add(stm);
            }
            
        }
        /* List<OrderItem> items = [SELECT Id, OrderId, StatusProduto__c FROM OrderItem WHERE Id IN: statusIds];
        
        for(OrderItem oi: items){
            if(!mapaOrderItem.containsKey(oi.Id)){
                mapaOrderItem.put(oi.Id, new List<OrderItem>{oi});
            } else {
                mapaOrderItem.get(oi.Id).add(oi);
            }
        }
        if(!stMarcacao.isEmpty()){ 
            for(StatusdeMarcacao__c ord : stMarcacao){
                    for(OrderItem item : mapaOrderItem.get(ord.ProdutodoContrato__c)){
                        item.StatusProduto__c = 'Em carregamento';
                        itensAtualizar.add(item);
                    }
            }
        }
        if(!itensAtualizar.isEmpty()){
        	update itensAtualizar;
        } */
    }

    @AuraEnabled(cacheable=true)
    public static List<StatusdeMarcacao__c> lstMarcacao( ID orderItemId){
        return  [
                    SELECT 
                        Id, 
                        NumeroPreMarcacao__c,
                        Transportadora__c,
                        Placa__c,
                        Motorista__c,
                        StatusMarcacao__c,
                        DatadoStatus__c,
                        Destinatario__c,
                        QuantidadePrevista__c
                    FROM 
                        StatusdeMarcacao__c 
                    where 
                        ProdutodoContrato__c = :orderItemId
                    And StatusMarcacao__c != 'Cancelado' 
                    And StatusMarcacao__c != 'Cancelado por Erro de Cadastro'
                    And StatusMarcacao__c != 'Desistência'

                ];
    }
}