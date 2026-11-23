Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.2
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795440525;
	b=wk7zYevc998yToUR/pRdteKZwpOC7g90O1P2KUxu9kTv+WMZSAeF7h/9QZyQe7hPnxaU
	 NH6BrBPyCve4SZOVyjcjETeJPQVluyX49zZEGJlVhSsXziKlmpn5EDgVuNrZo+JSfk+d9
	 SrB3TgkF8AJPx3+qkp83V2IwED8SZ0/j055YDM9xssN7Om8COTWto3i+cW1sBc5gApTaI
	 G96n72lGJQVLTlTMITtI1gBhMBDMS25//YZ5X+S/CrdLd5LlUMsEq5rnikvBPOBGsZwlQ
	 PqUn/w7yl7tt+81TO+RWZVK1q/dhfk7F7vzgzwBrAUR3K163157skzmjTjNQQPp6Efw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795440525;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=p+XGa+rKQRR/hqxrCmzSgiozlznoYhs2BcbHwRvKq8U=;
	b=3RKvC1v134B8LVgfMHtMpHC9v2ZPxsy3x7HXFxyhoFhEOfJocxrBXnVBFCzIyVqW7Mfa
	 T3MrcUDQPFFiz9akyYXcBXqzZxprRwNLft2AOHCmaCJSV65fpbrt77r8ZtDQRZeeOohm1
	 YXS8ssA8NKebuMXDQbX5tKMFQfS/OT7fodfJbxNvGVWhJ14n/dSSsA09WtfmcWq7aBzCs
	 d7ckeVd7jwJ+NHRz6S9xQ/qS3gak90LopSYov/lL+lIbQintBqtUgZV5mZybAHY4pB2z5
	 rLnCTBYMR6Of3GXG3BSM6dNg11LjPSj/4e16wVEU76GnDk7ZV1Jljw3Wp/C3g0o1geQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=olg6Q+Jt;
	arc=none smtp.remote-ip=220.197.31.2
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C27B606A31A;
	Mon, 23 Nov 2026 13:28:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C27B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=olg6Q+Jt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=p+
	XGa+rKQRR/hqxrCmzSgiozlznoYhs2BcbHwRvKq8U=; b=olg6Q+JttEBcFKv7uZ
	xjYqWSzJwc0qzMGg+ZtRac+Gqnp3cgsG5HZQWTmZDYenoX9KtsPJegVFkBhcPXOw
	WsjbVlC2sd+TToBjXp8tf2WlvCH8Sr/VdSIi/6D+cmMN8SUbqSQVPbTIj8CttEfJ
	SCdfCe574EiGCzu6uOtek82hE=
Received: from ubuntu (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wD3_+lSPwRrDyTFJg--.50510S2;
	Mon, 23 Nov 2026 21:27:57 +0800 (CST)
From: Shaopei Zhu <shaopei_1012@163.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>
Cc: Yuezhang Mo <yuezhang.mo@sony.com>,
	exfat@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] exfat: add EXFAT_IOC_COMBINE to append a file's clusters to another
Date: Mon, 23 Nov 2026 21:27:42 +0800
Message-ID: <20261123132742.743416-1-shaopei_1012@163.com>
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
X-CM-TRANSID:_____wD3_+lSPwRrDyTFJg--.50510S2
X-Coremail-Antispam: 1Uf129KBjvAXoWfZr1Dtr15XF48AF43Cw48WFg_yoW5ur1xuo
	WfZw4kWw1rtrnayrW8CF17Gry5WaykCayfXr1YgFWqvF1Iq34UGa1jy345JaySqr1v9rZ3
	X34xtw43JrWSyr93n29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUchiSDUUUU
X-CM-SenderInfo: pvkd01phlbiiirs6il2tof0z/xtbC6h3CUWsEP11-OAAA3u

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
anything is changed, and an already unlinked source is accepted.  An
unlinked destination is refused with -ENOENT, as its entry is no longer
written and the data of the source would be lost with it.

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
entry, then the deletion of the source entry set are written and flushed
to the device in that order, as recommended by section 8.1 of the exFAT
specification; the allocation bitmap is not touched.  A crash at any
point leaves all data reachable from at least one entry.  In the worst
case both entries share the appended clusters; fsck.exfat keeps them in
the file it checks first and truncates the other one, so either the
combine has completed or the source still holds its data.  Combining the
same files again before fsck.exfat has run completes the call if only
the FAT was updated, and fails with -EIO if both entries already share
the clusters, instead of linking the source to itself.  If the call
fails before the clusters are moved, the padding is removed again; what
was already written back is kept initialized, as
exfat_extend_valid_size() does on failure.  s_lock is only held while
updating the FAT and the entries, not while waiting for the device, so
that writers to other files on the volume are not stalled.

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
    Changes in v3, following the Sashiko review of v2 [1] and a review of
    our own along the same lines:
    
    - Check before padding that both inodes are consistent (allocation
      matching the size, a first cluster iff non-empty, valid_size not above
      the size) and return -EIO otherwise.  A failed truncate can leave
      i_blocks or valid_size above the size: padding allocated based on it
      (-ENOSPC from a wrapped cluster count, or a bogus chain error), and a
      source with valid_size above its size exposed its stale tail through
      the destination once that was extended.
    - Walk only the clusters @dst owns when looking for its last cluster,
      and refuse with -EIO a @src whose first cluster is among them, which
      is the state a crash between writing the entry of @dst and unlinking
      @src leaves until fsck.exfat has run; retrying would have linked @src
      to itself.  A crash before the entry of @dst was written leaves its
      last cluster already linked to @src, which is now accepted, so
      retrying completes instead of reporting a bogus chain.  An
      alternative would be to refuse combining on a volume mounted dirty,
      which is simpler but also blocks it after unrelated crashes.
    - Refuse with -EXDEV to unlink a source that was moved out of the bind
      mount it was opened through, checking as path_connected() does for
      "..", so that it is neither removed outside the mount nor passed to
      security_path_unlink() as a disconnected path.
    - Only fail with -ENOENT on a dead parent if @src is still in it, which
      needs the directory and the dcache to disagree; a source renamed to
      another directory or unlinked before its old parent was removed is
      retried or treated as unlinked.
    - On failure, keep the padding of @dst initialized below its old size
      once it was written back, flushing it to the medium before the entry
      that covers it, as exfat_extend_valid_size() keeps initialized data on
      failure; stores through mmap during the padding are no longer lost.
      If writing back failed, still drop valid_size back as in v2, but
      unmap that range so that stores fault again, and write the entry
      right away in both cases, as a failed padding may have left a larger
      valid_size in it.
    - Refuse an unlinked destination with -ENOENT.  Its entry is not written
      any more, so the call returned success, unlinked the source, and its
      data went away when the destination was closed.
    - Send a modify event for the source when it is left empty because
      unlinking it failed.
    - Comment of __exfat_combine(): the source is unlinked with
      vfs_unlink().
    
    Testing (linux-next 20261118 + this patch, arm64):
    
    - Each change above was first reproduced on v2 and then checked on v3,
      with test-only knobs where a race window or a failure had to be hit
      exactly (a delay at a given point, an error at a given step of
      truncate or of the combine), and with images edited offline to hold
      the states a crash leaves:
      - failed truncate of the destination: v2 -ENOSPC or a bogus chain
        error, v3 -EIO with nothing changed; of the source: v2 exposed 3178
        stale bytes once the destination was extended, v3 -EIO;
      - retry after a crash after step 1: v2 bogus chain error, v3
        completes; after step 2 (FAT chain, contiguous and empty
        destination): v2 made the chain a loop, v3 -EIO with the FAT
        unchanged, and fsck.exfat -y keeps all data in the destination;
      - source moved out of a bind mount, also under a Landlock ruleset
        allowing removal only inside it: v2 removed it, v3 -EXDEV;
      - source renamed or unlinked and its old parent removed while the
        call ran: v2 -ENOENT (once with the clusters already moved), v3
        completes;
      - store through a shared mapping into a never written range of the
        destination during the padding, then a failure after or during
        write back: v2 lost the stored data, v3 keeps it; the old data of
        that range stays hidden in both; the entry no longer carries a
        larger valid_size after a failed padding;
      - unlinked destination: v2 lost the source, v3 -ENOENT with the
        source intact; the new fstests case fails on a kernel without
        the check;
      - modify event on the source when unlinking it fails: received.
    - Builds without warnings with W=1 for arm64 (gcc, clang), arm and
      i386, built-in and as a module; no new sparse warnings.
    - Functional tests on 4 KiB clusters (including an already unlinked
      source and a remount), Landlock, permission, dead parent and mount
      point tests passed on the intermediate v3 kernels; fstests exfat/001
      and exfat/002, with the new cases for a read-only and an unlinked
      destination, pass on the final one.
    - Not rerun for v3: the long-running tests reported for v2 (power cut
      x30, files around 4 GiB, latency, KASAN, fstests -g quick).  v3 adds
      checks made before anything is changed and changes the failure paths,
      which the targeted tests above cover; the successful path writes the
      same on-disk sequence as in v2.
    
    [1] https://sashiko.dev/#/patchset/20261122124029.609636-1-shaopei_1012%40163.com
    
    v2: https://lore.kernel.org/all/20261122124029.609636-1-shaopei_1012@163.com/
    v1: https://lore.kernel.org/all/20261121174315.500249-1-shaopei_1012@163.com/

 .../userspace-api/ioctl/ioctl-number.rst      |   1 +
 fs/exfat/file.c                               | 598 ++++++++++++++++++
 include/uapi/linux/exfat.h                    |  47 ++
 3 files changed, 646 insertions(+)

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
index c7991e9..f7bed4d 100644
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
@@ -690,6 +692,600 @@ static int exfat_ioctl_set_volume_label(struct super_block *sb,
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
+ * Find the last cluster of @dst, walking only the clusters it owns.  A
+ * crash during an earlier call can have left the last one linked to @src,
+ * which is rewritten anyway, or, once the entry of @dst was written too,
+ * @src among them until fsck.exfat has run.  Refuse the latter, as
+ * linking @src again would create a loop in the FAT.
+ */
+static int exfat_combine_find_last(struct super_block *sb,
+				   struct exfat_chain *chain,
+				   unsigned int src_start, unsigned int *last)
+{
+	struct buffer_head *bh = NULL;
+	unsigned int clu = chain->dir, next, n;
+	int err = 0;
+
+	if (chain->flags == ALLOC_NO_FAT_CHAIN) {
+		if (src_start >= clu && src_start - clu < chain->size)
+			return -EIO;
+		*last = clu + chain->size - 1;
+		return 0;
+	}
+
+	for (n = 1; ; n++) {
+		if (clu == src_start) {
+			err = -EIO;
+			break;
+		}
+		err = exfat_ent_get(sb, clu, &next, &bh);
+		if (err)
+			break;
+		if (n == chain->size) {
+			if (next != EXFAT_EOF_CLUSTER && next != src_start)
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
+ *    vfs_unlink() once the in-memory state of @src no longer owns the
+ *    clusters.
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
+	err = exfat_combine_find_last(sb, &chain, src_ei->start_clu, &last_clu);
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
+ * unlinked, or an error, -EXDEV if it was moved out of the bind mount it
+ * was opened through.  A rename to another directory is retried.
+ */
+static struct dentry *exfat_combine_start_removing(struct file *src_file,
+						   struct path *parent)
+{
+	struct vfsmount *mnt = src_file->f_path.mnt;
+	struct dentry *dentry = src_file->f_path.dentry;
+	struct dentry *victim;
+	bool dead;
+
+	for (;;) {
+		if (d_unhashed(dentry))
+			return NULL;
+
+		parent->mnt = mnt;
+		parent->dentry = dget_parent(dentry);
+		victim = start_removing_dentry(parent->dentry, dentry);
+		if (!IS_ERR(victim)) {
+			/* As path_connected() does for "..". */
+			if (mnt->mnt_root == mnt->mnt_sb->s_root ||
+			    is_subdir(parent->dentry, mnt->mnt_root))
+				return victim;
+			end_removing(victim);
+			dput(parent->dentry);
+			return ERR_PTR(-EXDEV);
+		}
+
+		/*
+		 * -EINVAL: @src_file was renamed or unlinked meanwhile, which
+		 * is retried, or its parent was removed while it is still in
+		 * there, which only happens when the directory on disk and the
+		 * dcache disagree, e.g. after a media error.
+		 */
+		dead = IS_DEADDIR(d_inode(parent->dentry)) &&
+		       READ_ONCE(dentry->d_parent) == parent->dentry &&
+		       !d_unhashed(dentry);
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
+ * back to @old_size.  Once @dst was written back, the zeroes and any
+ * stores through mmap below @old_size are on disk, so keep them, as
+ * exfat_extend_valid_size() does, after flushing them to the medium
+ * ahead of the entry that covers them.  Otherwise drop its valid and
+ * zeroed size back to @old_valid and @old_zeroed, and unmap that range
+ * so that stores through mmap fault again and extend valid_size.  The
+ * entry is written right away.  Called with the inode and invalidate
+ * locks of @dst held.
+ */
+static void exfat_combine_unpad(struct inode *dst, loff_t old_size,
+				loff_t old_valid, loff_t old_zeroed,
+				bool written)
+{
+	struct exfat_sb_info *sbi = EXFAT_SB(dst->i_sb);
+	struct exfat_inode_info *ei = EXFAT_I(dst);
+	bool shrink = i_size_read(dst) > old_size;
+
+	if (shrink)
+		truncate_setsize(dst, old_size);
+
+	if (written) {
+		if (exfat_get_valid_size(ei) > old_valid)
+			blkdev_issue_flush(dst->i_sb->s_bdev);
+	} else {
+		if (exfat_get_valid_size(ei) > old_valid) {
+			if (old_valid < old_size)
+				unmap_mapping_range(dst->i_mapping, old_valid,
+						    old_size - old_valid, 0);
+			exfat_set_valid_size(ei, old_valid);
+		}
+		if (exfat_get_zeroed_size(ei) > old_zeroed)
+			exfat_set_zeroed_size(ei, old_zeroed);
+	}
+
+	if (shrink) {
+		exfat_truncate(dst);	/* writes the entry */
+	} else {
+		mutex_lock(&sbi->s_lock);
+		if (__exfat_write_inode(dst, inode_needs_sync(dst)))
+			mark_inode_dirty(dst);
+		mutex_unlock(&sbi->s_lock);
+	}
+}
+
+/*
+ * A failed truncate can leave the allocation of a file larger than its
+ * size, or its valid_size above its size.  Refuse such a file before
+ * anything is changed, as padding @dst allocates based on its allocation,
+ * and the valid_size of @src is carried over to @dst.
+ */
+static bool exfat_combine_inode_ok(struct inode *inode)
+{
+	struct exfat_sb_info *sbi = EXFAT_SB(inode->i_sb);
+	struct exfat_inode_info *ei = EXFAT_I(inode);
+	loff_t size = i_size_read(inode);
+
+	return exfat_ondisk_size(inode) == round_up(size, sbi->cluster_size) &&
+	       (ei->start_clu == EXFAT_EOF_CLUSTER) == !size &&
+	       exfat_get_valid_size(ei) <= size;
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
+	bool written = false;
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
+	written = true;
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
+		exfat_combine_unpad(dst, old_size, old_valid, old_zeroed,
+				    written);
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
+			fsnotify_modify(src_file);
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
@@ -702,6 +1298,8 @@ long exfat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		return exfat_ioctl_set_attributes(filp, user_attr);
 	case EXFAT_IOC_SHUTDOWN:
 		return exfat_ioctl_shutdown(inode->i_sb, arg);
+	case EXFAT_IOC_COMBINE:
+		return exfat_ioctl_combine(filp, arg);
 	case FITRIM:
 		return exfat_ioctl_fitrim(inode, arg);
 	case FS_IOC_GETFSLABEL:
diff --git a/include/uapi/linux/exfat.h b/include/uapi/linux/exfat.h
index 46d95b1..a6ebba7 100644
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
+ * that is already unlinked is accepted, an unlinked destination is not
+ * (ENOENT).  If unlinking still fails after the clusters were moved, e.g.
+ * because a security module denies it or the source was moved meanwhile
+ * to a directory it may not be removed from, the source is left as an
+ * empty file and the error is returned.
+ *
+ * Errors are reported even when the device fails only after the
+ * destination was updated.  The clusters may then already belong to the
+ * destination, with the source left as an empty file or already
+ * unlinked; callers can tell from the size of the destination.
+ * Otherwise a failed call leaves both files unchanged.
+ *
+ * A crash during the call may leave both files referencing the appended
+ * clusters.  fsck.exfat resolves this without losing data, but the source
+ * must not be truncated or removed before fsck has run, and combining it
+ * again fails with EIO.
+ */
+struct exfat_combine_args {
+	__s32 src_fd;	/* file whose clusters are moved */
+	__u32 flags;	/* must be zero */
+};
+
 #endif /* _UAPI_LINUX_EXFAT_H */
-- 
2.50.1 (Apple Git-155)

