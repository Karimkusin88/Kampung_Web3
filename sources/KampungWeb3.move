module 0x23adb5190b461f2821b3cafef93249837961a2c461fd103e94dd365f11bdb0b1::kampung_web3_v10 {
    use std::signer;
    use std::vector;
    use aptos_framework::coin::{Self, Coin};
    use aptos_framework::aptos_coin::AptosCoin;

    struct PestaRakyat has key {
        pool_hadiah: Coin<AptosCoin>,
        peserta: vector<address>
    }

    // Pak Lurah buka pendaftaran pesta
    public entry fun siapkan_pesta(account: &signer) {
        move_to(account, PestaRakyat { 
            pool_hadiah: coin::zero<AptosCoin>(),
            peserta: vector::empty<address>() 
        });
    }

    // Warga beli kupon buat join pesta (misal: 0.1 APT)
    public entry fun beli_kupon(account: &signer) acquires PestaRakyat {
        let biaya = 10000000; // 0.1 APT
        let sumbangan = coin::withdraw<AptosCoin>(account, biaya);
        let pesta = borrow_global_mut<PestaRakyat>(@0x23adb5190b461f2821b3cafef93249837961a2c461fd103e94dd365f11bdb0b1);
        
        coin::merge(&mut pesta.pool_hadiah, sumbangan);
        vector::push_back(&mut pesta.peserta, signer::address_of(account));
    }

    // Pak Lurah bagiin semua hadiah di pool ke pemenang
    public entry fun kocok_pemenang(admin: &signer, alamat_pemenang: address) acquires PestaRakyat {
        let admin_addr = signer::address_of(admin);
        assert!(admin_addr == @0x23adb5190b461f2821b3cafef93249837961a2c461fd103e94dd365f11bdb0b1, 403);
        
        let pesta = borrow_global_mut<PestaRakyat>(admin_addr);
        let total_hadiah = coin::extract_all(&mut pesta.pool_hadiah);
        coin::deposit(alamat_pemenang, total_hadiah);
    }
}
