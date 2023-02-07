// scripts/transfer-ownership.js
async function main () {
    const gnosisSafe = '0x08f1cF5B05d4896f4E6CFE2f82635093800AA588';
  
    console.log('Transferring ownership of ProxyAdmin...');
    // The owner of the ProxyAdmin can upgrade our contracts
    await upgrades.admin.transferProxyAdminOwnership(gnosisSafe);
    console.log('Transferred ownership of ProxyAdmin to:', gnosisSafe);
  }
  
  main()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error);
      process.exit(1);
    });