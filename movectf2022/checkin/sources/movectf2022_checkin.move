/// Module: movectf2022_checkin
module movectf2022_checkin::movectf2022_checkin {
    use sui::event;
    use sui::tx_context::{Self, TxContext};

    public struct Flag has copy, drop {
        user: address,
        flag: bool
    }

    public entry fun get_flag(ctx: &mut TxContext) {
        event::emit(Flag {
            user: tx_context::sender(ctx),
            flag: true
        })
    }
}
