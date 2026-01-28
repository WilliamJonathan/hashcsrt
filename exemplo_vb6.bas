' ========================================
' Exemplo SIMPLES de uso da DLL hashcsrt.dll em VB6
' ========================================

' 1. DECLARAÇÕES DA DLL (coloque no topo do módulo ou form)
Private Declare Function calcular_sha1_hash Lib "hashcsrt.dll" (ByVal input As String) As Long
Private Declare Sub free_string Lib "hashcsrt.dll" (ByVal ptr As Long)
Private Declare Function lstrcpyA Lib "kernel32" (ByVal dest As String, ByVal src As Long) As Long
Private Declare Function lstrlenA Lib "kernel32" (ByVal ptr As Long) As Long

' 2. FUNÇÃO AUXILIAR - Converte ponteiro para String VB6
Private Function GetStringFromPointer(ByVal ptr As Long) As String
    If ptr = 0 Then
        GetStringFromPointer = ""
        Exit Function
    End If
    
    Dim tamanho As Long
    tamanho = lstrlenA(ptr)
    
    If tamanho > 0 Then
        GetStringFromPointer = Space$(tamanho)
        lstrcpyA GetStringFromPointer, ptr
    Else
        GetStringFromPointer = ""
    End If
End Function

' 3. FUNÇÃO PRINCIPAL - Calcula SHA-1 e retorna Base64
Public Function SHA1_Base64(ByVal texto As String) As String
    Dim ptr As Long
    Dim resultado As String
    
    ' Chama a DLL
    ptr = calcular_sha1_hash(texto & vbNullChar)
    
    If ptr <> 0 Then
        ' Obtém o resultado
        resultado = GetStringFromPointer(ptr)
        
        ' IMPORTANTE: Libera a memória
        free_string ptr
        
        SHA1_Base64 = resultado
    Else
        SHA1_Base64 = ""
    End If
End Function

' 4. EXEMPLO DE USO
Sub TestarHash()
    Dim entrada As String
    Dim hash As String
    
    ' Exemplo 1: Texto simples
    entrada = "Hello World"
    hash = SHA1_Base64(entrada)
    MsgBox "Texto: " & entrada & vbCrLf & "Hash: " & hash
    
    ' Exemplo 2: String do sistema
    entrada = "T8L5TVKWDNGCESXPPIDF3I8Q8C397VBY2EFG41260138178375000119550010000480271779314050"
    hash = SHA1_Base64(entrada)
    MsgBox "Hash SHA-1 (Base64): " & hash
End Sub
