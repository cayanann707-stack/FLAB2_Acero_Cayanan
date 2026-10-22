BITS 32
global _start
 
%macro PRINT 1
    mov ecx, %1
    call print_string
%endmacro
 
section .data
    welcome db 10, '=======================================',10
            db '       THE MYSTIC ZODIAC ORACLE',10
            db '=======================================',10
            db '          *       *       *',10
            db '               /\',10
            db '         *    /  \    *',10
            db '             /____\',10
            db '              |  |',10
            db '          *   |__|   *',10
            db '        DISCOVER YOUR DESTINY!',10
            db '=======================================',10
            db 'All fortunes are fictional and for fun.',10,10,0
 
    name_prompt db 'Enter your name: ',0
    month_prompt db 'Enter birth month (1-12): ',0
    day_prompt db 'Enter birth day (1-31): ',0
 
    bad_name db 'Enter a name using 1-63 characters.',10,0
    bad_month db 'Invalid month. Enter a number from 1 to 12.',10,0
    bad_date db 'Invalid date. Check the number of days in this month.',10
             db 'February has 28 days in this program.',10,0
 
    hello db 10,'Welcome, ',0
    newline db 10,0
 
    sign_title db 10,'=======================================',10
               db '           YOUR ZODIAC SIGN',10
               db '=======================================',10,0
 
    menu db 10,'[1] Love and Relationships',10
         db '[2] Career and Studies',10
         db '[3] Health and Wellness',10
         db '[4] Lucky Number and Color',10
         db '[5] View Zodiac Information',10
         db '[6] Exit',10
         db 'Enter your choice: ',0
 
    bad_menu db 'Invalid selection. Enter 1 to 6.',10,0
    again_prompt db 10,'Return to menu? (Y/N): ',0
    bad_again db 'Invalid answer. Enter Y or N.',10,0
    goodbye db 10,'Thank you for visiting the Mystic Zodiac Oracle!',10,0
 
    love_title db 10,'LOVE AND RELATIONSHIPS HOROSCOPE',10,0
    career_title db 10,'CAREER AND STUDIES HOROSCOPE',10,0
    health_title db 10,'HEALTH AND WELLNESS HOROSCOPE',10,0
    lucky_title db 10,'YOUR LUCKY NUMBER AND COLOR',10,0
 
    month_days dd 31,28,31,30,31,30,31,31,30,31,30,31
    cutoffs dd 20,19,21,20,21,21,23,23,23,23,22,22
 
    info0 db 'Zodiac Sign: CAPRICORN',10
          db 'Element: Earth',10
          db 'Symbol: Sea-Goat',10
          db 'Personality: Responsible, disciplined, ambitious.',10,0
 
    info1 db 'Zodiac Sign: AQUARIUS',10
          db 'Element: Air',10
          db 'Symbol: Water Bearer',10
          db 'Personality: Independent, inventive, friendly.',10,0
 
    info2 db 'Zodiac Sign: PISCES',10
          db 'Element: Water',10
          db 'Symbol: Fish',10
          db 'Personality: Imaginative, gentle, compassionate.',10,0
 
    info3 db 'Zodiac Sign: ARIES',10
          db 'Element: Fire',10
          db 'Symbol: Ram',10
          db 'Personality: Brave, energetic, enthusiastic.',10,0
 
    info4 db 'Zodiac Sign: TAURUS',10
          db 'Element: Earth',10
          db 'Symbol: Bull',10
          db 'Personality: Patient, reliable, determined.',10,0
 
    info5 db 'Zodiac Sign: GEMINI',10
          db 'Element: Air',10
          db 'Symbol: Twins',10
          db 'Personality: Curious, adaptable, expressive.',10,0
 
    info6 db 'Zodiac Sign: CANCER',10
          db 'Element: Water',10
          db 'Symbol: Crab',10
          db 'Personality: Caring, loyal, protective.',10,0
 
    info7 db 'Zodiac Sign: LEO',10
          db 'Element: Fire',10
          db 'Symbol: Lion',10
          db 'Personality: Confident, creative, courageous.',10,0
 
    info8 db 'Zodiac Sign: VIRGO',10
          db 'Element: Earth',10
          db 'Symbol: Maiden',10
          db 'Personality: Practical, helpful, observant.',10,0
 
    info9 db 'Zodiac Sign: LIBRA',10
          db 'Element: Air',10
          db 'Symbol: Scales',10
          db 'Personality: Fair, charming, cooperative.',10,0
 
    info10 db 'Zodiac Sign: SCORPIO',10
           db 'Element: Water',10
           db 'Symbol: Scorpion',10
           db 'Personality: Passionate, resourceful, determined.',10,0
 
    info11 db 'Zodiac Sign: SAGITTARIUS',10
           db 'Element: Fire',10
           db 'Symbol: Archer',10
           db 'Personality: Adventurous, optimistic, honest.',10,0
 
    info_table dd info0,info1,info2,info3,info4,info5
               dd info6,info7,info8,info9,info10,info11
 
    art0 db '       /\ /\',10
         db '      ( o.o )____',10
         db '       /___/~~~~~>',10,10,0
 
    art1 db '        ____',10
         db '       /    \__',10
         db '       \____/  ~~~',10
         db '          ~~~~~~~',10,10,0
 
    art2 db '       ><(((o>   <o)))><',10,10,0
 
    art3 db '       (O)   (O)',10
         db '         \o o/',10
         db '          \_/',10,10,0
 
    art4 db '       \       /',10
         db '        \(o o)/',10
         db '         (___)',10,10,0
 
    art5 db '        O     O',10
         db '       /|\   /|\',10
         db '       / \   / \',10,10,0
 
    art6 db '       \/     \/',10
         db '        \(o o)/',10
         db '       /|_____ |\',10,10,0
 
    art7 db '         /\_/\',10
         db '        ( o.o )',10
         db '         > ^ <',10,10,0
 
    art8 db '          .-.',10
         db '         (o o)',10
         db '         /| |\',10
         db '          /_\',10,10,0
 
    art9 db '           |',10
         db '       ____|____',10
         db '      /\   |   /\',10
         db '     /__\  |  /__\',10
         db '          _|_',10,10,0
 
    art10 db '       \ /     __',10
          db '      (o o)___/  \',10
          db '       /| |\     _)',10
          db '                ^',10,10,0
 
    art11 db '          )',10
          db '      ----)---->',10
          db '          )',10,10,0
 
    art_table dd art0,art1,art2,art3,art4,art5
              dd art6,art7,art8,art9,art10,art11
 
    love0 db 'Capricorn, a thoughtful gesture may strengthen a bond today.',10,0
    love1 db 'Aquarius, an unexpected conversation may spark a friendship.',10,0
    love2 db 'Pisces, sharing your feelings may bring someone closer.',10,0
    love3 db 'Aries, a little patience may lead to a warmer conversation.',10,0
    love4 db 'Taurus, a simple act of kindness may brighten your relationship.',10,0
    love5 db 'Gemini, honest words may clear up a misunderstanding.',10,0
    love6 db 'Cancer, someone may appreciate your caring nature today.',10,0
    love7 db 'Leo, sharing the spotlight may strengthen a special connection.',10,0
    love8 db 'Virgo, a small thoughtful message may mean more than you expect.',10,0
    love9 db 'Libra, listening carefully may bring harmony to a relationship.',10,0
    love10 db 'Scorpio, trust may grow through a sincere conversation.',10,0
    love11 db 'Sagittarius, a shared adventure may create a happy memory.',10,0
 
    love_table dd love0,love1,love2,love3,love4,love5
               dd love6,love7,love8,love9,love10,love11
 
    career0 db 'Capricorn, your steady effort may help you finish a hard task.',10,0
    career1 db 'Aquarius, an original idea may improve your group project.',10,0
    career2 db 'Pisces, your imagination may reveal a useful solution.',10,0
    career3 db 'Aries, your initiative may help your team make progress.',10,0
    career4 db 'Taurus, patient practice may help you understand a new topic.',10,0
    career5 db 'Gemini, asking a question may lead to a helpful discovery.',10,0
    career6 db 'Cancer, cooperation may make a difficult assignment easier.',10,0
    career7 db 'Leo, your creativity may help solve a difficult problem today.',10,0
    career8 db 'Virgo, checking the details may help you catch a small mistake.',10,0
    career9 db 'Libra, a balanced plan may help your team meet its deadline.',10,0
    career10 db 'Scorpio, focused effort may unlock a challenging lesson.',10,0
    career11 db 'Sagittarius, exploring a new subject may inspire your next goal.',10,0
 
    career_table dd career0,career1,career2,career3,career4,career5
                 dd career6,career7,career8,career9,career10,career11
 
    health0 db 'Capricorn, your fictional stars suggest a peaceful break today.',10,0
    health1 db 'Aquarius, your fictional stars favor time away from your screen.',10,0
    health2 db 'Pisces, your fictional stars favor a quiet moment of relaxation.',10,0
    health3 db 'Aries, your fictional stars suggest balancing activity and rest.',10,0
    health4 db 'Taurus, your fictional stars favor a calm and comfortable evening.',10,0
    health5 db 'Gemini, your fictional stars suggest a pause between busy tasks.',10,0
    health6 db 'Cancer, your fictional stars favor a relaxing favorite hobby.',10,0
    health7 db 'Leo, your fictional stars suggest making room for rest today.',10,0
    health8 db 'Virgo, your fictional stars favor a manageable daily routine.',10,0
    health9 db 'Libra, your fictional stars suggest a balance of work and leisure.',10,0
    health10 db 'Scorpio, your fictional stars favor a peaceful change of pace.',10,0
    health11 db 'Sagittarius, your fictional stars favor a refreshing outdoor break.',10,0
 
    health_table dd health0,health1,health2,health3,health4,health5
                 dd health6,health7,health8,health9,health10,health11
 
    lucky0 db 'Lucky Number: 8',10,'Lucky Color: Brown',10,0
    lucky1 db 'Lucky Number: 11',10,'Lucky Color: Blue',10,0
    lucky2 db 'Lucky Number: 7',10,'Lucky Color: Sea Green',10,0
    lucky3 db 'Lucky Number: 9',10,'Lucky Color: Red',10,0
    lucky4 db 'Lucky Number: 6',10,'Lucky Color: Green',10,0
    lucky5 db 'Lucky Number: 5',10,'Lucky Color: Yellow',10,0
    lucky6 db 'Lucky Number: 2',10,'Lucky Color: Silver',10,0
    lucky7 db 'Lucky Number: 1',10,'Lucky Color: Gold',10,0
    lucky8 db 'Lucky Number: 4',10,'Lucky Color: Navy Blue',10,0
    lucky9 db 'Lucky Number: 6',10,'Lucky Color: Pink',10,0
    lucky10 db 'Lucky Number: 8',10,'Lucky Color: Maroon',10,0
    lucky11 db 'Lucky Number: 3',10,'Lucky Color: Purple',10,0
 
    lucky_table dd lucky0,lucky1,lucky2,lucky3,lucky4,lucky5
                dd lucky6,lucky7,lucky8,lucky9,lucky10,lucky11
 
section .bss
    name_buffer resb 64
    input_buffer resb 32
    input_char resb 1
    line_overflow resb 1
    birth_month resd 1
    birth_day resd 1
    zodiac resd 1
    choice resd 1
 
section .text
 
_start:
    call display_welcome
    call get_user_info
    call determine_zodiac
 
    PRINT hello
    PRINT name_buffer
    PRINT newline
 
    call display_zodiac_art
 
.menu_loop:
    call display_menu
    call read_number
 
    cmp eax, 6
    je exit_program
 
    cmp eax, 1
    jl .invalid
 
    cmp eax, 5
    jg .invalid
 
    mov [choice], eax
    call show_horoscope
    call ask_again
    jmp .menu_loop
 
.invalid:
    PRINT bad_menu
    jmp .menu_loop
 
display_welcome:
    PRINT welcome
    ret
 
get_user_info:
.name:
    PRINT name_prompt
    mov ecx, name_buffer
    mov edx, 64
    call read_line
 
    cmp eax, 0
    jg .month
 
    PRINT bad_name
    jmp .name
 
.month:
    PRINT month_prompt
    call read_number
 
    cmp eax, 1
    jl .invalid_month
 
    cmp eax, 12
    jg .invalid_month
 
    mov [birth_month], eax
 
.day:
    PRINT day_prompt
    call read_number
    mov [birth_day], eax
 
    call validate_birthdate
    cmp eax, 1
    je .done
 
    PRINT bad_date
    jmp .day
 
.invalid_month:
    PRINT bad_month
    jmp .month
 
.done:
    ret
 
validate_birthdate:
    mov edx, [birth_month]
 
    cmp edx, 1
    jl .invalid
 
    cmp edx, 12
    jg .invalid
 
    mov eax, [birth_day]
    cmp eax, 0
    jle .invalid
 
    dec edx
    cmp eax, [month_days + edx*4]
    jg .invalid
 
    mov eax, 1
    ret
 
.invalid:
    xor eax, eax
    ret
 
determine_zodiac:
    mov ebx, [birth_month]
    dec ebx
 
    mov eax, [birth_day]
    cmp eax, [cutoffs + ebx*4]
    jge .next_sign
    jmp .store
 
.next_sign:
    inc ebx
 
    cmp ebx, 12
    jne .store
 
    xor ebx, ebx
 
.store:
    mov [zodiac], ebx
    ret
 
display_zodiac_art:
    PRINT sign_title
 
    mov ebx, [zodiac]
    mov ecx, [art_table + ebx*4]
    call print_string
 
    mov ecx, [info_table + ebx*4]
    call print_string
    ret
 
display_menu:
    PRINT menu
    ret
 
show_horoscope:
    mov ebx, [zodiac]
    mov eax, [choice]
 
    cmp eax, 1
    je .love
 
    cmp eax, 2
    je .career
 
    cmp eax, 3
    je .health
 
    cmp eax, 4
    je .lucky
 
    call display_zodiac_art
    ret
 
.love:
    PRINT love_title
    mov ecx, [love_table + ebx*4]
    jmp .print
 
.career:
    PRINT career_title
    mov ecx, [career_table + ebx*4]
    jmp .print
 
.health:
    PRINT health_title
    mov ecx, [health_table + ebx*4]
    jmp .print
 
.lucky:
    PRINT lucky_title
    mov ecx, [lucky_table + ebx*4]
 
.print:
    call print_string
    ret
 
ask_again:
.prompt:
    PRINT again_prompt
    mov ecx, input_buffer
    mov edx, 32
    call read_line
 
    cmp eax, 1
    jne .invalid
 
    mov al, [input_buffer]
    or al, 32
 
    cmp al, 'y'
    je .done
 
    cmp al, 'n'
    je exit_program
 
.invalid:
    PRINT bad_again
    jmp .prompt
 
.done:
    ret
 
; Read an unsigned decimal number from 0 to 999.
; Return EAX = -1 for empty, nonnumeric, or oversized input.
read_number:
    mov ecx, input_buffer
    mov edx, 32
    call read_line
 
    cmp eax, 0
    jle .invalid
 
    mov esi, input_buffer
    xor eax, eax
 
.digit:
    movzx edx, byte [esi]
    test edx, edx
    jz .done
 
    sub edx, '0'
    cmp edx, 9
    ja .invalid
 
    imul eax, eax, 10
    add eax, edx
 
    cmp eax, 999
    ja .invalid
 
    inc esi
    jmp .digit
 
.invalid:
    mov eax, -1
 
.done:
    ret
 
; ECX = buffer, EDX = capacity including the final zero byte.
; Return EAX = length, or -1 if the line is too long.
; Reading one byte at a time also supports redirected input.
read_line:
    push ebx
    push ecx
    push edx
    push esi
    push edi
    push ebp
 
    mov esi, ecx
    mov edi, edx
    dec edi
 
    xor ebp, ebp
    mov byte [line_overflow], 0
 
.read:
    mov eax, 3
    xor ebx, ebx
    mov ecx, input_char
    mov edx, 1
    int 0x80
 
    cmp eax, -4
    je .read
 
    cmp eax, 0
    jl .input_error
    je .eof
 
    mov al, [input_char]
 
    cmp al, 10
    je .finish
 
    cmp al, 13
    je .read
 
    cmp ebp, edi
    jae .overflow
 
    test al, al
    jz .overflow
 
    mov [esi + ebp], al
    inc ebp
    jmp .read
 
.overflow:
    mov byte [line_overflow], 1
    jmp .read
 
.eof:
    test ebp, ebp
    jnz .finish
 
    cmp byte [line_overflow], 0
    jne .finish
 
    jmp exit_program
 
.finish:
    mov byte [esi + ebp], 0
    mov eax, ebp
 
    cmp byte [line_overflow], 0
    je .restore
 
    mov eax, -1
 
.restore:
    pop ebp
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
 
.input_error:
    mov eax, 1
    mov ebx, 1
    int 0x80
 
; Print a zero-terminated string at ECX.
; Preserve all general-purpose registers.
print_string:
    pushad
    xor edx, edx
 
.length:
    cmp byte [ecx + edx], 0
    je .write
 
    inc edx
    jmp .length
 
.write:
    test edx, edx
    jz .done
 
    mov eax, 4
    mov ebx, 1
    int 0x80
 
    cmp eax, -4
    je .write
 
    test eax, eax
    jle .done
 
    add ecx, eax
    sub edx, eax
    jmp .write
 
.done:
    popad
    ret
 
exit_program:
    PRINT goodbye
    mov eax, 1
    xor ebx, ebx
    int 0x80