From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH v3 7/7] crypto: AF_ALG - add support for key_id
Date: Tue, 29 Mar 2016 17:57:34 -0700
Message-ID: <20160330005734.25410.28829.stgit@tstruk-mobl1>
References: <20160330005649.25410.70508.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160330005649.25410.70508.stgit@tstruk-mobl1>
Sender: linux-kernel-owner@vger.kernel.org
To: herbert@gondor.apana.org.au
Cc: tadeusz.struk@intel.com, smueller@chronox.de, linux-api@vger.kernel.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, dwmw2@infradead.org, davem@davemloft.net
List-Id: linux-api@vger.kernel.org

This patch adds support for asymmetric key type to AF_ALG.
It will work as follows: A new PF_ALG socket options are
added on top of existing ALG_SET_KEY and ALG_SET_PUBKEY, namely
ALG_SET_KEY_ID and ALG_SET_PUBKEY_ID for setting public and
private keys respectively. When these new options will be used
the user, instead of providing the key material, will provide a
key id and the key itself will be obtained from kernel keyring
subsystem. The user will use the standard tools (keyctl tool
or the keyctl syscall) for key instantiation and to obtain the
key id. The key id can also be obtained by reading the
/proc/keys file.

When a key is found, the request_key() function
returns the requested key. Next the asymmetric key subtype will be
used to obtain the public_key, which can be either a public key
or a private key. The key is then verified using the new
key info public_key_query_sw_key query, to check whether or not the key
can be accessed by software. In case when the key is kept
in hardware (TPM) then the function will return -ENOKEY error code.

If the key can be accesses by software then the key payload
will be passed to the akcipher pf_alg subtype.
AF_ALG code will then call crypto API functions, either the
crypto_akcipher_set_priv_key or the crypto_akcipher_set_pub_key,
depending on the used option. Subsequently the asymmetric key
will be freed and return code returned back to the user.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/af_alg.c             |   50 ++++++++++++++++++++++++++++++++++++++++---
 include/uapi/linux/if_alg.h |    2 ++
 2 files changed, 48 insertions(+), 4 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 24dc082..9d109bc 100644
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
@@ -201,8 +203,40 @@ unlock:
 	return err;
 }
 
+static int alg_setkey_id(void *private, const u8 *key, unsigned int keylen,
+			 int (*setkey)(void *private, const u8 *key,
+				       unsigned int keylen))
+{
+	struct key *keyring;
+	struct public_key *pkey;
+	char key_name[12];
+	u32 keyid = *((u32 *)key);
+	int err;
+
+	sprintf(key_name, "id:%08x", keyid);
+	keyring = request_key(&key_type_asymmetric, key_name, NULL);
+
+	err = -ENOKEY;
+	if (IS_ERR(keyring))
+		goto out;
+
+	pkey = keyring->payload.data[asym_crypto];
+	if (!pkey)
+		goto out_put_key;
+
+	if (!public_key_query_sw_key(pkey))
+		goto out_put_key;
+
+	err = setkey(private, pkey->key, pkey->keylen);
+
+out_put_key:
+	key_put(keyring);
+out:
+	return err;
+}
+
 static int alg_setkey(struct sock *sk, char __user *ukey,
-		      unsigned int keylen,
+		      unsigned int keylen, bool key_id,
 		      int (*setkey)(void *private, const u8 *key,
 				    unsigned int keylen))
 {
@@ -221,7 +255,8 @@ static int alg_setkey(struct sock *sk, char __user *ukey,
 	if (copy_from_user(key, ukey, keylen))
 		goto out;
 
-	err = setkey(ask->private, key, keylen);
+	err = key_id ? alg_setkey_id(ask->private, key, keylen, setkey) :
+		       setkey(ask->private, key, keylen);
 
 out:
 	sock_kzfree_s(sk, key, keylen);
@@ -236,6 +271,8 @@ static int alg_setsockopt(struct socket *sock, int level, int optname,
 	struct alg_sock *ask = alg_sk(sk);
 	const struct af_alg_type *type;
 	int err = -EBUSY;
+	bool key_id = ((optname == ALG_SET_PUBKEY_ID) ||
+		       (optname == ALG_SET_KEY_ID));
 
 	lock_sock(sk);
 	if (ask->refcnt)
@@ -249,16 +286,21 @@ static int alg_setsockopt(struct socket *sock, int level, int optname,
 
 	switch (optname) {
 	case ALG_SET_KEY:
+	case ALG_SET_KEY_ID:
 		if (sock->state == SS_CONNECTED)
 			goto unlock;
+		/* ALG_SET_KEY_ID is only for akcipher */
+		if (!strcmp(type->name, "akcipher") && key_id)
+			goto unlock;
 
-		err = alg_setkey(sk, optval, optlen, type->setkey);
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
