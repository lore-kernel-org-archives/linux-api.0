Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E6A4477FD
	for <linux-api@vger.kernel.org>; Mon, 19 Oct 2026 04:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792383503; cv=none; b=Y0tR1cJPIVW7Ln9puQyr8Pz89MELaDkEZ3WYXgXwMX+D2tm7fFCc8iIvYRu69U/6aT5k3xU5/nguKEOLbVrVJpJ1Zx6Cib9xn11/HrhlQTMh3eulcBIUeq+gH7v5mD5Fc80wuEY/mCCrDQfsMiebe/P7B6Z9ohTSLovWqpls1WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792383503; c=relaxed/simple;
	bh=jfkFUDYZVNkVhxSOUjVLQm9+q9tiLoTfxj4ANpJxD7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Omja0tRSylyQnsUnp+hbMIwF11QGGJgK5RFQYXBk6dohVET9mUiBwUUC4Hivd5Q/CksrlkFWYHOAt3W1DPmOysjK877IePOH6ZWHs0YfRXd74PKoLmQ1bBVWzh4zXYvzcrcmBbIf8QTu2xe0oUPW56XqV10hFD7RnlIJ2RzQ5xQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hackers.camp; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hackers.camp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4887dbe4f2dso206045f8f.3
        for <linux-api@vger.kernel.org>; Sun, 18 Oct 2026 21:18:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792383494; x=1792988294;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OWrV6R/dIBP3SZfB8NPrDLE1kEcKxtlJi5peiI/zflI=;
        b=X4XJ0Kt3BWqD1k/2mghi1F6z1Aj/ymUv1QTl+o563rL65Uif7doIw+mlze94I0uUgP
         vLlcFUQdo9bLEh1YB6/B0bJeJaIDR777TEJ8LqhwrsRCJvrfyVO/1LJHpbpjIFlvadCR
         Qce8FVp3VzCujukcCuTyoUmXOOqE8sOxPRGC1CUZ5YqRZjNMn6wdpgMYhEarDiPueH3s
         +PYNYo7V36dG3gS2+2VVNJkvDIv8v67BiTO522bpmfWK1jMWxJjy44c4H/14QVfWmqAr
         eeG4V2H9Q60Uru4GQ109y7s7N7uLdl/5hpTljM27YWnCWP2jGb0WQI0bQuyhLm9TXqlf
         b3sA==
X-Forwarded-Encrypted: i=1; AKwUvBys7BFpwCk8h/6xtj7wxycOuE6ARUv6C2r3FJuyROySwAPwk2OJpKWAU7FEcmY072StRMw6J998sI4=@vger.kernel.org
X-Gm-Message-State: AFq9FYJJ+uGisDs3Tk1rBvHvJvA1uWzv7hA/j+UU91QI7wYRYJD9ZqAL
	cZShnJ7Zjz3S0EWLeLwh+o+CIzYmK6LOgbdlAc+NnT9iSM8FRVc54j8NeaBnwshziz4=
X-Gm-Gg: AYBFou0AH8qBn9pKpnou2w/CIteHiSx20gRG7pBJEcQ7q7zpLEZXzDak3leckeh26cO
	d2Qa6qj61823ZxcqJqHQvspP0DdE+nHHDL9ipcNbB9Tafy58pU1B5uehjjBqIF/QW6yvR4GYzbm
	41fOPp5LqoiHDBbmtLs7DQOPyeI3EEzaTle0/+3L2f8meqVXhskKK3XHnn6bt7/ihAdnXMX2NlQ
	mqDOmnpjQGEZK3F4iDXDtEoEwRNJA4zZrI1k6UCvJxz3fbAOQUdao7ldlX+6bFmqy0BKR7ZRbe5
	a8/+PjMVs3Sow06OFxyx8i+xeZg3uhZFxjjg2s/Y83BW+jT6tg93gPzgJUU34GuM13R6PZPfU6V
	MVRVstYH1Xx0WR1VkjxCnbf3oKN/I5IxoK9wZrAnhBeOUKTuM+io3Xw4yg15YECHmJilS1VQzgM
	cvLZJWLpQeE8u2QPa7PRF/RjuL4JhFAmwG/PRvhrZSgV1Sf+TVCgCi+WY8BAQ9amqP3eVQ7WN6L
	lcZUmKLUY9rGBYRqp6/M9lsHXkt7Ld/kvto
X-Received: by 2002:a05:6000:2409:b0:48d:ed98:2a53 with SMTP id ffacd0b85a97d-48e07f9ade0mr12119958f8f.4.1792383493421;
        Sun, 18 Oct 2026 21:18:13 -0700 (PDT)
Received: from spartian.home ([2a01:cb1c:76:ed00:602f:c5f4:d108:b925])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd500e75sm20090449f8f.42.2026.10.18.21.18.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 21:18:12 -0700 (PDT)
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
Subject: [RFC PATCH 14/18] beamfs: inline data path 4/4, write side
Date: Mon, 19 Oct 2026 06:17:24 +0200
Message-ID: <20261019041728.327785-15-aurelien@hackers.camp>
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

This part: writeback, ->write_iter, fsync, truncation, setattr,
fiemap, and the address_space, file and inode operation tables.

Assisted-by: LLM
Signed-off-by: Aurelien DESBRIERES <aurelien@hackers.camp>
---
 fs/beamfs/file_inline.c | 1186 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 1186 insertions(+)

diff --git a/fs/beamfs/file_inline.c b/fs/beamfs/file_inline.c
index 2ea7e7e10168..cdb1dc75dc86 100644
--- a/fs/beamfs/file_inline.c
+++ b/fs/beamfs/file_inline.c
@@ -3714,3 +3714,1189 @@ struct beamfs_wb {
 	int                     error;
 };
 
+static void beamfs_wb_folio_done(struct beamfs_wb_folio *o)
+{
+	if (!o)
+		return;
+	if (refcount_dec_and_test(&o->pending)) {
+		if (!o->abandoned)
+			iomap_finish_folio_write(o->inode, o->folio, o->len);
+		kfree(o);
+	}
+}
+
+static void beamfs_wb_end_bio(struct bio *bio)
+{
+	struct beamfs_wb_ioend *io = bio->bi_private;
+	struct beamfs_sb_info *sbi = BEAMFS_SB(io->sb);
+	bool failed = bio->bi_status != BLK_STS_OK;
+	unsigned int i;
+
+	for (i = 0; i < io->n; i++) {
+		struct beamfs_wb_block *blk = &io->blk[i];
+
+		if (failed) {
+			if (blk->owner)
+				mapping_set_error(blk->owner->inode->i_mapping, -EIO);
+			if (blk->owner2)
+				mapping_set_error(blk->owner2->inode->i_mapping, -EIO);
+		}
+		mempool_free(blk->page, sbi->s_wb_pages);
+		beamfs_wb_folio_done(blk->owner);
+		beamfs_wb_folio_done(blk->owner2);
+	}
+	bio_put(bio);
+	kfree(io);
+}
+
+static void beamfs_wb_submit_ioend(struct beamfs_wb *wb)
+{
+	struct beamfs_wb_ioend *io = wb->ioend;
+
+	if (!io)
+		return;
+	wb->ioend = NULL;
+	submit_bio(io->bio);
+}
+
+/*
+ * A page for one encoded block.
+ *
+ * Without waiting first: the pool is shared by every flusher thread,
+ * and a thread that waits on it while holding an unsubmitted bio full
+ * of pool pages is waiting for pages that only its own submission can
+ * return. So: try without waiting, then submit what is held, then
+ * wait -- what is held is on its way back by then.
+ */
+static struct page *beamfs_wb_page(struct beamfs_wb *wb)
+{
+	struct beamfs_sb_info *sbi = BEAMFS_SB(wb->sb);
+	struct page *page;
+
+	page = mempool_alloc(sbi->s_wb_pages, GFP_NOWAIT | __GFP_NOWARN);
+	if (page)
+		return page;
+	beamfs_wb_submit_ioend(wb);
+	return mempool_alloc(sbi->s_wb_pages, GFP_NOFS);
+}
+
+/*
+ * Bring the buffer cache's alias of @phys, if there is one, to the
+ * bytes the device is about to receive, and make it clean.
+ *
+ * The lock waits for a write of the alias already in flight -- the
+ * zero image of a fresh block, most often -- so that write lands
+ * before ours, whatever the device does with two requests for the
+ * same sectors. Nothing else is held here.
+ */
+static void beamfs_wb_sync_alias(struct super_block *sb, u64 phys,
+				 const void *block)
+{
+	struct buffer_head *bh = sb_find_get_block(sb, phys);
+
+	if (!bh)
+		return;
+	lock_buffer(bh);
+	memcpy(bh->b_data, block, BEAMFS_BLOCK_SIZE);
+	set_buffer_uptodate(bh);
+	clear_buffer_dirty(bh);
+	unlock_buffer(bh);
+	brelse(bh);
+}
+
+/*
+ * Encode @payload into a fresh page and queue the page for @phys.
+ *
+ * Contiguous with the bio being built: appended. Otherwise, or when
+ * the bio is full, that bio goes and a new one starts here.
+ */
+static int beamfs_wb_queue(struct beamfs_wb *wb, struct inode *inode,
+			   u64 b, u64 phys, const u8 *payload,
+			   struct beamfs_wb_folio *owner,
+			   struct beamfs_wb_folio *owner2,
+			   struct writeback_control *wbc)
+{
+	struct super_block *sb = wb->sb;
+	sector_t sector = (sector_t)phys << (BEAMFS_BLOCK_SHIFT - SECTOR_SHIFT);
+	struct beamfs_wb_ioend *io;
+	struct page *page;
+	u8 *block;
+	int ret;
+
+	page = beamfs_wb_page(wb);
+	block = page_address(page);
+
+	beamfs_lay_data_payload(sb, block, payload);
+	/*
+	 * The descriptor before the parity. In a capsule it is coded
+	 * data: stamped after the seal, the next read corrected it back
+	 * to what the page held when the parity was computed.
+	 */
+	beamfs_inline_stamp_tail_pad(BEAMFS_SB(sb), block, payload,
+				     inode->i_ino, b);
+	ret = beamfs_seal_data_block(sb, block);
+	if (ret < 0) {
+		pr_err_ratelimited("beamfs/inline: writeback: rs_encode_region failed for block %llu: %d\n",
+				   (unsigned long long)phys, ret);
+		mempool_free(page, BEAMFS_SB(sb)->s_wb_pages);
+		return ret;
+	}
+
+	beamfs_wb_sync_alias(sb, phys, block);
+
+	if (wb->ioend &&
+	    (wb->ioend->n == BEAMFS_WB_MAX_BLOCKS || wb->ioend->next != sector))
+		beamfs_wb_submit_ioend(wb);
+
+	if (!wb->ioend) {
+		io = kzalloc_obj(*io, GFP_NOFS);
+		if (!io) {
+			mempool_free(page, BEAMFS_SB(sb)->s_wb_pages);
+			return -ENOMEM;
+		}
+		io->sb = sb;
+		io->bio = bio_alloc(sb->s_bdev, BEAMFS_WB_MAX_BLOCKS,
+				    REQ_OP_WRITE |
+				    ((wbc && wbc->sync_mode == WB_SYNC_ALL) ?
+				     REQ_SYNC : 0),
+				    GFP_NOFS);
+		io->bio->bi_iter.bi_sector = sector;
+		io->bio->bi_private = io;
+		io->bio->bi_end_io = beamfs_wb_end_bio;
+		io->next = sector;
+		wb->ioend = io;
+	}
+	io = wb->ioend;
+	__bio_add_page(io->bio, page, BEAMFS_BLOCK_SIZE, 0);
+	io->blk[io->n].page   = page;
+	io->blk[io->n].owner  = owner;
+	io->blk[io->n].owner2 = owner2;
+	io->n++;
+	io->next += BEAMFS_BLOCK_SIZE >> SECTOR_SHIFT;
+	return 0;
+}
+
+/*
+ * The payload a block holds now, for the bytes a partial write does
+ * not touch. The buffer cache's alias first, the device otherwise --
+ * not sb_bread, which would create an alias to keep coherent for a
+ * block read once.
+ */
+static int beamfs_wb_read_old(struct super_block *sb, struct inode *inode,
+			      u64 b, u64 phys, u8 *payload)
+{
+	struct buffer_head *bh = sb_find_get_block(sb, phys);
+	u8 *raw = beamfs_scratch_get(sb);
+	int ret;
+
+	if (!raw) {
+		if (bh)
+			brelse(bh);
+		return -ENOMEM;
+	}
+	if (bh && buffer_uptodate(bh)) {
+		lock_buffer(bh);
+		memcpy(raw, bh->b_data, BEAMFS_BLOCK_SIZE);
+		unlock_buffer(bh);
+		brelse(bh);
+	} else {
+		if (bh)
+			brelse(bh);
+		ret = bdev_rw_virt(sb->s_bdev,
+				   (sector_t)phys << (BEAMFS_BLOCK_SHIFT - SECTOR_SHIFT),
+				   raw, BEAMFS_BLOCK_SIZE, REQ_OP_READ);
+		if (ret) {
+			pr_err_ratelimited("beamfs/inline: writeback: read of block %llu for a partial write failed: %d\n",
+					   (unsigned long long)phys, ret);
+			beamfs_scratch_put(sb, raw);
+			return -EIO;
+		}
+	}
+	ret = beamfs_inline_decode_block_into_buf(sb, raw, phys, inode, b,
+						  payload, 0,
+						  BEAMFS_DATA_INLINE_BYTES,
+						  true);
+	beamfs_scratch_put(sb, raw);
+	return ret < 0 ? ret : 0;
+}
+
+/*
+ * The boundary block's continuation did not come: finish it with what
+ * the block holds beyond the bytes written, and queue it.
+ */
+static int beamfs_wb_flush_pending(struct beamfs_wb *wb,
+				   struct writeback_control *wbc)
+{
+	struct beamfs_wb_folio *owner = wb->pend_owner;
+	u8 *old;
+	int ret;
+
+	if (!wb->have_pend)
+		return 0;
+	wb->have_pend = false;
+	wb->pend_owner = NULL;
+
+	old = beamfs_scratch_get(wb->sb);
+	if (!old) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+	ret = beamfs_wb_read_old(wb->sb, wb->pend_inode, wb->pend_b,
+				 wb->pend_phys, old);
+	if (ret == 0) {
+		memcpy(old, wb->pend_payload, wb->pend_filled);
+		ret = beamfs_wb_queue(wb, wb->pend_inode, wb->pend_b,
+				      wb->pend_phys, old, owner, NULL, wbc);
+	}
+	beamfs_scratch_put(wb->sb, old);
+	if (ret == 0)
+		return 0;
+fail:
+	/*
+	 * The block is lost to this pass; the folio it belonged to is
+	 * told, and not finished twice.
+	 */
+	if (owner) {
+		mapping_set_error(owner->inode->i_mapping, ret);
+		beamfs_wb_folio_done(owner);
+	}
+	if (!wb->error)
+		wb->error = ret;
+	return ret;
+}
+
+static struct beamfs_wb *beamfs_wb_get(struct iomap_writepage_ctx *wpc)
+{
+	struct beamfs_wb *wb = wpc->wb_ctx;
+
+	if (wb)
+		return wb;
+	wb = kzalloc_obj(*wb, GFP_NOFS);
+	if (!wb)
+		return NULL;
+	wb->sb = wpc->inode->i_sb;
+	wb->pend_payload = beamfs_scratch_get(wb->sb);
+	if (!wb->pend_payload) {
+		kfree(wb);
+		return NULL;
+	}
+	wpc->wb_ctx = wb;
+	return wb;
+}
+
+/*
+ * Map and encode one folio's range.
+ *
+ * Each slice of the range is one block. A slice that starts the block
+ * and fills it is encoded and queued at once. A slice that starts the
+ * block and stops short is the folio's last: its bytes wait in
+ * wb->pend for the folio that continues it. A slice that starts inside
+ * the block is that continuation when it matches what waits, and a
+ * partial write over an existing block otherwise, which reads the
+ * block first.
+ *
+ * The folio counts one block per slice and is finished when the last
+ * of them completes.
+ */
+static ssize_t beamfs_inline_writeback_range(struct iomap_writepage_ctx *wpc,
+					     struct folio *folio, u64 pos,
+					     unsigned int len, u64 end_pos)
+{
+	struct inode             *inode = wpc->inode;
+	struct super_block       *sb    = inode->i_sb;
+	struct beamfs_inode_info *fi    = BEAMFS_I(inode);
+	u32      payload = beamfs_block_payload(sb);
+	u64      p       = pos;
+	u64      end     = pos + len;
+	struct beamfs_wb       *wb;
+	struct beamfs_wb_folio *owner;
+	u8      *scratch = NULL;
+	unsigned int nslices, queued = 0;
+	int      ret = 0;
+
+	/*
+	 * iomap_writeback_range() adds the return value to
+	 * bytes_submitted only when wpc->iomap.type is not IOMAP_HOLE;
+	 * left zeroed, every folio read as "nothing submitted" and iomap
+	 * ended it itself, once too many.
+	 */
+	wpc->iomap.type   = IOMAP_MAPPED;
+	wpc->iomap.offset = pos;
+	wpc->iomap.length = len;
+	wpc->iomap.bdev   = sb->s_bdev;
+
+	wb = beamfs_wb_get(wpc);
+	if (!wb)
+		return -ENOMEM;
+
+	/* One block per slice: the first block, then whole blocks. */
+	nslices = (u32)(div_u64(end - 1, payload) - div_u64(pos, payload)) + 1;
+
+	owner = kzalloc_obj(*owner, GFP_NOFS);
+	if (!owner)
+		return -ENOMEM;
+	owner->inode = inode;
+	owner->folio = folio;
+	owner->len   = len;
+	refcount_set(&owner->pending, (int)nslices);
+
+	scratch = beamfs_scratch_get(sb);
+	if (!scratch) {
+		kfree(owner);
+		return -ENOMEM;
+	}
+
+	/*
+	 * A boundary block waiting for another folio, or another file,
+	 * is not continued by this one.
+	 */
+	if (wb->have_pend &&
+	    (wb->pend_inode != inode || wb->pend_next_pos != (loff_t)pos)) {
+		ret = beamfs_wb_flush_pending(wb, wpc->wbc);
+		if (ret < 0)
+			goto out;
+	}
+
+	while (p < end) {
+		u64    b            = div_u64(p, payload);
+		u32    slice_offset = (u32)(p - b * payload);
+		u32    slice_length = (u32)min_t(u64, end - p,
+						 payload - slice_offset);
+		size_t folio_off    = offset_in_folio(folio, p);
+		u64    phys         = 0;
+		u8    *src;
+
+		{
+			u64 before = 0;
+
+			mutex_lock(&fi->i_alloc_mutex);
+			(void)beamfs_inline_lookup_phys(inode, b, &before);
+			ret = beamfs_inline_lookup_or_alloc_phys(inode, b,
+								 &phys);
+			mutex_unlock(&fi->i_alloc_mutex);
+			if (ret < 0)
+				break;
+			if (before && phys && before != phys)
+				pr_err("beamfs/leak: ino=%llu iblock=%llu %llu -> %llu\n",
+				       (unsigned long long)inode->i_ino,
+				       (unsigned long long)b,
+				       (unsigned long long)before,
+				       (unsigned long long)phys);
+		}
+		if (!phys) {
+			pr_err_ratelimited("beamfs/inline: writeback: no block for ino=%llu iblock=%llu\n",
+					   (unsigned long long)inode->i_ino,
+					   (unsigned long long)b);
+			ret = -EIO;
+			break;
+		}
+
+		if (slice_offset != 0) {
+			/* The continuation of the block that waits. */
+			if (wb->have_pend && wb->pend_b == b &&
+			    wb->pend_phys == phys &&
+			    wb->pend_filled == slice_offset) {
+				struct beamfs_wb_folio *first = wb->pend_owner;
+
+				src = kmap_local_folio(folio, folio_off);
+				memcpy(wb->pend_payload + slice_offset, src,
+				       slice_length);
+				kunmap_local(src);
+				wb->pend_filled += slice_length;
+				wb->have_pend = false;
+				wb->pend_owner = NULL;
+				if (wb->pend_filled < payload) {
+					/*
+					 * Still short: a block spanning three
+					 * folios, which a 4096-byte folio
+					 * cannot produce. Finished from the
+					 * medium rather than deferred again,
+					 * because a block has two owners here
+					 * and no more.
+					 */
+					ret = beamfs_wb_read_old(sb, inode, b, phys,
+								 scratch);
+					if (ret < 0) {
+						beamfs_wb_folio_done(first);
+						break;
+					}
+					memcpy(scratch, wb->pend_payload,
+					       wb->pend_filled);
+					ret = beamfs_wb_queue(wb, inode, b, phys,
+							      scratch, first, owner,
+							      wpc->wbc);
+				} else {
+					ret = beamfs_wb_queue(wb, inode, b, phys,
+							      wb->pend_payload,
+							      first, owner,
+							      wpc->wbc);
+				}
+				if (ret < 0) {
+					beamfs_wb_folio_done(first);
+					break;
+				}
+				queued++;
+			} else {
+				/* A partial write over an existing block. */
+				if (wb->have_pend) {
+					ret = beamfs_wb_flush_pending(wb, wpc->wbc);
+					if (ret < 0)
+						break;
+				}
+				ret = beamfs_wb_read_old(sb, inode, b, phys, scratch);
+				if (ret < 0)
+					break;
+				src = kmap_local_folio(folio, folio_off);
+				memcpy(scratch + slice_offset, src, slice_length);
+				kunmap_local(src);
+				ret = beamfs_wb_queue(wb, inode, b, phys, scratch,
+						      owner, NULL, wpc->wbc);
+				if (ret < 0)
+					break;
+				queued++;
+			}
+		} else if (slice_length == payload) {
+			/* A whole block: nothing to preserve, nothing to wait for. */
+			if (wb->have_pend) {
+				ret = beamfs_wb_flush_pending(wb, wpc->wbc);
+				if (ret < 0)
+					break;
+			}
+			src = kmap_local_folio(folio, folio_off);
+			memcpy(scratch, src, slice_length);
+			kunmap_local(src);
+			ret = beamfs_wb_queue(wb, inode, b, phys, scratch,
+					      owner, NULL, wpc->wbc);
+			if (ret < 0)
+				break;
+			queued++;
+		} else {
+			/* The folio ends inside this block: wait for the next. */
+			if (wb->have_pend) {
+				ret = beamfs_wb_flush_pending(wb, wpc->wbc);
+				if (ret < 0)
+					break;
+			}
+			src = kmap_local_folio(folio, folio_off);
+			memcpy(wb->pend_payload, src, slice_length);
+			kunmap_local(src);
+			wb->have_pend      = true;
+			wb->pend_phys      = phys;
+			wb->pend_b         = b;
+			wb->pend_filled    = slice_length;
+			wb->pend_next_pos  = (loff_t)(p + slice_length);
+			wb->pend_inode     = inode;
+			wb->pend_owner     = owner;
+			queued++;
+		}
+
+		p += slice_length;
+	}
+
+out:
+	beamfs_scratch_put(sb, scratch);
+
+	if (ret < 0) {
+		/*
+		 * iomap ends this folio itself when the range fails.
+		 * Whatever was queued for it still writes, and must not
+		 * finish the folio a second time: the slices never
+		 * queued are taken off the count, and the owner is
+		 * marked so the last completion frees it and does no
+		 * more.
+		 */
+		owner->abandoned = true;
+		if (nslices > queued &&
+		    refcount_sub_and_test((int)(nslices - queued), &owner->pending))
+			kfree(owner);
+		if (!wb->error)
+			wb->error = ret;
+		return ret;
+	}
+
+	(void)end_pos;
+	return (ssize_t)len;
+}
+
+/*
+ * The end of the pass: the boundary block nobody continued is finished
+ * from what the medium holds, and the bio being built goes.
+ */
+static int beamfs_inline_writeback_submit(struct iomap_writepage_ctx *wpc,
+					  int error)
+{
+	struct beamfs_wb *wb = wpc->wb_ctx;
+	int ret;
+
+	if (!wb)
+		return error;
+	ret = beamfs_wb_flush_pending(wb, wpc->wbc);
+	beamfs_wb_submit_ioend(wb);
+	if (!error)
+		error = ret < 0 ? ret : wb->error;
+	beamfs_scratch_put(wb->sb, wb->pend_payload);
+	kfree(wb);
+	wpc->wb_ctx = NULL;
+	return error;
+}
+
+static const struct iomap_writeback_ops beamfs_inline_writeback_ops = {
+	.writeback_range  = beamfs_inline_writeback_range,
+	.writeback_submit = beamfs_inline_writeback_submit,
+};
+
+/* ------------------------------------------------------------------------- */
+/* writepages                                                                */
+/*                                                                           */
+/* iomap_writepages walks the dirty folios and hands each range to           */
+/* beamfs_inline_writeback_range, which maps and allocates under the         */
+/* per-inode i_alloc_mutex and encodes into bounce pages;                    */
+/* beamfs_inline_writeback_submit ends the pass. See the writeback comment   */
+/* above.                                                                    */
+/* ------------------------------------------------------------------------- */
+static int beamfs_inline_writepages(struct address_space *mapping,
+				    struct writeback_control *wbc)
+{
+	struct iomap_writepage_ctx wpc = {
+		.inode = mapping->host,
+		.wbc   = wbc,
+		.ops   = &beamfs_inline_writeback_ops,
+	};
+
+	return iomap_writepages(&wpc);
+}
+
+/* ------------------------------------------------------------------------- */
+/* write_iter entry point                                                    */
+/* ------------------------------------------------------------------------- */
+static ssize_t beamfs_inline_file_write_iter(struct kiocb *iocb,
+					     struct iov_iter *from)
+{
+	struct inode *inode = file_inode(iocb->ki_filp);
+	loff_t before;
+	ssize_t ret;
+
+	/*
+	 * generic_write_checks first, and it is not optional.
+	 *
+	 * It is what moves ki_pos to i_size when the file was opened
+	 * O_APPEND, and it enforces the rlimit and the s_maxbytes bound
+	 * along the way. Without it every append wrote at whatever
+	 * position the descriptor happened to hold, which for a fresh
+	 * open is zero: three four-byte appends left a four-byte file
+	 * reading CCCC, and xfstests generic/069 reported "maybe corrupt
+	 * O_APPEND" with one file holding twelve megabytes that belonged
+	 * to its siblings.
+	 *
+	 * generic_file_write_iter calls it, which is why filesystems
+	 * built on that never notice. iomap_file_buffered_write sits
+	 * below it and expects the caller to have done the checks --
+	 * xfs_file_write_checks exists for this, and says so in a
+	 * comment: "that assigns ki_pos for O_APPEND".
+	 */
+	/*
+	 * inode_lock, like every other buffered write in the tree.
+	 *
+	 * generic_file_write_iter takes it for ext2; ext4 and XFS take
+	 * it by hand. Without it a truncate -- do_truncate holds
+	 * inode_lock through setattr -- runs while this write is still
+	 * populating the page cache of the same inode: i_size is written
+	 * by both sides in no order, truncate_setsize drops folios this
+	 * write is still creating, and the block tree is freed under a
+	 * mapping iomap_begin has already handed out.
+	 *
+	 * generic/464 makes that the common case: sixteen processes doing
+	 * pwrite -ftc on two hundred files chosen at random.
+	 *
+	 * i_alloc_mutex serialises the tree walks. It does not serialise
+	 * the write against the truncate; that is what the inode lock is
+	 * for.
+	 */
+	inode_lock(inode);
+	ret = generic_write_checks(iocb, from);
+	if (ret <= 0)
+		goto out;
+
+	/*
+	 * The set-user-ID and set-group-ID bits, and the times, before
+	 * the data. generic_file_write_iter does this through
+	 * file_remove_privs; iomap_file_buffered_write sits below it and
+	 * leaves it to the caller, as XFS does in xfs_file_write_checks.
+	 */
+	ret = kiocb_modified(iocb);
+	if (ret)
+		goto out;
+
+	before = i_size_read(inode);
+
+	ret = iomap_file_buffered_write(iocb, from, &beamfs_inline_iomap_ops,
+					&beamfs_inline_write_ops, NULL);
+	if (ret <= 0)
+		goto out;
+
+	/*
+	 * iomap_write_iter() states the division of labour outright:
+	 * "Update the in-memory inode size after copying the data into the
+	 * page cache. It's up to the file system to write the updated size
+	 * to disk." It grows i_size and raises IOMAP_F_SIZE_CHANGED; the
+	 * inode does not reach the medium unless someone here says so.
+	 *
+	 * Returning its result directly meant a write that extended a file
+	 * without a following fsync had the new size in stat and the old
+	 * one on disk. xfstests generic/169: write 5 bytes, fsync, write 5
+	 * more, unmount -- the file comes back 5 bytes long. The first
+	 * half of that test passes only because every write there is
+	 * fsynced.
+	 *
+	 * generic_write_sync last, as fuse does: it honours O_SYNC and
+	 * O_DSYNC on the kiocb, so a caller that asked for durability gets
+	 * it, and one that did not pays nothing.
+	 */
+	if (i_size_read(inode) != before)
+		inode_set_ctime_current(inode);
+	inode_set_mtime_to_ts(inode, current_time(inode));
+	mark_inode_dirty(inode);
+
+out:
+	inode_unlock(inode);
+	/*
+	 * Outside the lock, as ext4 does: it may wait on the device and
+	 * has no business holding the inode while it does.
+	 */
+	if (ret > 0)
+		ret = generic_write_sync(iocb, ret);
+	return ret;
+}
+
+/* ------------------------------------------------------------------------- */
+/* Public ops structures                                                     */
+/* ------------------------------------------------------------------------- */
+
+const struct address_space_operations beamfs_inline_aops = {
+	.read_folio       = beamfs_inline_read_folio,
+	.writepages       = beamfs_inline_writepages,
+	/*
+	 * iomap_dirty_folio, not filemap_dirty_folio.
+	 *
+	 * filemap's marks the folio dirty and stops there. iomap's also
+	 * allocates the iomap_folio_state and calls
+	 * iomap_set_range_dirty, which is what iomap_find_dirty_range
+	 * later reads to decide what to write back.
+	 *
+	 * Without it the folio is dirty to the VFS and clean to iomap:
+	 * iomap_writeback_folio calls folio_start_writeback, finds no
+	 * dirty range to hand to ->writeback_range, submits nothing --
+	 * and nothing ever ends the writeback it just started. The folio
+	 * stays that way for the life of the mount, and the next process
+	 * to touch the file waits in folio_wait_writeback forever.
+	 *
+	 * Found through xfstests: rm sat in truncate_inode_partial_folio
+	 * under beamfs_evict_inode for nine hours while the tracing said
+	 * every folio that reached writeback_range was accounted for --
+	 * correctly, because the one that mattered never got there.
+	 *
+	 * gfs2 declares the same, which is the shortest way to see it.
+	 */
+	.dirty_folio      = iomap_dirty_folio,
+	/* Required once the folio state is iomap's: the kernel warns at
+	 * compaction time without it.
+	 */
+	.migrate_folio    = filemap_migrate_folio,
+	.release_folio    = iomap_release_folio,
+	.invalidate_folio = iomap_invalidate_folio,
+};
+
+/*
+ * Same as the non-inline path: generic_file_fsync() went away with
+ * sync_mapping_buffers() and i_private_list. Metadata buffer_heads
+ * owned by the inode are flushed through mmb_fsync().
+ */
+static int beamfs_inline_fsync(struct file *file, loff_t start, loff_t end,
+			       int datasync)
+{
+	return simple_fsync(file, start, end, datasync);
+}
+
+const struct file_operations beamfs_inline_file_operations = {
+	.llseek      = generic_file_llseek,
+	.read_iter   = generic_file_read_iter,
+	.write_iter  = beamfs_inline_file_write_iter,
+	.mmap        = generic_file_mmap,
+	.fsync       = beamfs_inline_fsync,
+	.splice_read = filemap_splice_read,
+	/*
+	 * splice_write is what copy_file_range falls back to.
+	 *
+	 * The VFS has no .copy_file_range here and no .remap_file_range,
+	 * so vfs_copy_file_range reaches do_splice_direct -- which needs
+	 * an output side. Without it the syscall returns EINVAL, and fsx
+	 * stops on its first COPY operation, taking generic/075 with it.
+	 *
+	 * iter_file_splice_write goes through write_iter, so the RS
+	 * encode and the append handling apply to spliced data exactly as
+	 * they do to written data. ext2 declares the same pair, which is
+	 * why it never had this gap.
+	 */
+	.splice_write = iter_file_splice_write,
+};
+
+/* ------------------------------------------------------------------------- */
+/* Truncate support                                                          */
+/*                                                                           */
+/* The allocator reaches every level: lookup_or_alloc_phys has allocation    */
+/* sites for direct, indirect, double and triple indirect, so the write      */
+/* path is not capped at 524 blocks. Measured 2026-08-20 on a freshly        */
+/* formatted volume: a 64 MiB file, about 17500 blocks and well into double  */
+/* indirect, was written and read back intact at 24 MB/s with no             */
+/* EOPNOTSUPP. Capacity per file is BEAMFS_MAX_IBLOCK_TINDIRECT blocks of    */
+/* payload: about 479 GiB at 3824 bytes per block, 477 GiB at 3808.          */
+/*                                                                           */
+/* beamfs_inline_free_blocks_from walks the same four levels, so a           */
+/* truncate frees everything past the new end of the file.                   */
+/* ------------------------------------------------------------------------- */
+
+/*
+ * beamfs_inline_free_blocks_from - free disk blocks at logical iblock
+ *                                  >= b_first_freed.
+ *
+ * Mirror of beamfs_free_data_blocks (super.c) restricted to a starting
+ * logical block, used for truncate-down and by iomap_end to give back
+ * what a short write allocated. Walks direct[b_first_freed..N-1], then
+ * the single indirect block, then the double and triple indirect trees
+ * through beamfs_free_ind_range. If b_first_freed <= BEAMFS_DIRECT_BLOCKS
+ * the indirect block itself is freed; otherwise individual indirect slots
+ * are zeroed and the indirect block is kept.
+ *
+ * Callers hold inode_lock and i_alloc_mutex: this rewrites the tree the
+ * allocator walks.
+ */
+static void beamfs_inline_free_blocks_from(struct inode *inode,
+					   u64 b_first_freed)
+{
+	struct beamfs_inode_info *fi = BEAMFS_I(inode);
+	struct super_block       *sb = inode->i_sb;
+	unsigned int              i;
+
+	/* --- Direct blocks --- */
+	for (i = b_first_freed; i < BEAMFS_DIRECT_BLOCKS; i++) {
+		u64 blk = le64_to_cpu(fi->i_direct[i]);
+
+		if (blk) {
+			beamfs_free_block(sb, blk, inode);
+			fi->i_direct[i] = 0;
+		}
+	}
+
+	/* --- Single indirect block --- */
+	if (fi->i_indirect) {
+		u64                 indirect_blk = le64_to_cpu(fi->i_indirect);
+		struct buffer_head *ibh = NULL;
+		__le64             *ptrs;
+		u64                 nptrs = BEAMFS_INDIRECT_PTRS;
+		u64                 slot_first;
+		u64                 j;
+
+		ibh = sb_bread(sb, indirect_blk);
+		if (!ibh) {
+			pr_err_ratelimited("beamfs/inline: truncate: failed to read indirect block %llu\n",
+					   (unsigned long long)indirect_blk);
+			return;
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
+			pr_err_ratelimited("beamfs/inline: truncate: indirect block %llu failed parity, subtree left allocated\n",
+					   (unsigned long long)indirect_blk);
+			return;
+		}
+		ptrs = (__le64 *)ibh->b_data;
+
+		if (b_first_freed >= BEAMFS_DIRECT_BLOCKS)
+			slot_first = b_first_freed - BEAMFS_DIRECT_BLOCKS;
+		else
+			slot_first = 0;
+
+		/*
+		 * Under the buffer lock, as the install side is.
+		 *
+		 * Zeroing a pointer is a store into a shared indirect
+		 * block, no different from installing one: the flusher
+		 * can be submitting that same buffer while the loop runs,
+		 * and a slot cleared halfway through the write reaches
+		 * the disk as neither the old value nor zero. The three
+		 * install sites take the lock; the two free sites did not.
+		 *
+		 * beamfs_free_block sleeps -- write_bitmap_block takes
+		 * lock_buffer on a bitmap block -- so the pointers are
+		 * collected under the lock first and freed after it, one
+		 * pass each, rather than sleeping with the buffer held.
+		 */
+
+		{
+			u64 *doomed;
+			u64 n_doomed = 0;
+
+			doomed = kvmalloc_array(nptrs, sizeof(*doomed),
+						GFP_NOFS);
+			if (!doomed) {
+				brelse(ibh);
+				return;
+			}
+
+			lock_buffer(ibh);
+			for (j = slot_first; j < nptrs; j++) {
+				u64 blk = le64_to_cpu(ptrs[j]);
+
+				if (blk) {
+					doomed[n_doomed++] = blk;
+					beamfs_tc_clear(sb, ibh->b_blocknr, (u32)j);
+					ptrs[j] = 0;
+				}
+			}
+			beamfs_ind_parity_update(sb, ibh, inode);
+			unlock_buffer(ibh);
+			mmb_mark_buffer_dirty(ibh,
+					      &BEAMFS_I(inode)->i_metadata_bhs);
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
+			brelse(ibh);
+
+			for (j = 0; j < n_doomed; j++)
+				beamfs_free_block(sb, doomed[j], inode);
+			kvfree(doomed);
+		}
+
+		/* If we freed the entire indirect range, drop the indirect
+		 * block itself.
+		 */
+		if (slot_first == 0) {
+			beamfs_free_block(sb, indirect_blk, inode);
+			fi->i_indirect = 0;
+		}
+	}
+
+	/*
+	 * Double and triple indirect. The allocator reaches both, so a
+	 * truncate stopping at single indirect leaves every block a file
+	 * held past 2 MiB allocated with nothing left pointing at it.
+	 *
+	 * skip counts data blocks to preserve within each subtree: zero
+	 * once the truncation point is below the level, otherwise the
+	 * offset into it. A subtree entirely below the point is skipped
+	 * whole, which is why the walk returns its span.
+	 */
+	/*
+	 * The truncation point goes in as an absolute logical index, and
+	 * the pointer is cleared only if the walk reports the whole
+	 * subtree gone. Deriving that from the truncation point instead
+	 * was how a partially freed subtree ended up with a null parent
+	 * pointer and its surviving blocks orphaned.
+	 */
+	if (fi->i_dindirect &&
+	    beamfs_free_ind_range(sb, le64_to_cpu(fi->i_dindirect), 2,
+				  BEAMFS_MAX_IBLOCK_INDIRECT, b_first_freed, inode))
+		fi->i_dindirect = 0;
+
+	if (fi->i_tindirect &&
+	    beamfs_free_ind_range(sb, le64_to_cpu(fi->i_tindirect), 3,
+				  BEAMFS_MAX_IBLOCK_DINDIRECT, b_first_freed, inode))
+		fi->i_tindirect = 0;
+
+	mark_inode_dirty(inode);
+}
+
+/*
+ * beamfs_inline_zero_tail_block - zero user bytes [zero_offset .. end of
+ *                                 payload) in INLINE disk block b, via
+ *                                 RMW + RS re-encode.
+ *
+ * Used when truncate-down lands inside a block: the surviving block must
+ * be valid (RS-encoded) with stale tail bytes zeroed. The block is
+ * decoded into scratch, the tail is memset to zero, and the block is
+ * re-encoded and synced.
+ *
+ * Caller holds inode_lock. i_alloc_mutex is taken around the lookup;
+ * the read-modify-write itself runs under the buffer lock.
+ */
+static int beamfs_inline_zero_tail_block(struct inode *inode, u64 b,
+					 u32 zero_offset)
+{
+	struct beamfs_inode_info *fi = BEAMFS_I(inode);
+	struct super_block       *sb = inode->i_sb;
+	struct buffer_head       *bh;
+	u8                       *scratch;
+	u64                       phys = 0;
+	int                       ret;
+
+	if (zero_offset >= BEAMFS_DATA_INLINE_BYTES)
+		return 0;
+
+	{
+		u64 before = 0;
+
+		mutex_lock(&fi->i_alloc_mutex);
+		(void)beamfs_inline_lookup_phys(inode, b, &before);
+		ret = beamfs_inline_lookup_or_alloc_phys(inode, b, &phys);
+		/*
+		 * The same gate: this one reads the block and writes it
+		 * back, so a wrong address here overwrites metadata with
+		 * a zeroed tail.
+		 */
+		if (ret == 0 &&
+		    !beamfs_phys_is_sane(inode->i_sb, inode, phys, "zero_tail"))
+			ret = -EUCLEAN;
+		mutex_unlock(&fi->i_alloc_mutex);
+		if (ret < 0)
+			return ret;
+		if (before && phys && before != phys)
+			pr_err("beamfs/leak: zero_tail ino=%llu iblock=%llu %llu -> %llu\n",
+			       (unsigned long long)inode->i_ino, (unsigned long long)b,
+			       (unsigned long long)before,
+			       (unsigned long long)phys);
+	}
+	if (phys == 0)
+		return 0; /* HOLE: nothing to zero, sparse semantics */
+
+	scratch = beamfs_scratch_get(sb);
+	if (!scratch)
+		return -ENOMEM;
+
+	/*
+	 * zero_tail is part of the RMW write path (truncate-induced tail
+	 * clear). rmw_path=true so any flip detected on disk is journalled
+	 * with RMW_NEUTRALISED, as writeback's read of a partial block is.
+	 */
+	bh = sb_bread(sb, phys);
+	if (!bh) {
+		pr_err_ratelimited("beamfs/inline: zero_tail: sb_bread phys=%llu failed\n",
+				   (unsigned long long)phys);
+		beamfs_scratch_put(sb, scratch);
+		return -EIO;
+	}
+	/*
+	 * Lock bh for the full RMW transit: readers copy this block under
+	 * its lock, and writeback brings the same buffer up to date under it
+	 * (beamfs_wb_sync_alias), so none of them sees it half rewritten.
+	 */
+	lock_buffer(bh);
+
+	ret = beamfs_inline_decode_block_into_buf(sb, bh->b_data, phys, inode, b,
+						  scratch, 0,
+						  BEAMFS_DATA_INLINE_BYTES,
+						  true);
+	if (ret < 0) {
+		unlock_buffer(bh);
+		brelse(bh);
+		beamfs_scratch_put(sb, scratch);
+		return ret;
+	}
+
+	memset(scratch + zero_offset, 0,
+	       BEAMFS_DATA_INLINE_BYTES - zero_offset);
+
+	beamfs_lay_data_payload(sb, (u8 *)bh->b_data, scratch);
+	/* The descriptor before the parity, as in beamfs_wb_queue. */
+	beamfs_inline_stamp_tail_pad(BEAMFS_SB(inode->i_sb),
+				     (u8 *)bh->b_data, scratch,
+				     (unsigned long long)inode->i_ino, b);
+
+	ret = beamfs_seal_data_block(sb, (u8 *)bh->b_data);
+	if (ret < 0) {
+		pr_err_ratelimited("beamfs/inline: zero_tail: rs_encode_region failed: %d\n",
+				   ret);
+		unlock_buffer(bh);
+		brelse(bh);
+		beamfs_scratch_put(sb, scratch);
+		return ret;
+	}
+
+	mark_buffer_dirty(bh);
+	unlock_buffer(bh);
+	ret = sync_dirty_buffer(bh);
+	brelse(bh);
+	beamfs_scratch_put(sb, scratch);
+	return ret;
+}
+
+/*
+ * beamfs_inline_setattr - VFS setattr hook for INLINE inodes.
+ *
+ * Handles ATTR_SIZE (truncate up and down). Truncate-up extends i_size
+ * sparsely (HOLE handling in read_folio returns zero for unallocated
+ * blocks). Truncate-down frees disk blocks beyond the new size and
+ * zeros the partial trailing bytes in the surviving block.
+ *
+ * Other attribute changes (mode, owner, times) are forwarded to
+ * setattr_copy + mark_inode_dirty.
+ */
+static int beamfs_inline_setattr(const struct mnt_idmap *idmap,
+				 struct dentry *dentry, struct iattr *attr)
+{
+	struct inode *inode = d_inode(dentry);
+	int           ret;
+
+	ret = setattr_prepare(idmap, dentry, attr);
+	if (ret)
+		return ret;
+
+	if (attr->ia_valid & ATTR_SIZE) {
+		loff_t old_size = i_size_read(inode);
+		loff_t new_size = attr->ia_size;
+
+		ret = inode_newsize_ok(inode, new_size);
+		if (ret)
+			return ret;
+
+		if (new_size < old_size) {
+			u64 b_first_freed;
+			u32 tail_off;
+			u32 payload = beamfs_block_payload(inode->i_sb);
+
+			/* Drop pagecache beyond new_size before freeing
+			 * the underlying disk blocks.
+			 */
+			truncate_setsize(inode, new_size);
+
+			/*
+			 * Logical block index of the first block to be
+			 * fully freed: ceil(new_size / payload).
+			 */
+			b_first_freed = DIV_ROUND_UP_ULL((u64)new_size, payload);
+
+			/* If new_size is not block-aligned, the surviving
+			 * last block has stale user bytes beyond new_size.
+			 * Zero them via RMW + RS re-encode.
+			 */
+			div_u64_rem((u64)new_size, payload, &tail_off);
+			if (tail_off != 0 && new_size > 0) {
+				u64 b_last_kept = div_u64((u64)new_size, payload);
+
+				ret = beamfs_inline_zero_tail_block(inode,
+								    b_last_kept,
+								    tail_off);
+				if (ret)
+					return ret;
+			}
+
+			/*
+			 * The same mutex the allocator takes.
+			 *
+			 * Truncate walks the same indirection tree that
+			 * lookup_or_alloc_phys writes into, and took no
+			 * lock at all. The trace caught it: pid 3212
+			 * freeing block 0xe09 at 196.057356 between pid
+			 * 3112 allocating it at 196.042955 and allocating
+			 * it again at 196.058203 -- one writer's pointer
+			 * overwritten by another's, and the block left
+			 * marked used with nothing referencing it.
+			 *
+			 * generic/464 runs sixteen processes doing
+			 * pwrite -ftc against two hundred files chosen at
+			 * random, so a truncate on one file races an
+			 * allocation on another constantly. The leak
+			 * varied from 1 to 734 blocks between runs, which
+			 * is what a race looks like when you count it.
+			 */
+			mutex_lock(&BEAMFS_I(inode)->i_alloc_mutex);
+			beamfs_inline_free_blocks_from(inode, b_first_freed);
+			mutex_unlock(&BEAMFS_I(inode)->i_alloc_mutex);
+		} else if (new_size > old_size) {
+			/* Sparse extension: just adjust i_size. read_folio
+			 * returns zero for unallocated (HOLE) blocks.
+			 */
+			truncate_setsize(inode, new_size);
+		}
+
+		/*
+		 * A truncate changes the file, so it changes mtime, and it
+		 * changes the inode, so it changes ctime.
+		 *
+		 * setattr_copy below only carries the times the VFS asked
+		 * for, and truncate asks for none: the filesystem is
+		 * expected to set them itself, the way it does for a write.
+		 * generic/313 reports all four cases -- ctime and mtime,
+		 * shrinking and growing -- and says so in as many words.
+		 *
+		 * Both are set even when the size did not actually move,
+		 * because setattr_prepare has already accepted the request
+		 * and POSIX makes no exception for a truncate to the
+		 * current length.
+		 */
+		inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
+	}
+
+	setattr_copy(idmap, inode, attr);
+	mark_inode_dirty(inode);
+	return 0;
+}
+
+/*
+ * fiemap for the INLINE scheme.
+ *
+ * beamfs_fiemap in file.c calls iomap_fiemap with beamfs_iomap_ops --
+ * the legacy scheme=5 map, where a logical block is 4096 bytes and disk
+ * offset is file offset. Under INLINE a logical block is 3824 bytes
+ * inside a 4096-byte physical one, so that map describes a geometry
+ * this file does not have: generic/473 saw data starting at block 136
+ * where it had written at 128, a drift of 272 bytes per block.
+ *
+ * What this reports is one extent per block, and that is not a
+ * limitation of the code. fiemap merges two extents when
+ * addr + length == next addr; here addr advances by 4096 while length
+ * is at most the block's payload, 3808 or 3824 bytes, so the test never
+ * holds and never can. The mapping from file offset to disk offset is
+ * not affine, which is the price of putting each block's parity inside
+ * the block: 288 or 272 bytes of every 4096 hold the parity and the
+ * checks that protect the rest.
+ *
+ * So generic/473 still fails, and it fails for a reason worth stating
+ * rather than hiding: a tool asking where a file lives now gets the
+ * truth, block by block, instead of confident nonsense.
+ */
+static int beamfs_inline_fiemap(struct inode *inode,
+				struct fiemap_extent_info *fieinfo,
+				u64 start, u64 len)
+{
+	int ret;
+	loff_t i_size;
+
+	inode_lock(inode);
+	i_size = i_size_read(inode);
+	/* iomap_fiemap rejects len == 0; keep the call valid for an
+	 * empty file, where it returns no extents.
+	 */
+	if (i_size == 0)
+		i_size = 1;
+	len = min_t(u64, len, i_size);
+	ret = iomap_fiemap(inode, fieinfo, start, len,
+			   &beamfs_inline_iomap_ops);
+	inode_unlock(inode);
+	return ret;
+}
+
+const struct inode_operations beamfs_inline_inode_operations = {
+	.getattr        = beamfs_getattr,
+	.setattr        = beamfs_inline_setattr,
+	.fiemap         = beamfs_inline_fiemap,
+};
-- 
2.55.0

