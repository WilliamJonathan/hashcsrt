# HashCSRT - DLL Rust para VB6

DLL em Rust para calcular hash SHA-1 e retornar em Base64, compatível com VB6.

## Requisitos

- Rust toolchain instalado
- Target i686-pc-windows-msvc (32-bit) instalado

Para instalar o target 32-bit:
```bash
rustup target add i686-pc-windows-msvc
```

## Compilação

```bash
cargo build --release
```

A DLL será gerada em: `target\i686-pc-windows-msvc\release\hashcsrt.dll`

## Uso em VB6

1. Copie a DLL `hashcsrt.dll` para a pasta do seu projeto VB6 ou para `C:\Windows\System32`

2. Importe o módulo `exemplo_vb6.bas` no seu projeto VB6

3. Use a função `CalculateSHA1Hash`:

```vb
Dim hash As String
hash = CalculateSHA1Hash("sua_string_aqui")
MsgBox hash
```

## Exemplo

```vb
Dim CSRT As String
Dim hashCSRT As String

CSRT = "G8063VRTNDMO886SFNK5LDUDEI24XJ22YIPO"
hashCSRT = CalculateSHA1Hash("G8063VRTNDMO886SFNK5LDUDEI24XJ22YIPO41180678393592000146558900000006041028190697")

MsgBox "Hash SHA-1 (Base64): " & hashCSRT
```

## Funções da DLL

### `calculate_sha1_hash`
- **Entrada**: String (null-terminated)
- **Saída**: Ponteiro para string com hash SHA-1 em Base64
- **Nota**: A memória deve ser liberada com `free_string`

### `free_string`
- **Entrada**: Ponteiro retornado por `calculate_sha1_hash`
- **Saída**: Nenhuma
- **Nota**: Libera a memória alocada pela DLL

## Arquitetura

A DLL aceita parâmetros em tempo de execução (não fixos), conforme solicitado. A string de entrada é passada como parâmetro e o hash é calculado dinamicamente.
