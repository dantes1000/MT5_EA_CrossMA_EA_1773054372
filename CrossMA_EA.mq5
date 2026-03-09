// CrossMA_EA.mq5 - Expert Advisor basé sur croisement de moyennes mobiles
// Version: 1.0
// Auteur: Expert MQL5

#property copyright "Expert MQL5"
#property link      "https://www.mql5.com"
#property version   "1.00"

// Inclusions des fichiers d'en-tête
#include "RiskManager.mqh"
#include "Indicators.mqh"
#include "TradingFunctions.mqh"
#include "SignalGenerator.mqh"

// Variables globales
bool IndicatorsInitialized = false;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
    // Initialiser les indicateurs
    IndicatorsInitialized = InitializeIndicators();
    
    if(!IndicatorsInitialized)
    {
        Print("Échec de l'initialisation des indicateurs");
        return INIT_FAILED;
    }
    
    Print("CrossMA_EA initialisé avec succès");
    Print("Paramètres: MA Rapide=", FastMAPeriod, ", MA Lente=", SlowMAPeriod);
    Print("Risque: Lot=", FixedLot, ", SL=", StopLossPips, " pips, TP=", TakeProfitPips, " pips");
    
    return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    // Nettoyer les ressources
    CleanupIndicators();
    Print("CrossMA_EA désinitialisé");
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
    // Vérifier si les indicateurs sont initialisés
    if(!IndicatorsInitialized)
        return;
    
    // Vérifier s'il y a déjà une position ouverte
    if(HasOpenPosition())
        return;
    
    // Générer le signal
    ENUM_SIGNAL signal = CheckForCrossSignal();
    
    // Exécuter le trade selon le signal
    switch(signal)
    {
        case SIGNAL_BUY:
            Print("Signal BUY détecté");
            OpenBuyPosition();
            break;
            
        case SIGNAL_SELL:
            Print("Signal SELL détecté");
            OpenSellPosition();
            break;
            
        case SIGNAL_NONE:
            // Pas de signal
            break;
    }
}

//+------------------------------------------------------------------+
//| Fonction pour tester le EA dans le Strategy Tester              |
//+------------------------------------------------------------------+
void OnTester()
{
    // Cette fonction est utilisée pour les tests d'optimisation
    Print("Test en cours...");
}

//+------------------------------------------------------------------+
//| Fonction de gestion des événements de chart                     |
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
{
    // Gestion des événements du graphique (optionnel)
    if(id == CHARTEVENT_OBJECT_CLICK)
    {
        // Exemple: fermer toutes les positions si on clique sur un objet
        if(sparam == "close_all_button")
        {
            CloseAllPositions();
        }
    }
}