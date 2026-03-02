module kampung_account::ping_v1 {
    use std::signer;
    use aptos_framework::timestamp;

    struct Status has key { terakhir_ping: u64 }

    public entry fun absen(account: &signer) acquires Status {
        let addr = signer::address_of(account);
        let skrg = timestamp::now_seconds();
        if (exists<Status>(addr)) {
            let s = borrow_global_mut<Status>(addr);
            s.terakhir_ping = skrg;
        } else {
            move_to(account, Status { terakhir_ping: skrg });
        }
    }
}
