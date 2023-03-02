// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;
// 0x068F62f072B9c15Df83426C3C6d598d138F930f4
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Presale {

    uint256 public immutable minBuy = 10;
    uint256 maxSupply = 50000000000 * 10**2;

    uint256 totalBought;

    uint256 private _deployTime;
    int256 private eur_to_usdPrice;

    address private erc20Address;
    address private OwnerIs;

    // uint256 public currentPriceFor1;

    constructor(address tokenAddress, address owner) {
        _deployTime = block.timestamp;
        erc20Address = tokenAddress;
        OwnerIs = owner;
    }

    struct timestampInfo {
        uint256 tokens;
        uint256 timestamp;
    }

    mapping(address => timestampInfo[]) storeTimeInfo;
    mapping(address => uint256) withdrawAble;

    function CurrentPrice() public view returns(uint256) {
        getEURtoUSDPrice();

        if (totalBought <= 10000000000 * 10**2) {
            return( ((getEURtoUSDPrice()) / 10000) * (10**7));
        } else if (totalBought <= 20000000000 * 10**2) {
            return( ((getEURtoUSDPrice()) / 1000) * (10**7));
        } else if (totalBought <= 30000000000 * 10**2) {
            return( ((getEURtoUSDPrice()) / 100) * (10**7));
        } else if (totalBought <= 40000000000 * 10**2) {
            return( ((getEURtoUSDPrice()) / 10) * (10**7));
        }

        else{
            return( ((getEURtoUSDPrice()) / 1) * (10**7));
        }
    }

    function getEURtoUSDPrice() public view  returns(uint256){
            AggregatorV3Interface priceFeed;

        priceFeed = AggregatorV3Interface(
            0x7d7356bF6Ee5CDeC22B216581E48eCC700D0497A
        );
        (
            ,
            /*uint80 roundID*/
            int256 price, /*uint startedAt*/ /*uint timeStamp*/ /*uint80 answeredInRound*/
            ,
            ,

        ) = priceFeed.latestRoundData();
        return uint256(price);
    }

    function buy(uint256 amount) public payable {
        address caller = msg.sender;

        require(amount >= minBuy, "Low Amount Pass");
        require(totalBought <= maxSupply, "Total Minted Amount execeded");

        require(msg.value >= (CurrentPrice() * amount), "Low Value Pass");
        IERC20(erc20Address).transfer(caller, amount);

        storeTimeInfo[caller].push(timestampInfo(amount, block.timestamp));

        totalBought = totalBought + amount;
    }

    function sell(uint256 amount) public virtual returns (bool) {
        address caller = msg.sender;
        require(
            block.timestamp >= _deployTime + 3 minutes,
            "not allowed to mint for first 4 years time prtiod"
        );

        require(
            IERC20(erc20Address).balanceOf(caller) >= amount,
            "Not Enough tokens abailable"
        );

        timestampInfo[] storage temp = storeTimeInfo[caller];

        for (uint256 i = 0; i < temp.length; i++) {
            if (
                temp[i].timestamp + 3 minutes <= block.timestamp &&
                temp[i].tokens <= amount
            ) {
                temp[i].tokens = temp[i].tokens - amount;
                withdrawAble[caller] += amount;

                temp[i] = temp[temp.length - 1];
                temp.pop();
                return true;
            }
        }

        require(
            withdrawAble[caller] >= amount,
            "WithrawAble amount is not enough"
        );

        IERC20(erc20Address).transferFrom(caller, address(this), amount);

        return false;
    }

    // get Amount From Contract to Owner Account

    function getFunds(address payable owner) public payable {
        require(msg.sender == OwnerIs, "invalid user");
        bool sent = owner.send(msg.value);
        require(sent, "Failed to send Ether");
    }

    // TESTING FUNCTIONS

    function checkStructArray() public view returns (timestampInfo[] memory) {
        return storeTimeInfo[msg.sender];
    }


    function ownerBuy(uint256 amount, address accountAdd) public {
        require(msg.sender == OwnerIs,"only Owner Is allowed to call");

        require(totalBought <= maxSupply, "Total Minted Amount execeded");

        IERC20(erc20Address).transfer(accountAdd, amount);

        storeTimeInfo[accountAdd].push(timestampInfo(amount, block.timestamp));

        totalBought = totalBought + amount;
    }
}
