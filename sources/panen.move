module kampung_web3::manajemen_panen {
    use std::string::String;
    use std::signer;
    use aptos_framework::timestamp;
    use aptos_framework::event;

    struct CatatanPanen has key, store {
        jenis_tanaman: String,
        berat_kg: u64,
        tanggal_panen: u64,
        status_verifikasi: bool,
    }

    #[event]
    struct PanenTerdaftar has drop, store {
        petani: address,
        jenis: String,
        berat: u64,
    }

    public entry fun daftar_panen_warga(
        lurah: &signer, 
        alamat_petani: address, 
        jenis: String, 
        berat: u64
    ) {
        // Alamat dompet Pak Lurah yang sakti
        assert!(signer::address_of(lurah) == @0x23adb5190b461f2821b3cafef93249837961a2c461fd103e94dd365f11bdb0b1, 1);

        let data = CatatanPanen {
            jenis_tanaman: jenis,
            berat_kg: berat,
            tanggal_panen: timestamp::now_seconds(),
            status_verifikasi: true,
        };

        move_to(lurah, data); 

        event::emit(PanenTerdaftar {
            petani: alamat_petani,
            jenis: jenis,
            berat: berat,
        });
    }
}
