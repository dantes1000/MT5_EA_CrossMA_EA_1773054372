// Indicators.mqh - Gestion des indicateurs techniques
#ifndef INDICATORS_MQH
#define INDICATORS_MQH

// Paramètres des moyennes mobiles
input int FastMAPeriod = 20;          // Période MA rapide
input int SlowMAPeriod = 50;          // Période MA lente
input ENUM_MA_METHOD MAMethod = MODE_SMA; // Méthode de calcul
input ENUM_APPLIED_PRICE MAPrice = PRICE_CLOSE; // Prix appliqué

// Handles pour les indicateurs
int FastMAHandle;
int SlowMAHandle;

// Fonction d'initialisation des indicateurs
bool InitializeIndicators()
{
    FastMAHandle = iMA(_Symbol, _Period, FastMAPeriod, 0, MAMethod, MAPrice);
    SlowMAHandle = iMA(_Symbol, _Period, SlowMAPeriod, 0, MAMethod, MAPrice);
    
    if(FastMAHandle == INVALID_HANDLE || SlowMAHandle == INVALID_HANDLE)
    {
        Print("Erreur lors de la création des indicateurs MA");
        return false;
    }
    
    return true;
}

// Fonction pour obtenir les valeurs des MA
double GetFastMAValue(int shift)
{
    double values[1];
    if(CopyBuffer(FastMAHandle, 0, shift, 1, values) > 0)
        return values[0];
    return 0.0;
}

double GetSlowMAValue(int shift)
{
    double values[1];
    if(CopyBuffer(SlowMAHandle, 0, shift, 1, values) > 0)
        return values[0];
    return 0.0;
}

// Fonction de nettoyage des handles
void CleanupIndicators()
{
    if(FastMAHandle != INVALID_HANDLE)
        IndicatorRelease(FastMAHandle);
    if(SlowMAHandle != INVALID_HANDLE)
        IndicatorRelease(SlowMAHandle);
}

#endif