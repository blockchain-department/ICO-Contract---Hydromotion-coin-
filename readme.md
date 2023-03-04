## **-------P R E S A L E   C O N T R A C T-------**

#### **-- variables**

**1. minBuy = 10**
>        mimimum amount if Tokens any user can mint.

**2. totalBought**
>        store total amount of tokens that are already minted.

**3. eur_to_usdPrice**
>        return price of 1 euro in dolor 

**4. erc20Address**
>        store address of erc20Tokken contract

**5. OwnerIs**
>        store address of owner of both contracts

------------


------------

#### **-- Constructor**

**constructor() {
OwnerIs = msg.sender;
    }**
>     sets the address of Owner

------------


------------


#### **-- Struct**

**1. timestampInfo {
    uint256 tokens;
    uint256 timestamp;
}**
>     this structure use to store token amount minted when press mint button and the current time stamp when tokens minted

------------


------------


#### **-- Mappings**

**1. mapping(address => timestampInfo[]) storeTimeInfo;**
>     store array of structure timestampInfo of every user

**2. mapping(address => uint256) withdrawAble;**
>     store available tokens to sell.


------------

------------

####**-- Functions**

**1. CurrentPrice**
>    - calculate the current price required to mint 1 token in wei which will be equalant to very aproximately 0.01 euro for round 1. 
   - it can change when new round starts acordingly. 
   - returns the current price.

**2. getEURtoUSDPrice**
>    it calculate price of 1 euro into usd

**3. buy**
>-     check if minBuy is satisfied.
-    check if totalBought is not reached to is maxSupply
-    call CurrentPrice() function to get latest price for mint 1 token.
-    check if passed value(amount) is >= required amount for minting specified number of tokens.
-    transfer the mentioned amount of tokens to caller account. 
-    update mapping 
-    update totalBought

**4. transfer**
>-    check if user have enough tokens is his account
-    check if his required time to mint the contract is passed.
-    update withdraw, storeTimeInfo mapping.
-    sell the tokens if withdraw is not empty.

**5. withdraw**
>-    transfer funds from contract to owner account

**6. withdrawTokens**
>-    Owner can transfer Contract Tokens to any Account

**7. mint**
>-    Owner can mint Tokens for any Account

**8. transferOwnership**
>-    Owner can set new Owner to any Account

**9. setTokenAddress**
>-    Owner can set new ERC20Contract Address


**6. checkUserBuyList**
>-    return mapping of msg.sender


## **-------E R C - 2 0   C O N T R A C T-------**

> this is standard erc20 contract followed by OpenZeppelin standard with additional change is transfer and transferFrom functions by overriding them so they are only can be called by PRESALE contract which can be defined with another custom function which sets address of presale smartcontract in a new variable and that variable use to check if transfer functions are called by that contract address.
