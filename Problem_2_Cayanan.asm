; =============================================================================
; Module 5 — Assembly Language Machine Problem 2
; Dungeon Adventure and Survival Game (NASM 32-bit x86 / Linux int 0x80)
; =============================================================================

section .data
    ; --- Formatting Utilities ---
    newline     db 10, 0
    divider     db "=======================================", 10, 0
    space_str   db " ", 0
    
    ; --- Welcome Screen ---
    welcome_msg db "       DUNGEON OF THE LOST KING", 10
                db "              |>>>>", 10
                db "              |          _  _|_  _", 10
                db "             |;|_|;|_|;|", 10
                db "             \\.    .  /", 10
                db "              \\:  .  /", 10
                db "               ||:   |", 10
                db "               ||:.  |", 10
                db "               ||:  .|", 10
                db "       ENTER IF YOU DARE!", 10, 0

    ; --- Registration and Class Selection ---
    prompt_name db "Enter your hero name: ", 0
    prompt_cls  db "Choose your character:", 10
                db " [1] Warrior", 10
                db " [2] Mage", 10
                db " [3] Archer", 10
                db "Enter choice: ", 0
    invalid_err db "Invalid selection! Try again.", 10, 0
    
    welcome_hero db "Welcome, ", 0
    excl_break   db "! ", 10, 0

    w_label      db "Warrior ", 0
    m_label      db "Mage ", 0
    a_label      db "Archer ", 0

    ; --- Main Menu ---
    menu_msg    db 10, "--- MAIN MENU ---", 10
                db " [1] Explore Dungeon", 10
                db " [2] View Character Status", 10
                db " [3] Use Health Potion", 10
                db " [4] View Inventory", 10
                db " [5] Exit Game", 10
                db "Enter choice: ", 0

    ; --- Room Displays & ASCII Art ---
    goblin_art  db 10, "          ,      ,", 10
                db "         /(.-''-.)\\", 10
                db "        |\\  \\/      \\/  /|", 10
                db "        | \\ / =.  .= \\ / |", 10
                db "         \\  \\   ^    /  /", 10
                db "          \\  '-----'  /", 10
                db "A GOBLIN APPEARS!", 10, 0

    combat_menu db " [1] Attack  [2] Defend", 10
                db " [3] Use Potion  [4] Run", 10
                db "Enter combat choice: ", 0

    chest_art   db 10, "          __________", 10
                db "         /_________/|", 10
                db "        |  _____  | |", 10
                db "        | |  ?  | | |", 10
                db "        | |_____| | /", 10
                db "        |_________|/", 10
                db "TREASURE CHAMBER!", 10
                db " [1] Open Chest  [2] Leave Chest", 10
                db "Enter choice: ", 0

    dragon_art  db 10, "         / \\  //\\", 10
                db "              |\\___/|", 10
                db "      \\      /0  0  \\", 10
                db "      |     /   ^    \\", 10
                db "    /    /  \\___/   \\  /", 10
                db "      \\__________\\/", 10
                db "THE DRAGON AWAKENS!", 10, 0

    ; --- Combat Strings ---
    msg_p_hit   db "You attack and deal ", 0
    msg_e_hit   db " dmg to the enemy!", 10, 0
    msg_e_att   db "The enemy counter-attacks and deals ", 0
    msg_p_def   db "You brace yourself! Incoming damage will be reduced by 5.", 10, 0
    msg_run     db "You retreated safely back to safety!", 10, 0
    msg_chest_g db "You found 50 gold in the chest!", 10, 0
    msg_chest_l db "You walked past the chest cautiously.", 10, 0
    
    ; --- Status / Inventory Displays ---
    lbl_status  db 10, "--- CHARACTER STATUS ---", 10, 0
    lbl_inv     db 10, "--- INVENTORY ---", 10, 0
    lbl_hp      db "Health: ", 0
    lbl_max_hp  db "/", 0
    lbl_atk     db "Attack: ", 0
    lbl_potions db "Potions: ", 0
    lbl_gold    db "Gold: ", 0
    
    msg_pot_use db "You gulped down a health potion! Restored 20 HP.", 10, 0
    msg_pot_ful db "Your health is already maxed out!", 10, 0
    msg_pot_emp db "Error: Out of health potions!", 10, 0
    msg_room_c  db "This chamber is empty... Advance using the Main Menu.", 10, 0

    ; --- End Game States ---
    victory_msg db 10, "=======================================", 10
                db "VICTORY!", 10
                db "CONGRATULATIONS!", 10
                db "You defeated the dragon and escaped!", 10, 0
    final_g_lbl db "Final Gold: ", 0
    rem_hp_lbl  db "Remaining Health: ", 0
    hero_foot   db "YOU ARE A HERO!", 10, 0

    defeat_msg  db 10, "=======================================", 10
                db "GAME OVER", 10
                db "Your hero has fallen.", 10
                db "The dungeon remains undefeated.", 10
                db "BETTER LUCK NEXT TIME!", 10, 0

section .bss
    ; --- State Management Variables ---
    hero_name   resb 32
    class_choice resb 2
    menu_choice resb 2
    combat_choice resb 2
    chest_choice resb 2
    num_buffer  resb 12

    player_hp   resd 1
    player_max  resd 1
    player_atk  resd 1
    player_pot  resd 1
    player_gold resd 1
    player_class resd 1

    current_room resd 1
    enemy_hp    resd 1
    enemy_dmg   resd 1
    defend_flag resd 1

section .text
    global _start

_start:
    mov dword [player_gold], 0
    mov dword [current_room], 1

    call display_welcome
    call get_player_info
    call initialize_character

.main_loop:
    call display_main_menu
    
    mov eax, 3
    mov ebx, 0
    mov ecx, menu_choice
    mov edx, 2
    int 0x80

    mov al, [menu_choice]
    cmp al, '1'
    je .explore
    cmp al, '2'
    je .status
    cmp al, '3'
    je .potion
    cmp al, '4'
    je .inventory
    cmp al, '5'
    je .exit
    
    mov eax, divider
    call print_string
    mov eax, invalid_err
    call print_string
    jmp .main_loop

.explore:
    call explore_dungeon
    jmp .main_loop

.status:
    call display_status
    jmp .main_loop

.potion:
    call use_potion
    jmp .main_loop

.inventory:
    call display_inventory
    jmp .main_loop

.exit:
    call exit_program

; =============================================================================
; PROCEDURES LOGIC
; =============================================================================

display_welcome:
    mov eax, divider
    call print_string
    mov eax, welcome_msg
    call print_string
    mov eax, divider
    call print_string
    ret

get_player_info:
    mov eax, prompt_name
    call print_string
    
    mov eax, 3
    mov ebx, 0
    mov ecx, hero_name
    mov edx, 30
    int 0x80
    
    mov ecx, 0
.clean_name:
    cmp ecx, 30
    je .class_prompt
    mov al, [hero_name + ecx]
    cmp al, 10
    je .strip
    inc ecx
    jmp .clean_name
.strip:
    mov byte [hero_name + ecx], 0

.class_prompt:
    mov eax, prompt_cls
    call print_string
    
    mov eax, 3
    mov ebx, 0
    mov ecx, class_choice
    mov edx, 2
    int 0x80

    mov al, [class_choice]
    cmp al, '1'
    je .done
    cmp al, '2'
    je .done
    cmp al, '3'
    je .done
    
    mov eax, invalid_err
    call print_string
    jmp .class_prompt
.done:
    ret

initialize_character:
    mov al, [class_choice]
    cmp al, '1'
    je .warrior
    cmp al, '2'
    je .mage
    cmp al, '3'
    je .archer
    ret

.warrior:
    mov dword [player_hp], 100
    mov dword [player_max], 100
    mov dword [player_atk], 20
    mov dword [player_pot], 2
    mov dword [player_class], 1
    
    mov eax, welcome_hero
    call print_string
    mov eax, w_label
    call print_string
    mov eax, hero_name
    call print_string
    mov eax, excl_break
    call print_string
    ret

.mage:
    mov dword [player_hp], 70
    mov dword [player_max], 70
    mov dword [player_atk], 30
    mov dword [player_pot], 3
    mov dword [player_class], 2
    
    mov eax, welcome_hero
    call print_string
    mov eax, m_label
    call print_string
    mov eax, hero_name
    call print_string
    mov eax, excl_break
    call print_string
    ret

.archer:
    mov dword [player_hp], 85
    mov dword [player_max], 85
    mov dword [player_atk], 25
    mov dword [player_pot], 2
    mov dword [player_class], 3
    
    mov eax, welcome_hero
    call print_string
    mov eax, a_label
    call print_string
    mov eax, hero_name
    call print_string
    mov eax, excl_break
    call print_string
    ret

; =============================================================================
; GLOBAL RESET LABEL (This fixes the "symbol not defined" error)
; =============================================================================
clear_local_scope:

display_main_menu:
    mov eax, menu_msg
    call print_string
    ret

explore_dungeon:
    mov eax, [current_room]
    cmp eax, 1
    je .room1
    cmp eax, 2
    je .room2
    cmp eax, 3
    je .room3
    
    mov eax, msg_room_c
    call print_string
    ret

.room1:
    mov eax, goblin_art
    call print_string
    mov dword [enemy_hp], 30
    mov dword [enemy_dmg], 10
    call battle_enemy
    ret

.room2:
    mov eax, chest_art
    call print_string
    
    mov eax, 3
    mov ebx, 0
    mov ecx, chest_choice
    mov edx, 2
    int 0x80

    mov al, [chest_choice]
    cmp al, '1'
    je .open_chest
    cmp al, '2'
    je .leave_chest
    mov eax, invalid_err
    call print_string
    jmp .room2

.open_chest:
    mov eax, msg_chest_g
    call print_string
    add dword [player_gold], 50
    mov dword [current_room], 3
    ret

.leave_chest:
    mov eax, msg_chest_l
    call print_string
    mov dword [current_room], 3
    ret

.room3:
    mov eax, dragon_art
    call print_string
    mov dword [enemy_hp], 60
    mov dword [enemy_dmg], 15
    call battle_enemy
    ret

battle_enemy:
    mov dword [defend_flag], 0
    mov eax, combat_menu
    call print_string
    
    mov eax, 3
    mov ebx, 0
    mov ecx, combat_choice
    mov edx, 2
    int 0x80

    mov al, [combat_choice]
    cmp al, '1'
    je .action_attack
    cmp al, '2'
    je .action_defend
    cmp al, '3'
    je .action_potion
    cmp al, '4'
    je .action_run
    
    mov eax, invalid_err
    call print_string
    jmp battle_enemy

.action_attack:
    mov ebx, [player_atk]
    mov eax, msg_p_hit
    call print_string
    mov eax, ebx
    call print_int
    mov eax, msg_e_hit
    call print_string

    mov eax, [enemy_hp]
    sub eax, ebx
    mov [enemy_hp], eax
    
    cmp dword [enemy_hp], 0
    jle .enemy_defeated
    jmp .enemy_retaliation

.action_defend:
    mov dword [defend_flag], 1
    mov eax, msg_p_def
    call print_string
    jmp .enemy_retaliation

.action_potion:
    call use_potion
    jmp battle_enemy

.action_run:
    mov eax, msg_run
    call print_string
    ret

.enemy_retaliation:
    mov ebx, [enemy_dmg]
    cmp dword [defend_flag], 1
    jne .apply_damage
    sub ebx, 5
    cmp ebx, 0
    jge .apply_damage
    mov ebx, 0

.apply_damage:
    mov eax, msg_e_att
    call print_string
    mov eax, ebx
    call print_int
    mov eax, msg_e_hit
    call print_string

    mov eax, [player_hp]
    sub eax, ebx
    mov [player_hp], eax

    cmp dword [player_hp], 0
    jle .player_dead
    jmp battle_enemy

.enemy_defeated:
    mov eax, [current_room]
    inc eax
    mov [current_room], eax
    cmp dword [current_room], 4
    je .trigger_victory
    ret

.trigger_victory:
    call display_game_result
    ret

.player_dead:
    mov dword [player_hp], 0
    call display_game_result
    ret

use_potion:
    mov eax, [player_pot]
    cmp eax, 0
    jle .no_potions

    mov eax, [player_hp]
    cmp eax, [player_max]
    jge .already_full

    dec dword [player_pot]
    add eax, 20
    mov ebx, [player_max]
    cmp eax, ebx
    jle .save_hp
    mov eax, ebx

.save_hp:
    mov [player_hp], eax
    mov eax, msg_pot_use
    call print_string
    ret

.no_potions:
    mov eax, msg_pot_emp
    call print_string
    ret

.already_full:
    mov eax, msg_pot_ful
    call print_string
    ret

display_status:
    mov eax, lbl_status
    call print_string
    mov eax, lbl_hp
    call print_string
    mov eax, [player_hp]
    call print_int
    mov eax, lbl_max_hp
    call print_string
    mov eax, [player_max]
    call print_int
    mov eax, newline
    call print_string
    mov eax, lbl_atk
    call print_string
    mov eax, [player_atk]
    call print_int
    mov eax, newline
    call print_string
    ret

display_inventory:
    mov eax, lbl_inv
    call print_string
    mov eax, lbl_gold
    call print_string
    mov eax, [player_gold]
    call print_int
    mov eax, newline
    call print_string
    mov eax, lbl_potions
    call print_string
    mov eax, [player_pot]
    call print_int
    mov eax, newline
    call print_string
    ret

display_game_result:
    cmp dword [player_hp], 0
    jle .defeat_screen

    mov eax, victory_msg
    call print_string
    mov eax, final_g_lbl
    call print_string
    mov eax, [player_gold]
    call print_int
    mov eax, newline
    call print_string
    mov eax, rem_hp_lbl
    call print_string
    mov eax, [player_hp]
    call print_int
    mov eax, newline
    call print_string
    mov eax, hero_foot
    call print_string
    jmp .end_execution

.defeat_screen:
    mov eax, defeat_msg
    call print_string

.end_execution:
    call exit_program

exit_program:
    mov eax, 1
    mov ebx, 0
    int 0x80

; =============================================================================
; HELPER FUNCTIONS FOR TERMINAL OUTPUT
; =============================================================================

print_string:
    push ebx
    push ecx
    push edx
    mov ecx, eax
    mov edx, 0
.loop_len:
    cmp byte [ecx + edx], 0
    je .write
    inc edx
    jmp .loop_len
.write:
    mov eax, 4
    mov ebx, 1
    int 0x80
    pop edx
    pop ecx
    pop ebx
    ret

	

print_int:
    push eax
    push ebx
    push ecx
    push edx
    push esi
    
    mov ecx, num_buffer
    add ecx, 11
    mov byte [ecx], 0
    mov ebx, 10
    mov esi, 0

    cmp eax, 0
    jne .convert
    dec ecx
    mov byte [ecx], '0'
    jmp .print

.convert:
    mov edx, 0
    div ebx
    add dl, '0'
    dec ecx
    mov [ecx], dl
    cmp eax, 0
    jne .convert

.print:
    mov eax, ecx
    call print_string
    
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

