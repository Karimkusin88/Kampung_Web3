module kampung::kas {
    use std::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    struct Brankas has key {
        saldo: u64,
        total_donasi: u64,
    }

    public entry fun buka_brankas(account: &signer) {
        let addr = signer::address_of(account);
        assert!(!exists<Brankas>(addr), 1);
        move_to(account, Brankas { saldo: 0, total_donasi: 0 });
    }

    public entry fun sumbang(account: &signer, kampung_addr: address, jumlah: u64) acquires Brankas {
        coin::transfer<AptosCoin>(account, kampung_addr, jumlah);
        let brankas = borrow_global_mut<Brankas>(kampung_addr);
        brankas.saldo = brankas.saldo + jumlah;
        brankas.total_donasi = brankas.total_donasi + jumlah;
    }

    #[view]
    public fun cek_saldo(kampung_addr: address): u64 acquires Brankas {
        borrow_global<Brankas>(kampung_addr).saldo
    }
}
