# WOO

与上一道题目DB类似，问题还是出在获取奖励上    
设置黑名单防止重复获取奖励，但是忘记了考虑玩家处于购物状态的情况

https://github.com/m4sk93/movectf/blob/69e71452df1ebddbd552499d35a5248a95b5dd9f/justctf2024/woo/sources/framework-solve/dependency/sources/quest.move#L265-L281

```
    public fun get_the_reward(vault: &mut Vault<OTTER>, board: &mut QuestBoard, player: &mut Player, ctx: &mut TxContext) {
        assert!(player.status != RESTING && player.status != PREPARE_FOR_TROUBLE && player.status != ON_ADVENTURE, WRONG_PLAYER_STATE);


        let monster = vector::remove(&mut board.quests, player.quest_index);


        let Monster {
            reward: reward,
            power: _
        } = monster;


        let coins = coin::split(&mut vault.cash, reward, ctx); 
        let balance = coin::into_balance(coins);


        balance::join(&mut player.wallet, balance);


        player.status = RESTING;
    }
```

```
    public fun enter_tavern(player: &mut Player): TawernTicket {
        assert!(player.status == RESTING, WRONG_PLAYER_STATE);

        player.status = SHOPPING;

        TawernTicket{ total: 0, flag_bought: false }
    }
```
