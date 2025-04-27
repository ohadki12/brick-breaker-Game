IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------
misgeretColor db 0
 note dw 2394h ; 1193180 / 131 -> (hex)
arebipon db 0;0-no,1-yes
areyouwin db 0;0-no,1-yes
;ardelayforxdrawtoend db 30 dup(0)
arrareblockstillalive db 30 dup(0);0-yes,1-no,but still bing seen just with a x on it,2-no
aredrawagainblocks db 0;0 not,1 yes
arrblocksplacebackgroundcolorvalue db 7500 dup(0)
;ballhitblockup db 0
;ballhitblockdown db 0
;ballhitblockleft db 0
;ballhitblockright db 0
arrvalueofcolorblock db 30 dup(1)
arryfirstplaceblocks  dw 10,10,10,10,10,10,10,10,10,10,10,10,30,30,30,30,30,30,30,30,30,30,30,30,30
arrxfirstplaceblocks dw 70,90,110,130,150,170,190,210,230,250,270,290,80,100,120,140,160,180,200,220,240,260,280,300,320
arrcolorvalueofthepaddle db 6,6,39,39,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,39,39,6,6,6,6,6,6,39,39,5,5,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,5,5,39,39,6,6,6,6,6,6,6,6,6,6,39,39,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,39,39,6,6,6,6,6,6,6,6,6,6,6,6,6,6,39,39,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,39,39,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,39,39,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,39,39,6,6,6,6,6,6,6,6,6,6
areballdrop db 0
;msgfilscore db  '        $'
hitsscoremsg db 'hits:   $'
movescoremsg db 'moves:  $'
triesscoremsg db'tries:  $'
scorescoremsg db'score:  $'
ballfalledmsg db 'oops, you drop your ball,enter space to continue$'
score dw 0;number of score
tries dw 3;number of tries you have
moves dw 80;number of moves you have
hits dw 0;nuber of hits,dhow on the board of the game
usexory db 0;tell if use x or y 0=use x 1=use y
randomnumfrom0to1 db 0
how_much_move_x_then_move_one_y db 1;how much to draw in the same x row then move in the y row
how_much_move_y_then_move_one_x db 3;how much to draw in the same y row then move in the x row
movex db 0
movey db 0
OrigPalette 	db 256*4 dup (0)
filenamelose db 'test16.bmp',0
filenamewin db 'test15.bmp',0
filenamebackground db 'test14.bmp',0
filenamestart db 'test13.bmp',0
filenameinstructions db 'test17.bmp',0
filehandle dw ?
Header db 54 dup (0)
Palette db 256*4 dup (0)
ScrLine db 320 dup (0) 
ErrorMsg db 'Error', 13, 10 ,'$'
subballxway dw 1
arrreplacepixelsball db 4 dup(0);the value of the colot thats need to to draw again after the ball was there.
arrreplacepixelspaddle db 2400 dup (0);150
addballxway dw 2
arr2 dw 10 dup(0) ;0-rapair paddle width,2-loop find paddle destroyed,4-loop draw lines;6-drawblocksbackgroundarea
arr db  20 dup(0);place 0- paddle lengh,,2-ball lengh,3-ball width,4 and 5- find ball deystroyed color loop,  8-loop find paddle destroy colors ,10-draw blocks loop y,11-draw blocks loop x,12-loop draw misgeretColorck block frame,13-loop of how many block to print,14-loop draw x on block when brake,15-loop of draw the background when the blocks at,16-to check if win loop,17-resat arrballstillalive array to 0
paddlex dw 4ah
paddley dw 190
ballx dw 29h
bally dw 190
ballxway dw 0;check to which direction the bal need to go,1-add,0-sub
ballyway dw 0;check to which direction the bal need to go,1-add,0-sub
CODESEG
;complete the write of the score with misgeretColorck which is the background of the text mode in graphic mode
proc complitewrite
mov cx,5
loopcomplitewrite:
mov dl,' '
mov ah,2
int 21h
loop loopcomplitewrite
ret
endp complitewrite
;proc readPaletteFromScreen	
;	mov dx,3C7h ; palette data read port
;	mov ax,0 ; color index 0
;	out dx,ax ; outputing the data
;	mov dx,3C9h ; we set dx to data port
	
;	mov si,offset OrigPalette 
;	mov cx,256 ; loop boundary of 256 colors to change
	
;readPalLoop:
;	in al,dx ; red color to bl	
;	shl al, 2
;	mov [si + 2], al
	
;	in al,dx ; green color to cl
;	shl al, 2
;	mov [si + 1], al
	
;	in al,dx ; blue color to ch
;	shl al, 2
;	mov [si], al
	
;	add si,4
	
;	loop readPalLoop
	
	;ret
;endp readPaletteFromScreen
;proc open file of the instructions picture
proc OpenFileinstructions
; Open file
mov ah, 3Dh
xor al, al
mov dx, offset filenameinstructions
int 21h
jc openerror2
mov [filehandle], ax
ret
openerror2 :
mov dx, offset ErrorMsg
mov ah, 9h
int 21h
ret
endp OpenFileinstructions
;pro
proc OpenFilestart
;proc open file of the start picture
mov ah, 3Dh
xor al, al
mov dx, offset filenamestart
int 21h
jc openerror
mov [filehandle], ax
ret
openerror :
mov dx, offset ErrorMsg
mov ah, 9h
int 21h
ret
endp OpenFilestart
;proc open file of the background of the game picture
proc OpenFilebackground
; Open file
mov ah, 3Dh
xor al, al
mov dx, offset filenamebackground
int 21h
jc openerror1
mov [filehandle], ax
ret
openerror1 :
mov dx, offset ErrorMsg
mov ah, 9h
int 21h
ret
endp OpenFilebackground
;proc open file of the win picture
proc OpenFilewin
; Open file
mov ah, 3Dh
xor al, al
mov dx, offset filenamewin
int 21h
jc openerror11
mov [filehandle], ax
ret
openerror11 :
mov dx, offset ErrorMsg
mov ah, 9h
int 21h
ret
endp OpenFilewin
;proc open file of the lose picture
proc OpenFilelose
; Open file
mov ah, 3Dh
xor al, al
mov dx, offset filenamelose
int 21h
jc openerror111
mov [filehandle], ax
ret
openerror111:
mov dx, offset ErrorMsg
mov ah, 9h
int 21h
ret
endp OpenFilelose
proc ReadHeader
; Read BMP file header, 54 bytes
mov ah,3fh
mov bx, [filehandle]
mov cx,54
mov dx,offset Header
int 21h
ret
endp ReadHeader
proc ReadPalette
; Read BMP file color palette, 256 colors * 4 bytes (400h)
mov ah,3fh
mov cx,400h
mov dx,offset Palette
int 21h
ret
endp ReadPalette
;proc OrigPaletteRead
; Read BMP file color palette, 256 colors * 4 bytes (400h)
;mov ah,3fh
;mov cx,400h
;mov dx,offset OrigPalette
;int 21h
;ret
;endp OrigPaletteRead
proc CopyPal
; Copy the colors palette to the video memory
; The number of the first color should be sent to port 3C8h
; The palette is sent to port 3C9h
mov si,offset Palette
mov cx,256
mov dx,3C8h
mov al,0
; Copy starting color to port 3C8h
out dx,al
; Copy palette itself to port 3C9h
inc dx
PalLoop:
; Note: Colors in a BMP file are saved as BGR values rather than RGB .
mov al,[si+2] ; Get red value .
shr al,2 ; Max. is 255, but video palette maximal
; value is 63. Therefore dividing by 4.
out dx,al ; Send it .
mov al,[si+1] ; Get green value .
shr al,2
out dx,al ; Send it .
mov al,[si] ; Get blue value .
shr al,2
out dx,al ; Send it .
add si,4 ; Point to next color .
; (There is a null chr. after every color.)
loop PalLoop
ret
endp CopyPal
;proc CopyorigPal
; Copy the colors palette to the video memory
; The number of the first color should be sent to port 3C8h
; The palette is sent to port 3C9h
;mov si,offset OrigPalette
;mov cx,256
;mov dx,3C8h
;mov al,0
; Copy starting color to port 3C8h
;out dx,al
; Copy palette itself to port 3C9h
;inc dx
;PalrealLoop:
; Note: Colors in a BMP file are saved as BGR values rather than RGB .
;mov al,[si+2] ; Get red value .
;shr al,2 ; Max. is 255, but video palette maximal
; value is 63. Therefore dividing by 4.
;out dx,al ; Send it .
;mov al,[si+1] ; Get green value .
;shr al,2
;out dx,al ; Send it .
;mov al,[si] ; Get blue value .
;shr al,2
;out dx,al ; Send it .
;add si,4 ; Point to next color .
; (There is a null chr. after every color.)
;loop PalrealLoop
;ret
;endp CopyorigPal
	proc CopyBitmap
; BMP graphics are saved upside-down .
; Read the graphic line by line (200 lines in VGA format),
; displaying the lines from bottom to top.
mov ax, 0A000h
mov es, ax
mov cx,200
PrintBMPLoop :
push cx
; di = cx*320, point to the correct screen line
mov di,cx
shl cx,6
shl di,8
add di,cx
; Read one line
mov ah,3fh
mov cx,320
mov dx,offset ScrLine
int 21h
; Copy one line into video memory
cld ; Clear direction flag, for movsb
mov cx,320
mov si,offset ScrLine
rep movsb ; Copy line to the screen
 ;rep movsb is same as the following code :
 ;mov es:di, ds:si
 ;inc si
 ;inc di
 ;dec cx
;loop until cx=0
pop cx
loop PrintBMPLoop
ret
endp CopyBitmap
;proc that can print numbers that are bigger then 9,use for writing the score
proc string
mov bh,3
mov bp,sp
mov ax,[bp+2]
mov cx,10
loopprintnumber1:
xor dx,dx
div cx
;mov cl,ah
push dx

sub bh,1
cmp bh,0
jg loopprintnumber1
mov bh,3
xor dx,dx
loopprintnumber2:
POP dx
add dx,'0'
mov ah,2
int 21h
sub bh,1
cmp bh,0
jg loopprintnumber2
ret 2
endp string;;;;;;;;;;;;;;;;;;;;;;;;;;;
;system time ,loop many times and from that make a delay
proc systemtime
mov bp,sp
mov cx,60000;[bp+2]
loopdelay:
loop loopdelay
mov cx,60000
loopdelay2:
loop loopdelay2
mov cx,60000;[bp+2]
loopdelay3:
loop loopdelay3
mov cx,60000
loopdelay4:
loop loopdelay4
mov cx,60000;[bp+2]
loopdelay5:
loop loopdelay5
mov cx,60000
loopdelay6:
loop loopdelay6
mov cx,60000
loopdelay7:
loop loopdelay7
mov cx,60000
loopdelay8:
loop loopdelay8
mov cx,60000
loopdelay9:
loop loopdelay9
mov cx,60000
loopdelay10:
loop loopdelay10

ret 
endp systemtime


;go line down
proc linedown
mov dl,10
mov ah,2
int 21h
ret 
endp linedown
;draw the padle using push to the x and y first location

proc drawpaddle
mov bp,sp


mov ah,0ch
;mov al,03h
mov bl,00h
mov cx,[bp+4]
mov dx,[bp+2]
;mov [offset bally],dx
mov [arr],5
mov si,0
l2:
sub [arr],1
		mov [arr+1],45;30
		l1:
		sub [arr+1],1
		mov al,[arrcolorvalueofthepaddle+si]
		inc si
		int 10h
		inc cx
		cmp [arr+1],0
		jg l1
mov cx,[bp+4]

inc dx		
cmp [arr],0
jg l2
ret 4
endp drawpaddle
;draw the background by that the paddle move and destroyed the color of the pixel
proc drawrepairpixelspaddle
mov bp,sp

mov si,0
mov ah,0ch
mov al,0eh
mov bl,00h
mov cx,64;70;0;[bp+4]
mov dx,190;[bp+2]
;mov [offset bally],dx
mov [arr],5

drawrepairpixelspaddleyloop:
sub [arr],1
		mov [arr2],300
	     drawrepairpixelspaddlexloop:
		sub [arr2],1
		mov al,[arrreplacepixelspaddle+si]
		int 10h
		inc cx
		inc si
		cmp [arr2],0
		jg drawrepairpixelspaddlexloop
mov cx,64;70;0;[bp+4]

inc dx		
cmp [arr],0
jg drawrepairpixelspaddleyloop
ret 2
endp drawrepairpixelspaddle

;the paddle movements check if left or right been pressed  if yes change the x paddle position
proc paddlemovements

in al,64h
cmp al,2
je keynotpress

in al,60h
cmp al,1eh
je apress
cmp al,20h
je dpress
cmp al,1h
je exitesc
jmp keynotpress
exitesc:
jmp exit
apress:;if a buttom have been pressed if yes sub by 2 the paddle place
cmp [paddlex],64
jle keynotpress

push [paddley]
call drawrepairpixelspaddle
sub [paddlex],2
jmp keynotpress
dpress:  ;if d buttom have been pressed if yes add by 2 the paddle place
cmp [paddlex],273;205
jg keynotpress
;push [paddlex]
push [paddley]
call drawrepairpixelspaddle
add [paddlex],2
keynotpress:
ret 
endp paddlemovements
;proc that are drawing the ball using the x and y cords that are in the stack
proc drawball
mov bp,sp
mov al,2
mov bl,0
mov cx,[bp+4]
mov dx,[bp+2]
mov ah,0ch
mov [arr+2],2
loopdrawbally:
mov [arr+3],2
mov cx,[ballx]
loopdrawballx:
int 10h
inc cx
sub [arr+3],1
cmp [arr+3],0
jg loopdrawballx
inc dx
sub [arr+2],1
cmp [arr+2],0
jg loopdrawbally
ret 4
endp drawball
;ball movments,keep the ball inside the area
proc ballmoveplace
mov bp,sp
cmp [ballx],63;0
jle addxball
cmp [ballx],319;248
jge subxball
cmp [bally],0
jle addyball
cmp [bally],199
jge exitexit
cmp [moves],0
je exitexit1
jmp notexitexit
exitexit:
dec [tries]
mov [areballdrop],1
call writescore
cmp [tries],0
je exitexit1
jmp notexitexit
exitexit1:
jmp exit1
;jmp subyball
notexitexit:
jmp checkifonpaddle
addxball:
add [ballx],1

;mov [movex],0
call moveball90degrese;--------------
mov [ballxway],1
;mov ax,1
jmp dontdo
subxball:
sub [ballx],1
;mov [movex],0
call moveball90degrese;-------------
mov [ballxway],0
;mov ax,1
jmp dontdo
addyball:
add [bally],1

mov [ballyway],1
jmp dontdo
;subyball:
;mov [ballyway],0
jmp dontdo

checkifonpaddle:
mov ax,[paddlex]
sub ax,2
cmp [ballx],ax
jl dontdo
add ax,48;46;:34;32
cmp [ballx],ax
jg dontdo
;mov ax,[paddley]
cmp [bally],189
jl dontdo
cmp [bally],191
jg dontdo
mov [ballyway],0
push [paddlex]
push [ballx]
call ballmovments
call bipon
sub [moves],1
cmp [score],0
jle donotdecscore
dec [score]
donotdecscore:
call writescore
;call beepon
sub [bally],1
mov ax,[ballx]
mov bx,[paddlex]
sub ax,bx

cmp ax,22
jl subballxx
jmp addballxx
subballxx:
mov [ballxway],0
jmp dontdo
addballxx:
mov [ballxway],1
jmp dontdo



dontdo:
cmp [usexory],1
je usey
usex:
cmp [movex],0               
jg movexnotzero
jmp endmovex
movexnotzero:
mov ax,0;1
mov bx,1;0
dec [movex]
jmp endmovex2
endmovex:
mov al,[how_much_move_y_then_move_one_x]
mov [movex],al
mov ax,1
mov bx,1
jmp endmovex2
usey:
cmp [movex],0               
jg movexnotzero2
jmp endmovex3
movexnotzero2:
mov ax,1
mov bx,0
dec [movex]
jmp endmovex2
endmovex3:
mov al,[how_much_move_x_then_move_one_y]
mov [movex],al
mov ax,1
mov bx,1
jmp endmovex2
endmovex2:
cmp [ballxway],1
je addballx
jmp subballx
addballx:

add [ballx],ax;1;-------
jmp endx 
subballx:

sub [ballx],ax;1;-------
endx:
cmp [ballyway],1
je addbally
jmp subbally
addbally:
add [bally],bx;0;-------
jmp endy
subbally:
sub [bally],bx;0;-------
jmp endy
endy:

ret 
endp ballmoveplace
;draw the pixels on the background where the ball have been destryed
proc drawdarkball
mov bp,sp
mov si,0
mov bl,0
mov cx,[bp+4]
mov dx,[bp+2]
mov ah,0ch
mov [arr+2],2
loopdrawdarkbally:
mov [arr+3],2
mov cx,[ballx]
loopdrawdarkballx:
mov al,[arrreplacepixelsball+si]
int 10h
inc si
inc cx
sub [arr+3],1
cmp [arr+3],0
jg loopdrawdarkballx
inc dx
sub [arr+2],1;4
cmp [arr+2],0
jg loopdrawdarkbally
ret 4
endp drawdarkball
;find the value of the colors that need to draw after the ball been there
proc findvaluecolor
mov bp,sp
mov si,0
mov cx,[bp+4]
mov dx,[bp+2]
mov ah,0dh
mov [arr+4],2
loopfindbally:
mov [arr+5],2
	loopfindballx:
	int 10h
	mov [arrreplacepixelsball+si],al
	inc si
	inc cx
	sub [arr+5],1
	cmp [arr+5],0
	jg loopfindballx
mov cx,[bp+4]
inc dx
sub [arr+4],1
cmp [arr+4],0
jg loopfindbally

ret 4
endp findvaluecolor
;find the value of the background which where the paddle have been destryed
proc findpaddlecolorvalue
mov bp,sp
mov si,0
mov cx,64;[bp+4]
mov dx,190;[bp+2]
mov ah,0dh
mov [arr+8],8
loopfindpaddley:
mov [arr2+2],300;30
	loopfindpaddlex:
	int 10h
	mov [arrreplacepixelspaddle+si],al
	inc si
	inc cx
	sub [arr2+2],1
	cmp [arr2+2],0
	jg loopfindpaddlex
mov cx,64;[bp+4]
inc dx
sub [arr+8],1;7
cmp [arr+8],0
jg loopfindpaddley

ret ;4 
endp findpaddlecolorvalue
;when the ball hited the paddle find where the ball have hited the paddle, then give correct value to the movements of the ball ,value of how much move the x then move the y or the oppside
proc ballmovments
mov bp,sp
mov ax,[bp+2];[paddlex]
sub ax,[bp+4];[ballx]
cmp ax,5
jle placepaddle1
cmp ax,10
jle placepaddle2
cmp ax,15
jle placepaddle3
cmp ax,20
jle placepaddle4
cmp ax,25
jle placepaddle5
cmp ax,30
jle placepaddle6
cmp ax,35

jmp endballmovments2
placepaddle1:
mov [usexory],1
mov [how_much_move_x_then_move_one_y],4
call randomfrom0to1
mov al,[randomnumfrom0to1]
sub [how_much_move_x_then_move_one_y],al
jmp endballmovments
placepaddle2:
mov [usexory],1
mov [how_much_move_x_then_move_one_y],3
call randomfrom0to1
mov al,[randomnumfrom0to1]
sub [how_much_move_x_then_move_one_y],al
jmp endballmovments
placepaddle3:
mov [usexory],0;x
mov [how_much_move_y_then_move_one_x],1
call randomfrom0to1
mov al,[randomnumfrom0to1]
sub [how_much_move_y_then_move_one_x],al
jmp endballmovments
placepaddle4:
mov [usexory],0;x
mov [how_much_move_y_then_move_one_x],2
call randomfrom0to1
mov al,[randomnumfrom0to1]
sub [how_much_move_y_then_move_one_x],al
jmp endballmovments
placepaddle5:
mov [usexory],0;x
mov [how_much_move_y_then_move_one_x],4
call randomfrom0to1
mov al,[randomnumfrom0to1]
sub [how_much_move_y_then_move_one_x],al
jmp endballmovments
placepaddle6:
mov [usexory],0;x
mov [how_much_move_y_then_move_one_x],2
call randomfrom0to1
mov al,[randomnumfrom0to1]
sub [how_much_move_y_then_move_one_x],al
jmp endballmovments
endballmovments2:
cmp ax,35
jle placepaddle7
cmp ax,40
jle placepaddle8
cmp ax,45
jle placepaddle9
jmp endballmovments
placepaddle7:
mov [usexory],0;x
mov [how_much_move_y_then_move_one_x],1
call randomfrom0to1
mov al,[randomnumfrom0to1]
sub [how_much_move_y_then_move_one_x],al
jmp endballmovments
placepaddle8:
mov [usexory],1;y
mov [how_much_move_x_then_move_one_y],3
call randomfrom0to1
mov al,[randomnumfrom0to1]
sub [how_much_move_x_then_move_one_y],al
jmp endballmovments
placepaddle9:
mov [usexory],1;y
mov [how_much_move_x_then_move_one_y],4
call randomfrom0to1
mov al,[randomnumfrom0to1]
sub [how_much_move_x_then_move_one_y],al
endballmovments:




ret 4
endp ballmovments
;random number un range from zero to one which helping in the movments of the ball
proc randomfrom0to1
 mov ah, 00h  ; interrupts to get system time
    INT 1AH      ; CX:DX now hold number of clock ticks since midnight
    mov  ax, dx
    xor  dx, dx
    mov  cx, 3
    div  cx   
and dl,00000001b   
mov [randomnumfrom0to1],dl
ret 
endp randomfrom0to1
;when the ball hited the sides of the area and he is going upside,change the direction of the ball
proc moveball90degrese
cmp [ballyway],1
je endball90degrese
cmp [usexory],0
je endball90degrese
cmp [usexory],1
je usey2
usex2:
mov [usexory],1

mov  al,6
sub al,[how_much_move_x_then_move_one_y]
mov [how_much_move_y_then_move_one_x],al

jmp endball90degrese
usey2:
mov [usexory],0
mov al,6
sub al,[how_much_move_y_then_move_one_x]
mov [how_much_move_x_then_move_one_y],al


jmp endball90degrese

endball90degrese:
ret 
endp moveball90degrese
;proc that draws the sides of the area
proc draw_area_lines
mov ah,0ch
mov cx, 64;70;250
mov dx,0
mov al,7
mov bl,0
mov [arr2+4],199
loopdrawlftline:
int 10h
inc dx
dec [arr2+4]
cmp [arr2+4],0
jg loopdrawlftline
mov [arr2+4],255
loopdrawbuttomline:
inc cx
int 10h
dec [arr2+4]
cmp [arr2+4],0
jg loopdrawbuttomline
mov [arr2+4],199
loopdrawrightline:
dec dx
int 10h
dec [arr2+4]
cmp [arr2+4],0
jg loopdrawrightline
mov [arr2+4],255
loopdrawtopline:
dec cx
int 10h
dec [arr2+4]
cmp [arr2+4],0
jg loopdrawtopline
ret
endp draw_area_lines
;proc that write the score
proc writescore
mov bp,sp
mov dl,0
mov dh,0
mov bh,0
mov bl,4
mov al,0h
mov ah,2 
int 10h
mov dx,offset scorescoremsg
mov ah,9
int 21h
call linedown
push [score]
call string
call complitewrite
call linedown
mov dx,offset movescoremsg
mov ah,9
int 21h
call linedown
push [moves]
call string
call complitewrite
call linedown
mov dx,offset hitsscoremsg
mov ah,9
int 21h
call linedown
push [hits]
call string
call complitewrite
call linedown
mov dx,offset triesscoremsg
mov ah,9
int 21h
call linedown
push [tries];[bp+2]
call string
call complitewrite
ret ;2
endp writescore
;print the blocks proc
proc drawblocks
mov [arr+13],24
mov di,0
mov si,0
loopdrawblock:
	 
	
	cmp [arrareblockstillalive+si],1;10
	je skipdrawblockafter
	cmp [arrareblockstillalive+si],2
	je gotodrawx
	jmp drawblock4
	
	skipdrawblockafter:
	mov [arrareblockstillalive+si],2
	jmp drawxonblock;skipdrawblock
	;draw the block using the arrs of x ,y positon and arr of the color value

	drawblock4:
	
	mov cx,[arrxfirstplaceblocks+di]
	mov dx,[arryfirstplaceblocks+di]
	inc cx
	inc dx
	mov ah,0ch
	mov bx,0
	
	mov al,[arrvalueofcolorblock+si];
	
	mov [arr+10],8
	loopprintblocky:
	mov [arr+11],8
		loopprintblockx:
		int 10h
		inc cx
		dec [arr+11]
		cmp [arr+11],0
		jg loopprintblockx
	mov cx,[arrxfirstplaceblocks+di]
	inc cx
	add dx,1
	dec [arr+10]
	cmp [arr+10],0
	jg loopprintblocky
	;draw the misgeretColorck misgeretColor around the blocks
	mov cx,[arrxfirstplaceblocks+di]
	mov dx,[arryfirstplaceblocks+di]
	mov [arr+12],9
	mov ah,0ch
	mov bl,0
	mov al,[misgeretColor]
	loopdrawblockframe1:
	inc cx
	int 10h
	
	dec [arr+12]
	cmp [arr+12],0
	jg loopdrawblockframe1
	jmp loopdrawblockframe22;caused  of irelative jump
	gotodrawx:
	jmp drawxonblock
	loopdrawblockframe22:
	mov [arr+12],9
	loopdrawblockframe2:
	inc dx
	int 10h
	dec [arr+12]
	cmp [arr+12],0
	jg loopdrawblockframe2
	mov [arr+12],9
	loopdrawblockframe3:
	dec cx
	int 10h
	dec [arr+12]
	cmp [arr+12],0
	jg loopdrawblockframe3
	mov [arr+12],9
	loopdrawblockframe4:
	dec dx
	int 10h
	dec [arr+12]
	cmp [arr+12],0
	jg loopdrawblockframe4
	
	
	jmp skipdrawblock
	drawxonblock:
	;inc [arrareblockstillalive+si]
	push [arrxfirstplaceblocks+di]
	push [arryfirstplaceblocks+di]
	call draw_x_on_block_when_break
skipdrawblock:

add di,2
inc si

dec [arr+13]
cmp [arr+13],0
jg loopdrawblock2;irelative jump caused
jmp enddrawblocks
loopdrawblock2:
jmp loopdrawblock
enddrawblocks:
ret
endp drawblocks
;check if the ball hit some random blocks
proc check_if_ball_touched_block
mov bp,sp
cmp [ballx],64
jle endcheckifballtouchedtheblock3;caused of lags that ditack somewhaythat the ball have hited a block
cmp [ballx],318
jge endcheckifballtouchedtheblock3;caused of lags that ditack somewhaythat the ball have hited a block
cmp [bally],5
jle endcheckifballtouchedtheblock3
cmp [bally],60
jge endcheckifballtouchedtheblock3
mov ah,0dh
mov cx,[bp+4]
mov dx,[bp+2]
mov bl,0
dec dx
int 10h;al the value of the pixel
cmp al,[misgeretColor];0
je changeballywaytodown;if there is misgeretColorck pixel up the ball
mov cx,[bp+4]
mov dx,[bp+2]
inc cx
int 10h
cmp al,[misgeretColor];0
je changeballxwaytoleft;if there is misgeretColorck pixel  right to the ball
mov cx,[bp+4]
mov dx,[bp+2]
inc  dx
int 10h
cmp al,[misgeretColor];0
je changeballywaytoup;if there is misgeretColorck pixel down the ball
mov cx,[bp+4]
mov dx,[bp+2]
dec cx
int 10h
cmp al,[misgeretColor];0
je changeballxwayyoright;if there is misgeretColorck pixel left to the ball
jmp endcheckifballtouchedtheblock2
endcheckifballtouchedtheblock3:
jmp endcheckifballtouchedtheblock2
changeballxwaytoleft:
mov [ballxway],0;change the direction
;dec [ballx]
call findwhichblock
call drawplacebackgroud
call drawblocks;-------------------
jmp endcheckifballtouchedtheblock
changeballxwayyoright:
;inc [ballx]
mov [ballxway],1;change the direction

call findwhichblock
call drawplacebackgroud
call drawblocks;-------------------------
jmp endcheckifballtouchedtheblock
changeballywaytoup:
;dec [bally]
mov [ballyway],0;change the direction

call findwhichblock
call drawplacebackgroud
call drawblocks;-----------------
jmp endcheckifballtouchedtheblock
changeballywaytodown:
;inc [bally]
mov [ballyway],1;change the direction
call findwhichblock
call drawplacebackgroud
call drawblocks;------------------
jmp endcheckifballtouchedtheblock
endcheckifballtouchedtheblock:
mov [movex],0
mov [movey],0
inc [hits]
add [score],2
call writescore
call bipon
;call bipoff
endcheckifballtouchedtheblock2:
ret 4
endp check_if_ball_touched_block
;proc that will be called in case the ball touched block  than call this proc for track witch block have been touched
proc findwhichblock
mov si,0
mov di,0
mov ax,[arryfirstplaceblocks]
add ax,15
cmp [bally],ax
jl firstrow
mov si,24;26
mov di,12;13----------------------------
cmp [bally],45
jg endfindblockplace
cmp [bally],10
jl endfindblockplace
jmp secondrow
notthisblock:
add si,2
inc di
firstrow:
mov ax,[ballx]
sub ax,11
cmp ax,[arrxfirstplaceblocks+si]
jg notthisblock
cmp [arrvalueofcolorblock+di],6;47;35;21;------------------------------------
jge clearblock
;cmp [arrvalueofcolorblock+di],200
;je endfindblockplace
inc [arrvalueofcolorblock+di];sub [arrvalueofcolorblock+di],3
jmp endfindblockplace
clearblock:
;mov [arrvalueofcolorblock+di],200;9;0
mov [arrareblockstillalive+di],1
jmp endfindblockplace
notthisblock2:
add si,2
inc di
secondrow:
mov ax,[ballx]
sub ax,11
cmp ax,[arrxfirstplaceblocks+si]
jg notthisblock2
cmp [arrvalueofcolorblock+di],6;47;35;21;------------------------------------
jge clearblock2
;cmp [arrvalueofcolorblock+di],200
;je endfindblockplace
inc [arrvalueofcolorblock+di];sub [arrvalueofcolorblock+di],3
jmp endfindblockplace
clearblock2:
;mov [arrvalueofcolorblock+di],200;0
mov [arrareblockstillalive+di],1
endfindblockplace:
ret
endp findwhichblock
;proc that finds out the background colors values where the blocks are been draws on
proc findplacebackgroundcolorvalue
mov cx,66;69;70
mov dx,10
mov ah,0dh
mov bl,0
mov si,0
;mov [arr+14],250
mov [arr+14],30
loopfindbackground:
	mov [arr2+6],250
	loopfindbackground2:
	int 10h
	mov [arrblocksplacebackgroundcolorvalue+si],al
	inc cx
	inc si
	dec [arr2+6]
	cmp [arr2+6],0
	jg loopfindbackground2
mov cx,66;69;70
inc dx
dec [arr+14]
cmp [arr+14],0
jg loopfindbackground
ret
endp findplacebackgroundcolorvalue
;proc that draw the part of the background again where the blocks are
;using when block has been broke and need to  clear the screen
proc drawplacebackgroud
mov cx,66;68;69;70
mov dx,10
mov ah,0ch
mov bl,0
mov si,0
mov [arr+15],30
loopfindbackground3:
	mov [arr2+8],250
	loopfindbackground4:
	mov al,[arrblocksplacebackgroundcolorvalue+si]
	int 10h
	inc cx
	inc si
	dec [arr2+8]
	cmp [arr2+8],0
	jg loopfindbackground4
mov cx,66;68;69;70
inc dx
dec [arr+15]
cmp [arr+15],0
jg loopfindbackground3
ret 
endp  drawplacebackgroud
;proc that draw an misgeretColorck x on the block for second when the block have just been broke
proc draw_x_on_block_when_break
mov bp,sp
mov cx,[bp+4]
mov dx,[bp+2]
inc dx
inc cx
mov al,1
mov bl,0
mov ah,0ch
mov [arr+14],8
loopdrawx:
int 10h
inc cx
inc dx
dec [arr+14]
cmp [arr+14],0
jg loopdrawx
;add dx,2
dec cx
mov dx,[bp+2]
inc dx
mov [arr+14],8
loopdrawx2:
int 10h
inc dx
dec cx
dec [arr+14]
cmp [arr+14],0
jg loopdrawx2
ret 4
endp draw_x_on_block_when_break 
;proc that will check if you win 
proc check_if_win
mov [arr+16],24;number of blocks
mov si,0
loopcheckifwin:
cmp [arrareblockstillalive+si],2
jne endcheckifwin
inc si
dec [arr+16]
cmp [arr+16],0
jg loopcheckifwin
mov [areyouwin],1

endcheckifwin:
ret 
endp check_if_win
;proc that makeing a bip when the ball have touched some random blocks ore when  the ball have touched the paddle
proc bipon
mov [arebipon],1
in al, 61h
or al, 00000011b
out 61h, al
; send control word to change frequency
mov al, 0B6h
out 43h, al
; play frequency 131Hz
mov ax, [note]
out 42h, al ; Sending lower byte
mov al, ah
out 42h, al ; Sending upper byte



ret
endp bipon
;proc that stopping the bipping
proc bipoff
cmp [arebipon],4
jne endturnbupoff
mov [arebipon],0
; close the speaker
in al, 61h
and al, 11111100b
out 61h, al
endturnbupoff:
ret
endp bipoff
;proc that setting the values of all the variables to ther originals value, using when the player wants to play again
proc setblockstostart
mov [arr+17],30
mov si,0
loopresatarray:
mov [arrareblockstillalive+si], 0;resat block situation to start
mov [arrvalueofcolorblock+si],1;resat color value
inc si
dec [arr+17]
cmp [arr+17],0
jg loopresatarray
mov [arrareblockstillalive+si],0
mov [moves],80
mov [hits],0
mov [score],0
mov [tries],3
mov [paddlex], 4ah
mov [ballyway],0
mov [ballxway],1
mov [areyouwin],0
ret
endp setblockstostart
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here  
; --------------------------

startnew2:
call setblockstostart
;mov [arrareblockstillalive+si],0
;inc si
mov ax,13h
int 10h
;call readPaletteFromScreen
startpicture:
mov ax,13h
int 10h
call OpenFilestart
call ReadHeader
call ReadPalette
call CopyPal
call CopyBitmap
waittosomethingstart:
;mov ah,1
;int 16h
;;cmp al,1
;jne waittosomethingstart
mov ah,0
int 16h
cmp ah,1ch
je start2
cmp al,'q'
je instructions
jmp waittosomethingstart

instructions:
mov ax,13h
int 10h
call OpenFileinstructions
call ReadHeader
call ReadPalette
call CopyPal
call CopyBitmap
waittosomethinginstructions:
mov ah,8h
int 21h
cmp al,27
je startpicture
jmp waittosomethinginstructions
start2:
mov ax,13h
int 10h
;mov ax,4f02h
;mov bx,103h
;int 10h

call OpenFilebackground
call ReadHeader
call ReadPalette
call CopyPal
call CopyBitmap
call findplacebackgroundcolorvalue
call drawblocks
call writescore
;push [moves]
;call string
call draw_area_lines
;push 0
;push [paddley]
call findpaddlecolorvalue
start0:
mov [areballdrop],0
call systemtime
call paddlemovements
push [paddlex]
push [paddley]
call drawpaddle


in al,60h
cmp al,39h
jne start0

mov ax,[paddlex]
add ax,22;25;15
mov [ballx],ax
mov [bally],190
;push [paddley]	
;call drawrepairpixelspaddle
start1:
;push 20000

cmp [arebipon],0
je dontneedto
inc [arebipon]
dontneedto:
call bipoff
call ballmoveplace
push [ballx]
push [bally]
call check_if_ball_touched_block
cmp [aredrawagainblocks],1
je drawblocksagain
jmp dontdrawagainblocks
drawblocksagain:
mov [aredrawagainblocks],0
call drawblocks
dontdrawagainblocks:
mov [aredrawagainblocks],0
push [ballx]
push [bally]
call findvaluecolor

push [ballx]
push [bally]
call drawball
cmp [areballdrop],1
je start0

call systemtime




call paddlemovements

;push [paddlex]
;push [paddley]
;call drawrepairpixelspaddle
push [paddlex]
push [paddley]
call drawpaddle

push [ballx]
push [bally]
call drawdarkball

call check_if_win;check if you been destroyed al the blocks,if yes go to the win end 
cmp [areyouwin],1
je winmsgend

jmp start1


winmsgend:
;when win
mov [arebipon],4
call bipoff
mov ax,13h
int 10h
call OpenFilewin
call ReadHeader
call ReadPalette
call CopyPal
call CopyBitmap
call writescore
waittosomethingwin:
mov ah,08h
int 21h
cmp al,1b
je exit
cmp al,13
je startnew
jmp waittosomethingwin
startnew:
jmp startnew2
	
	
	
exit1:
;when lose
mov ax,13h
int 10h

mov [arebipon],4
call bipoff
call OpenFilelose
call ReadHeader
call ReadPalette
call CopyPal
call CopyBitmap
call writescore
waittosomethinglose:
mov ah,8h
int 21h
cmp al,13
je startnew3
cmp al,1bh
je exit
jmp waittosomethinglose
startnew3:
jmp startnew
exit:
mov ax,13h
int 10h
	mov ax, 4c00h
	int 21h
END start;o/ i'm ohad but not ido the second
