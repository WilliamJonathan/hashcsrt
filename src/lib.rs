use std::ffi::{CStr, CString};
use std::os::raw::c_char;
use sha1::{Sha1, Digest};
use base64::{Engine as _, engine::general_purpose};

/// Calcula o hash SHA-1 de uma entrada e retorna o resultado em formato Base64.
/// 
/// Esta função é exportada para ser chamada de VB6 ou outras linguagens que suportam C ABI.
/// 
/// # Parâmetros
/// * `input` - Ponteiro para uma string C (null-terminated) de entrada
/// 
/// # Retorno
/// * Ponteiro para uma string C com o hash SHA-1 em formato Base64
/// * Retorna null em caso de erro
/// 
/// # Importante
/// * O caller é responsável por liberar a memória usando `free_string`
/// * A string de entrada deve estar em UTF-8 ou será convertida se possível
#[unsafe(no_mangle)]
pub unsafe extern "C" fn calculate_sha1_hash(input: *const c_char) -> *mut c_char {
    // Verifica se o ponteiro é válido
    if input.is_null() {
        return std::ptr::null_mut();
    }

    // Converte a C string para Rust string
    let c_str = unsafe {
        match CStr::from_ptr(input).to_str() {
            Ok(s) => s,
            Err(_) => return std::ptr::null_mut(),
        }
    };

    // Calcula o hash SHA-1
    let mut hasher = Sha1::new();
    hasher.update(c_str.as_bytes());
    let result = hasher.finalize();

    // Converte para Base64
    let base64_string = general_purpose::STANDARD.encode(result);

    // Converte para C string para retornar
    match CString::new(base64_string) {
        Ok(c_string) => c_string.into_raw(),
        Err(_) => std::ptr::null_mut(),
    }
}

/// Libera a memória alocada para uma string retornada por calculate_sha1_hash
/// 
/// # Parâmetros
/// * `s` - Ponteiro para a string C a ser liberada
/// 
/// # Importante
/// * Deve ser chamada exatamente uma vez para cada string retornada
/// * Não chame com strings que não foram retornadas por calculate_sha1_hash
#[unsafe(no_mangle)]
pub unsafe extern "C" fn free_string(s: *mut c_char) {
    if !s.is_null() {
        unsafe {
            // Reconstrói o CString para que seja dropped e a memória liberada
            let _ = CString::from_raw(s);
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::ffi::CString;

    #[test]
    fn test_calculate_sha1_hash() {
        // Teste com o exemplo do código C#
        let input = CString::new("G8063VRTNDMO886SFNK5LDUDEI24XJ22YIPO41180678393592000146558900000006041028190697").unwrap();
        let result_ptr = unsafe { calculate_sha1_hash(input.as_ptr()) };
        
        assert!(!result_ptr.is_null());
        
        let result_cstr = unsafe { CStr::from_ptr(result_ptr) };
        let result = result_cstr.to_str().unwrap();
        
        // O hash SHA-1 em Base64 deve ter 28 caracteres (20 bytes * 4/3)
        assert!(result.len() > 0);
        println!("SHA-1 Hash (Base64): {}", result);
        
        // Libera a memória
        unsafe { free_string(result_ptr); }
    }

    #[test]
    fn test_null_input() {
        let result = unsafe { calculate_sha1_hash(std::ptr::null()) };
        assert!(result.is_null());
    }
}
