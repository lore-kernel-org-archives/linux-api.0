Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.156.91
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795011122;
	b=FKyMMr/lGtBRx9rPHTXeU28nsTQWc3KfNQkCv0/PRoq6m81V5avor3FuWXlVpNzWNGP8
	 B9QHW5SkDbju+xpEsI7Y2m/xuykRFC+koMWpdKR1/hY+Km4SmuNd1HR/DZcpnDX6oFA1r
	 KeStPGRkS+eRXCD/6TM3URSnGP8uqBNTw+BNvMTACAJNXtsUL7K+h6siMrkn4YF5ev1tA
	 xWhVWsTf6hPifllwdlEcfCxANfdmjerIz+zhn81lRFJTKPzv1opQLWkUACkrj30gAY7OU
	 XVsuOTwwPRN1tNVgNoGEHyNDt6x78zXSeYK8XumxNBncrUTBxDh0gViJffIaBRdYLAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795011122;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CMAE-Envelope;
	bh=D/WVgy27CxRvzITypzhrotqlE4cGsxqI2QSk6YgZzmA=;
	b=0JZeEDBf9pWbwjflYe3fUoLBn+OaZbdtA1sVZnDBvwXrSw7o4NljcEZQV90fZ0aNBMOr
	 lyPFvxL2RmfSOJgPRpQZogAMYKSVPGkmV8quVncMVGhXrT5XoAfkMF8Q+zP+fEqo723CP
	 35ItVlNHPUU2EAmxv+7rLSndYzR8peDUB53KKBYF0+tu5OCD7Ts5m7U5aH5E0G3xKZfch
	 daX/QMze7HQj27BNosOyLI+ieycOtjdWheDPguvWWk0fP24/89E1RwMWZjwV060wwEe5t
	 x7ugjiLsViEoEVVrXFOx7XfaugqQCqHHMnhBO5gLCsggk4dy8pAMp8VgPDkqIhw6C7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=enneenne.com;
	spf=pass smtp.mailfrom=enneenne.com;
	dkim=pass header.d=aruba.it header.i=@aruba.it header.a=rsa-sha256 header.s=a1 header.b=DC2O1z8R;
	arc=none smtp.remote-ip=62.149.156.91
Received: from smtpcmd0991.aruba.it (smtpcmd0991.aruba.it [62.149.156.91])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E1660A2619
	for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 14:11:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 58E1660A2619
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=enneenne.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=enneenne.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.a=rsa-sha256 header.s=a1 header.b=DC2O1z8R
Received: from polimar.tail4f75e6.ts.net ([101.57.122.26])
	by Aruba SMTP with ESMTPSA
	id TgOCxLR9Q6q8sTgOCxcAD5; Wed, 18 Nov 2026 15:11:57 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1795011117; bh=wnkC3412nZ3n+qios3UhyIUa/arX2U6GfVNaawJ8UWs=;
	h=From:To:Subject:Date:MIME-Version;
	b=DC2O1z8RjsA01B4Xqo3iZDBdzZTaLpB3PTK/wyxG7rhM7w5kpwv8iM5ts2f33P67a
	 hq+qf38O/+vXkGLq/GZFkD4cHYqeiqZcU5M2VYQoUanIH8rK3el0xNl4l00XzwuYPA
	 YLDUywpOcJIRjNNP9ymej9Fup/nrZwUZKd83xGvKhcS/YYIyW4R7lrd52roMxDHo+C
	 9vEjdj3ykae8iOuY3GNSPezSDVudbS062lapQX95lGk9FppblcRNn2upzLRmySyokd
	 YsU+l0GaH0CGR6pl94Le8/zs6+NFemwEyn3gAMNcSlGcJFPcluFkNP9a87WPafx5lG
	 IUeCznOhB7Kzw==
From: Rodolfo Giometti <giometti@enneenne.com>
To: David Howells <dhowells@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	keyrings@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Jens Wiklander <jenswi@kernel.org>,
	Sumit Garg <sumit.garg@kernel.org>,
	op-tee@lists.trustedfirmware.org,
	=?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Sahil Malhotra <sahil.malhotra@nxp.com>,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Richard Weinberger <richard@nod.at>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-crypto@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Rodolfo Giometti <giometti@enneenne.com>
Subject: [RFC PATCH 8/9] KEYS: keycrypt: Add the CAAM backend
Date: Wed, 18 Nov 2026 15:11:53 +0100
Message-ID: <20261118141153.621958-1-giometti@enneenne.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261118140421.584086-1-giometti@enneenne.com>
References: <20261118140421.584086-1-giometti@enneenne.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfPE9fFmOmNqBA0vaMOZqgnpmcISfQWZU338x+RzPsOD6u68jpHQmovagmswdhJVPsHklUiUBdq0MBaimVgg9v3cnALbW46NGERtxF3XgR1RHJD1F6aYz
 GjtBzVaZTVCJIyO+m/92QjwLI26f36UIcY3DxJzrNnhzWkUgXrrD3oyLM/ZK7S2CluAoHJN42J4qI9JgsQVWkswFU+FftiSH9W3RFVZaTEJWGt4GiGo0fC/J
 5H7cVXVIXMwrm0eqPFDpt0WHVy0/nhN1uijHLsUuujwA0UuQ8FXvAnYT0K6lHx2iIQV89w7riXPq82YqLAK+A/tR/tStPftTgt1d2APQYu/GFWbdJByoqxqW
 IwbvW/ReHaC7ZB7nnIev+jqmbWlZFt8bHLyp+i9yyb2Pz/v/O5QpojCWb7bhUURCY0/0CdI9di0Y9AWDeXLUSc4xnR3PKEh37T+9mLEdLDc2XjQFEgNbwkX/
 ky4LxGkox4B14VBd3xRA/YSbzfEyKB8Eu6JX8CkB0m4e58YkIrX9RMNnG+5/LooMjh3++dRMixHl8NnUWfaYnXp2OrZQ2phDlJUGm6uDt6Oc7gjRb/sHKM8V
 lVsEC3R4QGFA1vclkHP9RhW2hNdWnWC5foY/Uw1+f+UhJzIouGQmsBfGx8tvQr8CiBito8dYCSHa5XkPsfQE2og6dLS6YT+12961LJhNZAkUGBgJnDkNU/2k
 MSR7n4miShIs3eYJu/LKoiaxsuXTOapu08OP55sC45Ea3hX4H0J7XUxMwBFgHQDJrUsUxkwS7NzMb/oaI3h5PAeaXNey5I+d8Ns3fmHiEIYuuyKpVxIEeYPf
 xxc/ZVaGGSqIR9WIUB+zHpuZxyvGxUDIyEYp7d7zMRHd8+xtdUvz/+cok4qQqyn+sBtiMabb1c6T+G7yAhvL/yU931CkSqwfXnkTeHUJBudy2jT8sG/6kJqv
 umboc7Zl2AU8nua91IXvMQ87Kf/Hp5jHLKy7HvJGPQ9ZVxN3Bk/SEAsvbSuAjJXAIKqkKBaO9Hs2E9fv9VIycYxZHQn+5F8iRrE0rhwTcjbjhL5tSDs163FV
 K7isQhyL5s6yRizaLjf4Vyk+i6b56wdlUDWPBdiFt3OUVUAXv+BYPBGSEJwR6tPlnICoL2Z5nIDu46xaPDxOO9IhCSOuBSv+EQ0JBRDwpKx+fGPkFb3qCJ56
 VC0mWVi7toGNq8dBAIK7et/KazRLeQYvQMRM0dKvM24geV+ff1HN22c8BZaomshHfp1EO8xlG6jzzIN/M4a1qi29PnxCj+bawZHaReSrUV7ByjazVYS/X+7A
 gm7pAVCruJmW1rJvzCoieb92KwPIxhzu+1L2RIpr7xxdWwcR65k=

Add "caam", a backend of the engine tier for NXP SoCs with a CAAM:
once sealed, its keys exist outside the CAAM only as black blobs and
black keys, used through the CAAM's internal cbc(paes); a new key is
drawn in kernel memory and sealed at once. Each blob is encapsulated
with a key modifier derived from the blob's header, so a blob whose
metadata was changed does not open, and the blobs of the public
cbc(paes) and of trusted "pk" keys, made with another key modifier, do
not load.

This is a proposal for owners of CAAM hardware to try, not to be
applied as is: it has not been run on hardware, and the CAAM does not
check what a key is used for, which is why its tier is engine. Only
aes256-cbc is offered, with ECB-encrypted black keys, since the
driver's cbc(paes), with Richard Weinberger's paes fixes, refuses
CCM ones.

With it comes its section of the documentation.

Signed-off-by: Rodolfo Giometti <giometti@enneenne.com>
---
 Documentation/security/keys/keycrypt.rst |  97 ++++++-
 security/keys/keycrypt/Kconfig           |  27 ++
 security/keys/keycrypt/Makefile          |   2 +
 security/keys/keycrypt/caam.c            | 346 +++++++++++++++++++++++
 security/keys/keycrypt/caam.h            |  30 ++
 5 files changed, 491 insertions(+), 11 deletions(-)
 create mode 100644 security/keys/keycrypt/caam.c
 create mode 100644 security/keys/keycrypt/caam.h

diff --git a/Documentation/security/keys/keycrypt.rst b/Documentation/security/keys/keycrypt.rst
index ac393a0bc97d..e2ee5f75d9f4 100644
--- a/Documentation/security/keys/keycrypt.rst
+++ b/Documentation/security/keys/keycrypt.rst
@@ -43,18 +43,21 @@ tier, such as the CAAM's protected keys, are used by the kernel, which
 cannot read them once sealed.
 
 The backends of this document: ``sw``, of tier ``kernel``, where the
-kernel's own software uses the key (`The sw backend`_); and ``optee``,
-of tier ``tee`` (`The OP-TEE backend`_).
+kernel's own software uses the key (`The sw backend`_); ``optee``,
+of tier ``tee`` (`The OP-TEE backend`_); and ``caam``, of tier
+``engine``, ``hsm`` only if the CAAM enforced a key's use
+(`The CAAM backend`_).
 
 Every backend, whatever its tier, must seal with a secret that is secret
-and unique to the device: the trusted key the sw backend derives from
-or OP-TEE's hardware unique key. Were that secret known, the blob, which
-user space reads, would be the key itself; were it shared by several
-devices, a blob copied from one would load on another, and its key would
-be used there. Every tier presumes it, and keycrypt cannot check it, nor
-that the hardware is configured so that the secret is secret (an OP-TEE
-whose hardware unique key is provisioned, not OP-TEE's test value):
-whoever builds in or loads a backend for a device declares
+and unique to the device: the trusted key the sw backend derives from,
+OP-TEE's hardware unique key, the CAAM's master key. Were that secret
+known, the blob, which user space reads, would be the key itself; were
+it shared by several devices, a blob copied from one would load on
+another, and its key would be used there. Every tier presumes it, and
+keycrypt cannot check it, nor that the hardware is configured so that
+the secret is secret (a CAAM with secure boot enabled, an OP-TEE whose
+hardware unique key is provisioned; not a CAAM test key, nor OP-TEE's
+test value): whoever builds in or loads a backend for a device declares
 that the device meets it, as a backend declares its tier. For the
 sw backend the secret is the trusted master each key names with
 ``master=``, so there the requirement falls on whoever creates that
@@ -417,6 +420,76 @@ a keyring, and every context open on one, gives ``ENODEV`` from then on,
 also after the driver is bound again; once it is, ``load`` each key
 again from its blob.
 
+The CAAM backend
+================
+
+With CONFIG_KEYCRYPT_CAAM the ``caam`` backend, of tier ``engine``, is
+available, built in or as the module ``keycrypt_caam``, for NXP SoCs
+with a CAAM. It has not been run on hardware: it is offered for owners
+of such boards to try.
+
+Its keys are AES-256 keys for ``aes256-cbc`` only. A new key is drawn
+with the kernel's random number generator and sealed at once; an
+imported one is sealed as given. Sealing makes the CAAM store the key as
+a black key (encrypted under a key that never leaves the CAAM, with ECB:
+the CAAM driver's ``cbc(paes)`` refuses CCM black keys) inside a CAAM
+blob whose key modifier is derived from the blob's header::
+
+    key modifier = first 16 bytes of SHA-256("keycrypt caam v1" || header)
+
+The backend data is a version byte, the black key's encoding, the key
+size (le16) and the 80-byte blob. A blob whose header was changed, or,
+on a CAAM in secure or trusted mode, a blob of another device, does not
+open: past the core's own checks, ``load`` fails with ``EBADMSG``. Of
+the CAAM driver's algorithms, only its internal ``cbc(paes)``, which
+AF_ALG cannot allocate, opens such a blob. The blobs of the public
+``cbc(paes)`` and of trusted keys with the ``pk`` option use the key
+modifier "SECURE_KEY", so neither kind opens as the other; a trusted
+``pk`` load copies any blob without opening it, so a keycrypt blob given
+to one is accepted there and fails when the key is used.
+
+The key is in clear in kernel memory only while a new one is drawn or
+one given to import is sealed, apart from the CAAM driver's limits
+below. After that the kernel holds the blob and, in the CAAM driver's
+state, the black key, which protect the key as far as the CAAM's own
+properties do: a black blob must not open as a red one, nor a black key
+be exported, and this backend does not check either when it runs.
+The use of a key is decided by the
+kernel: the CAAM runs whatever job the kernel submits, so the core's
+checks at ``KEYCTL_CRYPT_OPEN`` are the only ones, and a compromised
+kernel can encrypt with a decrypt-only key. That is the ``engine``
+tier. Where OP-TEE runs on the same SoC (OP-TEE derives its hardware
+unique key from the CAAM), the ``optee`` backend keeps the purpose in
+the secure world, and ``new`` with no option, or with
+``min-tier=engine``, chooses it over ``caam``; a program that wants the
+CAAM there all the same, for instance to avoid a call into the secure
+world at every operation, names it::
+
+    keyctl add keycrypt name "new aes256-cbc encrypt,decrypt backend=caam" ring
+
+The CAAM driver adds limits of its own:
+
+- On a CAAM in neither secure nor trusted mode (no closed secure boot),
+  blobs are sealed with a test key, protected by nothing, and the
+  driver writes "using insecure test key" to the kernel log at every
+  seal, which any local user can provoke with ``new``. A blob that
+  fails to open may make the driver log a job error.
+- With the driver's debug output enabled (CONFIG_CRYPTO_DEV_FSL_CAAM_DEBUG
+  or dynamic debug of the CAAM driver), it writes the key being sealed
+  to the kernel log.
+- Where its DMA goes through bounce buffers, copies of the data and,
+  when a seal fails, of the key may remain in them.
+- Unbinding the CAAM's job ring while ``keycrypt_caam`` is loaded leaves
+  the backend using freed state: do not.
+
+Every context holds a 64 KiB physically contiguous buffer, and every
+loaded key a CAAM transform; each update is one CAAM job, which opens
+the blob again. Load the module once the CAAM has probed: it registers
+only if a job ring with blob support and the CAAM's internal
+``cbc(paes)`` are there when it loads, and stays loaded but
+unregistered otherwise, saying why in the kernel log; built in, a CAAM
+whose probe was deferred leaves it unregistered.
+
 Using a key
 ===========
 
@@ -838,7 +911,9 @@ EIO          a backend failure
 An altered blob may be refused before its backend sees it, with
 ``EOPNOTSUPP``, ``ENODEV``, ``EKEYREJECTED`` or ``EPERM``, rather than
 ``EBADMSG``; past those checks ``optee`` answers ``EBADMSG`` for any
-altered byte. For the kernel tier, an altered master description gives
+altered byte. For the caam backend, ``EBADMSG`` from ``load`` can also
+be a CAAM job error it cannot tell apart from a blob that does not
+open. For the sw backend, an altered master description gives
 ``ENOKEY`` only when the altered name exists nowhere in the caller's
 search path; found there, it gives ``EACCES`` if the caller may not
 search that key, or, found and searchable but not the master that
diff --git a/security/keys/keycrypt/Kconfig b/security/keys/keycrypt/Kconfig
index a6d8a0fa6d29..f661c8952142 100644
--- a/security/keys/keycrypt/Kconfig
+++ b/security/keys/keycrypt/Kconfig
@@ -124,3 +124,30 @@ config KEYCRYPT_OPTEE
 	  which the driver finds on the TEE bus.
 
 	  If you are unsure as to whether this is required, answer N.
+
+config KEYCRYPT_CAAM
+	tristate "Keycrypt keys held by the CAAM"
+	depends on KEYCRYPT && CRYPTO_DEV_FSL_CAAM_JR
+	depends on CRYPTO_DEV_FSL_CAAM_CRYPTO_API
+	select CRYPTO_DEV_FSL_CAAM_BLOB_GEN
+	select CRYPTO_LIB_SHA256
+	select CRYPTO_SKCIPHER
+	help
+	  This option provides the "caam" keycrypt backend, of the engine
+	  tier, for NXP SoCs with a CAAM: AES-256 keys sealed as CAAM black
+	  blobs bound to their metadata, and used as black keys inside the
+	  CAAM, so that the kernel holds a key in clear only while a new
+	  one is drawn or one given to import is sealed (the documentation
+	  lists the CAAM driver's exceptions). The CAAM does not check
+	  what a key is used for: the keycrypt core does, so a
+	  compromised kernel can use a decrypt-only key to encrypt. Where
+	  OP-TEE runs, prefer the "optee" backend. Without secure boot the
+	  CAAM seals with a test key, and such keys are protected by
+	  nothing.
+
+	  Build it as a module and load it once the CAAM has probed: it
+	  registers only if a job ring with blob support and the CAAM's
+	  internal cbc(paes) are there when it loads, and stays loaded but
+	  unregistered otherwise, saying why in the kernel log.
+
+	  If you are unsure as to whether this is required, answer N.
diff --git a/security/keys/keycrypt/Makefile b/security/keys/keycrypt/Makefile
index f051050428cd..4e2087fcaee8 100644
--- a/security/keys/keycrypt/Makefile
+++ b/security/keys/keycrypt/Makefile
@@ -5,3 +5,5 @@ obj-$(CONFIG_KEYCRYPT_SW) += keycrypt_sw.o
 keycrypt_sw-y := sw.o
 obj-$(CONFIG_KEYCRYPT_OPTEE) += keycrypt_optee.o
 keycrypt_optee-y := optee.o
+obj-$(CONFIG_KEYCRYPT_CAAM) += keycrypt_caam.o
+keycrypt_caam-y := caam.o
diff --git a/security/keys/keycrypt/caam.c b/security/keys/keycrypt/caam.c
new file mode 100644
index 000000000000..d985cc38fe70
--- /dev/null
+++ b/security/keys/keycrypt/caam.c
@@ -0,0 +1,346 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * keycrypt - the CAAM backend: AES-256 keys sealed as CAAM black blobs,
+ * bound to the blob's header by their key modifier, and used as black
+ * keys through the CAAM's internal cbc(paes)
+ *
+ * Copyright (C) 2026 Rodolfo Giometti <giometti@enneenne.com>
+ */
+
+#define pr_fmt(fmt) "keycrypt: " fmt
+
+#include <crypto/aes.h>
+#include <crypto/sha2.h>
+#include <crypto/skcipher.h>
+#include <keys/keycrypt.h>
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/random.h>
+#include <linux/scatterlist.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/unaligned.h>
+#include "caam.h"
+
+/* The job ring blobs are sealed on, while the backend is registered */
+static struct caam_blob_priv *kc_caam_blob;
+
+/**
+ * struct kc_caam_ctx - a context
+ * @tfm: the key's, which outlives the context
+ * @iv: the CBC chain, advanced by every update
+ * @enc: encrypting, else decrypting
+ * @buf: KEYCRYPT_UPDATE_MAX bytes the CAAM reaches by DMA, which the
+ *	core's kvmalloc()ed buffers may not allow
+ */
+struct kc_caam_ctx {
+	struct crypto_skcipher *tfm;
+	u8 iv[AES_BLOCK_SIZE];
+	bool enc;
+	u8 *buf;
+};
+
+/* The key modifier of a blob bound to @hdr: SHA-256(label || @hdr), cut */
+static void kc_caam_key_mod(const u8 *hdr, u32 hdr_len,
+			    u8 km[CAAM_BLOB_KEYMOD_LENGTH])
+{
+	u8 d[SHA256_DIGEST_SIZE];
+	struct sha256_ctx ctx;
+
+	sha256_init(&ctx);
+	sha256_update(&ctx, (const u8 *)KC_CAAM_LABEL,
+		      sizeof(KC_CAAM_LABEL) - 1);
+	sha256_update(&ctx, hdr, hdr_len);
+	sha256_final(&ctx, d);
+	memcpy(km, d, CAAM_BLOB_KEYMOD_LENGTH);
+	memzero_explicit(d, sizeof(d));
+}
+
+/* Seal @key, or a random key if NULL, as a black blob bound to @hdr */
+static int kc_caam_seal(const u8 *hdr, u32 hdr_len, const u8 *key,
+			struct keycrypt_blob *out)
+{
+	struct caam_blob_info info = {
+		.pkey_info = {
+			.is_pkey = 1,
+			.key_enc_algo = CAAM_ENC_ALGO_ECB,
+			.plain_key_sz = KC_CAAM_KEY_LEN,
+		},
+		.input_len = KC_CAAM_KEY_LEN,
+		.output_len = KC_CAAM_BLOB_LEN,
+		.key_mod_len = CAAM_BLOB_KEYMOD_LENGTH,
+	};
+	u8 km[CAAM_BLOB_KEYMOD_LENGTH];
+	u8 *in, *blob, *data;
+	int ret = -ENOMEM;
+
+	/* The CAAM reaches the first two by DMA: not on the stack */
+	in = kmalloc(KC_CAAM_KEY_LEN, GFP_KERNEL);
+	blob = kmalloc(KC_CAAM_BLOB_LEN, GFP_KERNEL);
+	data = kmalloc(KC_CAAM_DATA_LEN, GFP_KERNEL);
+	if (!in || !blob || !data)
+		goto out;
+	if (key) {
+		memcpy(in, key, KC_CAAM_KEY_LEN);
+	} else {
+		ret = get_random_bytes_wait(in, KC_CAAM_KEY_LEN);
+		if (ret)
+			goto out;
+	}
+	kc_caam_key_mod(hdr, hdr_len, km);
+	info.input = in;
+	info.output = blob;
+	info.key_mod = km;
+	ret = caam_encap_blob(kc_caam_blob, &info);
+	if (!ret && info.output_len != KC_CAAM_BLOB_LEN)
+		ret = -EIO;
+	if (ret) {
+		ret = ret == -ENOMEM ? ret : -EIO;
+		goto out;
+	}
+	data[KC_CAAM_OFF_VER] = KC_CAAM_VERSION;
+	data[KC_CAAM_OFF_ENC] = CAAM_ENC_ALGO_ECB;
+	put_unaligned_le16(KC_CAAM_KEY_LEN, data + KC_CAAM_OFF_SZ);
+	memcpy(data + KC_CAAM_OFF_BLOB, blob, KC_CAAM_BLOB_LEN);
+	out->data = data;
+	out->len = KC_CAAM_DATA_LEN;
+	data = NULL;
+out:
+	/* The key in clear, or the black key the CAAM wrote over it */
+	kfree_sensitive(in);
+	kfree(blob);
+	kfree(data);
+	return ret;
+}
+
+static int kc_caam_generate(struct keycrypt_backend *b,
+			    const struct keycrypt_meta *m, const u8 *hdr,
+			    u32 hdr_len, const char *opts,
+			    struct keycrypt_blob *out)
+{
+	return kc_caam_seal(hdr, hdr_len, NULL, out);
+}
+
+static int kc_caam_import(struct keycrypt_backend *b,
+			  const struct keycrypt_meta *m, const u8 *hdr,
+			  u32 hdr_len, const char *opts, const u8 *key,
+			  size_t keylen, struct keycrypt_blob *out)
+{
+	if (keylen != KC_CAAM_KEY_LEN)
+		return -EINVAL;
+	return kc_caam_seal(hdr, hdr_len, key, out);
+}
+
+/*
+ * One request on @tfm, in place on @buf (kmalloc()ed), waited for without
+ * a timeout: only the CAAM's own watchdog bounds it
+ */
+static int kc_caam_crypt(struct crypto_skcipher *tfm, u8 *iv, u8 *buf,
+			 unsigned int len, bool enc)
+{
+	struct skcipher_request *req;
+	DECLARE_CRYPTO_WAIT(wait);
+	struct scatterlist sg;
+	int ret;
+
+	req = skcipher_request_alloc(tfm, GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+	sg_init_one(&sg, buf, len);
+	skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
+				      CRYPTO_TFM_REQ_MAY_SLEEP,
+				      crypto_req_done, &wait);
+	skcipher_request_set_crypt(req, &sg, &sg, len, iv);
+	ret = crypto_wait_req(enc ? crypto_skcipher_encrypt(req) :
+			      crypto_skcipher_decrypt(req), &wait);
+	skcipher_request_free(req);
+	return ret;
+}
+
+static int kc_caam_load(struct keycrypt_backend *b, struct keycrypt_key *k,
+			const char *opts)
+{
+	struct caam_pkey_info pi = {
+		.is_pkey = 1,
+		.key_enc_algo = CAAM_ENC_ALGO_ECB,
+		.plain_key_sz = KC_CAAM_KEY_LEN,
+	};
+	u8 iv[AES_BLOCK_SIZE] = {};
+	struct crypto_skcipher *tfm;
+	u8 *key = NULL, *probe = NULL;
+	int ret;
+
+	/* Not the CAAM's: the blob is all it authenticates */
+	if (k->data_len != KC_CAAM_DATA_LEN ||
+	    k->data[KC_CAAM_OFF_VER] != KC_CAAM_VERSION ||
+	    k->data[KC_CAAM_OFF_ENC] != CAAM_ENC_ALGO_ECB ||
+	    get_unaligned_le16(k->data + KC_CAAM_OFF_SZ) != KC_CAAM_KEY_LEN)
+		return -EBADMSG;
+
+	tfm = crypto_alloc_skcipher(KC_CAAM_ALG, CRYPTO_ALG_INTERNAL,
+				    CRYPTO_ALG_INTERNAL);
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm) == -ENOMEM ? -ENOMEM : -EIO;
+
+	ret = -ENOMEM;
+	key = kmalloc(CAAM_PKEY_KM_HEADER + KC_CAAM_BLOB_LEN, GFP_KERNEL);
+	probe = kzalloc(AES_BLOCK_SIZE, GFP_KERNEL);
+	if (!key || !probe)
+		goto out;
+	memcpy(key, &pi, CAAM_PKEY_HEADER);
+	kc_caam_key_mod(k->hdr, k->hdr_len, key + CAAM_PKEY_HEADER);
+	memcpy(key + CAAM_PKEY_KM_HEADER, k->data + KC_CAAM_OFF_BLOB,
+	       KC_CAAM_BLOB_LEN);
+	ret = crypto_skcipher_setkey(tfm, key,
+				     CAAM_PKEY_KM_HEADER + KC_CAAM_BLOB_LEN);
+	if (ret) {
+		ret = -EIO;
+		goto out;
+	}
+	ret = kc_caam_crypt(tfm, iv, probe, AES_BLOCK_SIZE, true);
+	/*
+	 * A CAAM job status (-EBADMSG for an ICV failure, -EINVAL otherwise)
+	 * is taken as a blob that does not open with this header's key
+	 * modifier; a failure to submit the job is not
+	 */
+	if (ret == -EINVAL)
+		ret = -EBADMSG;
+	else if (ret && ret != -EBADMSG && ret != -ENOMEM)
+		ret = -EIO;
+out:
+	kfree(key);
+	/* E_K(0): not secret */
+	kfree(probe);
+	if (ret) {
+		crypto_free_skcipher(tfm);
+		return ret;
+	}
+	k->priv = tfm;
+	return 0;
+}
+
+static void kc_caam_destroy(struct keycrypt_backend *b,
+			    struct keycrypt_key *k)
+{
+	crypto_free_skcipher(k->priv);
+	k->priv = NULL;
+}
+
+static int kc_caam_ctx_open(struct keycrypt_backend *b,
+			    struct keycrypt_key *k, u32 op, u8 *iv,
+			    void **ctx)
+{
+	struct kc_caam_ctx *c;
+
+	if (op != KEYCRYPT_OP_ENCRYPT && op != KEYCRYPT_OP_DECRYPT)
+		return -EIO;
+	c = kzalloc_obj(*c, GFP_KERNEL_ACCOUNT);
+	if (!c)
+		return -ENOMEM;
+	c->buf = kmalloc(KEYCRYPT_UPDATE_MAX,
+			 GFP_KERNEL_ACCOUNT | __GFP_NOWARN);
+	if (!c->buf) {
+		kfree(c);
+		return -ENOMEM;
+	}
+	c->tfm = k->priv;
+	memcpy(c->iv, iv, AES_BLOCK_SIZE);
+	c->enc = op == KEYCRYPT_OP_ENCRYPT;
+	*ctx = c;
+	return 0;
+}
+
+static int kc_caam_update(struct keycrypt_backend *b, void *ctx,
+			  const u8 *in, u8 *out, size_t len)
+{
+	struct kc_caam_ctx *c = ctx;
+	int ret;
+
+	if (len > KEYCRYPT_UPDATE_MAX || len % AES_BLOCK_SIZE)
+		return -EIO;
+	if (!len)
+		return 0;
+	memcpy(c->buf, in, len);
+	ret = kc_caam_crypt(c->tfm, c->iv, c->buf, len, c->enc);
+	if (!ret)
+		memcpy(out, c->buf, len);
+	memzero_explicit(c->buf, len);
+	return ret;
+}
+
+static int kc_caam_final(struct keycrypt_backend *b, void *ctx, u8 *out,
+			 size_t out_size, size_t *len)
+{
+	*len = 0;
+	return 0;
+}
+
+static void kc_caam_ctx_free(struct keycrypt_backend *b, void *ctx)
+{
+	struct kc_caam_ctx *c = ctx;
+
+	kfree(c->buf);		/* wiped after every update */
+	kfree_sensitive(c);
+}
+
+static struct keycrypt_backend keycrypt_caam = {
+	.name		= "caam",
+	.tier		= KEYCRYPT_TIER_ENGINE,
+	.algs		= BIT(KEYCRYPT_ALG_AES256_CBC),
+	.owner		= THIS_MODULE,
+	.generate	= kc_caam_generate,
+	.import		= kc_caam_import,
+	.load		= kc_caam_load,
+	.destroy	= kc_caam_destroy,
+	.ctx_open	= kc_caam_ctx_open,
+	.update		= kc_caam_update,
+	.final		= kc_caam_final,
+	.ctx_free	= kc_caam_ctx_free,
+};
+
+/*
+ * Without a CAAM the module stays loaded with the backend unregistered,
+ * and says why in the log
+ */
+static int __init kc_caam_init(void)
+{
+	struct caam_blob_priv *blob;
+	int ret;
+
+	blob = caam_blob_gen_init();
+	if (IS_ERR(blob)) {
+		pr_info("caam backend not registered: no CAAM job ring with blob support\n");
+		return 0;
+	}
+	if (!crypto_has_skcipher(KC_CAAM_ALG, CRYPTO_ALG_INTERNAL,
+				 CRYPTO_ALG_INTERNAL)) {
+		pr_info("caam backend not registered: no %s\n", KC_CAAM_ALG);
+		caam_blob_gen_exit(blob);
+		return 0;
+	}
+	kc_caam_blob = blob;
+	ret = keycrypt_register_backend(&keycrypt_caam);
+	if (ret) {
+		kc_caam_blob = NULL;
+		caam_blob_gen_exit(blob);
+	}
+	return ret;
+}
+
+/*
+ * Built in: after the job-ring driver registered; a CAAM whose probe was
+ * deferred is not there yet
+ */
+late_initcall(kc_caam_init);
+
+static void __exit kc_caam_exit(void)
+{
+	if (!kc_caam_blob)
+		return;
+	keycrypt_unregister_backend(&keycrypt_caam);
+	caam_blob_gen_exit(kc_caam_blob);
+}
+module_exit(kc_caam_exit);
+
+MODULE_DESCRIPTION("keycrypt CAAM backend");
+MODULE_LICENSE("GPL");
diff --git a/security/keys/keycrypt/caam.h b/security/keys/keycrypt/caam.h
new file mode 100644
index 000000000000..ebefa1dcff2e
--- /dev/null
+++ b/security/keys/keycrypt/caam.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * keycrypt - the CAAM backend's data layout
+ *
+ * Copyright (C) 2026 Rodolfo Giometti <giometti@enneenne.com>
+ */
+
+#ifndef _SECURITY_KEYS_KEYCRYPT_CAAM_H
+#define _SECURITY_KEYS_KEYCRYPT_CAAM_H
+
+#include <soc/fsl/caam-blob.h>
+
+/* Hashed with the header into the key modifier; "v1" names this layout */
+#define KC_CAAM_LABEL		"keycrypt caam v1"
+
+/* The CAAM's internal cbc(paes), which takes the blob's key modifier */
+#define KC_CAAM_ALG		"cbc-paes-km-caam"
+
+#define KC_CAAM_VERSION		1
+#define KC_CAAM_KEY_LEN		32	/* AES-256 */
+#define KC_CAAM_BLOB_LEN	(KC_CAAM_KEY_LEN + CAAM_BLOB_OVERHEAD)
+
+/* The backend's data: version, key encoding, key size (le16), black blob */
+#define KC_CAAM_OFF_VER		0
+#define KC_CAAM_OFF_ENC		1
+#define KC_CAAM_OFF_SZ		2
+#define KC_CAAM_OFF_BLOB	4
+#define KC_CAAM_DATA_LEN	(KC_CAAM_OFF_BLOB + KC_CAAM_BLOB_LEN)
+
+#endif /* _SECURITY_KEYS_KEYCRYPT_CAAM_H */
-- 
2.43.0

