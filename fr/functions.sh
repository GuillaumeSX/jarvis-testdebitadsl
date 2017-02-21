jv_pg_ct_testdebitinternet() {
sudo ping -q -c 2 www.google.fr >/dev/null 2>&1 


if [ $? -eq 0 ]; then 
#  echo "Vous êtes connecté." 
mesuredebit=`speedtest --simple`
mesuredebit1=`echo ${mesuredebit##P*Download:}` # enlève le début
mesuredebit1=`echo ${mesuredebit1%Upload*}` # enlève la fin
mesuredebit1=`echo $mesuredebit1 | sed -e "s/Kbit\/s/Kilo bites par seconde/g"  | sed -e "s/Mbit\/s/Méga bites par seconde/g"` # convertis KB/MB en Kilo/Méga bites par seconde
mesuredebit2=`echo $mesuredebit1 | sed -e "s/Mbit\/s//g" | sed -e "s/Kbit\/s//g"`  # affiche que le chiffre
mesuredebit3=`echo ${mesuredebit2%.*}`
	if [[ "$mesuredebit1" =~ "Kilo" ]]; then 
	echo "Le débit de cette ligne est de $mesuredebit1, ce qui est faible, ce n'est pas normal !"
	else

		if [[ "$mesuredebit3" -lt "4" ]]; then
		echo "Le débit de cette ligne est de $mesuredebit1,  ce qui n'est pas suffisant pour regarder la Télévision par l'ADSL en haute définition"
		fi

		if [[ "$mesuredebit3" -ge "4" ]]; then
		echo "Le débit de cette ligne est de $mesuredebit1, ce qui est parfait."
		fi

		if [[ "$mesuredebit3" -ge "8" ]]; then
		echo "Vous êtes même en ADSL plus excellent c'est rare !!"
		fi
	fi	

else 
echo "Vous n'êtes pas connecté à internet... il y a un soucis sur votre ligne." 
fi 
} 
