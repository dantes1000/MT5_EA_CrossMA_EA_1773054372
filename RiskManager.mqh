// RiskManager.mqh - Gestion des risques et paramètres de trading
#ifndef RISKMANAGER_MQH
#define RISKMANAGER_MQH

// Paramètres de risque
input double FixedLot = 0.1;          // Lot fixe
input int StopLossPips = 30;          // Stop Loss en pips
input int TakeProfitPips = 60;        // Take Profit en pips

// Fonction pour calculer le lot (ici lot fixe)
double CalculateLotSize()
{
    return FixedLot;
}

// Fonction pour calculer le Stop Loss en points
int CalculateStopLossPoints()
{
    return (int)(StopLossPips * _Point * 10); // Conversion pips -> points
}

// Fonction pour calculer le Take Profit en points
int CalculateTakeProfitPoints()
{
    return (int)(TakeProfitPips * _Point * 10); // Conversion pips -> points
}

#endif