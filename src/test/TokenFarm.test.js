const DaiToken = artifacts.require('DaiToken');
const DappToken = artifacts.require('DappToken');
const TokenFarm = artifacts.require('TokenFarm');

// TIME 50:00
require('chai')
  .use(require('chai-as-promised'))
  .should();

/**
 * Converts sting representation of ether amount into wei.
 * @param {string} n
 * @returns {string}
 */
function tokens(n) {
  return web3.utils.toWei(n, 'ether');
}

// destructor owner and investor from accounts array
contract('TokenFarm', ([owner, investor]) => {
  let daiToken, dappToken, tokenFarm;
  before(async () => {
    // Load Contracts
    daiToken = await DaiToken.new();
    dappToken = await DappToken.new();
    tokenFarm = await TokenFarm.new(daiToken.address, dappToken.address);

    // Transfer all Dapp tokens to farm (1 million)
    await dappToken.transfer(tokenFarm.address, tokens('1000000'));

    // Send tokens to investors
    await daiToken.transfer(investor, tokens('100'), { from: owner });
  });

  // Tests
  describe('Mock DAI deployment', async () => {
    it('has a name', async () => {
      const name = await daiToken.name();
      assert.equal(name, 'Mock DAI Token');
    });
  });

  describe('DappToken deployment', async () => {
    it('has a name', async () => {
      const name = await dappToken.name();
      assert.equal(name, 'DApp Token');
    });
  });

  describe('Token Farm deployment', async () => {
    it('has a name', async () => {
      const name = await tokenFarm.name();
      assert.equal(name, 'Dapp Token Farm');
    });

    it('contract has tokens', async () => {
      let balance = await dappToken.balanceOf(tokenFarm.address);
      assert.equal(balance.toString(), tokens('1000000'));
    });

    it('investor has sent contract tokens', async () => {
      let balance = await daiToken.balanceOf(investor);
      assert.equal(balance.toString(), tokens('100'));
    });
  });
});
