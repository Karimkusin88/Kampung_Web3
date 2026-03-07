module kampung::warga {
    use std::signer;
    use std::string::String;
    use aptos_framework::timestamp;

    struct Warga has key {
        nama: String,
        alamat: String,
        terdaftar_pada: u64,
        aktif: bool,
    }

    struct KampungInfo has key {
        nama_kampung: String,
        total_warga: u64,
        ketua: address,
    }

    public entry fun resmikan_kampung(account: &signer, nama_kampung: String) {
        let addr = signer::address_of(account);
        assert!(!exists<KampungInfo>(addr), 1);
        move_to(account, KampungInfo { nama_kampung, total_warga: 0, ketua: addr });
    }

    public entry fun daftar_warga(account: &signer, nama: String, alamat: String) {
        let addr = signer::address_of(account);
        assert!(!exists<Warga>(addr), 2);
        move_to(account, Warga { nama, alamat, terdaftar_pada: timestamp::now_seconds(), aktif: true });
    }

    #[view]
    public fun is_warga(addr: address): bool { exists<Warga>(addr) }
}
