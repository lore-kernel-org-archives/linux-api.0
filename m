Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.156.87
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795010680;
	b=ISMX5eFHG1VQQf11AzzyPjv+mKSeKzhrBy207hg+aK0CWYUrUBh3WJZZg7JLTZVNXtCY
	 G8nwW6lsn1QkVBp3CTKDCkB0l3aCru82YDxmttSg5yXgtDOhsqzURTEibUtfMuPy3wipS
	 5wgT+KLoqxVzntaoUjGZPOuGtb66GIkHbSMX73HMO0N/a6DTikK/V7Lv3cZpG+2MLXATm
	 +wut9tuAt3qz8b+pqZsFxu6AMszk7nFXK81UmkFjg1nWfcNr+PfSWvn6GfFaHMfebNWBm
	 AJWjB66bQJeRID5mGC8CMi3Wg/fczdfQpCGip4ZwbfFTmWvsOWrAFYuv0mvtZ8m/rDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795010680;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CMAE-Envelope;
	bh=z/HJIcpabCxs0VbBc5qQ1+MCFiToabINpitp6JkLwho=;
	b=Zd8v0/hRj4R1PFYqizpfqy+jXNgTHAsk7oRaB95O6qhuqekNfFg3bRgFBYUZXsN6I+cf
	 /bPfvMdREEbcOlq7e1F+FENH2mTuARUgeOyH6+S/x728Yf/SuSh+2d65Xbn0eOrP+hzob
	 2sFpIPwnjIq2VTozy9YPiOLs9/vL/0hf4yWY2k1kIIDs4YLGuEwi4gYYcAc/RHhNjWVa5
	 /GhBPi+XPnoiyTP++4Oe6nmiekOuC7QVg2tMrvV+oxxKoWemmBZFYJFJNpBbBkYSOezBf
	 4kPkHCS1mQNRLZKAa1X+EczKJrwiO++FSz3jmFpnYDHaH7rGhUuEayLhlkhawezQA0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=enneenne.com;
	spf=pass smtp.mailfrom=enneenne.com;
	dkim=pass header.d=aruba.it header.i=@aruba.it header.a=rsa-sha256 header.s=a1 header.b=lUEUd6nx;
	arc=none smtp.remote-ip=62.149.156.87
Received: from smtpcmd0987.aruba.it (smtpcmd0987.aruba.it [62.149.156.87])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74507606A320
	for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 14:04:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74507606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=enneenne.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=enneenne.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.a=rsa-sha256 header.s=a1 header.b=lUEUd6nx
Received: from polimar.tail4f75e6.ts.net ([101.57.122.26])
	by Aruba SMTP with ESMTPSA
	id TgGvxLK1X6q8sTgH0xc6NE; Wed, 18 Nov 2026 15:04:30 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1795010670; bh=ri1z1nmKrZJAIeer2FvVgJMXr755InTgnrOMRLpwRDE=;
	h=From:To:Subject:Date:MIME-Version;
	b=lUEUd6nx9bfWcWkMOFl70pUcMUi9A8djTq+aXLhAYQ3fSB1ZmCqTyQW9G4u9+t4bO
	 t2bfVLxS9FTArdx4n3MgQRkLNGetjJ/h5OLu/E60SiCMXCsn2QEOeWCuIBYJN8DoXD
	 g9dMhzS3eC2/GJFssiGuq2eQu63qIO32uTOqb03uW45W9JFjuhP3cPs4bWAm9c6h/p
	 gOqIDZjSAZWkLUnO8gp1hD+GNQBE8cnVZWowhnhn1/s23x4ro8vqmiYWJpQCdZMATj
	 A/lZaliSVI7/owxP/V/hbo9QGS+/j9CtJfWFnsnKyWW0FPMxwh5HDiwe4zmfpkZWdU
	 KdclpE8NEzqVg==
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
Subject: [RFC PATCH 2/9] KEYS: keycrypt: Add the sw backend
Date: Wed, 18 Nov 2026 15:04:14 +0100
Message-ID: <20261118140421.584086-3-giometti@enneenne.com>
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
X-CMAE-Envelope: MS4xfP3GH+/uUH2UT8xMvG9D4FaNvSpSliR0tTjVUWsuRp2/IOriQDotlmu0kb3Bvcv48aoM5XNmWbhv5eiS7QNJbgeBC1jsSjfOF972Rnh0emTdPjKGem6H
 R8FQM5ApEvDUk+7C5B64URlE/DqsWbFPmIqF5Fdxjbuw5qXpIO8d3te0cEC82Z1yxBQsfy5fV3Q6vZ1LuvDllWjcXQWhDr7/HbtU7r6PNWGUC6idVx8Dr8+B
 ek4wY1yZBCSekXremPsy96JR7VaG9YbC7dlZs/oF6FLaX56+khmMFDlKpg5Dga4RtCmlhP/PTf3/Dh/xG0Z35IxWGkvCS6mi3AQfMrTerV4gSjhBfTQ8TQhO
 2WtVsUgvTKAdiS2UhdVIk71THz3tgRxdeiBji8ZF+HADmbWgIlux4FlE4A0p3VP28f3gPJjwZKDH6AglEq+tcr1rjRLY8s7zrvU3ThHx7VMVVqpygaf93J27
 DHVEmdvKZFfR2UpWKSpSpKe8bJ0gn5UBlCLF0U9qDWYm+OsTcJC1+LnMhIjs4V4ikBIZNYQ72dmcSA3wyxBIE0HTPEzGG5/FK79bEa+OjwBYPRNnZMFu4/jE
 8fLscBn43xcxUZDE5f739I9U6VsNnUIH18fH8PjS9D9PsDJMhGMIuXaIiTxfCA1eB5mKHBc0ZnDALP0lYEcdczQp4+tzuYYNQ5Dm+6QH5rRsXS2mo/04EzVe
 gOWbCEMppMR8Ix+CM/H9ZCn3Merx9nyppgAhPDvrxQg21bU2Slt3lq4OPuwCaUo4PM1BGE3mSkSH/K1Lh7n2baw0oAovFNLJASml8hcwqvwIut+vbNsDev+/
 jL4TwCncokB9Gi9URV3sZeunfcG9elxQWWwLF70sRfu/Lj5CRo/LRnLLovR6bdbfJLbQL9PSC4rTIB9ezDgA8pCsliQo+8sfWszS7g+kZLsqcJe/pCzk3G2a
 K+aXWYYMBQ0+ZNodOykTnAu3U4Hpwf+A2Zhq0OsFvpNa5DfzMmhakS1mds1nPPfv5ZvQqawz4umbE/HXrLCnbCHipO7LH80m7k96Pvpd8GYdU5c+qkfL6OQj
 fBCugevbR4dYV71GmnWwMQf65uCPFfgEkHD8W5tyK0vJk30l/gaBt/FPPDGig/O2ukfHCRY0tThWdOkh7mGihZ6qm0bRs1fluXnNy3LNQBVXy/6c/Tec1ozG
 NUtfvoTF17PzVAAZusBifuJoXObZh4EK1MP30GWBGgaUpFqcU8vImlEjsHJ2AZ7eVxR1conCt1qT4W3JkVapXZnACuU4vDw/6BLTMqZ/9OLmP+rDNjRBJRSv
 hk8hlS8qrmlHW4pWqVe6at3+Hlu3MLpacBiP3W/Elb7Irg4wAAw=

Systems with neither a TEE nor a crypto engine able to keep keys still
want keys that user space cannot read and that are bound to one
algorithm and purpose, and the same interface on every device.

Add the "sw" backend, of the kernel tier: it seals each key with
AES-256-GCM under a key derived with HMAC-SHA256 from a "trusted" key
named by master=, authenticating the keycrypt header with it, and runs
the operations with the kernel's crypto library. A loaded key is in
clear in kernel memory until revoked or destroyed, which the kernel
log says when the backend registers and when the first key is loaded;
the backend is chosen only by tier=kernel, by backend=sw, or when no
backend of a higher tier is registered, and a system that must not use
it raises the system tier above it (CONFIG_KEYCRYPT_SYSTEM_TIER_*), or
leaves this option off.

In that derivation the trusted key's material is what the HMAC
processes, under a label and a random salt as its key, and not the
other way round: AF_ALG lets user space name a trusted key by its
serial number as the key of an HMAC socket, so with the material as the
key anyone allowed to search the master could recompute the sealing
key of every blob.

It depends on TRUSTED_KEYS and is a module when trusted keys are one.

Signed-off-by: Rodolfo Giometti <giometti@enneenne.com>
---
 security/keys/keycrypt/Kconfig  |  36 ++-
 security/keys/keycrypt/Makefile |   2 +
 security/keys/keycrypt/sw.c     | 404 ++++++++++++++++++++++++++++++++
 security/keys/keycrypt/sw.h     |  30 +++
 4 files changed, 468 insertions(+), 4 deletions(-)
 create mode 100644 security/keys/keycrypt/sw.c
 create mode 100644 security/keys/keycrypt/sw.h

diff --git a/security/keys/keycrypt/Kconfig b/security/keys/keycrypt/Kconfig
index e1d1b8e2a58b..50fd4cb3b1d2 100644
--- a/security/keys/keycrypt/Kconfig
+++ b/security/keys/keycrypt/Kconfig
@@ -34,10 +34,13 @@ choice
 	help
 	  The lowest tier a keycrypt key may be used at when the kernel
 	  starts: KEYCTL_CRYPT_OPEN refuses a key of a lower tier, which
-	  can still be created and loaded. The keycrypt.system_tier= boot
-	  parameter and the kernel.keys.keycrypt_system_tier sysctl can
-	  only raise it, so a signed kernel image sets a floor its command
-	  line cannot lower.
+	  can still be created and loaded. A key of the kernel tier so
+	  created or loaded is in clear in kernel memory all the same, as
+	  its trusted master is: to have none, build without
+	  KEYCRYPT_SW, the in-tree backend of that tier. The
+	  keycrypt.system_tier= boot parameter and the
+	  kernel.keys.keycrypt_system_tier sysctl can only raise it, so a
+	  signed kernel image sets a floor its command line cannot lower.
 
 	  The default sets no floor: which backends a kernel builds says
 	  nothing about which will be present when it runs (a
@@ -70,3 +73,28 @@ config KEYCRYPT_SYSTEM_TIER_HSM
 	  keycrypt key can be used at all.
 
 endchoice
+
+config KEYCRYPT_SW
+	tristate "The sw keycrypt backend, of the kernel tier"
+	depends on KEYCRYPT && TRUSTED_KEYS
+	select CRYPTO_LIB_AES_GCM
+	select CRYPTO_LIB_AES_CBC
+	select CRYPTO_LIB_SHA256
+	help
+	  This option provides the "sw" keycrypt backend: keys sealed
+	  with AES-256-GCM under a key derived from a "trusted" key, and
+	  used by the kernel itself. While such a key is loaded, it is in
+	  clear in kernel memory: this lowers the security of the system,
+	  and the kernel says so in its log when the backend registers and
+	  when the first such key is loaded. This backend is chosen by
+	  tier=kernel or backend=sw, and for a key created with
+	  neither a tier option nor backend= whenever no backend of a
+	  higher tier is registered.
+
+	  It needs trusted keys (TRUSTED_KEYS) to seal and load keys, and
+	  is built as a module when trusted keys are one.
+
+	  Use trusted keys created with blob authorization or a policy as
+	  masters (see the documentation).
+
+	  If you are unsure as to whether this is required, answer N.
diff --git a/security/keys/keycrypt/Makefile b/security/keys/keycrypt/Makefile
index 8910fb0156e7..5a2e222a6908 100644
--- a/security/keys/keycrypt/Makefile
+++ b/security/keys/keycrypt/Makefile
@@ -1,3 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
 obj-y += core.o ctx.o
+obj-$(CONFIG_KEYCRYPT_SW) += keycrypt_sw.o
+keycrypt_sw-y := sw.o
diff --git a/security/keys/keycrypt/sw.c b/security/keys/keycrypt/sw.c
new file mode 100644
index 000000000000..f1ff4de4afc6
--- /dev/null
+++ b/security/keys/keycrypt/sw.c
@@ -0,0 +1,404 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * keycrypt - the sw backend, of the kernel tier: keys sealed under a
+ * trusted key, used by the kernel itself
+ *
+ * The blob's layout and its GCM key are in keycrypt.rst, "The sw
+ * backend".
+ *
+ * Copyright (C) 2026 Rodolfo Giometti <giometti@enneenne.com>
+ */
+
+#include <crypto/aes-cbc.h>
+#include <crypto/aes-gcm.h>
+#include <crypto/sha2.h>
+#include <keys/trusted-type.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/key.h>
+#include <linux/module.h>
+#include <linux/random.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include "keycrypt.h"
+#include "sw.h"
+
+/* <keys/trusted-type.h> redefines pr_fmt; reassert ours after it */
+#undef pr_fmt
+#define pr_fmt(fmt) "keycrypt: " fmt
+
+#define SW_LABEL	"keycrypt kernel-tier v1"
+#define SW_AAD_MAX	(KEYCRYPT_HEADER_MAX + 2 + KEYCRYPT_SW_DESC_MAX + \
+			 KEYCRYPT_SW_SALT_LEN)
+
+static int sw_prepare(struct aes_gcm_key *gk, const u8 *master, size_t mlen,
+		      const u8 *salt)
+{
+	u8 label[sizeof(SW_LABEL) - 1 + KEYCRYPT_SW_SALT_LEN];
+	u8 dk[SHA256_DIGEST_SIZE];
+	int ret;
+
+	memcpy(label, SW_LABEL, sizeof(SW_LABEL) - 1);
+	memcpy(label + sizeof(SW_LABEL) - 1, salt, KEYCRYPT_SW_SALT_LEN);
+	/*
+	 * The master is the data, never the key: AF_ALG keys an HMAC with
+	 * a trusted key given by serial, so whoever may search the master
+	 * could otherwise compute this key.
+	 */
+	hmac_sha256_usingrawkey(label, sizeof(label), master, mlen, dk);
+	ret = aes_gcm_preparekey(gk, dk, sizeof(dk), KEYCRYPT_SW_TAG_LEN);
+	memzero_explicit(dk, sizeof(dk));
+	return ret;
+}
+
+static size_t sw_aad(u8 *aad, const u8 *hdr, u32 hdr_len, const u8 *prefix,
+		     size_t prefix_len)
+{
+	memcpy(aad, hdr, hdr_len);
+	memcpy(aad + hdr_len, prefix, prefix_len);
+	return hdr_len + prefix_len;
+}
+
+static int keycrypt_sw_seal(const u8 *master, size_t mlen,
+			    const u8 *hdr, u32 hdr_len,
+			    const char *desc, const u8 *key,
+			    size_t klen, struct keycrypt_blob *out)
+{
+	size_t dlen = strlen(desc), prefix_len, alen, len;
+	struct aes_gcm_key gk;
+	u8 aad[SW_AAD_MAX];
+	u8 *p, *salt, *nonce, *ct;
+	int ret;
+
+	if (!dlen || dlen > KEYCRYPT_SW_DESC_MAX ||
+	    hdr_len > KEYCRYPT_HEADER_MAX || !klen ||
+	    klen > KEYCRYPT_SW_KEY_MAX)
+		return -EINVAL;
+	len = 2 + dlen + KEYCRYPT_SW_SALT_LEN + KEYCRYPT_SW_NONCE_LEN + klen +
+	      KEYCRYPT_SW_TAG_LEN;
+	p = kmalloc(len, GFP_KERNEL);
+	if (!p)
+		return -ENOMEM;
+	p[0] = KEYCRYPT_SW_VERSION;
+	p[1] = dlen;
+	memcpy(p + 2, desc, dlen);
+	salt = p + 2 + dlen;
+	nonce = salt + KEYCRYPT_SW_SALT_LEN;
+	ct = nonce + KEYCRYPT_SW_NONCE_LEN;
+	ret = get_random_bytes_wait(salt, KEYCRYPT_SW_SALT_LEN);
+	if (ret) {
+		kfree(p);
+		return ret;
+	}
+	ret = sw_prepare(&gk, master, mlen, salt);
+	if (ret) {
+		kfree(p);
+		return ret;
+	}
+	ret = get_random_bytes_wait(nonce, KEYCRYPT_SW_NONCE_LEN);
+	if (ret) {
+		memzero_explicit(&gk, sizeof(gk));
+		kfree(p);
+		return ret;
+	}
+	prefix_len = 2 + dlen + KEYCRYPT_SW_SALT_LEN;
+	alen = sw_aad(aad, hdr, hdr_len, p, prefix_len);
+	aes_gcm_encrypt(ct, key, klen, ct + klen, aad, alen, nonce, &gk);
+	memzero_explicit(&gk, sizeof(gk));
+	out->data = p;
+	out->len = len;
+	return 0;
+}
+
+static int keycrypt_sw_unseal(const u8 *master, size_t mlen,
+			      const u8 *hdr, u32 hdr_len,
+			      const u8 *data, u32 len, u8 *key,
+			      size_t *klen)
+{
+	const u8 *salt, *nonce, *ct;
+	struct aes_gcm_key gk;
+	size_t dlen, clen, alen, prefix_len;
+	u8 aad[SW_AAD_MAX];
+	int ret;
+
+	if (len < 2 || data[0] != KEYCRYPT_SW_VERSION ||
+	    hdr_len > KEYCRYPT_HEADER_MAX)
+		return -EBADMSG;
+	dlen = data[1];
+	if (!dlen ||
+	    len < 2 + dlen + KEYCRYPT_SW_SALT_LEN + KEYCRYPT_SW_NONCE_LEN + 1 +
+		  KEYCRYPT_SW_TAG_LEN)
+		return -EBADMSG;
+	clen = len - 2 - dlen - KEYCRYPT_SW_SALT_LEN - KEYCRYPT_SW_NONCE_LEN -
+	       KEYCRYPT_SW_TAG_LEN;
+	if (clen > KEYCRYPT_SW_KEY_MAX)
+		return -EBADMSG;
+	salt = data + 2 + dlen;
+	nonce = salt + KEYCRYPT_SW_SALT_LEN;
+	ct = nonce + KEYCRYPT_SW_NONCE_LEN;
+	prefix_len = 2 + dlen + KEYCRYPT_SW_SALT_LEN;
+	alen = sw_aad(aad, hdr, hdr_len, data, prefix_len);
+	ret = sw_prepare(&gk, master, mlen, salt);
+	if (ret)
+		return ret;
+	ret = aes_gcm_decrypt(key, ct, clen, ct + clen, aad, alen, nonce, &gk);
+	memzero_explicit(&gk, sizeof(gk));
+	if (ret) {
+		memzero_explicit(key, clen);
+		return -EBADMSG;
+	}
+	*klen = clen;
+	return 0;
+}
+
+/*
+ * Copy the key material of the trusted key @desc that the caller can
+ * search for into @buf (MAX_KEY_SIZE bytes). No callout information, so no
+ * upcall: the key must exist, though it may still be under construction,
+ * and then this waits for it with the backend's handle held: the one wait
+ * without bound in this backend's callbacks. Not request_key_rcu(): it
+ * misses keys that the RCU walk cannot reach, such as those of the user
+ * keyring of a process without a session keyring.
+ */
+static int sw_master(const char *desc, u8 *buf, size_t *len)
+{
+	const struct trusted_key_payload *tp;
+	struct key *mk;
+	int ret;
+
+	mk = request_key(&key_type_trusted, desc, NULL);
+	if (IS_ERR(mk))
+		return PTR_ERR(mk) == -EACCES ? -EACCES : -ENOKEY;
+	down_read(&mk->sem);
+	tp = dereference_key_locked(mk);
+	if (key_validate(mk) || !tp || tp->key_len < MIN_KEY_SIZE ||
+	    tp->key_len > MAX_KEY_SIZE) {
+		ret = -ENOKEY;
+	} else {
+		memcpy(buf, tp->key, tp->key_len);
+		*len = tp->key_len;
+		ret = 0;
+	}
+	up_read(&mk->sem);
+	key_put(mk);
+	return ret;
+}
+
+/* The one option of the sw backend: "master=<description>" */
+static int sw_master_opt(const char *opts, const char **desc)
+{
+	if (!opts || strncmp(opts, "master=", 7) || !opts[7])
+		return -EINVAL;
+	*desc = opts + 7;
+	return 0;
+}
+
+static int sw_seal_key(const u8 *hdr, u32 hdr_len, const char *opts,
+		       const u8 *key, size_t klen, struct keycrypt_blob *out)
+{
+	u8 master[MAX_KEY_SIZE];
+	const char *desc;
+	size_t mlen;
+	int ret;
+
+	ret = sw_master_opt(opts, &desc);
+	if (ret)
+		return ret;
+	if (strlen(desc) > KEYCRYPT_SW_DESC_MAX)
+		return -EINVAL;
+	ret = sw_master(desc, master, &mlen);
+	if (!ret)
+		ret = keycrypt_sw_seal(master, mlen, hdr, hdr_len, desc, key,
+				       klen, out);
+	memzero_explicit(master, sizeof(master));
+	return ret;
+}
+
+static int sw_generate(struct keycrypt_backend *b,
+		       const struct keycrypt_meta *m, const u8 *hdr,
+		       u32 hdr_len, const char *opts,
+		       struct keycrypt_blob *out)
+{
+	u8 key[32];
+	int ret;
+
+	ret = get_random_bytes_wait(key, sizeof(key));
+	if (!ret)
+		ret = sw_seal_key(hdr, hdr_len, opts, key, sizeof(key), out);
+	memzero_explicit(key, sizeof(key));
+	return ret;
+}
+
+static int sw_import(struct keycrypt_backend *b,
+		     const struct keycrypt_meta *m, const u8 *hdr,
+		     u32 hdr_len, const char *opts, const u8 *key,
+		     size_t keylen, struct keycrypt_blob *out)
+{
+	return sw_seal_key(hdr, hdr_len, opts, key, keylen, out);
+}
+
+static int sw_load(struct keycrypt_backend *b, struct keycrypt_key *k,
+		   const char *opts)
+{
+	char desc[KEYCRYPT_SW_DESC_MAX + 1];
+	u8 master[MAX_KEY_SIZE];
+	struct keycrypt_sw_key *priv;
+	size_t mlen, dlen;
+	int ret;
+
+	if (opts)
+		return -EINVAL;
+	if (k->data_len < 2 || !k->data[1])
+		return -EBADMSG;
+	dlen = k->data[1];
+	if (k->data_len < 2 + dlen)
+		return -EBADMSG;
+	memcpy(desc, k->data + 2, dlen);
+	desc[dlen] = '\0';
+	if (strlen(desc) != dlen)
+		return -EBADMSG;
+
+	priv = kzalloc_obj(*priv);
+	if (!priv)
+		return -ENOMEM;
+	ret = sw_master(desc, master, &mlen);
+	if (!ret)
+		ret = keycrypt_sw_unseal(master, mlen, k->hdr, k->hdr_len,
+					 k->data, k->data_len, priv->key,
+					 &priv->len);
+	memzero_explicit(master, sizeof(master));
+	if (!ret && !keycrypt_key_len_valid(k->meta.alg, priv->len))
+		ret = -EBADMSG;
+	if (ret) {
+		kfree_sensitive(priv);
+		return ret;
+	}
+	k->priv = priv;
+	pr_warn_once("a key of the kernel tier is loaded: it is in clear in kernel memory\n");
+	return 0;
+}
+
+static void sw_destroy(struct keycrypt_backend *b, struct keycrypt_key *k)
+{
+	kfree_sensitive(k->priv);
+	k->priv = NULL;
+}
+
+struct sw_ctx {
+	u32 op;
+	union {
+		struct {
+			union {
+				struct aes_key    key;	    /* decrypt */
+				struct aes_enckey enc_key; /* encrypt-only */
+			};
+			u8 iv[AES_BLOCK_SIZE];
+		} cbc;
+		struct hmac_sha256_ctx mac;
+	};
+};
+
+static int sw_ctx_open(struct keycrypt_backend *b, struct keycrypt_key *k,
+		       u32 op, u8 *iv, void **ctx)
+{
+	struct keycrypt_sw_key *kk = k->priv;
+	struct sw_ctx *c;
+	int ret;
+
+	if (!kk)
+		return -EIO;
+	c = kzalloc_obj(*c, GFP_KERNEL_ACCOUNT);
+	if (!c)
+		return -ENOMEM;
+	c->op = op;
+	if (op == KEYCRYPT_OP_MAC || op == KEYCRYPT_OP_VERIFY) {
+		hmac_sha256_init_usingrawkey(&c->mac, kk->key, kk->len);
+	} else {
+		ret = op == KEYCRYPT_OP_ENCRYPT ?
+		      aes_prepareenckey(&c->cbc.enc_key, kk->key, kk->len) :
+		      aes_preparekey(&c->cbc.key, kk->key, kk->len);
+		if (ret) {
+			kfree_sensitive(c);
+			return -EIO;
+		}
+		memcpy(c->cbc.iv, iv, AES_BLOCK_SIZE);
+	}
+	*ctx = c;
+	return 0;
+}
+
+static int sw_update(struct keycrypt_backend *b, void *ctx, const u8 *in,
+		     u8 *out, size_t len)
+{
+	struct sw_ctx *c = ctx;
+
+	switch (c->op) {
+	case KEYCRYPT_OP_ENCRYPT:
+		aes_cbc_encrypt(out, in, len, c->cbc.iv, &c->cbc.enc_key);
+		break;
+	case KEYCRYPT_OP_DECRYPT:
+		aes_cbc_decrypt(out, in, len, c->cbc.iv, &c->cbc.key);
+		break;
+	default:
+		hmac_sha256_update(&c->mac, in, len);
+	}
+	return 0;
+}
+
+static int sw_final(struct keycrypt_backend *b, void *ctx, u8 *out,
+		    size_t out_size, size_t *len)
+{
+	struct sw_ctx *c = ctx;
+
+	if (c->op == KEYCRYPT_OP_MAC || c->op == KEYCRYPT_OP_VERIFY) {
+		if (out_size < SHA256_DIGEST_SIZE)
+			return -EIO;
+		hmac_sha256_final(&c->mac, out);
+		*len = SHA256_DIGEST_SIZE;
+	} else {
+		*len = 0;
+	}
+	return 0;
+}
+
+static void sw_ctx_free(struct keycrypt_backend *b, void *ctx)
+{
+	kfree_sensitive(ctx);
+}
+
+static const char * const sw_opts[] = { "master", NULL };
+
+static struct keycrypt_backend keycrypt_sw = {
+	.name		= "sw",
+	.tier		= KEYCRYPT_TIER_KERNEL,
+	.algs		= KEYCRYPT_ALGS_ALL,
+	.owner		= THIS_MODULE,
+	.opts		= sw_opts,
+	.generate	= sw_generate,
+	.import		= sw_import,
+	.load		= sw_load,
+	.destroy	= sw_destroy,
+	.ctx_open	= sw_ctx_open,
+	.update		= sw_update,
+	.final		= sw_final,
+	.ctx_free	= sw_ctx_free,
+};
+
+static int __init keycrypt_sw_init(void)
+{
+	int ret = keycrypt_register_backend(&keycrypt_sw);
+
+	if (!ret)
+		pr_warn("kernel tier enabled: its keys are in clear in kernel memory while loaded\n");
+	return ret;
+}
+module_init(keycrypt_sw_init);
+
+static void __exit keycrypt_sw_exit(void)
+{
+	keycrypt_unregister_backend(&keycrypt_sw);
+}
+module_exit(keycrypt_sw_exit);
+
+MODULE_DESCRIPTION("keycrypt sw backend, of the kernel tier");
+MODULE_LICENSE("GPL");
diff --git a/security/keys/keycrypt/sw.h b/security/keys/keycrypt/sw.h
new file mode 100644
index 000000000000..30e24fb56ce3
--- /dev/null
+++ b/security/keys/keycrypt/sw.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * keycrypt - the sw backend's blob fields and loaded-key state
+ *
+ * Copyright (C) 2026 Rodolfo Giometti <giometti@enneenne.com>
+ */
+
+#ifndef _SECURITY_KEYS_KEYCRYPT_SW_H
+#define _SECURITY_KEYS_KEYCRYPT_SW_H
+
+#include <linux/types.h>
+
+#define KEYCRYPT_SW_VERSION	1
+#define KEYCRYPT_SW_SALT_LEN	32
+#define KEYCRYPT_SW_NONCE_LEN	12
+#define KEYCRYPT_SW_TAG_LEN	16
+#define KEYCRYPT_SW_DESC_MAX	255
+#define KEYCRYPT_SW_KEY_MAX	64
+
+/**
+ * struct keycrypt_sw_key - the sw backend's state for a loaded key
+ * @len: bytes in @key
+ * @key: the key, in clear
+ */
+struct keycrypt_sw_key {
+	size_t	len;
+	u8	key[KEYCRYPT_SW_KEY_MAX];
+};
+
+#endif /* _SECURITY_KEYS_KEYCRYPT_SW_H */
-- 
2.43.0

