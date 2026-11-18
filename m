Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.156.116
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795011063;
	b=u8vae08SnksnJX/I/MFOKMqOOkX3GVtwD5duokm7NmnfYeqWL9I9oR+5mr/sIHg6M4VT
	 ayUfftHWLjhjhOG8ISnfGpOTODiYtP83u3XFnSR2BJFHRqwkBIdpEA950nwxEucxQT/CJ
	 26Ot0Fd3nZ//fc0LEvhPiIj6vFCRvQUPcs013yAgED2Zmotr6biC84w+bL5jZsusCOPtX
	 6FyNBTUhA9U8Ja3oTrtBCuwfTrnK9QQB9OSduw4gmxdnxD/S1rZLYDO65NalFgYRV6YCM
	 3QArBJ25mtrnLQRdvdtebyS0FzFBVWrzZpK5Jjm8xmHX9qDAjYGO/roHrJphmV+3C7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795011063;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CMAE-Envelope;
	bh=fKl8MNySZ88IUVeu2UU7VcrqEn+ayXaw8/l2vB54HEo=;
	b=jO5y8g9HXZOVIQLWN2D6d4sjeW1MMuS4wLa3/CoPOSl8Ez3sgeg+jmm0hhMXWH6VCAHR
	 eGYqZ5vlTuw8+LnnvZMLcuMX/atLMET2tFNMWLekcCcAKgSeMBErEeTrRUlZytKuRVfsN
	 7Rtj1Q5Ssjjkvz2l1HQdmQvGKvWxWw+J1XCRT0+OBLXBAXkjPK5JLkHg4d2leen86CKKY
	 fsj5X3asqQSamhPElXjEVeXbBuwPWPgKQVUG4J3Y6kYcs5lVNyF4t7d0YjSa1rx2XfTsa
	 psfvarlqd3SOI9gAZRi7p1L8gAIe58trzKRXfZzrs1sc1jhrckkvfca1cn8Qan6r0+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=enneenne.com;
	spf=pass smtp.mailfrom=enneenne.com;
	dkim=pass header.d=aruba.it header.i=@aruba.it header.a=rsa-sha256 header.s=a1 header.b=eJWb9UxQ;
	arc=none smtp.remote-ip=62.149.156.116
Received: from smtpcmd11116.aruba.it (smtpcmd11116.aruba.it [62.149.156.116])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F57606A339
	for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 14:11:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 65F57606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=enneenne.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=enneenne.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.a=rsa-sha256 header.s=a1 header.b=eJWb9UxQ
Received: from polimar.tail4f75e6.ts.net ([101.57.122.26])
	by Aruba SMTP with ESMTPSA
	id TgNAx52bt6VShTgNAxMwjf; Wed, 18 Nov 2026 15:10:53 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1795011053; bh=GvPGRQ87Mt+BUKvr7jj3/S+NK4dYrqykH+GKaaPi5aQ=;
	h=From:To:Subject:Date:MIME-Version;
	b=eJWb9UxQhFL46ix3TFV/rWxZQYgNwDgvkzEXGxx+dAa0fIKa9nl6xxcu9R1sqUsQU
	 70TNopPpMPKX8+sMA7PxML6zXGo20jAZEARneS5fgPEgSsBK6yI0iJ+QjgFO+wi+Xm
	 7F9YW8NuDMvNxEiKMV1M0U1Dt1kpDYpVLyRWH323K3W5oa+SPn0cCsrgX9NbKMZEUF
	 QI/6X+293T3J0m+tatOCHPQJa0Jwu2SiFIKOGj39lP0nc5Ta9jCtldrqtp8gDoJsDH
	 2NspoD23D3W/ZaYc7jgdodUkPwwTrocn7clOezUpe7y/vQbj8OgGjNA/7uqrdFjVHp
	 Er5lI35K1r0Ew==
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
Subject: [RFC PATCH 7/9] crypto: caam - add an internal cbc(paes) taking the blob's key modifier
Date: Wed, 18 Nov 2026 15:10:47 +0100
Message-ID: <20261118141047.616989-1-giometti@enneenne.com>
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
X-CMAE-Envelope: MS4xfE5OpqY75Ap3Fw41rg59MeMfDJL8VLBXfB7grLmJrcheJpfdBBjwj4/o3/jJ+Oq/GidTZ5rPY+KvdqwBHB0smNkdNjPlFYZQ/YMI66SfBxOdEt7QQmuJ
 VxyiSgTYAk6BtCBqQJ4PJc/1GFqvSANx4AQ7GBzWENhF/z1l/fUyGnUY9UVdgfmMtcV5fB/gT3qg4t60O8gkg/AZ5klrgiJk+94IiD8iv8e1an81pI8cY/3B
 iPsu7US/wz9binHbc+L1ce3G8HBgP6gu1qPrGRY94h1XBiuYRKdBjzV+qrlnssejxIQklBlk6wDsbfy/+hQPAOmJuOalB51CIE78GPs9BvDU9c1VYtQNUGPN
 FaNzJTBwYs1vnylakFLkGjXrcDuZ6ElzzijYPmMU/8mxaZ/iXnoJo0noL3UEDlTEoWvFgthTjooPrgwq9r5An5SWmuvA5jhcpDaWjGNPeVpJX/X4mZykjMP9
 dROwmsgDD7Ky0w87+5in9Kr0JTdltoisiZvcKxAp7sqzZ55KrkvjaqH5wQIi1o8veWwci7KpRx48j9G74P4yQsT4ES7thJ21J8gZNqzkeSPFsgIMZb/jKX6S
 Iu4VZmJ1++s2x6l/0cEWtRphuW3Rt6RFezF7qhecDIgg60M/qwsf5E3zKFQ9BnYLobNFEcAg0HY/9d8CPS3USBlzD3aw+5sjpU2cGD9mgzXNZjzz3FRjJQQf
 t6zFocVmFWMtja1S4fFwN4AmjrcFmaTfoniARPlzw7HZd8PS+BC6sMjTOqpFycfcAcpUKbkSVJgxscf8zaWY0TpQlK4L+VtMiqA0QkMh3WPmB83rA3V+W5oi
 NCJCAYKLYHIkbxIhj8o5jILr/DS6haFVdy1dUUBurNJ3NVEhx/7Vl88aA8W6T1sH03o37BahwRPZn9W3PWKa0+F0AMmPB3Zkttbaf03m96JKwG76aRUeJBj8
 5xtJMj/9ikF/QABBS2kBAMsoYo8Yi0R3vwwVn00LXawbU+eDbEq1DkfZAknqDK5dl5fgvTfDZQO1i3pGoqY90YcSZxgFrGTDxXyD3hnj7fi+90DdqodpZhRD
 xqXY4AaXY6IIpB208HEZi3ndRW+e0hAGd5fM6+65sHfl5qcu1IoMhDjUbotryYDCK8E1dTajC7Xq5L32ML6B9xgnWnsyHAD1r24tb3fl9RGugkZlWZCRow/y
 RufAhx/8Z1aOsTca/tWcherpNmTt7Qw1IVKhW9m2lo+VBNWml7Hskh/nR2lJSEzgI7V0Z0OAjTkr5i/h03plD6qzcTX5PETQI/AeHui6KZd5h/lpfc/YAH9d
 e+lQLGjp76Zpu9yJ4OG4//vtWGgSPc4Cx0hei1rRAjgeKvmCvQ0=

cbc(paes) decapsulates every blob with the fixed key modifier
"SECURE_KEY", the one trusted keys use for their "pk" keys, and is
reachable from AF_ALG: a blob made for either can be used through the
other by whoever holds CAP_NET_ADMIN or CAP_SYS_ADMIN (with AF_ALG's
default restriction), for whatever operation they choose. A kernel
user that wants its blobs bound to something of its own, such as the
metadata of the key they protect, has no way to say so.

Add a second cbc(paes), cbc-paes-km-caam, flagged CRYPTO_ALG_INTERNAL
so that only kernel code asking for that flag can allocate it, as the
DCP's paes is, which trusted keys allocate by driver name with that
flag; its key names the key modifier to decapsulate with.
caam_encap_blob() already takes a caller's key modifier, so a kernel
user can now bind its blobs to a value of its own.

Its only user is the keycrypt CAAM backend, which is a proposal, and
so is this.

Signed-off-by: Rodolfo Giometti <giometti@enneenne.com>
---
 drivers/crypto/caam/caamalg.c      | 89 ++++++++++++++++++++++++++----
 drivers/crypto/caam/caamalg_desc.c |  3 +-
 drivers/crypto/caam/caamalg_desc.h |  1 +
 include/soc/fsl/caam-blob.h        |  8 +++
 4 files changed, 89 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index d00caa9cdf8e..f34717f312b8 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -125,6 +125,8 @@ struct caam_ctx {
 	dma_addr_t key_dma;
 	u8 protected_key[CAAM_MAX_KEY_SIZE];
 	dma_addr_t protected_key_dma;
+	u8 key_mod[CAAM_BLOB_KEYMOD_LENGTH];
+	unsigned int key_mod_len;
 	enum dma_data_direction dir;
 	struct device *jrdev;
 	struct alginfo adata;
@@ -784,18 +786,19 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	return 0;
 }
 
-static int paes_skcipher_setkey(struct crypto_skcipher *skcipher,
-				const u8 *key,
-				unsigned int keylen)
+static int paes_set_blob(struct crypto_skcipher *skcipher,
+			 const struct caam_pkey_info *pkey_info,
+			 const u8 *blob, unsigned int keylen,
+			 const u8 *key_mod, unsigned int key_mod_len)
 {
-	struct caam_pkey_info *pkey_info = (struct caam_pkey_info *)key;
 	struct caam_ctx *ctx = crypto_skcipher_ctx_dma(skcipher);
 	struct device *jrdev = ctx->jrdev;
 	int err;
 
-	ctx->cdata.key_inline = false;
+	if (WARN_ON(key_mod_len > CAAM_BLOB_KEYMOD_LENGTH))
+		return -EINVAL;
 
-	keylen = keylen - CAAM_PKEY_HEADER;
+	ctx->cdata.key_inline = false;
 
 	if (pkey_info->is_pkey != 1) {
 		dev_dbg(jrdev, "not a protected key\n");
@@ -842,19 +845,52 @@ static int paes_skcipher_setkey(struct crypto_skcipher *skcipher,
 	/* Retrieve the length of blob*/
 	ctx->cdata.keylen = keylen;
 
-	/* Retrieve the address of the blob */
-	ctx->cdata.key_virt = pkey_info->key_buf;
-
 	/* set command option */
 	ctx->cdata.key_cmd_opt = KEY_ENC;
 
-	memcpy(ctx->key, ctx->cdata.key_virt, keylen);
+	/* The key modifier the blob is decapsulated with, at every job */
+	memcpy(ctx->key_mod, key_mod, key_mod_len);
+	ctx->key_mod_len = key_mod_len;
+
+	/* Retrieve the address of the blob */
+	memcpy(ctx->key, blob, keylen);
+	ctx->cdata.key_virt = ctx->key;
 	dma_sync_single_for_device(jrdev, ctx->key_dma, keylen, DMA_TO_DEVICE);
 	ctx->cdata.key_dma = ctx->key_dma;
 
 	return 0;
 }
 
+static int paes_skcipher_setkey(struct crypto_skcipher *skcipher,
+				const u8 *key,
+				unsigned int keylen)
+{
+	const struct caam_pkey_info *pkey_info =
+		(const struct caam_pkey_info *)key;
+
+	return paes_set_blob(skcipher, pkey_info, pkey_info->key_buf,
+			     keylen - CAAM_PKEY_HEADER, KEYMOD,
+			     sizeof(KEYMOD) - 1);
+}
+
+/*
+ * The internal cbc(paes): the blob comes with the key modifier it was
+ * encapsulated with, which only kernel code can choose; a caller that
+ * picks a modifier of its own keeps its blobs apart from those of
+ * cbc(paes) and of trusted "pk" keys
+ */
+static int paes_km_skcipher_setkey(struct crypto_skcipher *skcipher,
+				   const u8 *key,
+				   unsigned int keylen)
+{
+	const struct caam_pkey_info *pkey_info =
+		(const struct caam_pkey_info *)key;
+
+	return paes_set_blob(skcipher, pkey_info, key + CAAM_PKEY_KM_HEADER,
+			     keylen - CAAM_PKEY_KM_HEADER,
+			     key + CAAM_PKEY_HEADER, CAAM_BLOB_KEYMOD_LENGTH);
+}
+
 static int aes_skcipher_setkey(struct crypto_skcipher *skcipher,
 			       const u8 *key, unsigned int keylen)
 {
@@ -1398,7 +1434,9 @@ static int init_skcipher_job(struct skcipher_request *req,
 		edesc->desc_dma = desc_dma;
 		edesc->desc_dma_bytes = desc_bytes(desc);
 
-		cnstr_desc_protected_blob_decap(edesc->hw_desc, &ctx->cdata, desc_dma);
+		cnstr_desc_protected_blob_decap(edesc->hw_desc, &ctx->cdata,
+						ctx->key_mod, ctx->key_mod_len,
+						desc_dma);
 	} else {
 		sh_desc = encrypt ? ctx->sh_desc_enc : ctx->sh_desc_dec;
 		ptr = encrypt ? ctx->sh_desc_enc_dma : ctx->sh_desc_dec_dma;
@@ -2031,6 +2069,30 @@ static struct caam_skcipher_alg driver_algs[] = {
 		.caam.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
 		.caam.is_paes = true,
 	},
+	{
+		.skcipher.base = {
+			.base = {
+				.cra_name = "cbc(paes)",
+				.cra_driver_name = "cbc-paes-km-caam",
+				.cra_blocksize = AES_BLOCK_SIZE,
+				/* kernel users only: never from AF_ALG */
+				.cra_flags = CRYPTO_ALG_INTERNAL,
+			},
+			.setkey = paes_km_skcipher_setkey,
+			.encrypt = skcipher_encrypt,
+			.decrypt = skcipher_decrypt,
+			.min_keysize = AES_MIN_KEY_SIZE + CAAM_BLOB_OVERHEAD +
+				       CAAM_PKEY_KM_HEADER,
+			.max_keysize = AES_MAX_KEY_SIZE + CAAM_BLOB_OVERHEAD +
+				       CAAM_PKEY_KM_HEADER,
+			.ivsize = AES_BLOCK_SIZE,
+		},
+		.skcipher.op = {
+			.do_one_request = skcipher_do_one_req,
+		},
+		.caam.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
+		.caam.is_paes = true,
+	},
 	{
 		.skcipher.base = {
 			.base = {
@@ -3812,6 +3874,11 @@ static int caam_cra_init(struct crypto_skcipher *tfm)
 		 * AF_ALG refuses ALG_SET_KEY once an op socket exists, so
 		 * concurrent jobs all decapsulate the same blob into the same
 		 * black key.
+		 * In-kernel users of the internal cbc(paes) set the key once,
+		 * before any request, as well. It also relies on the black
+		 * key being decapsulated identically by every job, which ECB
+		 * black keys are; CCM ones, with their random nonce, would
+		 * need a buffer per request.
 		 */
 		ctx->protected_key_dma = dma_map_single(ctx->jrdev,
 							ctx->protected_key,
diff --git a/drivers/crypto/caam/caamalg_desc.c b/drivers/crypto/caam/caamalg_desc.c
index 04c1105eb1f5..db3bbba67c8b 100644
--- a/drivers/crypto/caam/caamalg_desc.c
+++ b/drivers/crypto/caam/caamalg_desc.c
@@ -1410,6 +1410,7 @@ void cnstr_desc_skcipher_enc_dec(u32 * const desc, struct alginfo *cdata,
 EXPORT_SYMBOL(cnstr_desc_skcipher_enc_dec);
 
 void cnstr_desc_protected_blob_decap(u32 * const desc, struct alginfo *cdata,
+				     const u8 *key_mod, unsigned int key_mod_len,
 				     dma_addr_t next_desc_addr)
 {
 	u32 protected_store;
@@ -1417,7 +1418,7 @@ void cnstr_desc_protected_blob_decap(u32 * const desc, struct alginfo *cdata,
 	init_job_desc(desc, 0);
 
 	/* Load key modifier */
-	append_load_as_imm(desc, KEYMOD, sizeof(KEYMOD) - 1,
+	append_load_as_imm(desc, key_mod, key_mod_len,
 			   LDST_CLASS_2_CCB | LDST_SRCDST_BYTE_KEY);
 
 	append_seq_in_ptr_intlen(desc, cdata->key_dma,
diff --git a/drivers/crypto/caam/caamalg_desc.h b/drivers/crypto/caam/caamalg_desc.h
index 323490a4a756..ae673b596a6d 100644
--- a/drivers/crypto/caam/caamalg_desc.h
+++ b/drivers/crypto/caam/caamalg_desc.h
@@ -117,6 +117,7 @@ void cnstr_shdsc_xts_skcipher_encap(u32 * const desc, struct alginfo *cdata);
 void cnstr_shdsc_xts_skcipher_decap(u32 * const desc, struct alginfo *cdata);
 
 void cnstr_desc_protected_blob_decap(u32 * const desc, struct alginfo *cdata,
+				     const u8 *key_mod, unsigned int key_mod_len,
 				     dma_addr_t next_desc);
 
 void cnstr_desc_skcipher_enc_dec(u32 * const desc, struct alginfo *cdata,
diff --git a/include/soc/fsl/caam-blob.h b/include/soc/fsl/caam-blob.h
index 922f7ec3e231..13c21c7e4c2e 100644
--- a/include/soc/fsl/caam-blob.h
+++ b/include/soc/fsl/caam-blob.h
@@ -38,6 +38,14 @@ struct caam_pkey_info {
 /* sizeof struct caam_pkey_info */
 #define CAAM_PKEY_HEADER		4
 
+/*
+ * A key of the CAAM's internal cbc(paes): struct caam_pkey_info, the
+ * CAAM_BLOB_KEYMOD_LENGTH-byte key modifier the blob was encapsulated
+ * with, then the blob
+ */
+#define CAAM_PKEY_KM_HEADER		(CAAM_PKEY_HEADER + \
+					 CAAM_BLOB_KEYMOD_LENGTH)
+
 /**
  * struct caam_blob_info - information for CAAM blobbing
  * @pkey_info:	 pointer to keep protected key information
-- 
2.43.0

