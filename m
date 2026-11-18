Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037332;
	b=r3KlmBEJM8ihk7OKiqXfM4GwbxgDf6b0LxjI4b++eSlYujiUQw6r8xL5v/7T8TqzBrjN
	 JQRD/2SOysb6ixfGZdxA/jyHI9DBlv3Kh5aII51qMArcdz/ea5fSymnmkrQOFI3Ul+zzb
	 lcbv4jeCJbFhw6AsBmm6NMkWwA6qkDYvQ9ML5/sLpwhpqCtCLM1MKrhaAB7R2o9pvMwGL
	 DsYJuSYHosk6HLtoN0sWnANKVdRFxkhc1yold4WYHZGZ8XTTJUpKBEwYIIaNFWC2cYgaX
	 s3zL1V86s6e4sHbcUIvfYx//QEcreiI5b28+TKdOpKljEdTh9KNOJdYxzC3jYd8I/kA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037332;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hq4FetZ9TbMuXfM2xTa4nRWlSTgcNRWAkocFboOGKak=;
	b=y4bA0N1eT4m1kcix78KSNF5yle+p21/iU73/1v3pbSfPwL0epxy7uIyYAxdEmoawAWIB
	 hswWMYeKeIWihCO75FsQ8zMgjTZn+sbXKvDZlj3CEEb1jIeXvNPKdo1J/lBbbiUs2bU4g
	 XOg8jOPC9syMPRtdF5e8JzJqhTILT/5gFy2KdtujDFU29qkhFsY+12foYKDegNxhhRXBD
	 P3LPqvcxka3PNBCGHHO4FvaTFnqmq7weI3jRKQj2dzqJPTVL3KGgxdxknf8bc+sW/ogkH
	 pxdZiPwgz1IzJ7JSZMs74q06JD0FJWn9eknkwftiE/rNhMJPJMIR4eGhg3bc5fqbLLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=soleen.com;
	spf=pass smtp.mailfrom=soleen.com;
	dkim=pass header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=BbqEuGsM;
	arc=none smtp.remote-ip=209.85.221.181
Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6271606A332
	for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 21:28:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B6271606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=BbqEuGsM
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-5eaa5e03c47so230344e0c.0
        for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 13:28:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1795037331; x=1795642131; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=hq4FetZ9TbMuXfM2xTa4nRWlSTgcNRWAkocFboOGKak=;
        b=BbqEuGsMb2OLXmUye1xIZ4ahKyCHhyvnM+t2gMHhvIVbiKlP4BxZ+qaQ0AqVZPl9TX
         AfsaH4/XBmXDC5XF4A58nWltOdmW++0dNBD+E1W6Yj0pefr+hkI1SNdszECsQrD6NZBs
         +UY4F15v1FAOep5Uvljx0cxBoYSnJsHPhAUbKg3aaDNS7KX3rXi4vgTYesZxdudz7qm9
         kGtjXjfItev7DHV8N0aJLeXbhOg6S647Gt8x/FSJpXpPWPbIAo/I1iw83umj+7pxdq/j
         syLf8jMmaxTK8lzHNwnWB3Y/vvAKxqAsyXzopkenTGWIccFn0tlF52bD4phwi2MU+N+F
         zwmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795037331; x=1795642131;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=hq4FetZ9TbMuXfM2xTa4nRWlSTgcNRWAkocFboOGKak=;
        b=BfThthE12DqEbRE0o3c6rlT2UJIL/Z67QKO/ku24ODiVU9qBnmzEjx7ELMLbuTsnVV
         aywv8FNBjasgQ1t26lgoGevBsFnfWdnzHYmajuejQyve/HQCXNB7m89zQXgRXrKOuIa6
         0IEvW0D/eb2F/z7Gj9ukiA7CLRZKDYo7FBTI5pn5qL+kv81lw1VH5l8DDGw9MDJpgM73
         Zcm/BA1egh/Oq5AfYzdFjKkILtlxhnzq6KDsnAcfJYXNRVZnoBFhPhvxG3yUqQPyZ2CY
         Tf45S0D8yFyBl2MmUaEYWaKG/GR30Ts3sCJ0B8LNgRPCGjkNOChPEYguNVnGV1/axVaS
         7EMQ==
X-Forwarded-Encrypted: i=1; AL+hErEvb9av3iC/RtrBoOfMGolI1NAcnkCCdbAt+jP8TpQ0cXRx/5s1vEAdU15xxm4MPVrouUfujAL9Jqc=@vger.kernel.org
X-Gm-Message-State: APuU4Z8Cr5q8LJXt93uoL1yGoidAOY5W/vfjeOHLaM+BdvhdKTdtZsBO
	dWObBMjx+dTMVoLaQQ0wTkj8sQGalFT8/4t9tKOpjxNMR+0KJVk40zxA1FeTt6PM+70=
X-Gm-Gg: AYBFou3blzVf0O03TNVmucgzVfrvtGeZSwMGhkyDeZbKB3Ok8mtbZxQY+IG4X7XwmIV
	aehT+90+QRw5ceoGSn90OTymob94ojH2Rq/10/+ZWRX1j6NljxEJhJlSTA24eRU6XI7ro3YEEIB
	LfOet8NZSRe/gxjkDfDSRdyIH7+Am8VEOyX1kktHAqT10KxeeQspSLUpVUU95S84LvViUsWoHio
	J7GNlKKqXVtgyDiGtsM22HQRETrxmtyhd2Qgcc1sgSZ/09GgeKAABpCu7B4vGcywi9zacIRVxoO
	pYYHSVkYIfdbn2LTaGfxCQv2gxzAwSBl2cPjZVorWRWg02afrqyKZtEMfLjwOt7jUuNS3QWcB0w
	9Ua7oS2CaFBe6TvNxfW511tllhKIIvlhFfgJJhf+mbsdRRjhUDbJ+L0QPn4Ax9iKZ5By89JF/0H
	tyvTBwmr55NhlgSjPfHeQw3sDP8osT1GKcTSWcuqTNWHmdMJrPHqYDR6FsQQh2VxH7aKWNhrP1f
	NKo/CIqLjIEckUZyCBvkmecnLAAOhF+tMh+OmtV6MDbq15qOaXrozl/BtlsAJ1/MJYtoC6aEo2y
	RLHRdx4+MDu96XRSUuQsNlcFv3BGmflM4mSMuxnaUJTedx+sH+Gj4rfk14hMgGwP/iHouXbG0ni
	vdHM0MOsjPjGnsJYV0c7TnLYxtwRH6YJjLsaSN0SBlbnVbtCjl0gb
X-Received: by 2002:a05:6102:548e:b0:7ba:b5ea:c4b8 with SMTP id ada2fe7eead31-7d6cb42f39emr262542137.1.1795037330488;
        Wed, 18 Nov 2026 13:28:50 -0800 (PST)
Received: from soleen.c.googlers.com.com (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7d6b9185bc3sm2724635137.5.2026.11.18.13.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 13:28:50 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	vipinsh@google.com,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	linux-api@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	graf@amazon.com
Subject: [PATCH v6 2/7] kho: link outgoing blocks lazily in kho_block
Date: Wed, 18 Nov 2026 16:28:37 -0500
Message-ID: <20261118212845.2855249-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
In-Reply-To: <20261118212845.2855249-1-pasha.tatashin@soleen.com>
References: <20261118212845.2855249-1-pasha.tatashin@soleen.com>
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

Currently, kho_block_add() links each preallocated block onto the
serialized chain immediately, even while it is still empty. This
assumes all preallocated blocks are populated together before the
chain is referenced by KHO.

When sessions are serialized incrementally ahead of reboot, extra
blocks may be preallocated for sessions that have not been serialized
yet. Keeping those blocks linked leaves empty trailing blocks on the
KHO chain.

Keep preallocated outgoing blocks unlinked in kho_block_add() and link
each block lazily in kho_block_set_it_reserve_entry() when advancing
into it. Also unlink blocks in kho_block_set_clear() and stop at
unlinked blocks in kho_block_set_it_read_entry().

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/kho_block.c | 38 +++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/kernel/liveupdate/kho_block.c b/kernel/liveupdate/kho_block.c
index 0d2a342ef422..21cee45fa1cc 100644
--- a/kernel/liveupdate/kho_block.c
+++ b/kernel/liveupdate/kho_block.c
@@ -16,6 +16,11 @@
  * array of serialized entries. Multiple blocks are linked together via a
  * physical pointer in the header, forming a linked list that can be easily
  * traversed in both the current and the next kernel.
+ *
+ * Outgoing blocks preallocated via kho_block_set_grow() remain unlinked until
+ * entries are reserved via kho_block_set_it_reserve_entry(). This allows
+ * entries to be serialized incrementally without exposing empty trailing blocks
+ * on the physical chain.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -79,7 +84,7 @@ static struct kho_block_header_ser *kho_block_alloc_ser(struct kho_block_set *bs
 static int kho_block_add(struct kho_block_set *bs,
 			 struct kho_block_header_ser *ser)
 {
-	struct kho_block *block, *last;
+	struct kho_block *block;
 
 	if (bs->nblocks >= KHO_MAX_BLOCKS)
 		return -ENOSPC;
@@ -89,15 +94,11 @@ static int kho_block_add(struct kho_block_set *bs,
 		return -ENOMEM;
 
 	block->ser = ser;
-	last = list_last_entry_or_null(&bs->blocks, struct kho_block, list);
+	if (list_empty(&bs->blocks))
+		bs->head_pa = virt_to_phys(ser);
 	list_add_tail(&block->list, &bs->blocks);
 	bs->nblocks++;
 
-	if (last)
-		last->ser->next = virt_to_phys(ser);
-	else
-		bs->head_pa = virt_to_phys(ser);
-
 	return 0;
 }
 
@@ -144,9 +145,9 @@ static void kho_block_set_shrink_one(struct kho_block_set *bs)
  * @bs:    The block set.
  * @count: The target number of valid entries to accommodate.
  *
- * Dynamically preallocates and links preserved memory blocks if the target
- * entry count exceeds the current total capacity of the set, ensuring they
- * are available during serialization/deserialization.
+ * Dynamically preallocates preserved memory blocks if the target entry count
+ * exceeds the current total capacity of the set, ensuring they are available
+ * during serialization/deserialization.
  *
  * Context: Caller must hold a lock protecting the block set.
  * Return: 0 on success, or a negative errno on failure.
@@ -312,12 +313,15 @@ void kho_block_set_destroy(struct kho_block_set *bs)
 /**
  * kho_block_set_clear - Clear all serialized data in a block set.
  * @bs: The block set to clear.
+ *
+ * Resets entry counts, unlinks blocks, and zeroes all entry payloads.
  */
 void kho_block_set_clear(struct kho_block_set *bs)
 {
 	struct kho_block *block;
 
 	list_for_each_entry(block, &bs->blocks, list) {
+		block->ser->next = 0;
 		block->ser->count = 0;
 		memset(block->ser + 1, 0, KHO_BLOCK_SIZE - sizeof(*block->ser));
 	}
@@ -340,14 +344,16 @@ void kho_block_set_it_init(struct kho_block_set_it *it, struct kho_block_set *bs
  * @it: The block iterator.
  *
  * Reserves a slot in the current block during state serialization to add a new
- * entry, advancing the internal index. If the current block is full, it
- * automatically moves to the next block in the set.
+ * entry, advancing the internal index. If the current block is full, it moves
+ * to the next preallocated block and links it onto the serialized chain via
+ * the previous block's header.
  *
  * Return: A pointer to the reserved entry slot, or NULL if the block set's
  * capacity is fully exhausted.
  */
 void *kho_block_set_it_reserve_entry(struct kho_block_set_it *it)
 {
+	struct kho_block *prev = NULL;
 	void *entry;
 
 	if (!it->block)
@@ -356,12 +362,16 @@ void *kho_block_set_it_reserve_entry(struct kho_block_set_it *it)
 	if (it->i == it->bs->count_per_block) {
 		if (list_is_last(&it->block->list, &it->bs->blocks))
 			return NULL;
+		prev = it->block;
 		it->block = list_next_entry(it->block, list);
 		it->i = 0;
 	}
 
 	entry = kho_block_entry(it, it->i++);
 	it->block->ser->count = it->i;
+	if (prev)
+		prev->ser->next = virt_to_phys(it->block->ser);
+
 	return entry;
 }
 
@@ -381,7 +391,9 @@ void *kho_block_set_it_read_entry(struct kho_block_set_it *it)
 		return NULL;
 
 	if (it->i == it->block->ser->count) {
-		if (list_is_last(&it->block->list, &it->bs->blocks))
+		if (!it->block->ser->next)
+			return NULL;
+		if (WARN_ON_ONCE(list_is_last(&it->block->list, &it->bs->blocks)))
 			return NULL;
 		it->block = list_next_entry(it->block, list);
 		it->i = 0;
-- 
2.56.1.708.g77570a6a1d-goog

