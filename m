From: Eric Biggers <ebiggers3@gmail.com>
Subject: [RFC PATCH 17/25] fscrypt: add an HKDF-SHA512
 implementation
Date: Mon, 23 Oct 2017 14:40:50 -0700
Message-ID: <20171023214058.128121-18-ebiggers3@gmail.com>
References: <20171023214058.128121-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20171023214058.128121-1-ebiggers3@gmail.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-fscrypt@vger.kernel.org
Cc: Ryo Hashimoto <hashimoto@chromium.org>, Gwendal Grignou <gwendal@chromium.org>, "Theodore Y . Ts'o" <tytso@mit.edu>, Eric Biggers <ebiggers@google.com>, linux-api@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>, linux-f2fs-devel@lists.sourceforge.net, keyrings@vger.kernel.org, linux-mtd@lists.infradead.org, Michael Halcrow <mhalcrow@google.com>, Sarthak Kukreti <sarthakkukreti@chromium.org>, linux-fsdevel@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

For v2 encryption policies, we need to hash the master key to compute a
master_key_identifier.  Naively, we could just use a truncated SHA-512
or another common cryptographic hash function.  However, that would
cause the same key material to be used in two different ways: both as
input to the hash function, and as input to the AES-ECB-based KDF when
deriving the per-inode encryption keys.  There *probably* isn't any
practical attack on that, but still it would be better "crypto hygiene"
to use the key material for one purpose only, e.g. just for a KDF.

It also happens that the AES-based KDF is on our list of things to fix.
While it does generate unique derived keys with sufficient entropy, it
is nonstandard and has some problems that don't exist in standard KDFs
such as HKDF.  For example, the AES-based KDF is reversible: given a
derived key and nonce, an attacker can easily compute the master key.
This was maybe okay for the original threat model of ext4 encryption
where the master key and derived keys were considered equally hard to
compromise.  But now we would like to be more robust against threats
such as a derived key being compromised through a timing attack, or a
derived key for an in-use file being compromised after the master key
has already been wiped from memory via FS_IOC_REMOVE_ENCRYPTION_KEY.

HKDF also has other advantages over the AES-ECB-based KDF such as evenly
distributing the entropy from the input key material and being more
extensible to deriving other key material that may be needed.

Since we're introducing a new encryption policy version that already
includes an on-disk format change, and we also now have a good place to
cache an HMAC transform for each master key (struct fscrypt_master_key)
so that HKDF can be implemented efficiently, we finally have a chance to
switch to HKDF to derive the per-file keys.

In addition, we'll use HKDF to derive the master_key_identifier,
avoiding the need for a separate cryptographic hash primitive.  This is
secure because the output from HKDF is cryptographically isolated, i.e.
sending some output in the clear doesn't reveal any other output, in a
computational sense.  (This is assuming that application-specific info
strings aren't repeated between different uses of HKDF, but we'll use
context bytes to ensure that.)

Thus, this patch adds an implementation of HKDF to keyinfo.c, using an
HMAC transform allocated from the crypto API.  Later patches will make
use of it.

Note that using HKDF-SHA512 as the key derivation function will
introduce a dependency on the security and implementation of SHA-512,
whereas before we were using only AES for both key derivation and
encryption.  However, by using HMAC rather than the hash function
directly, HKDF is designed to remain secure even if various classes of
attacks, e.g. collision attacks, are found against the underlying
unkeyed hash function.  Even HMAC-MD5 is still considered secure in
practice, despite MD5 itself having been heavily compromised.  And
meanwhile, the AES-based KDF used the public nonce as the cipher *key*,
which is an unusual case which probably hasn't undergone much
cryptanalysis.  HKDF-SHA512 seems like a safer bet.

We *could* actually avoid introducing a hash primitive by instantiating
HKDF-Expand with CMAC-AES256 as the pseudorandom function rather than
HMAC-SHA512.  That would work; however, the HKDF specification doesn't
explicitly allow a non-HMAC pseudorandom function, so it would be less
standard.  It would also require skipping HKDF-Extract and making the
API accept only 32-byte master keys, since otherwise HKDF-Extract using
CMAC-AES would produce a pseudorandom key only 16 bytes long which would
only be enough for AES-128, not AES-256.

References:

   - RFC 5869. "HMAC-based Extract-and-Expand Key Derivation Function
     (HKDF)".  https://tools.ietf.org/html/rfc5869

   - Krawczyk (2010). "Cryptographic Extraction and Key Derivation: The
     HKDF Scheme".  https://eprint.iacr.org/2010/264.pdf

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/Kconfig   |   2 +
 fs/crypto/keyinfo.c | 180 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 181 insertions(+), 1 deletion(-)

diff --git a/fs/crypto/Kconfig b/fs/crypto/Kconfig
index 02b7d91c9231..bbd4e38b293c 100644
--- a/fs/crypto/Kconfig
+++ b/fs/crypto/Kconfig
@@ -8,6 +8,8 @@ config FS_ENCRYPTION
 	select CRYPTO_CTS
 	select CRYPTO_CTR
 	select CRYPTO_SHA256
+	select CRYPTO_SHA512
+	select CRYPTO_HMAC
 	select KEYS
 	help
 	  Enable encryption of files and directories.  This
diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
index 937a678ebba1..e9de625ddfe4 100644
--- a/fs/crypto/keyinfo.c
+++ b/fs/crypto/keyinfo.c
@@ -6,6 +6,11 @@
  * This contains encryption key functions.
  *
  * Written by Michael Halcrow, Ildar Muslukhov, and Uday Savagaonkar, 2015.
+ *
+ * HKDF support and key add/remove API added by Eric Biggers, 2017.
+ *
+ * The implementation and usage of HKDF should conform to RFC-5869 ("HMAC-based
+ * Extract-and-Expand Key Derivation Function").
  */
 
 #include <keys/user-type.h>
@@ -14,10 +19,181 @@
 #include <linux/scatterlist.h>
 #include <linux/seq_file.h>
 #include <crypto/aes.h>
+#include <crypto/hash.h>
 #include <crypto/sha.h>
 #include "fscrypt_private.h"
 
-static struct crypto_shash *essiv_hash_tfm;
+/*
+ * Any unkeyed cryptographic hash algorithm can be used with HKDF, but we use
+ * SHA-512 because it is reasonably secure and efficient; and since it produces
+ * a 64-byte digest, deriving an AES-256-XTS key preserves all 64 bytes of
+ * entropy from the master key and requires only one iteration of HKDF-Expand.
+ */
+#define HKDF_HMAC_ALG		"hmac(sha512)"
+#define HKDF_HASHLEN		SHA512_DIGEST_SIZE
+
+/*
+ * HKDF consists of two steps:
+ *
+ * 1. HKDF-Extract: extract a fixed-length pseudorandom key from the
+ *    input keying material and optional salt.
+ * 2. HKDF-Expand: expand the pseudorandom key into output keying material of
+ *    any length, parameterized by an application-specific info string.
+ *
+ * HKDF-Extract can be skipped if the input is already a good pseudorandom key
+ * that is at least as long as the hash.  While the fscrypt master keys should
+ * already be good pseudorandom keys, when using encryption algorithms that use
+ * short keys (e.g. AES-128-CBC) we'd like to permit the master key to be
+ * shorter than HKDF_HASHLEN bytes.  Thus, we still must do HKDF-Extract.
+ *
+ * Ideally, HKDF-Extract would be passed a random salt for each distinct input
+ * key.  Details about the advantages of a random salt can be found in the HKDF
+ * paper (Krawczyk, 2010; "Cryptographic Extraction and Key Derivation: The HKDF
+ * Scheme").  However, we do not have the ability to store a salt on a
+ * per-master-key basis.  Thus, we have to use a fixed salt.  This is sufficient
+ * as long as the master keys are already pseudorandom and are long enough to
+ * make dictionary attacks infeasible.  This should be the case if userspace
+ * used a cryptographically secure random number generator, e.g. /dev/urandom,
+ * to generate the master keys and it was initialized with sufficient entropy.
+ *
+ * For the fixed salt we use "fscrypt_hkdf_salt" rather than default of all 0's
+ * defined by RFC-5869.  This is only to be slightly more robust against
+ * userspace (unwisely) reusing the master keys for different purposes.
+ * Logically, it's more likely that the keys would be passed to unsalted
+ * HKDF-SHA512 than specifically to "fscrypt_hkdf_salt"-salted HKDF-SHA512.
+ * Of course, a random salt would be better for this purpose.
+ */
+
+#define HKDF_SALT		"fscrypt_hkdf_salt"
+#define HKDF_SALT_LEN		(sizeof(HKDF_SALT) - 1)
+
+/*
+ * HKDF-Extract (RFC-5869 section 2.2).  This extracts a pseudorandom key 'prk'
+ * from the input key material 'ikm' and a salt.  See explanation above for why
+ * we use a fixed salt.
+ */
+static int hkdf_extract(struct crypto_shash *hmac_tfm,
+			const u8 *ikm, unsigned int ikmlen,
+			u8 prk[HKDF_HASHLEN])
+{
+	SHASH_DESC_ON_STACK(desc, hmac_tfm);
+	int err;
+
+	desc->tfm = hmac_tfm;
+	desc->flags = 0;
+
+	err = crypto_shash_setkey(hmac_tfm, HKDF_SALT, HKDF_SALT_LEN);
+	if (err)
+		goto out;
+
+	err = crypto_shash_digest(desc, ikm, ikmlen, prk);
+out:
+	shash_desc_zero(desc);
+	return err;
+}
+
+/*
+ * HKDF-Expand (RFC-5869 section 2.3).  This expands the pseudorandom key, which
+ * has already been keyed into 'hmac_tfm', into 'okmlen' bytes of output keying
+ * material, parameterized by the application-specific information string of
+ * 'info' prefixed with the 'context' byte.  ('context' isn't part of the HKDF
+ * specification; it's just a prefix we add to our application-specific info
+ * strings to guarantee that we don't accidentally repeat an info string when
+ * using HKDF for different purposes.)
+ */
+static int hkdf_expand(struct crypto_shash *hmac_tfm, u8 context,
+		       const u8 *info, unsigned int infolen,
+		       u8 *okm, unsigned int okmlen)
+{
+	SHASH_DESC_ON_STACK(desc, hmac_tfm);
+	int err;
+	const u8 *prev = NULL;
+	unsigned int i;
+	u8 counter = 1;
+	u8 tmp[HKDF_HASHLEN];
+
+	desc->tfm = hmac_tfm;
+	desc->flags = 0;
+
+	if (unlikely(okmlen > 255 * HKDF_HASHLEN))
+		return -EINVAL;
+
+	for (i = 0; i < okmlen; i += HKDF_HASHLEN) {
+
+		err = crypto_shash_init(desc);
+		if (err)
+			goto out;
+
+		if (prev) {
+			err = crypto_shash_update(desc, prev, HKDF_HASHLEN);
+			if (err)
+				goto out;
+		}
+
+		err = crypto_shash_update(desc, &context, 1);
+		if (err)
+			goto out;
+
+		err = crypto_shash_update(desc, info, infolen);
+		if (err)
+			goto out;
+
+		if (okmlen - i < HKDF_HASHLEN) {
+			err = crypto_shash_finup(desc, &counter, 1, tmp);
+			if (err)
+				goto out;
+			memcpy(&okm[i], tmp, okmlen - i);
+			memzero_explicit(tmp, sizeof(tmp));
+		} else {
+			err = crypto_shash_finup(desc, &counter, 1, &okm[i]);
+			if (err)
+				goto out;
+		}
+		counter++;
+		prev = &okm[i];
+	}
+	err = 0;
+out:
+	shash_desc_zero(desc);
+	return err;
+}
+
+/*
+ * Precompute HKDF-Extract using the master key as the input key material, then
+ * return an HMAC transform that is keyed using the resulting pseudorandom key.
+ * This can be used to derive further key material using HKDF-Expand.
+ */
+static struct crypto_shash *allocate_hmac_tfm(const u8 *master_key, u32 size)
+{
+	struct crypto_shash *hmac_tfm;
+	u8 prk[HKDF_HASHLEN];
+	int err;
+
+	hmac_tfm = crypto_alloc_shash(HKDF_HMAC_ALG, 0, 0);
+	if (IS_ERR(hmac_tfm)) {
+		pr_warn("fscrypt: error allocating " HKDF_HMAC_ALG ": %ld\n",
+			PTR_ERR(hmac_tfm));
+		goto out;
+	}
+
+	BUG_ON(crypto_shash_digestsize(hmac_tfm) != sizeof(prk));
+
+	err = hkdf_extract(hmac_tfm, master_key, size, prk);
+	if (err)
+		goto fail;
+
+	err = crypto_shash_setkey(hmac_tfm, prk, sizeof(prk));
+	if (err)
+		goto fail;
+out:
+	memzero_explicit(prk, sizeof(prk));
+	return hmac_tfm;
+
+fail:
+	crypto_free_shash(hmac_tfm);
+	hmac_tfm = ERR_PTR(err);
+	goto out;
+}
 
 /*
  * fscrypt_master_key_secret - secret key material of an in-use master key
@@ -914,6 +1090,8 @@ static void put_crypt_info(struct fscrypt_info *ci)
 	kmem_cache_free(fscrypt_info_cachep, ci);
 }
 
+static struct crypto_shash *essiv_hash_tfm;
+
 static int derive_essiv_salt(const u8 *key, int keysize, u8 *salt)
 {
 	struct crypto_shash *tfm = READ_ONCE(essiv_hash_tfm);
-- 
2.15.0.rc0.271.g36b669edcc-goog


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
