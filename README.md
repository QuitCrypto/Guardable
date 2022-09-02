**GUARDABLE**

Guardable is a contract module which provides added security functionality, where an account can assign a guardian to protect their NFTs. While a guardian is assigned, setApprovalForAll is locked. New approvals cannot be set. There can only ever be one guardian per account, and setting a new guardian will overwrite any existing one.

Existing approvals can still be leveraged as normal, and it is expected that this functionality be used after a user has set the approvals they want to set. Approvals can still be removed while a guardian is set.

Setting a guardian has no effect on transfers, so users can move assets to a new wallet to effectively "clear" guardians if a guardian is maliciously set, or keys to a guardian are lost.

It is not recommended to use _lockToSelf, as removing this lock would be easily added to a malicious workflow, whereas removing a traditional lock from a guardian account would be sufficiently prohibitive.

This repository provides sample implementations for ERC1155/ERC721, which inherit the base OpenZeppelin variants accordingly. It was designed to be used for `setApprovalForAll` and `approve`, but feel free to create your own implementation, and use guardable wherever is needed.