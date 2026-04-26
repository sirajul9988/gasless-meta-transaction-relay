const { ethers } = require("ethers");

async function signMetaTransaction(signer, contractAddress, functionSignature) {
    const domain = {
        name: "GaslessRelay",
        version: "1",
        chainId: (await signer.provider.getNetwork()).chainId,
        verifyingContract: contractAddress
    };

    const types = {
        Execute: [
            { name: "user", type: "address" },
            { name: "nonce", type: "uint256" },
            { name: "functionSignature", type: "bytes" }
        ]
    };

    const userAddress = await signer.getAddress();
    const nonce = 0; // Fetch from contract in real scenario

    const value = {
        user: userAddress,
        nonce: nonce,
        functionSignature: functionSignature
    };

    const signature = await signer.signTypedData(domain, types, value);
    return ethers.Signature.from(signature);
}

module.exports = { signMetaTransaction };
