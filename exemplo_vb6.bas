' Exemplo de uso da DLL hashcsrt.dll em VB6
' 
' Declarações das funções da DLL
Private Declare Function calculate_sha1_hash Lib "hashcsrt.dll" (ByVal input As String) As Long
Private Declare Sub free_string Lib "hashcsrt.dll" (ByVal ptr As Long)

' Função auxiliar para converter ponteiro C em String VB6
Private Function PtrToString(ByVal ptr As Long) As String
    Dim length As Long
    Dim i As Long
    Dim char As Byte
    Dim result As String
    
    If ptr = 0 Then
        PtrToString = ""
        Exit Function
    End If
    
    ' Encontra o comprimento da string (até o null terminator)
    length = 0
    Do
        CopyMemory char, ByVal ptr + length, 1
        If char = 0 Then Exit Do
        length = length + 1
    Loop
    
    ' Copia a string
    If length > 0 Then
        result = Space$(length)
        CopyMemory ByVal StrPtr(result), ByVal ptr, length
        PtrToString = result
    Else
        PtrToString = ""
    End If
End Function

' Declaração da API do Windows para copiar memória
Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" _
    (Destination As Any, Source As Any, ByVal length As Long)

' Função principal que calcula o SHA-1 Hash
Public Function CalculateSHA1Hash(ByVal input As String) As String
    Dim resultPtr As Long
    Dim hashResult As String
    
    ' Chama a função da DLL
    resultPtr = calculate_sha1_hash(input & vbNullChar)
    
    If resultPtr <> 0 Then
        ' Converte o ponteiro para string VB6
        hashResult = PtrToString(resultPtr)
        
        ' Libera a memória alocada pela DLL
        free_string resultPtr
        
        CalculateSHA1Hash = hashResult
    Else
        CalculateSHA1Hash = ""
    End If
End Function

' Exemplo de uso
Sub ExemploUso()
    Dim CSRT As String
    Dim hashCSRT As String
    
    CSRT = "G8063VRTNDMO886SFNK5LDUDEI24XJ22YIPO"
    hashCSRT = CalculateSHA1Hash("G8063VRTNDMO886SFNK5LDUDEI24XJ22YIPO41180678393592000146558900000006041028190697")
    
    MsgBox "Hash SHA-1 (Base64): " & hashCSRT
End Sub
