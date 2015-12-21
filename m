From: Tadeusz Struk <tstruk@gmail.com>
Subject: [PATCH] crypto: AF_ALG - add support for keys/asymmetric-type
Date: Mon, 21 Dec 2015 12:51:07 -0800
Message-ID: <20151221205107.28935.59696.stgit@desktop.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: herbert@gondor.apana.org.au
Cc: tadeusz.struk@intel.com, smueller@chronox.de, dwmw2@infradead.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, linux-api@vger.kernel.org, tstruk@gmail.com, zohar@linux.vnet.ibm.com
List-Id: linux-api@vger.kernel.org

From: Tadeusz Struk <tadeusz.struk@intel.com>

Created on top of patchset from Stephan Mueller <smueller@chronox.de>
https://patchwork.kernel.org/patch/7877921/
https://patchwork.kernel.org/patch/7877971/
https://patchwork.kernel.org/patch/7877961/

This patch adds support for asymmetric key type to AF_ALG.
It will work as follows: A new PF_ALG socket options will be
added on top of existing ALG_SET_KEY and ALG_SET_PUBKEY, namely
ALG_SET_PUBKEY_ID and ALG_SET_KEY_ID for setting public and
private keys respectively. When these new options will be used
the user instead of providing the key material, will provide a
key id and the key itself will be obtained from kernel keyring
subsystem. The user will use the standard tools (keyctl tool
or the keyctl syscall) for key instantiation and to obtain the
key id. The key id can also be obtained by reading the
/proc/keys file.

When a key will be found, the request_key() function will
return a requested key. Next the asymmetric key subtype will be
used to obtain the public_key, which can be either a public key
or a private key from the cryptographic point of view, and the
key payload will be passed to the akcipher pf_alg subtype.
Pf_alg code will then call crypto API functions, either the
crypto_akcipher_set_priv_key or the crypto_akcipher_set_pub_key,
depending on the used option. Subsequently the asymmetric key
will be freed and return code returned back to the user.

Currently the interface will be restricted only to asymmetric
ciphers, but it can be extended later to work with symmetric
ciphers if required.

The assumption is that access rights for a given user will be
verified by the key subsystem so the pf_alg interface can call
the request_key() without checking if the user has appropriate
rights (Please verify this assumption).

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/af_alg.c             |   41 +++++++++++++++++++++++++++++++++++++----
 include/uapi/linux/if_alg.h |    2 ++
 2 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 767a134..d2ec357 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -22,6 +22,8 @@
 #include <linux/net.h>
 #include <linux/rwsem.h>
 #include <linux/security.h>
+#include <crypto/public_key.h>
+#include <keys/asymmetric-type.h>
 
 struct alg_type_list {
 	const struct af_alg_type *type;
@@ -173,7 +175,7 @@ static int alg_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 }
 
 static int alg_setkey(struct sock *sk, char __user *ukey,
-		      unsigned int keylen,
+		      unsigned int keylen, bool key_id,
 		      int (*setkey)(void *private, const u8 *key,
 				    unsigned int keylen))
 {
@@ -192,7 +194,30 @@ static int alg_setkey(struct sock *sk, char __user *ukey,
 	if (copy_from_user(key, ukey, keylen))
 		goto out;
 
-	err = setkey(ask->private, key, keylen);
+	if (key_id) {
+		struct key *keyring;
+		struct public_key *pkey;
+		char key_name[12];
+		u32 keyid = *((u32 *)key);
+
+		sprintf(key_name, "id:%08x", keyid);
+		keyring = request_key(&key_type_asymmetric, key_name, NULL);
+
+		err = -ENOKEY;
+		if (IS_ERR(keyring))
+			goto out;
+
+		pkey = keyring->payload.data[asym_crypto];
+		if (!pkey) {
+			key_put(keyring);
+			goto out;
+		}
+
+		err = setkey(ask->private, pkey->key, pkey->keylen);
+		key_put(keyring);
+	} else {
+		err = setkey(ask->private, key, keylen);
+	}
 
 out:
 	sock_kzfree_s(sk, key, keylen);
@@ -207,6 +232,8 @@ static int alg_setsockopt(struct socket *sock, int level, int optname,
 	struct alg_sock *ask = alg_sk(sk);
 	const struct af_alg_type *type;
 	int err = -ENOPROTOOPT;
+	bool key_id = ((optname == ALG_SET_PUBKEY_ID) ||
+		       (optname == ALG_SET_KEY_ID));
 
 	lock_sock(sk);
 	type = ask->type;
@@ -216,16 +243,22 @@ static int alg_setsockopt(struct socket *sock, int level, int optname,
 
 	switch (optname) {
 	case ALG_SET_KEY:
+	case ALG_SET_KEY_ID:
 		if (sock->state == SS_CONNECTED)
 			goto unlock;
 
-		err = alg_setkey(sk, optval, optlen, type->setkey);
+		/* ALG_SET_KEY_ID is only for akcipher */
+		if (!strcmp(type->name, "akcipher") && key_id)
+			goto unlock;
+
+		err = alg_setkey(sk, optval, optlen, key_id, type->setkey);
 		break;
 	case ALG_SET_PUBKEY:
+	case ALG_SET_PUBKEY_ID:
 		if (sock->state == SS_CONNECTED)
 			goto unlock;
 
-		err = alg_setkey(sk, optval, optlen, type->setpubkey);
+		err = alg_setkey(sk, optval, optlen, key_id, type->setpubkey);
 		break;
 	case ALG_SET_AEAD_AUTHSIZE:
 		if (sock->state == SS_CONNECTED)
diff --git a/include/uapi/linux/if_alg.h b/include/uapi/linux/if_alg.h
index 02e6162..0379766 100644
--- a/include/uapi/linux/if_alg.h
+++ b/include/uapi/linux/if_alg.h
@@ -35,6 +35,8 @@ struct af_alg_iv {
 #define ALG_SET_AEAD_ASSOCLEN		4
 #define ALG_SET_AEAD_AUTHSIZE		5
 #define ALG_SET_PUBKEY			6
+#define ALG_SET_PUBKEY_ID		7
+#define ALG_SET_KEY_ID			8
 
 /* Operations */
 #define ALG_OP_DECRYPT			0
