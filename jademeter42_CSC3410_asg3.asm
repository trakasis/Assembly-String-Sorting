;Joshua Demeter
;CSC-3410-001
;Program 3
.586
.MODEL FLAT, stdcall
.STACK 4096
ExitProcess proto,dwExitCode:dword

.DATA
s1 BYTE "Ba", 0
s2 BYTE "Aa", 0
s3 BYTE "Ba", 0
stringorder WORD 0

.CODE
main PROC

lea eax, s1
push eax
call strlen 
add esp, 4
mov edx, eax
lea eax, s2
push eax
call strlen 
add esp, 4
mov ecx, eax
cmp edx, ecx
jl StrTwoLonger
jg StrOneLonger

StrOneLonger:
mov ecx, edx
jmp CompareOneTwo

strTwoLonger:
CompareOneTwo:
lea esi, s1
lea edi, s2
cld
repe cmpsb
jecxz IsEqual

mov bl, BYTE PTR [esi-1]
mov dl, BYTE PTR [edi-1]
cmp bl, dl
jl LessThan
jg GreaterThan

IsEqual:
lea eax, s1
push eax
call strlen
add esp, 4
mov edx, eax
lea eax, s3
push eax
call strlen
add esp, 4
mov ecx, eax
cmp edx, ecx
jl StrThrLonger
jg StartOneLonger

StartOneLonger:
mov ecx, edx
jmp CompareOneThrEq

StrThrLonger:
CompareOneThrEq:
lea esi, s1
lea edi, s3
cld
repe cmpsb
jecxz AllEqual

mov bl, BYTE PTR [esi-1]
mov dl, BYTE PTR [edi-1]
cmp dl, bl
jl ThrLessOneTwo
jg ThrGrOneTwo

ThrLessOneTwo:
mov stringorder, 312h       ;since here s1 and s2 are the same
jmp quit                    ;it doesn't particularly matter if the order is 312 or 321

ThrGrOneTwo:
mov stringorder, 123h
jmp quit

AllEqual:
mov stringorder, 123h       ;if all values are the same then order doesnt matter
jmp quit

GreaterThan:
mov stringorder, 21h
lea eax, s2
push eax
call strlen
add esp, 4
mov edx, eax
lea eax, s3
push eax
call strlen
add esp, 4
mov ecx, eax
cmp edx, ecx
jl TwoOverThree
jg ThreeOverTwo

ThreeOverTwo:
mov ecx, edx
jmp nextCompare

TwoOverThree:
nextCompare:
lea esi, s2
lea edi, s3
cld
repe cmpsb
jecxz GTIsEqual

mov bl, BYTE PTR [esi-1]
mov dl, BYTE PTR [edi-1]
cmp dl, bl
jl ThreeTwoOne
jg ThreeGrTwoSplit

GTIsEqual:
mov stringorder, 231h
jmp quit

ThreeTwoOne:
mov stringorder, 321h
jmp quit

ThreeGrTwoSplit:
lea eax, s1
push eax
call strlen
add esp, 4      ;I probably could have compared the string lengths within the procedure
mov edx, eax    ;so i wouldnt have to do this ugly block of text here (and everywhere else)
lea eax, s3     ;but I didn't realize it until too late
push eax
call strlen
add esp, 4
mov ecx, eax
cmp edx, ecx
jl EDLTEC
jg EDECSwap

EDECSwap:
mov ecx, edx
jmp goNext

EDLTEC:
goNext:
lea esi, s1
lea edi, s3
cld
repe cmpsb
jecxz OneThreeEqualGr

mov bl, BYTE PTR [esi-1]
mov dl, BYTE PTR [edi-1]
cmp dl, bl
jl TwoThrOne
jg TwoOneThr

TwoThrOne:
mov stringorder, 231h
jmp quit

TwoOneThr:
mov stringorder, 213h
jmp quit

OneThreeEqualGr:
mov stringorder, 213h
jmp quit

LessThan:
mov stringorder, 12h
lea eax, s1
push eax
call strlen
add esp, 4
mov edx, eax
lea eax, s3
push eax
call strlen
add esp, 4
mov ecx, eax
cmp edx, ecx
jl DisLTC
jg DisGTC

DisGTC:
mov ecx, edx
jmp goCompare    ;a lot of these jumps are probably redundant
                 ;but i've been burned by not jumping to the right place before
DisLTC:          ;so i'm extra careful now
goCompare: 
lea esi, s1
lea edi, s3
cld
repe cmpsb
jecxz LTIsEqual

mov bl, BYTE PTR [esi-1]
mov dl, BYTE PTR [edi-1]
cmp dl, bl
jl ThreeOneTwoBranch
jg ThreeGrOneSplit

LTIsEqual:
mov stringorder, 132h
jmp quit

ThreeOneTwoBranch:
mov stringorder, 312h
jmp quit

ThreeGrOneSplit:
lea eax, s2
push eax
call strlen
add esp, 4
mov edx, eax
lea eax, s3
push eax
call strlen
add esp, 4
mov ecx, eax
cmp edx, ecx
jl DLTC
jg DGTC

DGTC:
mov ecx, edx
jmp comparing

DLTC:
comparing:
lea esi, s2
lea edi, s3
cld
repe cmpsb
jecxz TGOIsEqual

mov bl, BYTE PTR [esi-1]
mov dl, BYTE PTR [edi-1]
cmp dl, bl
jl OneThreeTwo
jg OneTwoThree

TGOIsEqual:
mov stringorder, 123h
jmp quit

OneThreeTwo:
mov stringorder, 132h
jmp quit

OneTwoThree:
mov stringorder, 123h
jmp quit

quit:
invoke ExitProcess, 0
main ENDP


strlen PROC      ;This procedure used from the Intro to 80x86 Assembly textbook by Richard Detmer (p.251)
	push ebp
	mov ebp, esp
	push ebx
	sub eax, eax
	mov ebx, [ebp+8]

	whileChar:	cmp BYTE PTR [ebx], 0
				je endWhileChar
				inc eax
				inc ebx
				jmp whileChar
	endWhileChar:
				pop ebx
				pop ebp
				ret
 strlen ENDP

END