Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664723DB63D
	for <linux-api@vger.kernel.org>; Mon, 19 Oct 2026 04:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792383508; cv=none; b=eNDcjGQZ7MXmWzjsgtqQmfTMPuI8q3ddcmNsYAfLUqo6jX+rmka3TMYoEghSn/zv+YsIu5RFYUtMITDjN3Do9vPXoQJHpeOkQHlHlWVn5XeZt4e6o9vGyr1QVuzioDm56s7P0xcC1O0HsJFh/l6ec0eukLNjJS4Rmn49muF3AQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792383508; c=relaxed/simple;
	bh=YkErhc9zYWo/QJYm2jSa90NLvuFXKuNPFR6/ld86oQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PcveDHS+6AE8tpQqecCUBOkDQ7YZl6Uw1NHNtmLXplzZNOXkXxoj3zTYi0d5vfPQXqN+QDiAWx22xQUREepu/DngUGT/SwGsRLzRQoLxU9meCokgyYE1gd8S84tYTKBLmqteeVsYp8XoN5UjG1h50pJGLu4+Ieg3sl60ryhNmNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hackers.camp; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hackers.camp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a1e154e4c6so678225e9.3
        for <linux-api@vger.kernel.org>; Sun, 18 Oct 2026 21:18:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792383494; x=1792988294;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mta0KU8Ec2imZw6SS7yj1fVAdGUKp1H1Hm/Ej69dbT0=;
        b=vxsEcn9KwUAP9q3YOgDkmV6NfIBIbXS1s3Q8HQEFWZWAy+1D1c0wIIj6aocZW7X7Ji
         zpeUSHUY5ybL2lXvpgZl3eyi9PWJ/Z4SXZalj8PTL/wjOak5tIt/PIVG50vz7lyfYDsn
         9vCp8x4eHmZbbqQiNoZWfMJ7zUDiPXTTeigCWmK0PFlOlJOQDPAM7LPKjxOLuadUDoKb
         fckCwy//NNszwfwKxEhZAkQZsycNy3AdA7Uej9TZIBqLm/CFAHCRqn3aJ48c7ddeqbSJ
         zavPx6bFVxHS7DcYALOwAYxiW5pXneXjSawA85YNKRNCbvCaHjRmeSIFaX6qVnyY48h1
         uDfQ==
X-Forwarded-Encrypted: i=1; AKwUvBwQjW9bO/xN8y33Lf6oMQ20SJZhwxlKDMSvz1Vm2vwzx+zsSxg04O/A/eb2eWCPDgc3y3fvleaSmuY=@vger.kernel.org
X-Gm-Message-State: AFq9FYJ+qYqFmlXKqPxIjqiH3IhoolwkDIJrs9m3Ck2jmSb7/d8ObSQy
	oxX6NXclbZg4z3S6ra0XHl11Rty6pXxlLvOYbKy683hAec4KIhAvlKE/
X-Gm-Gg: AYBFou3nbLvJ/ztr8Hnt2b5CmMAyqToi7CRrm0hJbU29HzrCDTRvC2lKBzXH7pVVETs
	kTYuTdwlST2Kb6gMQKsjqNuqAkG8x3WZykG0aYtMko/iJl55mMHRpfkTAvSoNfHv5gj20p4dx8P
	6SOGeS4DrJVXcLSdqEjYF5UiH3zPaRP1Ub9jwwY/EjAxsdDLui4+DU4YwQeT/tdnH2RSFNXasNd
	lf8COQTL/zUwgegS/dARaOp1nnnl4+us1kdDNIe37izIKapFkX3GcvoTuhyXchFk8aeMyiC0ugO
	fEET7VdkZJnIrli76A34F5X1dQkxtFs+IwtyQmsRy5IGZ2wGZWJu186gQSW/h0741f48hfPrnrL
	nywrYs0ph7HXTSTyuFZRLw12SpDff56DTFfOkEhQawh9M9iqyak7kySM4uoqkNInMPlEgvBv5QF
	21TMkpI0HazNyRXh5i/mLAcbx2e1vbtHnpUZsW4P/NITN+wyRL0yAcoRsQ8u6qtTYmAqYfRBjwx
	fYAevduJ3iFD9JhjaVpltS2i+INtVFiEFDl5HWloonj+uo=
X-Received: by 2002:a05:600c:1c25:b0:4a1:e774:370d with SMTP id 5b1f17b1804b1-4a1e7743a15mr34813855e9.1.1792383491177;
        Sun, 18 Oct 2026 21:18:11 -0700 (PDT)
Received: from spartian.home ([2a01:cb1c:76:ed00:602f:c5f4:d108:b925])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd500e75sm20090449f8f.42.2026.10.18.21.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 21:18:10 -0700 (PDT)
From: Aurelien DESBRIERES <aurelien@hackers.camp>
To: Aurelien DESBRIERES <aurelien@hackers.camp>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	aurelien.desbrieres@gmail.com,
	linux-api@vger.kernel.org
Subject: [RFC PATCH 13/18] beamfs: inline data path 3/4, read side
Date: Mon, 19 Oct 2026 06:17:23 +0200
Message-ID: <20261019041728.327785-14-aurelien@hackers.camp>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261019041728.327785-1-aurelien@hackers.camp>
References: <20261019041728.327785-1-aurelien@hackers.camp>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

file_inline.c is the data path of the UNIVERSAL_INLINE protection
scheme (scheme 2), the one mkfs.beamfs formats. Each 4096-byte data
block holds sixteen RS(255,239) codewords, 3824 coded bytes and 256
bytes of parity, followed by a 16-byte tail; every read decodes the
block.

The file is 4875 lines, too large for one message to the list, so it
is split across four patches along function boundaries. It builds only
as a whole, once the Kconfig and Makefile patch is applied.

This part: the tail descriptor and its payload CRC, block decode,
symlink decode, ->iomap_begin and ->iomap_end, and the read side:
read_folio and the read of partial blocks before a write.

Assisted-by: LLM
Signed-off-by: Aurelien DESBRIERES <aurelien@hackers.camp>
---
 fs/beamfs/file_inline.c | 1316 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 1316 insertions(+)

diff --git a/fs/beamfs/file_inline.c b/fs/beamfs/file_inline.c
index dca00ae1f645..2ea7e7e10168 100644
--- a/fs/beamfs/file_inline.c
+++ b/fs/beamfs/file_inline.c
@@ -2398,3 +2398,1319 @@ static int beamfs_inline_lookup_or_alloc_phys_new(struct inode *inode,
 	return -EOPNOTSUPP;
 }
 
+/* ------------------------------------------------------------------------- */
+/*
+ * beamfs_inline_stamp_tail_pad -- write the DATA_CSUM descriptor and the
+ * DATA_SELFID digest into a data block. The 16-byte tail at
+ * BEAMFS_DATA_INLINE_TOTAL is always zeroed first; in the alternating
+ * layout that is where both go, and the zeroing covers the reserved
+ * bytes and the csum-disabled (NONE) case. When the volume has DATA_CSUM
+ * active, stamp csum_type = CRC32 and the beamfs_crc32 (crc32_le) of the
+ * payload, beamfs_block_payload() bytes of it. Where the descriptor and
+ * the digest live in each layout is below.
+ */
+/*
+ * Where the descriptor lives, and how much it covers.
+ *
+ * Alternating: at 4080, outside every codeword, over the 3824 bytes of
+ * payload. A flip there fails a read closed rather than accepting
+ * wrong data.
+ *
+ * Capsule: at 3808, inside the coded area, over the 3808 bytes of
+ * payload. The argument for staying outside was that a descriptor
+ * cannot be repaired -- interleaved it can, along with everything
+ * else, and nine bad bytes there stop condemning a block whose data is
+ * intact. The sixteen bytes it costs are already spent: the payload is
+ * 3808 and the encoder covers 3824, so 3808..3823 were protected and
+ * empty.
+ */
+static u32 beamfs_desc_off(struct super_block *sb)
+{
+	if (BEAMFS_SB(sb)->s_feat_incompat &
+	    BEAMFS_FEATURE_INCOMPAT_RS_INTERLEAVE)
+		return BEAMFS_CAPSULE_CSUM_OFF;
+
+	return BEAMFS_DATA_CSUM_TYPE_OFF;
+}
+
+static u32 beamfs_selfid_off(struct super_block *sb)
+{
+	if (BEAMFS_SB(sb)->s_feat_incompat &
+	    BEAMFS_FEATURE_INCOMPAT_RS_INTERLEAVE)
+		return BEAMFS_CAPSULE_SELFID_OFF;
+
+	return BEAMFS_DATA_SELFID_OFF;
+}
+
+static void beamfs_inline_stamp_tail_pad(struct beamfs_sb_info *sbi,
+					 u8 *block, const u8 *payload,
+					 u64 ino, u64 iblock)
+{
+	struct super_block *sb = sbi->s_sb;
+	u32 doff = beamfs_desc_off(sb);
+	u32 soff = beamfs_selfid_off(sb);
+	u32 covered = beamfs_block_payload(sb);
+
+	memset(block + BEAMFS_DATA_INLINE_TOTAL, 0, BEAMFS_DATA_INLINE_PAD);
+	/*
+	 * The descriptor whole, whatever is stamped in it below: in a
+	 * capsule it is coded data, and left as the page held it, it
+	 * carried sixteen bytes of kernel memory to the medium.
+	 */
+	memset(block + doff, 0,
+	       BEAMFS_DATA_CSUM_DESC_BYTES + BEAMFS_DATA_SELFID_BYTES);
+	if (sbi->s_data_csum) {
+		u32 crc = beamfs_crc32(payload, covered);
+
+		block[doff] = BEAMFS_CSUM_CRC32;
+		put_unaligned_le32(crc, block + doff + 4);
+	}
+	/*
+	 * DATA_SELFID: bind the block to the (inode, logical index) pair it
+	 * was written for, so a read reaching it through a corrupted pointer
+	 * fails closed instead of returning another file's intact data.
+	 */
+	if (sbi->s_data_selfid) {
+		u64 id = beamfs_data_selfid(ino, iblock);
+
+		put_unaligned_le64(id, block + soff);
+	}
+}
+
+/*
+ * Stamp a data block's descriptor, before its seal. Exposed for
+ * namei.c: the target of a long symlink is a data block written there.
+ */
+void beamfs_stamp_data_block(struct super_block *sb, u8 *block,
+			     const u8 *payload, u64 ino, u64 iblock)
+{
+	beamfs_inline_stamp_tail_pad(BEAMFS_SB(sb), block, payload, ino, iblock);
+}
+
+/*
+ * beamfs_inline_payload_crc -- recompute the DATA_CSUM over the decoded
+ * payload held in @codeword, in whichever layout it is written.
+ *
+ * A capsule holds the payload contiguously: one crc32_le over its 3808
+ * bytes. The alternating layout holds it in sixteen runs of 239 bytes,
+ * 255 apart: crc32_le is chained over the sixteen runs, which equals
+ * beamfs_crc32() over the contiguous 3824-byte payload, the value the
+ * write path stored. Walking one layout as the other hashes the parity
+ * along with the data and disagrees with what was stamped. No alloc.
+ */
+static u32 beamfs_inline_payload_crc(struct super_block *sb,
+				     const u8 *codeword)
+{
+	u32 c = 0xFFFFFFFF;
+	unsigned int i;
+
+	if (BEAMFS_SB(sb)->s_feat_incompat &
+	    BEAMFS_FEATURE_INCOMPAT_RS_INTERLEAVE)
+		return crc32_le(c, codeword + BEAMFS_CAPSULE_DATA_OFF,
+				BEAMFS_CAPSULE_DATA_BYTES) ^ 0xFFFFFFFF;
+
+	for (i = 0; i < BEAMFS_DATA_INLINE_SUBBLOCKS; i++)
+		c = crc32_le(c,
+			     codeword + (size_t)i * BEAMFS_SUBBLOCK_TOTAL,
+			     BEAMFS_SUBBLOCK_DATA);
+	return c ^ 0xFFFFFFFF;
+}
+
+/* beamfs_inline_decode_block_into_buf -- RS-decode a raw block image and    */
+/*                                        copy a user-byte slice into the    */
+/*                                        supplied buffer.                   */
+/*                                                                           */
+/* Called from read_folio_range, the partial-write fill                      */
+/* (write_read_folio_range), writeback's read of a partial block             */
+/* (beamfs_wb_read_old), zero_tail_block and the symlink reader.             */
+/*                                                                           */
+/* Inputs:                                                                   */
+/*   sb                       superblock (layout, journal)                   */
+/*   raw                      the block as read, BEAMFS_BLOCK_SIZE bytes;    */
+/*                            copied, never modified                         */
+/*   phys                     non-zero physical disk block number to decode  */
+/*   inode                    inode (its ino for DATA_SELFID and log lines)  */
+/*   iblock_logical_for_log   logical iblock, checked against DATA_SELFID    */
+/*                            and named in log lines                         */
+/*   dst_buf                  destination buffer; caller-allocated, must     */
+/*                            have at least slice_length bytes available     */
+/*   slice_offset             byte offset within the disk block user-area    */
+/*                            (0..BEAMFS_DATA_INLINE_BYTES-1)                */
+/*   slice_length             number of user bytes to copy into dst_buf      */
+/*                            (1..BEAMFS_DATA_INLINE_BYTES)                  */
+/*   rmw_path                 caller context flag: true when invoked from a  */
+/*                            read-modify-write transit (beamfs_wb_read_old  */
+/*                            or zero_tail_block), false otherwise.          */
+/*                            Propagated into the journal entry as           */
+/*                            BEAMFS_RS_EVENT_FLAG_RMW_NEUTRALISED so that   */
+/*                            silent neutralisation events become            */
+/*                            empirically distinguishable from user-visible  */
+/*                            corrections in post-run forensic analysis.     */
+/*                            Also discriminates the pr_warn / pr_err log    */
+/*                            line wording between "neutralised" and         */
+/*                            "corrected" / "uncorrectable".                 */
+/*                                                                           */
+/* Slice contract: slice_offset + slice_length <= BEAMFS_DATA_INLINE_BYTES   */
+/* (3824). HOLE (phys == 0) is NOT handled here -- caller must check.        */
+/*                                                                           */
+/* On any subblock corrected: the correction is journalled and the           */
+/* corrected bytes are copied out; the block on the medium is not            */
+/* rewritten here (see the end of the function).                             */
+/* On any subblock uncorrectable, or a DATA_CSUM or DATA_SELFID mismatch:    */
+/* journal entry with UNCORRECTABLE flag, then -EIO; no slice copy is        */
+/* performed.                                                                */
+/*                                                                           */
+/* This isolates the RS decode from folio lifecycle management. The folio    */
+/* lock and the end of the read are the caller's responsibility.             */
+/* ------------------------------------------------------------------------- */
+static int beamfs_inline_decode_block_into_buf(struct super_block *sb,
+					       const u8 *raw,
+					       u64 phys,
+					       struct inode *inode,
+					       u64 iblock_logical_for_log,
+					       u8 *dst_buf,
+					       u32 slice_offset,
+					       u32 slice_length,
+					       bool rmw_path)
+{
+	u8                 *tmp = NULL;
+	int                 rs_results[BEAMFS_DATA_INLINE_SUBBLOCKS];
+	u8                 rs_positions[BEAMFS_DATA_INLINE_SUBBLOCKS *
+				      (BEAMFS_RS_PARITY / 2)];
+	bool                corrected = false;
+	bool                uncorrectable = false;
+	unsigned int        i;
+	int                 ret = 0;
+	struct beamfs_sb_info *sbi = BEAMFS_SB(sb);
+
+	/* Defensive contract checks (cheap; helpful in audit and fuzzing). */
+	if (WARN_ON_ONCE(phys == 0))
+		return -EINVAL;
+	if (WARN_ON_ONCE(!dst_buf))
+		return -EINVAL;
+	if (WARN_ON_ONCE(slice_length == 0))
+		return -EINVAL;
+	if (WARN_ON_ONCE((u64)slice_offset + slice_length >
+			 BEAMFS_DATA_INLINE_BYTES))
+		return -EINVAL;
+
+	/*
+	 * @raw is only read: it is copied into a private scratch buffer
+	 * (tmp) and decoded there, never in place. decode_rs8 mutates both
+	 * data and parity bytes in its input, and @raw may be the b_data of
+	 * a buffer that other paths read. The decode_rs8 upstream race on
+	 * rs_control->buffers[] is resolved by the per-CPU rs_control
+	 * allocation in edac.c.
+	 */
+	tmp = beamfs_scratch_get(sb);
+	if (!tmp)
+		return -ENOMEM;
+	/*
+	 * No lock_buffer here, and the reason is in the callers.
+	 *
+	 * Those that pass a buffer's b_data -- write_read_folio_range,
+	 * zero_tail_block and the symlink reader -- already hold its lock,
+	 * so taking it again deadlocks on the first decode, which on this
+	 * filesystem means the rootfs mount. That was tried and the node
+	 * never reached a login prompt.
+	 *
+	 * The others -- read_folio_range and beamfs_wb_read_old -- pass a
+	 * copy taken under the buffer lock, or a block read straight from
+	 * the device into a scratch page.
+	 */
+	memcpy(tmp, raw, BEAMFS_BLOCK_SIZE);
+
+	/*
+	 * A capsule is gathered, not walked.
+	 *
+	 * Interleaved, symbol i of codeword j is at byte i*16 + j rather
+	 * than j*255 + i, and the header sits inside the coded area. The
+	 * two layouts share no arithmetic: reading one with the other's
+	 * gathers the wrong symbols and decodes to noise with every
+	 * check passing. The feature bit is what keeps them apart.
+	 */
+	if (BEAMFS_SB(sb)->s_feat_incompat &
+	    BEAMFS_FEATURE_INCOMPAT_RS_INTERLEAVE) {
+		beamfs_rs_decode_woven(tmp + BEAMFS_CAPSULE_DATA_OFF,
+				       tmp + BEAMFS_CAPSULE_PARITY_OFF,
+				       BEAMFS_RS_PARITY,
+				       BEAMFS_SUBBLOCK_DATA,
+				       BEAMFS_DATA_INLINE_SUBBLOCKS,
+				       rs_results, "file data");
+	} else {
+		beamfs_rs_decode_region(tmp, BEAMFS_SUBBLOCK_TOTAL,
+					tmp + BEAMFS_SUBBLOCK_DATA,
+					BEAMFS_SUBBLOCK_TOTAL,
+					BEAMFS_SUBBLOCK_DATA,
+					BEAMFS_DATA_INLINE_SUBBLOCKS,
+					rs_results, rs_positions,
+					BEAMFS_RS_PARITY / 2, "file data");
+	}
+
+	for (i = 0; i < BEAMFS_DATA_INLINE_SUBBLOCKS; i++) {
+		int rc = rs_results[i];
+
+		if (rc < 0) {
+			u32 xflags = rmw_path ?
+				BEAMFS_RS_EVENT_FLAG_RMW_NEUTRALISED : 0;
+
+			/*
+			 * Journal the uncorrectable event before raising the
+			 * error: forensic record takes priority over the alert.
+			 *
+			 * rmw_path=true here means the uncorrectable was
+			 * detected during a write transit. The caller fails the
+			 * read-modify-write on the -EIO below, so the damaged
+			 * block is not re-encoded over; the journal entry
+			 * preserves the forensic record of the event.
+			 */
+			beamfs_log_rs_event_flagged(sb, (u64)phys,
+						    NULL, 0,
+				BEAMFS_SUBBLOCK_DATA,
+				xflags | beamfs_rs_event_subblock_bits(i));
+			pr_err_ratelimited("beamfs/inline: ino=%llu iblock=%llu subblock=%u uncorrectable%s\n",
+					   (unsigned long long)inode->i_ino,
+					   (unsigned long long)iblock_logical_for_log,
+					   i,
+					   rmw_path ? " (rmw)" : "");
+			beamfs_alert_uncorrectable(sb, phys);
+			uncorrectable = true;
+		} else if (rc > 0) {
+			unsigned int np = (unsigned int)rc;
+			u8 *pos = rs_positions +
+				   (size_t)i * (BEAMFS_RS_PARITY / 2);
+			u32 xflags = rmw_path ?
+				BEAMFS_RS_EVENT_FLAG_RMW_NEUTRALISED : 0;
+
+			if (np > BEAMFS_RS_PARITY / 2)
+				np = BEAMFS_RS_PARITY / 2;
+			pr_warn_ratelimited("beamfs/inline: ino=%llu iblock=%llu subblock=%u: %d symbol(s) %s\n",
+					    (unsigned long long)inode->i_ino,
+					    (unsigned long long)iblock_logical_for_log,
+					    i, rc,
+					    rmw_path ? "neutralised" : "corrected");
+			beamfs_log_rs_event_flagged(sb, (u64)phys,
+						    pos, np,
+				BEAMFS_SUBBLOCK_DATA,
+				xflags | beamfs_rs_event_subblock_bits(i));
+			/*
+			 * The journal says this happened; the budget says
+			 * how close the block now is to having nothing left.
+			 * A high-water mark, so the byte reports the worst
+			 * any subblock of this block has been rather than
+			 * the most recent, since the worst is what will
+			 * saturate first.
+			 */
+			beamfs_budget_record(sb, phys, np);
+			corrected = true;
+		}
+	}
+
+	if (uncorrectable) {
+		ret = -EIO;
+		goto out_brelse;
+	}
+
+	/*
+	 * DATA_CSUM verification. decode_rs8 can return success while having
+	 * converged to a wrong valid codeword (silent miscorrection).
+	 * Recompute the payload checksum and reject on mismatch. The
+	 * descriptor is read from tmp: in a capsule it sits inside the coded
+	 * area and has just been decoded with the rest; in the alternating
+	 * layout it sits in the tail pad, which decode does not touch. Any
+	 * type other than CRC32 fails closed (see below). On mismatch,
+	 * journal an UNCORRECTABLE event and fail closed before any slice
+	 * copy, as the per-subblock uncorrectable path does.
+	 */
+	if (sbi->s_data_csum) {
+		u32 doff  = beamfs_desc_off(sb);
+		u8  ctype = tmp[doff];
+		u32 want  = get_unaligned_le32(tmp + doff + 4);
+		u32 got   = beamfs_inline_payload_crc(sb, tmp);
+
+		/*
+		 * csum_type gates the whole check. In the alternating layout
+		 * the descriptor is outside every RS codeword, so it is
+		 * neither corrected nor detected by the code. Accepting any
+		 * type other than CRC32 as "no checksum present" therefore let
+		 * a single flip on offset 4080 disable verification for that
+		 * block, silently. Measured 2026-08-17 at 128 flips on a
+		 * 64-block file: 20 RS symbols corrected, no uncorrectable, no
+		 * csum mismatch logged, and 15296 wrong bits returned to
+		 * userspace across two blocks -- the silent accept a descriptor
+		 * outside the codewords was meant to rule out. That holds for
+		 * the csum value (a corrupted CRC can only over-reject) but not
+		 * for the type byte.
+		 *
+		 * On a DATA_CSUM volume every data block is stamped at write
+		 * time, so any other type is a corrupted descriptor, not an
+		 * unstamped block: fail closed instead of waving it through.
+		 */
+		if (ctype != BEAMFS_CSUM_CRC32) {
+			/*
+			 * UNCORRECTABLE is reserved:
+			 * beamfs_log_rs_event_flagged sets it itself for
+			 * the positions == NULL, n_positions == 0 call shape
+			 * used here. Passing it in extra_flags trips the
+			 * WARN_ON_ONCE reserved-mask guard there; that
+			 * mistake is what made the master node report
+			 * RS_FAILED on 2026-08-24.
+			 */
+			u32 xflags = 0;
+
+			if (rmw_path)
+				xflags |= BEAMFS_RS_EVENT_FLAG_RMW_NEUTRALISED;
+
+			beamfs_log_rs_event_flagged(sb,
+						    (u64)phys * BEAMFS_DATA_INLINE_SUBBLOCKS,
+						    NULL, 0,
+						    BEAMFS_SUBBLOCK_DATA,
+						    xflags);
+			pr_err_ratelimited("beamfs/inline: ino=%llu iblock=%llu data_csum bad descriptor type=0x%02x (expected 0x%02x)%s\n",
+					   (unsigned long long)inode->i_ino,
+					   (unsigned long long)iblock_logical_for_log,
+					   ctype, BEAMFS_CSUM_CRC32,
+					   rmw_path ? " (rmw)" : "");
+			ret = -EIO;
+			goto out_brelse;
+		}
+
+		if (want != got) {
+			beamfs_log_rs_event_flagged(sb,
+						    (u64)phys * BEAMFS_DATA_INLINE_SUBBLOCKS,
+				NULL, 0,
+				BEAMFS_SUBBLOCK_DATA,
+				rmw_path ? BEAMFS_RS_EVENT_FLAG_RMW_NEUTRALISED : 0);
+			pr_err_ratelimited("beamfs/inline: ino=%llu iblock=%llu data_csum mismatch want=0x%08x got=0x%08x%s\n",
+					   (unsigned long long)inode->i_ino,
+					   (unsigned long long)iblock_logical_for_log,
+					   want, got,
+					   rmw_path ? " (rmw)" : "");
+			ret = -EIO;
+			goto out_brelse;
+		}
+	}
+
+	/*
+	 * DATA_SELFID verification. DATA_CSUM proves the block is intact; it
+	 * cannot prove it is the block that was asked for. A corrupted
+	 * pointer landing inside the data area reaches a different but valid
+	 * block whose own descriptor verifies, so every check above passes on
+	 * the wrong data. Measured 2026-08-19: a direct pointer moved from
+	 * physical 471 to 503 and the read returned that block's contents,
+	 * 15245 wrong bits, with no kernel signal. Comparing the stored
+	 * identity digest against the (inode, iblock) actually being read
+	 * closes that path.
+	 */
+	if (sbi->s_data_selfid) {
+		u64 want_id = beamfs_data_selfid(inode->i_ino,
+						 iblock_logical_for_log);
+		u64 got_id  = get_unaligned_le64(tmp +
+						 beamfs_selfid_off(sb));
+
+		if (want_id != got_id) {
+			/*
+			 * UNCORRECTABLE is reserved:
+			 * beamfs_log_rs_event_flagged sets it itself for
+			 * the positions == NULL, n_positions == 0 call shape
+			 * used here. Passing it in extra_flags trips the
+			 * WARN_ON_ONCE reserved-mask guard there; that
+			 * mistake is what made the master node report
+			 * RS_FAILED on 2026-08-24.
+			 */
+			u32 xflags = 0;
+
+			if (rmw_path)
+				xflags |= BEAMFS_RS_EVENT_FLAG_RMW_NEUTRALISED;
+
+			beamfs_log_rs_event_flagged(sb,
+						    (u64)phys * BEAMFS_DATA_INLINE_SUBBLOCKS,
+						    NULL, 0,
+						    BEAMFS_SUBBLOCK_DATA,
+						    xflags);
+			pr_err_ratelimited("beamfs/inline: ino=%llu iblock=%llu data_selfid mismatch want=0x%016llx got=0x%016llx%s\n",
+					   (unsigned long long)inode->i_ino,
+					   (unsigned long long)iblock_logical_for_log,
+					   want_id, got_id,
+					   rmw_path ? " (rmw)" : "");
+			ret = -EIO;
+			goto out_brelse;
+		}
+	}
+
+	/*
+	 * Slice gather: copy [slice_offset, slice_offset + slice_length)
+	 * of the payload into dst_buf. The alternating layout holds it as
+	 * 16 segments of 239 bytes with the parity between them: walk the
+	 * relevant subblocks and copy the intersecting portion of each.
+	 */
+	{
+		u32 slice_end = slice_offset + slice_length;
+		u32 sb_first  = slice_offset / BEAMFS_SUBBLOCK_DATA;
+		u32 sb_last   = (slice_end - 1) / BEAMFS_SUBBLOCK_DATA;
+		u32 dst_off   = 0;
+		u32 sb_idx;
+
+		if (BEAMFS_SB(sb)->s_feat_incompat &
+		    BEAMFS_FEATURE_INCOMPAT_RS_INTERLEAVE) {
+			/*
+			 * A capsule holds its payload contiguously, so
+			 * the slice is one copy. Walking it in sixteen
+			 * runs 255 apart reads each one 16 bytes further
+			 * along than it lies.
+			 */
+			memcpy(dst_buf + dst_off,
+			       tmp + BEAMFS_CAPSULE_DATA_OFF + slice_offset,
+			       slice_length);
+			dst_off += slice_length;
+		} else {
+			for (sb_idx = sb_first; sb_idx <= sb_last; sb_idx++) {
+				u32 sb_user_start = sb_idx * BEAMFS_SUBBLOCK_DATA;
+				u32 sb_user_end   = sb_user_start +
+						    BEAMFS_SUBBLOCK_DATA;
+				u32 from_in_sb    = (slice_offset > sb_user_start)
+					? (slice_offset - sb_user_start) : 0;
+				u32 to_in_sb      = (slice_end < sb_user_end)
+					? (slice_end - sb_user_start)
+					: BEAMFS_SUBBLOCK_DATA;
+				u32 copy_len      = to_in_sb - from_in_sb;
+
+				memcpy(dst_buf + dst_off,
+				       tmp
+					+ (size_t)sb_idx * BEAMFS_SUBBLOCK_TOTAL
+					+ from_in_sb,
+				       copy_len);
+				dst_off += copy_len;
+			}
+		}
+	}
+
+	/*
+	 * No write-back of the correction from here.
+	 *
+	 * The corrected bytes are in tmp; @raw, and the medium, still hold
+	 * what was read. Writing the block back from this path would need
+	 * either:
+	 *  (a) an exclusive lock on phys around the read-modify-write
+	 *      window, OR
+	 *  (b) a CoW write path that allocates a fresh phys and
+	 *      updates the indirect pointer.
+	 * The correction is journalled above. The background scrubber
+	 * writes corrected blocks back (beamfs_scrub_check_block), and a
+	 * later write to the block re-encodes it whole.
+	 */
+	(void)corrected;
+
+	beamfs_scratch_put(sb, tmp);
+	return 0;
+
+out_brelse:
+	beamfs_scratch_put(sb, tmp);
+	return ret;
+}
+
+/*
+ * beamfs_inline_decode_symlink -- RS-decode a block holding a link target.
+ *
+ * The same decode as file data, exposed for namei.c because a long
+ * symlink is a data block in every respect but the path that reaches it.
+ * Separate entry point rather than a wider signature on the file path:
+ * this one takes no folio, no iomap iterator and no RMW flag, and
+ * threading three unused arguments through the reader to avoid twelve
+ * lines here would be the worse trade.
+ */
+int beamfs_inline_decode_symlink(struct super_block *sb,
+				 struct buffer_head *bh, u64 phys,
+				 struct inode *inode, u8 *dst, u32 len)
+{
+	if (len > beamfs_block_payload(sb))
+		return -EUCLEAN;
+
+	return beamfs_inline_decode_block_into_buf(sb, bh->b_data, phys, inode, 0,
+						   dst, 0, len, false);
+}
+
+/* ------------------------------------------------------------------------- */
+/* iomap read path                                                           */
+/*                                                                           */
+/* Every 4096-byte block carries its RS parity alongside its payload: 3808   */
+/* bytes of file data in a capsule, 3824 in the alternating layout. File     */
+/* offset is therefore not disk offset plus a constant -- which is what      */
+/* iomap_sector() assumes.                                                   */
+/*                                                                           */
+/* Two consequences shape this code. iomap_begin bounds a write or fiemap    */
+/* mapping by the block that backs pos, and iomap calls back for the rest;   */
+/* a read mapping keeps the full requested length (see iomap_begin). And     */
+/* the read is done by beamfs_inline_read_folio_range() rather than by       */
+/* iomap_bio_read_ops, because the bytes that reach the page cache are not   */
+/* the bytes on disk: they are what RS decoding produces from them.          */
+/* ------------------------------------------------------------------------- */
+
+/*
+ * A mapping iomap_begin allocated, for iomap_end to give back if the
+ * write stops short of it.
+ *
+ * Not IOMAP_F_NEW. To iomap that flag means the folio range is new:
+ * __iomap_write_begin zeroes it outside the bytes written instead of
+ * reading it (iomap_block_needs_zeroing). A folio here holds the end
+ * of one block and the start of the next, so a write starting a fresh
+ * block zeroed the data of the block before it in the same folio.
+ * Without the flag iomap reads the folio through
+ * beamfs_inline_write_read_folio_range, which finds the fresh block
+ * zeroed in the buffer cache.
+ */
+#define BEAMFS_IOMAP_F_FRESH	IOMAP_F_PRIVATE
+
+static int beamfs_inline_iomap_begin(struct inode *inode, loff_t pos,
+				     loff_t length, unsigned int flags,
+				     struct iomap *iomap,
+				     struct iomap *srcmap)
+{
+	loff_t i_size = i_size_read(inode);
+	u32 payload = beamfs_block_payload(inode->i_sb);
+	u64 b = div_u64((u64)pos, payload);
+	u64 phys = 0;
+	int ret;
+
+	iomap->flags = 0;
+	iomap->bdev = inode->i_sb->s_bdev;
+	iomap->addr = IOMAP_NULL_ADDR;
+
+	/*
+	 * Start the mapping at the position the caller asked for, not at
+	 * the start of the INLINE block that backs it. iomap tracks its
+	 * position within the folio against the mapping it was given, and
+	 * readahead ends a folio when offset_in_folio(folio, pos) reaches
+	 * zero; handing back a range that starts before the requested
+	 * position leaves that comparison never matching, and the iterator
+	 * walks off a folio it has already released.
+	 */
+	iomap->offset = pos;
+
+	/*
+	 * Past EOF the whole remaining range is a hole, in one mapping:
+	 * iomap zero-fills it without calling back. Splitting it into
+	 * INLINE-sized pieces would leave iomap iterating after
+	 * iomap_read_folio_iter() has released the folio, which
+	 * dereferences NULL on the next round.
+	 */
+	/*
+	 * Past EOF is a hole to a reader and nothing of the sort to a
+	 * writer.
+	 *
+	 * A write at pos == i_size is the ordinary case of extending a
+	 * file, and the block holding that position usually exists
+	 * already: at 3808 or 3824 usable bytes per block, appending to a
+	 * 32-byte file writes into block 0, which has data in it.
+	 *
+	 * Reporting IOMAP_HOLE there made iomap_block_needs_zeroing true
+	 * on the first term, so __iomap_write_begin took the zeroing
+	 * branch and called folio_zero_segments over the whole folio
+	 * outside the written range -- erasing bytes 0..31, which were on
+	 * disk and below i_size. generic/639 writes 32 bytes, cycles the
+	 * mount, writes 32 more, and reads back thirty-two zeros followed
+	 * by the second write. Silent loss of data the caller never
+	 * touched.
+	 *
+	 * iomap works in i_blocksize units, 4096, while a block carries
+	 * 3808 or 3824 bytes of payload, so its block boundaries are not ours
+	 * and a range it considers past EOF can hold live bytes. Answering
+	 * the question it actually asked -- what is mapped here -- rather
+	 * than a shortcut about EOF keeps the two views consistent.
+	 */
+	if (!(flags & IOMAP_WRITE) && pos >= i_size) {
+		iomap->length = length;
+		iomap->type = IOMAP_HOLE;
+		return 0;
+	}
+
+	/*
+	 * One mapping covers the whole requested range, even where that
+	 * spans two or three INLINE blocks.
+	 *
+	 * iomap_read_folio_iter() releases the folio as soon as a call
+	 * returns with no iomap_folio_state attached -- which is always
+	 * the case here, folio size and block size both being 4096, so
+	 * ifs_alloc() has nothing to track. A mapping shorter than the
+	 * folio therefore leaves iomap iterating over a folio it has
+	 * already given up, and the next round dereferences NULL at
+	 * folio_size(). Verified by disassembly: iomap_read_folio_iter+0x7c
+	 * is mov (%r12),%rax with r12 = ctx->cur_folio.
+	 *
+	 * Spanning blocks is fine because read_folio_range does its own
+	 * reading: it walks the blocks the range covers and decodes each.
+	 * iomap->addr is reported to fiemap and tracing but nothing
+	 * derives an I/O sector from it.
+	 */
+	/*
+	 * Report asks about one block; read asks about the whole range.
+	 *
+	 * IOMAP_REPORT is fiemap, and it wants the truth: this mapping
+	 * describes the block pos falls in and nothing beyond it.
+	 * Claiming the requested length told fiemap that the answer for
+	 * the first block held for the entire file, so a leading hole
+	 * was reported as spanning 1 MiB, iomap stepped past EOF, and a
+	 * file with 512 KiB of data came back with no extents at all.
+	 *
+	 * Everything else keeps the full length, and must. A mapping
+	 * shorter than the folio makes iomap_read_folio_iter release the
+	 * folio -- nothing attached an iomap_folio_state, folio and
+	 * block size both being 4096 -- and then dereference it on the
+	 * next round at folio_size(). That is the NULL documented above,
+	 * confirmed by disassembly, and a 3824-byte mapping is always
+	 * shorter than a 4096-byte folio.
+	 */
+	/*
+	 * A write is bounded by the block it allocated; a read is not.
+	 *
+	 * The write leg allocates exactly one block -- b = pos / payload
+	 * -- and then declared a mapping covering the whole requested
+	 * length. iomap believes it: iomap_write_iter copies the entire
+	 * range into the page cache without asking again, so a 1 MiB
+	 * write allocated one block of 3808 bytes and accepted 275 more
+	 * on the strength of it.
+	 *
+	 * Measured on 2026-09-19: 1.25 GiB written in fourteen seconds
+	 * onto a 256 MiB volume, df moving by 11 MiB, dd returning
+	 * success throughout. The file reached 1.41 GiB before the dirty
+	 * page limit stopped it, and the allocation it needs happens at
+	 * writeback, where ENOSPC has nobody to report to. That is the
+	 * EFBIG generic/015 ends on, and the silent acceptance the whole
+	 * filesystem exists to prevent.
+	 *
+	 * iomap handles a short mapping by calling back for the rest;
+	 * every filesystem in the tree relies on that. The read leg is
+	 * the one that cannot take it -- iomap_read_folio_iter releases
+	 * a folio no iomap_folio_state is attached to and dereferences
+	 * it on the next round, which is what the comment above records
+	 * and disassembly confirmed -- so it keeps the full length.
+	 */
+	if (flags & (IOMAP_REPORT | IOMAP_WRITE)) {
+		u64 in_block = (u64)pos - b * payload;
+
+		/*
+		 * payload, not BEAMFS_DATA_INLINE_BYTES.
+		 *
+		 * The remainder above is taken modulo payload and the
+		 * bound was taken on the constant. On a capsule volume
+		 * those are 3808 and 3824, so every extent fiemap
+		 * reported ran up to sixteen bytes past the block that
+		 * backs it, and the next one started inside it.
+		 *
+		 * beamfs_block_payload says what this costs in as many
+		 * words: writing the constant instead "reads a file back
+		 * shifted by sixteen bytes on a capsule volume,
+		 * silently". generic/473 is where it shows: the test
+		 * expects [128..255] and gets [128..254].
+		 */
+		iomap->length = min_t(u64, (u64)length,
+				      (u64)payload - in_block);
+	} else {
+		iomap->length = length;
+	}
+
+	/*
+	 * A write allocates here, not at writeback.
+	 *
+	 * Only lookup_phys was called, for every caller, so a write to an
+	 * unallocated block was told IOMAP_HOLE and accepted into the page
+	 * cache; the allocation happened later in the flusher, where an
+	 * ENOSPC has nobody left to report to. A volume at 100% took a
+	 * 10 MiB write at 5.5 GB/s -- nothing reached the disk, and the
+	 * application was told it had.
+	 *
+	 * That is silent data loss, on a filesystem whose whole purpose is
+	 * that data survives.
+	 *
+	 * It also explains the EFBIG that ended generic/015 and
+	 * generic/269: dd kept writing past the end of a full 1 GiB volume
+	 * until the file hit the 134480396-block ceiling of the
+	 * indirection tree -- 479 GiB of file on a gigabyte of disk --
+	 * because no write ever failed.
+	 *
+	 * ext2 draws the same line: create = flags & IOMAP_WRITE.
+	 */
+	if (flags & IOMAP_WRITE) {
+		struct beamfs_inode_info *fi = BEAMFS_I(inode);
+
+		/*
+		 * Allocation is serialised by i_alloc_mutex, and this is
+		 * an allocation site.
+		 *
+		 * The two other callers take it; this one did not, so two
+		 * threads writing the same logical block each allocated a
+		 * physical one and the second overwrote the first's
+		 * pointer. The overwritten block stayed marked used with
+		 * nothing referencing it -- 36 leaked out of 317559
+		 * allocations under generic/344, which runs holetest with
+		 * 256 threads on one sparse file. A narrow window, hit
+		 * often enough by 256 threads.
+		 */
+		bool fresh = false;
+
+		/*
+		 * Not on a failed volume.
+		 *
+		 * beamfs_fail says "refusing further writes" and nothing in
+		 * this file asked: a write into a block the file already had
+		 * was accepted, and one that needed a block was told ENOSPC by
+		 * the allocator, which answers 0 for a failed volume as for a
+		 * full one. generic/361 on aarch64, 2026-10-01: "pwrite: No
+		 * space left on device" on a 1 GiB volume holding 520 MiB.
+		 */
+		if (beamfs_failed(inode->i_sb))
+			return -EIO;
+
+		mutex_lock(&fi->i_alloc_mutex);
+		ret = beamfs_inline_lookup_or_alloc_phys_new(inode, b, &phys,
+							     &fresh);
+		mutex_unlock(&fi->i_alloc_mutex);
+
+		/*
+		 * BEAMFS_IOMAP_F_FRESH: this mapping did not exist before the call.
+		 *
+		 * iomap_end may only give back what this call created. A
+		 * block the file already owned belongs to it whether or
+		 * not the write that asked for the mapping reached it, and
+		 * freeing that would lose data nobody asked to lose.
+		 */
+		if (ret == 0 && fresh)
+			iomap->flags |= BEAMFS_IOMAP_F_FRESH;
+	} else {
+		ret = beamfs_inline_lookup_phys(inode, b, &phys);
+	}
+	/*
+	 * The last place a wrong address can still be stopped.
+	 *
+	 * What goes into the iomap below becomes a bio, and a bio does
+	 * not ask where it is going: an address under s_data_start lands
+	 * on the inode table. generic/075 put fsx's fill bytes in blocks
+	 * 7 and 246 that way and left no trace in any buffer head,
+	 * because iomap does not use them.
+	 *
+	 * Checked here rather than at each place the two lookups return a
+	 * block: one gate the address must pass, and one place to read when
+	 * it does not.
+	 */
+	if (ret == 0 &&
+	    !beamfs_phys_is_sane(inode->i_sb, inode, phys, "iomap_begin"))
+		ret = -EUCLEAN;
+
+	if (ret < 0)
+		return ret;
+
+	if (phys == 0) {
+		iomap->type = IOMAP_HOLE;
+		return 0;
+	}
+
+	iomap->type = IOMAP_MAPPED;
+	/*
+	 * Physical block start. Nothing derives a sector from it for I/O --
+	 * read_folio_range reads the block itself -- but fiemap and the
+	 * tracepoints report it, so it has to be the real address.
+	 */
+	iomap->addr = (u64)phys * BEAMFS_BLOCK_SIZE;
+
+	(void)srcmap;
+	return 0;
+}
+
+/*
+ * Give back what a short write allocated and did not use.
+ *
+ * iomap_begin allocates a block per call as it walks the mapping, and
+ * a write that stops short -- ENOSPC, a signal, an error partway --
+ * leaves the rest of them allocated and named by nothing. generic/013
+ * ends with ten such blocks in two runs, the longer of nine: one
+ * write's worth.
+ *
+ * Only what this mapping created, which BEAMFS_IOMAP_F_FRESH says. A
+ * block the file already owned belongs to it whether or not this write
+ * reached it, and freeing that loses data nobody asked to lose.
+ *
+ * Rounded up to the next block: a partially written block is kept
+ * whole, because the bytes before the stopping point are the user's.
+ */
+static int beamfs_inline_iomap_end(struct inode *inode, loff_t pos,
+				   loff_t length, ssize_t written,
+				   unsigned int flags, struct iomap *iomap)
+{
+	u32 payload = beamfs_block_payload(inode->i_sb);
+	u64 first_unused;
+	loff_t reached;
+
+	if (!(flags & IOMAP_WRITE) || !(iomap->flags & BEAMFS_IOMAP_F_FRESH))
+		return 0;
+	if (written < 0 || written >= length)
+		return 0;
+
+	/*
+	 * The first block entirely past what the write reached. Anything
+	 * from here to the end of the mapping was allocated by it and
+	 * never filled.
+	 */
+	reached = pos + written;
+	first_unused = DIV_ROUND_UP_ULL((u64)reached, payload);
+
+	if ((loff_t)(first_unused * payload) >= pos + length)
+		return 0;
+
+	/*
+	 * Only past the end of the file.
+	 *
+	 * free_blocks_from frees everything from a block onwards, which
+	 * is what a truncate wants and not what this does. A write that
+	 * fails at offset zero on a file that already holds data would
+	 * take all of it: the mapping is new, the blocks past it are
+	 * not.
+	 *
+	 * i_size is what iomap has already set from what was written, so
+	 * anything beyond it is out of the file by definition.
+	 */
+	{
+		loff_t size = i_size_read(inode);
+		u64 first_past_eof = DIV_ROUND_UP_ULL((u64)size, payload);
+
+		if (first_unused < first_past_eof)
+			return 0;
+	}
+
+	mutex_lock(&BEAMFS_I(inode)->i_alloc_mutex);
+	beamfs_inline_free_blocks_from(inode, first_unused);
+	mutex_unlock(&BEAMFS_I(inode)->i_alloc_mutex);
+
+	return 0;
+}
+
+static const struct iomap_ops beamfs_inline_iomap_ops = {
+	.iomap_begin = beamfs_inline_iomap_begin,
+	.iomap_end   = beamfs_inline_iomap_end,
+};
+
+/*
+ * Read one mapped range into the folio, decoding it on the way.
+ *
+ * iomap has already resolved which INLINE block backs this file range;
+ * what is left is to fetch the physical block, run the 16 RS codewords
+ * through the decoder, and copy out the slice the folio asked for. The
+ * read is synchronous, as iomap_bio_read_folio_range_sync() shows is
+ * expected, so iomap_finish_folio_read() is called before returning.
+ */
+static int beamfs_inline_read_folio_range(const struct iomap_iter *iter,
+					  struct iomap_read_folio_ctx *ctx,
+					  size_t len)
+{
+	struct inode       *inode = iter->inode;
+	struct super_block *sb    = inode->i_sb;
+	struct folio       *folio = ctx->cur_folio;
+	loff_t              i_size = i_size_read(inode);
+	u64                 pos   = (u64)iter->pos;
+	u64                 end   = pos + len;
+	size_t              done  = 0;
+	int                 ret   = 0;
+
+	/*
+	 * The range can straddle INLINE blocks, so walk them: for each,
+	 * read the physical block, run its 16 RS codewords through the
+	 * decoder, and copy out the slice this folio wants.
+	 */
+	/*
+	 * Past EOF within this range: zero it here rather than returning a
+	 * second HOLE mapping. iomap releases the folio as soon as a call
+	 * returns without an iomap_folio_state attached -- always the case
+	 * at 4096-byte folios and blocks -- so a folio must be covered by
+	 * exactly one mapping. Traced on 2026-08-29: a 1000-byte file
+	 * produced MAPPED [0, 0x3e8) then HOLE [0x3e8, 0x1000), and the
+	 * second iteration dereferenced the released folio.
+	 */
+	if (end > (u64)i_size) {
+		u64 eof = max_t(u64, pos, (u64)i_size);
+
+		folio_zero_range(folio, offset_in_folio(folio, eof),
+				 (size_t)(end - eof));
+		end = eof;
+	}
+
+	while (pos < end) {
+		u32    payload      = beamfs_block_payload(inode->i_sb);
+		u64    b            = div_u64(pos, payload);
+		u32    slice_offset = (u32)(pos - b * payload);
+		u32    slice_length = (u32)min_t(u64, end - pos,
+						 payload - slice_offset);
+		size_t folio_off    = offset_in_folio(folio, pos);
+		u64    phys = 0;
+		u8    *dst;
+
+		/*
+		 * The tree read under the allocator's mutex.
+		 *
+		 * lookup_phys walks i_direct and the indirect blocks while
+		 * writeback, truncate and eviction are free to rewrite them.
+		 * Reading a pointer mid-update returns a block number that
+		 * belongs to no one, or to another file once it has been
+		 * reallocated. ext2 holds truncate_mutex across the same walk.
+		 *
+		 * Held for the lookup only, released before the read that
+		 * follows: the block I/O may sleep and has no business
+		 * holding up the allocator.
+		 */
+		mutex_lock(&BEAMFS_I(inode)->i_alloc_mutex);
+		ret = beamfs_inline_lookup_phys(inode, b, &phys);
+		mutex_unlock(&BEAMFS_I(inode)->i_alloc_mutex);
+		if (ret < 0)
+			break;
+
+		if (phys == 0) {
+			folio_zero_range(folio, folio_off, slice_length);
+			pos  += slice_length;
+			done += slice_length;
+			continue;
+		}
+
+		/*
+		 * Not sb_bread, and that is the whole point.
+		 *
+		 * __bread_gfp adds __GFP_NOFAIL whatever mask it is given,
+		 * so this read could not fail -- it looped in the
+		 * allocator instead. On a machine whose page cache is full
+		 * of this filesystem's own blocks, that is a machine that
+		 * stops: captured 2026-09-18 with the node at 270% CPU,
+		 * kswapd running, eight tasks on this exact line and
+		 * nothing advancing, with generic/083 under -I crc.
+		 *
+		 * The cache is consulted first and never created. A block
+		 * with a dirty buffer still holds the newest bytes -- the
+		 * medium has the previous ones until writeback lands -- so
+		 * reading past it would hand back stale data. When there
+		 * is no buffer, the block is read straight into a scratch
+		 * page: one bounded allocation that can fail cleanly,
+		 * instead of an unbounded one that cannot fail at all.
+		 *
+		 * A capsule is exactly BEAMFS_BLOCK_SIZE and the scratch
+		 * pool hands out exactly that, so the block lands in one
+		 * piece with no bounce.
+		 */
+		{
+			struct buffer_head *cached = sb_find_get_block(sb, phys);
+			u8 *raw;
+
+			if (cached) {
+				raw = beamfs_scratch_get(sb);
+				if (!raw) {
+					brelse(cached);
+					ret = -ENOMEM;
+					break;
+				}
+				lock_buffer(cached);
+				memcpy(raw, cached->b_data, BEAMFS_BLOCK_SIZE);
+				unlock_buffer(cached);
+				brelse(cached);
+			} else {
+				raw = beamfs_scratch_get(sb);
+				if (!raw) {
+					ret = -ENOMEM;
+					break;
+				}
+				ret = bdev_rw_virt(sb->s_bdev,
+						   (sector_t)phys *
+						   (BEAMFS_BLOCK_SIZE >> SECTOR_SHIFT),
+						   raw, BEAMFS_BLOCK_SIZE,
+						   REQ_OP_READ);
+				if (ret) {
+					pr_err_ratelimited("beamfs/inline: read_folio_range: read of phys=%llu failed: %d\n",
+							   (unsigned long long)phys,
+							   ret);
+					beamfs_scratch_put(sb, raw);
+					ret = -EIO;
+					break;
+				}
+			}
+
+			dst = kmap_local_folio(folio, folio_off);
+			ret = beamfs_inline_decode_block_into_buf(sb, raw, phys,
+								  inode, b, dst,
+								  slice_offset,
+								  slice_length,
+								  false);
+			kunmap_local(dst);
+			beamfs_scratch_put(sb, raw);
+			if (ret < 0)
+				break;
+		}
+
+		pos  += slice_length;
+		done += slice_length;
+	}
+
+	/*
+	 * On failure, return without finishing the folio.
+	 * iomap_read_folio_iter() propagates a non-zero return before
+	 * counting the range as submitted, and iomap_read_folio() then
+	 * ends the folio itself through iomap_read_end(). Calling
+	 * iomap_finish_folio_read() here as well runs folio_end_read()
+	 * on a folio iomap still owns -- with no iomap_folio_state
+	 * attached, which is always the case at 4096-byte folios and
+	 * blocks, that call is unconditional -- and the second end
+	 * leaves any waiter parked in folio_wait_bit_common() forever.
+	 *
+	 * Observed on 2026-08-30 by the saturation protocol: a block with
+	 * nine symbol errors in one subblock was correctly detected and
+	 * journalled, but the read never returned EIO -- cat sat in
+	 * uninterruptible sleep instead. The fail-closed half of the
+	 * saturation contract was the casualty, not the detection half.
+	 *
+	 * iomap_bio_read_folio_range_sync() has the same shape: it
+	 * returns the error and finishes nothing.
+	 */
+	if (ret < 0)
+		return ret;
+
+	iomap_finish_folio_read(folio, offset_in_folio(folio, iter->pos),
+				len, 0);
+	(void)done;
+	return 0;
+}
+
+static const struct iomap_read_ops beamfs_inline_read_ops = {
+	.read_folio_range = beamfs_inline_read_folio_range,
+};
+
+/*
+ * No .readahead. iomap_readahead_iter() moves to the next folio only when
+ * offset_in_folio(cur_folio, iter->pos) reaches zero, so it assumes
+ * mappings line up with folio boundaries. INLINE mappings end on block
+ * payload boundaries, 3808 or 3824 bytes apart, and folios are 4096
+ * bytes, so that comparison never matches at the right moment:
+ * iomap_read_folio_iter() clears cur_folio once the folio is full, the
+ * transition to the next folio does not fire, and the following
+ * iteration dereferences NULL. Confirmed twice on kernel 7.1.3.
+ *
+ * readahead is optional in address_space_operations. Aligning the format
+ * to folios would mean moving parity out of the data block, which is what
+ * lets a single read correct a flip without depending on a second block --
+ * the property the filesystem exists for. Sequential reads simply go one
+ * folio at a time through read_folio.
+ *
+ * read_folio: iomap resolves which INLINE block backs each
+ * file range, then calls beamfs_inline_read_folio_range() to produce the
+ * bytes. The folio locking and uptodate accounting are iomap's; what
+ * stays here is the RS decode.
+ */
+static int beamfs_inline_read_folio(struct file *file, struct folio *folio)
+{
+	struct iomap_read_folio_ctx ctx = {
+		.ops       = &beamfs_inline_read_ops,
+		.cur_folio = folio,
+	};
+
+	iomap_read_folio(&beamfs_inline_iomap_ops, &ctx, NULL);
+	return 0;
+}
+
+/* ------------------------------------------------------------------------- */
+/* iomap write path                                                          */
+/*                                                                           */
+/* Same shape as the read side. iomap owns the folio lifecycle -- locking,   */
+/* dirty accounting, writeback tagging -- and beamfs owns what the bytes     */
+/* look like on disk: the read-modify-write cycle that decodes a block,      */
+/* splices the folio's contribution in, re-encodes all 16 RS codewords and   */
+/* stamps the DATA_CSUM descriptor.                                          */
+/* ------------------------------------------------------------------------- */
+
+/*
+ * Fill a folio range for a partial write. iomap calls this when a write
+ * covers only part of a folio that is not uptodate, so the rest has to
+ * come off disk first. The contract requires a synchronous read, which
+ * is what the decode path does anyway.
+ */
+static int beamfs_inline_write_read_folio_range(const struct iomap_iter *iter,
+						struct folio *folio,
+						loff_t pos, size_t len)
+{
+	struct inode       *inode = iter->inode;
+	struct super_block *sb    = inode->i_sb;
+	loff_t              i_size = i_size_read(inode);
+	u64                 p     = (u64)pos;
+	u64                 end   = p + len;
+	int                 ret   = 0;
+
+	if (end > (u64)i_size) {
+		u64 eof = max_t(u64, p, (u64)i_size);
+
+		folio_zero_range(folio, offset_in_folio(folio, eof),
+				 (size_t)(end - eof));
+		end = eof;
+	}
+
+	while (p < end) {
+		u32    payload      = beamfs_block_payload(inode->i_sb);
+		u64    b            = div_u64(p, payload);
+		u32    slice_offset = (u32)(p - b * payload);
+		u32    slice_length = (u32)min_t(u64, end - p,
+						 payload - slice_offset);
+		size_t folio_off    = offset_in_folio(folio, p);
+		struct buffer_head *bh;
+		u64    phys = 0;
+		u8    *dst;
+
+		/*
+		 * The tree read under the allocator's mutex.
+		 *
+		 * lookup_phys walks i_direct and the indirect blocks while
+		 * writeback, truncate and eviction are free to rewrite them.
+		 * Reading a pointer mid-update returns a block number that
+		 * belongs to no one, or to another file once it has been
+		 * reallocated. ext2 holds truncate_mutex across the same walk.
+		 *
+		 * Held for the lookup only, released before the read that
+		 * follows: the block I/O may sleep and has no business
+		 * holding up the allocator.
+		 */
+		mutex_lock(&BEAMFS_I(inode)->i_alloc_mutex);
+		ret = beamfs_inline_lookup_phys(inode, b, &phys);
+		mutex_unlock(&BEAMFS_I(inode)->i_alloc_mutex);
+		if (ret < 0)
+			break;
+
+		if (phys == 0) {
+			folio_zero_range(folio, folio_off, slice_length);
+			p += slice_length;
+			continue;
+		}
+
+		bh = sb_bread(sb, phys);
+		if (!bh) {
+			ret = -EIO;
+			break;
+		}
+
+		dst = kmap_local_folio(folio, folio_off);
+		lock_buffer(bh);
+		ret = beamfs_inline_decode_block_into_buf(sb, bh->b_data, phys, inode,
+							  b, dst, slice_offset,
+							  slice_length, false);
+		unlock_buffer(bh);
+		kunmap_local(dst);
+		brelse(bh);
+		if (ret < 0)
+			break;
+
+		p += slice_length;
+	}
+
+	return ret;
+}
+
+static const struct iomap_write_ops beamfs_inline_write_ops = {
+	.read_folio_range = beamfs_inline_write_read_folio_range,
+};
+
+/*
+ * Writeback: encode into bounce pages, gather the pages into bios.
+ *
+ * How ext2 and ext4 write a file back, functionally: the flusher hands
+ * the filesystem one folio after another; the filesystem resolves
+ * where each block goes, appends the folio's pages to the bio it is
+ * building while the blocks stay contiguous, and submits that bio
+ * when they stop being contiguous, when it is full, or at the end of
+ * the pass. Nothing waits per block, dozens of writes are in flight at
+ * once, the device sees requests of 128 KiB rather than 4, and a
+ * folio's writeback ends from the completion of the bio that carried
+ * it. A block is a page, so no block is ever half a folio's and half
+ * another's, and nothing is read back to be rewritten.
+ *
+ * beamfs cannot hand the folio's own pages to the device: a block
+ * carries 3808 or 3824 bytes of payload alongside 256 bytes of
+ * Reed-Solomon parity and its checksum and identity fields, so every
+ * block has to be encoded into a bounce page first. And because the
+ * payload is not 4096, a folio ends inside a block that the next folio
+ * continues.
+ *
+ * What was here before did the encode through the block device's
+ * buffer cache, one buffer_head per block, one bio per buffer_head,
+ * and took the buffer lock for each: the block a folio ended in was
+ * read back, decoded, merged, re-encoded and written, and then the
+ * next folio did the same to the same block -- waiting first on the
+ * lock, which the write in flight still held. Measured on 2026-09-22
+ * under generic/074: 2 176 467 writes of one block, 1.12 ms each, one
+ * in flight at a time, 4.8 MB/s, every boundary block written twice
+ * and decoded once; ext2 on the same device ran the same test in 17
+ * seconds against a budget beamfs could not fit in.
+ *
+ * Now the boundary block is not written until the folio that
+ * continues it has arrived: its payload waits in wb->pend, the next
+ * folio fills the rest, and the block is encoded once and queued
+ * once. Encoded pages come from a pool, not the buffer cache, so no
+ * buffer lock is held across anything that can sleep -- the rule whose
+ * breach generic/076 turned into a four-party deadlock. Blocks
+ * contiguous on the medium go into one bio of up to
+ * 32 pages, submitted when the run breaks, when it is full, or from
+ * writeback_submit at the end of the pass. Each folio carries a
+ * counter of the blocks that hold its bytes; the bio completion
+ * decrements it and finishes the folio at zero, so a folio whose two
+ * blocks travel in two bios is finished exactly once.
+ *
+ * The buffer cache still holds aliases of data blocks: the zero image
+ * a fresh allocation writes through sb_getblk, the copy a read-modify-
+ * write took through sb_bread, the copy read_folio_range consults
+ * first. Before an encoded page is queued, any alias is brought to the
+ * same bytes and made clean, under its lock, so a reader that finds it
+ * reads what the device will hold, and the block device's own flusher
+ * does not later write the stale zeros over the data.
+ */
+
+/* 32 blocks of 4 KiB: one bio of 128 KiB, the size ext4 builds. */
+#define BEAMFS_WB_MAX_BLOCKS 32
+
+/*
+ * One folio in flight. pending counts the blocks that carry bytes of
+ * this folio and have not completed; the folio is finished at zero.
+ * abandoned is set when writeback_range failed for this folio after
+ * queueing some of its blocks: iomap ends such a folio itself, and a
+ * second finish from here would end a writeback that is not ours.
+ */
+struct beamfs_wb_folio {
+	struct inode *inode;
+	struct folio *folio;
+	size_t        len;
+	refcount_t    pending;
+	bool          abandoned;
+};
+
+/* One encoded block in a bio, and the folio or folios it came from. */
+struct beamfs_wb_block {
+	struct page            *page;
+	struct beamfs_wb_folio *owner;
+	struct beamfs_wb_folio *owner2;
+};
+
+/* A bio being built: contiguous encoded blocks, submitted together. */
+struct beamfs_wb_ioend {
+	struct bio            *bio;
+	struct super_block    *sb;
+	unsigned int           n;
+	sector_t               next;
+	struct beamfs_wb_block blk[BEAMFS_WB_MAX_BLOCKS];
+};
+
+/*
+ * The state of one writeback pass, kept in wpc->wb_ctx from the first
+ * folio to writeback_submit.
+ */
+struct beamfs_wb {
+	struct super_block     *sb;
+	struct beamfs_wb_ioend *ioend;
+	/* The boundary block waiting for the folio that continues it. */
+	bool                    have_pend;
+	u64                     pend_phys;
+	u64                     pend_b;
+	u32                     pend_filled;
+	loff_t                  pend_next_pos;
+	struct inode           *pend_inode;
+	struct beamfs_wb_folio *pend_owner;
+	u8                     *pend_payload;
+	/* The first error a completion or a flush saw. */
+	int                     error;
+};
+
-- 
2.55.0

