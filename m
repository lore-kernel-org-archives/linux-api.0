Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B673A1683
	for <linux-api@vger.kernel.org>; Mon, 19 Oct 2026 04:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792383465; cv=none; b=OQtXGJOxKA+8Qep9MpoqNOwKeSpvWIfRPDDrrEWF+Q+ot8LWIo2tfwFJeWOaz/dpPMoikw8tgwKNEHyQNY9uQE/2wQyyLn4ZLZ7tGuUwA0MzwbboNsOOlY4nlr2bp29Z0oudyKu8mlG7qrWYKxvi79XBAbdzZtqmLovNTslCMxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792383465; c=relaxed/simple;
	bh=JZmCNLq1R5ba5sJb0RMd/6IntEEhcwH/VDPNPJnFLBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fGVPC8UuCA4X3NEUUOe/xvk7BYJxGxkovWdvZOPGH7xmp1+tPxnX2iuSdLeuEmwpR/hwJpSyYMFZtxWBSHWKrsZ0M3xTVLsrbyNXADtOSkXbf/Aev/8FDRMOslopTvneB6GVzkgWu/BS+nSefQZ51rmLCAcTmfi1at54XKGGN4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hackers.camp; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hackers.camp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48dfbf48b92so156566f8f.0
        for <linux-api@vger.kernel.org>; Sun, 18 Oct 2026 21:17:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792383458; x=1792988258;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XfcoQomygRwzobtcBlaXJToQo4YE0agbyiVyCGyVveA=;
        b=1vOt7SoaMBf80vzWgVjkbJX/GzbYPs8GrJhe9EElxMnTwXWf8IgqG2urehLi+9xKMc
         TSyE5osovyeR0t5wg/mGge7YEYG3cYf55+G4vkRrpHJXIIF6iObM4/d/g8IKVVDxQ0x0
         r15A+UJW9QcPiufwE1blQSyMVDrjDxgJts6NQrmoGWHmzLxdJ/8z5x3kUN3KhYi4STyp
         J0/37JEBytaQrDSgVVxwNRvkAYlj8iVvQdxf1Br3CfaeN7gI1SJ/osPP/E0VQscKMH33
         WH3WmqpAlxcil7D9br6k/rW02hYSvnCJLF2+LIUAeIKOizwtLLTyGLufjtBP4xZrj300
         /+hQ==
X-Forwarded-Encrypted: i=1; AKwUvBwzeqOV5zKJalFFTc/Yg1M6TEMivXfgMAh03DU0eDnOU/q7rkwJl+EX56HncKsP6SiWI2wT2oXDXtg=@vger.kernel.org
X-Gm-Message-State: AFq9FYJZBEb4/0Cj9LhQUxMH+7xNteW9qwx3fwZhAdxW/qXuUE+bSOfQ
	vubgxm90n3HODceTJVwmlKmo4r9dMvki9OnxfKuu6Xk/FcRtZS9E/sam
X-Gm-Gg: AYBFou3pjQk5WdGTpCW0URWn0lED5Q31Y7LEAVMrrtSKkBZZvUkRFwiawtcZxKM/IVi
	bFEinAX4KBF8RQ4T4s/YNoke/pnJPrXhw2ZvXqoNELu9TwuqmbZhe+yRK0W2q+V4olAor5iHaHC
	B+SXU9KxfSvo1SSzcidH4PDfZZU1PYx+EdwvUdKrKmN9t1xMioth+sVG9HZM52XniUhPvINg/SJ
	Kz2UlYrCrvfO+4xEhTOPe/X5KiBUzy0JG3gBAtkkx2c8EIDT7SFWIPr+bUSzroV+lO2ayrAAeEy
	9OHlPTRsfEenjLKCwSL6MWOnW0WE0kP4uUfJ1dina/nKQ7Q/+mYsIa+zh43UIpLeaDdGBJRYiFA
	SJ6cVYsNG0En6PBSPKm9dRuycEomfiYOl9IUFEm8zQwYeIeN8DmAftxLfDYCAgaFu+HvxQLlb42
	m/nEnd4BfHBvXZA3FXAcerKQF2S1erZJS70OPRtrxTFbkD/tFzlg917KwE1pBdFHtF0XY1uoqpa
	XMTQ2NDQ3dG0TH6vYJLcEYwHOswR/NWr/m/
X-Received: by 2002:a05:6000:238a:b0:48e:f14:62fc with SMTP id ffacd0b85a97d-48e0f146338mr8145416f8f.2.1792383458021;
        Sun, 18 Oct 2026 21:17:38 -0700 (PDT)
Received: from spartian.home ([2a01:cb1c:76:ed00:602f:c5f4:d108:b925])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd500e75sm20090449f8f.42.2026.10.18.21.17.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 21:17:36 -0700 (PDT)
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
Subject: [RFC PATCH 02/18] beamfs: add in-core header and tracepoints
Date: Mon, 19 Oct 2026 06:17:12 +0200
Message-ID: <20261019041728.327785-3-aurelien@hackers.camp>
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

beamfs.h holds the in-core superblock and inode, and the declarations
shared between the translation units.

beamfs_trace.h defines the tracepoints, among them one event per store
into the block tree and one per read of a slot, which the usual event
filters narrow to a single inode.

Assisted-by: LLM
Signed-off-by: Aurelien DESBRIERES <aurelien@hackers.camp>
---
 fs/beamfs/beamfs.h       | 813 +++++++++++++++++++++++++++++++++++++++
 fs/beamfs/beamfs_trace.h | 341 ++++++++++++++++
 2 files changed, 1154 insertions(+)
 create mode 100644 fs/beamfs/beamfs.h
 create mode 100644 fs/beamfs/beamfs_trace.h

diff --git a/fs/beamfs/beamfs.h b/fs/beamfs/beamfs.h
new file mode 100644
index 000000000000..dc01bcdf2f17
--- /dev/null
+++ b/fs/beamfs/beamfs.h
@@ -0,0 +1,813 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * beamfs - resilient filesystem
+ * Based on: Fuchs, Langer, Trinitis - ARCS 2015
+ *
+ * Author: Aurelien DESBRIERES <aurelien@hackers.camp>
+ */
+
+#ifndef _BEAMFS_H
+#define _BEAMFS_H
+
+#include <linux/hashtable.h>
+#include <linux/fs.h>
+#include <linux/fs_context.h>
+#include <linux/types.h>
+#include <linux/mutex.h>
+/*
+ * mempool_t and its operations, for the scratch reserve created at
+ * mount. Included explicitly rather than relied on: the aarch64 build
+ * got it through some other header's chain and the x86 one did not,
+ * which is the kind of thing a second architecture is for.
+ */
+#include <linux/mempool.h>
+/*
+ * sb_bread and mark_buffer_dirty, for the wrappers below and for the
+ * many callers that reach them through this header.
+ */
+#include <linux/buffer_head.h>
+
+/*
+ * On-disk format lives in its own header so the userspace tools can
+ * include it without dragging in kernel types.
+ */
+#include "beamfs_format.h"
+
+struct beamfs_sb_info {
+#ifdef CONFIG_BEAMFS_DEBUG_TREE
+	/*
+	 * Every live indirect pointer, so a store that finds a slot at
+	 * zero where one was recorded is caught where it happens rather
+	 * than counted by fsck twenty seconds later.
+	 */
+	DECLARE_HASHTABLE(s_tc, 14);
+	/*
+	 * The same entries keyed by child, for beamfs_free_block: it asks
+	 * "which slots name this block", and walking the whole table for
+	 * that, once per freed block under s_tc_lock, was 70% of the CPU
+	 * of generic/074 (2026-09-23).
+	 */
+	DECLARE_HASHTABLE(s_tc_child, 14);
+	spinlock_t        s_tc_lock;  /* s_tc, s_tc_child, s_tc_entries */
+	unsigned int      s_tc_entries;
+	unsigned int      s_tc_violations;
+#endif
+	/* Block allocator */
+	unsigned long    *s_block_bitmap;  /* In-memory free block bitmap */
+
+	/*
+	 * Scratch pages for decode and encode, reserved at mount.
+	 *
+	 * Every path that touches a block needs one: a lookup decodes a
+	 * directory block, writeback decodes before it re-encodes, the
+	 * sweep decodes what it checks. They were kmalloc'd per call --
+	 * a ten-block directory meant ten allocations to resolve one name
+	 * -- and under memory pressure that turns a path which must not
+	 * block into one that does. generic/558 had twelve tasks in
+	 * uninterruptible sleep and one was in kfree beneath
+	 * beamfs_lookup.
+	 *
+	 * A mempool never returns NULL for GFP_NOFS and does not wait
+	 * while it holds a free element. Thirty-two 4 KiB elements, 128 KiB
+	 * per mount, against a class of stall that only appears when the
+	 * machine is already in trouble -- which is exactly when a
+	 * filesystem has to keep working.
+	 */
+	mempool_t        *s_scratch_pool;
+	/*
+	 * Pages for encoded data blocks on their way to the device, so
+	 * writeback never encodes through the block device cache and
+	 * never holds a buffer lock. Sixty-four is two full bios; a
+	 * flusher that finds the pool empty submits what it holds and
+	 * waits for its own pages to come back.
+	 */
+	mempool_t        *s_wb_pages;
+	/*
+	 * Staging for the superblock's RS encode, allocated at mount.
+	 *
+	 * beamfs_dirty_super_now used to kvmalloc it on every call, and
+	 * beamfs_free_block calls that under s_lock -- a spinlock. An
+	 * allocation that sleeps under a spinlock is a deadlock waiting
+	 * for a machine busy enough, and DEBUG_ATOMIC_SLEEP found it on
+	 * the first generic/076 after it was turned on: "BUG: sleeping
+	 * function called from invalid context", rm holding three locks.
+	 *
+	 * 2769 bytes a mount against an allocation on every block freed.
+	 * Written under s_lock, which every caller of dirty_super_now
+	 * already holds or takes.
+	 */
+	u8               *s_sb_rs_staging;
+	/*
+	 * Bumped by every indirect-parity update.
+	 *
+	 * The per-cpu decode cache in indparity.c keys on it: a cached
+	 * decode from before an update describes a region that has
+	 * changed since, and one counter for the filesystem is enough --
+	 * a redundant decode costs what it was going to cost anyway,
+	 * while a stale hit would report a block as sound that is not.
+	 */
+	atomic64_t        s_ind_parity_gen;
+	unsigned long     s_nblocks;       /* Number of data blocks */
+	unsigned long     s_data_start;    /* First data block number */
+	/* Inode allocator */
+	unsigned long    *s_inode_bitmap;  /* In-memory free inode bitmap */
+	unsigned long     s_ninodes;       /* Total number of inodes */
+	/* Superblock */
+	struct beamfs_super_block *s_beamfs_sb; /* On-disk superblock copy */
+	struct buffer_head       *s_sbh;      /* Buffer head for superblock */
+	/* Array of K bhs; K = s_bitmap_blocks_count (multi-block bitmap). */
+	struct buffer_head      **s_bitmap_blkhs;
+	u32                       s_bitmap_blocks_count;
+
+	/*
+	 * Which bitmap blocks need their on-disk image rebuilt.
+	 *
+	 * Rebuilding means walking 3824 bytes bit by bit out of the
+	 * in-memory bitmap and running sixteen RS encodes over the result.
+	 * Doing that per allocation cost one full re-encode per data block
+	 * touched -- measured at 25264 rebuilds for 25264 allocations, and
+	 * a second RS pass over the superblock alongside it, so two
+	 * metadata encodes for every block of payload. Writing 800 MiB
+	 * meant 220000 of each.
+	 *
+	 * The bit itself is what changed; the codeword only has to be
+	 * right when the buffer reaches the disk. Marking here and
+	 * rebuilding in sync_fs collapses thousands of rebuilds into one
+	 * per block that was actually touched.
+	 *
+	 * s_super_needs_encode is the superblock's equivalent, but the
+	 * superblock is not deferred: the flusher can write its buffer at
+	 * any time, so beamfs_dirty_super rebuilds it at once and the flag
+	 * stays clear.
+	 */
+	unsigned long            *s_bitmap_needs_encode;
+	/*
+	 * Metadata buffers the whole volume shares: bitmap blocks and
+	 * indirect parity regions. One list for all of them, never an
+	 * inode's. A buffer that moves between per-inode lists meets the
+	 * window in mmb_sync where b_mmb is NULL under one inode's lock
+	 * while mmb_mark_buffer_dirty, under another inode's lock, relinks
+	 * the same b_assoc_buffers: list_del corruption, then a soft lockup
+	 * holding mmb->lock (dbench, generic/241, x86-01, 2026-10-15).
+	 * write_inode, sync_inode_metadata and evict sync this list before
+	 * the inode's own; put_super empties it before releasing them.
+	 */
+	struct mapping_metadata_bhs s_shared_bhs;
+	bool                      s_super_needs_encode;
+	spinlock_t                s_lock;     /* Superblock lock */
+
+	/*
+	 * Set once the volume has failed, and never cleared.
+	 *
+	 * A filesystem whose device has gone away must stop writing to
+	 * it. Without this, beamfs kept marking buffers dirty on a device
+	 * that answered every request with EIO -- and the kernel says so:
+	 * mark_buffer_dirty starts with WARN_ON_ONCE(!buffer_uptodate),
+	 * because a buffer that could not be read holds nothing worth
+	 * writing back. generic/338 replaces the device with dm-error and
+	 * watches for exactly that.
+	 *
+	 * Checking buffer_uptodate at each of the thirty-nine
+	 * mark_buffer_dirty sites would silence the warning and treat the
+	 * symptom. The volume is what failed, so the volume is what
+	 * records it: one flag, tested where writes begin, and the mount
+	 * goes read-only so the VFS stops sending more.
+	 */
+	bool                      s_failed;
+	/* Found MOUNTED or ERRORS set at mount: the last mount did not end well. */
+	bool                      s_unclean;
+	unsigned long             s_free_blocks;
+	unsigned long             s_free_inodes;
+
+	/*
+	 * Where the last allocation landed.
+	 *
+	 * find_first_bit scans from zero every time, so the cost of an
+	 * allocation grows with how full the volume is and filling one is
+	 * quadratic. Measured: 240 writes/s on an empty volume, 17 on a
+	 * mostly full one, a fifteenfold fall that made generic/015 and
+	 * generic/074 exceed a twenty-minute timeout.
+	 *
+	 * Resuming from the last position makes the common case -- a
+	 * sequential writer -- constant time. Wrapping to zero on the
+	 * first miss keeps it exhaustive, so a volume with a hole near
+	 * the start still fills completely.
+	 *
+	 * ext2 has done this since 1993 and calls it the goal.
+	 */
+	unsigned long             s_alloc_goal;
+	/*
+	 * Reservation windows of the inodes being written, under s_lock:
+	 * ext2's rsv_window. Each writer allocates inside its own
+	 * interval and nobody else does, so three files written at once
+	 * come out as three contiguous runs instead of one interleaving.
+	 */
+	struct list_head          s_rsv_windows;
+	/* enum BEAMFS_DATA_PROTECTION_*, cached from on-disk SB */
+	u32                       s_scheme;
+	u64                       s_feat_incompat; /* cached from on-disk SB at mount time */
+	bool                      s_data_csum;      /* DATA_CSUM active, cached at mount */
+	bool                      s_data_selfid;    /* DATA_SELFID active, cached at mount */
+
+	/* Indirection parity, cached from the on-disk superblock. */
+	u64                       s_ind_parity_blk;
+	u32                       s_ind_parity_len;
+	u32                       s_ind_parity_mode;
+
+	/* Error budget region, cached from the superblock. */
+	u64                       s_budget_blk;
+	u32                       s_budget_len;
+
+	/*
+	 * Back-pointer to the VFS superblock.
+	 *
+	 * The sysfs attributes are handed an sb_info and need a
+	 * super_block to read the medium. bd_super used to serve; it was
+	 * removed from struct block_device, and reaching for it through
+	 * the buffer_head was always the long way round for something
+	 * this object could simply hold.
+	 */
+	struct super_block       *s_sb;
+
+	/* Clock anchor, cached and refreshed by the scrubber. */
+	u64                       s_anchor_mono;
+	u64                       s_anchor_real;
+	u32                       s_anchor_quality;
+
+	/* Alert rate limiting, one slot per event class. */
+	unsigned long             s_alert_last[3];
+	u64                       s_alert_last_corrected;
+	u32                       s_alert_rate_limit;
+
+	/*
+	 * Background scrubber.
+	 *
+	 * Correction happens on read, so a block nobody reads accumulates
+	 * upsets until it passes the eight-symbol radius and becomes
+	 * unrecoverable. Cold data is exactly the case this filesystem
+	 * exists for -- an archive on a spacecraft is written once and
+	 * read years later -- so waiting for a reader is waiting for the
+	 * failure.
+	 *
+	 * The thread walks allocated blocks at a bounded rate, decodes
+	 * each, and journals what it finds. A block that needed
+	 * correction is written back whole, under the buffer lock: only
+	 * while its owner still maps it at the same place, only if no
+	 * subblock was beyond correction and the buffer is unchanged
+	 * since the decode, and never on a read-only or frozen volume.
+	 * Each upset is correctable on its own; it is their sum that
+	 * loses data. Blocks reached through the wear map have no known
+	 * owner and are checked and reported, never written.
+	 */
+	struct task_struct       *s_scrub_thread;
+	unsigned int              s_scrub_interval_ms; /* between blocks; 0 = idle */
+	u64                       s_scrub_cursor;      /* next block to visit */
+	u64                       s_scrub_passes;      /* completed sweeps */
+	u64                       s_scrub_blocks;      /* blocks checked */
+	u64                       s_scrub_corrected;   /* blocks with corrections */
+	u64                       s_scrub_uncorrectable;
+
+	/*
+	 * Sweep pacing, closed on what the last sweep found.
+	 *
+	 * The interval was a constant the operator set once, so the
+	 * scrubber consumed the same bandwidth on a volume where nothing
+	 * had been corrected in months as on one correcting steadily. In
+	 * a radiotherapy vault the neutron flux exists only during
+	 * treatment: a fixed rate is both wasteful at night and too slow
+	 * during a session, and it is the one environment this filesystem
+	 * was built for.
+	 *
+	 * s_scrub_base_ms is what the operator asked for and the pace
+	 * returns to when the volume is quiet. s_scrub_last_corrected is
+	 * the correction count at the end of the previous sweep, which is
+	 * all that is needed to know whether this one found more.
+	 */
+	/*
+	 * Where the wear scan has reached, and how many worn blocks the
+	 * last pass over the budget found. The cursor is a block offset
+	 * within the data region, not a byte offset in the budget.
+	 */
+	u64                       s_wear_cursor;
+	u64                       s_wear_visits;
+
+	unsigned int              s_scrub_base_ms;
+	u64                       s_scrub_last_corrected;
+	struct kobject            s_kobj;
+	struct completion         s_kobj_unregister;
+};
+
+/*
+ * In-memory inode info (embedded in VFS inode via container_of)
+ */
+struct beamfs_inode_info {
+	__le64          i_direct[BEAMFS_DIRECT_BLOCKS];
+	__le64          i_indirect;
+	__le64          i_dindirect;
+	__le64          i_tindirect;
+	__u32           i_flags;
+	/*
+	 * Whether i_blocks holds the count of the blocks the inode has on
+	 * the medium. The inode does not store it: beamfs_getattr takes it
+	 * from the tree the first time, beamfs_alloc_block and
+	 * beamfs_free_block keep it from then on. Set under i_alloc_mutex,
+	 * with a release; beamfs_getattr reads it without, with an acquire.
+	 */
+	bool            i_blocks_counted;
+	struct mutex    i_alloc_mutex;  /* serialize lookup_or_alloc_phys */
+	/*
+	 * This inode's reservation window, [i_rsv_start, i_rsv_end), on
+	 * s_rsv_windows while it holds one; i_rsv_next is the first block
+	 * of it not yet handed out, i_rsv_size what the next window asks
+	 * for, i_last_alloc the goal. All under s_lock, none on the disk.
+	 */
+	struct list_head i_rsv_list;
+	unsigned long    i_rsv_start;
+	unsigned long    i_rsv_end;
+	unsigned long    i_rsv_next;
+	unsigned int     i_rsv_size;
+	unsigned long    i_last_alloc;
+	/*
+	 * Metadata buffer_heads owned by this inode (bitmap blocks dirtied
+	 * on its behalf). The kernel replaced the old i_data.i_private_list
+	 * mechanism, along with mark_buffer_dirty_inode() and
+	 * invalidate_inode_buffers(), with this per-inode list and the
+	 * mmb_* helpers; ext2 carries the same field as i_metadata_bhs.
+	 */
+	struct mapping_metadata_bhs i_metadata_bhs;
+	struct inode    vfs_inode;  /* Must be last */
+};
+
+static inline struct beamfs_inode_info *BEAMFS_I(struct inode *inode)
+{
+	return container_of(inode, struct beamfs_inode_info, vfs_inode);
+}
+
+static inline struct beamfs_sb_info *BEAMFS_SB(struct super_block *sb)
+{
+	return sb->s_fs_info;
+}
+
+/* Function prototypes */
+/* super.c */
+int beamfs_fill_super(struct super_block *sb, struct fs_context *fc);
+
+/* scrub.c */
+int  beamfs_scrub_init(struct super_block *sb);
+void beamfs_scrub_exit(struct super_block *sb);
+int  beamfs_scrub_check_block(struct super_block *sb, u64 phys,
+			      unsigned int *corrected,
+			      struct inode *owner, u64 iblock);
+void beamfs_scrub_stop(struct super_block *sb);
+
+/* file_inline.c */
+int  beamfs_count_blocks(struct inode *inode, u64 *count);
+int  beamfs_inline_lookup_phys(struct inode *inode, u64 iblock_logical,
+			       u64 *phys_out);
+
+/* super.c -- the RS journal */
+/*
+ * beamfs_log_rs_event -- record a Reed-Solomon correction event in the
+ *                       persistent superblock journal.
+ *
+ * @sb:           mounted superblock (sbi must be initialized)
+ * @block_no:     block number where correction occurred, OR a SB
+ *                sub-block sentinel (see BEAMFS_RS_BLOCK_NO_SB_MARKER)
+ * @positions:    array of byte positions corrected within the codeword.
+ *                MUST be non-NULL when n_positions >= 1, valid for
+ *                n_positions entries. MUST be NULL when n_positions == 0
+ *                (uncorrectable event, see UNCORRECTABLE policy below).
+ * @n_positions:  number of corrections; MUST be in [0, BEAMFS_RS_PARITY/2].
+ *                When >= 1, equals the symbol count and is written
+ *                verbatim into re_symbol_count. When == 0, denotes an
+ *                uncorrectable event (see UNCORRECTABLE policy below).
+ * @code_len_bytes: data length of the codeword that produced @positions
+ *                  (BEAMFS_INODE_RS_DATA for inodes, BEAMFS_SUBBLOCK_DATA
+ *                  for bitmap subblocks, BEAMFS_SB_RS_DATA_LEN for SB
+ *                  subblocks). Required by the entropy estimator to
+ *                  compute the bin index from each byte position.
+ *                  MUST be in [1, BEAMFS_SUBBLOCK_DATA], even for
+ *                  uncorrectable events.
+ *
+ * Forensic policy:
+ *   n_positions >= 2  -> entropy computed, ENTROPY_VALID flag set,
+ *                        re_symbol_count = n_positions
+ *   n_positions == 1  -> entropy zeroed, ENTROPY_VALID cleared,
+ *                        re_symbol_count = 1 (single-sample event is
+ *                        not forensically significant; Family A vs B
+ *                        distinction relies on timestamp clustering
+ *                        for these entries)
+ *   n_positions == 0  -> UNCORRECTABLE flag set, ENTROPY_VALID cleared,
+ *                        re_symbol_count = 0, re_entropy_q16_16 = 0.
+ *                        re_block_no and re_timestamp retain their
+ *                        normal meaning, allowing the entry to
+ *                        participate in temporal and spatial clustering
+ *                        analyses alongside correctable events.
+ *
+ * Computes the Shannon entropy estimate from @positions and stores it
+ * in re_entropy_q16_16 with BEAMFS_RS_EVENT_FLAG_ENTROPY_VALID set
+ * (only when n_positions >= 2; see Forensic policy above).
+ *
+ * Invariants enforced via WARN_ON_ONCE: a call that breaks one is not
+ * journalled, and reserved bits in extra_flags are masked off; nothing
+ * panics. Takes s_lock with spin_lock(), so not for interrupt context.
+ */
+/*
+ * beamfs_log_rs_event_flagged -- variant of beamfs_log_rs_event that
+ * accepts an OR-mask of extra_flags to set on the journal entry in
+ * addition to the policy-derived flags (ENTROPY_VALID, UNCORRECTABLE).
+ *
+ * Used by call sites that can distinguish caller context (e.g.
+ * read path vs RMW-neutralised write path in file_inline.c) and
+ * want that distinction recorded in re_flags. Pass extra_flags = 0
+ * for the legacy behaviour (then beamfs_log_rs_event is the
+ * idiomatic alias).
+ *
+ * extra_flags MUST only contain BEAMFS_RS_EVENT_FLAG_* bits and the
+ * subblock field built by beamfs_rs_event_subblock_bits().
+ * ENTROPY_VALID and UNCORRECTABLE are reserved for the policy and MUST
+ * NOT appear in extra_flags (WARN_ON_ONCE enforces).
+ */
+void beamfs_log_rs_event_flagged(struct super_block *sb,
+				 u64 block_no,
+			const u8 *positions,
+			unsigned int n_positions,
+			size_t code_len_bytes,
+			u32 extra_flags);
+
+void beamfs_log_rs_event(struct super_block *sb,
+			 u64 block_no,
+			const u8 *positions,
+			unsigned int n_positions,
+			size_t code_len_bytes);
+void beamfs_dirty_super(struct beamfs_sb_info *sbi);
+
+/* file.c - BEAMFS_DATA_PROTECTION_UNIVERSAL_INLINE data path (v2) */
+extern const struct address_space_operations beamfs_inline_aops;
+extern const struct file_operations          beamfs_inline_file_operations;
+
+/* inode.c */
+struct inode *beamfs_iget(struct super_block *sb, unsigned long ino);
+int beamfs_getattr(const struct mnt_idmap *idmap, const struct path *path,
+		   struct kstat *stat, u32 request_mask,
+		   unsigned int query_flags);
+/* namei.c */
+struct inode *beamfs_new_inode(struct inode *dir, umode_t mode);
+
+/* dir.c */
+extern const struct file_operations beamfs_dir_operations;
+
+/* namei.c */
+extern const struct inode_operations beamfs_dir_inode_operations;
+extern const struct inode_operations beamfs_symlink_inode_operations;
+
+/* Directory block resolver (defined in namei.c). */
+int beamfs_dir_get_block(struct inode *dir, unsigned int block_idx,
+			 bool alloc, u64 *out_block);
+
+/* file.c */
+extern const struct file_operations beamfs_file_operations;
+/* S2.2: fiemap support shared by both schemes (file.c). */
+int beamfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
+		  u64 start, u64 len);
+extern const struct inode_operations beamfs_file_inode_operations;
+extern const struct address_space_operations beamfs_aops;
+
+/* file_inline.c -- getattr, setattr and fiemap for inline-path regular files */
+extern const struct inode_operations beamfs_inline_inode_operations;
+
+/* edac.c */
+int beamfs_rs_init_tables(void);
+void beamfs_rs_exit_tables(void);
+__u32 beamfs_crc32(const void *buf, size_t len);
+
+/*
+ * beamfs_inode_crc -- checksum over everything the inode's parity
+ * protects, which is the head and the pointers but not i_crc32 itself.
+ *
+ * Staged into a contiguous buffer: the covered bytes are not contiguous
+ * on disk, and computing over them in two calls would need a seeded
+ * primitive that beamfs_crc32 does not offer. 168 bytes on the stack,
+ * once per inode read or write.
+ */
+static inline __u32 beamfs_inode_crc(const struct beamfs_inode *raw)
+{
+	__u8 staging[BEAMFS_INODE_CRC_BYTES];
+
+	memcpy(staging, raw, BEAMFS_INODE_CRC_HEAD_LEN);
+	memcpy(staging + BEAMFS_INODE_CRC_HEAD_LEN,
+	       (const __u8 *)raw + BEAMFS_INODE_CRC_TAIL_OFF,
+	       BEAMFS_INODE_CRC_TAIL_LEN);
+	return beamfs_crc32(staging, sizeof(staging));
+}
+
+/*
+ * beamfs_data_selfid -- 64-bit identity digest of (ino, iblock), stored in
+ * the block descriptor when DATA_SELFID is active. Two independent CRC32s,
+ * one per dimension, concatenated: reuses the single hashing primitive
+ * already backing i_crc32, s_crc32 and DATA_CSUM rather than introducing a
+ * second algorithm for an auditor to review. Collision probability 2^-64.
+ */
+static inline __u64 beamfs_data_selfid(__u64 ino, __u64 iblock)
+{
+	__le64 a = cpu_to_le64(ino);
+	__le64 b = cpu_to_le64(iblock);
+	__u32  lo = beamfs_crc32(&a, sizeof(a));
+	__u32  hi = beamfs_crc32(&b, sizeof(b));
+
+	return ((__u64)hi << 32) | lo;
+}
+
+__u32 beamfs_crc32_sb(const struct beamfs_super_block *fsb);
+int beamfs_rs_encode(u8 *data, size_t len, u8 *parity);
+
+/*
+ * beamfs_rs_decode -- decode and correct a shortened RS(255,239)
+ *                    codeword in place, optionally exposing the
+ *                    list of corrected byte positions for entropy.
+ *
+ * @data:         data bytes, corrected in place on success
+ * @len:          number of data bytes (must match the encode call)
+ * @parity:       parity bytes (BEAMFS_RS_PARITY)
+ * @positions:    optional output, BEAMFS_RS_PARITY/2 = 8 entries; on a
+ *                positive return holds the corrected DATA byte
+ *                positions, in [0, len). Corrections that fell in the
+ *                parity are not listed. May be NULL if the caller does
+ *                not need the position list (no entropy logging).
+ * @max_positions: capacity of @positions in entries; ignored if NULL.
+ *
+ * Returns:
+ *   < 0  uncorrectable (-EBADMSG) or invalid input (-EINVAL)
+ *   = 0  no errors detected
+ *   > 0  number of symbol errors corrected in place, data and parity
+ *
+ * The return value is therefore not the number of entries in
+ * @positions when a parity symbol was among those corrected; the
+ * entropy estimator must only be given the data positions.
+ */
+int beamfs_rs_decode(u8 *data, size_t len, u8 *parity,
+		     u8 *positions, unsigned int max_positions,
+		     const char *who);
+
+/*
+ * Shannon entropy estimator for the RS journal.
+ *
+ * @positions:       byte positions corrected (output of beamfs_rs_decode)
+ * @n_positions:     number of valid entries in @positions, in [1, 8]
+ * @code_len_bytes:  data length of the codeword, in [n_positions, 239]
+ *
+ * Returns H in Q16.16, range [0, 3*65536). Deterministic, no FPU,
+ * no runtime division except for bin index computation. Backed by a
+ * compile-time LUT, defined in edac.c.
+ *
+ * Pre: positions != NULL, 1 <= n_positions <= BEAMFS_RS_PARITY/2
+ *      code_len_bytes >= n_positions
+ */
+__u32 beamfs_rs_compute_entropy_q16_16(const u8 *positions,
+				       unsigned int n_positions,
+				      size_t code_len_bytes);
+
+/*
+ * How many bytes of a file one block holds.
+ *
+ * 3824 in the alternating layout, where the whole coded area is user
+ * data. 3808 in a capsule, where the last sixteen of it are the
+ * descriptor -- the csum and the selfid, moved inside the codewords so
+ * a burst cannot condemn a block whose data is intact.
+ *
+ * Every place that turns a file offset into a block number goes
+ * through this. Writing the constant instead reads a file back shifted
+ * by sixteen bytes on a capsule volume, silently: measured on a live
+ * volume as eight megabytes in and a different md5sum out, with every
+ * check green.
+ */
+static inline u32 beamfs_block_payload(struct super_block *sb)
+{
+	if (BEAMFS_SB(sb)->s_feat_incompat &
+	    BEAMFS_FEATURE_INCOMPAT_RS_INTERLEAVE)
+		return BEAMFS_CAPSULE_DATA_BYTES;
+
+	return BEAMFS_DATA_INLINE_BYTES;
+}
+
+/*
+ * Lay a data block's payload down, stamp its descriptor and seal it,
+ * in that order and in the volume's layout. Defined in file_inline.c.
+ *
+ * Shared because a symlink's target is a data block written from
+ * namei.c, and it followed the alternating layout on a capsule volume
+ * until generic/360 read back an empty path.
+ */
+void beamfs_lay_data_payload(struct super_block *sb, u8 *block,
+			     const u8 *payload);
+int  beamfs_seal_data_block(struct super_block *sb, u8 *block);
+void beamfs_stamp_data_block(struct super_block *sb, u8 *block,
+			     const u8 *payload, u64 ino, u64 iblock);
+
+int beamfs_rs_encode_block(u8 *block);
+int beamfs_rs_decode_block(u8 *block, int *results, const char *who);
+void beamfs_block_read(const u8 *block, size_t off, size_t len, u8 *out);
+void beamfs_block_write(u8 *block, size_t off, size_t len, const u8 *in);
+int beamfs_rs_encode_woven(u8 *data_buf, u8 *parity_buf,
+			   size_t parity_stride, size_t data_len,
+			   unsigned int n_subblocks);
+int beamfs_rs_decode_woven(u8 *data_buf, u8 *parity_buf,
+			   size_t parity_stride, size_t data_len,
+			   unsigned int n_subblocks, int *results,
+			   const char *who);
+/*
+ * Encode/decode N RS(255,239) shortened subblocks across a region.
+ * data and parity may live in the same buffer (alternating layout,
+ * like the bitmap) or in two separate buffers (contiguous-parity
+ * layout, like the superblock). The strides decouple the two cases.
+ *
+ * The decode helper additionally exposes per-subblock corrected
+ * position lists for entropy logging. Each subblock writes up to
+ * positions_stride entries into positions_buf at offset
+ * i * positions_stride; results[i] holds beamfs_rs_decode's return
+ * for that subblock, which also counts corrections in the parity
+ * that the list leaves out.
+ *
+ * positions_buf may be NULL (and positions_stride == 0) if the caller
+ * does not need entropy logging for any of the subblocks.
+ */
+int beamfs_rs_encode_region(u8 *data_buf, size_t data_stride,
+			    u8 *parity_buf, size_t parity_stride,
+			   size_t data_len, unsigned int n_subblocks);
+int beamfs_rs_decode_region(u8 *data_buf, size_t data_stride,
+			    u8 *parity_buf, size_t parity_stride,
+			   size_t data_len, unsigned int n_subblocks,
+			   int *results,
+			   u8 *positions_buf,
+			   unsigned int positions_stride,
+			    const char *who);
+
+/* alloc.c */
+int  beamfs_setup_bitmap(struct super_block *sb);
+void beamfs_bitmap_encode_pending(struct super_block *sb);
+/* super.c */
+void beamfs_super_encode_pending(struct beamfs_sb_info *sbi);
+void beamfs_dirty_super_now(struct beamfs_sb_info *sbi);
+/* alloc.c */
+int  beamfs_write_bitmap_block(struct super_block *sb,
+			       unsigned long bit_global,
+			       struct inode *owner);
+void beamfs_destroy_bitmap(struct super_block *sb);
+u64  beamfs_alloc_block(struct super_block *sb, struct inode *owner);
+void beamfs_rsv_init(struct beamfs_inode_info *fi);
+void beamfs_rsv_discard(struct inode *inode);
+void beamfs_free_block(struct super_block *sb, u64 block, struct inode *owner);
+bool beamfs_block_is_allocated(struct super_block *sb, u64 block);
+/* super.c */
+/*
+ * beamfs_free_ind_range -- free part or all of an indirection subtree.
+ *
+ * @depth: 1 = pointers are data blocks, 2 = single-indirect blocks,
+ *         3 = double-indirect blocks.
+ * @base:  logical index of the first data block the subtree covers.
+ * @first: logical index from which to free; everything below survives.
+ *
+ * Returns true when the subtree ended up empty and @blk was freed with
+ * it, false when something survived and @blk was kept.
+ */
+bool beamfs_free_ind_range(struct super_block *sb, u64 blk,
+			   unsigned int depth, u64 base, u64 first,
+			   struct inode *inode);
+
+/* indparity.c */
+void beamfs_ind_parity_update(struct super_block *sb, struct buffer_head *bh,
+			      struct inode *inode);
+int  beamfs_ind_parity_verify(struct super_block *sb, struct buffer_head *bh);
+int  beamfs_ind_parity_verify_medium(struct super_block *sb, struct buffer_head *bh);
+/*
+ * An indirect block whose copy in memory has been checked against its
+ * parity, or written by us with the parity filed: ext4's
+ * buffer_verified. Set once per life of the buffer, so a pointer
+ * lookup does not decode sixteen codewords of the parity region each
+ * time -- 19 % of the CPU of generic/074 (2026-09-23), because the
+ * decode cache was keyed on a counter every parity update bumped.
+ */
+#define BH_BeamfsVerified BH_PrivateStart
+BUFFER_FNS(BeamfsVerified, beamfs_verified)
+void beamfs_ind_parity_touched(struct beamfs_sb_info *sbi);
+void beamfs_ind_parity_cache_free(void);
+
+#ifdef CONFIG_BEAMFS_DEBUG_TREE
+void beamfs_tc_init(struct beamfs_sb_info *sbi);
+void beamfs_tc_exit(struct beamfs_sb_info *sbi);
+void beamfs_tc_store(struct super_block *sb, unsigned long ino, u64 parent,
+		     u32 slot, u64 old, u64 child, const char *who);
+void beamfs_tc_clear(struct super_block *sb, u64 parent, u32 slot);
+void beamfs_tc_zeroed(struct super_block *sb, unsigned long ino, u64 parent,
+		      const char *who);
+void beamfs_tc_forget_child(struct super_block *sb, u64 child);
+void beamfs_tc_forget_parent(struct super_block *sb, u64 parent);
+#else
+static inline void beamfs_tc_init(struct beamfs_sb_info *sbi) { }
+static inline void beamfs_tc_exit(struct beamfs_sb_info *sbi) { }
+static inline void beamfs_tc_store(struct super_block *sb, unsigned long ino,
+				   u64 parent, u32 slot, u64 old, u64 child,
+				   const char *who) { }
+static inline void beamfs_tc_clear(struct super_block *sb, u64 parent,
+				   u32 slot) { }
+static inline void beamfs_tc_zeroed(struct super_block *sb, unsigned long ino,
+				    u64 parent, const char *who) { }
+static inline void beamfs_tc_forget_child(struct super_block *sb, u64 child) { }
+static inline void beamfs_tc_forget_parent(struct super_block *sb, u64 parent) { }
+#endif
+
+/* Scratch pages, from the mount's reserve. Never NULL under GFP_NOFS. */
+void *beamfs_scratch_get(struct super_block *sb);
+void  beamfs_scratch_put(struct super_block *sb, void *p);
+
+/*
+ * Record that the volume has failed and take it read-only.
+ *
+ * Safe to call more than once and from any context; the first caller
+ * logs, the rest are ignored.
+ */
+void beamfs_fail(struct super_block *sb, const char *where, int err);
+
+/*
+ * sb_bread, and mark the volume failed when it comes back empty.
+ *
+ * Forty-seven sites read blocks and each handles its own NULL with an
+ * EIO. That is right locally and blind globally: nothing recorded that
+ * the device had stopped answering, so the next write went ahead and
+ * dirtied a buffer nobody could read -- the WARN_ON_ONCE inside
+ * mark_buffer_dirty, which generic/338 provokes with dm-error.
+ *
+ * One wrapper, so a read that fails is a volume that has failed. What a
+ * failed volume refuses is listed in beamfs_fail.
+ */
+static inline struct buffer_head *beamfs_bread(struct super_block *sb,
+					       sector_t block,
+					       const char *where)
+{
+	struct buffer_head *bh = sb_bread(sb, block);
+
+	if (!bh)
+		beamfs_fail(sb, where, -EIO);
+	return bh;
+}
+
+/* Has the volume already failed? Writes must not start if it has. */
+static inline bool beamfs_failed(struct super_block *sb)
+{
+	struct beamfs_sb_info *sbi = BEAMFS_SB(sb);
+
+	return sbi && READ_ONCE(sbi->s_failed);
+}
+
+/* dirent.c -- variable-length directory entries, and parity over them */
+u32  beamfs_dirent_place(u32 off, u16 len);
+u32  beamfs_dirent_next(const struct beamfs_dir_entry *de, u32 off);
+bool beamfs_dirent_valid(const struct beamfs_dir_entry *de, u32 off);
+void beamfs_dirent_encode(struct buffer_head *bh);
+int  beamfs_dirent_decode(struct super_block *sb, struct buffer_head *bh,
+			  u8 *dst);
+/* file_inline.c */
+int  beamfs_inline_decode_symlink(struct super_block *sb,
+				  struct buffer_head *bh, u64 phys,
+				  struct inode *inode, u8 *dst, u32 len);
+
+/* alert.c -- uevent on threshold crossing */
+enum {
+	BEAMFS_ALERT_UNCORRECTABLE = 0,
+	BEAMFS_ALERT_MARGIN,
+	BEAMFS_ALERT_RATE,
+	BEAMFS_ALERT_CLASSES
+};
+
+void beamfs_alert_uncorrectable(struct super_block *sb, u64 phys);
+void beamfs_alert_margin(struct super_block *sb, u64 phys, unsigned int used);
+void beamfs_alert_check_rate(struct super_block *sb);
+
+/* clock.c -- anchoring the journal's monotonic stamps to a date */
+void beamfs_clock_anchor(struct super_block *sb);
+u64  beamfs_clock_to_real(struct beamfs_sb_info *sbi, u64 mono);
+
+/* budget.c -- per-block correction margin */
+void beamfs_budget_record(struct super_block *sb, u64 phys,
+			  unsigned int symbols);
+u8   beamfs_budget_read(struct super_block *sb, u64 phys);
+void beamfs_budget_histogram(struct super_block *sb, u64 *hist);
+u64  beamfs_budget_next_worn(struct super_block *sb, u64 from, u8 threshold);
+
+/* rsbench.c -- codec cost, no block layer underneath */
+void beamfs_debugfs_init(void);
+void beamfs_debugfs_exit(void);
+
+/* alloc.c -- inode numbers */
+u64  beamfs_alloc_inode_num(struct super_block *sb);
+void beamfs_free_inode_num(struct super_block *sb, u64 ino);
+
+/* dir.c */
+struct dentry *beamfs_lookup(struct inode *dir, struct dentry *dentry,
+			     unsigned int flags);
+
+/* namei.c */
+int beamfs_write_inode(struct inode *inode, struct writeback_control *wbc);
+int beamfs_write_inode_raw(struct inode *inode);
+
+#endif /* _BEAMFS_H */
diff --git a/fs/beamfs/beamfs_trace.h b/fs/beamfs/beamfs_trace.h
new file mode 100644
index 000000000000..618313a066c1
--- /dev/null
+++ b/fs/beamfs/beamfs_trace.h
@@ -0,0 +1,341 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM beamfs
+
+#if !defined(_BEAMFS_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _BEAMFS_TRACE_H
+
+#include <linux/tracepoint.h>
+#include <linux/kdev_t.h>
+
+/*
+ * One event per store into the block tree, and one per read of a slot.
+ * Filterable in the usual way -- echo 'ino == 60' > filter -- so a run
+ * can be narrowed to the inode that leaked without rebuilding anything.
+ */
+TRACE_EVENT(beamfs_slot_store,
+	TP_PROTO(dev_t dev, unsigned long ino, u64 parent, u64 slot, u64 old, u64 new,
+		 unsigned int level),
+	TP_ARGS(dev, ino, parent, slot, old, new, level),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned long, ino)
+		__field(u64, parent)
+		__field(u64, slot)
+		__field(u64, old)
+		__field(u64, new)
+		__field(unsigned int, level)
+	),
+	TP_fast_assign(
+		__entry->dev = dev;
+		__entry->ino = ino;
+		__entry->parent = parent;
+		__entry->slot = slot;
+		__entry->old = old;
+		__entry->new = new;
+		__entry->level = level;
+	),
+	TP_printk("dev=%u:%u ino=%lu parent=%llu slot=%llu %llu->%llu lvl=%u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino, __entry->parent, __entry->slot,
+		  __entry->old, __entry->new, __entry->level)
+);
+
+/*
+ * An indirect block read on the allocation path.
+ *
+ * generic/464 has two writers install a pointer into the same slot of
+ * the same indirect block, twenty-five seconds apart, and the second
+ * one reads it as zero: xfs_io writes 23967 into slot 5 of block 36508
+ * at t=2158.33, and a writeback kworker writes 105019 into the same
+ * slot at t=2183.22, with the trace showing 0-> both times. The block
+ * held the first pointer; the second writer did not see it.
+ *
+ * @uptodate says whether the buffer came back already valid -- a
+ * buffer that had to be read from the medium is one the cache had
+ * dropped, and what comes back is whatever was last written out,
+ * which need not be what the last writer put in memory.
+ *
+ * @slotval is what sits in the slot about to be written, so a read
+ * that returns zero where a pointer was installed shows up here rather
+ * than being inferred from two slot_store events.
+ */
+TRACE_EVENT(beamfs_ind_read,
+	TP_PROTO(dev_t dev, unsigned long ino, u64 blk, unsigned int slot, u64 slotval,
+		 int uptodate, int fresh),
+	TP_ARGS(dev, ino, blk, slot, slotval, uptodate, fresh),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned long, ino)
+		__field(u64, blk)
+		__field(unsigned int, slot)
+		__field(u64, slotval)
+		__field(int, uptodate)
+		__field(int, fresh)
+	),
+	TP_fast_assign(
+		__entry->dev = dev;
+		__entry->ino = ino;
+		__entry->blk = blk;
+		__entry->slot = slot;
+		__entry->slotval = slotval;
+		__entry->uptodate = uptodate;
+		__entry->fresh = fresh;
+	),
+	TP_printk("dev=%u:%u ino=%lu ind=%llu slot=%u val=%llu uptodate=%d fresh=%d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino, __entry->blk, __entry->slot,
+		  __entry->slotval, __entry->uptodate, __entry->fresh)
+);
+
+/*
+ * One parity slot written.
+ *
+ * A region block holds fourteen slots under RS, and several inodes'
+ * indirect blocks land in the same one. generic/464 leaves slots
+ * describing a block that is not the block on the medium -- subblocks
+ * 0..6 with data and no parity, 7..15 with parity and no data, two
+ * states in one slot -- and the question is which writer left what,
+ * and in which order. @nz is how many of the indirect block's pointers
+ * were set when the parity was taken, so a slot can be matched to the
+ * block it was computed from.
+ */
+TRACE_EVENT(beamfs_parity_slot,
+	TP_PROTO(dev_t dev, unsigned long ino, u64 phys, u64 region, unsigned int slot,
+		 unsigned int nz),
+	TP_ARGS(dev, ino, phys, region, slot, nz),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned long, ino)
+		__field(u64, phys)
+		__field(u64, region)
+		__field(unsigned int, slot)
+		__field(unsigned int, nz)
+	),
+	TP_fast_assign(
+		__entry->dev = dev;
+		__entry->ino = ino;
+		__entry->phys = phys;
+		__entry->region = region;
+		__entry->slot = slot;
+		__entry->nz = nz;
+	),
+	TP_printk("dev=%u:%u ino=%lu ind=%llu region=%llu slot=%u ptrs=%u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino, __entry->phys, __entry->region,
+		  __entry->slot, __entry->nz)
+);
+TRACE_EVENT(beamfs_block_alloc,
+	TP_PROTO(dev_t dev, unsigned long ino, u64 blk, unsigned int level),
+	TP_ARGS(dev, ino, blk, level),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned long, ino)
+		__field(u64, blk)
+		__field(unsigned int, level)
+	),
+	TP_fast_assign(
+		__entry->dev = dev;
+		__entry->ino = ino;
+		__entry->blk = blk;
+		__entry->level = level;
+	),
+	TP_printk("dev=%u:%u ino=%lu blk=%llu lvl=%u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino, __entry->blk, __entry->level)
+);
+
+TRACE_EVENT(beamfs_block_free,
+	TP_PROTO(dev_t dev, unsigned long ino, u64 blk, unsigned long site),
+	TP_ARGS(dev, ino, blk, site),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned long, ino)
+		__field(u64, blk)
+		__field(unsigned long, site)
+	),
+	TP_fast_assign(
+		__entry->dev = dev;
+		__entry->ino = ino;
+		__entry->blk = blk;
+		__entry->site = site;
+	),
+	/*
+	 * site names the caller, by its return address.
+	 *
+	 * It was the constant 0 in every one of 56215 frees, so a capture
+	 * could say a block had been freed and never which of the
+	 * twenty-nine call sites did it. That matters here more than
+	 * anywhere: freeing a block whose buffer is still on an inode's
+	 * metadata list is how a later owner's pointers are lost, the
+	 * fix is right for some callers and wrong for others -- applied
+	 * to all of them it turned 58 leaked blocks into 345 -- and
+	 * telling them apart needs the caller's name.
+	 */
+	TP_printk("dev=%u:%u ino=%lu blk=%llu site=%pS",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino, __entry->blk, (void *)__entry->site)
+);
+
+/*
+ * An inode's metadata buffers, written or dropped.
+ *
+ * An indirect block is dirtied and put on the inode's metadata list,
+ * and something has to take it from there to the medium. Two things
+ * can: mmb_sync, from write_inode and from sync_inode_metadata, which
+ * writes them; and mmb_invalidate, from evict_inode, which does not --
+ * it empties the list and the buffers go with whatever they held.
+ *
+ * generic/464 leaves one indirect block per run filled with 0xcd, the
+ * kernel's poison for memory nobody wrote: block 41641 of inode 24 in
+ * one capture, 35433 of inode 65 in the next, each named by its inode
+ * on disk and each never written. Something is taking these buffers
+ * off the list without writing them, and @how says which.
+ *
+ * @n is how many buffers the list held when the call started, so a
+ * sync that finds nothing and an evict that drops four are told apart.
+ */
+TRACE_EVENT(beamfs_mmb,
+	TP_PROTO(dev_t dev, unsigned long ino, const char *how, int n, int err),
+	TP_ARGS(dev, ino, how, n, err),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned long, ino)
+		__string(how, how)
+		__field(int, n)
+		__field(int, err)
+	),
+	TP_fast_assign(
+		__entry->dev = dev;
+		__entry->ino = ino;
+		__assign_str(how);
+		__entry->n = n;
+		__entry->err = err;
+	),
+	TP_printk("dev=%u:%u ino=%lu %s buffers=%d err=%d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino, __get_str(how), __entry->n, __entry->err)
+);
+/*
+ * What a flush of the bitmap found, and what it managed to write.
+ *
+ * The bitmap's blocks are the one place a freed block is recorded, and
+ * 47% of the updates to them are attached to no inode at all -- the
+ * free path passes no owner -- so nothing carries them to the medium
+ * except the flusher, sync_fs and put_super. Those two are static and
+ * inlined, so a kprobe cannot count them and the question "did the
+ * free reach the disk" had no answer from outside.
+ *
+ * @dirty is how many bitmap blocks were dirty when the flush started,
+ * @written how many reached the medium, @err the first failure.
+ */
+TRACE_EVENT(beamfs_bitmap_flush,
+	TP_PROTO(dev_t dev, const char *where, unsigned int dirty,
+		 unsigned int written, int err),
+	TP_ARGS(dev, where, dirty, written, err),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__string(where, where)
+		__field(unsigned int, dirty)
+		__field(unsigned int, written)
+		__field(int, err)
+	),
+	TP_fast_assign(
+		__entry->dev = dev;
+		__assign_str(where);
+		__entry->dirty = dirty;
+		__entry->written = written;
+		__entry->err = err;
+	),
+	TP_printk("dev=%u:%u %s dirty=%u written=%u err=%d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __get_str(where), __entry->dirty, __entry->written,
+		  __entry->err)
+);
+
+TRACE_EVENT(beamfs_write_inode,
+	TP_PROTO(dev_t dev, unsigned long ino, int sync, u64 indirect, int err),
+	TP_ARGS(dev, ino, sync, indirect, err),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned long, ino)
+		__field(int, sync)
+		__field(u64, indirect)
+		__field(int, err)
+	),
+	TP_fast_assign(
+		__entry->dev = dev;
+		__entry->ino = ino;
+		__entry->sync = sync;
+		__entry->indirect = indirect;
+		__entry->err = err;
+	),
+	TP_printk("dev=%u:%u ino=%lu sync=%d i_indirect=%llu err=%d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino, __entry->sync, __entry->indirect, __entry->err)
+);
+
+TRACE_EVENT(beamfs_inode_dirty,
+	TP_PROTO(dev_t dev, unsigned long ino, unsigned long state),
+	TP_ARGS(dev, ino, state),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned long, ino)
+		__field(unsigned long, state)
+	),
+	TP_fast_assign(
+		__entry->dev = dev;
+		__entry->ino = ino;
+		__entry->state = state;
+	),
+	TP_printk("dev=%u:%u ino=%lu state=0x%lx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino, __entry->state)
+);
+
+/*
+ * One event per RS decode that found something, on every path: data
+ * read, RMW transit, directory, bitmap, indirect parity, scrub and
+ * superblock. It is raised in beamfs_log_rs_event_flagged, the one
+ * place every decoder reports to, so a capture misses none of them and
+ * none is rate-limited the way the dmesg lines are. The journal in the
+ * superblock keeps the last sixty-four; this keeps as many as the ring
+ * buffer is sized for.
+ *
+ * @blk is the physical block, the number emufi's flip_log gives as
+ * sector / 8, so a flip and its verdict join on it directly. @sub is
+ * the subblock, -1 when the event has none (a superblock or inode
+ * correction). @symbols is how many the decoder corrected, 0 when it
+ * could not; @flags is re_flags as journalled, so uncorrectable
+ * (BIT(1)), RMW-neutralised (BIT(2)) and inode (BIT(3)) read off it.
+ */
+TRACE_EVENT(beamfs_rs_event,
+	TP_PROTO(dev_t dev, u64 blk, int sub, unsigned int symbols, u32 flags),
+	TP_ARGS(dev, blk, sub, symbols, flags),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(u64, blk)
+		__field(int, sub)
+		__field(unsigned int, symbols)
+		__field(u32, flags)
+	),
+	TP_fast_assign(
+		__entry->dev = dev;
+		__entry->blk = blk;
+		__entry->sub = sub;
+		__entry->symbols = symbols;
+		__entry->flags = flags;
+	),
+	TP_printk("dev=%u:%u blk=%llu sub=%d symbols=%u flags=0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->blk, __entry->sub, __entry->symbols,
+		  __entry->flags)
+);
+
+#endif /* _BEAMFS_TRACE_H */
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE beamfs_trace
+#include <trace/define_trace.h>
-- 
2.55.0

