// TradingFunctions.mqh - Fonctions d'exécution des trades
#ifndef TRADINGFUNCTIONS_MQH
#define TRADINGFUNCTIONS_MQH

#include "RiskManager.mqh"

// Fonction pour ouvrir une position BUY
bool OpenBuyPosition()
{
    MqlTradeRequest request = {};
    MqlTradeResult result = {};
    
    request.action = TRADE_ACTION_DEAL;
    request.symbol = _Symbol;
    request.volume = CalculateLotSize();
    request.type = ORDER_TYPE_BUY;
    request.price = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
    request.sl = request.price - CalculateStopLossPoints();
    request.tp = request.price + CalculateTakeProfitPoints();
    request.deviation = 10;
    request.magic = 12345;
    request.comment = "CrossMA_EA Buy";
    
    if(OrderSend(request, result))
    {
        Print("Position BUY ouverte. Ticket: ", result.order);
        return true;
    }
    else
    {
        Print("Erreur ouverture BUY. Code: ", result.retcode);
        return false;
    }
}

// Fonction pour ouvrir une position SELL
bool OpenSellPosition()
{
    MqlTradeRequest request = {};
    MqlTradeResult result = {};
    
    request.action = TRADE_ACTION_DEAL;
    request.symbol = _Symbol;
    request.volume = CalculateLotSize();
    request.type = ORDER_TYPE_SELL;
    request.price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
    request.sl = request.price + CalculateStopLossPoints();
    request.tp = request.price - CalculateTakeProfitPoints();
    request.deviation = 10;
    request.magic = 12345;
    request.comment = "CrossMA_EA Sell";
    
    if(OrderSend(request, result))
    {
        Print("Position SELL ouverte. Ticket: ", result.order);
        return true;
    }
    else
    {
        Print("Erreur ouverture SELL. Code: ", result.retcode);
        return false;
    }
}

// Fonction pour fermer toutes les positions
void CloseAllPositions()
{
    for(int i = PositionsTotal() - 1; i >= 0; i--)
    {
        if(PositionSelectByTicket(PositionGetTicket(i)))
        {
            if(PositionGetInteger(POSITION_MAGIC) == 12345)
            {
                MqlTradeRequest request = {};
                MqlTradeResult result = {};
                
                request.action = TRADE_ACTION_DEAL;
                request.symbol = PositionGetString(POSITION_SYMBOL);
                request.volume = PositionGetDouble(POSITION_VOLUME);
                request.type = (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) ? ORDER_TYPE_SELL : ORDER_TYPE_BUY;
                request.position = PositionGetTicket(i);
                request.price = SymbolInfoDouble(request.symbol, (request.type == ORDER_TYPE_SELL) ? SYMBOL_BID : SYMBOL_ASK);
                request.deviation = 10;
                request.magic = 12345;
                
                OrderSend(request, result);
            }
        }
    }
}

#endif