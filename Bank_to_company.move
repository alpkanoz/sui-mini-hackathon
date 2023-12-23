module banktocomp::messenger{
    
    use std::string::{Self, String};
    use sui::object::{Self,UID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    use sui::signing;
    use sui::encryption;

    struct BankIdentity {
        public_key: vector<u8>,
        private_key: vector<u8>,
}
    struct CompID {
        public_key: vector<u8>,
        private_key: vector<u8>,
        id: UID,
        name: String,

    }

    struct Message {
        content: vector<u8>,
        encrypted_content: vector<u8>,
        signature: vector<u8>,
        from: address,
        to: address,
}

    fun init(ctx: &mut TxContext){
        transfer::transfer(BankIdentity {id: object::new(ctx)}, tx_context::sender(ctx));
    }

    public entry fun create_messenger(_:&BankIdentity,name: vector<u8>, message:vector<u8>,to:address, from:address, ctx: &mut TxContext) {        
        let messenger = Message {
            id: object::new(ctx),
            encrypted_content: encryption::encrypt(message, sui_token_public_key)
            name: string::utf8(name),
            signature: signing::sign(Message {
                content: encrypted_content,
                sender: bank_identity,
            }),
        };
        };
        transfer::transfer(messenger,to);
    



    #[test_only]
    // Not public by default
    public fun init_for_testing(ctx: &mut TxContext){
        init(ctx);
    }
}