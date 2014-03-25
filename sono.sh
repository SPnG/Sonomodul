#!/bin/sh

# Gehört zum Sonoprogramm
# Wird zum Aufruf von sono1.sh benötigt.

# mr@speedpoint.de  Version 21.09.2012
# Sono-Anbindung
# Start aus DavidX, Patient, Programme
# 
# Programm startet Programm sono-davidx.exe auf dem Windows-PC
#
# Auf dem Server muss in /etc/hosts ein Eintrag für diesen Platz existieren.
# Beispiel: 
# Dieser WinPC hat die IP = 192.168.0.30
# Dieser Linux-User ist platz02
# Eintrag in /etc/hosts:
# 192.168.0.30 platz02 
#
# -----------------------------------------------------------------------
# Vorgaben
#
# Portnummer des Rexservers auf dem Win.PC:
rexport="6666"

# Name des Sonoordners beim Patienten
sonodirnam="sonobilder"

# Symlinkname in trpword
sonosymlink="sono-patient"

# Datum im Dateinamen (0 oder 1 oder 2)
# 0=kein Datum, 1=Datum wird vorgeschlagen, 2=Datum kommt automatisch 
datregel="2"

# Datumformat im Dateinamen (3-stellig, z.B. JMT)
#     J=Jahr, M=Monat, T=Tag
# z.B. JMT wird zu 2012-09-26
datformat="JMT"

# PraxisID fest auf A stellen
pxid="A"

# -----------------------------------------------------------------------
# ab hier Finger weg!
#
# TermID aus david.cfg ermitteln
davuser=`echo $USER`
termid=`cat /home/david/david.cfg|fgrep $davuser|fgrep -v \#|awk '{print $10}'`

# PatNr ermitteln
pnr=`head -n 1 /home/david/trpword/$termid/text.$termid`

#
#locnam="`who -m|awk '{print $1}'`"
locnam=`echo $USER`

locip="`cat /etc/hosts|fgrep -w $locnam|fgrep -v \#|awk '{print $1}'`"

trpw="/home/david/trpword"
pfad=`echo $pnr | awk '{printf("%08.f\n",$1)}' | awk -F '' '{printf("%d/%d/%d/%d/%d/%d/%d/%d",$1,$2,$3,$4,$5,$6,$7,$8)}'`
fullpfad="$trpw/pat_nr/$pxid/$pfad"

# Ordner Sonobilder im Patordner anlegen
mkdir -p -m 777 "$fullpfad/$sonodirnam" > /dev/null  
# Symlink "sono-patient" in trpword erzeugen
rm -rf $trpw/$sonosymlink > /dev/null
ln -s $fullpfad/$sonodirnam $trpw/$sonosymlink > /dev/null

datform=$datformat$datregel
echo "DAVCMD start %systemdrive%\\david\\sono\\sono-davidx.exe /copyto=$sonosymlink /patnr=$pnr /datformat=$datform"|netcat $locip $rexport > /dev/null

exit 0
