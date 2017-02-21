jv_pg_ct_testdebitinternet() {
mesuredebit=`wget  http://speedtest.wdc01.softlayer.com/downloads/test10.zip   2>&1 | grep -o "[0-9.]\+ [KM]*B/s"`
mesuredebit1=`echo $mesuredebit | sed -e "s/KB\/s/Kilo bites par seconde/g"  | sed -e "s/MB\/s/Méga bites par seconde/g"` # convertis KB/MB en Kilo/Méga bites par seconde
mesuredebit2=`echo $mesuredebit | sed -e "s/[^[:digit:]]//g"` # affiche que le chiffre

if [[ "$mesuredebit1" =~ "Kilo" ]]; then 
echo "Le débit de cette ligne est de $mesuredebit1, ce qui est faible, ce n'est pas normal !"
else

	if [[ "$mesuredebit2" -lt "4" ]]; then
	echo "Le débit de cette ligne est de $mesuredebit1,  ce qui n'est pas suffisant pour regarder la Télévision par l'ADSL en haute définition"
	fi

	if [[ "$mesuredebit2" -ge "4" ]]; then
	echo "Le débit de cette ligne est de $mesuredebit1, ce qui est parfait."
	fi

	if [[ "$mesuredebit2" -ge "8" ]]; then
	echo "Vous êtes même en ADSL plus excellent c'est rare !!"
	fi
fi



} 
