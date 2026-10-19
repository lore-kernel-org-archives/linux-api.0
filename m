Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B243C3F64
	for <linux-api@vger.kernel.org>; Mon, 19 Oct 2026 04:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792383501; cv=none; b=f0CrTKlDh6zF7eKoIOI7HfPbXQ9QhSqD5MuWtzPHyCb/cDFwPK4uhTDe0HC+7GEQDWmRbbiyhvJefhsxuJ2dk5HlJkbgSmtAU3Xq8VrheQ2MqMqAO9gRKjDhZ5Aq5hRnThlf+3QFu1Jk6QDwbtMOtAhWvghyKb0GubH8ywP5LQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792383501; c=relaxed/simple;
	bh=svVSK2LuGqacp4seRV8Urzr28v5qHRaVADBtGBUJ/lI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZuJj8xjiUpp1+z//WR9VOyJmtsu1M6ih9Scg/gXqCfwR9lkLyKQvNfPqgreXcRlHbsLpaG9oWNHwjenS4u+qvQFitL2BPprj12m4lWTRCcWhjhtwJNesZvy9p/9hW50+4PQMlD+pJeE/MSuO7XQaPkM3NdIRG+kwl74srmaETM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hackers.camp; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hackers.camp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-4887dbe4f2dso206042f8f.3
        for <linux-api@vger.kernel.org>; Sun, 18 Oct 2026 21:18:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792383490; x=1792988290;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nJVGdUtkjuCBrR8jULwo+EEKIVBWEAYIjz56iH0bIU0=;
        b=uek51nglg++Tp48E9uGZG/yicLxpGuxoJJY7v/6805uKnqAVQPEz25MzoNm9fIhdpK
         lYQ/E02F/DKfypCguhDQE0iaIBxnYTZbYfOBnwqnstwfYLJkn4yTgk38wRqx5dcmJ8b2
         h8XaaXs1DM7FEUpCaQ0EFcd/pM5O9SROcgi9KOM/lcY32KwiHf5zcTOaXAKTc6ABRFXy
         VMQS0ULvQA4Forwvu1tzewjHujsJHAPVHEBwIBcY6J3q35Wa7LVq1toJbgzn54kv7cEI
         UeFwhfVAX2vD3UNZxmRy4ItQqxNgvUiaQNQZtPk2GunmBBRmWAhn825t0vSiwtwXYvjY
         sOPg==
X-Forwarded-Encrypted: i=1; AKwUvBz4R+Y7UAZ/PNAM/DU8K4UAm5pbRyOZkUnI4FbnaVANW45fPlX57LDTPaa6WSOuJ14yOd/9NtPwWs8=@vger.kernel.org
X-Gm-Message-State: AFq9FYJfCHbaZBLq41ut4NdS9GAue9UXPmp8qm+MIJbaGXPnu7oxLyrU
	MS9HymGB6zZnTOy+Jdz46T/H+Llio3fjelXbO4FE1hdEFf4ZUfdpwSiv
X-Gm-Gg: AYBFou1ZCgaMBOHtPbSBQtMBQu0PfBMJYFkUi1zliXoI9ginO0lawdzv6GbwK2YGRUu
	5gGSoHt2otHS5czeE3/DLk0/1Lfj1gQA2j1ibITjy1BEFrzjB6YqnvS1LgJRBSfyIAG2cywZmmX
	jPi8C5uq7ogF9Gis6FfDo/8KNduL3vcOXnXfkKW15u66wb2s3ld9qshtYlN9tZlbFpTVUAYFwuv
	/cBatoyZGnbJk+caR+8PS9iNgAQia6EvpjJnRTXWXBS+npQE9DlF6uY67lG8yE+epdMMk2Ttwqx
	niZA7Jpp3Wn2xauqxQnJL8WcTxaS9NLfC5dnMKEnKMLooyUzFvR+cKGRSAvDmIwfvMYkzl4wv0y
	szQyyMclbSgEXZkxv+BS5hC44EH1YkzxOSyjW7gind0SkD6g8wj2KBN+0jETzCs18aFRdz7rv45
	HilMXzR+WOqH2GTPSxERw4RJguTkVI1f0YocNwIqAXdRnlnMoj7NnFAIMjVEvgLYWE7VXkMOHif
	uhoyIjjdGI9xnxT7xgBUR05I+Q6krCHBVxe
X-Received: by 2002:a05:6000:46d7:b0:487:8ba:8b4c with SMTP id ffacd0b85a97d-48e0798be38mr10075156f8f.1.1792383489505;
        Sun, 18 Oct 2026 21:18:09 -0700 (PDT)
Received: from spartian.home ([2a01:cb1c:76:ed00:602f:c5f4:d108:b925])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd500e75sm20090449f8f.42.2026.10.18.21.18.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 21:18:08 -0700 (PDT)
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
Subject: [RFC PATCH 12/18] beamfs: inline data path 2/4, allocation
Date: Mon, 19 Oct 2026 06:17:22 +0200
Message-ID: <20261019041728.327785-13-aurelien@hackers.camp>
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

This part: beamfs_inline_lookup_or_alloc_phys_new(), which allocates
data and indirect blocks and installs them in the tree.

Assisted-by: LLM
Signed-off-by: Aurelien DESBRIERES <aurelien@hackers.camp>
---
 fs/beamfs/file_inline.c | 1575 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 1575 insertions(+)

diff --git a/fs/beamfs/file_inline.c b/fs/beamfs/file_inline.c
index 6c071d623fcb..dca00ae1f645 100644
--- a/fs/beamfs/file_inline.c
+++ b/fs/beamfs/file_inline.c
@@ -823,3 +823,1578 @@ static inline void beamfs_order_before_pointer(struct buffer_head *bh)
  *
  * @allocated may be NULL for callers that do not care.
  */
+static int beamfs_inline_lookup_or_alloc_phys_new(struct inode *inode,
+						  u64 iblock_logical,
+						  u64 *phys_out,
+						  bool *allocated);
+
+static int beamfs_inline_lookup_or_alloc_phys(struct inode *inode,
+					      u64 iblock_logical,
+					      u64 *phys_out)
+{
+	return beamfs_inline_lookup_or_alloc_phys_new(inode, iblock_logical,
+						      phys_out, NULL);
+}
+
+/*
+ * Lay a block's payload down in whichever layout the volume uses.
+ *
+ * Alternating, the payload is sixteen runs of 239 bytes 255 apart, and
+ * the copy has to break it up. A capsule holds it contiguously, and
+ * breaking it up writes every run 16 bytes further along than it
+ * belongs -- measured as the last 222 bytes of every block coming back
+ * wrong, which is where the fifteenth run ends up.
+ *
+ * Paired with beamfs_seal_data_block, which encodes what this writes.
+ */
+void beamfs_lay_data_payload(struct super_block *sb, u8 *block,
+			     const u8 *payload)
+{
+	unsigned int i;
+
+	if (BEAMFS_SB(sb)->s_feat_incompat &
+	    BEAMFS_FEATURE_INCOMPAT_RS_INTERLEAVE) {
+		memcpy(block + BEAMFS_CAPSULE_DATA_OFF, payload,
+		       BEAMFS_CAPSULE_DATA_BYTES);
+		return;
+	}
+
+	for (i = 0; i < BEAMFS_DATA_INLINE_SUBBLOCKS; i++)
+		memcpy(block + (size_t)i * BEAMFS_SUBBLOCK_TOTAL,
+		       payload + (size_t)i * BEAMFS_SUBBLOCK_DATA,
+		       BEAMFS_SUBBLOCK_DATA);
+}
+
+/*
+ * Seal a data block: compute its RS parity in whichever layout the
+ * volume uses. Every site that encodes a data block goes through here,
+ * so a layout change touches one place.
+ */
+int beamfs_seal_data_block(struct super_block *sb, u8 *block)
+{
+	if (BEAMFS_SB(sb)->s_feat_incompat &
+	    BEAMFS_FEATURE_INCOMPAT_RS_INTERLEAVE)
+		return beamfs_rs_encode_woven(block + BEAMFS_CAPSULE_DATA_OFF,
+					      block + BEAMFS_CAPSULE_PARITY_OFF,
+					      BEAMFS_RS_PARITY,
+					      BEAMFS_SUBBLOCK_DATA,
+					      BEAMFS_DATA_INLINE_SUBBLOCKS);
+
+	return beamfs_rs_encode_region(block, BEAMFS_SUBBLOCK_TOTAL,
+				       block + BEAMFS_SUBBLOCK_DATA,
+				       BEAMFS_SUBBLOCK_TOTAL,
+				       BEAMFS_SUBBLOCK_DATA,
+				       BEAMFS_DATA_INLINE_SUBBLOCKS);
+}
+
+/*
+ * Dirty an indirect block and attach it to @inode, unless its last
+ * write failed.
+ *
+ * An install reads the parent block, allocates the child -- which can
+ * sleep -- and only then stores the pointer and dirties the parent. A
+ * write of the parent that fails in between leaves it not uptodate
+ * (end_buffer_write_sync clears the bit on an error): the medium holds
+ * an older block than memory does, and dirtying it anyway is what
+ * mark_buffer_dirty warns about. The volume is failed instead, as
+ * beamfs_write_bitmap_block does for a bitmap block.
+ *
+ * Tested under the buffer lock: a write in flight holds it until its
+ * completion has set or cleared uptodate.
+ */
+static void beamfs_attach_dirty(struct inode *inode, struct buffer_head *bh)
+{
+	lock_buffer(bh);
+	if (!buffer_uptodate(bh)) {
+		unlock_buffer(bh);
+		pr_err_ratelimited("beamfs: block %llu: its last write failed, not dirtied again\n",
+				   (unsigned long long)bh->b_blocknr);
+		beamfs_fail(inode->i_sb, "indirect block write", -EIO);
+		return;
+	}
+	mmb_mark_buffer_dirty(bh, &BEAMFS_I(inode)->i_metadata_bhs);
+	unlock_buffer(bh);
+}
+
+static int beamfs_inline_lookup_or_alloc_phys_new(struct inode *inode,
+						  u64 iblock_logical,
+						  u64 *phys_out,
+						  bool *allocated)
+{
+	/*
+	 * False until proven otherwise: a caller reading this after an
+	 * error path must not find a stale true.
+	 */
+	if (allocated)
+		*allocated = false;
+
+	/*
+	 * Nothing to allocate for an inode being destroyed.
+	 *
+	 * __mark_inode_dirty returns without queueing when I_FREEING is
+	 * set -- fs-writeback.c, "if (inode_state_read(inode) &
+	 * I_FREEING) goto out_unlock". A block allocated here has its
+	 * pointer installed into a tree whose inode will never be
+	 * written: the bitmap says used, nothing references it, and fsck
+	 * calls it used-but-unreferenced.
+	 *
+	 * The check belongs here rather than in the callers, because all
+	 * three of them -- iomap_begin, writeback_range, zero_tail_block
+	 * -- can run against an evicting inode, and guarding one of the
+	 * three leaves the other two leaking.
+	 *
+	 * ext2 cannot reach this: ext2_get_block runs with create=0 on
+	 * the writeback path, and an evicting inode has been through
+	 * truncate_inode_pages_final. beamfs allocates at writeback and
+	 * has to check for itself.
+	 */
+	if (inode_state_read_once(inode) &
+	    (I_FREEING | I_WILL_FREE | I_CLEAR))
+		return -EIO;
+
+	/*
+	 * Nothing free: say so once and return, rather than walking the
+	 * whole indirection tree to discover it at every level.
+	 *
+	 * Without this a full volume produced one failed allocation per
+	 * block per level -- 19531 suppressed log callbacks in three
+	 * seconds under generic/224 -- and the writeback path spent its
+	 * time in the allocator and the ring buffer instead of returning
+	 * ENOSPC. The test then exceeded its timeout for want of an error
+	 * the filesystem already knew.
+	 *
+	 * s_free_blocks is read without the lock. It is a hint here: a
+	 * concurrent free racing this check costs one retry, and the
+	 * allocation below is still the thing that decides.
+	 */
+	if (BEAMFS_SB(inode->i_sb)->s_free_blocks == 0)
+		return -ENOSPC;
+
+	struct beamfs_inode_info *fi = BEAMFS_I(inode);
+	struct super_block       *sb = inode->i_sb;
+	struct buffer_head *ibh = NULL;
+	struct buffer_head       *dbh;
+	__le64                   *ptrs;
+	u64                       indirect_blk;
+	u64                       indirect_slot;
+	u64                       phys;
+	u64                       new_block;
+
+	if (!phys_out)
+		return -EINVAL;
+
+	*phys_out = 0;
+
+	if (iblock_logical < BEAMFS_DIRECT_BLOCKS) {
+		/* --- Direct block --- */
+		phys = le64_to_cpu(fi->i_direct[iblock_logical]);
+		if (phys) {
+			*phys_out = phys;
+			return 0;
+		}
+		new_block = beamfs_alloc_block(sb, inode);
+		if (!new_block) {
+			if (beamfs_failed(sb))
+				return -EIO;
+			return -ENOSPC;
+		}
+		/* Zero-init the freshly allocated data block on disk. */
+		dbh = sb_getblk(sb, new_block);
+		if (!dbh) {
+			beamfs_free_block(sb, new_block, inode);
+			return -EIO;
+		}
+		lock_buffer(dbh);
+		memset(dbh->b_data, 0, BEAMFS_BLOCK_SIZE);
+		/*
+		 * Stamp the DATA_CSUM descriptor on the freshly allocated data
+		 * block. An all-zero block is a valid RS codeword by linearity,
+		 * so decode accepts it, but the descriptor would stay 0x00 and
+		 * the read path would have nothing to verify against. Before
+		 * the type byte was made fail-closed that meant silent
+		 * acceptance; afterwards it means a legitimate newly allocated
+		 * block is rejected. Observed 2026-08-18: iblocks 0..5 of a
+		 * test file logged "bad descriptor type=0x00" on five runs out
+		 * of six, because allocation writes the block here while the
+		 * only other stamp sites are writeback and
+		 * zero_tail_block, neither of which runs for a block that is
+		 * allocated but not yet written through the folio path. The
+		 * payload is the zeroed block itself. Indirect blocks carry no
+		 * DATA_CSUM descriptor and are deliberately left untouched.
+		 */
+		beamfs_inline_stamp_tail_pad(BEAMFS_SB(sb), (u8 *)dbh->b_data,
+					     (const u8 *)dbh->b_data,
+					     (unsigned long long)inode->i_ino, iblock_logical);
+		set_buffer_uptodate(dbh);
+		unlock_buffer(dbh);
+		/*
+		 * A data block carries sixteen RS codewords, not indirect
+		 * parity.
+		 *
+		 * ind_parity_update files a CRC for this block number in
+		 * the separate parity region that covers indirect blocks.
+		 * A newly allocated data block was being registered there,
+		 * and its own sixteen codewords were left as the zeros
+		 * memset put down -- correct for a zero block, wrong the
+		 * moment anything is written into it and the parity is not
+		 * recomputed.
+		 *
+		 * The sweep found exactly that: subblocks holding data,
+		 * uncorrectable; subblocks still zero, fine. Encoding here
+		 * makes a fresh block valid on its own terms from the
+		 * start.
+		 */
+		{
+			int _e = beamfs_seal_data_block(sb, (u8 *)dbh->b_data);
+
+			if (_e < 0)
+				pr_err_ratelimited("beamfs/inline: encode of new data block %llu failed: %d\n",
+						   (unsigned long long)new_block,
+						   _e);
+		}
+		mark_buffer_dirty(dbh);
+
+		/*
+		 * The direct array is a slot store like any other.
+		 *
+		 * The three indirect levels emit this and the direct array
+		 * did not, so a probe pairing allocations against stores
+		 * counted every direct block as an allocation that went
+		 * nowhere: 176180 of them in one generic/269, against 327
+		 * blocks fsck actually finds leaked.
+		 *
+		 * parent 0 and level 0: there is no block above a direct
+		 * pointer, and nothing else uses those values.
+		 */
+		trace_beamfs_slot_store(inode->i_sb->s_dev, inode->i_ino, 0, iblock_logical,
+					le64_to_cpu(fi->i_direct[iblock_logical]),
+					new_block, 0);
+
+		/* The block, before the pointer that names it. */
+		beamfs_order_before_pointer(dbh);
+		brelse(dbh);
+		fi->i_direct[iblock_logical] = cpu_to_le64(new_block);
+		mark_inode_dirty(inode);
+
+		if (allocated)
+			*allocated = true;
+		*phys_out = new_block;
+		return 0;
+	}
+
+	if (iblock_logical < BEAMFS_DIRECT_BLOCKS + BEAMFS_INDIRECT_PTRS) {
+		/* --- Single indirect block --- */
+		indirect_slot = iblock_logical - BEAMFS_DIRECT_BLOCKS;
+		indirect_blk  = le64_to_cpu(fi->i_indirect);
+
+		if (!indirect_blk) {
+			/* Allocate indirect block first, zero-init. */
+			indirect_blk = beamfs_alloc_block(sb, inode);
+			if (!indirect_blk) {
+				if (beamfs_failed(sb))
+					return -EIO;
+				return -ENOSPC;
+			}
+			ibh = sb_getblk(sb, indirect_blk);
+			if (!ibh) {
+				beamfs_free_block(sb, indirect_blk, inode);
+				return -EIO;
+			}
+			lock_buffer(ibh);
+			beamfs_tc_zeroed(sb, inode->i_ino, ibh->b_blocknr, __func__);
+			memset(ibh->b_data, 0, BEAMFS_BLOCK_SIZE);
+			set_buffer_uptodate(ibh);
+			/*
+			 * Parity taken under the lock, like the install
+			 * sites do.
+			 *
+			 * The block is allocated and visible before its
+			 * pointer is installed a few lines down, so
+			 * another writer can reach it. Computing parity
+			 * after unlock_buffer describes whatever the block
+			 * held at that instant, which need not be what
+			 * reaches the medium: generic/464 writes and
+			 * fsyncs the same files from several tasks and
+			 * produced 194 indirect blocks whose parity was
+			 * written and did not match, seven orphaned blocks
+			 * under each.
+			 */
+			beamfs_ind_parity_update(sb, ibh, inode);
+			unlock_buffer(ibh);
+			/*
+			 * Attach it to the inode as the install sites do.
+			 *
+			 * A fresh indirect block is dirtied here and its first
+			 * pointer installed a few lines further down, and the
+			 * install attaches it. But sb_getblk here and sb_bread
+			 * there need not hand back the same buffer: if this one
+			 * is evicted in between, it goes with nothing written,
+			 * on no inode's list for anyone to flush.
+			 *
+			 * generic/464 loses exactly that. Inode 150 in one
+			 * capture: four pointers installed into indirect block
+			 * 33190, i_indirect written to disk naming it, and 33190
+			 * itself still 0xcd -- never written at all -- so fsck
+			 * finds four blocks marked used that nothing references.
+			 */
+			mmb_mark_buffer_dirty(ibh, &BEAMFS_I(inode)->i_metadata_bhs);
+			/*
+			 * Held, not released and read back.
+			 *
+			 * This released the buffer here and read the same block
+			 * again a few lines down. Between the two it can be
+			 * evicted, and the read then comes from the medium --
+			 * where nothing has been written yet. The block returns
+			 * holding whatever was there before, and every pointer
+			 * installed into it afterwards lands in a block that is
+			 * never written at all.
+			 *
+			 * A frozen generic/464 volume shows the whole thing:
+			 * inode 36's indirect block 16469, named by the inode on
+			 * disk, 0xcd across 464 of its 512 slots, and 273 blocks
+			 * reported used and referenced by nothing.
+			 *
+			 * Attaching it to the inode was meant to close this. It
+			 * does not: the attach makes the buffer flushable, and
+			 * dropping the last reference still lets it go before
+			 * anything flushes it. Holding the reference closes it.
+			 */
+
+			/* The block, before the pointer that names it. */
+			beamfs_order_before_pointer(ibh);
+			/*
+			 * The inode's own pointer is a slot store too.
+			 *
+			 * parent 0 and level 0, as for the direct array:
+			 * there is no block above an inode's pointer. Without
+			 * it a probe following a block from allocation to its
+			 * tree loses every root indirect block.
+			 */
+			trace_beamfs_slot_store(inode->i_sb->s_dev, inode->i_ino, 0, 0, 0,
+						indirect_blk, 0);
+			fi->i_indirect = cpu_to_le64(indirect_blk);
+			mark_inode_dirty(inode);
+		}
+
+		/* Read indirect to look up / install the slot. */
+		/* Already held when this call created it. */
+		{
+			int cached = 1;
+
+			if (!ibh) {
+				/*
+				 * Same probe as the read path: was this
+				 * block already in the cache, or does it
+				 * come off the medium?
+				 *
+				 * The allocation path had no tracepoint at
+				 * all, so a slot installed here and read
+				 * back as zero 150 ms later could not be
+				 * told apart from a slot never written.
+				 * generic/083 lost 47 blocks that way and
+				 * the trace could not say which.
+				 */
+				struct buffer_head *probe =
+					sb_find_get_block(sb, indirect_blk);
+
+				cached = !!probe;
+				if (probe)
+					brelse(probe);
+				ibh = sb_bread(sb, indirect_blk);
+			}
+			if (ibh)
+				trace_beamfs_ind_read(inode->i_sb->s_dev,
+						      inode->i_ino, indirect_blk,
+					(unsigned int)indirect_slot,
+					le64_to_cpu(((__le64 *)ibh->b_data)[indirect_slot]),
+					buffer_uptodate(ibh), !cached);
+		}
+		if (!ibh) {
+			pr_err_ratelimited("beamfs/inline: failed to read indirect block %llu\n",
+					   (unsigned long long)indirect_blk);
+			return -EIO;
+		}
+		/*
+		 * Verify before trusting the pointers. Under CRC this turns a
+		 * flipped pointer that lands in range and on an allocated block
+		 * -- the residual left open by the bounds check above -- into a
+		 * clean failure instead of someone else's data. Under RS a copy
+		 * is decoded and what it corrects is journalled, but the
+		 * pointers are read as the medium holds them: a correctable
+		 * flip is reported, not repaired.
+		 */
+		if (beamfs_ind_parity_verify(sb, ibh)) {
+			brelse(ibh);
+			return -EUCLEAN;
+		}
+		ptrs = (__le64 *)ibh->b_data;
+		phys = le64_to_cpu(ptrs[indirect_slot]);
+
+		if (phys) {
+			brelse(ibh);
+			*phys_out = phys;
+			return 0;
+		}
+
+		/* Allocate data block and zero-init. */
+		new_block = beamfs_alloc_block(sb, inode);
+		if (!new_block) {
+			brelse(ibh);
+			if (beamfs_failed(sb))
+				return -EIO;
+			return -ENOSPC;
+		}
+		dbh = sb_getblk(sb, new_block);
+		if (!dbh) {
+			beamfs_free_block(sb, new_block, inode);
+			brelse(ibh);
+			return -EIO;
+		}
+		lock_buffer(dbh);
+		memset(dbh->b_data, 0, BEAMFS_BLOCK_SIZE);
+		/*
+		 * Stamp the DATA_CSUM descriptor on the freshly allocated data
+		 * block. An all-zero block is a valid RS codeword by linearity,
+		 * so decode accepts it, but the descriptor would stay 0x00 and
+		 * the read path would have nothing to verify against. Before
+		 * the type byte was made fail-closed that meant silent
+		 * acceptance; afterwards it means a legitimate newly allocated
+		 * block is rejected. Observed 2026-08-18: iblocks 0..5 of a
+		 * test file logged "bad descriptor type=0x00" on five runs out
+		 * of six, because allocation writes the block here while the
+		 * only other stamp sites are writeback and
+		 * zero_tail_block, neither of which runs for a block that is
+		 * allocated but not yet written through the folio path. The
+		 * payload is the zeroed block itself. Indirect blocks carry no
+		 * DATA_CSUM descriptor and are deliberately left untouched.
+		 */
+		beamfs_inline_stamp_tail_pad(BEAMFS_SB(sb), (u8 *)dbh->b_data,
+					     (const u8 *)dbh->b_data,
+					     (unsigned long long)inode->i_ino, iblock_logical);
+		set_buffer_uptodate(dbh);
+		unlock_buffer(dbh);
+		/*
+		 * A data block carries sixteen RS codewords, not indirect
+		 * parity.
+		 *
+		 * ind_parity_update files a CRC for this block number in
+		 * the separate parity region that covers indirect blocks.
+		 * A newly allocated data block was being registered there,
+		 * and its own sixteen codewords were left as the zeros
+		 * memset put down -- correct for a zero block, wrong the
+		 * moment anything is written into it and the parity is not
+		 * recomputed.
+		 *
+		 * The sweep found exactly that: subblocks holding data,
+		 * uncorrectable; subblocks still zero, fine. Encoding here
+		 * makes a fresh block valid on its own terms from the
+		 * start.
+		 */
+		{
+			int _e = beamfs_seal_data_block(sb, (u8 *)dbh->b_data);
+
+			if (_e < 0)
+				pr_err_ratelimited("beamfs/inline: encode of new data block %llu failed: %d\n",
+						   (unsigned long long)new_block,
+						   _e);
+		}
+		mark_buffer_dirty(dbh);
+
+		/*
+		 * Under the buffer lock, like ext2 splicing a branch.
+		 *
+		 * This stores a pointer into a shared indirect block. Without
+		 * the lock the store races the flusher submitting that same
+		 * buffer: the pointer reaches disk half-written, or a
+		 * concurrent installer's store is lost. generic/464 lost
+		 * blocks whose final event was exactly this store into an L1
+		 * shared across inodes, with no free and no truncate after.
+		 * ind_parity_update reads b_data, so it belongs inside the
+		 * lock too.
+		 */
+		lock_buffer(ibh);
+		trace_beamfs_slot_store(inode->i_sb->s_dev, inode->i_ino, ibh->b_blocknr,
+					indirect_slot, le64_to_cpu(ptrs[indirect_slot]),
+					new_block, 1);
+		beamfs_tc_store(sb, inode->i_ino, ibh->b_blocknr,
+				(u32)indirect_slot, le64_to_cpu(ptrs[indirect_slot]), new_block,
+			__func__);
+		/* The block, before the pointer that names it. */
+		beamfs_order_before_pointer(dbh);
+		brelse(dbh);
+		ptrs[indirect_slot] = cpu_to_le64(new_block);
+		beamfs_ind_parity_update(sb, ibh, inode);
+		unlock_buffer(ibh);
+		/*
+		 * Attach the block to the inode and dirty the inode, the
+		 * way ext2_splice_branch ends:
+		 *
+		 *   mmb_mark_buffer_dirty(where->bh,
+		 *                         &EXT2_I(inode)->i_metadata_bhs);
+		 *   inode_set_ctime_current(inode);
+		 *   mark_inode_dirty(inode);
+		 *
+		 * A plain mark_buffer_dirty leaves the block on no inode's
+		 * metadata list, so __writeback_single_inode never flushes
+		 * it: the pointer is in memory, the buffer is dirty, and
+		 * nothing carries it to the disk. The three sites that
+		 * create a fresh indirect block already dirty the inode --
+		 * they change i_indirect -- and these three, installing
+		 * into a block that already exists, did not.
+		 *
+		 * That is the generic/464 leak: 28 blocks allocated by one
+		 * writer into one inode from this site, no free after, and
+		 * the flusher reallocating for the same inode seconds later
+		 * because the tree it read had none of them.
+		 */
+		beamfs_attach_dirty(inode, ibh);
+		inode_set_ctime_current(inode);
+		mark_inode_dirty(inode);
+		brelse(ibh);
+
+		if (allocated)
+			*allocated = true;
+		*phys_out = new_block;
+		return 0;
+	}
+
+	if (iblock_logical < BEAMFS_MAX_IBLOCK_DINDIRECT) {
+		/*
+		 * Double-indirect write path: allocate dindirect block,
+		 * level-1 indirect block, and data block in a cascade,
+		 * each zero-initialized. The allocation order minimizes
+		 * orphaned blocks on crash: data block last, so a crash
+		 * between dindirect alloc and data alloc leaves a zero
+		 * level-1 pointer (treated as HOLE on read).
+		 */
+		u64 didx, l1_slot, l2_slot;
+		u64 dindirect_blk, l1_blk;
+		struct buffer_head *l1bh = NULL;
+
+		didx = iblock_logical - BEAMFS_MAX_IBLOCK_INDIRECT;
+		l1_slot = didx / BEAMFS_INDIRECT_PTRS;
+		l2_slot = didx % BEAMFS_INDIRECT_PTRS;
+
+		/* --- Stage 1: dindirect block --- */
+		dindirect_blk = le64_to_cpu(fi->i_dindirect);
+		if (!dindirect_blk) {
+			dindirect_blk = beamfs_alloc_block(sb, inode);
+			if (!dindirect_blk) {
+				if (beamfs_failed(sb))
+					return -EIO;
+				return -ENOSPC;
+			}
+			ibh = sb_getblk(sb, dindirect_blk);
+			if (!ibh) {
+				beamfs_free_block(sb, dindirect_blk, inode);
+				return -EIO;
+			}
+			lock_buffer(ibh);
+			beamfs_tc_zeroed(sb, inode->i_ino, ibh->b_blocknr, __func__);
+			memset(ibh->b_data, 0, BEAMFS_BLOCK_SIZE);
+			set_buffer_uptodate(ibh);
+			/*
+			 * Parity taken under the lock, like the install
+			 * sites do.
+			 *
+			 * The block is allocated and visible before its
+			 * pointer is installed a few lines down, so
+			 * another writer can reach it. Computing parity
+			 * after unlock_buffer describes whatever the block
+			 * held at that instant, which need not be what
+			 * reaches the medium: generic/464 writes and
+			 * fsyncs the same files from several tasks and
+			 * produced 194 indirect blocks whose parity was
+			 * written and did not match, seven orphaned blocks
+			 * under each.
+			 */
+			beamfs_ind_parity_update(sb, ibh, inode);
+			unlock_buffer(ibh);
+			/*
+			 * Attach it to the inode as the install sites do.
+			 *
+			 * A fresh indirect block is dirtied here and its first
+			 * pointer installed a few lines further down, and the
+			 * install attaches it. But sb_getblk here and sb_bread
+			 * there need not hand back the same buffer: if this one
+			 * is evicted in between, it goes with nothing written,
+			 * on no inode's list for anyone to flush.
+			 *
+			 * generic/464 loses exactly that. Inode 150 in one
+			 * capture: four pointers installed into indirect block
+			 * 33190, i_indirect written to disk naming it, and 33190
+			 * itself still 0xcd -- never written at all -- so fsck
+			 * finds four blocks marked used that nothing references.
+			 */
+			mmb_mark_buffer_dirty(ibh, &BEAMFS_I(inode)->i_metadata_bhs);
+			/*
+			 * Held, not released and read back.
+			 *
+			 * This released the buffer here and read the same block
+			 * again a few lines down. Between the two it can be
+			 * evicted, and the read then comes from the medium --
+			 * where nothing has been written yet. The block returns
+			 * holding whatever was there before, and every pointer
+			 * installed into it afterwards lands in a block that is
+			 * never written at all.
+			 *
+			 * A frozen generic/464 volume shows the whole thing:
+			 * inode 36's indirect block 16469, named by the inode on
+			 * disk, 0xcd across 464 of its 512 slots, and 273 blocks
+			 * reported used and referenced by nothing.
+			 *
+			 * Attaching it to the inode was meant to close this. It
+			 * does not: the attach makes the buffer flushable, and
+			 * dropping the last reference still lets it go before
+			 * anything flushes it. Holding the reference closes it.
+			 */
+			/* The block, before the pointer that names it. */
+			beamfs_order_before_pointer(ibh);
+			/*
+			 * The inode's own pointer is a slot store too.
+			 *
+			 * parent 0 and level 0, as for the direct array:
+			 * there is no block above an inode's pointer. Without
+			 * it a probe following a block from allocation to its
+			 * tree loses every root indirect block.
+			 */
+			trace_beamfs_slot_store(inode->i_sb->s_dev, inode->i_ino, 0, 0, 0,
+						dindirect_blk, 0);
+			fi->i_dindirect = cpu_to_le64(dindirect_blk);
+			mark_inode_dirty(inode);
+		}
+
+		/* --- Stage 2: level-1 indirect block --- */
+		{
+			/*
+			 * The last unlit sb_bread of the allocation path.
+			 *
+			 * generic/083 on 2026-09-18, inode 39: block 1067
+			 * became its i_dindirect at 479.487 and slots 0
+			 * to 4 were filled; from 483.756 slots 0, 1, 2 and
+			 * 3 were each written again, every one of them
+			 * reading zero, and treecheck reported three lost
+			 * pointers. Not one of those stores had an
+			 * ind_read beside it, because the read that
+			 * decides them happens here and here alone.
+			 *
+			 * 1067 had been a DATA block of inode 7 until
+			 * 479.485 -- 1.7 ms earlier. A data block recycled
+			 * into an indirect one passes through no path that
+			 * detaches its buffer from the old owner.
+			 */
+			struct buffer_head *probe =
+				sb_find_get_block(sb, dindirect_blk);
+			int cached = !!probe;
+
+			if (probe)
+				brelse(probe);
+			ibh = sb_bread(sb, dindirect_blk);
+			if (ibh)
+				trace_beamfs_ind_read(inode->i_sb->s_dev,
+						      inode->i_ino, dindirect_blk,
+					(unsigned int)l1_slot,
+					le64_to_cpu(((__le64 *)ibh->b_data)[l1_slot]),
+					buffer_uptodate(ibh), !cached);
+		}
+		if (!ibh) {
+			pr_err_ratelimited("beamfs/inline: failed to read dindirect block %llu\n",
+					   (unsigned long long)dindirect_blk);
+			return -EIO;
+		}
+		/*
+		 * Verify before trusting the pointers. Under CRC this turns a
+		 * flipped pointer that lands in range and on an allocated block
+		 * -- the residual left open by the bounds check above -- into a
+		 * clean failure instead of someone else's data. Under RS a copy
+		 * is decoded and what it corrects is journalled, but the
+		 * pointers are read as the medium holds them: a correctable
+		 * flip is reported, not repaired.
+		 */
+		if (beamfs_ind_parity_verify(sb, ibh)) {
+			brelse(ibh);
+			return -EUCLEAN;
+		}
+		ptrs = (__le64 *)ibh->b_data;
+		l1_blk = le64_to_cpu(ptrs[l1_slot]);
+		if (!l1_blk) {
+			l1_blk = beamfs_alloc_block(sb, inode);
+			if (!l1_blk) {
+				brelse(ibh);
+				if (beamfs_failed(sb))
+					return -EIO;
+				return -ENOSPC;
+			}
+			l1bh = sb_getblk(sb, l1_blk);
+			if (!l1bh) {
+				beamfs_free_block(sb, l1_blk, inode);
+				brelse(ibh);
+				return -EIO;
+			}
+			lock_buffer(l1bh);
+			beamfs_tc_zeroed(sb, inode->i_ino, l1bh->b_blocknr, __func__);
+			memset(l1bh->b_data, 0, BEAMFS_BLOCK_SIZE);
+			set_buffer_uptodate(l1bh);
+			unlock_buffer(l1bh);
+			beamfs_ind_parity_update(sb, l1bh, inode);
+			/*
+			 * Attach it to the inode as the install sites do.
+			 *
+			 * A fresh indirect block is dirtied here and its first
+			 * pointer installed a few lines further down, and the
+			 * install attaches it. But sb_getblk here and sb_bread
+			 * there need not hand back the same buffer: if this one
+			 * is evicted in between, it goes with nothing written,
+			 * on no inode's list for anyone to flush.
+			 *
+			 * generic/464 loses exactly that. Inode 150 in one
+			 * capture: four pointers installed into indirect block
+			 * 33190, i_indirect written to disk naming it, and 33190
+			 * itself still 0xcd -- never written at all -- so fsck
+			 * finds four blocks marked used that nothing references.
+			 */
+			mmb_mark_buffer_dirty(l1bh, &BEAMFS_I(inode)->i_metadata_bhs);
+			/*
+			 * And the inode, so the list gets flushed.
+			 *
+			 * mmb_mark_buffer_dirty puts the buffer on the inode's
+			 * metadata list, and mmb_sync empties that list -- from
+			 * write_inode, which the VFS calls only for an inode it
+			 * believes is dirty. Installing a pointer into a parent block
+			 * changes no field of the inode, so nothing marked it, and
+			 * both buffers stayed in memory with the pointer in them.
+			 *
+			 * generic/013 loses fourteen blocks that way: allocated,
+			 * placed in a slot, and the block holding the slot never
+			 * written -- "indirect block N has no parity written yet".
+			 */
+			mark_inode_dirty(inode);
+			/*
+			 * Held, not released and read back.
+			 *
+			 * This released the buffer here and read the same block
+			 * again a few lines down. Between the two it can be
+			 * evicted, and the read then comes from the medium --
+			 * where nothing has been written yet. The block returns
+			 * holding whatever was there before, and every pointer
+			 * installed into it afterwards lands in a block that is
+			 * never written at all.
+			 *
+			 * A frozen generic/464 volume shows the whole thing:
+			 * inode 36's indirect block 16469, named by the inode on
+			 * disk, 0xcd across 464 of its 512 slots, and 273 blocks
+			 * reported used and referenced by nothing.
+			 *
+			 * Attaching it to the inode was meant to close this. It
+			 * does not: the attach makes the buffer flushable, and
+			 * dropping the last reference still lets it go before
+			 * anything flushes it. Holding the reference closes it.
+			 */
+			/*
+			 * Traced like every other slot install.
+			 *
+			 * Three of the ten allocation sites called tc_store
+			 * and not this, so a probe pairing allocations with
+			 * stores counted every L1 and L2 indirect block as an
+			 * allocation that went nowhere: 4126 of them in one
+			 * generic/476, against the one block fsck found
+			 * leaked.
+			 */
+			/*
+			 * Under the buffer lock, like the data installs above.
+			 *
+			 * This stores a pointer into a shared indirect block. Without
+			 * the lock the store races the flusher submitting that same
+			 * buffer: the pointer reaches disk half-written, or a
+			 * concurrent installer's store is lost. treecheck caught it
+			 * from wb_workfn -- LOST POINTER, held N, read as 0 -- and the
+			 * child block then has no parity written for it and its whole
+			 * subtree is unreachable. The three data installs took this
+			 * lock; the three indirect installs did not.
+			 * ind_parity_update reads b_data, so it belongs inside too.
+			 */
+			lock_buffer(ibh);
+			trace_beamfs_slot_store(inode->i_sb->s_dev, inode->i_ino, ibh->b_blocknr,
+						l1_slot, le64_to_cpu(ptrs[l1_slot]),
+						l1_blk, 2);
+			beamfs_tc_store(sb, inode->i_ino, ibh->b_blocknr,
+					(u32)l1_slot, le64_to_cpu(ptrs[l1_slot]), l1_blk,
+				__func__);
+			/* The block, before the pointer that names it. */
+			beamfs_order_before_pointer(l1bh);
+			ptrs[l1_slot] = cpu_to_le64(l1_blk);
+			beamfs_ind_parity_update(sb, ibh, inode);
+			unlock_buffer(ibh);
+			/* Splicing a child into its parent is an install like
+			 * any other: the parent goes on the inode's list too,
+			 * or it is dirty on nobody's.
+			 */
+			beamfs_attach_dirty(inode, ibh);
+			/*
+			 * And the inode, so the list gets flushed.
+			 *
+			 * mmb_mark_buffer_dirty puts the buffer on the inode's
+			 * metadata list, and mmb_sync empties that list -- from
+			 * write_inode, which the VFS calls only for an inode it
+			 * believes is dirty. Installing a pointer into a parent block
+			 * changes no field of the inode, so nothing marked it, and
+			 * both buffers stayed in memory with the pointer in them.
+			 *
+			 * generic/013 loses fourteen blocks that way: allocated,
+			 * placed in a slot, and the block holding the slot never
+			 * written -- "indirect block N has no parity written yet".
+			 */
+			mark_inode_dirty(inode);
+		}
+		brelse(ibh);
+
+		/* --- Stage 3: data block --- */
+		/* Already held when this call created it. */
+		{
+			int cached = 1;
+
+			if (!l1bh) {
+				/*
+				 * The level-1 path had this probe and the
+				 * double indirect had none, so every lost
+				 * pointer below a dindirect was invisible.
+				 *
+				 * generic/083 on 2026-09-18: inode 112 put
+				 * 2127 into slot 0 of block 1248, then put
+				 * 11106 into that same slot 4.3 seconds
+				 * later, both stores reading zero. Far too
+				 * far apart for a race, and the trace had
+				 * nothing at all between them because the
+				 * read that returned zero was here.
+				 */
+				struct buffer_head *probe =
+					sb_find_get_block(sb, l1_blk);
+
+				cached = !!probe;
+				if (probe)
+					brelse(probe);
+				l1bh = sb_bread(sb, l1_blk);
+			}
+			if (l1bh)
+				trace_beamfs_ind_read(inode->i_sb->s_dev,
+						      inode->i_ino, l1_blk,
+					(unsigned int)l2_slot,
+					le64_to_cpu(((__le64 *)l1bh->b_data)[l2_slot]),
+					buffer_uptodate(l1bh), !cached);
+		}
+		if (!l1bh) {
+			pr_err_ratelimited("beamfs/inline: failed to read L1 indirect block %llu\n",
+					   (unsigned long long)l1_blk);
+			return -EIO;
+		}
+		/*
+		 * Verify before trusting the pointers. Under CRC this turns a
+		 * flipped pointer that lands in range and on an allocated block
+		 * -- the residual left open by the bounds check above -- into a
+		 * clean failure instead of someone else's data. Under RS a copy
+		 * is decoded and what it corrects is journalled, but the
+		 * pointers are read as the medium holds them: a correctable
+		 * flip is reported, not repaired.
+		 */
+		if (beamfs_ind_parity_verify(sb, l1bh)) {
+			brelse(l1bh);
+			return -EUCLEAN;
+		}
+		ptrs = (__le64 *)l1bh->b_data;
+		phys = le64_to_cpu(ptrs[l2_slot]);
+		if (phys) {
+			brelse(l1bh);
+			*phys_out = phys;
+			return 0;
+		}
+
+		new_block = beamfs_alloc_block(sb, inode);
+		if (!new_block) {
+			brelse(l1bh);
+			if (beamfs_failed(sb))
+				return -EIO;
+			return -ENOSPC;
+		}
+		dbh = sb_getblk(sb, new_block);
+		if (!dbh) {
+			beamfs_free_block(sb, new_block, inode);
+			brelse(l1bh);
+			return -EIO;
+		}
+		lock_buffer(dbh);
+		memset(dbh->b_data, 0, BEAMFS_BLOCK_SIZE);
+		/*
+		 * Stamp the DATA_CSUM descriptor on the freshly allocated data
+		 * block. An all-zero block is a valid RS codeword by linearity,
+		 * so decode accepts it, but the descriptor would stay 0x00 and
+		 * the read path would have nothing to verify against. Before
+		 * the type byte was made fail-closed that meant silent
+		 * acceptance; afterwards it means a legitimate newly allocated
+		 * block is rejected. Observed 2026-08-18: iblocks 0..5 of a
+		 * test file logged "bad descriptor type=0x00" on five runs out
+		 * of six, because allocation writes the block here while the
+		 * only other stamp sites are writeback and
+		 * zero_tail_block, neither of which runs for a block that is
+		 * allocated but not yet written through the folio path. The
+		 * payload is the zeroed block itself. Indirect blocks carry no
+		 * DATA_CSUM descriptor and are deliberately left untouched.
+		 */
+		beamfs_inline_stamp_tail_pad(BEAMFS_SB(sb), (u8 *)dbh->b_data,
+					     (const u8 *)dbh->b_data,
+					     (unsigned long long)inode->i_ino, iblock_logical);
+		set_buffer_uptodate(dbh);
+		unlock_buffer(dbh);
+		/*
+		 * A data block carries sixteen RS codewords, not indirect
+		 * parity.
+		 *
+		 * ind_parity_update files a CRC for this block number in
+		 * the separate parity region that covers indirect blocks.
+		 * A newly allocated data block was being registered there,
+		 * and its own sixteen codewords were left as the zeros
+		 * memset put down -- correct for a zero block, wrong the
+		 * moment anything is written into it and the parity is not
+		 * recomputed.
+		 *
+		 * The sweep found exactly that: subblocks holding data,
+		 * uncorrectable; subblocks still zero, fine. Encoding here
+		 * makes a fresh block valid on its own terms from the
+		 * start.
+		 */
+		{
+			int _e = beamfs_seal_data_block(sb, (u8 *)dbh->b_data);
+
+			if (_e < 0)
+				pr_err_ratelimited("beamfs/inline: encode of new data block %llu failed: %d\n",
+						   (unsigned long long)new_block,
+						   _e);
+		}
+		mark_buffer_dirty(dbh);
+
+		/*
+		 * Under the buffer lock, like ext2 splicing a branch.
+		 *
+		 * This stores a pointer into a shared indirect block. Without
+		 * the lock the store races the flusher submitting that same
+		 * buffer: the pointer reaches disk half-written, or a
+		 * concurrent installer's store is lost. generic/464 lost
+		 * blocks whose final event was exactly this store into an L1
+		 * shared across inodes, with no free and no truncate after.
+		 * ind_parity_update reads b_data, so it belongs inside the
+		 * lock too.
+		 */
+		lock_buffer(l1bh);
+		trace_beamfs_slot_store(inode->i_sb->s_dev, inode->i_ino, l1bh->b_blocknr,
+					l2_slot, le64_to_cpu(ptrs[l2_slot]),
+					new_block, 2);
+		beamfs_tc_store(sb, inode->i_ino, l1bh->b_blocknr,
+				(u32)l2_slot, le64_to_cpu(ptrs[l2_slot]), new_block,
+			__func__);
+		/* The block, before the pointer that names it. */
+		beamfs_order_before_pointer(dbh);
+		brelse(dbh);
+		ptrs[l2_slot] = cpu_to_le64(new_block);
+		beamfs_ind_parity_update(sb, l1bh, inode);
+		unlock_buffer(l1bh);
+		/*
+		 * Attach the block to the inode and dirty the inode, the
+		 * way ext2_splice_branch ends:
+		 *
+		 *   mmb_mark_buffer_dirty(where->bh,
+		 *                         &EXT2_I(inode)->i_metadata_bhs);
+		 *   inode_set_ctime_current(inode);
+		 *   mark_inode_dirty(inode);
+		 *
+		 * A plain mark_buffer_dirty leaves the block on no inode's
+		 * metadata list, so __writeback_single_inode never flushes
+		 * it: the pointer is in memory, the buffer is dirty, and
+		 * nothing carries it to the disk. The three sites that
+		 * create a fresh indirect block already dirty the inode --
+		 * they change i_indirect -- and these three, installing
+		 * into a block that already exists, did not.
+		 *
+		 * That is the generic/464 leak: 28 blocks allocated by one
+		 * writer into one inode from this site, no free after, and
+		 * the flusher reallocating for the same inode seconds later
+		 * because the tree it read had none of them.
+		 */
+		beamfs_attach_dirty(inode, l1bh);
+		inode_set_ctime_current(inode);
+		mark_inode_dirty(inode);
+		brelse(l1bh);
+
+		if (allocated)
+			*allocated = true;
+		*phys_out = new_block;
+		return 0;
+	}
+
+	if (iblock_logical < BEAMFS_MAX_IBLOCK_TINDIRECT) {
+		/*
+		 * Triple-indirect write path: allocate tindirect block,
+		 * level-1 indirect block, level-2 indirect block, and data
+		 * block in a cascade, each zero-initialized. Allocation order
+		 * minimizes orphaned blocks on crash: data block last.
+		 */
+		u64 tidx, l1_slot, l2_slot, l3_slot;
+		u64 tindirect_blk, l1_blk, l2_blk;
+		struct buffer_head *l1bh = NULL, *l2bh = NULL;
+
+		tidx = iblock_logical - BEAMFS_MAX_IBLOCK_DINDIRECT;
+		l1_slot = tidx / (BEAMFS_INDIRECT_PTRS * BEAMFS_INDIRECT_PTRS);
+		l2_slot = (tidx / BEAMFS_INDIRECT_PTRS) % BEAMFS_INDIRECT_PTRS;
+		l3_slot = tidx % BEAMFS_INDIRECT_PTRS;
+
+		/* --- Stage 1: tindirect block --- */
+		tindirect_blk = le64_to_cpu(fi->i_tindirect);
+		if (!tindirect_blk) {
+			tindirect_blk = beamfs_alloc_block(sb, inode);
+			if (!tindirect_blk) {
+				if (beamfs_failed(sb))
+					return -EIO;
+				return -ENOSPC;
+			}
+			ibh = sb_getblk(sb, tindirect_blk);
+			if (!ibh) {
+				beamfs_free_block(sb, tindirect_blk, inode);
+				return -EIO;
+			}
+			lock_buffer(ibh);
+			beamfs_tc_zeroed(sb, inode->i_ino, ibh->b_blocknr, __func__);
+			memset(ibh->b_data, 0, BEAMFS_BLOCK_SIZE);
+			set_buffer_uptodate(ibh);
+			/*
+			 * Parity taken under the lock, like the install
+			 * sites do.
+			 *
+			 * The block is allocated and visible before its
+			 * pointer is installed a few lines down, so
+			 * another writer can reach it. Computing parity
+			 * after unlock_buffer describes whatever the block
+			 * held at that instant, which need not be what
+			 * reaches the medium: generic/464 writes and
+			 * fsyncs the same files from several tasks and
+			 * produced 194 indirect blocks whose parity was
+			 * written and did not match, seven orphaned blocks
+			 * under each.
+			 */
+			beamfs_ind_parity_update(sb, ibh, inode);
+			unlock_buffer(ibh);
+			/*
+			 * Attach it to the inode as the install sites do.
+			 *
+			 * A fresh indirect block is dirtied here and its first
+			 * pointer installed a few lines further down, and the
+			 * install attaches it. But sb_getblk here and sb_bread
+			 * there need not hand back the same buffer: if this one
+			 * is evicted in between, it goes with nothing written,
+			 * on no inode's list for anyone to flush.
+			 *
+			 * generic/464 loses exactly that. Inode 150 in one
+			 * capture: four pointers installed into indirect block
+			 * 33190, i_indirect written to disk naming it, and 33190
+			 * itself still 0xcd -- never written at all -- so fsck
+			 * finds four blocks marked used that nothing references.
+			 */
+			mmb_mark_buffer_dirty(ibh, &BEAMFS_I(inode)->i_metadata_bhs);
+			/*
+			 * Held, not released and read back.
+			 *
+			 * This released the buffer here and read the same block
+			 * again a few lines down. Between the two it can be
+			 * evicted, and the read then comes from the medium --
+			 * where nothing has been written yet. The block returns
+			 * holding whatever was there before, and every pointer
+			 * installed into it afterwards lands in a block that is
+			 * never written at all.
+			 *
+			 * A frozen generic/464 volume shows the whole thing:
+			 * inode 36's indirect block 16469, named by the inode on
+			 * disk, 0xcd across 464 of its 512 slots, and 273 blocks
+			 * reported used and referenced by nothing.
+			 *
+			 * Attaching it to the inode was meant to close this. It
+			 * does not: the attach makes the buffer flushable, and
+			 * dropping the last reference still lets it go before
+			 * anything flushes it. Holding the reference closes it.
+			 */
+			/* The block, before the pointer that names it. */
+			beamfs_order_before_pointer(ibh);
+			/*
+			 * The inode's own pointer is a slot store too.
+			 *
+			 * parent 0 and level 0, as for the direct array:
+			 * there is no block above an inode's pointer. Without
+			 * it a probe following a block from allocation to its
+			 * tree loses every root indirect block.
+			 */
+			trace_beamfs_slot_store(inode->i_sb->s_dev, inode->i_ino, 0, 0, 0,
+						tindirect_blk, 0);
+			fi->i_tindirect = cpu_to_le64(tindirect_blk);
+			mark_inode_dirty(inode);
+		}
+
+		/* --- Stage 2: level-1 indirect block --- */
+		ibh = sb_bread(sb, tindirect_blk);
+		if (!ibh) {
+			pr_err_ratelimited("beamfs/inline: failed to read tindirect block %llu\n",
+					   (unsigned long long)tindirect_blk);
+			return -EIO;
+		}
+		/*
+		 * Verify before trusting the pointers. Under CRC this turns a
+		 * flipped pointer that lands in range and on an allocated block
+		 * -- the residual left open by the bounds check above -- into a
+		 * clean failure instead of someone else's data. Under RS a copy
+		 * is decoded and what it corrects is journalled, but the
+		 * pointers are read as the medium holds them: a correctable
+		 * flip is reported, not repaired.
+		 */
+		if (beamfs_ind_parity_verify(sb, ibh)) {
+			brelse(ibh);
+			return -EUCLEAN;
+		}
+		ptrs = (__le64 *)ibh->b_data;
+		l1_blk = le64_to_cpu(ptrs[l1_slot]);
+		if (!l1_blk) {
+			l1_blk = beamfs_alloc_block(sb, inode);
+			if (!l1_blk) {
+				brelse(ibh);
+				if (beamfs_failed(sb))
+					return -EIO;
+				return -ENOSPC;
+			}
+			l1bh = sb_getblk(sb, l1_blk);
+			if (!l1bh) {
+				beamfs_free_block(sb, l1_blk, inode);
+				brelse(ibh);
+				return -EIO;
+			}
+			lock_buffer(l1bh);
+			beamfs_tc_zeroed(sb, inode->i_ino, l1bh->b_blocknr, __func__);
+			memset(l1bh->b_data, 0, BEAMFS_BLOCK_SIZE);
+			set_buffer_uptodate(l1bh);
+			unlock_buffer(l1bh);
+			beamfs_ind_parity_update(sb, l1bh, inode);
+			/*
+			 * Attach it to the inode as the install sites do.
+			 *
+			 * A fresh indirect block is dirtied here and its first
+			 * pointer installed a few lines further down, and the
+			 * install attaches it. But sb_getblk here and sb_bread
+			 * there need not hand back the same buffer: if this one
+			 * is evicted in between, it goes with nothing written,
+			 * on no inode's list for anyone to flush.
+			 *
+			 * generic/464 loses exactly that. Inode 150 in one
+			 * capture: four pointers installed into indirect block
+			 * 33190, i_indirect written to disk naming it, and 33190
+			 * itself still 0xcd -- never written at all -- so fsck
+			 * finds four blocks marked used that nothing references.
+			 */
+			mmb_mark_buffer_dirty(l1bh, &BEAMFS_I(inode)->i_metadata_bhs);
+			/*
+			 * And the inode, so the list gets flushed.
+			 *
+			 * mmb_mark_buffer_dirty puts the buffer on the inode's
+			 * metadata list, and mmb_sync empties that list -- from
+			 * write_inode, which the VFS calls only for an inode it
+			 * believes is dirty. Installing a pointer into a parent block
+			 * changes no field of the inode, so nothing marked it, and
+			 * both buffers stayed in memory with the pointer in them.
+			 *
+			 * generic/013 loses fourteen blocks that way: allocated,
+			 * placed in a slot, and the block holding the slot never
+			 * written -- "indirect block N has no parity written yet".
+			 */
+			mark_inode_dirty(inode);
+			/*
+			 * Held, not released and read back.
+			 *
+			 * This released the buffer here and read the same block
+			 * again a few lines down. Between the two it can be
+			 * evicted, and the read then comes from the medium --
+			 * where nothing has been written yet. The block returns
+			 * holding whatever was there before, and every pointer
+			 * installed into it afterwards lands in a block that is
+			 * never written at all.
+			 *
+			 * A frozen generic/464 volume shows the whole thing:
+			 * inode 36's indirect block 16469, named by the inode on
+			 * disk, 0xcd across 464 of its 512 slots, and 273 blocks
+			 * reported used and referenced by nothing.
+			 *
+			 * Attaching it to the inode was meant to close this. It
+			 * does not: the attach makes the buffer flushable, and
+			 * dropping the last reference still lets it go before
+			 * anything flushes it. Holding the reference closes it.
+			 */
+			/*
+			 * Traced like every other slot install.
+			 *
+			 * Three of the ten allocation sites called tc_store
+			 * and not this, so a probe pairing allocations with
+			 * stores counted every L1 and L2 indirect block as an
+			 * allocation that went nowhere: 4126 of them in one
+			 * generic/476, against the one block fsck found
+			 * leaked.
+			 */
+			/*
+			 * Under the buffer lock, like the data installs above.
+			 *
+			 * This stores a pointer into a shared indirect block. Without
+			 * the lock the store races the flusher submitting that same
+			 * buffer: the pointer reaches disk half-written, or a
+			 * concurrent installer's store is lost. treecheck caught it
+			 * from wb_workfn -- LOST POINTER, held N, read as 0 -- and the
+			 * child block then has no parity written for it and its whole
+			 * subtree is unreachable. The three data installs took this
+			 * lock; the three indirect installs did not.
+			 * ind_parity_update reads b_data, so it belongs inside too.
+			 */
+			lock_buffer(ibh);
+			trace_beamfs_slot_store(inode->i_sb->s_dev, inode->i_ino, ibh->b_blocknr,
+						l1_slot, le64_to_cpu(ptrs[l1_slot]),
+						l1_blk, 2);
+			beamfs_tc_store(sb, inode->i_ino, ibh->b_blocknr,
+					(u32)l1_slot, le64_to_cpu(ptrs[l1_slot]), l1_blk,
+				__func__);
+			/* The block, before the pointer that names it. */
+			beamfs_order_before_pointer(l1bh);
+			ptrs[l1_slot] = cpu_to_le64(l1_blk);
+			beamfs_ind_parity_update(sb, ibh, inode);
+			unlock_buffer(ibh);
+			/* Splicing a child into its parent is an install like
+			 * any other: the parent goes on the inode's list too,
+			 * or it is dirty on nobody's.
+			 */
+			beamfs_attach_dirty(inode, ibh);
+			/*
+			 * And the inode, so the list gets flushed.
+			 *
+			 * mmb_mark_buffer_dirty puts the buffer on the inode's
+			 * metadata list, and mmb_sync empties that list -- from
+			 * write_inode, which the VFS calls only for an inode it
+			 * believes is dirty. Installing a pointer into a parent block
+			 * changes no field of the inode, so nothing marked it, and
+			 * both buffers stayed in memory with the pointer in them.
+			 *
+			 * generic/013 loses fourteen blocks that way: allocated,
+			 * placed in a slot, and the block holding the slot never
+			 * written -- "indirect block N has no parity written yet".
+			 */
+			mark_inode_dirty(inode);
+		}
+		brelse(ibh);
+
+		/* --- Stage 3: level-2 indirect block --- */
+		/* Already held when this call created it. */
+		if (!l1bh)
+			l1bh = sb_bread(sb, l1_blk);
+		if (!l1bh) {
+			pr_err_ratelimited("beamfs/inline: failed to read tindirect L1 block %llu\n",
+					   (unsigned long long)l1_blk);
+			return -EIO;
+		}
+		/*
+		 * Verify before trusting the pointers. Under CRC this turns a
+		 * flipped pointer that lands in range and on an allocated block
+		 * -- the residual left open by the bounds check above -- into a
+		 * clean failure instead of someone else's data. Under RS a copy
+		 * is decoded and what it corrects is journalled, but the
+		 * pointers are read as the medium holds them: a correctable
+		 * flip is reported, not repaired.
+		 */
+		if (beamfs_ind_parity_verify(sb, l1bh)) {
+			brelse(l1bh);
+			return -EUCLEAN;
+		}
+		ptrs = (__le64 *)l1bh->b_data;
+		l2_blk = le64_to_cpu(ptrs[l2_slot]);
+		if (!l2_blk) {
+			l2_blk = beamfs_alloc_block(sb, inode);
+			if (!l2_blk) {
+				brelse(l1bh);
+				if (beamfs_failed(sb))
+					return -EIO;
+				return -ENOSPC;
+			}
+			l2bh = sb_getblk(sb, l2_blk);
+			if (!l2bh) {
+				beamfs_free_block(sb, l2_blk, inode);
+				brelse(l1bh);
+				return -EIO;
+			}
+			lock_buffer(l2bh);
+			beamfs_tc_zeroed(sb, inode->i_ino, l2bh->b_blocknr, __func__);
+			memset(l2bh->b_data, 0, BEAMFS_BLOCK_SIZE);
+			set_buffer_uptodate(l2bh);
+			unlock_buffer(l2bh);
+			beamfs_ind_parity_update(sb, l2bh, inode);
+			/*
+			 * Attach it to the inode as the install sites do.
+			 *
+			 * A fresh indirect block is dirtied here and its first
+			 * pointer installed a few lines further down, and the
+			 * install attaches it. But sb_getblk here and sb_bread
+			 * there need not hand back the same buffer: if this one
+			 * is evicted in between, it goes with nothing written,
+			 * on no inode's list for anyone to flush.
+			 *
+			 * generic/464 loses exactly that. Inode 150 in one
+			 * capture: four pointers installed into indirect block
+			 * 33190, i_indirect written to disk naming it, and 33190
+			 * itself still 0xcd -- never written at all -- so fsck
+			 * finds four blocks marked used that nothing references.
+			 */
+			mmb_mark_buffer_dirty(l2bh, &BEAMFS_I(inode)->i_metadata_bhs);
+			/*
+			 * And the inode, so the list gets flushed.
+			 *
+			 * mmb_mark_buffer_dirty puts the buffer on the inode's
+			 * metadata list, and mmb_sync empties that list -- from
+			 * write_inode, which the VFS calls only for an inode it
+			 * believes is dirty. Installing a pointer into a parent block
+			 * changes no field of the inode, so nothing marked it, and
+			 * both buffers stayed in memory with the pointer in them.
+			 *
+			 * generic/013 loses fourteen blocks that way: allocated,
+			 * placed in a slot, and the block holding the slot never
+			 * written -- "indirect block N has no parity written yet".
+			 */
+			mark_inode_dirty(inode);
+			/*
+			 * Held, not released and read back.
+			 *
+			 * This released the buffer here and read the same block
+			 * again a few lines down. Between the two it can be
+			 * evicted, and the read then comes from the medium --
+			 * where nothing has been written yet. The block returns
+			 * holding whatever was there before, and every pointer
+			 * installed into it afterwards lands in a block that is
+			 * never written at all.
+			 *
+			 * A frozen generic/464 volume shows the whole thing:
+			 * inode 36's indirect block 16469, named by the inode on
+			 * disk, 0xcd across 464 of its 512 slots, and 273 blocks
+			 * reported used and referenced by nothing.
+			 *
+			 * Attaching it to the inode was meant to close this. It
+			 * does not: the attach makes the buffer flushable, and
+			 * dropping the last reference still lets it go before
+			 * anything flushes it. Holding the reference closes it.
+			 */
+			/*
+			 * Traced like every other slot install.
+			 *
+			 * Three of the ten allocation sites called tc_store
+			 * and not this, so a probe pairing allocations with
+			 * stores counted every L1 and L2 indirect block as an
+			 * allocation that went nowhere: 4126 of them in one
+			 * generic/476, against the one block fsck found
+			 * leaked.
+			 */
+			/*
+			 * Under the buffer lock, like the data installs above.
+			 *
+			 * This stores a pointer into a shared indirect block. Without
+			 * the lock the store races the flusher submitting that same
+			 * buffer: the pointer reaches disk half-written, or a
+			 * concurrent installer's store is lost. treecheck caught it
+			 * from wb_workfn -- LOST POINTER, held N, read as 0 -- and the
+			 * child block then has no parity written for it and its whole
+			 * subtree is unreachable. The three data installs took this
+			 * lock; the three indirect installs did not.
+			 * ind_parity_update reads b_data, so it belongs inside too.
+			 */
+			lock_buffer(l1bh);
+			trace_beamfs_slot_store(inode->i_sb->s_dev, inode->i_ino, l1bh->b_blocknr,
+						l2_slot, le64_to_cpu(ptrs[l2_slot]),
+						l2_blk, 3);
+			beamfs_tc_store(sb, inode->i_ino, l1bh->b_blocknr,
+					(u32)l2_slot, le64_to_cpu(ptrs[l2_slot]), l2_blk,
+				__func__);
+			/* The block, before the pointer that names it. */
+			beamfs_order_before_pointer(l2bh);
+			ptrs[l2_slot] = cpu_to_le64(l2_blk);
+			beamfs_ind_parity_update(sb, l1bh, inode);
+			unlock_buffer(l1bh);
+			/* Splicing a child into its parent is an install like
+			 * any other: the parent goes on the inode's list too,
+			 * or it is dirty on nobody's.
+			 */
+			beamfs_attach_dirty(inode, l1bh);
+			/*
+			 * And the inode, so the list gets flushed.
+			 *
+			 * mmb_mark_buffer_dirty puts the buffer on the inode's
+			 * metadata list, and mmb_sync empties that list -- from
+			 * write_inode, which the VFS calls only for an inode it
+			 * believes is dirty. Installing a pointer into a parent block
+			 * changes no field of the inode, so nothing marked it, and
+			 * both buffers stayed in memory with the pointer in them.
+			 *
+			 * generic/013 loses fourteen blocks that way: allocated,
+			 * placed in a slot, and the block holding the slot never
+			 * written -- "indirect block N has no parity written yet".
+			 */
+			mark_inode_dirty(inode);
+		}
+		brelse(l1bh);
+
+		/* --- Stage 4: data block --- */
+		/* Already held when this call created it. */
+		if (!l2bh)
+			l2bh = sb_bread(sb, l2_blk);
+		if (!l2bh) {
+			pr_err_ratelimited("beamfs/inline: failed to read tindirect L2 block %llu\n",
+					   (unsigned long long)l2_blk);
+			return -EIO;
+		}
+		/*
+		 * Verify before trusting the pointers. Under CRC this turns a
+		 * flipped pointer that lands in range and on an allocated block
+		 * -- the residual left open by the bounds check above -- into a
+		 * clean failure instead of someone else's data. Under RS a copy
+		 * is decoded and what it corrects is journalled, but the
+		 * pointers are read as the medium holds them: a correctable
+		 * flip is reported, not repaired.
+		 */
+		if (beamfs_ind_parity_verify(sb, l2bh)) {
+			brelse(l2bh);
+			return -EUCLEAN;
+		}
+		ptrs = (__le64 *)l2bh->b_data;
+		phys = le64_to_cpu(ptrs[l3_slot]);
+		if (phys) {
+			brelse(l2bh);
+			*phys_out = phys;
+			return 0;
+		}
+
+		new_block = beamfs_alloc_block(sb, inode);
+		if (!new_block) {
+			brelse(l2bh);
+			if (beamfs_failed(sb))
+				return -EIO;
+			return -ENOSPC;
+		}
+		dbh = sb_getblk(sb, new_block);
+		if (!dbh) {
+			beamfs_free_block(sb, new_block, inode);
+			brelse(l2bh);
+			return -EIO;
+		}
+		lock_buffer(dbh);
+		memset(dbh->b_data, 0, BEAMFS_BLOCK_SIZE);
+		/*
+		 * Stamp the DATA_CSUM descriptor on the freshly allocated data
+		 * block. An all-zero block is a valid RS codeword by linearity,
+		 * so decode accepts it, but the descriptor would stay 0x00 and
+		 * the read path would have nothing to verify against. Before
+		 * the type byte was made fail-closed that meant silent
+		 * acceptance; afterwards it means a legitimate newly allocated
+		 * block is rejected. Observed 2026-08-18: iblocks 0..5 of a
+		 * test file logged "bad descriptor type=0x00" on five runs out
+		 * of six, because allocation writes the block here while the
+		 * only other stamp sites are writeback and
+		 * zero_tail_block, neither of which runs for a block that is
+		 * allocated but not yet written through the folio path. The
+		 * payload is the zeroed block itself. Indirect blocks carry no
+		 * DATA_CSUM descriptor and are deliberately left untouched.
+		 */
+		beamfs_inline_stamp_tail_pad(BEAMFS_SB(sb), (u8 *)dbh->b_data,
+					     (const u8 *)dbh->b_data,
+					     (unsigned long long)inode->i_ino, iblock_logical);
+		set_buffer_uptodate(dbh);
+		unlock_buffer(dbh);
+		/*
+		 * A data block carries sixteen RS codewords, not indirect
+		 * parity.
+		 *
+		 * ind_parity_update files a CRC for this block number in
+		 * the separate parity region that covers indirect blocks.
+		 * A newly allocated data block was being registered there,
+		 * and its own sixteen codewords were left as the zeros
+		 * memset put down -- correct for a zero block, wrong the
+		 * moment anything is written into it and the parity is not
+		 * recomputed.
+		 *
+		 * The sweep found exactly that: subblocks holding data,
+		 * uncorrectable; subblocks still zero, fine. Encoding here
+		 * makes a fresh block valid on its own terms from the
+		 * start.
+		 */
+		{
+			int _e = beamfs_seal_data_block(sb, (u8 *)dbh->b_data);
+
+			if (_e < 0)
+				pr_err_ratelimited("beamfs/inline: encode of new data block %llu failed: %d\n",
+						   (unsigned long long)new_block,
+						   _e);
+		}
+		mark_buffer_dirty(dbh);
+
+		/*
+		 * Under the buffer lock, like ext2 splicing a branch.
+		 *
+		 * This stores a pointer into a shared indirect block. Without
+		 * the lock the store races the flusher submitting that same
+		 * buffer: the pointer reaches disk half-written, or a
+		 * concurrent installer's store is lost. generic/464 lost
+		 * blocks whose final event was exactly this store into an L1
+		 * shared across inodes, with no free and no truncate after.
+		 * ind_parity_update reads b_data, so it belongs inside the
+		 * lock too.
+		 */
+		lock_buffer(l2bh);
+		trace_beamfs_slot_store(inode->i_sb->s_dev, inode->i_ino, l2bh->b_blocknr,
+					l3_slot, le64_to_cpu(ptrs[l3_slot]),
+					new_block, 3);
+		beamfs_tc_store(sb, inode->i_ino, l2bh->b_blocknr,
+				(u32)l3_slot, le64_to_cpu(ptrs[l3_slot]), new_block,
+			__func__);
+		/* The block, before the pointer that names it. */
+		beamfs_order_before_pointer(dbh);
+		brelse(dbh);
+		ptrs[l3_slot] = cpu_to_le64(new_block);
+		beamfs_ind_parity_update(sb, l2bh, inode);
+		unlock_buffer(l2bh);
+		/*
+		 * Attach the block to the inode and dirty the inode, the
+		 * way ext2_splice_branch ends:
+		 *
+		 *   mmb_mark_buffer_dirty(where->bh,
+		 *                         &EXT2_I(inode)->i_metadata_bhs);
+		 *   inode_set_ctime_current(inode);
+		 *   mark_inode_dirty(inode);
+		 *
+		 * A plain mark_buffer_dirty leaves the block on no inode's
+		 * metadata list, so __writeback_single_inode never flushes
+		 * it: the pointer is in memory, the buffer is dirty, and
+		 * nothing carries it to the disk. The three sites that
+		 * create a fresh indirect block already dirty the inode --
+		 * they change i_indirect -- and these three, installing
+		 * into a block that already exists, did not.
+		 *
+		 * That is the generic/464 leak: 28 blocks allocated by one
+		 * writer into one inode from this site, no free after, and
+		 * the flusher reallocating for the same inode seconds later
+		 * because the tree it read had none of them.
+		 */
+		beamfs_attach_dirty(inode, l2bh);
+		inode_set_ctime_current(inode);
+		mark_inode_dirty(inode);
+		brelse(l2bh);
+
+		if (allocated)
+			*allocated = true;
+		*phys_out = new_block;
+		return 0;
+	}
+
+	pr_err_ratelimited("beamfs/inline: iblock %llu beyond tindirect capacity (write)\n",
+			   (unsigned long long)iblock_logical);
+	return -EOPNOTSUPP;
+}
+
-- 
2.55.0

