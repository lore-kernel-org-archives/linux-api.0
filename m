Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.2
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795736988;
	b=TuBIx+MOBXzhBD07bhjAEILMVCwWEARTw6LSe7WWs2KYVk5I6zxg8UB+UFD+kZ/jlvfz
	 9RgDXnUqCTOw/h23wppu4yboF566pzBHX133x+JGy13k+tn/ITN3VrHNYxYkhRyOOc+dF
	 OD169nKTlKYoj42GVdRrb0DEq4yL1QPZ/DrfnzRFbpbotVGtXvVXbhR0f8va2nf6peUIG
	 1c6IbD3thydxcrA+b8EdlAglvDJwh8qRhyw261uD3JlhyyBJ5zS4eqvmnOUMCoJg5c1q9
	 VuUqTwU3pg5aNHUmlfzKBs9BM/WzXmp/jfmWX/3QCUkH5rd+l0UoIdGV0/HKb2Ev1eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795736988;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=s0cHhkhVkcyMmHeklem0mV/oIOZAkpaU1gLlvGn/cN0=;
	b=qgxjHC9Sq+8U1cCLrTHRdj3nPcZyDLsLvhw6/XFIK5vU8DPXkItd4xn9dtPnKoxFj0cO
	 zlQ/3VGcsezQElHdXY9epQulV3lEMhvi3AKPW6gYyyxhTFvudJLtOg90VtjNWvocB1+NL
	 2HRNBS/+hU+mVNvlZwM2GnnOPbyWIOTSIJ33uJkHx5tcn0fU6fMZA8wqIOFRNYTr+S2t/
	 9zA4zZtDSOJ5cXdzi3smwrEfCcNz98mY6Mj+CGqZCJXR7kxcbDGPkUHq6b8Xvz6GKCnXk
	 vX2hvEtrBE717WH93R6vLuwylGLzU22HqNeEy1PMSKvuiEw40P+QcJ8kRjJ2jVi+etw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=G1SdJ2f9;
	arc=none smtp.remote-ip=117.135.210.2
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8BF606A31C;
	Thu, 26 Nov 2026 23:49:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EF8BF606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=G1SdJ2f9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=s0
	cHhkhVkcyMmHeklem0mV/oIOZAkpaU1gLlvGn/cN0=; b=G1SdJ2f9T8cU6EYrl+
	cBvX4ahFw/t14lVK10wPWVkHD+LXD6pGrEjAZIUosWWqi9q1xSnntsNjCIX3GSJh
	CDdTFBl1mXZ2MrSPf9/AQ0S4OWzh2TCl+DF1LD3g9ZlHs7tFBOk1EQndNXbFS2ln
	zyzum9+EOmr0Tx5zl1/gyphUY=
Received: from ubuntu (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wD3fxVgxQhrMs_9KQ--.57815S2;
	Fri, 27 Nov 2026 07:48:59 +0800 (CST)
From: Shaopei Zhu <shaopei_1012@163.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>
Cc: Yuezhang Mo <yuezhang.mo@sony.com>,
	exfat@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v11] exfat: add EXFAT_IOC_COMBINE to append a file's clusters to another
Date: Fri, 27 Nov 2026 07:48:46 +0800
Message-ID: <20261126234846.940461-1-shaopei_1012@163.com>
X-Mailer: git-send-email 2.53.0
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
X-CM-TRANSID:_____wD3fxVgxQhrMs_9KQ--.57815S2
X-Coremail-Antispam: 1Uf129KBjvAXoWfZr1Dtr15tF4kJw1DtrW5Jrb_yoW5tF13Jo
	WfZws3Xw1rtrnxtrW8Gr17Gry5XaykuF1fJr4YgF4qvF18t34UWa1Fyw15Za1Sqw1vkrZ5
	X3yIq3y3JFWaqrn3n29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxU7L0eDUUUU
X-CM-SenderInfo: pvkd01phlbiiirs6il2tof0z/xtbC6g5p92sIxW7M9AAA3K

Cameras recording to exFAT SD cards often write auxiliary data, such as
GPS, motion or per-frame exposure data, to separate files next to the
video stream, and merge them into the video file when recording stops,
so that playback, editing and post-processing work on a single file.
That data grows with the length of the recording, to hundreds of MiB.

Merging it with read()/write() or copy_file_range() copies all of that
data, which takes time proportional to its size on such media, wears
the flash and needs free space for a second copy.  On a battery-powered
device with a removable card, a copy that takes tens of seconds is also
a long window in which the card can be pulled or the power lost,
leaving a partially merged file.

Filesystems supporting reflink can already avoid the copy by cloning
the source to the end of the destination with FICLONERANGE.  exFAT
cannot share clusters between files, so it needs an operation that
moves them instead.  Its semantics follow from the exFAT on-disk format
(cluster granularity, a single valid_size per file), so it is added as
an exfat ioctl rather than a VFS interface; fallocate() does not fit
either, as it only takes a single file.

Add an ioctl that moves the cluster chain of a source file to the end
of a destination file and leaves the source as an empty file, so that
no file data is copied: only the FAT and the stream extension entries
of both files change:

	struct exfat_combine_args args = { .src_fd = src_fd };
	ioctl(dst_fd, EXFAT_IOC_COMBINE, &args);

As with the other interfaces that move or share data between files,
removing the source is left to the caller, which unlinks it afterwards
if it is not needed.  An already unlinked source is accepted.  An
unlinked destination is refused with -ENOENT, as its entry is no longer
written and the data of the source would be lost with it.

The source must be open for reading and writing, as it is emptied and
its data becomes readable through the destination, and the destination
for writing; both must be regular files on the same mount.  Files whose
allocation, chain layout or valid_size are inconsistent, as after a
failed truncate or on a corrupt volume, or that are found to share
clusters, are refused with -EIO before anything is changed.

exFAT has a single size and valid_size per file, so clusters can only
be appended at a cluster boundary of a fully initialized file.  The
destination is therefore first zero-filled up to the end of its last
cluster with exfat_extend_valid_size(), leaving a zero-filled gap
between the original and the appended data when its size is not
cluster aligned.  This keeps stale on-disk data out of the file and is
documented in the uapi header.  The gap lies in the last cluster, which
is already allocated to the destination, so it takes no extra space.

exFAT has no journal, so the data and the FAT, then the destination
entry, then the source entry as an empty file are written and flushed to
the device in that order, as recommended by section 8.1 of the exFAT
specification; the allocation bitmap is not touched.  A crash at any
point leaves all data reachable from at least one entry.  In the worst
case both entries share the appended clusters; fsck.exfat keeps them in
the file it checks first and truncates the other one, so either the
combine has completed or the source still holds its data.  A crash
between the first two writes leaves the chain of the destination linked
to the clusters of the source while its size does not cover them, which
fsck.exfat cuts off again.  In both cases neither file may be truncated
or removed before fsck.exfat has run, as freeing the clusters of one
would free clusters the other still uses; the volume is marked dirty
before the FAT is changed.  On a volume that was not cleanly unmounted,
the call fails with -EUCLEAN until fsck.exfat has run, so that it never
works on clusters that two files may already share or that may already
be linked.  Once the volume is in an emergency state, nothing more is
written, which leaves what a crash at that point would.  If the call
fails before the clusters are moved, the padding is removed again; what
was already written back is kept initialized, as
exfat_extend_valid_size() does on failure.  Write back errors are
checked through the errseq of the mappings, as their error flags may be
taken by a concurrent fsync().  s_lock is only held while updating the
FAT and the entries, not while waiting for the device, so that writers
to other files on the volume are not stalled.

No file data is copied, so the cost depends on the number of clusters
(when a FAT chain has to be built for a contiguous file) rather than on
the amount of data.  Measured on a disk throttled to SD card speeds
(30 MiB/s write), appending to a 300 MiB file with 128 KiB clusters,
until the result is on disk:

  source     EXFAT_IOC_COMBINE   copy_file_range() + fsync()
  50 MiB          12.3 ms                 2.2 s
  500 MiB         13.3 ms                22.3 s
  1 GiB           13.0 ms                45.7 s

The files of this test were contiguous.  Building the FAT chain of a
contiguous file, when it is needed, takes about 100 ms per GiB with
4 KiB clusters, and 32 times less with 128 KiB clusters.

The ioctl number is taken from the 'r' range next to the FAT ioctls.
A user space tool for exfatprogs (exfatcombine) and a test for fstests
(exfat/002) are posted separately.

This patch was written with the help of an AI coding assistant
(Claude Code, Opus 5.5); I have reviewed and tested the result.

Signed-off-by: Shaopei Zhu <shaopei_1012@163.com>
---

Notes:
    Changes in v11, comments and commit message only, no functional change:
    
    - Document that after a crash neither file, not only the source, may be
      truncated or removed before fsck.exfat has run, and describe the
      state a crash between the FAT update and the destination entry
      leaves, in the uapi header, the comment of __exfat_combine() and the
      commit message.
    
    This follows the review of v10 by Sashiko [1], which pointed out that
    the chain of the destination can be left linked to the clusters of the
    source.  I reproduced it with images edited offline (4 KiB clusters,
    destination with a FAT chain of 3 clusters, source of 3 clusters,
    volume dirty), mounted without running fsck, doing one operation and
    then writing a new file:
    
      state on disk     operation        result
      A                 rm dst           src loses its clusters
      A                 truncate dst     src silently corrupted
      A                 append to dst    both files intact
      A                 rm src           dst intact, but its chain runs
                                         into the new file
      B                 rm dst           src corrupted
      B                 rm src           dst silently corrupted
      A, contiguous dst rm dst           src intact
    
      A: the FAT links the destination to the source, both entries are
         still the old ones (crash between the first two writes)
      B: both entries own the clusters (crash before the source entry
         is written)
    
    fsck.exfat run before the operation repairs both states without losing
    data, and the call itself fails with -EUCLEAN on a dirty volume, so the
    rule is the one that already applies to a dirty exFAT volume; v11 only
    states it for both files.
    
    The cause is that __exfat_free_cluster() follows a FAT chain to its end
    rather than for the number of clusters of the file.  If you would
    rather have the kernel cope with the first state than rely on fsck, I
    can add a patch that makes it stop after the size of the chain; please
    let me know.
    
    Sashiko's other comment, about a source opened with O_APPEND, is
    unchanged from v10: not addressed, and I can refuse such a source if
    you prefer that.
    
    This applies to linux-next (next-20261118).  It uses
    exfat_emergency_state(), which comes with "exfat: don't set SB_RDONLY
    after filesystem errors" in the vfs tree (vfs-7.5.super.ro), so it does
    not build on mainline or on the exfat dev branch until that is merged
    there.  I can rebase it onto exfat dev then.
    
    All tests reported for v8 apply unchanged.  v10 was a resend of v9 with
    the base stated; v9 only changed the commit message (use case, the gap
    taking no space, measurements).
    
    [1] https://sashiko.dev/#/patchset/20261126200717.939328-1-shaopei_1012%40163.com
    
    v10: https://lore.kernel.org/all/20261126200717.939328-1-shaopei_1012@163.com/
    v9: https://lore.kernel.org/all/20261126191955.935845-1-shaopei_1012@163.com/
    v8: https://lore.kernel.org/all/20261126125216.927053-1-shaopei_1012@163.com/
    v7: https://lore.kernel.org/all/20261124230746.850528-1-shaopei_1012@163.com/
    v6: https://lore.kernel.org/all/20261124212236.830224-1-shaopei_1012@163.com/
    v5: https://lore.kernel.org/all/20261124202455.817408-1-shaopei_1012@163.com/
    v4: https://lore.kernel.org/all/20261124142807.773299-1-shaopei_1012@163.com/
    v3: https://lore.kernel.org/all/20261123132742.743416-1-shaopei_1012@163.com/
    v2: https://lore.kernel.org/all/20261122124029.609636-1-shaopei_1012@163.com/
    v1: https://lore.kernel.org/all/20261121174315.500249-1-shaopei_1012@163.com/

 .../userspace-api/ioctl/ioctl-number.rst      |   1 +
 fs/exfat/file.c                               | 616 ++++++++++++++++++
 include/uapi/linux/exfat.h                    |  47 ++
 3 files changed, 664 insertions(+)

diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
index dbe462040..e9b4c13d8 100644
--- a/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -292,6 +292,7 @@ Code  Seq#    Include File                                             Comments
 'q'   80-FF  linux/telephony.h                                         Internet PhoneJACK, Internet LineJACK
              linux/ixjuser.h                                           <http://web.archive.org/web/%2A/http://www.quicknet.net>
 'r'   00-1F  linux/msdos_fs.h and fs/fat/dir.c
+'r'   20-2F  linux/exfat.h
 's'   all    linux/cdk.h
 't'   00-7F  linux/ppp-ioctl.h
 't'   80-8F  linux/isdn_ppp.h
diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index 7ca26e3f1..855593d61 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -13,6 +13,7 @@
 #include <linux/writeback.h>
 #include <linux/filelock.h>
 #include <linux/falloc.h>
+#include <linux/file.h>
 #include <linux/fileattr.h>
 #include <linux/iomap.h>
 #include <linux/pagemap.h>
@@ -710,6 +711,619 @@ static int exfat_ioctl_set_volume_label(struct super_block *sb,
 	return exfat_write_volume_label(sb, &uniname);
 }
 
+static int exfat_extend_valid_size(struct inode *inode, loff_t new_valid_size);
+
+/*
+ * Write back all dirty metadata buffers and flush the device cache.  The
+ * error flags of the block device mapping go to whoever checks them
+ * first, an fsync() of any file on the volume included, so also check
+ * its errseq sampled in @since.  Advance @since, also when the writeback
+ * returned the error itself, so that the error is marked seen and fails
+ * one call only.
+ */
+static int exfat_combine_flush(struct super_block *sb, errseq_t *since)
+{
+	int err = sync_blockdev(sb->s_bdev);
+	int ret = errseq_check_and_advance(&sb->s_bdev->bd_mapping->wb_err,
+					   since);
+
+	if (!err)
+		err = ret;
+	return err ? err : blkdev_issue_flush(sb->s_bdev);
+}
+
+static void exfat_combine_reset_hints(struct inode *inode)
+{
+	struct exfat_inode_info *ei = EXFAT_I(inode);
+
+	exfat_cache_inval_inode(inode);
+	ei->hint_bmap.off = EXFAT_EOF_CLUSTER;
+	ei->hint_bmap.clu = EXFAT_EOF_CLUSTER;
+}
+
+/*
+ * Find the last cluster of @dst, walking only the clusters it owns.  A
+ * crash during an earlier call can have left the last one linked to @src,
+ * which is rewritten anyway, or, once the entry of @dst was written too,
+ * @src among them until fsck.exfat has run.  Refuse the latter, and any
+ * other overlap with the clusters of @src known without walking its
+ * chain (all of them if it is contiguous), as linking @src would create
+ * a loop in the FAT.
+ */
+static int exfat_combine_find_last(struct super_block *sb,
+				   struct exfat_chain *chain,
+				   struct exfat_chain *src, unsigned int *last)
+{
+	struct buffer_head *bh = NULL;
+	unsigned int clu = chain->dir, next, n;
+	unsigned int src_end = src->dir +
+		(src->flags == ALLOC_NO_FAT_CHAIN ? src->size : 1);
+	int err = 0;
+
+	if (chain->flags == ALLOC_NO_FAT_CHAIN) {
+		if (clu < src_end && src->dir < clu + chain->size)
+			return -EIO;
+		*last = clu + chain->size - 1;
+		return 0;
+	}
+
+	for (n = 1; ; n++) {
+		if (clu >= src->dir && clu < src_end) {
+			err = -EIO;
+			break;
+		}
+		err = exfat_ent_get(sb, clu, &next, &bh);
+		if (err)
+			break;
+		if (n == chain->size) {
+			if (next != EXFAT_EOF_CLUSTER && next != src->dir)
+				goto bogus;
+			*last = clu;
+			break;
+		}
+		if (next == EXFAT_EOF_CLUSTER)
+			goto bogus;
+		clu = next;
+	}
+	brelse(bh);
+	return err;
+
+bogus:
+	brelse(bh);
+	exfat_fs_error(sb, "bogus cluster chain (start 0x%08x, %u clusters)",
+		       chain->dir, chain->size);
+	return -EIO;
+}
+
+/*
+ * Move the cluster chain of @src to the end of @dst, leaving @src empty.
+ *
+ * Only the FAT and the two stream extension entries are updated, no file
+ * data is copied.  The caller must have found the last cluster @last_clu
+ * of @dst with exfat_combine_check_chains() and zero-filled @dst up to
+ * its end, so that no stale data ends up in the middle of the file, and
+ * must hold the inode and invalidate locks of both files.
+ *
+ * exFAT has no journal, so the updates are ordered on disk such that a
+ * crash at any point leaves all data reachable:
+ *
+ * 1. the data of both files and the FAT, so that the new chain of @dst
+ *    is complete before any entry refers to it; until step 2, the chain
+ *    of @dst runs into the clusters of @src beyond its size, which
+ *    fsck.exfat cuts off again;
+ * 2. the entry of @dst, after which both entries reference the clusters
+ *    of @src; fsck.exfat keeps them in whichever file it checks first and
+ *    truncates the other one;
+ * 3. the entry of @src as an empty file.
+ *
+ * This follows the write ordering recommended by section 8.1 of the
+ * exFAT specification: the FAT before the entry that refers to it.  No
+ * cluster is allocated or freed, so the allocation bitmap is not
+ * touched.
+ *
+ * s_lock is only held while updating the FAT and the entries, not while
+ * waiting for the device, so that other files on the volume are not
+ * stalled.  Until step 2, the in-memory state of @dst is left alone, so
+ * that writeback cannot publish its new chain flags early, and the
+ * in-memory state of @src is only changed once @dst is on disk.
+ */
+static int __exfat_combine(struct inode *dst, struct inode *src,
+			   unsigned int last_clu, errseq_t *meta_since)
+{
+	struct super_block *sb = dst->i_sb;
+	struct exfat_sb_info *sbi = EXFAT_SB(sb);
+	struct exfat_inode_info *dst_ei = EXFAT_I(dst);
+	struct exfat_inode_info *src_ei = EXFAT_I(src);
+	loff_t dst_size = i_size_read(dst);
+	loff_t src_size = i_size_read(src);
+	loff_t new_valid_size;
+	unsigned int dst_clus, src_clus, dst_start, dst_start_old;
+	unsigned char dst_flags, dst_flags_old;
+	bool linked = false;
+	int err = 0, ret;
+
+	dst_clus = exfat_bytes_to_cluster(sbi, exfat_ondisk_size(dst));
+	src_clus = exfat_bytes_to_cluster(sbi, exfat_ondisk_size(src));
+
+	/* Ensured by exfat_ioctl_combine() and stable under its locks. */
+	if (exfat_cluster_to_bytes(sbi, dst_clus) != dst_size ||
+	    (!dst_clus && dst_ei->start_clu != EXFAT_EOF_CLUSTER) ||
+	    (dst_clus && dst_ei->start_clu == EXFAT_EOF_CLUSTER) ||
+	    exfat_get_valid_size(dst_ei) != dst_size ||
+	    src_ei->start_clu == EXFAT_EOF_CLUSTER ||
+	    exfat_bytes_to_cluster_round_up(sbi, src_size) != src_clus)
+		return -EIO;
+
+	/* Step 1: build the new chain of @dst in the FAT. */
+	mutex_lock(&sbi->s_lock);
+	err = exfat_emergency_state(sb);
+	if (err)
+		goto unlock;
+	exfat_set_volume_dirty(sb);
+	dst_start_old = dst_ei->start_clu;
+	dst_flags_old = dst_ei->flags;
+	dst_start = dst_start_old;
+	dst_flags = dst_flags_old;
+
+	if (!dst_clus) {
+		dst_start = src_ei->start_clu;
+		dst_flags = src_ei->flags;
+		goto unlock;
+	}
+
+	/*
+	 * A contiguous @dst can stay contiguous only if @src is contiguous
+	 * and starts right after it.  Otherwise build its FAT chain first.
+	 */
+	if (dst_flags == ALLOC_NO_FAT_CHAIN &&
+	    (src_ei->flags != ALLOC_NO_FAT_CHAIN ||
+	     src_ei->start_clu != last_clu + 1)) {
+		err = exfat_chain_cont_cluster(sb, dst_start, dst_clus);
+		if (err)
+			goto unlock;
+		dst_flags = ALLOC_FAT_CHAIN;
+	}
+
+	if (dst_flags == ALLOC_FAT_CHAIN) {
+		if (src_ei->flags == ALLOC_NO_FAT_CHAIN) {
+			err = exfat_chain_cont_cluster(sb, src_ei->start_clu,
+						       src_clus);
+			if (err)
+				goto unlock;
+		}
+		err = exfat_ent_set(sb, last_clu, src_ei->start_clu);
+		linked = !err;
+	}
+unlock:
+	mutex_unlock(&sbi->s_lock);
+	if (err)
+		return err;
+
+	err = exfat_combine_flush(sb, meta_since);
+	if (err)
+		goto undo;
+
+	/*
+	 * Step 2: publish the new size and chain of @dst.  As the rest of
+	 * exfat, write nothing more once the volume is in an emergency
+	 * state, which leaves what a crash after step 1 leaves.  If it
+	 * enters that state after the entry of @dst is written, @src keeps
+	 * its entry, as after a crash after step 2.
+	 */
+	mutex_lock(&sbi->s_lock);
+	err = exfat_emergency_state(sb);
+	if (err) {
+		mutex_unlock(&sbi->s_lock);
+		goto undo;
+	}
+	dst_ei->start_clu = dst_start;
+	dst_ei->flags = dst_flags;
+	new_valid_size = dst_size + exfat_get_valid_size(src_ei);
+	dst->i_blocks = exfat_cluster_to_sectors(sbi, dst_clus + src_clus);
+	i_size_write(dst, dst_size + src_size);
+	exfat_set_valid_size(dst_ei, new_valid_size);
+	exfat_set_zeroed_size(dst_ei, new_valid_size);
+	dst_ei->attr |= EXFAT_ATTR_ARCHIVE;
+	inode_set_mtime_to_ts(dst, inode_set_ctime_current(dst));
+	exfat_combine_reset_hints(dst);
+	err = __exfat_write_inode(dst, 1);
+	if (err) {
+		/*
+		 * The error is returned, mark it seen in the errseq of the
+		 * block device mapping, which no flush checks now, so that it
+		 * does not fail later calls.  Its error flags are left alone:
+		 * they are shared by every file on the volume.
+		 */
+		errseq_check_and_advance(&sb->s_bdev->bd_mapping->wb_err,
+					 meta_since);
+		/*
+		 * Keep @src the only owner of its clusters: give @dst back its
+		 * old state, which writeback retries to put on disk.
+		 */
+		dst_ei->start_clu = dst_start_old;
+		dst_ei->flags = dst_flags_old;
+		dst->i_blocks = exfat_cluster_to_sectors(sbi, dst_clus);
+		i_size_write(dst, dst_size);
+		exfat_set_valid_size(dst_ei, dst_size);
+		exfat_set_zeroed_size(dst_ei, dst_size);
+		exfat_combine_reset_hints(dst);
+		mark_inode_dirty(dst);
+	}
+	mutex_unlock(&sbi->s_lock);
+	if (err)
+		goto undo;
+
+	err = blkdev_issue_flush(sb->s_bdev);
+
+	/*
+	 * Step 3: the clusters now belong to @dst.  Write @src as an empty
+	 * file.  If the flush failed, the entry of @dst was still written,
+	 * so do it anyway.  If writing @src fails, its in-memory state no
+	 * longer owns the clusters, so evicting it frees nothing, and
+	 * writeback retries the entry; until then both entries reference
+	 * the clusters, as after a crash.
+	 */
+	mutex_lock(&sbi->s_lock);
+	src_ei->start_clu = EXFAT_EOF_CLUSTER;
+	src_ei->flags = ALLOC_NO_FAT_CHAIN;
+	src->i_blocks = 0;
+	i_size_write(src, 0);
+	exfat_set_valid_size(src_ei, 0);
+	exfat_set_zeroed_size(src_ei, 0);
+	exfat_combine_reset_hints(src);
+	src_ei->attr |= EXFAT_ATTR_ARCHIVE;
+	inode_set_mtime_to_ts(src, inode_set_ctime_current(src));
+	ret = exfat_emergency_state(sb);
+	if (!ret) {
+		ret = __exfat_write_inode(src, 1);
+		if (ret)	/* as for @dst in step 2 */
+			errseq_check_and_advance(&sb->s_bdev->bd_mapping->wb_err,
+						 meta_since);
+	}
+	if (ret)
+		mark_inode_dirty(src);
+	mutex_unlock(&sbi->s_lock);
+	return err ? err : ret;
+
+undo:
+	/*
+	 * @dst does not own the clusters of @src, cut its chain again,
+	 * unless the volume is in an emergency state.
+	 */
+	if (linked) {
+		mutex_lock(&sbi->s_lock);
+		if (!exfat_emergency_state(sb))
+			exfat_ent_set(sb, last_clu, EXFAT_EOF_CLUSTER);
+		mutex_unlock(&sbi->s_lock);
+	}
+	return err;
+}
+
+/*
+ * Write back @inode and check that everything dirtied since @since has
+ * reached the disk.  The error flags of a mapping go to whoever checks
+ * them first, a concurrent fsync() included, so a clean return of the
+ * writeback alone does not tell; its errseq does.  Mark the error seen,
+ * so that it does not fail later calls; @since is the caller's copy, so
+ * checking again with it still reports the error.
+ */
+static int exfat_combine_write_back(struct inode *inode, errseq_t since)
+{
+	int err = filemap_write_and_wait(inode->i_mapping);
+	int ret = errseq_check_and_advance(&inode->i_mapping->wb_err, &since);
+
+	return err ? err : ret;
+}
+
+/*
+ * Undo the zero padding of @dst after a failed combine: drop its size
+ * back to @old_size.  Once @dst was written back, the zeroes and any
+ * stores through mmap below @old_size are on disk, so keep them, as
+ * exfat_extend_valid_size() does, after flushing them to the medium
+ * ahead of the entry that covers them.  Only if @dst cannot be written
+ * back, drop its valid size back to @old_valid and its zeroed size to
+ * no more than that, and unmap that range so that further stores through
+ * mmap fault again and extend valid_size.  The entry is written right
+ * away.
+ * Called with the inode and invalidate locks of @dst held.
+ */
+static void exfat_combine_unpad(struct inode *dst, loff_t old_size,
+				loff_t old_valid, loff_t old_zeroed,
+				bool written, errseq_t since)
+{
+	struct exfat_sb_info *sbi = EXFAT_SB(dst->i_sb);
+	struct exfat_inode_info *ei = EXFAT_I(dst);
+	bool shrink = i_size_read(dst) > old_size;
+	loff_t zeroed;
+
+	if (shrink)
+		truncate_setsize(dst, old_size);
+	/* Do not rely on exfat_truncate(), which stops early after an error. */
+	if (exfat_get_valid_size(ei) > old_size)
+		exfat_set_valid_size(ei, old_size);
+	if (exfat_get_zeroed_size(ei) > old_size)
+		exfat_set_zeroed_size(ei, old_size);
+
+	/*
+	 * Padding or writing back @src may have failed before @dst was
+	 * written back: try that first, as stores through mmap that have
+	 * already completed cannot be made to fault again.
+	 */
+	if (!written)
+		written = !exfat_combine_write_back(dst, since);
+
+	if (written) {
+		if (exfat_get_valid_size(ei) > old_valid)
+			blkdev_issue_flush(dst->i_sb->s_bdev);
+	} else {
+		if (exfat_get_valid_size(ei) > old_valid) {
+			/*
+			 * unmap_mapping_range() rounds the start down but not
+			 * the length up past it: pass whole pages, or the last
+			 * page of the range stays mapped writable.
+			 */
+			if (old_valid < old_size) {
+				loff_t start = round_down(old_valid, PAGE_SIZE);
+
+				unmap_mapping_range(dst->i_mapping, start,
+						    old_size - start, 0);
+			}
+			exfat_set_valid_size(ei, old_valid);
+		}
+		/*
+		 * The failed writeback also cleaned a folio that was dirty
+		 * before the call, without its blocks reaching the disk: do
+		 * not count its tail past @old_valid as initialized, so that
+		 * extending valid_size prepares and dirties it again.
+		 */
+		zeroed = min(old_zeroed, old_valid);
+		if (exfat_get_zeroed_size(ei) > zeroed)
+			exfat_set_zeroed_size(ei, zeroed);
+	}
+
+	if (shrink) {
+		exfat_truncate(dst);	/* writes the entry */
+	} else if (!exfat_emergency_state(dst->i_sb)) {
+		mutex_lock(&sbi->s_lock);
+		if (__exfat_write_inode(dst, inode_needs_sync(dst)))
+			mark_inode_dirty(dst);
+		mutex_unlock(&sbi->s_lock);
+	}
+}
+
+/*
+ * A failed truncate can leave the allocation of a file larger than its
+ * size, or its valid_size above its size, and a corrupt entry can carry
+ * neither chain layout, or a contiguous chain running past the volume.
+ * Refuse such a file before anything is changed, as padding @dst
+ * allocates based on its allocation, the valid_size of @src is carried
+ * over to @dst, and Step 1 writes the FAT entries of contiguous chains.
+ */
+static bool exfat_combine_inode_ok(struct inode *inode)
+{
+	struct exfat_sb_info *sbi = EXFAT_SB(inode->i_sb);
+	struct exfat_inode_info *ei = EXFAT_I(inode);
+	loff_t size = i_size_read(inode);
+
+	if (exfat_ondisk_size(inode) != round_up(size, sbi->cluster_size) ||
+	    (!size && ei->start_clu != EXFAT_EOF_CLUSTER) ||
+	    (size && ei->start_clu == EXFAT_EOF_CLUSTER) ||
+	    exfat_get_valid_size(ei) > size)
+		return false;
+	if (!size || ei->flags == ALLOC_FAT_CHAIN)
+		return true;
+	/* As exfat_validate_vendor_alloc() checks a contiguous range. */
+	return ei->flags == ALLOC_NO_FAT_CHAIN &&
+	       DIV_ROUND_UP_ULL(size, sbi->cluster_size) <=
+	       sbi->num_clusters - ei->start_clu;
+}
+
+/*
+ * Only a corrupt volume has files sharing clusters.  Refuse them before
+ * anything is changed: zero-filling @dst would overwrite data of @src in
+ * a shared cluster, and linking @src would create a loop in the FAT.
+ * Two files owning more clusters than are in use share some of them, and
+ * the result would fail the check of exfat_find() too.  The chain of
+ * @dst cannot change until the combine, as it is fully allocated and the
+ * caller holds its inode lock.
+ */
+static int exfat_combine_check_chains(struct inode *dst, struct inode *src,
+				      unsigned int *last)
+{
+	struct super_block *sb = dst->i_sb;
+	struct exfat_sb_info *sbi = EXFAT_SB(sb);
+	struct exfat_inode_info *dst_ei = EXFAT_I(dst);
+	struct exfat_inode_info *src_ei = EXFAT_I(src);
+	unsigned int dst_clus, src_clus;
+	struct exfat_chain chain, src_chain;
+	int err = 0;
+
+	dst_clus = exfat_bytes_to_cluster_round_up(sbi, i_size_read(dst));
+	src_clus = exfat_bytes_to_cluster_round_up(sbi, i_size_read(src));
+	*last = EXFAT_EOF_CLUSTER;
+
+	mutex_lock(&sbi->s_lock);
+	if ((u64)dst_clus + src_clus > sbi->used_clusters) {
+		err = -EIO;
+	} else if (dst_clus) {
+		exfat_chain_set(&chain, dst_ei->start_clu, dst_clus,
+				dst_ei->flags);
+		exfat_chain_set(&src_chain, src_ei->start_clu, src_clus,
+				src_ei->flags);
+		err = exfat_combine_find_last(sb, &chain, &src_chain, last);
+	}
+	mutex_unlock(&sbi->s_lock);
+	return err;
+}
+
+static int exfat_ioctl_combine(struct file *dst_file, unsigned long arg)
+{
+	struct inode *dst = file_inode(dst_file);
+	struct exfat_sb_info *sbi = EXFAT_SB(dst->i_sb);
+	struct exfat_combine_args args;
+	struct file *src_file;
+	struct inode *src;
+	loff_t old_size, old_valid, old_zeroed, dst_size, src_size;
+	errseq_t dst_since, src_since, meta_since;
+	unsigned int last_clu;
+	bool written = false, moved = false;
+	int err = 0;
+
+	if (copy_from_user(&args, (void __user *)arg, sizeof(args)))
+		return -EFAULT;
+
+	if (args.flags)
+		return -EINVAL;
+
+	CLASS(fd, f)(args.src_fd);
+	if (fd_empty(f))
+		return -EBADF;
+	src_file = fd_file(f);
+	src = file_inode(src_file);
+
+	/* The data of @src becomes readable through @dst. */
+	if (!(dst_file->f_mode & FMODE_WRITE) ||
+	    !(src_file->f_mode & FMODE_READ) ||
+	    !(src_file->f_mode & FMODE_WRITE))
+		return -EBADF;
+
+	if (dst_file->f_path.mnt != src_file->f_path.mnt)
+		return -EXDEV;
+
+	if (!S_ISREG(dst->i_mode) || !S_ISREG(src->i_mode) || dst == src)
+		return -EINVAL;
+
+	if (unlikely(exfat_forced_shutdown(dst->i_sb)))
+		return -EIO;
+
+	/*
+	 * After an unclean shutdown, the clusters of a source may already
+	 * belong to its destination as well, or be linked to it, and any file
+	 * may be inconsistent until fsck.exfat has run.
+	 */
+	if (sbi->vol_flags_persistent & VOLUME_DIRTY)
+		return -EUCLEAN;
+
+	/* LSM and fanotify permission checks, done before taking any lock. */
+	src_size = i_size_read(src);
+	err = remap_verify_area(src_file, 0, src_size, true);
+	if (err)
+		return err;
+	err = remap_verify_area(dst_file, i_size_read(dst), src_size, true);
+	if (err)
+		return err;
+
+	err = mnt_want_write_file(dst_file);
+	if (err)
+		return err;
+
+	lock_two_nondirectories(dst, src);
+	/* swapon() sets S_SWAPFILE under the inode lock. */
+	if (IS_SWAPFILE(dst) || IS_SWAPFILE(src)) {
+		err = -ETXTBSY;
+		goto out_unlock_inodes;
+	}
+	/* An unlinked @dst is not written back: @src would lose its data. */
+	if (!dst->i_nlink) {
+		err = -ENOENT;
+		goto out_unlock_inodes;
+	}
+	if (!exfat_combine_inode_ok(dst) || !exfat_combine_inode_ok(src)) {
+		err = -EIO;
+		goto out_unlock_inodes;
+	}
+	inode_dio_wait(dst);
+	inode_dio_wait(src);
+
+	src_size = i_size_read(src);
+	if (!src_size)
+		goto out_unlock_inodes;
+
+	err = exfat_combine_check_chains(dst, src, &last_clu);
+	if (err)
+		goto out_unlock_inodes;
+
+	err = exfat_emergency_state(dst->i_sb);
+	if (err)
+		goto out_unlock_inodes;
+
+	/*
+	 * exFAT cannot describe a gap in the middle of a file, and the rest
+	 * of the last cluster of @dst may hold stale data.  Zero-fill @dst
+	 * up to the end of its last cluster, including any uninitialized
+	 * range before i_size, so that @src starts at a cluster boundary.
+	 */
+	dst_size = round_up(i_size_read(dst), sbi->cluster_size);
+	err = inode_newsize_ok(dst, dst_size + src_size);
+	if (err)
+		goto out_unlock_inodes;
+
+	old_size = i_size_read(dst);
+	old_valid = exfat_get_valid_size(EXFAT_I(dst));
+	old_zeroed = exfat_get_zeroed_size(EXFAT_I(dst));
+	dst_since = filemap_sample_wb_err(dst->i_mapping);
+	src_since = filemap_sample_wb_err(src->i_mapping);
+	meta_since = filemap_sample_wb_err(dst->i_sb->s_bdev->bd_mapping);
+	err = exfat_extend_valid_size(dst, dst_size);
+
+	filemap_invalidate_lock_two(dst->i_mapping, src->i_mapping);
+	if (err)
+		goto out_unlock;
+
+	/*
+	 * Dirty data of @src must reach its clusters before they change
+	 * owner.  All dirty data of @dst, including the zeroes just written,
+	 * must be on disk before its new valid_size is, and cached folios of
+	 * @dst past its EOF must not shadow the data appended from @src.
+	 */
+	err = exfat_combine_write_back(src, src_since);
+	if (err)
+		goto out_unlock;
+
+	err = exfat_combine_write_back(dst, dst_since);
+	if (err)
+		goto out_unlock;
+	written = true;
+
+	err = invalidate_inode_pages2_range(dst->i_mapping,
+					    dst_size >> PAGE_SHIFT, -1);
+	if (err)
+		goto out_unlock;
+
+	err = __exfat_combine(dst, src, last_clu, &meta_since);
+	moved = i_size_read(dst) > dst_size;
+
+	/* @src may have been emptied even if a later step failed. */
+	truncate_pagecache(src, i_size_read(src));
+	if (moved) {
+		fsnotify_modify(dst_file);
+		fsnotify_modify(src_file);
+	}
+
+out_unlock:
+	/*
+	 * If the clusters were not moved, undo the zero padding so that a
+	 * failed call leaves @dst as it was.
+	 */
+	if (err && i_size_read(dst) <= dst_size)
+		exfat_combine_unpad(dst, old_size, old_valid, old_zeroed,
+				    written, dst_since);
+	filemap_invalidate_unlock_two(dst->i_mapping, src->i_mapping);
+out_unlock_inodes:
+	unlock_two_nondirectories(dst, src);
+
+	/*
+	 * Make the empty entry of @src durable and check for metadata write
+	 * errors, with the inode locks dropped so that writers of either
+	 * file are not stalled by the device.  Unlinking the emptied @src,
+	 * if it is not needed, is up to the caller.
+	 */
+	if (!err && moved)
+		err = exfat_combine_flush(dst->i_sb, &meta_since);
+	mnt_drop_write_file(dst_file);
+	return err;
+}
+
 long exfat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
@@ -722,6 +1336,8 @@ long exfat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		return exfat_ioctl_set_attributes(filp, user_attr);
 	case EXFAT_IOC_SHUTDOWN:
 		return exfat_ioctl_shutdown(inode->i_sb, arg);
+	case EXFAT_IOC_COMBINE:
+		return exfat_ioctl_combine(filp, arg);
 	case FITRIM:
 		return exfat_ioctl_fitrim(inode, arg);
 	case FS_IOC_GETFSLABEL:
diff --git a/include/uapi/linux/exfat.h b/include/uapi/linux/exfat.h
index 46d95b16f..e5c19ad6d 100644
--- a/include/uapi/linux/exfat.h
+++ b/include/uapi/linux/exfat.h
@@ -13,6 +13,7 @@
  */
 
 #define EXFAT_IOC_SHUTDOWN _IOR('X', 125, __u32)
+#define EXFAT_IOC_COMBINE  _IOW('r', 0x20, struct exfat_combine_args)
 
 /*
  * Flags used by EXFAT_IOC_SHUTDOWN
@@ -22,4 +23,50 @@
 #define EXFAT_GOING_DOWN_FULLSYNC	0x1     /* going down with full sync*/
 #define EXFAT_GOING_DOWN_NOSYNC         0x2     /* going down */
 
+/*
+ * Argument for EXFAT_IOC_COMBINE.
+ *
+ * The ioctl is issued on the destination file.  The clusters of @src_fd
+ * are appended to the destination without copying any data, and the
+ * source is left as an empty file, so that only metadata is changed.
+ * The caller unlinks the source afterwards if it is not needed; if the
+ * name of the source has to keep referring to the same file until then,
+ * the caller has to prevent concurrent renames.
+ *
+ * Clusters can only be appended at a cluster boundary.  If the size of
+ * the destination is not a multiple of the cluster size, it is first
+ * extended with zeroes up to the end of its last cluster, so the combined
+ * file has a zero-filled gap between the original and the appended data,
+ * and the appended data starts at offset round_up(old size, cluster size).
+ * User space has to account for that gap, e.g. by making the file format
+ * skip it.  To fill it with something else, user space can pad the
+ * destination itself before the call, in which case nothing is zeroed.
+ * The cluster size is reported in st_blksize by stat(2).  Any range of
+ * the destination that was never written, e.g. after fallocate(2), is
+ * zeroed as well, which can take a while if it is large.
+ *
+ * An unlinked destination is refused (ENOENT); an unlinked source is
+ * accepted.  An empty source leaves the destination unchanged.
+ *
+ * Errors are reported even when the device fails only after the
+ * destination was updated.  The clusters may then already belong to the
+ * destination, with the source empty or still to be written as empty;
+ * callers can tell from the size of the destination.  Otherwise a failed
+ * call leaves both files unchanged.
+ *
+ * A crash during the call may leave both files referencing the appended
+ * clusters, or the cluster chain of the destination linked to them while
+ * its size does not cover them yet.  fsck.exfat resolves this without
+ * losing data, but neither file may be truncated or removed before fsck
+ * has run: that can free clusters the other file still uses.  On a volume
+ * that was not cleanly unmounted, the call fails with EUCLEAN until
+ * fsck.exfat has run.  After a crash, an empty source next to a
+ * destination that already contains its data means that the call
+ * completed and only the unlink is left.
+ */
+struct exfat_combine_args {
+	__s32 src_fd;	/* file whose clusters are moved */
+	__u32 flags;	/* must be zero */
+};
+
 #endif /* _UAPI_LINUX_EXFAT_H */

base-commit: e8017d29067fd1310a65c3494ce1a1b492adbac6
-- 
2.53.0

