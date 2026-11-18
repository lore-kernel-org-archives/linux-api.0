Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.156.91
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795010680;
	b=AokEOdOi6RbGycnxZhtkCjjO/Ry/vNQ4atXj95hxodOiJ0TjvwteuAxtbgZElp9qIJpO
	 /7ARZAAIw2CijFVm88YVt+jB9vg1MhR+L988q/ouhRtVupFwCpdJI65lMnJJY4uVPxhzn
	 /cOXZd182XqpRo1jkkI3iZJrDYT2Az28PZgKU/Qi2SYb6kpa5j9s9wiFyH46UStBI2XI5
	 AnzPOEdm7+9ofhNUsl0k6OZGVRlmoI1R+5BH/rhr9wCCBcVnunmjettKHCIwaH+CimG3x
	 IotGIC/VHTV4OU3etU7+BjinWFuu+yB5SodaOHmJf5MZEwVxwyupd18x3JE12mNZNHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795010680;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CMAE-Envelope;
	bh=gr8Qv6oDz1kKxMIQvC8LrpYwAhBBUywYgZsdVMhA6/Q=;
	b=Wkk+0kcDJZt4YvbVBAiYfWkDnk03Yj60ZW0fm0YHtBURfPS6GZDLaRmZZz1LuHEw9BNA
	 nPgY5lRxB4klyvdBfRqAHCd8jdjILuZqr9AKZAbaJSWi2GjKwFFvvnruvuBaSbP8enkKK
	 0g2NzHgiy4ZsrPVGQuSvfWlUYmWyEvAcQN3/b2xNDWTT/3XLOpUDky9sSIgf4jKFZL1kR
	 qJL96TgxKAHaJFp0Vlgb4Q3ur20PiCiuq3ctMDpYPEagCQ7EY3NQF2MAyBdCL3a8ohrGk
	 yirQi0xXQGnHQitgBqHsAZoWWVa/ww5bFUH7z/4/AiHmghHk8SDyA3yiUm2ZxheGvuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=enneenne.com;
	spf=pass smtp.mailfrom=enneenne.com;
	dkim=pass header.d=aruba.it header.i=@aruba.it header.a=rsa-sha256 header.s=a1 header.b=dookSa6H;
	arc=none smtp.remote-ip=62.149.156.91
Received: from smtpcmd0991.aruba.it (smtpcmd0991.aruba.it [62.149.156.91])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E97F60A2604
	for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 14:04:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0E97F60A2604
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=enneenne.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=enneenne.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.a=rsa-sha256 header.s=a1 header.b=dookSa6H
Received: from polimar.tail4f75e6.ts.net ([101.57.122.26])
	by Aruba SMTP with ESMTPSA
	id TgGvxLK1X6q8sTgH0xc6OJ; Wed, 18 Nov 2026 15:04:31 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1795010671; bh=LFu8MgDXQ6MAAoGPfVc8BvfkRFpgUYXzNzNAuKZ4MPE=;
	h=From:To:Subject:Date:MIME-Version;
	b=dookSa6HuUStJcyUT1RFUrEIDYfmojNRQrDx94g0U26X9U8I9XpoNdYQk5ogJ61pu
	 fNBdncXbI3b097oC9PduVNDFeCfuAiaAQHiQCPm4XGJ4bffS28jlDp2D0M05uL6wqA
	 vhvH4LFcJChkflk4XWoaLYhqn2gXxi1hY4AT4vLGETTK+Dbpv6PV8uKP+bss26+XsF
	 uIOKwF+GntJgMl+S+VrBmZaC8OrDwo6T5ltcSqeBhVfII+Fi7DRephkl6M8+wgIaas
	 aARlQWivIiHafgcY7UArNGq4K2C3mTzwePW98dTRkHZJ5nSV6Xn9tVg62XkVM5yPdy
	 7SqUiE6YyU9Yg==
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
Subject: [RFC PATCH 3/9] KEYS: keycrypt: Add the OP-TEE backend
Date: Wed, 18 Nov 2026 15:04:15 +0100
Message-ID: <20261118140421.584086-4-giometti@enneenne.com>
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
X-CMAE-Envelope: MS4xfN4aS6QuPJBvjUCjh1TLCqNOiwD9JJZC0RsoyzsxnmWljiDL2LPxxCkgYdSevusWK9TrDQ5DHRnnCOXccq0RXArif5cEVTOjYKo65bKOXxLZWsOMFfsM
 CNa7WFXtN26uSFYze9sOM2cVo9HyHPSCn0C9zs5MyaXUvuiBbKQSgxUkGXeFTzpG8JlkNJGGgJejH1NJDLcHeWMXGp3aNj/3cDKJaf0v1+EA8JrAkX6hk4VZ
 4GI5u+PuQbHgiZEOr97nrGEdTE6D8L14y9X297u9AISUfBhtyqmShzb1NrnIAlsPa6sgCOwdB8MqTNnlczKGeYmITsP2JA8nEsDmPT8Ru1/+G2wccBs3WLd4
 RPD1HtxcE4/SC0sIUd0jjScht6MZDK0+E0je+RjGofRzPeOxs2+1aVPkb4jfdjR3jt8TWi/1DOgC6Cd0JJqo+2yeXlUG/fBVo1+DC0qEKNtXLIXujw2j8PXh
 QMaCJD14nEO3Rj+APPinVfcwL703gaxEBNqc5GTde33ohF+ASMxQB8zNtzxzg2B+9kpm2ADbaFRYWPplH1bG4lQHMoNvelVnO3SPO6QXWQzY7OrNJxnfnpRh
 plHXSsAnWmVHJK6IJGlR5QFCSlozlrVyrf8lvUi9Zsq+QNydzlQ27TR0qq8RZAklFXQiY1T+py9oeGuUEZcMZEriPI8LEKf12EIzrwHcxic21Xaq9pOVnI86
 hWfVw4dfs4Mbip9VPql+PufjFu1M55Z5evoUMq3uIPIEM0jI40h+3xt7A60aGxLW8CWviexh2DKaWyLd1PnpxLgVAfoZyzR27vzS23s4T4a8q5WVaoT+B3W/
 sWOWxfNQN2buIkFNKe0uX7KcUBsYB6nTwMb4wSvEbx9p4XBe/BFGk1K2uu42PSD4cCXIg0NdSnSxq5xBj1nfvhduZI3/esILrSYAm33gYrl9shjDFrCU0j0e
 n9XxPZE1z1fOXP1C7CcPGPa5cDy2RCGQY29YA3fxzziKKYp79xWTSEwJQXYdG5i3a9xcTC0WACHFhgyvhpraczIkCRHqluGT9M0QPw4vwaPsIb/lq0cKDr3l
 7VDU59a2zN4n1tVs33BoRdeTpPZSO3w+tyEA6FaeZ1i/VcMSHucDlHDtFMuYaOy9PIB2iqdVYross3U+GS9FCGXdtfeO7qBV4jQoxTa1Q+5EISuS1wwpkeuM
 N2qRCd+rTJG7XStsJwCZKaxBfOlWydX9QrM/QLwEf4oHn52Ewr8ykW2VffH5NyE0Nw571iXmQKhQmWRl8SvRiO8HM8UlVBckmumJfNGH6p1RsmB0sn2T3rf/
 LMCcmxij76mX17pQPUGFGGSMSEwnrevkVIVZvh5fouVHmVw789Q=

Keys of the kernel tier are in clear in kernel memory while loaded,
and nothing the keycrypt core checks holds against a compromised
kernel. Add "optee", a backend of the tee tier.

One TA session is one operation context. The TA authenticates the
key's header again when the context opens, refuses an operation the
key's purpose does not allow, keeps the CBC chain and the HMAC state,
and compares a tag to verify without returning it: what keycrypt.rst's
"Backend requirements" asks of a backend against a compromised kernel.

The TA accepts only kernel clients. It is ta/keycrypt, written for
OP-TEE and not proposed to OP-TEE yet.

Signed-off-by: Rodolfo Giometti <giometti@enneenne.com>
---
 security/keys/keycrypt/Kconfig  |  17 ++
 security/keys/keycrypt/Makefile |   2 +
 security/keys/keycrypt/optee.c  | 437 ++++++++++++++++++++++++++++++++
 security/keys/keycrypt/optee.h  |  37 +++
 4 files changed, 493 insertions(+)
 create mode 100644 security/keys/keycrypt/optee.c
 create mode 100644 security/keys/keycrypt/optee.h

diff --git a/security/keys/keycrypt/Kconfig b/security/keys/keycrypt/Kconfig
index 50fd4cb3b1d2..e61922933bd7 100644
--- a/security/keys/keycrypt/Kconfig
+++ b/security/keys/keycrypt/Kconfig
@@ -98,3 +98,20 @@ config KEYCRYPT_SW
 	  masters (see the documentation).
 
 	  If you are unsure as to whether this is required, answer N.
+
+config KEYCRYPT_OPTEE
+	tristate "Keycrypt keys held by OP-TEE"
+	depends on KEYCRYPT && TEE
+	help
+	  This option provides the "optee" keycrypt backend, of the tee
+	  tier: keys sealed by the keycrypt Trusted Application under a
+	  key derived from the device's hardware unique key, and used only
+	  inside it. The kernel never holds such a key in clear, except
+	  one given to it to import. The keys are only as secret as that
+	  hardware unique key: with OP-TEE's test value (QEMU, or a board
+	  whose key is not provisioned) anyone can unseal them.
+
+	  It needs OP-TEE with the keycrypt TA built in as an early TA,
+	  which the driver finds on the TEE bus.
+
+	  If you are unsure as to whether this is required, answer N.
diff --git a/security/keys/keycrypt/Makefile b/security/keys/keycrypt/Makefile
index 5a2e222a6908..f051050428cd 100644
--- a/security/keys/keycrypt/Makefile
+++ b/security/keys/keycrypt/Makefile
@@ -3,3 +3,5 @@
 obj-y += core.o ctx.o
 obj-$(CONFIG_KEYCRYPT_SW) += keycrypt_sw.o
 keycrypt_sw-y := sw.o
+obj-$(CONFIG_KEYCRYPT_OPTEE) += keycrypt_optee.o
+keycrypt_optee-y := optee.o
diff --git a/security/keys/keycrypt/optee.c b/security/keys/keycrypt/optee.c
new file mode 100644
index 000000000000..5a3ab6f825f1
--- /dev/null
+++ b/security/keys/keycrypt/optee.c
@@ -0,0 +1,437 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * keycrypt - the OP-TEE backend
+ *
+ * Copyright (C) 2026 Rodolfo Giometti <giometti@enneenne.com>
+ */
+
+#include <keys/keycrypt.h>
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/tee_drv.h>
+#include <linux/uuid.h>
+#include "optee.h"
+
+#define KC_KEY_MAX	64	/* the longest key, hmac-sha256's */
+
+/*
+ * Offsets in a shared buffer, which carries one call's parameters at a
+ * time: header, blob and imported key for a control call; header, blob
+ * and IV for CTX_OPEN; data and tag for a context's later calls.
+ */
+#define KC_SHM_HDR	0
+#define KC_SHM_BLOB	(KC_SHM_HDR + KEYCRYPT_HEADER_MAX)
+#define KC_SHM_KEY	(KC_SHM_BLOB + KC_TA_DATA_MAX)
+#define KC_CTL_SIZE	(KC_SHM_KEY + KC_KEY_MAX)
+#define KC_SHM_DATA	0
+#define KC_SHM_TAG	(KC_SHM_DATA + KEYCRYPT_UPDATE_MAX)
+#define KC_SHM_IV	(KC_SHM_TAG + KEYCRYPT_MAC_LEN)
+#define KC_IV_LEN	sizeof_field(struct keycrypt_open_params, iv)
+#define KC_CTX_SIZE	(KC_SHM_IV + KC_IV_LEN)
+
+static_assert(KC_SHM_BLOB + KC_TA_DATA_MAX <= KC_SHM_TAG);
+static_assert(KEYCRYPT_UPDATE_MAX <= KC_TA_BUF_MAX);
+
+/**
+ * struct kc_optee - the backend's link to the TA
+ * @tee: the TEE context of every session, NULL while no TA device is bound
+ * @uuid: the TA's
+ * @ctl: the control session (GENERATE, IMPORT, CHECK), open while the
+ *	backend is registered
+ * @ctl_shm: its shared buffer
+ * @ctl_va: @ctl_shm's kernel address
+ * @ctl_lock: one control call at a time, the one @ctl_shm holds
+ */
+struct kc_optee {
+	struct tee_context *tee;
+	u8 uuid[TEE_IOCTL_UUID_LEN];
+	u32 ctl;
+	struct tee_shm *ctl_shm;
+	u8 *ctl_va;
+	struct mutex ctl_lock;	/* serialises the control calls */
+};
+
+/* A context: a TA session of its own, fixed to one operation */
+struct kc_optee_ctx {
+	u32 session;
+	u8 alg;
+	u32 op;
+	struct tee_shm *shm;
+	u8 *va;
+};
+
+static struct kc_optee kc_optee = {
+	.ctl_lock = __MUTEX_INITIALIZER(kc_optee.ctl_lock),
+};
+
+static void kc_memref(struct tee_param *p, u64 attr, struct tee_shm *shm,
+		      size_t offs, size_t size)
+{
+	p->attr = attr;
+	p->u.memref.shm = shm;
+	p->u.memref.shm_offs = offs;
+	p->u.memref.size = size;
+}
+
+/*
+ * The TA's answers that reach user space as themselves; any other is
+ * -EIO, as the core narrows a backend's errors anyway.
+ */
+static int kc_errno(u32 res)
+{
+	switch (res) {
+	case KC_TEE_SUCCESS:
+		return 0;
+	case KC_TEE_ERROR_MAC_INVALID:
+		return -EBADMSG;
+	case KC_TEE_ERROR_OUT_OF_MEMORY:
+		return -ENOMEM;
+	default:
+		return -EIO;
+	}
+}
+
+static int kc_invoke(u32 session, u32 func, struct tee_param *p)
+{
+	struct tee_ioctl_invoke_arg arg = {
+		.func = func,
+		.session = session,
+		.num_params = 4,
+	};
+	int ret;
+
+	ret = tee_client_invoke_func(kc_optee.tee, &arg, p);
+	if (ret)
+		return ret == -ENOMEM ? ret : -EIO;
+	return kc_errno(arg.ret);
+}
+
+static int kc_open_session(u32 *session)
+{
+	struct tee_ioctl_open_session_arg arg = {
+		.clnt_login = TEE_IOCTL_LOGIN_REE_KERNEL,
+	};
+	int ret;
+
+	memcpy(arg.uuid, kc_optee.uuid, sizeof(arg.uuid));
+	ret = tee_client_open_session(kc_optee.tee, &arg, NULL);
+	if (ret)
+		return ret == -ENOMEM ? ret : -EIO;
+	ret = kc_errno(arg.ret);
+	if (!ret)
+		*session = arg.session;
+	return ret;
+}
+
+static int kc_seal(u32 func, const u8 *hdr, u32 hdr_len, const u8 *key,
+		   size_t keylen, struct keycrypt_blob *out)
+{
+	struct tee_shm *shm = kc_optee.ctl_shm;
+	struct tee_param p[4] = {};
+	size_t len;
+	int n = 0;
+	int ret;
+
+	if (hdr_len > KEYCRYPT_HEADER_MAX || keylen > KC_KEY_MAX)
+		return -EINVAL;
+	mutex_lock(&kc_optee.ctl_lock);
+	memcpy(kc_optee.ctl_va + KC_SHM_HDR, hdr, hdr_len);
+	kc_memref(&p[n++], TEE_IOCTL_PARAM_ATTR_TYPE_MEMREF_INPUT, shm,
+		  KC_SHM_HDR, hdr_len);
+	if (key) {
+		memcpy(kc_optee.ctl_va + KC_SHM_KEY, key, keylen);
+		kc_memref(&p[n++], TEE_IOCTL_PARAM_ATTR_TYPE_MEMREF_INPUT, shm,
+			  KC_SHM_KEY, keylen);
+	}
+	kc_memref(&p[n], TEE_IOCTL_PARAM_ATTR_TYPE_MEMREF_OUTPUT, shm,
+		  KC_SHM_BLOB, KC_TA_DATA_MAX);
+	ret = kc_invoke(kc_optee.ctl, func, p);
+	len = p[n].u.memref.size;
+	if (!ret && (!len || len > KC_TA_DATA_MAX))
+		ret = -EIO;
+	if (!ret) {
+		out->data = kmemdup(kc_optee.ctl_va + KC_SHM_BLOB, len,
+				    GFP_KERNEL);
+		ret = out->data ? 0 : -ENOMEM;
+		out->len = len;
+	}
+	memzero_explicit(kc_optee.ctl_va, KC_CTL_SIZE);
+	mutex_unlock(&kc_optee.ctl_lock);
+	return ret;
+}
+
+static int kc_optee_generate(struct keycrypt_backend *b,
+			     const struct keycrypt_meta *m, const u8 *hdr,
+			     u32 hdr_len, const char *opts,
+			     struct keycrypt_blob *out)
+{
+	return kc_seal(KC_TA_CMD_GENERATE, hdr, hdr_len, NULL, 0, out);
+}
+
+static int kc_optee_import(struct keycrypt_backend *b,
+			   const struct keycrypt_meta *m, const u8 *hdr,
+			   u32 hdr_len, const char *opts, const u8 *key,
+			   size_t keylen, struct keycrypt_blob *out)
+{
+	return kc_seal(KC_TA_CMD_IMPORT, hdr, hdr_len, key, keylen, out);
+}
+
+static int kc_optee_load(struct keycrypt_backend *b, struct keycrypt_key *k,
+			 const char *opts)
+{
+	struct tee_shm *shm = kc_optee.ctl_shm;
+	struct tee_param p[4] = {};
+	int ret;
+
+	/* Not the TA's: it would refuse it as not authenticating */
+	if (k->hdr_len > KEYCRYPT_HEADER_MAX || k->data_len > KC_TA_DATA_MAX)
+		return -EBADMSG;
+	mutex_lock(&kc_optee.ctl_lock);
+	memcpy(kc_optee.ctl_va + KC_SHM_HDR, k->hdr, k->hdr_len);
+	memcpy(kc_optee.ctl_va + KC_SHM_BLOB, k->data, k->data_len);
+	kc_memref(&p[0], TEE_IOCTL_PARAM_ATTR_TYPE_MEMREF_INPUT, shm,
+		  KC_SHM_HDR, k->hdr_len);
+	kc_memref(&p[1], TEE_IOCTL_PARAM_ATTR_TYPE_MEMREF_INPUT, shm,
+		  KC_SHM_BLOB, k->data_len);
+	ret = kc_invoke(kc_optee.ctl, KC_TA_CMD_CHECK, p);
+	memzero_explicit(kc_optee.ctl_va, KC_CTL_SIZE);
+	mutex_unlock(&kc_optee.ctl_lock);
+	return ret;
+}
+
+static void kc_ctx_release(struct kc_optee_ctx *c)
+{
+	memzero_explicit(c->va, KC_CTX_SIZE);
+	tee_shm_free(c->shm);
+	kfree(c);
+}
+
+static int kc_optee_ctx_open(struct keycrypt_backend *b,
+			     struct keycrypt_key *k, u32 op, u8 *iv,
+			     void **ctx)
+{
+	struct tee_param p[4] = {};
+	struct kc_optee_ctx *c;
+	int ret;
+
+	if (k->hdr_len > KEYCRYPT_HEADER_MAX || k->data_len > KC_TA_DATA_MAX)
+		return -EIO;
+	c = kzalloc_obj(*c, GFP_KERNEL_ACCOUNT);
+	if (!c)
+		return -ENOMEM;
+	/* The session first: a full TA table refuses before any buffer */
+	ret = kc_open_session(&c->session);
+	if (ret)
+		goto free_ctx;
+	c->shm = tee_shm_alloc_kernel_buf(kc_optee.tee, KC_CTX_SIZE);
+	if (IS_ERR(c->shm)) {
+		ret = -ENOMEM;
+		goto close_session;
+	}
+	c->va = tee_shm_get_va(c->shm, 0);
+	if (IS_ERR(c->va)) {
+		ret = -EIO;
+		goto free_shm;
+	}
+
+	memcpy(c->va + KC_SHM_HDR, k->hdr, k->hdr_len);
+	memcpy(c->va + KC_SHM_BLOB, k->data, k->data_len);
+	memcpy(c->va + KC_SHM_IV, iv, KC_IV_LEN);
+	kc_memref(&p[0], TEE_IOCTL_PARAM_ATTR_TYPE_MEMREF_INPUT, c->shm,
+		  KC_SHM_HDR, k->hdr_len);
+	kc_memref(&p[1], TEE_IOCTL_PARAM_ATTR_TYPE_MEMREF_INPUT, c->shm,
+		  KC_SHM_BLOB, k->data_len);
+	p[2].attr = TEE_IOCTL_PARAM_ATTR_TYPE_VALUE_INPUT;
+	p[2].u.value.a = op;
+	kc_memref(&p[3], TEE_IOCTL_PARAM_ATTR_TYPE_MEMREF_INOUT, c->shm,
+		  KC_SHM_IV, KC_IV_LEN);
+	ret = kc_invoke(c->session, KC_TA_CMD_CTX_OPEN, p);
+	if (!ret && p[3].u.memref.size != KC_IV_LEN)
+		ret = -EIO;
+	if (ret)
+		goto wipe;
+	memzero_explicit(c->va, KC_CTX_SIZE);
+	c->alg = k->meta.alg;
+	c->op = op;
+	*ctx = c;
+	return 0;
+
+wipe:
+	memzero_explicit(c->va, KC_CTX_SIZE);
+free_shm:
+	tee_shm_free(c->shm);
+close_session:
+	tee_client_close_session(kc_optee.tee, c->session);
+free_ctx:
+	kfree(c);
+	return ret;
+}
+
+static int kc_optee_update(struct keycrypt_backend *b, void *ctx,
+			   const u8 *in, u8 *out, size_t len)
+{
+	struct kc_optee_ctx *c = ctx;
+	bool mac = c->alg == KEYCRYPT_ALG_HMAC_SHA256;
+	struct tee_param p[4] = {};
+	int ret;
+
+	if (len > KEYCRYPT_UPDATE_MAX)
+		return -EIO;
+	memcpy(c->va + KC_SHM_DATA, in, len);
+	kc_memref(&p[0], mac ? TEE_IOCTL_PARAM_ATTR_TYPE_MEMREF_INPUT :
+		  TEE_IOCTL_PARAM_ATTR_TYPE_MEMREF_INOUT, c->shm,
+		  KC_SHM_DATA, len);
+	ret = kc_invoke(c->session, KC_TA_CMD_UPDATE, p);
+	if (!ret && !mac && p[0].u.memref.size != len)
+		ret = -EIO;
+	if (!ret && !mac)
+		memcpy(out, c->va + KC_SHM_DATA, len);
+	memzero_explicit(c->va + KC_SHM_DATA, len);
+	return ret;
+}
+
+static int kc_optee_final(struct keycrypt_backend *b, void *ctx, u8 *out,
+			  size_t out_size, size_t *len)
+{
+	struct kc_optee_ctx *c = ctx;
+	struct tee_param p[4] = {};
+	bool mac = c->op == KEYCRYPT_OP_MAC;
+	int ret;
+
+	if (mac) {
+		if (out_size < KEYCRYPT_MAC_LEN)
+			return -EIO;
+		kc_memref(&p[0], TEE_IOCTL_PARAM_ATTR_TYPE_MEMREF_OUTPUT,
+			  c->shm, KC_SHM_TAG, KEYCRYPT_MAC_LEN);
+	}
+	ret = kc_invoke(c->session, KC_TA_CMD_FINAL, p);
+	if (!ret && mac && p[0].u.memref.size != KEYCRYPT_MAC_LEN)
+		ret = -EIO;
+	if (!ret && mac)
+		memcpy(out, c->va + KC_SHM_TAG, KEYCRYPT_MAC_LEN);
+	*len = !ret && mac ? KEYCRYPT_MAC_LEN : 0;
+	memzero_explicit(c->va + KC_SHM_TAG, KEYCRYPT_MAC_LEN);
+	return ret;
+}
+
+static int kc_optee_verify(struct keycrypt_backend *b, void *ctx,
+			   const u8 *expected)
+{
+	struct kc_optee_ctx *c = ctx;
+	struct tee_param p[4] = {};
+	int ret;
+
+	memcpy(c->va + KC_SHM_TAG, expected, KEYCRYPT_MAC_LEN);
+	kc_memref(&p[0], TEE_IOCTL_PARAM_ATTR_TYPE_MEMREF_INPUT, c->shm,
+		  KC_SHM_TAG, KEYCRYPT_MAC_LEN);
+	ret = kc_invoke(c->session, KC_TA_CMD_VERIFY, p);
+	memzero_explicit(c->va + KC_SHM_TAG, KEYCRYPT_MAC_LEN);
+	return ret;
+}
+
+static void kc_optee_ctx_free(struct keycrypt_backend *b, void *ctx)
+{
+	struct kc_optee_ctx *c = ctx;
+
+	tee_client_close_session(kc_optee.tee, c->session);
+	kc_ctx_release(c);
+}
+
+static struct keycrypt_backend keycrypt_optee = {
+	.name		= "optee",
+	.tier		= KEYCRYPT_TIER_TEE,
+	.algs		= KEYCRYPT_ALGS_ALL,
+	.owner		= THIS_MODULE,
+	.generate	= kc_optee_generate,
+	.import		= kc_optee_import,
+	.load		= kc_optee_load,
+	.ctx_open	= kc_optee_ctx_open,
+	.update		= kc_optee_update,
+	.final		= kc_optee_final,
+	.verify		= kc_optee_verify,
+	.ctx_free	= kc_optee_ctx_free,
+};
+
+static int kc_optee_match(struct tee_ioctl_version_data *ver,
+			  const void *data)
+{
+	return ver->impl_id == TEE_IMPL_ID_OPTEE;
+}
+
+static int kc_optee_probe(struct tee_client_device *tdev)
+{
+	struct tee_context *tee;
+	int ret;
+
+	/* One backend, so one TA device: a second one is refused untouched */
+	if (kc_optee.tee)
+		return -EBUSY;
+	tee = tee_client_open_context(NULL, kc_optee_match, NULL, NULL);
+	if (IS_ERR(tee))
+		return -ENODEV;
+	kc_optee.tee = tee;
+	memcpy(kc_optee.uuid, tdev->id.uuid.b, TEE_IOCTL_UUID_LEN);
+	kc_optee.ctl_shm = tee_shm_alloc_kernel_buf(kc_optee.tee, KC_CTL_SIZE);
+	if (IS_ERR(kc_optee.ctl_shm)) {
+		ret = PTR_ERR(kc_optee.ctl_shm);
+		goto close_tee;
+	}
+	kc_optee.ctl_va = tee_shm_get_va(kc_optee.ctl_shm, 0);
+	if (IS_ERR(kc_optee.ctl_va)) {
+		ret = PTR_ERR(kc_optee.ctl_va);
+		goto free_shm;
+	}
+	ret = kc_open_session(&kc_optee.ctl);
+	if (ret) {
+		dev_err(&tdev->dev, "cannot open a session to the keycrypt TA: %d\n",
+			ret);
+		goto free_shm;
+	}
+	ret = keycrypt_register_backend(&keycrypt_optee);
+	if (ret)
+		goto close_ctl;
+	return 0;
+
+close_ctl:
+	tee_client_close_session(kc_optee.tee, kc_optee.ctl);
+free_shm:
+	tee_shm_free(kc_optee.ctl_shm);
+close_tee:
+	tee_client_close_context(kc_optee.tee);
+	kc_optee.tee = NULL;
+	return ret;
+}
+
+static void kc_optee_remove(struct tee_client_device *tdev)
+{
+	keycrypt_unregister_backend(&keycrypt_optee);
+	tee_client_close_session(kc_optee.tee, kc_optee.ctl);
+	tee_shm_free(kc_optee.ctl_shm);
+	tee_client_close_context(kc_optee.tee);
+	kc_optee.tee = NULL;
+}
+
+static const struct tee_client_device_id kc_optee_id_table[] = {
+	{ UUID_INIT(0x65a0d9f0, 0xf057, 0x414c,
+		    0x9d, 0x5a, 0x9a, 0xac, 0x7c, 0x8b, 0xa4, 0x61) },
+	{}
+};
+MODULE_DEVICE_TABLE(tee, kc_optee_id_table);
+
+static struct tee_client_driver kc_optee_driver = {
+	.probe		= kc_optee_probe,
+	.remove		= kc_optee_remove,
+	/* Sessions left open would outlive a kexec in the secure world */
+	.shutdown	= kc_optee_remove,
+	.id_table	= kc_optee_id_table,
+	.driver		= {
+		.name	= "keycrypt-optee",
+	},
+};
+module_tee_client_driver(kc_optee_driver);
+
+MODULE_DESCRIPTION("keycrypt OP-TEE backend");
+MODULE_LICENSE("GPL");
diff --git a/security/keys/keycrypt/optee.h b/security/keys/keycrypt/optee.h
new file mode 100644
index 000000000000..391eba15b699
--- /dev/null
+++ b/security/keys/keycrypt/optee.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * keycrypt - the OP-TEE backend's protocol with the keycrypt TA
+ *
+ * The TA's interface is ta/keycrypt/include/keycrypt_ta.h in OP-TEE: the
+ * command numbers and limits below are its, and neither side changes one
+ * alone. The operation, and the algorithm, purpose and tier in a key's
+ * header, reach the TA as keycrypt's own values, which that file repeats.
+ * The result codes are GlobalPlatform's.
+ *
+ * Copyright (C) 2026 Rodolfo Giometti <giometti@enneenne.com>
+ */
+
+#ifndef _SECURITY_KEYS_KEYCRYPT_OPTEE_H
+#define _SECURITY_KEYS_KEYCRYPT_OPTEE_H
+
+#include <linux/types.h>
+
+#define KC_TA_CMD_GENERATE	0
+#define KC_TA_CMD_IMPORT	1
+#define KC_TA_CMD_CHECK		2
+#define KC_TA_CMD_CTX_OPEN	3
+#define KC_TA_CMD_UPDATE	4
+#define KC_TA_CMD_FINAL		5
+#define KC_TA_CMD_VERIFY	6
+
+#define KC_TA_DATA_MAX		93	/* the TA's data: 1 + 12 + 64 + 16 */
+#define KC_TA_BUF_MAX		65536	/* data of one UPDATE */
+/* The TA's limit, the control session included; not enforced here */
+#define KC_TA_SESSIONS_MAX	32
+
+/* GlobalPlatform TEE result codes */
+#define KC_TEE_SUCCESS			0x00000000
+#define KC_TEE_ERROR_OUT_OF_MEMORY	0xffff000c
+#define KC_TEE_ERROR_MAC_INVALID	0xffff3071
+
+#endif /* _SECURITY_KEYS_KEYCRYPT_OPTEE_H */
-- 
2.43.0

