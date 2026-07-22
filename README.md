# weekmenu
Weekmenu en recepten

## Beveiligde opslag instellen

1. Maak een Supabase-project aan.
2. Voer `supabase-setup.sql` uit in de SQL Editor en vervang het voorbeeldadres door de toegestane e-mailadressen.
3. Vul de Project URL en publishable key in `supabase-config.js` in.
4. Voeg `https://jerryveen.github.io/weekmenu/` toe als Site URL en Redirect URL bij Authentication > URL Configuration.
5. Migreer de bestaande JSONBin-data voordat de oude sleutel wordt ingetrokken.

De publishable key mag in de website staan. De databasebeveiliging zit in Supabase Row Level Security; gebruik hier nooit een secret key.
