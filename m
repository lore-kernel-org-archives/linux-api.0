Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.3
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795351293;
	b=jveBEcO/vZkCk4dHiGidgsuXM8TTk2BJc2qE4VoEzoXP4CyQ+MiFqjbCLkaGGxBv8x+h
	 7AVf/TiM91MGj7fHJ1AwrUOlEdDurnIalUiX77yIpX/aT7c0cmeA3Iz15Apy1wpr31KaN
	 AV0QEaqm0VWFiN9NpBZHkPr3qdw/9ixBd/gbTZ2CjBEWatFR87UcYRNL4OlXGb3C1zHzG
	 zcBjZlnl9w3y7AxW4rQBufZ4TvfzuG1Y6ErLJ7eGpBiTSKWG9S3LcScXaid//2H5OWSmi
	 6jhvqt9Sbi0Khk30ACCzRrwNp0Tuh9YmjNinqatqkwaUuxmypw6JUccy396Vx/Z/j1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795351293;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=RiSehMBMXp3JGcuv+I1fmr099AT+fLW4tepYFS+P7ao=;
	b=bJ4O7f5Wv2n8CxeZ8z+T0oVvUsq6tWffX88umrc5RjdwIuw7ZED569xipPWcXOWzEloc
	 gdFyg55d/7ouYRMHYZI2gAcQd2Vg/Xep6hdmtR5GtO2QLA7pLCN8y+NLADBnT7e+hZLRw
	 3ApDA7jzXfUOsDsMTUaekfYOgwRq7cfVfrq/mhDLQzMYRcNM6XYIfQ81WLF8KqFFJk7Ux
	 e5HcfT6rZSZLCQY0vfm/PdjuoKXhG4hyVQ3G7xlh3j2s9Sdr+FjK2FHTOq4tVz3stvYqc
	 N4DbNF/cEzaAGSD03cKpU28hIbBDI1ep58mHERYLCuw63tSjbjkR35CpIs+Ttw6nHOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=JuUSmTfL;
	arc=none smtp.remote-ip=220.197.31.3
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D50606A331;
	Sun, 22 Nov 2026 12:41:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 37D50606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=JuUSmTfL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Ri
	SehMBMXp3JGcuv+I1fmr099AT+fLW4tepYFS+P7ao=; b=JuUSmTfLpC++MSn/HN
	nZT8I4ENreibncxLJtSiUINtj8UXqj4MxtgUKV68r1PXM7U4K+4vokJBUN1hdavd
	cuAjEbKmZwXT6fg7CcMY1+wg49z4hhuW00Ka1aKKRCZlj6TJ1JeesuB5VKNhzxkS
	UGokwvItYgSZzklWR/a2xIj+s=
Received: from ubuntu (unknown [])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wCHjpfA4gJrM_rmIg--.62631S2;
	Sun, 22 Nov 2026 20:40:43 +0800 (CST)
From: Shaopei Zhu <shaopei_1012@163.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>
Cc: Yuezhang Mo <yuezhang.mo@sony.com>,
	exfat@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] exfat: add EXFAT_IOC_COMBINE to append a file's clusters to another
Date: Sun, 22 Nov 2026 20:40:29 +0800
Message-ID: <20261122124029.609636-1-shaopei_1012@163.com>
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
X-CM-TRANSID:_____wCHjpfA4gJrM_rmIg--.62631S2
X-Coremail-Antispam: 1Uf129KBjvAXoWfZr1Dtr15AF1DKw48Gw48JFb_yoW5WFykuo
	WfZws7Ww1rtFnIyrW8WF47GFy5WaykCa1xXr15WFWqyFyIq34UGa18A343J3WSqr1v9rZ3
	J34xtw43JFW3trn5n29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUxtxhDUUUU
X-CM-SenderInfo: pvkd01phlbiiirs6il2tof0z/xtbC6gxH1WsC4szicwAA3i

Cameras and dashcams recording to exFAT SD cards often write the video
stream and auxiliary data (e.g. IMU samples) to separate files and merge
them when recording stops.  Doing that with read()/write() or
copy_file_range() copies all the data of the source, which takes time
proportional to its size on such media, wears the flash and needs free
space for a second copy.

Filesystems supporting reflink can already avoid the copy by cloning
the source to the end of the destination with FICLONERANGE and then
unlinking it.  exFAT cannot share clusters between files, so it needs
an operation that moves them instead.  Its semantics follow from the
exFAT on-disk format (cluster granularity, a single valid_size per
file), so it is added as an exfat ioctl rather than a VFS interface;
fallocate() does not fit either, as it only takes a single file.

Add an ioctl that moves the cluster chain of a source file to the end
of a destination file and then unlinks the source, so that only
metadata changes: the FAT, the stream extension entry of the
destination and the entry set of the source:

	struct exfat_combine_args args = { .src_fd = src_fd };
	ioctl(dst_fd, EXFAT_IOC_COMBINE, &args);

The source is unlinked as unlink(2) does it: start_removing_dentry()
revalidates the dentry of the open file and locks its parent, and
security_path_unlink() and vfs_unlink() check permissions and security
modules, break leases and delegations, and handle mount points;
vfs_unlink() calls exfat_unlink(), which deletes the entry set.  Since
the in-memory inode no longer owns the clusters, evicting it frees
nothing.  The checks that can be made without unlinking are made before
anything is changed, and an already unlinked source is accepted.

As with EXT4_IOC_MOVE_EXT and F2FS_IOC_MOVE_RANGE, the source must be
open for reading and writing, the destination for writing, and both
must be regular files on the same mount.

exFAT has a single size and valid_size per file, so clusters can only
be appended at a cluster boundary of a fully initialized file.  The
destination is therefore first zero-filled up to the end of its last
cluster with exfat_extend_valid_size(), leaving a zero-filled gap
between the original and the appended data when its size is not
cluster aligned.  This is documented in the uapi header, and keeps
stale on-disk data out of the file.

exFAT has no journal, so the data and the FAT, then the destination
entry, then the deletion of the source entry set are written and
flushed to the device in that order, as recommended by section 8.1 of
the exFAT specification; the allocation bitmap is not touched.  A
crash at any point leaves all data reachable from at least one entry.
In the worst case both entries share the appended clusters; fsck.exfat
keeps them in the file it checks first and truncates the other one, so
either the combine has completed or the source still holds its data.
If the call fails before the clusters are moved, the zero padding is
removed again.  s_lock is only held while updating the FAT and the
entries, not while waiting for the device, so that writers to other
files on the volume are not stalled.

No file data is copied, so the cost depends on the number of clusters
(when a FAT chain has to be built for a contiguous file) rather than on
the amount of data.

The ioctl number is taken from the 'r' range next to the FAT ioctls.
A user space tool for exfatprogs (exfatcombine) and a test for fstests
(exfat/002) are posted separately.

This patch was written with the help of an AI coding assistant
(Claude Code, Opus 5.5); I have reviewed and tested the result.

Signed-off-by: Shaopei Zhu <shaopei_1012@163.com>
---

Notes:
    Changes in v2, following the Sashiko review of v1 [1]:
    
    - Unlink the source with security_path_unlink() and vfs_unlink() instead
      of open coding it, so that security modules, leases and delegations,
      swap files and mount points are handled as for unlink(2).  exfat_unlink()
      is no longer split, so namei.c and exfat_fs.h are not touched anymore.
    - Retry looking up the parent of the source only after a rename, and fail
      instead of looping when the parent was removed.  A rename no longer
      skips the permission check before the combine.
    - Refuse a source that is a mount point in any namespace before changing
      anything.
    - Write back all of the destination before its new valid_size is
      written, not only from the padding on.
    - On failure, restore the size, valid_size and zeroed_size of the
      destination, also when the padding itself failed part way or the
      destination was already cluster aligned.
    - Check IS_SWAPFILE() under the inode locks.
    - Return -EIO instead of WARN_ON_ONCE() when an earlier failed truncate
      left an inode inconsistent, and also check that an empty destination
      has no first cluster.
    - Not changed: a store through a shared mapping of the destination into
      the padding, between exfat_extend_valid_size() and taking the
      invalidate lock, is kept as file data like any concurrent write; it
      cannot expose stale data, and if the call fails the padding is
      truncated as by a concurrent ftruncate().  A test storing through a
      mapping during 2000 combines found only zeroes or the stored bytes in
      the padding.
    - Changelog: copying the source takes time proportional to its size; it
      does not rewrite the whole payload as v1 said.
    
    Testing (linux-next 20261118 + this patch, arm64, PROVE_LOCKING,
    DEBUG_ATOMIC_SLEEP, DEBUG_LIST; no lockdep or other warnings):
    
    - Functional tests on 512 B, 4 KiB and 128 KiB clusters: aligned and
      unaligned destination, empty destination/source, contiguous and
      fragmented chains, NO_FAT_CHAIN -> FAT chain conversion, destination
      extended by ftruncate()/fallocate(), already unlinked source, invalid
      arguments.  Every file is compared byte by byte, again after a
      remount, followed by fsck.exfat; the source is gone after every
      successful call and left alone after every failed one.
    - Unlinking the source: fails with EACCES and changes nothing in a
      directory the caller may not write to, or under a Landlock ruleset
      that does not allow removing files; succeeds otherwise.  A source that
      is a mount point fails with EBUSY, a swap file as source or
      destination is refused, and a source whose parent directory was
      removed fails with ENOENT; nothing is changed in any of these cases.
    - Files around 4 GiB on 4 KiB clusters (dst 4G-1, 4G, 4G+1, src 4G+7,
      2G+1 + 2G+1), fully verified after remount, fsck.exfat clean.
    - 300 MiB + 5 MiB on 128 KiB clusters: md5 matches dst + zero gap + src.
    - Time until durable, 300 MiB destination, 128 KiB clusters: the ioctl
      takes 12-15 ms for sources of 5 MiB to 1 GiB; appending them with
      copy_file_range() and fsync() takes 25 ms to 0.9 s on the test disk,
      and 135 ms to 46 s with the disk limited to 90/30 MiB/s read/write by
      cgroup io.max, as for an SD card.
    - Concurrency: 300 combines with a concurrent O_APPEND writer on the
      source and buffered, O_DIRECT and mmap readers on the destination; no
      record lost or duplicated.  Stores through a shared mapping into the
      padding during 2000 combines: see above.
    - Power cut: 30 runs with fsync'ed records (22 inside the ioctl, 12 left
      both entries sharing clusters), and 30 runs without any fsync and with
      dirty destination data at every combine; after fsck.exfat -y,
      everything synced or combined before the cut was present, with no
      stale data, and fsck was clean afterwards.
    - Impact on other writers: a thread appending 128 KiB chunks to another
      file on the volume while combines run back to back (about 820 in 10 s)
      keeps ~94% of its throughput, p99 write latency 0.075 ms (0.053 ms
      without combines).
    - Error paths with fail_make_request: failures while padding (also with
      a destination extended by truncate, aligned or not) leave the size,
      the data and the never written range, which reads as zeroes,
      unchanged, and the source in place; a failure at the FAT flush leaves
      the destination usable; after a truncate that failed with I/O errors,
      the call returns EIO without any warning.
    - KASAN with SLUB_DEBUG_ON: all of the above tests and fstests -g quick
      reported nothing.
    - fstests -g quick: the same 14 failures with and without the patch
      (generic/029 030 131 260 288 436 490 554 569 571 634 740 786 787),
      109 passed including the new exfat/002.
    - Builds without warnings with W=1 for arm64 (gcc, clang), arm and
      i386, built-in and as a module; no new sparse warnings.
    
    The test programs are available on request.
    
    [1] https://sashiko.dev/#/patchset/20261121174315.500249-1-shaopei_1012%40163.com
    
    v1: https://lore.kernel.org/all/20261121174315.500249-1-shaopei_1012@163.com/

 .../userspace-api/ioctl/ioctl-number.rst      |   1 +
 fs/exfat/file.c                               | 484 ++++++++++++++++++
 include/uapi/linux/exfat.h                    |  45 ++
 3 files changed, 530 insertions(+)

diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
index dbe4620..e9b4c13 100644
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
index c7991e9..dd3f85c 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -13,8 +13,10 @@
 #include <linux/writeback.h>
 #include <linux/filelock.h>
 #include <linux/falloc.h>
+#include <linux/file.h>
 #include <linux/fileattr.h>
 #include <linux/iomap.h>
+#include <linux/namei.h>
 #include <linux/pagemap.h>
 #include <linux/rmap.h>
 #include <linux/uio.h>
@@ -690,6 +692,486 @@ static int exfat_ioctl_set_volume_label(struct super_block *sb,
 	return exfat_write_volume_label(sb, &uniname);
 }
 
+static int exfat_extend_valid_size(struct inode *inode, loff_t new_valid_size);
+
+/* Write back all dirty metadata buffers and flush the device cache. */
+static int exfat_combine_flush(struct super_block *sb)
+{
+	int err = sync_blockdev(sb->s_bdev);
+
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
+ * Move the cluster chain of @src to the end of @dst, leaving @src empty.
+ *
+ * Only the FAT and the two stream extension entries are updated, no file
+ * data is copied.  The caller must have zero-filled @dst up to the end of
+ * its last cluster, so that no stale data ends up in the middle of the
+ * file, and must hold the inode and invalidate locks of both files.
+ *
+ * exFAT has no journal, so the updates are ordered on disk such that a
+ * crash at any point leaves all data reachable:
+ *
+ * 1. the data of both files and the FAT, so that the new chain of @dst
+ *    is complete before any entry refers to it;
+ * 2. the entry of @dst, after which both entries reference the clusters
+ *    of @src; fsck.exfat keeps them in whichever file it checks first and
+ *    truncates the other one;
+ * 3. the deletion of the entry set of @src, done by the caller with
+ *    __exfat_unlink() once the in-memory state of @src no longer owns
+ *    the clusters.
+ *
+ * This follows the write ordering recommended by section 8.1 of the
+ * exFAT specification: the FAT before the entry that refers to it, and
+ * the deletion of an entry set last.  No cluster is allocated or freed,
+ * so the allocation bitmap is not touched.
+ *
+ * s_lock is only held while updating the FAT and the entries, not while
+ * waiting for the device, so that other files on the volume are not
+ * stalled.  Until step 2, the in-memory state of @dst is left alone, so
+ * that writeback cannot publish its new chain flags early, and the
+ * in-memory state of @src is only changed once @dst is on disk.
+ */
+static int __exfat_combine(struct inode *dst, struct inode *src)
+{
+	struct super_block *sb = dst->i_sb;
+	struct exfat_sb_info *sbi = EXFAT_SB(sb);
+	struct exfat_inode_info *dst_ei = EXFAT_I(dst);
+	struct exfat_inode_info *src_ei = EXFAT_I(src);
+	loff_t dst_size = i_size_read(dst);
+	loff_t src_size = i_size_read(src);
+	loff_t new_valid_size;
+	unsigned int dst_clus, src_clus, last_clu, dst_start, dst_start_old;
+	unsigned char dst_flags, dst_flags_old;
+	struct exfat_chain chain;
+	bool linked = false;
+	int err = 0;
+
+	if (!src_size)
+		return 0;
+
+	dst_clus = exfat_bytes_to_cluster(sbi, exfat_ondisk_size(dst));
+	src_clus = exfat_bytes_to_cluster(sbi, exfat_ondisk_size(src));
+
+	/*
+	 * Ensured by exfat_ioctl_combine() and stable under its locks, unless
+	 * an earlier failed truncate left the allocation of a file larger
+	 * than its size, or the inode is otherwise inconsistent.
+	 */
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
+	exfat_chain_set(&chain, dst_start, dst_clus, dst_flags);
+	err = exfat_find_last_cluster(sb, &chain, &last_clu);
+	if (err)
+		goto unlock;
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
+		return -EIO;
+
+	err = exfat_combine_flush(sb);
+	if (err)
+		goto undo;
+
+	/* Step 2: publish the new size and chain of @dst. */
+	mutex_lock(&sbi->s_lock);
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
+	 * Step 3: the clusters now belong to @dst.  Only forget them in
+	 * memory, so that evicting @src does not free them; its entry on
+	 * disk is deleted by the caller.  If the flush failed, the entry of
+	 * @dst was still written, so do it anyway, and let writeback write
+	 * @src as an empty file since the caller will not unlink it.
+	 */
+	mutex_lock(&sbi->s_lock);
+	src_ei->start_clu = EXFAT_EOF_CLUSTER;
+	src_ei->flags = ALLOC_NO_FAT_CHAIN;
+	src->i_blocks = 0;
+	i_size_write(src, 0);
+	exfat_set_valid_size(src_ei, 0);
+	exfat_set_zeroed_size(src_ei, 0);
+	exfat_combine_reset_hints(src);
+	if (err)
+		mark_inode_dirty(src);
+	mutex_unlock(&sbi->s_lock);
+	return err;
+
+undo:
+	/* @dst does not own the clusters of @src, cut its chain again. */
+	if (linked) {
+		mutex_lock(&sbi->s_lock);
+		exfat_ent_set(sb, last_clu, EXFAT_EOF_CLUSTER);
+		mutex_unlock(&sbi->s_lock);
+	}
+	return err;
+}
+
+/*
+ * Lock the parent directory of @src_file for removing it.  Returns the
+ * dentry to remove with @parent set, NULL if @src_file is already
+ * unlinked, or an error.  A rename to another directory is retried.
+ */
+static struct dentry *exfat_combine_start_removing(struct file *src_file,
+						   struct path *parent)
+{
+	struct dentry *dentry = src_file->f_path.dentry;
+	struct dentry *victim;
+	bool dead;
+
+	for (;;) {
+		if (d_unhashed(dentry))
+			return NULL;
+
+		parent->mnt = src_file->f_path.mnt;
+		parent->dentry = dget_parent(dentry);
+		victim = start_removing_dentry(parent->dentry, dentry);
+		if (!IS_ERR(victim))
+			return victim;
+
+		/* -EINVAL: renamed, unlinked, or the parent was removed */
+		dead = IS_DEADDIR(d_inode(parent->dentry));
+		dput(parent->dentry);
+		if (dead)
+			return ERR_PTR(-ENOENT);
+		if (PTR_ERR(victim) == -ENOENT)
+			return NULL;
+		if (PTR_ERR(victim) != -EINVAL)
+			return victim;
+		cond_resched();
+	}
+}
+
+/*
+ * Check before anything is changed whether @src_file may be unlinked, so
+ * that the unlink after a successful combine does not fail on
+ * permissions.  This makes the checks of unlink(2) that do not need the
+ * inode lock; security_inode_unlink() only runs in vfs_unlink().  The
+ * parent directory is only locked for the check, not across the combine,
+ * so that other operations in that directory are not stalled.
+ */
+static int exfat_combine_may_unlink(struct file *src_file)
+{
+	struct dentry *victim;
+	struct path parent;
+	int err;
+
+	victim = exfat_combine_start_removing(src_file, &parent);
+	if (IS_ERR_OR_NULL(victim))
+		return PTR_ERR(victim);
+
+	err = may_delete_dentry(file_mnt_idmap(src_file),
+				d_inode(parent.dentry), victim, false);
+	/*
+	 * Refuse a source that is a mount point in any namespace, which is
+	 * stricter than vfs_unlink() checking the current one; the check
+	 * under the inode lock is done by vfs_unlink().
+	 */
+	if (!err && d_mountpoint(victim))
+		err = -EBUSY;
+	if (!err)
+		err = security_path_unlink(&parent, victim);
+
+	end_removing(victim);
+	dput(parent.dentry);
+	return err;
+}
+
+/*
+ * Unlink @src_file after its clusters were moved, the way unlink(2) does:
+ * vfs_unlink() checks the permission, security modules, mount points and
+ * swap files, breaks leases and delegations, and calls exfat_unlink(),
+ * which only deletes the entry set.  The clusters stay with the
+ * destination, as the in-memory inode no longer owns them.
+ */
+static int exfat_combine_unlink(struct file *src_file)
+{
+	struct delegated_inode delegated_inode = { };
+	struct dentry *victim;
+	struct path parent;
+	int err;
+
+retry:
+	victim = exfat_combine_start_removing(src_file, &parent);
+	if (IS_ERR_OR_NULL(victim))
+		return PTR_ERR(victim);
+
+	err = security_path_unlink(&parent, victim);
+	if (!err)
+		err = vfs_unlink(file_mnt_idmap(src_file),
+				 d_inode(parent.dentry), victim,
+				 &delegated_inode);
+
+	end_removing(victim);
+	dput(parent.dentry);
+	if (is_delegated(&delegated_inode)) {
+		err = break_deleg_wait(&delegated_inode);
+		if (!err)
+			goto retry;
+	}
+	return err;
+}
+
+/*
+ * Undo the zero padding of @dst after a failed combine: drop its size
+ * back to @old_size, and its valid and zeroed size back to @old_valid and
+ * @old_zeroed, as the zeroes may not have reached the disk.  Called with
+ * the inode and invalidate locks of @dst held.
+ */
+static void exfat_combine_unpad(struct inode *dst, loff_t old_size,
+				loff_t old_valid, loff_t old_zeroed)
+{
+	struct exfat_inode_info *ei = EXFAT_I(dst);
+	bool shrink = i_size_read(dst) > old_size;
+
+	if (shrink)
+		truncate_setsize(dst, old_size);
+	if (exfat_get_valid_size(ei) > old_valid)
+		exfat_set_valid_size(ei, old_valid);
+	if (exfat_get_zeroed_size(ei) > old_zeroed)
+		exfat_set_zeroed_size(ei, old_zeroed);
+	if (shrink)
+		exfat_truncate(dst);	/* writes the entry */
+	else
+		mark_inode_dirty(dst);
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
+	/* @src is unlinked on success, refuse early if that is not allowed. */
+	err = exfat_combine_may_unlink(src_file);
+	if (err)
+		goto out_drop_write;
+
+	lock_two_nondirectories(dst, src);
+	/* swapon() sets S_SWAPFILE under the inode lock. */
+	if (IS_SWAPFILE(dst) || IS_SWAPFILE(src)) {
+		err = -ETXTBSY;
+		goto out_unlock_inodes;
+	}
+	inode_dio_wait(dst);
+	inode_dio_wait(src);
+
+	src_size = i_size_read(src);
+	if (!src_size)
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
+	err = filemap_write_and_wait(src->i_mapping);
+	if (err)
+		goto out_unlock;
+
+	err = filemap_write_and_wait(dst->i_mapping);
+	if (err)
+		goto out_unlock;
+
+	err = invalidate_inode_pages2_range(dst->i_mapping,
+					    dst_size >> PAGE_SHIFT, -1);
+	if (err)
+		goto out_unlock;
+
+	err = __exfat_combine(dst, src);
+
+	/* @src may have been emptied even if writing @dst failed. */
+	truncate_pagecache(src, i_size_read(src));
+	if (!err)
+		fsnotify_modify(dst_file);
+
+out_unlock:
+	/*
+	 * If the clusters were not moved, undo the zero padding so that a
+	 * failed call leaves @dst as it was.
+	 */
+	if (err && i_size_read(dst) <= dst_size)
+		exfat_combine_unpad(dst, old_size, old_valid, old_zeroed);
+	filemap_invalidate_unlock_two(dst->i_mapping, src->i_mapping);
+out_unlock_inodes:
+	unlock_two_nondirectories(dst, src);
+
+	/*
+	 * Unlink @src last, with the inode locks dropped, as the parent has
+	 * to be locked first.  Should that still fail, e.g. because a
+	 * security module denies it or @src was meanwhile moved to a
+	 * directory it may not be removed from, write @src as an empty file
+	 * so that its entry no longer references the moved clusters.
+	 */
+	if (!err) {
+		err = exfat_combine_unlink(src_file);
+		if (!err) {
+			err = exfat_combine_flush(dst->i_sb);
+		} else {
+			int ret;
+
+			mutex_lock(&sbi->s_lock);
+			ret = __exfat_write_inode(src, 1);
+			mutex_unlock(&sbi->s_lock);
+			if (!ret)
+				ret = blkdev_issue_flush(dst->i_sb->s_bdev);
+			if (ret)
+				mark_inode_dirty(src);
+		}
+	}
+out_drop_write:
+	mnt_drop_write_file(dst_file);
+	return err;
+}
+
 long exfat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
@@ -702,6 +1184,8 @@ long exfat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		return exfat_ioctl_set_attributes(filp, user_attr);
 	case EXFAT_IOC_SHUTDOWN:
 		return exfat_ioctl_shutdown(inode->i_sb, arg);
+	case EXFAT_IOC_COMBINE:
+		return exfat_ioctl_combine(filp, arg);
 	case FITRIM:
 		return exfat_ioctl_fitrim(inode, arg);
 	case FS_IOC_GETFSLABEL:
diff --git a/include/uapi/linux/exfat.h b/include/uapi/linux/exfat.h
index 46d95b1..c515898 100644
--- a/include/uapi/linux/exfat.h
+++ b/include/uapi/linux/exfat.h
@@ -13,6 +13,7 @@
  */
 
 #define EXFAT_IOC_SHUTDOWN _IOR('X', 125, __u32)
+#define EXFAT_IOC_COMBINE  _IOW('r', 0x20, struct exfat_combine_args)
 
 /*
  * Flags used by EXFAT_IOC_SHUTDOWN
@@ -22,4 +23,48 @@
 #define EXFAT_GOING_DOWN_FULLSYNC	0x1     /* going down with full sync*/
 #define EXFAT_GOING_DOWN_NOSYNC         0x2     /* going down */
 
+/*
+ * Argument for EXFAT_IOC_COMBINE.
+ *
+ * The ioctl is issued on the destination file.  The clusters of @src_fd
+ * are appended to the destination without copying any data, and the
+ * source is then unlinked from its directory, so that only metadata is
+ * changed.  Open file descriptors of the source refer to an empty file
+ * afterwards.
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
+ * The source is unlinked with the same checks as unlink(2), including
+ * security modules.  The permission to unlink it is checked before
+ * anything is changed, as far as possible without unlinking it.  A source
+ * that is already unlinked is accepted.  If unlinking still fails after
+ * the clusters were moved, e.g. because a security module denies it or
+ * the source was moved meanwhile to a directory it may not be removed
+ * from, the source is left as an empty file and the error is returned.
+ *
+ * Errors are reported even when the device fails only after the
+ * destination was updated.  The clusters may then already belong to the
+ * destination, with the source left as an empty file or already
+ * unlinked; callers can tell from the size of the destination.
+ * Otherwise a failed call leaves both files unchanged.
+ *
+ * A crash during the call may leave both files referencing the appended
+ * clusters.  fsck.exfat resolves this without losing data, but the source
+ * must not be truncated or removed before fsck has run.
+ */
+struct exfat_combine_args {
+	__s32 src_fd;	/* file whose clusters are moved */
+	__u32 flags;	/* must be zero */
+};
+
 #endif /* _UAPI_LINUX_EXFAT_H */
-- 
2.50.1 (Apple Git-155)

