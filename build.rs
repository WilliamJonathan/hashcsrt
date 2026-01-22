fn main() {
    // Apenas para Windows 32-bit (i686)
    if std::env::var("CARGO_CFG_TARGET_ARCH").unwrap() == "x86" {
        // Força a exportação dos símbolos sem decoração (sem @N)
        // Isso facilita o uso no VB6 sem precisar de Alias complexos
        println!("cargo:rustc-cdylib-link-arg=/EXPORT:processar_dados_excel_para_mysql");
        println!("cargo:rustc-cdylib-link-arg=/EXPORT:processar_dados_excel_para_mysql_env");
        println!("cargo:rustc-cdylib-link-arg=/EXPORT:free_string");
    }
}
