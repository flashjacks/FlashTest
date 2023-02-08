;---------------------------------------------------------
; FlashTest
; Hace un test de la memoria Flash devolviendonos lo
; códigos de identificación de la Flash.
;---------------------------------------------------------
; DEFINIR CONTANTES
;---------------------------------------------------------
; Variables de sistema MSX
FORCLR equ 0f3e9h ; Foreground colour
TERM0 equ 00h; Salida al MSXDOS
CSRSW equ FCA9h; Bit cursor ON/OFF
; Constantes nuestras 
SLOT1 equ 00000001b; Definimos el valor Slot1
SLOT2 equ 00000010b; Definimos el valor Slot2
;---------------------------------------------------------


; DIRECTIVAS PARA EL ENSAMBLADOR ( asMSX )
;---------------------------------------------------------
.bios ; Definir Nombres de las llamadas a la BIOS
;.page 2 ; Definir la dirección del código irá en 8000h
;.rom ; esto es para indicar que crearemos una ROM
.MSXDOS ; Esto es para indicar que quiero un .COM. Quitar .page2 y .rom
.start INICIO ; Inicio del Código de nuestro Programa
;---------------------------------------------------------


;---------------------------------------------------------
INICIO:
; INICIO DEL PROGRAMA
;---------------------------------------------------------
; Inicializa la pantalla ---------------------------------
.callbios CLS ; Borra la pantalla
ld hl, CSRSW  ; Apaga el cursor y evita ser visto mientras escribe.
ld [hl],0h ; Apaga el cursor y evita ser visto mientras escribe.
; Escribe el texto introductorio  ------------------------
ld hl,intro1 ; Imprime la primera línea por pantalla
call IMPRI_MENSAJE ; Imprimir la intro 1 
ld hl,intro2 ; Imprime la segunda línea por pantalla
call IMPRI_MENSAJE ; Imprimir la intro 2
ld hl,intro3 ; Imprime la tercera línea por pantalla
call IMPRI_MENSAJE ; Imprimir la intro 3
ld hl,intro4 ; Imprime la cuarta línea por pantalla
call IMPRI_MENSAJE ; Imprimir la intro 4
ld hl,intro5 ; Imprime la quinta línea por pantalla
call IMPRI_MENSAJE ; Imprimir la intro 5
; Escanea ROMS y FLASHROMS en SLOTS 1 y 2 ----------------
call FLASHSCAN; Hace un escaneo de los dos puertos buscando memorias FLASH y carga sus ID en las variables MANID y DEVID
call CARSLOTS1Y2; Hace un escaneo intentando leer las ROMS de los SLOTS 1 y 2 e identifica en CARSLOT1y2 lo encontrado
; Escribe el texto de lectura del SLOT1 ------------------
ld hl,intro6 ; Imprime la sexta línea por pantalla
call IMPRI_MENSAJE ; Imprimir la intro 6
ld a,[MANIDSLOT1]
call IMPRI_NUMERO; Imprime el numero "a" HEX de 8 bits por pantalla
ld a,20h;Carga el caracter espacio en a 
.callbios CHPUT; Imprime por pantalla un espacio.
ld a,[DEVIDSLOT1]
call IMPRI_NUMERO; Imprime el numero "a" HEX de 8 bits por pantalla
ld a,13;Carga el caracter return 
.callbios CHPUT; Imprime por pantalla return.
ld a,10;Carga el caracter return 
.callbios CHPUT; Imprime por pantalla return.
; Escribe la clasificación del tipo de cartucho por pantalla
ld a,[CARSLOT1]
call identROM ; Escribe la selección de Flashrom que hay en a por pantalla
ld a,13;Carga el caracter return 
.callbios CHPUT; Imprime por pantalla return.
ld a,10;Carga el caracter return 
.callbios CHPUT; Imprime por pantalla return.

; Escribe el texto de lectura del SLOT2 ------------------
ld hl,intro7 ; Imprime la septima línea por pantalla
call IMPRI_MENSAJE ; Imprimir la intro 7
ld a,[MANIDSLOT2]
call IMPRI_NUMERO; Imprime el numero "a" HEX de 8 bits por pantalla
ld a,20h;Carga el caracter espacio en a 
.callbios CHPUT; Imprime por pantalla un espacio.
ld a,[DEVIDSLOT2]
call IMPRI_NUMERO; Imprime el numero "a" HEX de 8 bits por pantalla
ld a,13;Carga el caracter return 
.callbios CHPUT; Imprime por pantalla return.
ld a,10;Carga el caracter return 
.callbios CHPUT; Imprime por pantalla return.
; Escribe la clasificación del tipo de cartucho por pantalla
ld a,[CARSLOT2]
call identROM ; Escribe la selección de Flashrom que hay en a por pantalla
ld a,13;Carga el caracter return 
.callbios CHPUT; Imprime por pantalla return.
ld a,10;Carga el caracter return 
.callbios CHPUT; Imprime por pantalla return.

; Escribe un enter adicional para separar el dos command del programa-------
ld a,13;Carga el caracter return 
.callbios CHPUT; Imprime por pantalla return.
ld a,10;Carga el caracter return 
.callbios CHPUT; Imprime por pantalla return.
; Finalizamos el programa y salimos al sistema -----------
call TERM0 ; Devuelve el control al sistema y FIN.
FIN:
jp FIN ; esto es como 100 goto 100
;---------------------------------------------------------

;---------------------------------------------------------
; VARIABLES
;---------------------------------------------------------
NSLOT: ; Aquí pondremos el Número de Slot que queremos
.db 0
MANIDSLOT1: ; Es la ID de manufactura del Slot 1
.db 0
DEVIDSLOT1: ; Es la ID del tipo de dispositivo del Slot 1
.db 0
MANIDSLOT2: ; Es la ID de manufactura del Slot 1
.db 0
DEVIDSLOT2: ; Es la ID del tipo de dispositivo del Slot 1
.db 0
CARSLOT1: ; Nos dice que hay en el Slot 1
.db 0; Si es 0 no hay ninguna ROM. 
     ; Si es 1 hay un cartucho ROM
     ; Si es 2 hay una FLASHROM con ID no disponible
     ; Si es 3 hay una FLASHROM con ID desconocido
     ; Si es 4 hay una FLASHROM AMD Am29F040B
     ; Si es 5 hay una FLASHROM AMD Am29F040
     ; Si es 6 hay una FLASHROM Fujitsu MBM29F040C
     ; Si es 7 hay una FLASHROM Alliance AS29F040
     ; Si es 8 hay una FLASHROM Macronix MX29F040
     ; Si es 9 hay una FLASHROM EON EN29F040
     ; Si es 10 hay una FLASHROM ST M29F040
 CARSLOT2: ; Nos dice que hay en el Slot 2
.db 0; Si es 0 no hay ninguna ROM. 
     ; Si es 1 hay un cartucho ROM
     ; Si es 2 hay una FLASHROM con ID no disponible
     ; Si es 3 hay una FLASHROM con ID desconocido
     ; Si es 4 hay una FLASHROM AMD Am29F040B
     ; Si es 5 hay una FLASHROM AMD Am29F040
     ; Si es 6 hay una FLASHROM Fujitsu MBM29F040C
     ; Si es 7 hay una FLASHROM Alliance AS29F040
     ; Si es 8 hay una FLASHROM Macronix MX29F040
     ; Si es 9 hay una FLASHROM EON EN29F040
     ; Si es 10 hay una FLASHROM ST M29F040
;---------------------------------------------------------



;---------------------------------------------------------
; TABLAS DE TEXTO
;---------------------------------------------------------
;    1234567890123456789012345678901234567890  Regla 40 car.
intro1:
.db "Comprobacion del cartucho FLASHROM.",13,10,0
intro2:
.db "-----------------------------------",13,10,0
intro3:
.db "Comprueba el ID de la memoria FLASH.",13,10,13,10,0
intro4:
.db "Programa Freeware creado por:",13,10,0
intro5:
.db "                   -2014- AquiJacks.",13,10,13,10,13,10,0
intro6:
.db "Se ha leido en el Slot1 el ID: ",0
intro7:
.db "Se ha leido en el Slot2 el ID: ",0
;---------------------------------------------------------




;---------------------------------------------------------
; A PARTIR DE AQUÍ COMIENZAN LAS RUTINAS
;---------------------------------------------------------

;---------------------------------------------------------
;---------------------------------------------------------
IMPRI_MENSAJE:
; RUTINA QUE IMPRIME EL TEXTO EN PANTALLA
;---------------------------------------------------------
; Poner en hl la dirección donde apunta el texto.
@@bucle:
ld a,[hl] ; leemos el primer carácter y lo metemos en A
or a ; comprobamos si hemos llegado al final del texto
ret z ; salimos de la rutina en el caso de que sea un cero
.callbios CHPUT ; escribimos ese carácter en la posición del cursor
inc hl ; incrementamos HL para que apunte a la siguiente letra
jr @@bucle ; como no hemos llegado al final continuamos escribiendo
;---------------------------------------------------------


;---------------------------------------------------------
;---------------------------------------------------------
IMPRI_NUMERO:
; RUTINA QUE IMPRIME UN NÚMERO DE 8 BYTES EN HEX ASCII POR
; PANTALLA.
;---------------------------------------------------------
; Poner en a el número a mostrar por pantalla
ld l,a
sra a
sra a
sra a
sra a ;Desplaza "a" cuatro bits a la derecha 
and a,0fh ;Borra los cuatro bits de la izquierda. Tenemos ahora las decenas en las unidades.
add a,30h ;Le suma 30h y convertimos el numero en ASCII
cp 3ah ;Compara para ver si supera el número 9 ASCII para saltar a las letras.
jp m,@@imtexto ; Si el número es negativo a-cp. Si está dentro de 0-9 salta a imtexto
add a,7h ; Si no está entre 0-9 añade 7 para alzanzar las letras A-F del ASCII
@@imtexto:
.callbios CHPUT ;Imprime las decenas del número por pantalla
ld a,l ;Carga en a el numero de la variable l
and a,0fh ;Borra los cuatro bits de la izquierda. Tenemos ahora las unidades.
add a,30h ;Le suma 30h y convertimos el numero en ASCII
cp 3ah ;Compara para ver si supera el número 9 ASCII para saltar a las letras.
jp m,@@imtexto2 ; Si el número es negativo a-cp. Si es está dentro de 0-9 y salta a imtexto2
add a,7h ; Si no está entre 0-9 añade 7 para alzanzar las letras A-F del ASCII
@@imtexto2:
.callbios CHPUT ;Imprime las unidades del número por pantalla
ret
;---------------------------------------------------------


;---------------------------------------------------------
;---------------------------------------------------------
FLASHID:
; RUTINA QUE ENVÍA EL COMANDO DE COGER ID A LA MEMORIA
; FLASHROM
;---------------------------------------------------------
; Poner en NSLOT el número de slot a hacer la lectura
; Envía secuencia de códigos al FLASHROM para petición ID.
ld e,f0h ; Reset FLASHROM. La inicializa.
ld a,[NSLOT] ; Carga slot 1
ld hl,9555h;Graba en dirección real ROM 5555h (4000h+5555h)
.callbios WRSLT ;Graba en slot.
ld e,aah ; Primera instrucción al FLASHROM
ld a,[NSLOT] ; Carga slot 1
ld hl,9555h;Graba en dirección real ROM 5555h (4000h+5555h)
.callbios WRSLT ;Graba en slot.
ld e,55h ; Segunda instrucción al FLASHROM
ld a,[NSLOT] ; Carga slot 1
ld hl,6aaah;Graba en dirección real ROM 2aaah (4000h+2aaah)
.callbios WRSLT ;Graba en slot.
ld e,90h ; Tercera instrucción al FLASHROM
ld a,[NSLOT] ; Carga slot 1
ld hl,9555h;Graba en dirección real ROM 5555h (4000h+5555h)
.callbios WRSLT ;Graba en slot.
ret
;---------------------------------------------------------


;---------------------------------------------------------
;---------------------------------------------------------
FLASHSCAN:
; RUTINA QUE ESCANEA LOS DOS SLOTS Y CARGA EN LAS VARIABLES
; ID (MANIDSLOT1 Y 2,DEVIDSLOT1 Y 2) LOS ID LEIDOS. 
;---------------------------------------------------------
ld a,SLOT1 ; Cargamos en a el SLOT1
ld [NSLOT],a; Seleccionamos en NSLOT el SLOT1
call FLASHID ; Solicitamos petición de ID a la memoria FLASH
ld a,SLOT1 ; Carga Slot 1
ld hl,4000h;Carga dirección 4000h
.callbios RDSLT ;Solicita valor dir4000h Slot1 y lo coloca en a.
ld [MANIDSLOT1],a
ld a,SLOT1 ; Carga Slot 1
ld hl,4001h;Carga dirección 4001h
.callbios RDSLT ;Solicita valor dir4000h Slot1 y lo coloca en a.
ld [DEVIDSLOT1],a
ld a,SLOT2 ; Cargamos en a el SLOT2
ld [NSLOT],a; Seleccionamos en NSLOT el SLOT2
call FLASHID ; Solicitamos petición de ID a la memoria FLASH
ld a,SLOT2 ; Carga Slot 1
ld hl,4000h;Carga dirección 4000h
.callbios RDSLT ;Solicita valor dir4000h Slot2 y lo coloca en a.
ld [MANIDSLOT2],a
ld a,SLOT2 ; Carga Slot 1
ld hl,4001h;Carga dirección 4001h
.callbios RDSLT ;Solicita valor dir4000h Slot2 y lo coloca en a.
ld [DEVIDSLOT2],a
ret
;---------------------------------------------------------


;---------------------------------------------------------
;---------------------------------------------------------
CARSLOTS1Y2:
; RUTINA QUE ESCANEA LOS DOS SLOTS Y CARGA EN LAS VARIABLES
; CARSLOT1 y 2 EL TIPO DE CARTUCHO DETECTADO
;---------------------------------------------------------
; Vamos a por la precarga para el Slot1
ld a,SLOT1 ; Cargamos en a el SLOT1
ld [NSLOT],a; Seleccionamos en NSLOT el SLOT1
ld a,[MANIDSLOT1] ; Cargamos MANIDSLOT1
ld [MANIDSLOTX],a; en MANIDSLOTX
ld a,[DEVIDSLOT1] ; Cargamos DEVIDSLOT1
ld [DEVIDSLOTX],a; en DEVIDSLOTX
call FUNCARSLOT; Llamamos a la funcion de búsqueda ID
ld a,[CARSLOTX] ; Cargamos CARSLOTX
ld [CARSLOT1],a; en CARSLOT1
; Vamos a por la precarga para el Slot2
ld a,SLOT2 ; Cargamos en a el SLOT1
ld [NSLOT],a; Seleccionamos en NSLOT el SLOT1
ld a,[MANIDSLOT2] ; Cargamos MANIDSLOT1
ld [MANIDSLOTX],a; en MANIDSLOTX
ld a,[DEVIDSLOT2] ; Cargamos DEVIDSLOT1
ld [DEVIDSLOTX],a; en DEVIDSLOTX
call FUNCARSLOT; Llamamos a la funcion de búsqueda ID
ld a,[CARSLOTX] ; Cargamos CARSLOTX
ld [CARSLOT2],a; en CARSLOT1
ret
;---------------------------------------------------------

; Esta función hace la identificación de lo que hay en el SlotX
FUNCARSLOT:
ld e,f0h ; Reset FLASHROM. La inicializa.
ld a,[NSLOT] ; Carga Slot 1
ld hl,9555h;Graba en dirección real ROM 5555h (4000h+5555h)
.callbios WRSLT ;Graba en slot.

; Vamos a comparar MANIDSLOT1 con la ROM 4000h. Primer dato
ld a,[MANIDSLOTX]; Carga MANIDSLOTX
push af; Lo metemos en el acumulador
ld a,[NSLOT] ; Carga Slot 1
ld hl,4000h;Carga dirección 4000h
.callbios RDSLT ;Solicita valor dir4000h Slot1 y lo coloca en a.
pop bc; Recuperamos acumulador y pone en b MANIDSLOT1
cp b ; Comparamos a con b = MANIDSLOTX con 4000h
jp nz,@@esunaflashrom; Si no es igual significa que es una FlasROM
cp 41h; Comparamos con 41h que es el primer byte de una ROM.
jp nz,@@aquinohaynada; Si no es significa que no hay nada en Slot1

; Vamos a comparar DEVIDSLOT1 con la ROM 4001h. Segundo dato
ld a,[DEVIDSLOTX]; Carga DEVIDSLOTX
push af; Lo metemos en el acumulador
ld a,[NSLOT] ; Carga Slot 1
ld hl,4001h;Carga dirección 4001h
.callbios RDSLT ;Solicita valor dir4001h Slot1 y lo coloca en a.
pop bc; Recuperamos acumulador y pone en b DEVIDSLOTX
cp b; Comparamos a con b = DEVIDSLOTX con 4001h
jp nz,@@esunaflashrom; Si no es igual significa que es una FlasROM
cp 42h; Comparamos con 42h que es el segundo byte de una ROM.
jp nz,@@aquinohaynada; Si no es significa que no hay nada en Slot1
; Llegados aquí significa que estamos ante un cartucho ROM
ld a,1h ;Cargamos 1 a CARSLOTX
ld [CARSLOTX],a ;Cargamos 1 a CARSLOTX
ret ;Fin de la subrutina
; Llegados aquí significa que no hay nada en este Slot.
@@aquinohaynada:
ld a,0h ;Cargamos 0 a CARSLOTX
ld [CARSLOTX],a;Cargamos 0 a CARSLOTX
ret;Fin de la subrutina
;Llegados aquí empezamos a comparar tipos de FlashRom
@@esunaflashrom:
; Comparamos si es una 014f que es una AMD Am29F040B
ld a,[MANIDSLOTX]; Carga MANIDSLOTX
cp 01h ;Comparamos si es el primer byte
jp nz,@@rompaso2 ; Si no es vamos a la siguiente comprobación
ld a,[DEVIDSLOTX]; Carga DEVIDSLOTX
cp 4fh ;Comparamos si es el segundo byte
jp nz,@@rompaso2; Si no es vamos a la siguiente comprobación
ld a,4h ;Cargamos 4 a CARSLOTX
ld [CARSLOTX],a;Cargamos 4 a CARSLOTX
ret;Fin de la subrutina
@@rompaso2:
; Comparamos si es una 01a4 que es una AMD Am29F040
ld a,[MANIDSLOTX]; Carga MANIDSLOTX
cp 01h ;Comparamos si es el primer byte
jp nz,@@rompaso3 ; Si no es vamos a la siguiente comprobación
ld a,[DEVIDSLOTX]; Carga DEVIDSLOTX
cp a4h ;Comparamos si es el segundo byte
jp nz,@@rompaso3; Si no es vamos a la siguiente comprobación
ld a,5h ;Cargamos 5 a CARSLOTX
ld [CARSLOTX],a;Cargamos 5 a CARSLOTX
ret;Fin de la subrutina
@@rompaso3:
; Comparamos si es una 04a4 que es una Fujitsu MBM29F040C
ld a,[MANIDSLOTX]; Carga MANIDSLOTX
cp 04h ;Comparamos si es el primer byte
jp nz,@@rompaso4 ; Si no es vamos a la siguiente comprobación
ld a,[DEVIDSLOTX]; Carga DEVIDSLOTX
cp a4h ;Comparamos si es el segundo byte
jp nz,@@rompaso4; Si no es vamos a la siguiente comprobación
ld a,6h ;Cargamos 6 a CARSLOTX
ld [CARSLOTX],a;Cargamos 6 a CARSLOTX
ret;Fin de la subrutina
@@rompaso4:
; Comparamos si es una 1c04 que es una EON EN29F040
ld a,[MANIDSLOTX]; Carga MANIDSLOTX
cp 1ch ;Comparamos si es el primer byte
jp nz,@@rompaso5 ; Si no es vamos a la siguiente comprobación
ld a,[DEVIDSLOTX]; Carga DEVIDSLOTX
cp 04h ;Comparamos si es el segundo byte
jp nz,@@rompaso5; Si no es vamos a la siguiente comprobación
ld a,9h ;Cargamos 9 a CARSLOTX
ld [CARSLOTX],a;Cargamos 9 a CARSLOTX
ret;Fin de la subrutina
@@rompaso5:
; Comparamos si es una 20E2 que es una ST M29F040
ld a,[MANIDSLOTX]; Carga MANIDSLOTX
cp 20h ;Comparamos si es el primer byte
jp nz,@@rompaso6 ; Si no es vamos a la siguiente comprobación
ld a,[DEVIDSLOTX]; Carga DEVIDSLOTX
cp e2h ;Comparamos si es el segundo byte
jp nz,@@rompaso6; Si no es vamos a la siguiente comprobación
ld a,10h ;Cargamos 10 a CARSLOTX
ld [CARSLOTX],a;Cargamos 10 a CARSLOTX
ret;Fin de la subrutina
@@rompaso6:
; Comparamos si es una 52A4 que es una Alliance AS29F040
ld a,[MANIDSLOTX]; Carga MANIDSLOTX
cp 52h ;Comparamos si es el primer byte
jp nz,@@rompaso7 ; Si no es vamos a la siguiente comprobación
ld a,[DEVIDSLOTX]; Carga DEVIDSLOTX
cp a4h ;Comparamos si es el segundo byte
jp nz,@@rompaso7; Si no es vamos a la siguiente comprobación
ld a,7h ;Cargamos 7 a CARSLOTX
ld [CARSLOTX],a;Cargamos 7 a CARSLOTX
ret;Fin de la subrutina
@@rompaso7:
; Comparamos si es una C2A4 que es una Macronix MX29F040
ld a,[MANIDSLOTX]; Carga MANIDSLOTX
cp c2h ;Comparamos si es el primer byte
jp nz,@@rompaso8 ; Si no es vamos a la siguiente comprobación
ld a,[DEVIDSLOTX]; Carga DEVIDSLOTX
cp a4h ;Comparamos si es el segundo byte
jp nz,@@rompaso8; Si no es vamos a la siguiente comprobación
ld a,8h ;Cargamos 8 a CARSLOT1
ld [CARSLOTX],a;Cargamos 8 a CARSLOTX
ret;Fin de la subrutina
@@rompaso8:
; Comparamos si es una 7f7f que es una Flashrom con ID no disponible
ld a,[MANIDSLOTX]; Carga MANIDSLOTX
cp 7fh ;Comparamos si es el primer byte
jp nz,@@rompaso9 ; Si no es vamos a la siguiente comprobación
ld a,[DEVIDSLOTX]; Carga DEVIDSLOTX
cp 7fh ;Comparamos si es el segundo byte
jp nz,@@rompaso9; Si no es vamos a la siguiente comprobación
ld a,2h ;Cargamos 2 a CARSLOTX
ld [CARSLOTX],a;Cargamos 2 a CARSLOTX
ret;Fin de la subrutina
@@rompaso9:
; Llegados aquí nos encontramos una Flashrom con ID desconocido
ld a,3h ;Cargamos 2 a CARSLOTX
ld [CARSLOTX],a;Cargamos 2 a CARSLOTX
ret
;---------------------------------------------------------
; Variables de esta subrutina
MANIDSLOTX: ; Es la ID de manufactura del Slot X
.db 0
DEVIDSLOTX: ; Es la ID del tipo de dispositivo del Slot X
.db 0
CARSLOTX: ; Nos dice que hay en el Slot X
.db 0
;---------------------------------------------------------


;---------------------------------------------------------
;---------------------------------------------------------
identROM:
; RUTINA QUE MEDIANTE EL CARSLOTX CARGADO EN a IMPRIME
; POR PANTALLA EL TEXTO ASOCIADO DE LA IDENTIFICACIÓN.
;---------------------------------------------------------
cp 0h ;Comparamos el con el valor 0. No hay ninguna ROM
jp nz,@@identROM1 ; Si no es vamos a la siguiente comprobación
ld hl,textIDROM0 ; Imprime no hay cartucho
call IMPRI_MENSAJE ; Imprimir texto seleccionado
ret
@@identROM1:
cp 1h ;Comparamos el con el valor 1. Hay un cartucho ROM
jp nz,@@identROM2 ; Si no es vamos a la siguiente comprobación
ld hl,textIDROM1 ; Imprime hay cartucho ROM
call IMPRI_MENSAJE ; Imprimir texto seleccionado
ret
@@identROM2:
cp 2h ;Comparamos el con el valor 2. Flashrom con ID no disponible
jp nz,@@identROM3 ; Si no es vamos a la siguiente comprobación
ld hl,textIDROM2 ; Imprime Flashrom con ID no disponible
call IMPRI_MENSAJE ; Imprimir texto seleccionado
ret
@@identROM3:
cp 3h ;Comparamos el con el valor 3. Flashrom con ID desconocido
jp nz,@@identROM4 ; Si no es vamos a la siguiente comprobación
ld hl,textIDROM3 ; Imprime Flashrom con ID desconocido
call IMPRI_MENSAJE ; Imprimir texto seleccionado
ret
@@identROM4:
cp 4h ;Comparamos el con el valor 4. Flashrom AMD Am29F040B
jp nz,@@identROM5 ; Si no es vamos a la siguiente comprobación
ld hl,textIDROM4 ; Imprime Flashrom AMD Am29F040B
call IMPRI_MENSAJE ; Imprimir texto seleccionado
ret
@@identROM5:
cp 5h ;Comparamos el con el valor 5. Flashrom AMD Am29F040
jp nz,@@identROM6 ; Si no es vamos a la siguiente comprobación
ld hl,textIDROM5 ; Imprime Flashrom AMD Am29F040
call IMPRI_MENSAJE ; Imprimir texto seleccionado
ret
@@identROM6:
cp 6h ;Comparamos el con el valor 6. Flashrom Fujitsu MBM29F040C
jp nz,@@identROM7 ; Si no es vamos a la siguiente comprobación
ld hl,textIDROM6 ; Imprime Flashrom Fujitsu MBM29F040C
call IMPRI_MENSAJE ; Imprimir texto seleccionado
ret
@@identROM7:
cp 7h ;Comparamos el con el valor 7. Flashrom Alliance AS29F040
jp nz,@@identROM8 ; Si no es vamos a la siguiente comprobación
ld hl,textIDROM7 ; Imprime Flashrom Alliance AS29F040
call IMPRI_MENSAJE ; Imprimir texto seleccionado
ret
@@identROM8:
cp 8h ;Comparamos el con el valor 8. Flashrom Macronix MX29F040
jp nz,@@identROM9 ; Si no es vamos a la siguiente comprobación
ld hl,textIDROM8 ; Imprime Flashrom Macronix MX29F040
call IMPRI_MENSAJE ; Imprimir texto seleccionado
ret
@@identROM9:
cp 9h ;Comparamos el con el valor 9. Flashrom EON EN29F040
jp nz,@@identROM10 ; Si no es vamos a la siguiente comprobación
ld hl,textIDROM9 ; Imprime Flashrom EON EN29F040
call IMPRI_MENSAJE ; Imprimir texto seleccionado
ret
@@identROM10:
cp 10h ;Comparamos el con el valor 10. Flashrom ST M29F040
jp nz,@@identROM11 ; Si no es vamos a la siguiente comprobación
ld hl,textIDROM10 ; Imprime Flashrom ST M29F040
call IMPRI_MENSAJE ; Imprimir texto seleccionado
ret
@@identROM11:
; Llegados a este punto significa que hay un error de programación.
ld hl,textIDROM11 ; Imprime Error de programación.
call IMPRI_MENSAJE ; Imprimir texto seleccionado
ret
;---------------------------------------------------------
; Variables de esta subrutina
;    1234567890123456789012345678901234567890  Regla 40 car.
textIDROM0:
.db "-No se detecta ROM ni FLASHROM-",13,10,0
textIDROM1:
.db "-Detectado un cartucho con una ROM-",13,10,0
textIDROM2:
.db "-FlashRom OK con ID no disponible-",13,10,0
textIDROM3:
.db "-FlashRom OK con ID desconocido-",13,10,0
textIDROM4:
.db "-FlashRom OK: AMD Am29F040B-",13,10,0
textIDROM5:
.db "-FlashRom OK: AMD Am29F040-",13,10,0
textIDROM6:
.db "-FlashRom OK: Fujitsu MBM29F040C-",13,10,0
textIDROM7:
.db "-FlashRom OK: Alliance AS29F040-",13,10,0
textIDROM8:
.db "-FlashRom OK: Macronix MX29F040-",13,10,0
textIDROM9:
.db "-FlashRom OK: EON EN29F040-",13,10,0
textIDROM10:
.db "-FlashRom OK: ST M29F040-",13,10,0
textIDROM11:
.db "-Error de programación.Lo siento.-",13,10,0
;---------------------------------------------------------