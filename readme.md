-- variables

1. _name = "Hydromotion coin"
        name of Token

2. _symbol = "HYM"
        symbol of Token
3. minBuy = 10
        mimimum amount if Tokens any user can mint.
4. maxSupply = 50000000000 * 10**2
        Maximum amount of tokens users can ever mint.
5. uint256 totalBought
        store total amount of tokens that are already minted.
6. _deployTime
        store time when contract deployed.
7. eur_to_usdPrice
        return price of 1 euro in dolor 
8. erc20Address
        store address of erc20Tokken contract
9. erc20ContractOwner
        store address of owner of both contracts
10. currentPriceFor1
        return price of 1 token in euro

-- Struct 

1. timestampInfo {
    uint256 tokens;
    uint256 timestamp;
}
    this structure use to store token amount minted when press mint button and the current time stamp when tokens minted

-- Mappings

1. mapping(address => timestampInfo[]) storeTimeInfo;
    store array of structure timestampInfo of every user

-- Functions

1. CurrentPrice
    calculate the current price required to mint 1 token in wei which will be equalant to very aproximately 0.01 euro for round 1. 
    it can change when new round starts acordingly. 

2. getEURtoUSDPrice
    it calculate price of 1 euro into usd

3. buy
    check if minBuy is satisfied.
    check if totalBought is not reached to is maxSupply
    call getEURtoUSDPrice() function to get latest price for mint 1 token.
    check if passed value(amount) is >= required amount for minting specified number of tokens.
    transfer the mentioned amount of tokens to caller account. 

    update mapping 
    update totalBought
4. sell
    user not allowed to call this function if the contract deployed time + minimum required time to transfer function.
    check if user have enough tokens is his account
    check if his required time to mint the contract is passed.
    update the mapping. 
5. getFunds
    transfer funds from contract to owner account


6. checkStructArray
    return mapping of msg.sender