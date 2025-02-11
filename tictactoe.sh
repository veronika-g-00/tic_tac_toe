#!/bin/bash
plansza=( "-" "-" "-"
          "-" "-" "-"
          "-" "-" "-" )
            
print_plansza() {
    printf " %s | %s | %s\n" "${plansza[0]}" "${plansza[1]}" "${plansza[2]}"
    echo "-----------"
    printf " %s | %s | %s\n" "${plansza[3]}" "${plansza[4]}" "${plansza[5]}"
    echo "-----------"
    printf " %s | %s | %s\n" "${plansza[6]}" "${plansza[7]}" "${plansza[8]}"
    echo
}

sprawdz_status_gry() {
    # sprawdzenie kolumn
    for i in 0 1 2; do
        if [[ "${plansza[$i]}" == "${plansza[$i+3]}" && "${plansza[$i+3]}" == "${plansza[$i+6]}" && "${plansza[$i]}" != "-" ]]; then
            echo "${plansza[$i]} wygrał!"
            exit 0
        fi
    done
	
	# sprawdzenie wierszy
    for i in 0 3 6; do
        if [[ "${plansza[$i]}" == "${plansza[$i+1]}" && "${plansza[$i+1]}" == "${plansza[$i+2]}" && "${plansza[$i]}" != "-" ]]; then
            echo "${plansza[$i]} wygrał!"
            exit 0
        fi
    done
      
    # sprawdzenie przekątnych
    if [[ "${plansza[0]}" == "${plansza[4]}" && "${plansza[4]}" == "${plansza[8]}" && "${plansza[0]}" != "-" ]]; then
        echo "${plansza[0]} wygrał!"
        exit 0
    elif [[ "${plansza[2]}" == "${plansza[4]}" && "${plansza[4]}" == "${plansza[6]}" && "${plansza[2]}" != "-" ]]; then
        echo "${plansza[2]} wygrał!"
        exit 0
    fi
    
    # sprawdzenie, czy remis
    if [[ ! " ${plansza[*]} " =~ "-" ]]; then
        echo "Remis!"
        exit 0
    fi
}

zapis_gry(){
	echo "${plansza[*]}" > savegame.txt
	echo "Gra zostala zapisana!"
}

wczytaj_gre(){
	if [[ -f savegame.txt ]]; then
		IFS=' ' read -r -a plansza < savegame.txt
		echo "Gra zostala wczytana"
	else 
		echo "Aktualnie brak zapisanego stanu gry!"
	fi
}

#zapytanie czy gracz chce wczytac gre
	read -p "Chcesz wczytac zapisana gre? (t/n): " wczytanie_decyzja
	if [[ "$wczytanie_decyzja" == "t" ]]; then
		wczytaj_gre
	fi

# gra
while :; do
    print_plansza
	
    read -p "Podaj indeks (0-8) swojego ruchu: " index
    if ! [[ $index =~ ^[0-8]$ ]]; then
        echo "Nieprawidłowy indeks. Podaj liczbę od 0 do 8."
        continue
    fi

    if [[ "${plansza[$index]}" == "-" ]]; then
        plansza[$index]="X"
        sprawdz_status_gry

        # Ruch komputera
        while :; do
            comp_move=$((RANDOM % 9))
            if [[ "${plansza[$comp_move]}" == "-" ]]; then
                plansza[$comp_move]="O"
                break
            fi
        done
        sprawdz_status_gry
		
		#zapytanie czy gracz chce zapisac gre po turze
		read -p "Chcesz zapisac gre? (t/n): " zapis_decyzja
		if [[ "$zapis_decyzja" == "t" ]]; then
			zapis_gry
		fi
		
    else
        echo "Zły ruch, spróbuj ponownie"
    fi
done
