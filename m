From: Eric Biggers <ebiggers@kernel.org>
Subject: [RFC PATCH v3 11/18] fscrypt: add an HKDF-SHA512
 implementation
Date: Tue, 19 Feb 2019 22:52:42 -0800
Message-ID: <20190220065249.32099-12-ebiggers@kernel.org>
References: <20190220065249.32099-1-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20190220065249.32099-1-ebiggers@kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-fscrypt@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, linux-api@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, keyrings@vger.kernel.org, linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org, Satya Tangirala <satyat@google.com>, Paul Crowley <paulcrowley@google.com>
List-Id: linux-api@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add an implementation of HKDF (RFC 5869) to fscrypt, for the purpose of
deriving additional key material from the fscrypt master keys for v2
encryption policies.  HKDF is a key derivation function built on top of
HMAC.  We choose SHA-512 for the underlying unkeyed hash, and use an
"hmac(sha512)" transform allocated from the crypto API.

We'll be using this to replace the AES-ECB based KDF currently used to
derive the per-file encryption keys.  While the AES-ECB based KDF is
believed to meet the original security requirements, it is nonstandard
and has problems that don't exist in modern KDFs such as HKDF:

1. It's reversible.  Given a derived key and nonce, an attacker can
   easily compute the master key.  This is okay if the master key and
   derived keys are equally hard to compromise, but now we'd like to be
   more robust against threats such as a derived key being compromised
   through a timing attack, or a derived key for an in-use file being
   compromised after the master key has already been removed.

2. It doesn't evenly distribute the entropy from the master key; each 16
   input bytes only affects the corresponding 16 output bytes.

3. It isn't easily extensible to deriving other values or keys that are
   or will be needed, such as per-mode keys (which is what DIRECT_KEY
   policies really should use, rather than the master key directly as
   they do now) or a public hash for securely identifying the key (to
   ensure that an encrypted file cannot be set up with the wrong key).

HKDF solves all the above problems.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/Kconfig           |   2 +
 fs/crypto/Makefile          |   1 +
 fs/crypto/fscrypt_private.h |  15 +++
 fs/crypto/hkdf.c            | 188 ++++++++++++++++++++++++++++++++++++
 4 files changed, 206 insertions(+)
 create mode 100644 fs/crypto/hkdf.c

diff --git a/fs/crypto/Kconfig b/fs/crypto/Kconfig
index f0de238000c0..c160598a9fe2 100644
--- a/fs/crypto/Kconfig
+++ b/fs/crypto/Kconfig
@@ -7,6 +7,8 @@ config FS_ENCRYPTION
 	select CRYPTO_XTS
 	select CRYPTO_CTS
 	select CRYPTO_SHA256
+	select CRYPTO_SHA512
+	select CRYPTO_HMAC
 	select KEYS
 	help
 	  Enable encryption of files and directories.  This
diff --git a/fs/crypto/Makefile b/fs/crypto/Makefile
index accdd622c908..4977b4347928 100644
--- a/fs/crypto/Makefile
+++ b/fs/crypto/Makefile
@@ -2,6 +2,7 @@ obj-$(CONFIG_FS_ENCRYPTION)	+= fscrypto.o
 
 fscrypto-y := crypto.o \
 	      fname.o \
+	      hkdf.o \
 	      hooks.o \
 	      keyring.o \
 	      keysetup.o \
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index cc1862c9baa1..e2a65189eb57 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -175,6 +175,21 @@ extern bool fscrypt_fname_encrypted_size(const struct inode *inode,
 					 u32 orig_len, u32 max_len,
 					 u32 *encrypted_len_ret);
 
+/* hkdf.c */
+
+struct fscrypt_hkdf {
+	struct crypto_shash *hmac_tfm;
+};
+
+extern int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
+			     unsigned int master_key_size);
+
+extern int fscrypt_hkdf_expand(struct fscrypt_hkdf *hkdf, u8 context,
+			       const u8 *info, unsigned int infolen,
+			       u8 *okm, unsigned int okmlen);
+
+extern void fscrypt_destroy_hkdf(struct fscrypt_hkdf *hkdf);
+
 /* keyring.c */
 
 /*
diff --git a/fs/crypto/hkdf.c b/fs/crypto/hkdf.c
new file mode 100644
index 000000000000..3f9dbf171d96
--- /dev/null
+++ b/fs/crypto/hkdf.c
@@ -0,0 +1,188 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Implementation of HKDF ("HMAC-based Extract-and-Expand Key Derivation
+ * Function"), aka RFC 5869.  See also the original paper (Krawczyk 2010):
+ * "Cryptographic Extraction and Key Derivation: The HKDF Scheme".
+ *
+ * This is used to derive keys from the fscrypt master keys.
+ *
+ * Copyright 2019 Google LLC
+ */
+
+#include <crypto/hash.h>
+#include <crypto/sha.h>
+
+#include "fscrypt_private.h"
+
+/*
+ * HKDF supports any unkeyed cryptographic hash algorithm, but fscrypt uses
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
+ * 1. HKDF-Extract: extract a pseudorandom key of length HKDF_HASHLEN bytes from
+ *    the input keying material and optional salt.
+ * 2. HKDF-Expand: expand the pseudorandom key into output keying material of
+ *    any length, parameterized by an application-specific info string.
+ *
+ * HKDF-Extract can be skipped if the input is already a pseudorandom key of
+ * length HKDF_HASHLEN bytes.  However, cipher modes other than AES-256-XTS take
+ * shorter keys, and we don't want to force users of those modes to generate
+ * unnecessarily long keys.  Thus fscrypt still does HKDF-Extract.
+ *
+ * HKDF-Extract also supports a salt.  Choosing a random salt per input key
+ * would permit the input key to come from *any* source with sufficient entropy,
+ * even if it's not distributed uniformly.  However, fscrypt doesn't take
+ * advantage of this because userspace should already provide good pseudorandom
+ * keys, which makes this unnecessary; also, having to persist a random salt per
+ * key from kernel mode would pose significant implementation complexity.  Thus
+ * fscrypt uses a fixed salt.  But to be slightly more robust against userspace
+ * (unwisely) reusing the fscrypt keys for another purpose, and to force
+ * brute-force attacks to target the fscrypt KDF specifically, fscrypt uses
+ * "fscrypt_hkdf_salt" rather than the default of all 0's defined by RFC 5869.
+ */
+
+#define HKDF_SALT		"fscrypt_hkdf_salt"
+#define HKDF_SALTLEN		CONST_STRLEN(HKDF_SALT)
+
+/* HKDF-Extract (RFC 5869 section 2.2), see explanation above */
+static int hkdf_extract(struct crypto_shash *hmac_tfm, const u8 *ikm,
+			unsigned int ikmlen, u8 prk[HKDF_HASHLEN])
+{
+	SHASH_DESC_ON_STACK(desc, hmac_tfm);
+	int err;
+
+	err = crypto_shash_setkey(hmac_tfm, HKDF_SALT, HKDF_SALTLEN);
+	if (err)
+		return err;
+
+	desc->tfm = hmac_tfm;
+	desc->flags = 0;
+	err = crypto_shash_digest(desc, ikm, ikmlen, prk);
+	shash_desc_zero(desc);
+	return err;
+}
+
+/*
+ * Compute HKDF-Extract using the given master key as the input keying material,
+ * and prepare an HMAC transform object keyed by the resulting pseudorandom key.
+ *
+ * Afterwards, the keyed HMAC transform object can be used for HKDF-Expand many
+ * times without having to recompute HKDF-Extract each time.
+ */
+int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
+		      unsigned int master_key_size)
+{
+	struct crypto_shash *hmac_tfm;
+	u8 prk[HKDF_HASHLEN];
+	int err;
+
+	hmac_tfm = crypto_alloc_shash(HKDF_HMAC_ALG, 0, 0);
+	if (IS_ERR(hmac_tfm)) {
+		fscrypt_warn(NULL, "error allocating " HKDF_HMAC_ALG ": %ld",
+			     PTR_ERR(hmac_tfm));
+		return PTR_ERR(hmac_tfm);
+	}
+
+	BUG_ON(crypto_shash_digestsize(hmac_tfm) != sizeof(prk));
+
+	err = hkdf_extract(hmac_tfm, master_key, master_key_size, prk);
+	if (err)
+		goto err_free_tfm;
+
+	err = crypto_shash_setkey(hmac_tfm, prk, sizeof(prk));
+	if (err)
+		goto err_free_tfm;
+
+	hkdf->hmac_tfm = hmac_tfm;
+	goto out;
+
+err_free_tfm:
+	crypto_free_shash(hmac_tfm);
+out:
+	memzero_explicit(prk, sizeof(prk));
+	return err;
+}
+
+/*
+ * HKDF-Expand (RFC 5869 section 2.3).  This expands the pseudorandom key, which
+ * was already keyed into 'hkdf->hmac_tfm' by fscrypt_init_hkdf(), into 'okmlen'
+ * bytes of output keying material parameterized by the application-specific
+ * 'info' of length 'infolen' bytes, prefixed with the 'context' byte.  This is
+ * thread-safe and may be called by multiple threads in parallel.
+ *
+ * ('context' isn't part of the HKDF specification; it's just a prefix fscrypt
+ * adds to its application-specific info strings to guarantee that it doesn't
+ * accidentally repeat an info string when using HKDF for different purposes.)
+ */
+int fscrypt_hkdf_expand(struct fscrypt_hkdf *hkdf, u8 context,
+			const u8 *info, unsigned int infolen,
+			u8 *okm, unsigned int okmlen)
+{
+	SHASH_DESC_ON_STACK(desc, hkdf->hmac_tfm);
+	unsigned int i;
+	int err;
+	const u8 *prev = NULL;
+	u8 counter = 1;
+	u8 tmp[HKDF_HASHLEN];
+
+	if (WARN_ON(okmlen > 255 * HKDF_HASHLEN))
+		return -EINVAL;
+
+	desc->tfm = hkdf->hmac_tfm;
+	desc->flags = 0;
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
+		BUILD_BUG_ON(sizeof(context) != 1);
+		err = crypto_shash_update(desc, &context, 1);
+		if (err)
+			goto out;
+
+		err = crypto_shash_update(desc, info, infolen);
+		if (err)
+			goto out;
+
+		BUILD_BUG_ON(sizeof(counter) != 1);
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
+	if (unlikely(err))
+		memzero_explicit(okm, okmlen); /* so caller doesn't need to */
+	shash_desc_zero(desc);
+	return err;
+}
+
+void fscrypt_destroy_hkdf(struct fscrypt_hkdf *hkdf)
+{
+	crypto_free_shash(hkdf->hmac_tfm);
+}
-- 
2.20.1
