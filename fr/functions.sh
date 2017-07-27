jv_pg_ct_testdebitinternet() {
sudo ping -q -c 2 www.google.fr >/dev/null 2>&1 


if [ $? -eq 0 ]; then 
# echo "Vous êtes connecté." 
mesuredebit=`speedtest --simple`


mesuredebit1=`echo ${mesuredebit##P*Download:}` # enlève le début
mesuredebit1=`echo ${mesuredebit1%Upload*}` # enlève la fin
mesuredebit2=`echo $mesuredebit1 | sed -e "s/Mbit\/s//g" | sed -e "s/Kbit\/s//g" | sed -e "s/\./,/g"`  # affiche que le chiffre
mesuredebit1=`echo $mesuredebit1 | sed -e "s/Kbit\/s/Kilobite par seconde/g"  | sed -e "s/Mbit\/s/Mégabite par seconde/g" | sed -e "s/\./,/g"` # convertis KB/MB en Kilo/Méga bites par seconde
mesuredebit3=$(printf "%.2f" $mesuredebit2)  # Arrondi le chiffre à 2 virgule prêt
CHEMINDEBITMAX="$jv_dir/plugins_installed/jarvis-testdebitadsl/debitmax.txt"
CHEMINDEBITMIN="$jv_dir/plugins_installed/jarvis-testdebitadsl/debitmin.txt"

	if [ -f "$CHEMINDEBITMAX" ]; then
	# fichier existe
	MESUEDEBITMAX=`echo $(cat $CHEMINDEBITMAX)`
	else
	say "J'enregistre ce débit..."
	echo "$mesuredebit3" > $CHEMINDEBITMAX 2>&1 
	fi


	if [ -f "$CHEMINDEBITMIN" ]; then
	# fichier existe
	MESUEDEBITMIN=`echo $(cat $CHEMINDEBITMIN)`
	else
	echo "$mesuredebit3" > $CHEMINDEBITMIN 2>&1 
	fi



		if [[ "$mesuredebit1" =~ "Kilo" ]]; then 
		say "Le débit de cette ligne est de $mesuredebit1, c'est anormalement faible !"
		else

			if [[ "$mesuredebit3" <  "4" ]]; then
			say "Le débit descendant de cette connexion est de $mesuredebit1,  ce n'est pas suffisant pour regarder la télé en HD"
			fi

			if [[ "$mesuredebit3" > "4" ]]; then
			say "Le débit descendant de cette connexion est de $mesuredebit1, ce qui est parfait."
			fi

			if [[ "$mesuredebit3" > "8" ]]; then
			say "Connexion de très bonne qualité, bravo !"
			fi

		fi	


	if [[ "$mesuredebit3" < "$MESUEDEBITMAX" ]]; then 
	say "le débit maximum relevé de $MESUEDEBITMAX n'est pas dépassé"
	fi

	if [[ "$mesuredebit3" > "$MESUEDEBITMAX" ]]; then 
	say "Nouveau débit maximal, je l'enregistre."
	echo "$mesuredebit3" > $CHEMINDEBITMAX 2>&1 
	fi

	if [[ "$mesuredebit3" < "$MESUEDEBITMIN" ]]; then 
	say "Débit le plus mauvais jusqu'à présent ! je l'enregistre."
	echo "$mesuredebit3" >  $CHEMINDEBITMIN 2>&1 
	fi


else 
say "Vous n'êtes pas connecté à internet... votre connexion est défectueuse." 
fi 
} 

jv_pg_ct_testdebitinternetmax(){
CHEMINDEBITMAX="$jv_dir/plugins_installed/jarvis-testdebitadsl/debitmax.txt"
if [ -f "$CHEMINDEBITMAX" ]; then
	# fichier existe
MESUEDEBITMAX=`echo $(cat $CHEMINDEBITMAX)`
MESUEDEBITMAXDATE=`date -r $CHEMINDEBITMAX "+%A %d %B à %H heure %M"`
say "Le débit maximum relevé était de $MESUEDEBITMAX le $MESUEDEBITMAXDATE"
else
say "Il n'y a pas encore de relevé enregistré, désolé."
fi
}

jv_pg_ct_testdebitinternetmin(){
CHEMINDEBITMIN="$jv_dir/plugins_installed/jarvis-testdebitadsl/debitmin.txt"
if [ -f "$CHEMINDEBITMIN" ]; then
	# fichier existe
MESUEDEBITMIN=`echo $(cat $CHEMINDEBITMIN)`
MESUEDEBITMINDATE=`date -r $CHEMINDEBITMIN "+%A %d %B à %H heure %M"`
say "Le débit minimum relevé était de $MESUEDEBITMIN le $MESUEDEBITMINDATE"
else
say "Il n'y a pas encore de relevé enregistré, désolé."
fi
}
