module kampung::absen {
    use std::signer;
    use aptos_framework::timestamp;

    struct Status has key { terakhir_ping: u64 }

    public entry fun absen(account: &signer) acquires Status {
        let addr = signer::address_of(account);
        let skrg = timestamp::now_seconds();
        if (exists<Status>(addr)) {
            borrow_global_mut<Status>(addr).terakhir_ping = skrg;
        } else {
            move_to(account, Status { terakhir_ping: skrg });
        }
    }

    #[view]
    public fun terakhir_absen(addr: address): u64 acquires Status {
        borrow_global<Status>(addr).terakhir_ping
    }
}
