#!/bin/bash

# В данной переменной хранится яркость.
BRIGHTNESS=0.5

# Значение, на которое увеличивается\уменьшается яркость
STEP=0.1

# Передаем сюда полный путь к данному скрипту (чтобы знать, куда сохранять яркость)
SCRIPT=$0

# Переменная принимает первый входной параметр - интерфейс
OUTPUT=$1

# Сохраняем яркость прямо в этот скрипт (переменная BRIGHTNESS)
SaveBrightness() {
	suffixArg=()
	sed --version 2>/dev/null | grep -q GNU || suffixArg=( '' )

	sed -i "${suffixArg[@]}" '
	s/^\(BRIGHTNESS\)=.*/\1='"$1"'/
	' "$SCRIPT"
}

# Увеличиваем яркость на число STEP
UpBrightness() {
	NEW_BRIGHTNESS=$(echo "$STEP+$BRIGHTNESS" | bc | sed -r 's/^(-?)\./\10\./');
	xrandr --output $OUTPUT --brightness $NEW_BRIGHTNESS;
}

# Уменьшаем яркость на число STEP
DownBrightness() {
	NEW_BRIGHTNESS=$(echo "$BRIGHTNESS-$STEP" | bc | sed -r 's/^(-?)\./\10\./');
	xrandr --output $OUTPUT --brightness $NEW_BRIGHTNESS;
}

# Применяем (восстанавливаем) сохраненную в переменной BRIGHTNESS яркость
RestoreBrightness() {
	xrandr --output $OUTPUT --brightness $BRIGHTNESS;
}

# Принимаем второй параметр запуска скрипта, выбираем, что нужно делать
case $2 in
     up)
		UpBrightness
		SaveBrightness $NEW_BRIGHTNESS
		notify-send -t 1200 "Set brightness = "$NEW_BRIGHTNESS" in output "$OUTPUT
		echo "Set brightness = "$NEW_BRIGHTNESS" in output "$OUTPUT
		;;
     down)
		DownBrightness
		SaveBrightness $NEW_BRIGHTNESS
		notify-send -t 1200 "Set brightness = "$NEW_BRIGHTNESS" in output "$OUTPUT
		echo "Set brightness = "$NEW_BRIGHTNESS" in output "$OUTPUT
		;;
     restore)
		RestoreBrightness
		notify-send -t 1200 "Set brightness = "$BRIGHTNESS" in output "$OUTPUT
		echo "Set brightness = "$BRIGHTNESS" in output "$OUTPUT
		;; 
     *)
		echo "Unknown command!"
		;;
esac

exit 0
