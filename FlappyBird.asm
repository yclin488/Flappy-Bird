;412262656 林彥辰  

;412262668 吳采凌 

; FlappyBirdGame.asm - Flappy Bird-like game in MASM
.386
.model flat, stdcall
.stack 4096

; 定義 Windows API 函數
ExitProcess proto, dwExitCode:dword
GetStdHandle proto, nStdHandle:dword
WriteConsoleA proto, hConsole:dword, lpBuffer:ptr byte, nNumberOfCharsToWrite:dword, lpNumberOfCharsWritten:ptr dword, lpReserved:dword
SetConsoleCursorPosition proto, hConsole:dword, dwCursorPosition:dword
Sleep proto, dwMilliseconds:dword
GetAsyncKeyState proto, vKey:dword

HANDLE typedef DWORD

.const
    SCREEN_WIDTH EQU 50
    SCREEN_HEIGHT EQU 20
    OBSTACLE_GAP EQU 6
    INITIAL_SPEED EQU 100
    STD_OUTPUT_HANDLE EQU -11
    VK_SPACE EQU 20h

.data
    ; 遊戲變數
    birdY DWORD SCREEN_HEIGHT / 2       ; 鳥的垂直位置
    score DWORD 0                       ; 分數
    gameOver DWORD 0                    ; 遊戲是否結束
    gameSpeed DWORD INITIAL_SPEED       ; 遊戲速度
    hConsole HANDLE ?                   ; 控制台句柄

    ; 障礙物佇列 (模擬環形佇列)
    ObstacleQueue DWORD 10 DUP(0)       ; 每個障礙物 3 個 DWORD
    QueueFront DWORD 0
    QueueRear DWORD 0

    ; 文本
    msgGameOver BYTE "Game Over! Final Score: ", 0
    msgScore BYTE "Score: ", 0
    msgPlayAgain BYTE "Do you want to play again? (y/n): ", 0
    msgThankYou BYTE "Thank you for playing!", 0

.code
main PROC
    ; 初始化控制台
    call InitializeConsole

    ; 遊戲主邏輯
GameLoopStart:
    call InitializeGame      ; 初始化遊戲變數與佇列
    call GameLoop            ; 運行遊戲主邏輯
    call DisplayGameOver     ; 顯示遊戲結束訊息

    ; 問玩家是否重新開始
    push OFFSET msgPlayAgain
    push hConsole
    call WriteConsoleString
    call GetInputKey          ; 等待玩家按下 y/n
    cmp al, 'y'
    je GameLoopStart

    ; 顯示感謝訊息並退出
    push OFFSET msgThankYou
    push hConsole
    call WriteConsoleString
    push 0
    call ExitProcess
main ENDP

; 初始化控制台
InitializeConsole PROC
    push STD_OUTPUT_HANDLE
    call GetStdHandle
    mov hConsole, eax
    ret
InitializeConsole ENDP

; 初始化遊戲
InitializeGame PROC
    mov birdY, SCREEN_HEIGHT / 2
    mov score, 0
    mov gameOver, 0
    call InitializeQueue
    call GenerateObstacles
    ret
InitializeGame ENDP

; 遊戲主邏輯
GameLoop PROC
    GameLoopStart:
        cmp gameOver, 1
        je GameLoopEnd

        call ProcessInput        ; 處理玩家輸入
        call UpdateObstacles     ; 更新障礙物邏輯
        call DrawScreen          ; 繪製畫面
        push gameSpeed
        call Sleep               ; 延遲以控制遊戲速度
        jmp GameLoopStart

    GameLoopEnd:
    ret
GameLoop ENDP

; 處理玩家輸入
ProcessInput PROC
    push VK_SPACE
    call GetAsyncKeyState
    test ax, 8000h              ; 檢查空白鍵是否被按下
    jz NoJump
    sub birdY, 1
NoJump:
    add birdY, 1
    cmp birdY, 0
    jl SetGameOver
    cmp birdY, SCREEN_HEIGHT
    jge SetGameOver
    ret

SetGameOver:
    mov gameOver, 1
    ret
ProcessInput ENDP

; 更新障礙物邏輯
UpdateObstacles PROC
    ; 更新每個障礙物位置
    ; 如果障礙物移出屏幕，則生成新障礙物
    ; 檢查鳥是否撞到障礙物
    ; TODO: 完整邏輯實現
    ret
UpdateObstacles ENDP

; 繪製畫面
DrawScreen PROC
    call ClearScreen
    ; 繪製鳥的位置
    ; 繪製障礙物
    ; 顯示分數
    ; TODO: 完整邏輯實現
    ret
DrawScreen ENDP

; 清空螢幕
ClearScreen PROC
    ; 使用 SetConsoleCursorPosition
    ret
ClearScreen ENDP

; 顯示遊戲結束訊息
DisplayGameOver PROC
    push OFFSET msgGameOver
    push hConsole
    call WriteConsoleString
    mov eax, score
    push eax
    push hConsole
    call WriteConsoleNumber
    ret
DisplayGameOver ENDP

; 獲取玩家輸入按鍵
GetInputKey PROC
    ; 等待玩家按鍵並返回其值
    ret
GetInputKey ENDP

; 初始化佇列
InitializeQueue PROC
    mov QueueFront, 0
    mov QueueRear, 0
    ret
InitializeQueue ENDP

; 生成初始障礙物
GenerateObstacles PROC
    ; TODO: 障礙物生成邏輯
    ret
GenerateObstacles ENDP

; 輸出字串
WriteConsoleString PROC
    push 0                   ; lpReserved
    push dword ptr [esp+8]   ; lpBuffer
    push -1                  ; 自動計算字串長度
    push dword ptr [esp+12]  ; hConsole
    call WriteConsoleA
    ret
WriteConsoleString ENDP

; 輸出數字
WriteConsoleNumber PROC
    ; TODO: 數字轉字串並輸出
    ret
WriteConsoleNumber ENDP

END main
