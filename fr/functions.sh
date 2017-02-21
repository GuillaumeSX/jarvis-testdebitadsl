jv_pg_ct_testdebitinternet() {
sudo ping -q -c 2 www.google.fr >/dev/null 2>&1 


if [ $? -eq 0 ]; then 
# echo "Vous êtes connecté." 
mesuredebit=`speedtest --simple`


mesuredebit1=`echo ${mesuredebit##P*Download:}` # enlève le début
mesuredebit1=`echo ${mesuredebit1%Upload*}` # enlève la fin
mesuredebit2=`echo $mesuredebit1 | sed -e "s/Mbit\/s//g" | sed -e "s/Kbit\/s//g" | sed -e "s/\./,/g"`  # affiche que le chiffre
mesuredebit1=`echo $mesuredebit1 | sed -e "s/Kbit\/s/Kilo bites par seconde/g"  | sed -e "s/Mbit\/s/Méga bites par seconde/g" | sed -e "s/\./,/g"` # convertis KB/MB en Kilo/Méga bites par seconde
mesuredebit3=$(printf "%.2f" $mesuredebit2)  # Arrondi le chiffre à 2 virgule prêt
CHEMINDEBIT="$jv_dir/plugins/jarvis-testdebitadsl/debitmax.txt"

	if [ -f "$CHEMINDEBIT" ]; then
	# fichier existe
	MESUEDEBITMAX=`echo $(cat $CHEMINDEBIT)`
	else
	say "J'enregitre cette mesure afin de la comparer la prochaine fois..."
	echo "$mesuredebit3" > $CHEMINDEBIT 2>&1 
	fi



		if [[ "$mesuredebit1" =~ "Kilo" ]]; then 
		say "Le débit de cette ligne est de $mesuredebit1, ce qui est faible, ce n'est pas normal !"
		else

			if [[ "$mesuredebit3" <  "4" ]]; then
			say "Le débit de cette ligne est de $mesuredebit1,  ce qui n'est pas suffisant pour regarder la Télévision par l'ADSL en haute définition"
			fi

			if [[ "$mesuredebit3" > "4" ]]; then
			say "Le débit de cette ligne est de $mesuredebit1, ce qui est parfait."
			fi

			if [[ "$mesuredebit3" > "8" ]]; then
			say "Vous êtes même en ADSL plus excellent c'est rare !!"
			fi

		fi	


	if [[ "$mesuredebit3" < "$MESUEDEBITMAX" ]]; then 
	say "le débit maximum relevé de $MESUEDEBITMAX n'est pas dépassé"
	fi

	if [[ "$mesuredebit3" > "$MESUEDEBITMAX" ]]; then 
	say "Super nouveau débit maximal perçu jusqu'à présent, je l'enregistre."
	echo "$mesuredebit3" > $CHEMINDEBIT 2>&1 
	fi

else 
say "Vous n'êtes pas connecté à internet... il y a un soucis sur votre ligne." 
fi 
} 
