# DB

酒馆里有个任务榜单，里面有不超过25个怪兽，击杀可以获取奖励   
获取奖励的函数存在逻辑漏洞,击杀榜单里第0个怪兽，可以领取所有怪兽的击杀奖金 

https://github.com/m4sk93/movectf/blob/69e71452df1ebddbd552499d35a5248a95b5dd9f/justctf2024/db/sources/framework-solve/dependency/sources/dark_brotterhood.move#L201-L223
```
    #[allow(lint(self_transfer))]
    public fun get_the_reward(
        vault: &mut Vault<OTTER>,
        board: &mut QuestBoard,
        player: &mut Player,
        quest_id: u64,
        ctx: &mut TxContext,
    ) {
        let quest_to_claim = vector::borrow_mut(&mut board.quests, quest_id);
        assert!(quest_to_claim.fight_status == FINISHED, WRONG_STATE);


        let monster = vector::pop_back(&mut board.quests);


        let Monster {
            fight_status: _,
            reward: reward,
            power: _
        } = monster;


        let coins = coin::split(&mut vault.cash, (reward as u64), ctx); 
        coin::join(&mut player.coins, coins);
    }

```
