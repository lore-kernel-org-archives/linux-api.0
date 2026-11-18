Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.156.87
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795010681;
	b=CYjwlxtyoPzxhhidNSWzXxydfiOaWQ50+xmP8ST7j1apT1NwjfL8SdxL+kR9MrCC+lfL
	 Y1P6uud3NP81R2dPws3vPkGrm0CJzUkY7by9PfKwBLJ7GlWhmJDgWf7We/jGKoAR3D1n+
	 ODOjClx3jGBCKCYm6sG5+mmwCMeGiYBj4FIBHC2U3DVrIDH9BARoMiAN40k0ZkDObgnhF
	 gCNtMwu4AxLSuDdHeTqAtGBlk4FuDQHIu5i3gylQeAl7BXYoLffHgM+1MPasvEq3O6s4I
	 h1WBJGxhDoUK7R0lMwQ3MITn11Q/yUpfXgrAXCFiEBBIjRNDaB988l2ACETvlsKNX6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795010681;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CMAE-Envelope;
	bh=zytyVC19xEXbb5X63vY6M3SRR7AUP2azHT3o3wfjjD4=;
	b=O53SmJ6JQCr3JoEfsnpk+cPgDBrvh16nF6USR76aa6hkkmleKDT8l9uXp2DLwxTK1xD2
	 F/UQzw3+u9/mosuzMhB6iAlONiuODtpG+6BN6OpNYAy88mPutLdHbuDrbW7MuNKNHjMim
	 Q6JlvjUsONBCkxGM0I5C8Xkoirhtmd8bTNqrMywCN86DYcp9NCwGZGhM0zi/TNV8TrhQJ
	 TzmQg65sVpMCT+B9xKxK1ekSy8Ti/Y4GvT2L0H/k6qmr+Bdya+e38TvgbhGk3Q9ir5lDT
	 b99ABmQrYH89jb6QjQmq2xrN/nlnuVrsVhgAM3GADBtL+4EUZj3rSObaveOoSr4rkfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=enneenne.com;
	spf=pass smtp.mailfrom=enneenne.com;
	dkim=pass header.d=aruba.it header.i=@aruba.it header.a=rsa-sha256 header.s=a1 header.b=WKxbXt7k;
	arc=none smtp.remote-ip=62.149.156.87
Received: from smtpcmd0987.aruba.it (smtpcmd0987.aruba.it [62.149.156.87])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8018606A330
	for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 14:04:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8018606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=enneenne.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=enneenne.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.a=rsa-sha256 header.s=a1 header.b=WKxbXt7k
Received: from polimar.tail4f75e6.ts.net ([101.57.122.26])
	by Aruba SMTP with ESMTPSA
	id TgGvxLK1X6q8sTgGzxc6MR; Wed, 18 Nov 2026 15:04:30 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1795010670; bh=n41lTxgDIMigqaCL6ajMk5RYGrDT0zdJ1a4SEDn8Hn4=;
	h=From:To:Subject:Date:MIME-Version;
	b=WKxbXt7kT0sdQ5Kev/+snXACrXL7UM1hcJhXnQ0G19zM6vL0j19iwZfk9Qsks33Wa
	 ajNkdLjUocZXethtYndsnkfqaLUkTwCkOGFevnQCtPMNkMkNhpZSD6gKjYYkpdJT0s
	 /L9WNUwjaqawDQsTo28yGglUGzmS1ltDkxEEnm8cgHtgd1HvP9N/N52MhEGk7txSwx
	 Qb0ItuETz7q7xG416M3xXnsLb2WYUrhIzCNarh2R/y702imQ4iZuP1HcUPrZPyFJEJ
	 W11taG03K+Zh1F+vcP8vz1dD/ISkEQLCZQoCT7YDe4Fa2GOZzqQvgx7m3fhziLtUvE
	 F4y7aORzJuuvA==
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
Subject: [RFC PATCH 1/9] KEYS: keycrypt: Add a key type for keys user space never reads
Date: Wed, 18 Nov 2026 15:04:13 +0100
Message-ID: <20261118140421.584086-2-giometti@enneenne.com>
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

Programs that encrypt, decrypt or authenticate data with a symmetric
key today hold that key: in a file, in a "user" or "logon" key handed
to AF_ALG, or in memory a compromised process can read. On a device
with a TEE or a crypto engine able to keep keys, nothing lets an
ordinary program use such a key through a kernel interface, with the
key fixed to one algorithm and purpose and never released.

Add the "keycrypt" key type. A key is created by a backend ("new"),
sealed from a key given in clear by CAP_SYS_ADMIN ("import", behind
CONFIG_KEYCRYPT_IMPORT), or re-created from the blob its backend
sealed ("load"); its algorithm (aes256-cbc, hmac-sha256), purpose and
protection tier (kernel, tee, hsm) are fixed at creation and
authenticated in the blob. User space reads only the blob.

This adds a user API: KEYCTL_CRYPT_OPEN opens an operation context on
a key, a file descriptor whose ioctls run the operation in the key's
backend, as the documentation describes. Two system policies come as
sysctls and boot parameters, both one-way: the system tier, a floor on
the use of keys whose starting value is chosen at build time
(CONFIG_KEYCRYPT_SYSTEM_TIER_*), and an import switch.

Backends register through keycrypt_register_backend(); none is added
here, so a well-formed add_key() fails with ENODEV until one is.

Signed-off-by: Rodolfo Giometti <giometti@enneenne.com>
---
 .../admin-guide/kernel-parameters.txt         |   20 +
 .../userspace-api/ioctl/ioctl-number.rst      |    2 +
 include/keys/keycrypt.h                       |  150 +++
 include/uapi/linux/keycrypt.h                 |  143 +++
 include/uapi/linux/keyctl.h                   |    1 +
 security/keys/Kconfig                         |    2 +
 security/keys/Makefile                        |    1 +
 security/keys/compat.c                        |    3 +
 security/keys/internal.h                      |   12 +
 security/keys/keycrypt/Kconfig                |   72 ++
 security/keys/keycrypt/Makefile               |    3 +
 security/keys/keycrypt/core.c                 | 1070 +++++++++++++++++
 security/keys/keycrypt/ctx.c                  |  530 ++++++++
 security/keys/keycrypt/keycrypt.h             |  173 +++
 security/keys/keyctl.c                        |    5 +
 15 files changed, 2187 insertions(+)
 create mode 100644 include/keys/keycrypt.h
 create mode 100644 include/uapi/linux/keycrypt.h
 create mode 100644 security/keys/keycrypt/Kconfig
 create mode 100644 security/keys/keycrypt/Makefile
 create mode 100644 security/keys/keycrypt/core.c
 create mode 100644 security/keys/keycrypt/ctx.c
 create mode 100644 security/keys/keycrypt/keycrypt.h

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 0b3c140babd9..62d44a5225e4 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2935,6 +2935,26 @@ Kernel parameters
 			for Movable pages.  "nn[KMGTPE]", "nn%", and "mirror"
 			are exclusive, so you cannot specify multiple forms.
 
+	keycrypt.import=	[KEYS] Allow importing clear key material into
+			keycrypt keys (CONFIG_KEYCRYPT_IMPORT).
+			Format: <bool>
+			Default: 1. 0 disables import until reboot; an
+			invalid value, or turning it back on, is
+			ignored, with a kernel warning. The
+			kernel.keys.keycrypt_import sysctl can later
+			turn it off the same way, but never back on.
+
+	keycrypt.system_tier=	[KEYS] Lowest protection tier a keycrypt key
+			may be used at; keys of a lower tier can still
+			be created and loaded.
+			Format: { kernel | tee | hsm }
+			Default: the CONFIG_KEYCRYPT_SYSTEM_TIER_*
+			choice, kernel unless set. Can only be raised,
+			here or later through the
+			kernel.keys.keycrypt_system_tier sysctl; an
+			invalid name, or a tier lower than already set,
+			is ignored, with a kernel warning.
+
 	kfence.burst=	[MM,KFENCE] The number of additional successive
 			allocations to be attempted through KFENCE for each
 			sample interval.
diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
index dbe462040999..efdace54085b 100644
--- a/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -387,6 +387,8 @@ Code  Seq#    Include File                                             Comments
                                                                        <mailto:linux-hyperv@vger.kernel.org>
 0xBA  00-0F  uapi/linux/liveupdate.h                                   Pasha Tatashin
                                                                        <mailto:pasha.tatashin@soleen.com>
+0xBB  00-0F  uapi/linux/keycrypt.h                                     keycrypt
+                                                                       <mailto:keyrings@vger.kernel.org>
 0xC0  00-0F  linux/usb/iowarrior.h
 0xCA  00-0F  uapi/misc/cxl.h                                           Dead since 6.15
 0xCA  10-2F  uapi/misc/ocxl.h
diff --git a/include/keys/keycrypt.h b/include/keys/keycrypt.h
new file mode 100644
index 000000000000..8aae3d47e697
--- /dev/null
+++ b/include/keys/keycrypt.h
@@ -0,0 +1,150 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * keycrypt - the interface for the backends that hold and use the keys
+ *
+ * Copyright (C) 2026 Rodolfo Giometti <giometti@enneenne.com>
+ */
+
+#ifndef _KEYS_KEYCRYPT_H
+#define _KEYS_KEYCRYPT_H
+
+#include <linux/bits.h>
+#include <linux/types.h>
+#include <uapi/linux/keycrypt.h>
+
+struct module;
+struct keycrypt_handle;
+
+#define KEYCRYPT_ALGS_ALL		(BIT(KEYCRYPT_ALG_AES256_CBC) | \
+					 BIT(KEYCRYPT_ALG_HMAC_SHA256))
+
+#define KEYCRYPT_BACKEND_DATA_MAX	4096
+
+/*
+ * Header of a blob: "KCR", version, flags, algorithm, purpose (le16),
+ * tier, origin, name length, then the name
+ */
+#define KEYCRYPT_HEADER_FIXED		11
+#define KEYCRYPT_HEADER_MAX		(KEYCRYPT_HEADER_FIXED + \
+					 KEYCRYPT_BACKEND_NAME_MAX)
+
+/**
+ * struct keycrypt_meta - metadata fixed when a key is created
+ * @alg: KEYCRYPT_ALG_*
+ * @purpose: KEYCRYPT_PURPOSE_* mask
+ * @tier: KEYCRYPT_TIER_* the key was sealed at
+ * @origin: KEYCRYPT_ORIGIN_*
+ * @backend: name of the backend, NUL terminated
+ */
+struct keycrypt_meta {
+	u8	alg;
+	u16	purpose;
+	u8	tier;
+	u8	origin;
+	char	backend[KEYCRYPT_BACKEND_NAME_MAX + 1];
+};
+
+/**
+ * struct keycrypt_blob - data a backend creates for a new key
+ * @data: allocated with kmalloc() by the backend, freed by the core on
+ *	every path, success or not
+ * @len: 1 to KEYCRYPT_BACKEND_DATA_MAX bytes
+ */
+struct keycrypt_blob {
+	u8	*data;
+	u32	len;
+};
+
+/**
+ * struct keycrypt_key - a key as its backend sees it
+ * @meta: its metadata
+ * @hdr: the header stored in the blob; the backend's data must
+ *	authenticate exactly these bytes
+ * @hdr_len: bytes in @hdr
+ * @data: the backend's data, as stored
+ * @data_len: bytes in @data
+ * @priv: the backend's state for this key, set by @load and released by
+ *	@destroy
+ */
+struct keycrypt_key {
+	struct keycrypt_meta	meta;
+	const u8		*hdr;
+	u32			hdr_len;
+	const u8		*data;
+	u32			data_len;
+	void			*priv;
+};
+
+/**
+ * struct keycrypt_backend - a place where keycrypt keys live
+ * @name: [a-z0-9_-], at most KEYCRYPT_BACKEND_NAME_MAX; it names a sealing
+ *	domain and is stored in every blob
+ * @tier: KEYCRYPT_TIER_*; _TEE and _HSM declare that the backend meets
+ *	Documentation/security/keys/keycrypt.rst, "Backend requirements"
+ * @algs: BIT(KEYCRYPT_ALG_*) mask of what it supports
+ * @owner: module holding the callbacks, pinned by every key
+ * @opts: NULL-terminated list of the option keys it accepts ("master"
+ *	for "master=<value>"); the core refuses any other, and duplicates
+ * @generate: create a key; its data must authenticate @hdr
+ * @import: seal a key given in clear, likewise; NULL if not supported
+ * @load: check that @k's data authenticates @k->hdr (-EBADMSG if not) and
+ *	set @k->priv if needed, leaving it unset on failure
+ * @destroy: release @k->priv; called at most once per key, and last
+ * @ctx_open: start @op on @k and set *@ctx, releasing what it acquired on
+ *	failure; @iv (16 bytes) is the aes256-cbc IV, used as given
+ * @update: process @len bytes from @in to @out, in place allowed; @out is
+ *	NULL for MAC and VERIFY
+ * @final: end the context; MAC and VERIFY write the 32-byte tag to @out
+ *	and set *@len, the ciphers set it to 0
+ * @verify: end a VERIFY context by comparing the tag with @expected where
+ *	the key lives, 0 or -EBADMSG, never the tag. Required of a _TEE or
+ *	_HSM backend with context callbacks offering hmac-sha256
+ * @ctx_free: release @ctx, once, however the context ends
+ * @handle: core private
+ *
+ * @opts given to a callback are the "key=value" options the core did not
+ * consume, or NULL. Errors of @generate, @import and @load reach user
+ * space as given for -ENOMEM, -EINVAL, -EBADMSG, -ENOKEY, -EKEYREJECTED,
+ * -EACCES, -EINTR and -ERESTARTSYS, those of the context callbacks only
+ * for -ENOMEM, -EINTR, -ERESTARTSYS and -EBADMSG; any other is -EIO.
+ *
+ * The callbacks may sleep and run concurrently, with the backend's handle
+ * held: they must not call into keycrypt, and must not wait without bound.
+ * The four context callbacks are all given or all NULL; without them the
+ * backend's keys cannot be used (KEYCTL_CRYPT_OPEN gives -ENODEV).
+ */
+struct keycrypt_backend {
+	const char	*name;
+	u8		tier;
+	u32		algs;
+	struct module	*owner;
+	const char * const *opts;
+
+	int (*generate)(struct keycrypt_backend *b,
+			const struct keycrypt_meta *m, const u8 *hdr,
+			u32 hdr_len, const char *opts,
+			struct keycrypt_blob *out);
+	int (*import)(struct keycrypt_backend *b,
+		      const struct keycrypt_meta *m, const u8 *hdr,
+		      u32 hdr_len, const char *opts, const u8 *key,
+		      size_t keylen, struct keycrypt_blob *out);
+	int (*load)(struct keycrypt_backend *b, struct keycrypt_key *k,
+		    const char *opts);
+	void (*destroy)(struct keycrypt_backend *b, struct keycrypt_key *k);
+	int (*ctx_open)(struct keycrypt_backend *b, struct keycrypt_key *k,
+			u32 op, u8 *iv, void **ctx);
+	int (*update)(struct keycrypt_backend *b, void *ctx, const u8 *in,
+		      u8 *out, size_t len);
+	int (*final)(struct keycrypt_backend *b, void *ctx, u8 *out,
+		     size_t out_size, size_t *len);
+	int (*verify)(struct keycrypt_backend *b, void *ctx,
+		      const u8 *expected);
+	void (*ctx_free)(struct keycrypt_backend *b, void *ctx);
+
+	struct keycrypt_handle *handle;
+};
+
+int keycrypt_register_backend(struct keycrypt_backend *b);
+void keycrypt_unregister_backend(struct keycrypt_backend *b);
+
+#endif /* _KEYS_KEYCRYPT_H */
diff --git a/include/uapi/linux/keycrypt.h b/include/uapi/linux/keycrypt.h
new file mode 100644
index 000000000000..c03348579f62
--- /dev/null
+++ b/include/uapi/linux/keycrypt.h
@@ -0,0 +1,143 @@
+/* SPDX-License-Identifier: GPL-2.0-only WITH Linux-syscall-note */
+/*
+ * keycrypt - the user-space API
+ *
+ * Copyright (C) 2026 Rodolfo Giometti <giometti@enneenne.com>
+ */
+
+#ifndef _UAPI_LINUX_KEYCRYPT_H
+#define _UAPI_LINUX_KEYCRYPT_H
+
+#include <linux/ioctl.h>
+#include <linux/types.h>
+
+/* Protection tiers, lowest first; the gaps leave room for more */
+#define KEYCRYPT_TIER_KERNEL	10	/* the kernel itself */
+#define KEYCRYPT_TIER_TEE	20	/* a trusted execution environment */
+/* as TEE, in dedicated hardware apart from the CPU running the kernel */
+#define KEYCRYPT_TIER_HSM	30
+
+/*
+ * Operations of KEYCTL_CRYPT_OPEN; which ones a key allows depends on its
+ * algorithm and purposes, see Documentation/security/keys/keycrypt.rst
+ */
+#define KEYCRYPT_OP_ENCRYPT	1
+#define KEYCRYPT_OP_DECRYPT	2
+#define KEYCRYPT_OP_MAC		3
+#define KEYCRYPT_OP_VERIFY	4
+
+/*
+ * KEYCTL_CRYPT_OPEN flags. KEYCRYPT_OPEN_CALLER_IV: encrypt with an IV
+ * the caller gives instead of one the kernel draws, for data formats
+ * that fix or derive the IV themselves; the caller then answers for
+ * its unpredictability. Without it, the kernel draws the IV.
+ */
+#define KEYCRYPT_OPEN_CALLER_IV	0x0001
+
+/* struct keycrypt_info: the key's algorithm */
+#define KEYCRYPT_ALG_AES256_CBC		1
+#define KEYCRYPT_ALG_HMAC_SHA256	2
+
+/* struct keycrypt_info: the key's purpose mask */
+#define KEYCRYPT_PURPOSE_ENCRYPT	0x0001
+#define KEYCRYPT_PURPOSE_DECRYPT	0x0002
+#define KEYCRYPT_PURPOSE_MAC		0x0004
+#define KEYCRYPT_PURPOSE_VERIFY		0x0008
+
+/* struct keycrypt_info: the key's origin */
+#define KEYCRYPT_ORIGIN_GENERATED	1
+#define KEYCRYPT_ORIGIN_IMPORTED	2
+
+/*
+ * A backend's name: at most this many characters, then a NUL (struct
+ * keycrypt_info's @backend has room for more)
+ */
+#define KEYCRYPT_BACKEND_NAME_MAX	16
+
+/**
+ * struct keycrypt_open_params - KEYCTL_CRYPT_OPEN parameters
+ * @op: KEYCRYPT_OP_*
+ * @accepted_min_tier: KEYCRYPT_TIER_*: refuse a key of a lower tier; 0:
+ *	no requirement beyond the system tier
+ * @flags: KEYCRYPT_OPEN_*
+ * @__reserved: must be zero
+ * @iv: aes256-cbc: the IV, given for decryption and with
+ *	KEYCRYPT_OPEN_CALLER_IV, otherwise written back by the kernel; MAC
+ *	and VERIFY: zero
+ *
+ * Extended by size (copy_struct_from_user()); at least
+ * KEYCRYPT_OPEN_PARAMS_SIZE_VER0 bytes.
+ */
+struct keycrypt_open_params {
+	__u32	op;
+	__u32	accepted_min_tier;
+	__u32	flags;
+	__u32	__reserved;
+	__u8	iv[16];
+};
+
+#define KEYCRYPT_OPEN_PARAMS_SIZE_VER0	32
+
+/**
+ * struct keycrypt_update - KEYCRYPT_IOC_UPDATE argument
+ * @in: user pointer to @len input bytes
+ * @out: user pointer to @len output bytes; 0 for MAC and VERIFY
+ * @len: bytes, at most KEYCRYPT_UPDATE_MAX; aes256-cbc: a multiple of 16
+ * @flags: must be zero
+ */
+struct keycrypt_update {
+	__u64	in;
+	__u64	out;
+	__u32	len;
+	__u32	flags;
+};
+
+/**
+ * struct keycrypt_final - KEYCRYPT_IOC_FINAL argument
+ * @out: user pointer; MAC: the tag, written, @len room in, bytes out;
+ *	VERIFY: the expected 32-byte tag, read, @len must be 32, 0 back;
+ *	aes256-cbc: 0, and @len comes back 0
+ * @len: see @out
+ * @flags: must be zero
+ */
+struct keycrypt_final {
+	__u64	out;
+	__u32	len;
+	__u32	flags;
+};
+
+#define KEYCRYPT_UPDATE_MAX	65536
+#define KEYCRYPT_MAC_LEN	32
+
+/**
+ * struct keycrypt_info - KEYCRYPT_IOC_INFO argument, written by the kernel
+ * @op: KEYCRYPT_OP_* the context was opened for
+ * @alg: KEYCRYPT_ALG_* of the key
+ * @purpose: KEYCRYPT_PURPOSE_* mask of the key
+ * @tier: KEYCRYPT_TIER_* the key was sealed at
+ * @origin: KEYCRYPT_ORIGIN_*
+ * @accepted_min_tier: the KEYCTL_CRYPT_OPEN @accepted_min_tier the
+ *	context was opened with, 0 for none
+ * @__reserved: zero; a field added here is zero when the kernel does not
+ *	report it, and zero is never one of its values (@accepted_min_tier,
+ *	whose 0 means none, is the exception)
+ * @backend: name of the key's backend, NUL terminated, the rest zero
+ */
+struct keycrypt_info {
+	__u32	op;
+	__u32	alg;
+	__u32	purpose;
+	__u32	tier;
+	__u32	origin;
+	__u32	accepted_min_tier;
+	__u32	__reserved[2];
+	char	backend[32];
+};
+
+#define KEYCRYPT_IOC_MAGIC	0xBB
+#define KEYCRYPT_IOC_UPDATE	_IOW(KEYCRYPT_IOC_MAGIC, 1, struct keycrypt_update)
+#define KEYCRYPT_IOC_FINAL	_IOWR(KEYCRYPT_IOC_MAGIC, 2, struct keycrypt_final)
+/* 3: KEYCRYPT_IOC_SEGMENT, with the aes256-gcm-stream algorithm */
+#define KEYCRYPT_IOC_INFO	_IOR(KEYCRYPT_IOC_MAGIC, 4, struct keycrypt_info)
+
+#endif /* _UAPI_LINUX_KEYCRYPT_H */
diff --git a/include/uapi/linux/keyctl.h b/include/uapi/linux/keyctl.h
index 00cc0942203e..1532cc76ab38 100644
--- a/include/uapi/linux/keyctl.h
+++ b/include/uapi/linux/keyctl.h
@@ -73,6 +73,7 @@
 #define KEYCTL_MOVE			30	/* Move keys between keyrings */
 #define KEYCTL_CAPABILITIES		31	/* Find capabilities of keyrings subsystem */
 #define KEYCTL_WATCH_KEY		32	/* Watch a key or ring of keys for changes */
+#define KEYCTL_CRYPT_OPEN		33	/* Open a keycrypt operation context */
 
 /* keyctl structures */
 struct keyctl_dh_params {
diff --git a/security/keys/Kconfig b/security/keys/Kconfig
index f4510d8cb485..fb0f48f218ef 100644
--- a/security/keys/Kconfig
+++ b/security/keys/Kconfig
@@ -128,4 +128,6 @@ config KEY_NOTIFICATIONS
 	  This makes use of pipes to handle the notification buffer and
 	  provides KEYCTL_WATCH_KEY to enable/disable watches.
 
+source "security/keys/keycrypt/Kconfig"
+
 endif # KEYS
diff --git a/security/keys/Makefile b/security/keys/Makefile
index 5f40807f05b3..82583db1704b 100644
--- a/security/keys/Makefile
+++ b/security/keys/Makefile
@@ -30,3 +30,4 @@ obj-$(CONFIG_ASYMMETRIC_KEY_TYPE) += keyctl_pkey.o
 obj-$(CONFIG_BIG_KEYS) += big_key.o
 obj-$(CONFIG_TRUSTED_KEYS) += trusted-keys/
 obj-$(CONFIG_ENCRYPTED_KEYS) += encrypted-keys/
+obj-$(CONFIG_KEYCRYPT) += keycrypt/
diff --git a/security/keys/compat.c b/security/keys/compat.c
index 1545efdca562..80ea06e59ee2 100644
--- a/security/keys/compat.c
+++ b/security/keys/compat.c
@@ -126,6 +126,9 @@ COMPAT_SYSCALL_DEFINE5(keyctl, u32, option,
 	case KEYCTL_WATCH_KEY:
 		return keyctl_watch_key(arg2, arg3, arg4);
 
+	case KEYCTL_CRYPT_OPEN:
+		return keyctl_crypt_open(arg2, compat_ptr(arg3), arg4, arg5);
+
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/security/keys/internal.h b/security/keys/internal.h
index b7b622bc36a1..69de149a0609 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -358,6 +358,18 @@ static inline long keyctl_watch_key(key_serial_t key_id, int watch_fd, int watch
 }
 #endif
 
+#ifdef CONFIG_KEYCRYPT
+extern long keyctl_crypt_open(key_serial_t id, void __user *uparams,
+			      size_t usize, unsigned long flags);
+#else
+static inline long keyctl_crypt_open(key_serial_t id,
+				     void __user *uparams,
+				     size_t usize, unsigned long flags)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
 /*
  * Debugging key validation
  */
diff --git a/security/keys/keycrypt/Kconfig b/security/keys/keycrypt/Kconfig
new file mode 100644
index 000000000000..e1d1b8e2a58b
--- /dev/null
+++ b/security/keys/keycrypt/Kconfig
@@ -0,0 +1,72 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+config KEYCRYPT
+	bool "Keys user space uses for cryptography but never reads"
+	select CRYPTO_LIB_UTILS
+	help
+	  This option provides the "keycrypt" key type: symmetric keys whose
+	  algorithm, purpose and protection tier are fixed when they are
+	  created, held by a backend such as dedicated hardware or a
+	  trusted execution environment. User space keeps only a blob the
+	  backend sealed, and never sees a key the backend created; a key
+	  of the kernel tier is in clear in kernel memory while loaded.
+
+	  See Documentation/security/keys/keycrypt.rst.
+
+	  If you are unsure as to whether this is required, answer N.
+
+config KEYCRYPT_IMPORT
+	bool "Allow keycrypt keys to be imported in clear"
+	depends on KEYCRYPT
+	help
+	  Allow a process with CAP_SYS_ADMIN to give a keycrypt backend a
+	  key in clear, for the backend to seal it ("import"). Such keys
+	  existed outside the backend and are marked "imported". Saying N
+	  refuses the import command; blobs of keys imported elsewhere
+	  still load.
+
+	  If you are unsure as to whether this is required, answer N.
+
+choice
+	prompt "System keycrypt tier at boot"
+	default KEYCRYPT_SYSTEM_TIER_KERNEL
+	depends on KEYCRYPT
+	help
+	  The lowest tier a keycrypt key may be used at when the kernel
+	  starts: KEYCTL_CRYPT_OPEN refuses a key of a lower tier, which
+	  can still be created and loaded. The keycrypt.system_tier= boot
+	  parameter and the kernel.keys.keycrypt_system_tier sysctl can
+	  only raise it, so a signed kernel image sets a floor its command
+	  line cannot lower.
+
+	  The default sets no floor: which backends a kernel builds says
+	  nothing about which will be present when it runs (a
+	  distribution kernel builds them all), so a product that knows
+	  its backends raises it here or on its command line.
+
+config KEYCRYPT_SYSTEM_TIER_KERNEL
+	bool "Kernel"
+	help
+	  Keys of every tier, the kernel tier included, can be used until
+	  the keycrypt.system_tier= boot parameter or the
+	  kernel.keys.keycrypt_system_tier sysctl raises the system tier.
+	  A system with no backend of the kernel tier built has no key of
+	  that tier to use.
+
+config KEYCRYPT_SYSTEM_TIER_TEE
+	bool "TEE"
+	help
+	  Keys whose use a trusted execution environment or the hardware
+	  checks: keys of the kernel tier are refused at every
+	  KEYCTL_CRYPT_OPEN; the tee and hsm tiers can be used. For a
+	  system where OP-TEE or an hsm backend holds the keys.
+
+config KEYCRYPT_SYSTEM_TIER_HSM
+	bool "HSM"
+	help
+	  Keys whose use dedicated hardware apart from the CPU checks: a
+	  key of any tier but hsm is refused at every KEYCTL_CRYPT_OPEN.
+	  Choose it only on a system with a backend of the hsm tier, or no
+	  keycrypt key can be used at all.
+
+endchoice
diff --git a/security/keys/keycrypt/Makefile b/security/keys/keycrypt/Makefile
new file mode 100644
index 000000000000..8910fb0156e7
--- /dev/null
+++ b/security/keys/keycrypt/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+obj-y += core.o ctx.o
diff --git a/security/keys/keycrypt/core.c b/security/keys/keycrypt/core.c
new file mode 100644
index 000000000000..debd0845621e
--- /dev/null
+++ b/security/keys/keycrypt/core.c
@@ -0,0 +1,1070 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * keycrypt - the key type and the backend registry
+ *
+ * Copyright (C) 2026 Rodolfo Giometti <giometti@enneenne.com>
+ */
+
+#define pr_fmt(fmt) "keycrypt: " fmt
+
+#include <linux/capability.h>
+#include <linux/err.h>
+#include <linux/hex.h>
+#include <linux/init.h>
+#include <linux/key-type.h>
+#include <linux/kstrtox.h>
+#include <linux/limits.h>
+#include <linux/minmax.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/seq_file.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/sysctl.h>
+#include <linux/unaligned.h>
+#include "keycrypt.h"
+
+#define KEYCRYPT_MAGIC		"KCR"
+#define KEYCRYPT_MAGIC_LEN	3
+#define KEYCRYPT_VERSION	1
+
+struct keycrypt_name {
+	u8		value;
+	const char	*name;
+};
+
+static const struct keycrypt_name keycrypt_algs[] = {
+	{ KEYCRYPT_ALG_AES256_CBC,	"aes256-cbc" },
+	{ KEYCRYPT_ALG_HMAC_SHA256,	"hmac-sha256" },
+};
+
+static const struct keycrypt_name keycrypt_tiers[] = {
+	{ KEYCRYPT_TIER_KERNEL,		"kernel" },
+	{ KEYCRYPT_TIER_TEE,		"tee" },
+	{ KEYCRYPT_TIER_HSM,		"hsm" },
+};
+
+static const struct keycrypt_name keycrypt_origins[] = {
+	{ KEYCRYPT_ORIGIN_GENERATED,	"generated" },
+	{ KEYCRYPT_ORIGIN_IMPORTED,	"imported" },
+};
+
+static int keycrypt_value(const struct keycrypt_name *t, size_t n,
+			  const char *s)
+{
+	size_t i;
+
+	for (i = 0; i < n; i++)
+		if (!strcmp(t[i].name, s))
+			return t[i].value;
+	return -EINVAL;
+}
+
+static const char *keycrypt_name(const struct keycrypt_name *t, size_t n,
+				 u8 v)
+{
+	size_t i;
+
+	for (i = 0; i < n; i++)
+		if (t[i].value == v)
+			return t[i].name;
+	return NULL;
+}
+
+#define KEYCRYPT_VALUE(t, s)	keycrypt_value(t, sizeof(t) / sizeof((t)[0]), s)
+#define KEYCRYPT_NAME(t, v)	keycrypt_name(t, sizeof(t) / sizeof((t)[0]), v)
+
+bool keycrypt_tier_valid(u32 tier)
+{
+	return tier <= U8_MAX && KEYCRYPT_NAME(keycrypt_tiers, tier);
+}
+
+static LIST_HEAD(keycrypt_handles);
+static DEFINE_MUTEX(keycrypt_lock);
+
+static bool keycrypt_purpose_valid(u8 alg, u16 purpose)
+{
+	switch (alg) {
+	case KEYCRYPT_ALG_AES256_CBC:
+		return purpose && !(purpose & ~(KEYCRYPT_PURPOSE_ENCRYPT |
+						KEYCRYPT_PURPOSE_DECRYPT));
+	case KEYCRYPT_ALG_HMAC_SHA256:
+		return purpose && !(purpose & ~(KEYCRYPT_PURPOSE_MAC |
+						KEYCRYPT_PURPOSE_VERIFY));
+	}
+	return false;
+}
+
+/* [a-z0-9_-], ASCII only: islower() also accepts Latin-1 letters */
+static bool keycrypt_name_valid(const char *s, size_t n)
+{
+	size_t i;
+
+	if (!n || n > KEYCRYPT_BACKEND_NAME_MAX)
+		return false;
+	for (i = 0; i < n; i++)
+		if (!((s[i] >= 'a' && s[i] <= 'z') ||
+		      (s[i] >= '0' && s[i] <= '9') || s[i] == '-' ||
+		      s[i] == '_'))
+			return false;
+	return true;
+}
+
+static char *keycrypt_next_token(char **s)
+{
+	char *t;
+
+	do {
+		t = strsep(s, " \t\n");
+	} while (t && !*t);
+	return t;
+}
+
+static int keycrypt_parse_purpose(char *s, u16 *purpose)
+{
+	char *p;
+
+	*purpose = 0;
+	while ((p = strsep(&s, ",")) != NULL) {
+		u16 bit;
+
+		if (!strcmp(p, "encrypt"))
+			bit = KEYCRYPT_PURPOSE_ENCRYPT;
+		else if (!strcmp(p, "decrypt"))
+			bit = KEYCRYPT_PURPOSE_DECRYPT;
+		else if (!strcmp(p, "mac"))
+			bit = KEYCRYPT_PURPOSE_MAC;
+		else if (!strcmp(p, "verify"))
+			bit = KEYCRYPT_PURPOSE_VERIFY;
+		else
+			return -EINVAL;
+		if (*purpose & bit)
+			return -EINVAL;
+		*purpose |= bit;
+	}
+	return 0;
+}
+
+static int keycrypt_parse_tier(const char *s, u8 *tier)
+{
+	int n;
+
+	if (*tier)
+		return -EINVAL;
+	n = KEYCRYPT_VALUE(keycrypt_tiers, s);
+	if (n < 0)
+		return n;
+	*tier = n;
+	return 0;
+}
+
+static int keycrypt_add_opt(struct keycrypt_req *req, const char *t)
+{
+	size_t len = strlen(req->opts), n = strlen(t);
+
+	if (len + 1 + n + 1 > req->opts_size)
+		return -EINVAL;
+	if (len)
+		req->opts[len++] = ' ';
+	memcpy(req->opts + len, t, n + 1);
+	return 0;
+}
+
+static int keycrypt_parse_option(char *t, struct keycrypt_req *req)
+{
+	char *v = strchr(t, '=');
+	bool load = req->cmd == KEYCRYPT_CMD_LOAD;
+
+	if (v == t || !v[1])
+		return -EINVAL;
+	*v++ = '\0';
+	if (!strcmp(t, "accepted-min-tier"))
+		return load ? keycrypt_parse_tier(v, &req->accepted_min_tier) :
+			      -EINVAL;
+	if (!strcmp(t, "backend")) {
+		if (load || *req->backend || !keycrypt_name_valid(v, strlen(v)))
+			return -EINVAL;
+		strscpy(req->backend, v);
+		return 0;
+	}
+	if (!strcmp(t, "min-tier"))
+		return load ? -EINVAL : keycrypt_parse_tier(v, &req->min_tier);
+	if (!strcmp(t, "purpose")) {
+		if (!load || req->want_purpose)
+			return -EINVAL;
+		if (keycrypt_parse_purpose(v, &req->want_purpose))
+			return -EINVAL;
+		if (!keycrypt_purpose_valid(KEYCRYPT_ALG_AES256_CBC,
+					    req->want_purpose) &&
+		    !keycrypt_purpose_valid(KEYCRYPT_ALG_HMAC_SHA256,
+					    req->want_purpose))
+			return -EINVAL;
+		return 0;
+	}
+	if (!strcmp(t, "tier"))
+		return load ? -EINVAL : keycrypt_parse_tier(v, &req->tier);
+	v[-1] = '=';
+	return keycrypt_add_opt(req, t);
+}
+
+/*
+ * "new <alg> <purpose>[,<purpose>...] [<option>=<value>...]"
+ * "import <alg> <purpose>[,<purpose>...] [<option>=<value>...] <hex key>"
+ * "load <hex blob> [<option>=<value>...]"
+ *
+ * req->opts and req->opts_size must be set by the caller.
+ */
+static int keycrypt_parse(char *s, struct keycrypt_req *req)
+{
+	size_t opts_size = req->opts_size;
+	char *opts = req->opts;
+	char *t;
+	int n, ret;
+
+	memset(req, 0, sizeof(*req));
+	req->opts = opts;
+	req->opts_size = opts_size;
+	opts[0] = '\0';
+
+	t = keycrypt_next_token(&s);
+	if (!t)
+		return -EINVAL;
+	if (!strcmp(t, "load")) {
+		req->cmd = KEYCRYPT_CMD_LOAD;
+		req->hex = keycrypt_next_token(&s);
+		if (!req->hex)
+			return -EINVAL;
+		while ((t = keycrypt_next_token(&s)) != NULL) {
+			if (!strchr(t, '='))
+				return -EINVAL;
+			ret = keycrypt_parse_option(t, req);
+			if (ret)
+				return ret;
+		}
+		return 0;
+	}
+	if (!strcmp(t, "new"))
+		req->cmd = KEYCRYPT_CMD_NEW;
+	else if (!strcmp(t, "import"))
+		req->cmd = KEYCRYPT_CMD_IMPORT;
+	else
+		return -EINVAL;
+
+	t = keycrypt_next_token(&s);
+	if (!t)
+		return -EINVAL;
+	n = KEYCRYPT_VALUE(keycrypt_algs, t);
+	if (n < 0)
+		return n;
+	req->alg = n;
+
+	t = keycrypt_next_token(&s);
+	if (!t)
+		return -EINVAL;
+	ret = keycrypt_parse_purpose(t, &req->purpose);
+	if (ret)
+		return ret;
+	if (!keycrypt_purpose_valid(req->alg, req->purpose))
+		return -EINVAL;
+
+	while ((t = keycrypt_next_token(&s)) != NULL) {
+		if (req->hex)
+			return -EINVAL;
+		if (strchr(t, '=')) {
+			ret = keycrypt_parse_option(t, req);
+			if (ret)
+				return ret;
+			continue;
+		}
+		if (req->cmd != KEYCRYPT_CMD_IMPORT)
+			return -EINVAL;
+		req->hex = t;
+	}
+	if (req->tier && req->min_tier)
+		return -EINVAL;
+	if (req->cmd == KEYCRYPT_CMD_IMPORT && !req->hex)
+		return -EINVAL;
+	return 0;
+}
+
+static int keycrypt_meta_header(const struct keycrypt_meta *m,
+				u8 *buf, size_t len)
+{
+	size_t n = strnlen(m->backend, sizeof(m->backend));
+	size_t need = KEYCRYPT_HEADER_FIXED + n;
+
+	if (!keycrypt_name_valid(m->backend, n))
+		return -EINVAL;
+	if (len < need)
+		return -ENOSPC;
+	memcpy(buf, KEYCRYPT_MAGIC, KEYCRYPT_MAGIC_LEN);
+	buf[3] = KEYCRYPT_VERSION;
+	buf[4] = 0;
+	buf[5] = m->alg;
+	put_unaligned_le16(m->purpose, buf + 6);
+	buf[8] = m->tier;
+	buf[9] = m->origin;
+	buf[10] = n;
+	memcpy(buf + KEYCRYPT_HEADER_FIXED, m->backend, n);
+	return need;
+}
+
+static void keycrypt_payload_init(struct keycrypt_payload *p,
+				  const struct keycrypt_meta *m,
+				  u32 hdr_len, u32 data_len)
+{
+	INIT_LIST_HEAD(&p->node);
+	p->key.meta = *m;
+	p->key.hdr = p->blob;
+	p->key.hdr_len = hdr_len;
+	p->key.data = p->blob + hdr_len + 4;
+	p->key.data_len = data_len;
+	p->blob_len = hdr_len + 4 + data_len;
+}
+
+static int keycrypt_payload_build(const struct keycrypt_meta *m,
+				  const u8 *hdr, u32 hdr_len,
+				  const u8 *data, u32 len,
+				  struct keycrypt_payload **out)
+{
+	struct keycrypt_payload *p;
+
+	if (!data || !len || len > KEYCRYPT_BACKEND_DATA_MAX)
+		return -EIO;
+	p = kzalloc_flex(*p, blob, hdr_len + 4 + len);
+	if (!p)
+		return -ENOMEM;
+	memcpy(p->blob, hdr, hdr_len);
+	put_unaligned_le32(len, p->blob + hdr_len);
+	memcpy(p->blob + hdr_len + 4, data, len);
+	keycrypt_payload_init(p, m, hdr_len, len);
+	*out = p;
+	return 0;
+}
+
+static int keycrypt_payload_parse(const u8 *raw, size_t len,
+				  struct keycrypt_payload **out)
+{
+	struct keycrypt_meta m = {};
+	struct keycrypt_payload *p;
+	size_t n, off;
+	u32 dlen;
+
+	if (len < KEYCRYPT_HEADER_FIXED ||
+	    memcmp(raw, KEYCRYPT_MAGIC, KEYCRYPT_MAGIC_LEN))
+		return -EBADMSG;
+	if (raw[3] != KEYCRYPT_VERSION || raw[4])
+		return -EOPNOTSUPP;
+	m.alg = raw[5];
+	m.purpose = get_unaligned_le16(raw + 6);
+	m.tier = raw[8];
+	m.origin = raw[9];
+	n = raw[10];
+	if (!keycrypt_purpose_valid(m.alg, m.purpose) ||
+	    !keycrypt_tier_valid(m.tier) ||
+	    !KEYCRYPT_NAME(keycrypt_origins, m.origin))
+		return -EBADMSG;
+	off = KEYCRYPT_HEADER_FIXED + n;
+	/* The name is read only once the length covers it */
+	if (len < off + 4 ||
+	    !keycrypt_name_valid((const char *)raw + KEYCRYPT_HEADER_FIXED, n))
+		return -EBADMSG;
+	memcpy(m.backend, raw + KEYCRYPT_HEADER_FIXED, n);
+	dlen = get_unaligned_le32(raw + off);
+	if (!dlen || dlen > KEYCRYPT_BACKEND_DATA_MAX || len != off + 4 + dlen)
+		return -EBADMSG;
+
+	p = kzalloc_flex(*p, blob, len);
+	if (!p)
+		return -ENOMEM;
+	memcpy(p->blob, raw, len);
+	keycrypt_payload_init(p, &m, off, dlen);
+	*out = p;
+	return 0;
+}
+
+void keycrypt_handle_put(struct keycrypt_handle *h)
+{
+	if (refcount_dec_and_test(&h->ref))
+		kfree(h);
+}
+
+/**
+ * keycrypt_register_backend() - make a backend available to keys
+ * @b: the backend, valid until keycrypt_unregister_backend() returns
+ *
+ * Return: 0, -EINVAL for a malformed @b, -EBUSY for a @b already
+ * registered, -EEXIST for a name in use, -ENOMEM.
+ */
+int keycrypt_register_backend(struct keycrypt_backend *b)
+{
+	struct keycrypt_handle *h, *p;
+	int ret = 0;
+
+	if (!b->name ||
+	    !keycrypt_name_valid(b->name,
+				 strnlen(b->name,
+					 KEYCRYPT_BACKEND_NAME_MAX + 1)) ||
+	    !keycrypt_tier_valid(b->tier) ||
+	    !b->algs || (b->algs & ~KEYCRYPT_ALGS_ALL) ||
+	    !b->generate || !b->load ||
+	    ((!!b->ctx_open + !!b->update + !!b->final + !!b->ctx_free) % 4) ||
+	    (b->tier >= KEYCRYPT_TIER_TEE &&
+	     b->ctx_open &&
+	     (b->algs & BIT(KEYCRYPT_ALG_HMAC_SHA256)) && !b->verify))
+		return -EINVAL;
+
+	h = kzalloc_obj(*h);
+	if (!h)
+		return -ENOMEM;
+	refcount_set(&h->ref, 1);
+	init_rwsem(&h->sem);
+	mutex_init(&h->keys_lock);
+	INIT_LIST_HEAD(&h->keys);
+	INIT_LIST_HEAD(&h->ctxs);
+	h->b = b;
+	h->tier = b->tier;
+	strscpy(h->name, b->name);
+
+	mutex_lock(&keycrypt_lock);
+	if (b->handle)
+		ret = -EBUSY;
+	if (!ret)
+		list_for_each_entry(p, &keycrypt_handles, list) {
+			if (!strcmp(p->name, h->name)) {
+				ret = -EEXIST;
+				break;
+			}
+		}
+	if (!ret) {
+		list_add_tail(&h->list, &keycrypt_handles);
+		b->handle = h;
+	}
+	mutex_unlock(&keycrypt_lock);
+	if (ret)
+		kfree(h);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(keycrypt_register_backend);
+
+/*
+ * The one door to @b->destroy: at most once per key, with @p's handle's
+ * sem held for writing (revoke, unregister) or by keycrypt_payload_free()
+ * when nothing else can reach @p, and its keys_lock held.
+ */
+static void keycrypt_payload_destroy(struct keycrypt_backend *b,
+				     struct keycrypt_payload *p)
+{
+	if (p->destroyed)
+		return;
+	p->destroyed = true;
+	if (b && b->destroy)
+		b->destroy(b, &p->key);
+}
+
+/**
+ * keycrypt_unregister_backend() - remove a backend
+ * @b: a backend registered earlier
+ *
+ * Waits for the backend calls in progress, calls @b->destroy on every key
+ * still using it, and leaves those keys in place: from then on they fail
+ * with -ENODEV. @b may be freed once this returns.
+ */
+void keycrypt_unregister_backend(struct keycrypt_backend *b)
+{
+	struct keycrypt_handle *h;
+	struct keycrypt_payload *p;
+	struct keycrypt_ctx *c;
+
+	mutex_lock(&keycrypt_lock);
+	h = b->handle;
+	if (WARN_ON_ONCE(!h)) {
+		mutex_unlock(&keycrypt_lock);
+		return;
+	}
+	b->handle = NULL;
+	list_del(&h->list);
+	mutex_unlock(&keycrypt_lock);
+
+	down_write(&h->sem);
+	mutex_lock(&h->keys_lock);
+	/* Contexts before keys, the order keycrypt_payload_revoke() uses */
+	list_for_each_entry(c, &h->ctxs, node)
+		keycrypt_ctx_detach(b, c);
+	list_for_each_entry(p, &h->keys, node)
+		keycrypt_payload_destroy(b, p);
+	mutex_unlock(&h->keys_lock);
+	h->b = NULL;
+	up_write(&h->sem);
+
+	keycrypt_handle_put(h);
+}
+EXPORT_SYMBOL_GPL(keycrypt_unregister_backend);
+
+/*
+ * The best backend for @alg (and, for @import, with an import) meeting
+ * every constraint given: named @name, of tier @tier, of at least
+ * @min_tier; the highest tier wins, the smaller name on a tie. Returned
+ * with a reference.
+ */
+static struct keycrypt_handle *keycrypt_get_handle(const char *name, u8 tier,
+						   u8 min_tier, u8 alg,
+						   bool import)
+{
+	struct keycrypt_handle *h, *best = NULL;
+
+	mutex_lock(&keycrypt_lock);
+	list_for_each_entry(h, &keycrypt_handles, list) {
+		if (!(h->b->algs & BIT(alg)) || (import && !h->b->import))
+			continue;
+		if (name && strcmp(h->name, name))
+			continue;
+		if ((tier && h->tier != tier) || h->tier < min_tier)
+			continue;
+		if (!best || h->tier > best->tier ||
+		    (h->tier == best->tier && strcmp(h->name, best->name) < 0))
+			best = h;
+	}
+	if (best)
+		refcount_inc(&best->ref);
+	mutex_unlock(&keycrypt_lock);
+	return best;
+}
+
+/* What a backend's error becomes for user space */
+int keycrypt_backend_ret(int ret)
+{
+	switch (ret) {
+	case 0:
+	case -ENOMEM:
+	case -EINVAL:
+	case -EBADMSG:
+	case -ENOKEY:
+	case -EKEYREJECTED:
+	case -EACCES:
+	case -EINTR:
+	case -ERESTARTSYS:
+		return ret;
+	}
+	return -EIO;
+}
+
+static const char *keycrypt_opts(const struct keycrypt_req *req)
+{
+	return *req->opts ? req->opts : NULL;
+}
+
+/* Every option in @opts has a key @b declares, and no key comes twice */
+static int keycrypt_check_opts(const struct keycrypt_backend *b,
+			       const char *opts)
+{
+	const char *s = opts, *e, *eq;
+	unsigned long seen = 0;
+	size_t i, n;
+
+	if (!opts)
+		return 0;
+	while (*s) {
+		e = strchrnul(s, ' ');
+		eq = strnchr(s, e - s, '=');
+		n = eq ? eq - s : e - s;
+		for (i = 0; b->opts && b->opts[i]; i++)
+			if (strlen(b->opts[i]) == n &&
+			    !strncmp(b->opts[i], s, n))
+				break;
+		if (!b->opts || !b->opts[i] || i >= BITS_PER_LONG ||
+		    (seen & BIT(i)))
+			return -EINVAL;
+		seen |= BIT(i);
+		s = *e ? e + 1 : e;
+	}
+	return 0;
+}
+
+/*
+ * Let the backend accept @p and link it to @h. Called with @h->sem held
+ * for reading and @h->b set; on success @p keeps the caller's reference
+ * to @h.
+ */
+static int keycrypt_attach(struct keycrypt_handle *h,
+			   struct keycrypt_payload *p, const char *opts)
+{
+	struct keycrypt_backend *b = h->b;
+	int ret;
+
+	if (!try_module_get(b->owner))
+		return -ENODEV;
+	ret = keycrypt_backend_ret(b->load(b, &p->key, opts));
+	if (ret) {
+		module_put(b->owner);
+		return ret;
+	}
+	p->handle = h;
+	p->owner = b->owner;
+	mutex_lock(&h->keys_lock);
+	list_add(&p->node, &h->keys);
+	mutex_unlock(&h->keys_lock);
+	return 0;
+}
+
+static void keycrypt_payload_free(struct keycrypt_payload *p)
+{
+	struct keycrypt_handle *h;
+
+	if (!p)
+		return;
+	h = p->handle;
+	if (h) {
+		down_read(&h->sem);
+		mutex_lock(&h->keys_lock);
+		keycrypt_payload_destroy(h->b, p);
+		list_del(&p->node);
+		mutex_unlock(&h->keys_lock);
+		up_read(&h->sem);
+		module_put(p->owner);
+		keycrypt_handle_put(h);
+	}
+	kfree_sensitive(p);
+}
+
+struct keycrypt_policy keycrypt_policy = {
+	.lock		= __MUTEX_INITIALIZER(keycrypt_policy.lock),
+	.system_tier	= KEYCRYPT_BOOT_SYSTEM_TIER,
+	.import		= true,
+};
+
+/* -EINVAL for an unknown tier, -EPERM for a lower one; equal is a no-op */
+static int
+keycrypt_policy_set_system_tier(struct keycrypt_policy *pol, u8 tier)
+{
+	int ret = 0;
+
+	if (!keycrypt_tier_valid(tier))
+		return -EINVAL;
+	mutex_lock(&pol->lock);
+	if (tier < pol->system_tier)
+		ret = -EPERM;
+	else
+		WRITE_ONCE(pol->system_tier, tier);
+	mutex_unlock(&pol->lock);
+	return ret;
+}
+
+/* -EPERM for turning it back on; off twice is a no-op */
+static int keycrypt_policy_set_import(struct keycrypt_policy *pol,
+				      bool on)
+{
+	int ret = 0;
+
+	mutex_lock(&pol->lock);
+	if (on && !pol->import)
+		ret = -EPERM;
+	else
+		WRITE_ONCE(pol->import, on);
+	mutex_unlock(&pol->lock);
+	return ret;
+}
+
+u8 keycrypt_policy_system_tier(void)
+{
+	return READ_ONCE(keycrypt_policy.system_tier);
+}
+
+bool keycrypt_policy_import(void)
+{
+	return READ_ONCE(keycrypt_policy.import);
+}
+
+static int keycrypt_create(const struct keycrypt_req *req,
+			   struct keycrypt_payload **out)
+{
+	bool import = req->cmd == KEYCRYPT_CMD_IMPORT;
+	const char *opts = keycrypt_opts(req);
+	struct keycrypt_payload *p = NULL;
+	struct keycrypt_blob blob = {};
+	struct keycrypt_meta m = {};
+	u8 hdr[KEYCRYPT_HEADER_MAX];
+	struct keycrypt_handle *h;
+	struct keycrypt_backend *b;
+	size_t keylen = 0;
+	u8 *key = NULL;
+	int hlen, ret;
+
+	if (import) {
+		if (!IS_ENABLED(CONFIG_KEYCRYPT_IMPORT) ||
+		    !keycrypt_policy_import() || !capable(CAP_SYS_ADMIN))
+			return -EPERM;
+		keylen = strlen(req->hex);
+		if (keylen % 2)
+			return -EINVAL;
+		keylen /= 2;
+		if (!keycrypt_key_len_valid(req->alg, keylen))
+			return -EINVAL;
+		key = kmalloc(keylen, GFP_KERNEL);
+		if (!key)
+			return -ENOMEM;
+		if (hex2bin(key, req->hex, keylen)) {
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
+	h = keycrypt_get_handle(*req->backend ? req->backend : NULL, req->tier,
+				req->min_tier, req->alg, import);
+	if (!h) {
+		ret = -ENODEV;
+		goto out;
+	}
+	down_read(&h->sem);
+	b = h->b;
+	if (!b) {
+		ret = -ENODEV;
+		goto unlock;
+	}
+	ret = keycrypt_check_opts(b, opts);
+	if (ret)
+		goto unlock;
+
+	m.alg = req->alg;
+	m.purpose = req->purpose;
+	m.tier = h->tier;
+	m.origin = import ? KEYCRYPT_ORIGIN_IMPORTED :
+			    KEYCRYPT_ORIGIN_GENERATED;
+	strscpy(m.backend, h->name);
+	hlen = keycrypt_meta_header(&m, hdr, sizeof(hdr));
+	if (hlen < 0) {
+		ret = hlen;
+		goto unlock;
+	}
+
+	if (import)
+		ret = b->import(b, &m, hdr, hlen, opts, key, keylen, &blob);
+	else
+		ret = b->generate(b, &m, hdr, hlen, opts, &blob);
+	ret = keycrypt_backend_ret(ret);
+	if (!ret)
+		ret = keycrypt_payload_build(&m, hdr, hlen, blob.data, blob.len,
+					     &p);
+	kfree_sensitive(blob.data);
+	/* load options come only with "load": none for the new blob */
+	if (!ret)
+		ret = keycrypt_attach(h, p, NULL);
+	if (ret) {
+		kfree_sensitive(p);
+		p = NULL;
+	}
+unlock:
+	up_read(&h->sem);
+	if (ret)
+		keycrypt_handle_put(h);
+	else
+		*out = p;
+out:
+	kfree_sensitive(key);
+	return ret;
+}
+
+static int keycrypt_load(const struct keycrypt_req *req,
+			 struct keycrypt_payload **out)
+{
+	size_t len = strlen(req->hex);
+	struct keycrypt_handle *h;
+	struct keycrypt_payload *p;
+	struct keycrypt_meta *m;
+	u8 *raw;
+	int ret;
+
+	if (!len || len % 2 || len / 2 > KEYCRYPT_BLOB_MAX)
+		return -EINVAL;
+	raw = kmalloc(len / 2, GFP_KERNEL);
+	if (!raw)
+		return -ENOMEM;
+	ret = hex2bin(raw, req->hex, len / 2) ? -EINVAL : 0;
+	if (!ret)
+		ret = keycrypt_payload_parse(raw, len / 2, &p);
+	kfree_sensitive(raw);
+	if (ret)
+		return ret;
+
+	m = &p->key.meta;
+	h = keycrypt_get_handle(m->backend, 0, 0, m->alg, false);
+	if (!h) {
+		ret = -ENODEV;
+		goto free;
+	}
+	down_read(&h->sem);
+	if (!h->b)
+		ret = -ENODEV;
+	else if (m->tier > h->tier)
+		ret = -EKEYREJECTED;
+	else if (m->tier < req->accepted_min_tier)
+		ret = -EPERM;
+	else if (req->want_purpose && m->purpose != req->want_purpose)
+		ret = -EKEYREJECTED;
+	else if (keycrypt_check_opts(h->b, keycrypt_opts(req)))
+		ret = -EINVAL;
+	else
+		ret = keycrypt_attach(h, p, keycrypt_opts(req));
+	up_read(&h->sem);
+	if (!ret) {
+		*out = p;
+		return 0;
+	}
+	keycrypt_handle_put(h);
+free:
+	kfree_sensitive(p);
+	return ret;
+}
+
+static int keycrypt_preparse(struct key_preparsed_payload *prep)
+{
+	struct keycrypt_payload *p = NULL;
+	struct keycrypt_req req = {};
+	char *buf, *opts;
+	int ret;
+
+	if (!prep->data || !prep->datalen ||
+	    prep->datalen > KEYCRYPT_INPUT_MAX)
+		return -EINVAL;
+	/* A NUL would hide what follows it; a final one is tolerated */
+	if (memchr(prep->data, '\0', prep->datalen - 1))
+		return -EINVAL;
+
+	buf = kmemdup_nul(prep->data, prep->datalen, GFP_KERNEL);
+	opts = kzalloc(prep->datalen + 1, GFP_KERNEL);
+	if (!buf || !opts) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	req.opts = opts;
+	req.opts_size = prep->datalen + 1;
+	ret = keycrypt_parse(buf, &req);
+	if (!ret) {
+		if (req.cmd == KEYCRYPT_CMD_LOAD)
+			ret = keycrypt_load(&req, &p);
+		else
+			ret = keycrypt_create(&req, &p);
+	}
+out:
+	kfree_sensitive(opts);
+	kfree_sensitive(buf);		/* it may hold a key in clear */
+	if (ret)
+		return ret;
+	prep->payload.data[0] = p;
+	prep->quotalen = p->blob_len;
+	return 0;
+}
+
+static void keycrypt_free_preparse(struct key_preparsed_payload *prep)
+{
+	keycrypt_payload_free(prep->payload.data[0]);
+}
+
+static void keycrypt_destroy(struct key *key)
+{
+	keycrypt_payload_free(key->payload.data[0]);
+}
+
+/* What "keyctl read" returns: the blob in hex, what "load" takes */
+static long keycrypt_format(const struct keycrypt_payload *p,
+			    char *buf, size_t buflen)
+{
+	long len = 2 * p->blob_len;
+	char *txt;
+
+	if (!buf || !buflen)
+		return len;
+	if (buflen >= len) {
+		bin2hex(buf, p->blob, p->blob_len);
+		return len;
+	}
+	txt = kmalloc(len, GFP_KERNEL);
+	if (!txt)
+		return -ENOMEM;
+	bin2hex(txt, p->blob, p->blob_len);
+	memcpy(buf, txt, buflen);
+	kfree(txt);
+	return len;
+}
+
+static long keycrypt_read(const struct key *key, char *buffer, size_t buflen)
+{
+	return keycrypt_format(dereference_key_locked(key), buffer, buflen);
+}
+
+static void keycrypt_purpose_str(u16 purpose, char *buf, size_t len)
+{
+	static const char * const names[] = {
+		"encrypt", "decrypt", "mac", "verify"
+	};
+	size_t i, n = 0;
+
+	buf[0] = '\0';
+	for (i = 0; i < ARRAY_SIZE(names); i++)
+		if (purpose & BIT(i))
+			n += scnprintf(buf + n, len - n, "%s%s", n ? "," : "",
+				       names[i]);
+}
+
+/* "<description>: <alg> <purpose> <tier> <backend> <origin>" */
+static void keycrypt_describe(const struct key *key, struct seq_file *m)
+{
+	const struct keycrypt_payload *p;
+	char purpose[24];
+
+	seq_puts(m, key->description);
+	if (!key_is_positive(key))
+		return;
+	p = dereference_key_rcu(key);
+	if (!p)
+		return;
+	keycrypt_purpose_str(p->key.meta.purpose, purpose, sizeof(purpose));
+	seq_printf(m, ": %s %s %s %s %s",
+		   KEYCRYPT_NAME(keycrypt_algs, p->key.meta.alg), purpose,
+		   KEYCRYPT_NAME(keycrypt_tiers, p->key.meta.tier),
+		   p->key.meta.backend,
+		   KEYCRYPT_NAME(keycrypt_origins, p->key.meta.origin));
+}
+
+/*
+ * Detach every open context of @key and wipe the backend's state for it.
+ * h->sem is taken for writing so that no backend call is still running on
+ * those contexts; lock order: key->sem, h->sem, h->keys_lock. Safe to call
+ * twice.
+ */
+static void keycrypt_payload_revoke(struct keycrypt_payload *p,
+				    struct key *key)
+{
+	struct keycrypt_handle *h;
+
+	if (!p || !p->handle)
+		return;
+	h = p->handle;
+	down_write(&h->sem);
+	mutex_lock(&h->keys_lock);
+	keycrypt_ctx_revoke(h, key);	/* detaches c->key == key */
+	keycrypt_payload_destroy(h->b, p);
+	mutex_unlock(&h->keys_lock);
+	up_write(&h->sem);
+}
+
+static void keycrypt_revoke(struct key *key)
+{
+	keycrypt_payload_revoke(dereference_key_locked(key), key);
+}
+
+/*
+ * Never constructed on demand: a request-key helper would instantiate the
+ * key with its own credentials and keyrings, not the requester's. The key
+ * is negated here, so every caller gets -ENOKEY.
+ */
+static int keycrypt_request_key(struct key *authkey, void *aux)
+{
+	complete_request_key(authkey, -ENOKEY);
+	return 0;
+}
+
+/*
+ * No .update: a payload never changes once instantiated, which .revoke and
+ * keyctl_crypt_open() rely on when they read it without key->sem.
+ */
+struct key_type key_type_keycrypt = {
+	.name		= "keycrypt",
+	.request_key	= keycrypt_request_key,
+	.preparse	= keycrypt_preparse,
+	.free_preparse	= keycrypt_free_preparse,
+	.instantiate	= generic_key_instantiate,
+	.destroy	= keycrypt_destroy,
+	.describe	= keycrypt_describe,
+	.read		= keycrypt_read,
+	.revoke		= keycrypt_revoke,
+};
+
+/*
+ * System policies: the kernel.keys sysctls
+ */
+
+static int keycrypt_sysctl_system_tier(const struct ctl_table *table,
+				       int write, void *buf, size_t *lenp,
+				       loff_t *ppos)
+{
+	unsigned int v = keycrypt_policy_system_tier();
+	const struct ctl_table t = { .data = &v, .maxlen = sizeof(v) };
+	int ret;
+
+	if (write && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	ret = proc_douintvec(&t, write, buf, lenp, ppos);
+	if (ret || !write)
+		return ret;
+	return keycrypt_policy_set_system_tier(&keycrypt_policy,
+					       v > U8_MAX ? U8_MAX : v);
+}
+
+static int keycrypt_sysctl_import(const struct ctl_table *table, int write,
+				  void *buf, size_t *lenp, loff_t *ppos)
+{
+	unsigned int v = keycrypt_policy_import();
+	const struct ctl_table t = { .data = &v, .maxlen = sizeof(v) };
+	int ret;
+
+	if (write && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	ret = proc_douintvec(&t, write, buf, lenp, ppos);
+	if (ret || !write)
+		return ret;
+	if (v > 1)
+		return -EINVAL;
+	return keycrypt_policy_set_import(&keycrypt_policy, v);
+}
+
+static const struct ctl_table keycrypt_sysctls[] = {
+	{
+		.procname	= "keycrypt_system_tier",
+		.mode		= 0644,
+		.proc_handler	= keycrypt_sysctl_system_tier,
+	},
+	{
+		.procname	= "keycrypt_import",
+		.mode		= 0644,
+		.proc_handler	= keycrypt_sysctl_import,
+	},
+};
+
+/*
+ * System policies: the boot parameters
+ */
+
+static int __init keycrypt_system_tier_setup(char *s)
+{
+	u8 tier = 0;
+
+	if (keycrypt_parse_tier(s, &tier) ||
+	    keycrypt_policy_set_system_tier(&keycrypt_policy, tier))
+		pr_warn("ignoring keycrypt.system_tier=%s\n", s);
+	return 1;
+}
+__setup("keycrypt.system_tier=", keycrypt_system_tier_setup);
+
+static int __init keycrypt_import_setup(char *s)
+{
+	bool on;
+
+	if (kstrtobool(s, &on) ||
+	    keycrypt_policy_set_import(&keycrypt_policy, on))
+		pr_warn("ignoring keycrypt.import=%s\n", s);
+	return 1;
+}
+__setup("keycrypt.import=", keycrypt_import_setup);
+
+static int __init keycrypt_init(void)
+{
+	int ret = register_key_type(&key_type_keycrypt);
+
+	if (ret)
+		return ret;
+	/* register_sysctl_init() logs and does not fail: defaults still work */
+	register_sysctl_init("kernel/keys", keycrypt_sysctls);
+	return 0;
+}
+late_initcall(keycrypt_init);
diff --git a/security/keys/keycrypt/ctx.c b/security/keys/keycrypt/ctx.c
new file mode 100644
index 000000000000..ce62ba08479b
--- /dev/null
+++ b/security/keys/keycrypt/ctx.c
@@ -0,0 +1,530 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * keycrypt - the operation context: KEYCTL_CRYPT_OPEN and its fd
+ *
+ * Copyright (C) 2026 Rodolfo Giometti <giometti@enneenne.com>
+ */
+
+#include <crypto/aes.h>
+#include <crypto/utils.h>
+#include <linux/anon_inodes.h>
+#include <linux/build_bug.h>
+#include <linux/err.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/key.h>
+#include <linux/keyctl.h>
+#include <linux/limits.h>
+#include <linux/minmax.h>
+#include <linux/mm.h>
+#include <linux/random.h>
+#include <linux/slab.h>
+#include <linux/stddef.h>
+#include <linux/string.h>
+#include <linux/uaccess.h>
+#include <uapi/linux/keycrypt.h>
+#include "../internal.h"
+#include "keycrypt.h"
+
+static_assert(offsetofend(struct keycrypt_open_params, iv) ==
+	      KEYCRYPT_OPEN_PARAMS_SIZE_VER0);
+static_assert(KEYCRYPT_BACKEND_NAME_MAX <
+	      sizeof_field(struct keycrypt_info, backend));
+
+static const u16 keycrypt_op_purpose[] = {
+	[KEYCRYPT_OP_ENCRYPT]	= KEYCRYPT_PURPOSE_ENCRYPT,
+	[KEYCRYPT_OP_DECRYPT]	= KEYCRYPT_PURPOSE_DECRYPT,
+	[KEYCRYPT_OP_MAC]	= KEYCRYPT_PURPOSE_MAC,
+	[KEYCRYPT_OP_VERIFY]	= KEYCRYPT_PURPOSE_MAC | KEYCRYPT_PURPOSE_VERIFY,
+};
+
+/*
+ * A context callback's error as user space sees it; keycrypt_backend_ret()
+ * is the wider mapping of @generate, @import and @load
+ */
+static int keycrypt_ctx_ret(int ret)
+{
+	switch (ret) {
+	case 0:
+	case -ENOMEM:
+	case -EINTR:
+	case -ERESTARTSYS:
+	case -EBADMSG:
+		return ret;
+	}
+	return -EIO;
+}
+
+/*
+ * Release the backend's state of @c. Called with @c->h->sem held (for
+ * writing by unregister and by revoke, with @b the backend; for reading
+ * otherwise, with @b = @c->h->b) and @c->h->keys_lock held. Leaves @done
+ * untouched: a detached @c with @bctx NULL answers through
+ * keycrypt_ctx_backend() instead of ending.
+ */
+void keycrypt_ctx_detach(struct keycrypt_backend *b, struct keycrypt_ctx *c)
+{
+	if (c->bctx && b)
+		b->ctx_free(b, c->bctx);
+	c->bctx = NULL;
+}
+
+/*
+ * Detach every context of @key: called by key_type_keycrypt.revoke(), with
+ * @h->sem held for writing and @h->keys_lock held. Left in @h->ctxs: only
+ * the fd's release removes a context from the list.
+ */
+void keycrypt_ctx_revoke(struct keycrypt_handle *h, struct key *key)
+{
+	struct keycrypt_ctx *c;
+
+	list_for_each_entry(c, &h->ctxs, node)
+		if (c->key == key)
+			keycrypt_ctx_detach(h->b, c);
+}
+
+/* Detach @c from its backend and from the handle's list */
+static void keycrypt_ctx_drop(struct keycrypt_ctx *c)
+{
+	struct keycrypt_handle *h = c->h;
+
+	down_read(&h->sem);
+	mutex_lock(&h->keys_lock);
+	keycrypt_ctx_detach(h->b, c);
+	list_del_init(&c->node);
+	mutex_unlock(&h->keys_lock);
+	up_read(&h->sem);
+}
+
+static void keycrypt_ctx_free(struct keycrypt_ctx *c)
+{
+	keycrypt_ctx_drop(c);
+	keycrypt_handle_put(c->h);
+	key_put(c->key);
+	kfree(c);
+}
+
+/* The key still usable: neither revoked, invalidated nor expired */
+static int keycrypt_ctx_check(struct keycrypt_ctx *c)
+{
+	int ret = key_validate(c->key);
+
+	return ret == -EKEYREVOKED || ret == -EKEYEXPIRED ? ret :
+	       ret ? -EKEYREVOKED : 0;
+}
+
+/*
+ * Under @c->h->sem: the backend to run @c on, or why there is none. A
+ * detached @c (revoked key, removed backend) gives the key's own error,
+ * else -ENODEV, and the context is not ended by it: every later call
+ * gives the same answer.
+ */
+static int keycrypt_ctx_backend(struct keycrypt_ctx *c,
+				struct keycrypt_backend **b)
+{
+	*b = c->h->b;
+	if (*b && c->bctx)
+		return 0;
+	return keycrypt_ctx_check(c) ?: -ENODEV;
+}
+
+/* End @c after FINAL or a failure that may have changed its state */
+static long keycrypt_ctx_end(struct keycrypt_ctx *c, long ret)
+{
+	c->done = true;
+	keycrypt_ctx_drop(c);
+	return ret == -ERESTARTSYS ? -EINTR : ret;
+}
+
+/*
+ * What KEYCRYPT_IOC_INFO reports: @c's operation and accepted minimum
+ * tier, and its key's metadata
+ */
+static void keycrypt_ctx_info(const struct keycrypt_ctx *c,
+			      struct keycrypt_info *info)
+{
+	memset(info, 0, sizeof(*info));
+	info->op = c->op;
+	info->alg = c->meta.alg;
+	info->purpose = c->meta.purpose;
+	info->tier = c->meta.tier;
+	info->origin = c->meta.origin;
+	info->accepted_min_tier = c->accepted_min_tier;
+	strscpy(info->backend, c->meta.backend, sizeof(info->backend));
+}
+
+/*
+ * KEYCRYPT_IOC_INFO under @c->lock: the state checks UPDATE with no
+ * data makes, then @info.
+ */
+static long keycrypt_ctx_info_get(struct keycrypt_ctx *c,
+				  struct keycrypt_info *info)
+{
+	struct keycrypt_backend *b;
+	long ret;
+
+	ret = mutex_lock_killable(&c->lock);
+	if (ret)
+		return ret;
+	if (c->done) {
+		ret = -EBADFD;
+		goto unlock;
+	}
+	ret = keycrypt_ctx_check(c);
+	if (!ret) {
+		down_read(&c->h->sem);
+		ret = keycrypt_ctx_backend(c, &b);
+		up_read(&c->h->sem);
+	}
+	if (!ret)
+		keycrypt_ctx_info(c, info);
+unlock:
+	mutex_unlock(&c->lock);
+	return ret;
+}
+
+static long keycrypt_ioc_update(struct keycrypt_ctx *c,
+				struct keycrypt_update __user *uarg)
+{
+	bool hmac = c->op == KEYCRYPT_OP_MAC || c->op == KEYCRYPT_OP_VERIFY;
+	struct keycrypt_backend *b;
+	struct keycrypt_update u;
+	u8 *buf = NULL;
+	bool ran = false;
+	long ret;
+
+	if (copy_from_user(&u, uarg, sizeof(u)))
+		return -EFAULT;
+	if (u.flags || (hmac && u.out) || (!hmac && u.len && !u.out) ||
+	    (!hmac && u.len % AES_BLOCK_SIZE))
+		return -EINVAL;
+	if (u.len > KEYCRYPT_UPDATE_MAX)
+		return -E2BIG;
+
+	ret = mutex_lock_killable(&c->lock);
+	if (ret)
+		return ret;
+	if (c->done) {
+		ret = -EBADFD;
+		goto unlock;
+	}
+	ret = keycrypt_ctx_check(c);
+	if (ret)
+		goto unlock;
+	if (!u.len) {
+		/* No data to run, but a detached context still answers */
+		down_read(&c->h->sem);
+		ret = keycrypt_ctx_backend(c, &b);
+		up_read(&c->h->sem);
+		goto unlock;
+	}
+	buf = kvmalloc(u.len, GFP_KERNEL_ACCOUNT);
+	if (!buf) {
+		ret = -ENOMEM;
+		goto unlock;
+	}
+	if (copy_from_user(buf, u64_to_user_ptr(u.in), u.len)) {
+		ret = -EFAULT;
+		goto free;
+	}
+	down_read(&c->h->sem);
+	ret = keycrypt_ctx_backend(c, &b);
+	ran = !ret;
+	if (!ret)
+		ret = keycrypt_ctx_ret(b->update(b, c->bctx, buf,
+						 hmac ? NULL : buf, u.len));
+	up_read(&c->h->sem);
+	if (!ret && !hmac &&
+	    copy_to_user(u64_to_user_ptr(u.out), buf, u.len))
+		ret = -EFAULT;
+	/* A failure past this point leaves the context in no known state */
+	if (ret && ran)
+		ret = keycrypt_ctx_end(c, ret);
+free:
+	kvfree_sensitive(buf, u.len);
+unlock:
+	mutex_unlock(&c->lock);
+	return ret;
+}
+
+static long keycrypt_ioc_final(struct keycrypt_ctx *c,
+			       struct keycrypt_final __user *uarg)
+{
+	bool mac = c->op == KEYCRYPT_OP_MAC;
+	bool verify = c->op == KEYCRYPT_OP_VERIFY;
+	u8 tag[KEYCRYPT_MAC_LEN] = {}, expected[KEYCRYPT_MAC_LEN];
+	struct keycrypt_backend *b;
+	struct keycrypt_final f;
+	bool by_backend;
+	size_t len = 0;
+	long ret;
+
+	if (copy_from_user(&f, uarg, sizeof(f)))
+		return -EFAULT;
+	if (f.flags || (!mac && !verify && f.out))
+		return -EINVAL;
+
+	ret = mutex_lock_killable(&c->lock);
+	if (ret)
+		return ret;
+	if (c->done) {
+		ret = -EBADFD;
+		goto unlock;
+	}
+	ret = keycrypt_ctx_check(c);
+	if (ret)
+		goto unlock;
+	if (mac && (f.len < KEYCRYPT_MAC_LEN || !f.out)) {
+		ret = -ENOSPC;		/* the context stays usable */
+		goto unlock;
+	}
+	if (verify && (f.len != KEYCRYPT_MAC_LEN || !f.out)) {
+		ret = -EINVAL;		/* the context stays usable */
+		goto unlock;
+	}
+	/* The expected tag comes in before the backend's sem is taken */
+	if (verify && copy_from_user(expected, u64_to_user_ptr(f.out),
+				     KEYCRYPT_MAC_LEN)) {
+		ret = -EFAULT;
+		goto wipe;
+	}
+	down_read(&c->h->sem);
+	ret = keycrypt_ctx_backend(c, &b);
+	if (ret) {
+		up_read(&c->h->sem);
+		goto wipe;
+	}
+	/* A VERIFY context whose backend compares its own tag: it never
+	 * exists outside the backend on this path.
+	 */
+	by_backend = verify && b->verify;
+	if (by_backend)
+		ret = keycrypt_ctx_ret(b->verify(b, c->bctx, expected));
+	else
+		ret = keycrypt_ctx_ret(b->final(b, c->bctx, tag, sizeof(tag),
+						&len));
+	up_read(&c->h->sem);
+	ret = keycrypt_ctx_end(c, ret);
+	if (by_backend) {
+		if (!ret && put_user(0U, &uarg->len))
+			ret = -EFAULT;
+		goto wipe;
+	}
+	if (!ret && len != (mac || verify ? KEYCRYPT_MAC_LEN : 0))
+		ret = -EIO;
+	if (!ret && verify && crypto_memneq(tag, expected, KEYCRYPT_MAC_LEN))
+		ret = -EBADMSG;		/* the computed tag never leaves */
+	if (!ret && mac && len &&
+	    copy_to_user(u64_to_user_ptr(f.out), tag, len))
+		ret = -EFAULT;
+	if (!ret && put_user((u32)(verify ? 0 : len), &uarg->len))
+		ret = -EFAULT;
+wipe:
+	memzero_explicit(tag, sizeof(tag));
+	memzero_explicit(expected, sizeof(expected));
+unlock:
+	mutex_unlock(&c->lock);
+	return ret;
+}
+
+static long keycrypt_ioc_info(struct keycrypt_ctx *c,
+			      struct keycrypt_info __user *uarg)
+{
+	struct keycrypt_info info;
+	long ret;
+
+	ret = keycrypt_ctx_info_get(c, &info);
+	if (!ret && copy_to_user(uarg, &info, sizeof(info)))
+		ret = -EFAULT;
+	return ret;
+}
+
+static long keycrypt_ioctl(struct file *file, unsigned int cmd,
+			   unsigned long arg)
+{
+	struct keycrypt_ctx *c = file->private_data;
+
+	switch (cmd) {
+	case KEYCRYPT_IOC_UPDATE:
+		return keycrypt_ioc_update(c, (void __user *)arg);
+	case KEYCRYPT_IOC_FINAL:
+		return keycrypt_ioc_final(c, (void __user *)arg);
+	case KEYCRYPT_IOC_INFO:
+		return keycrypt_ioc_info(c, (void __user *)arg);
+	}
+	return -ENOTTY;
+}
+
+static int keycrypt_release(struct inode *inode, struct file *file)
+{
+	keycrypt_ctx_free(file->private_data);
+	return 0;
+}
+
+static const struct file_operations keycrypt_fops = {
+	.owner		= THIS_MODULE,
+	.unlocked_ioctl	= keycrypt_ioctl,
+	.compat_ioctl	= compat_ptr_ioctl,
+	.release	= keycrypt_release,
+	.llseek		= noop_llseek,
+};
+
+/*
+ * Under @h->sem: the backend to open a context of @p on, or why there
+ * is none.
+ */
+static int keycrypt_open_backend(struct keycrypt_handle *h,
+				 const struct keycrypt_payload *p,
+				 struct keycrypt_backend **b)
+{
+	*b = h->b;
+	if (!*b)
+		return -ENODEV;
+	if (p->destroyed)
+		return -EKEYREVOKED;
+	if (!(*b)->ctx_open)
+		return -ENODEV;
+	return 0;
+}
+
+/**
+ * keyctl_crypt_open() - KEYCTL_CRYPT_OPEN
+ * @id: the key, which must be of type keycrypt and searchable
+ * @uparams: struct keycrypt_open_params
+ * @usize: its size, for extension
+ * @flags: must be zero
+ *
+ * Return: an O_RDWR | O_CLOEXEC fd bound to the key and the operation,
+ * or a negative error.
+ */
+long keyctl_crypt_open(key_serial_t id, void __user *uparams,
+		       size_t usize, unsigned long flags)
+{
+	struct keycrypt_open_params params;
+	struct keycrypt_payload *p;
+	struct keycrypt_handle *h;
+	struct keycrypt_backend *b;
+	struct keycrypt_ctx *c;
+	bool gen_iv = false;
+	key_ref_t kref;
+	struct key *key;
+	long ret;
+	int fd;
+
+	if (flags)
+		return -EINVAL;
+	if (usize > PAGE_SIZE)
+		return -E2BIG;
+	if (usize < KEYCRYPT_OPEN_PARAMS_SIZE_VER0)
+		return -EINVAL;
+	ret = copy_struct_from_user(&params, sizeof(params), uparams, usize);
+	if (ret)
+		return ret;
+	if (params.__reserved ||
+	    (params.flags & ~KEYCRYPT_OPEN_CALLER_IV) ||
+	    params.op < KEYCRYPT_OP_ENCRYPT || params.op > KEYCRYPT_OP_VERIFY ||
+	    (params.accepted_min_tier &&
+	     !keycrypt_tier_valid(params.accepted_min_tier)) ||
+	    ((params.op == KEYCRYPT_OP_MAC || params.op == KEYCRYPT_OP_VERIFY) &&
+	     memchr_inv(params.iv, 0, sizeof(params.iv))))
+		return -EINVAL;
+
+	kref = lookup_user_key(id, 0, KEY_NEED_SEARCH);
+	if (IS_ERR(kref))
+		return PTR_ERR(kref);
+	key = key_ref_to_ptr(kref);
+	if (key->type != &key_type_keycrypt) {
+		ret = -EOPNOTSUPP;
+		goto put_key;
+	}
+
+	/*
+	 * key_type_keycrypt has no .update, so @p's content is immutable
+	 * once instantiated: @p and @p->key.meta stay safe to read below,
+	 * after key->sem is released.
+	 */
+	down_read(&key->sem);
+	ret = key_validate(key);
+	p = dereference_key_locked(key);
+	if (!ret && !p)
+		ret = -ENOKEY;
+	if (!ret && !(p->key.meta.purpose & keycrypt_op_purpose[params.op]))
+		ret = -EKEYREJECTED;
+	if (!ret && p->key.meta.tier < max(params.accepted_min_tier,
+					   keycrypt_policy_system_tier()))
+		ret = -EPERM;
+	if (!ret && (params.flags & KEYCRYPT_OPEN_CALLER_IV) &&
+	    (params.op != KEYCRYPT_OP_ENCRYPT ||
+	     p->key.meta.alg != KEYCRYPT_ALG_AES256_CBC))
+		ret = -EINVAL;
+	if (!ret && params.op == KEYCRYPT_OP_ENCRYPT &&
+	    p->key.meta.alg == KEYCRYPT_ALG_AES256_CBC) {
+		gen_iv = !(params.flags & KEYCRYPT_OPEN_CALLER_IV);
+		if (gen_iv && memchr_inv(params.iv, 0, sizeof(params.iv)))
+			ret = -EINVAL;
+	}
+	h = ret ? NULL : p->handle;
+	if (h)
+		refcount_inc(&h->ref);
+	up_read(&key->sem);
+	if (ret)
+		goto put_key;
+
+	if (gen_iv) {
+		ret = get_random_bytes_wait(params.iv, sizeof(params.iv));
+		if (ret)
+			goto put_handle;
+	}
+
+	c = kzalloc_obj(*c, GFP_KERNEL_ACCOUNT);
+	if (!c) {
+		ret = -ENOMEM;
+		goto put_handle;
+	}
+	mutex_init(&c->lock);
+	INIT_LIST_HEAD(&c->node);
+	c->key = key;
+	c->h = h;
+	c->op = params.op;
+	c->meta = p->key.meta;
+	c->accepted_min_tier = params.accepted_min_tier;
+
+	down_read(&h->sem);
+	ret = keycrypt_open_backend(h, p, &b);
+	if (!ret)
+		ret = keycrypt_ctx_ret(b->ctx_open(b, &p->key, params.op,
+						   params.iv, &c->bctx));
+	if (!ret) {
+		mutex_lock(&h->keys_lock);
+		list_add(&c->node, &h->ctxs);
+		mutex_unlock(&h->keys_lock);
+	}
+	up_read(&h->sem);
+	if (ret) {
+		memzero_explicit(params.iv, sizeof(params.iv));
+		kfree(c);
+		goto put_handle;
+	}
+
+	/* The write-back happens before the fd exists: no fd on EFAULT */
+	if (gen_iv &&
+	    copy_to_user(((struct keycrypt_open_params __user *)uparams)->iv,
+			 params.iv, sizeof(params.iv))) {
+		memzero_explicit(params.iv, sizeof(params.iv));
+		keycrypt_ctx_free(c);
+		return -EFAULT;
+	}
+	memzero_explicit(params.iv, sizeof(params.iv));
+
+	fd = anon_inode_getfd("[keycrypt]", &keycrypt_fops, c,
+			      O_RDWR | O_CLOEXEC);
+	if (fd < 0)
+		keycrypt_ctx_free(c);
+	return fd;
+
+put_handle:
+	keycrypt_handle_put(h);
+put_key:
+	key_put(key);
+	return ret;
+}
diff --git a/security/keys/keycrypt/keycrypt.h b/security/keys/keycrypt/keycrypt.h
new file mode 100644
index 000000000000..5a41a68c48fa
--- /dev/null
+++ b/security/keys/keycrypt/keycrypt.h
@@ -0,0 +1,173 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * keycrypt - core-private definitions
+ *
+ * Copyright (C) 2026 Rodolfo Giometti <giometti@enneenne.com>
+ */
+
+#ifndef _SECURITY_KEYS_KEYCRYPT_H
+#define _SECURITY_KEYS_KEYCRYPT_H
+
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/refcount.h>
+#include <linux/rwsem.h>
+#include <keys/keycrypt.h>
+
+#define KEYCRYPT_BLOB_MAX	(KEYCRYPT_HEADER_MAX + 4 + \
+				 KEYCRYPT_BACKEND_DATA_MAX)
+#define KEYCRYPT_INPUT_MAX	(2 * KEYCRYPT_BLOB_MAX + 256)
+
+#define KEYCRYPT_CMD_NEW	1
+#define KEYCRYPT_CMD_LOAD	2
+#define KEYCRYPT_CMD_IMPORT	3
+
+/**
+ * struct keycrypt_handle - the core's record of a registered backend
+ * @list: in the registry, under keycrypt_lock; unlinked by unregister
+ * @ref: one for the registry, one per key
+ * @sem: held for reading around backend calls, for writing by unregister
+ *	and revoke
+ * @b: the backend, NULL once unregistered
+ * @keys_lock: guards @keys and @ctxs
+ * @keys: the payloads of the backend's keys
+ * @ctxs: open contexts, under @keys_lock
+ * @tier: the backend's tier
+ * @name: the backend's name
+ */
+struct keycrypt_handle {
+	struct list_head	list;
+	refcount_t		ref;
+	struct rw_semaphore	sem;
+	struct keycrypt_backend	*b;
+	struct mutex		keys_lock;	/* guards @keys and @ctxs */
+	struct list_head	keys;
+	struct list_head	ctxs;
+	u8			tier;
+	char			name[KEYCRYPT_BACKEND_NAME_MAX + 1];
+};
+
+/**
+ * struct keycrypt_payload - the payload of a keycrypt key
+ * @handle: the backend's handle, NULL until the backend accepted the key
+ * @owner: the backend's module, pinned while the key exists
+ * @node: in @handle->keys
+ * @key: what the backend sees; its hdr and data point into @blob
+ * @destroyed: @key's backend state released; set once, under @handle->sem
+ *	held for writing, or by the payload's own free
+ * @blob_len: bytes in @blob
+ * @blob: header, le32 length of the backend data, backend data
+ */
+struct keycrypt_payload {
+	struct keycrypt_handle	*handle;
+	struct module		*owner;
+	struct list_head	node;
+	struct keycrypt_key	key;
+	bool			destroyed;
+	u32			blob_len;
+	u8			blob[];
+};
+
+/**
+ * struct keycrypt_req - a parsed add_key() payload
+ * @cmd: KEYCRYPT_CMD_*
+ * @alg: KEYCRYPT_ALG_* (new, import)
+ * @purpose: KEYCRYPT_PURPOSE_* mask (new, import)
+ * @want_purpose: "purpose=" of load, or 0
+ * @tier: "tier=" of new and import, or 0
+ * @min_tier: "min-tier=" of new and import, or 0
+ * @accepted_min_tier: "accepted-min-tier=" of load, or 0
+ * @backend: "backend=" of new and import, or empty
+ * @hex: the blob (load) or the key (import), hex encoded
+ * @opts: buffer, given by the caller, receiving the options for the
+ *	backend, space separated
+ * @opts_size: size of @opts
+ */
+struct keycrypt_req {
+	int		cmd;
+	u8		alg;
+	u16		purpose;
+	u16		want_purpose;
+	u8		tier;
+	u8		min_tier;
+	u8		accepted_min_tier;
+	char		backend[KEYCRYPT_BACKEND_NAME_MAX + 1];
+	const char	*hex;
+	char		*opts;
+	size_t		opts_size;
+};
+
+/**
+ * struct keycrypt_ctx - an open operation context
+ * @lock: serialises the calls on the fd
+ * @key: the key, referenced
+ * @h: its backend's handle, referenced
+ * @node: in @h->ctxs, under @h->keys_lock
+ * @bctx: the backend's state; NULL once detached (revoked, unregistered,
+ *	or ended by FINAL or a failure)
+ * @op: KEYCRYPT_OP_*
+ * @meta: @key's metadata, copied at open
+ * @accepted_min_tier: the caller's KEYCRYPT_TIER_* at open, or 0
+ * @done: ended by FINAL or by a failure once the backend ran; every later
+ *	call gives -EBADFD
+ */
+struct keycrypt_ctx {
+	struct mutex		lock;	/* serialises the calls on the fd */
+	struct key		*key;
+	struct keycrypt_handle	*h;
+	struct list_head	node;
+	void			*bctx;
+	u32			op;
+	struct keycrypt_meta	meta;
+	u8			accepted_min_tier;
+	bool			done;
+};
+
+/* The key length each algorithm takes; false for an unknown alg */
+static inline bool keycrypt_key_len_valid(u8 alg, size_t len)
+{
+	switch (alg) {
+	case KEYCRYPT_ALG_AES256_CBC:
+		return len == 32;
+	case KEYCRYPT_ALG_HMAC_SHA256:
+		return len >= 1 && len <= 64;
+	}
+	return false;
+}
+
+/* The tiers a key may have, and a tier option may name */
+bool keycrypt_tier_valid(u32 tier);
+
+/* The system tier at boot (Kconfig); it can only be raised */
+#if IS_ENABLED(CONFIG_KEYCRYPT_SYSTEM_TIER_HSM)
+#define KEYCRYPT_BOOT_SYSTEM_TIER	KEYCRYPT_TIER_HSM
+#elif IS_ENABLED(CONFIG_KEYCRYPT_SYSTEM_TIER_TEE)
+#define KEYCRYPT_BOOT_SYSTEM_TIER	KEYCRYPT_TIER_TEE
+#else
+#define KEYCRYPT_BOOT_SYSTEM_TIER	KEYCRYPT_TIER_KERNEL
+#endif
+
+/**
+ * struct keycrypt_policy - system-wide limits, one-way until reboot
+ * @lock: serialises changes
+ * @system_tier: KEYCRYPT_TIER_*: the lowest tier a key may be used at;
+ *	can only be raised
+ * @import: import allowed; can only be turned off
+ */
+struct keycrypt_policy {
+	struct mutex	lock;	/* serialises changes */
+	u8		system_tier;
+	bool		import;
+};
+
+extern struct keycrypt_policy keycrypt_policy;
+u8 keycrypt_policy_system_tier(void);
+bool keycrypt_policy_import(void);
+
+extern struct key_type key_type_keycrypt;
+int keycrypt_backend_ret(int ret);
+void keycrypt_handle_put(struct keycrypt_handle *h);
+void keycrypt_ctx_detach(struct keycrypt_backend *b, struct keycrypt_ctx *c);
+void keycrypt_ctx_revoke(struct keycrypt_handle *h, struct key *key);
+
+#endif /* _SECURITY_KEYS_KEYCRYPT_H */
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index d6b10fd67627..d74708b832ea 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -2031,6 +2031,11 @@ SYSCALL_DEFINE5(keyctl, int, option, unsigned long, arg2, unsigned long, arg3,
 	case KEYCTL_WATCH_KEY:
 		return keyctl_watch_key((key_serial_t)arg2, (int)arg3, (int)arg4);
 
+	case KEYCTL_CRYPT_OPEN:
+		return keyctl_crypt_open((key_serial_t)arg2,
+					 (void __user *)arg3,
+					 (size_t)arg4, arg5);
+
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.43.0

