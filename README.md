# MediaToken 

## Transparent hyper-linkable and tokenized multimedia

MediaToken is a Solidity toolkit that allows one to tokenize, track, and 
represent IPFS-based media. It predates ERC-721, has full compatibility 
with any ERC-20 based wallet, and was adopted by multiple projects. 
Formal standardization is coming soon, as well as full API 
documentation. 

## Core concepts 

The 'Token Factory' aka Gallery contract serves as an enumerable, 
evented repo of all tokens that were minted in that particular instance, 
enabling all related media to easily be searchable and located. Each 
individual MediaToken contract created by a Gallery has reference to 
both an IPFS-addressed hash of the content, as well as a description and 
expected media type (in an Enumeration). When used properly, this 
enables any client to know in advance the expected file type, and thus 
the clients can pre-load and properly display the media. 

## Future updates 

A tagging contract to allow token owners to link related tokens, making 
the media transversible and allowing the issuance of sub-assets. 

Hub and spoke namespacing. Like ENS, this will allow each gallery to 
have a native token that is used for bonding and curation, allowing a 
participant to stake that their upload is not malicious content, and 
allowing a community of participant voters to claim the utility token 
that is native to that Gallery when making reports. The hub and spoke 
model will allow Gallery holders the ablilty to group related content, 
e.g. 'Memes' or 'Music', and allow other interested Galleries to peer, 
forming a full DAG of interesting and rich media content. Peer connects 
can be toll-based (where a fee to connect is paid to a gallery owner, 
either in ETH or a native ERC-20) or completely free, enabling open 
content networks, and mirroring the peering agreements of the Internet. 

(c) 2017-2019 MediaTokens. All code open-source
