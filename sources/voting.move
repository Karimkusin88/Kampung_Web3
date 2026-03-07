module kampung::voting {
    use std::signer;
    use std::string::String;
    use aptos_framework::timestamp;

    struct Proposal has key {
        judul: String,
        deskripsi: String,
        suara_setuju: u64,
        suara_tolak: u64,
        dibuat_pada: u64,
        aktif: bool,
    }

    struct SudahVote has key { proposal_addr: address }

    public entry fun ajukan_usul(account: &signer, judul: String, deskripsi: String) {
        let addr = signer::address_of(account);
        assert!(!exists<Proposal>(addr), 1);
        move_to(account, Proposal { judul, deskripsi, suara_setuju: 0, suara_tolak: 0, dibuat_pada: timestamp::now_seconds(), aktif: true });
    }

    public entry fun vote(account: &signer, proposal_addr: address, setuju: bool) acquires Proposal {
        let addr = signer::address_of(account);
        assert!(!exists<SudahVote>(addr), 2);
        let proposal = borrow_global_mut<Proposal>(proposal_addr);
        assert!(proposal.aktif, 3);
        if (setuju) { proposal.suara_setuju = proposal.suara_setuju + 1 } else { proposal.suara_tolak = proposal.suara_tolak + 1 };
        move_to(account, SudahVote { proposal_addr });
    }

    #[view]
    public fun hasil_vote(proposal_addr: address): (u64, u64) acquires Proposal {
        let p = borrow_global<Proposal>(proposal_addr);
        (p.suara_setuju, p.suara_tolak)
    }
}
