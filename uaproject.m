% Parametri del drone
massa_totale = 10; % kg (massa totale del drone)
carico_utile = 1.25; % kg (carico utile minimo)
massa_strutturale = 0.45 * massa_totale; % ipotesi massa strutturale 45% del totale
massa_batterie = 2.2; % kg (massa stimata per 2 batterie Tattu)
massa_motore = 0.685; % kg (massa stimata del motore AT5330)

% Parametri batteria e motore
potenza_motore_max = 3500; % W (potenza massima motore AT5330-A)
capacita_batteria = 8000; % mAh
voltaggio_batteria = 22.2; % V
numero_batterie = 2;

% Capacità totale batteria
capacita_totale = (capacita_batteria * numero_batterie) / 1000; % Ah -> kWh
energia_totale = capacita_totale * voltaggio_batteria; % kWh

% Tempo di volo richiesto
tempo_volo_min = 15 * 60; % 15 minuti convertiti in secondi
energia_riserva = 0.20 * energia_totale; % riserva del 20% dopo il volo
energia_disponibile = energia_totale - energia_riserva; % kWh disponibili per il volo

% Parametri di volo e consumo energetico
velocita_crociera = 35 * 0.51444; % Velocità in crociera in m/s (35 nodi)
potenza_crociera = (energia_disponibile * 3600) / tempo_volo_min; % Potenza richiesta per il volo di 15 minuti in W

% Durata stimata del volo
durata_volo_stimata = (energia_disponibile * 3600) / potenza_crociera; % Durata del volo in secondi
durata_volo_minuti = durata_volo_stimata / 60; % Converti in minuti

% Condizione: se la potenza di crociera supera quella disponibile dal motore
if potenza_crociera > potenza_motore_max
    errore = 'La potenza richiesta per garantire 15 minuti di volo è superiore alla potenza massima del motore';
    disp(errore);
else
    disp('Il drone può volare per almeno 15 minuti con le batterie fornite.');
    fprintf('Durata stimata del volo: %.2f minuti\n', durata_volo_minuti);
end

% Parametri ala trapezoidale
AR = 8; % Rapporto d'aspetto (tipico per ala trapezoidale)
carico_alare = 8.1; % Kg/m^2 (ipotesi carico alare)
superficie_alare = massa_totale / carico_alare; % Superficie alare in m^2
apertura_alare = sqrt(AR * superficie_alare); % Apertura alare in m
fprintf('superficie_alare: %.2f m^2\n', superficie_alare);
fprintf('apertura_alare: %.2f m\n', apertura_alare);

% Calcolo del centro di gravità (CG) con e senza carico utile
distanza_motore = 0.5; % m (distanza dal motore al CG)
distanza_batterie = 0.4; % m (distanza delle batterie al CG)
distanza_carico = 0.2; % m (distanza dal carico utile al CG)

CG_senza_carico = (massa_motore * distanza_motore + massa_strutturale * 0 + massa_batterie * distanza_batterie) / (massa_totale - carico_utile);
CG_con_carico = (massa_motore * distanza_motore + massa_strutturale * 0 + massa_batterie * distanza_batterie + carico_utile * distanza_carico) / massa_totale;

fprintf('Centro di gravità senza carico utile: %.2f m\n', CG_senza_carico);
fprintf('Centro di gravità con carico utile: %.2f m\n', CG_con_carico);

% Calcolo del margine di stabilità
lunghezza_mac = apertura_alare / 8.5; % Lunghezza della corda media aerodinamica
sm = (CG_con_carico - 0.25 * lunghezza_mac) / lunghezza_mac; % Margine di stabilità come frazione della MAC
fprintf('Margine di stabilità: %.2f\n', sm);

% Se il margine di stabilità è negativo, si avvisa l'utente
if sm < 0
    warning('Il margine di stabilità è negativo. Si consiglia di spostare i componenti per migliorare la stabilità.');
end

% Tensore di inerzia del drone (approssimato come un'ala rettangolare)
inerzia_xx = (1/12) * massa_totale * superficie_alare^2; % Inerzia attorno all'asse x
inerzia_yy = (1/12) * massa_totale * apertura_alare^2; % Inerzia attorno all'asse y
inerzia_zz = inerzia_xx + inerzia_yy; % Inerzia attorno all'asse z

fprintf('Tensore di inerzia (Ixx): %.2f kg*m^2\n', inerzia_xx);
fprintf('Tensore di inerzia (Iyy): %.2f kg*m^2\n', inerzia_yy);
fprintf('Tensore di inerzia (Izz): %.2f kg*m^2\n', inerzia_zz);

% Calcolo della velocità massima in nodi
velocita_massima = 50; % nodi
velocita_massima_m_s = velocita_massima * 0.51444; % conversione da nodi a m/s
fprintf('Velocità massima: %.2f m/s\n', velocita_massima_m_s);


