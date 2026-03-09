// SignalGenerator.mqh - Génération des signaux de trading
#ifndef SIGNALGENERATOR_MQH
#define SIGNALGENERATOR_MQH

#include "Indicators.mqh"

// Énumération des signaux
enum ENUM_SIGNAL
{
    SIGNAL_NONE,    // Aucun signal
    SIGNAL_BUY,     // Signal d'achat
    SIGNAL_SELL     // Signal de vente
};

// Fonction pour détecter le croisement des MA
ENUM_SIGNAL CheckForCrossSignal()
{
    // Récupérer les valeurs des MA pour la barre actuelle et précédente
    double fastMA0 = GetFastMAValue(0);
    double fastMA1 = GetFastMAValue(1);
    double slowMA0 = GetSlowMAValue(0);
    double slowMA1 = GetSlowMAValue(1);
    
    // Vérifier si les valeurs sont valides
    if(fastMA0 == 0.0 || fastMA1 == 0.0 || slowMA0 == 0.0 || slowMA1 == 0.0)
        return SIGNAL_NONE;
    
    // Détecter croisement haussier (MA rapide passe au-dessus de MA lente)
    if(fastMA1 <= slowMA1 && fastMA0 > slowMA0)
    {
        return SIGNAL_BUY;
    }
    // Détecter croisement baissier (MA rapide passe en-dessous de MA lente)
    else if(fastMA1 >= slowMA1 && fastMA0 < slowMA0)
    {
        return SIGNAL_SELL;
    }
    
    return SIGNAL_NONE;
}

// Fonction pour vérifier si une position est déjà ouverte
bool HasOpenPosition()
{
    for(int i = 0; i < PositionsTotal(); i++)
    {
        if(PositionSelectByTicket(PositionGetTicket(i)))
        {
            if(PositionGetInteger(POSITION_MAGIC) == 12345 && PositionGetString(POSITION_SYMBOL) == _Symbol)
                return true;
        }
    }
    return false;
}

#endif