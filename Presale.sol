// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;
// 0x068F62f072B9c15Df83426C3C6d598d138F930f4
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface erc20 {
    function mint(address to, uint256 amount) external;
    function __transfer(address to, uint256 amount)
        external
        returns (bool);

}

contract Presale {
    uint256 public immutable minBuy = 10 * 10**2;

    uint256 totalBought;

    int256 private eur_to_usdPrice;

    address private erc20Address;
    address private OwnerIs;

    mapping(address => timestampInfo[]) storeTimeInfo;
    mapping(address => uint256) withdrawAble;

    constructor() {
        OwnerIs = msg.sender;
    }

    struct timestampInfo {
        uint256 tokens;
        uint256 timestamp;
    }

    function CurrentPrice() public view returns (uint256) {
        getEURtoUSDPrice();

        if (totalBought <= 10000000000 * 10**2) {
            return ((getEURtoUSDPrice()) / (10000)) * (10**7);
        } else if (totalBought <= 20000000000 * 10**2) {
            return ((getEURtoUSDPrice()) / (1000)) * (10**7);
        } else if (totalBought <= 30000000000 * 10**2) {
            return ((getEURtoUSDPrice()) / (100)) * (10**7);
        } else if (totalBought <= 40000000000 * 10**2) {
            return ((getEURtoUSDPrice()) / (10)) * (10**7);
        } else if (totalBought <= 50000000000 * 10**2){
            return ((getEURtoUSDPrice()) / (1)) * (10**7);
        }
        else{
            revert ("Already Max Minted, Now Only Owner Can Mint");
        }
    }

    function getEURtoUSDPrice() public view returns (uint256) {
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

        require(msg.value >= (CurrentPrice() * (amount/10**2)), "Low Value Pass");
        IERC20(erc20Address).transfer(caller, (amount));
        

        storeTimeInfo[caller].push(timestampInfo((amount), block.timestamp));

        totalBought = totalBought + (amount);
    }

    function fiatBuy(uint256 amount, address account) public {
        require(msg.sender == OwnerIs, "only Owner Is allowed to call");

        require(amount >= minBuy, "Low Amount Pass");

        IERC20(erc20Address).transfer(account, (amount));

        storeTimeInfo[account].push(timestampInfo((amount), block.timestamp));

        totalBought = totalBought + (amount);
    }

    function transfer(uint256 amount, address account) public virtual returns (bool) {
        address caller = msg.sender;

        require(
            IERC20(erc20Address).balanceOf(caller) >= amount,
            "Not Enough tokens abailable"
        );

        timestampInfo[] storage temp = storeTimeInfo[caller];

        for (uint256 i = 0; i < temp.length; i++) {
            if (temp[i].timestamp + 1 minutes <= block.timestamp) {
                withdrawAble[caller] += temp[i].tokens;

                temp[i] = temp[temp.length - 1];
                temp.pop();
            }
        }

        require(
            withdrawAble[caller] >= amount,
            "WithrawAble amount is not enough"
        );

        erc20(erc20Address).__transfer(account, amount);

        return false;
    }

    function withdraw() external  {
        require(msg.sender == OwnerIs, "invalid user");
        (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(success, "Failed to send amount");
    }

    function withdrawTokens(uint256 amount, address account) public {
        require(msg.sender == OwnerIs, "only Owner Is allowed to call");

        IERC20(erc20Address).transfer(account, amount);
    }

    function mint(address to, uint256 amount) public {
        require(msg.sender == OwnerIs, "can be only called by Owner");
        erc20(erc20Address).mint(to, amount);

        storeTimeInfo[to].push(timestampInfo(amount, block.timestamp));
        totalBought = totalBought + amount;
    }

    function transferOwnership(address account) public {
        require(msg.sender == OwnerIs, "only Owner Function");
        OwnerIs = account;
    }

    function setTokenAddress(address tokenAddress) public {
        erc20Address = tokenAddress;
    }

    function checkUserBuyList() public view returns (timestampInfo[] memory) {
        return storeTimeInfo[msg.sender];
    }
}
