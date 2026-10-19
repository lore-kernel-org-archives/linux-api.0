Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B9D3C3F64
	for <linux-api@vger.kernel.org>; Mon, 19 Oct 2026 04:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792383491; cv=none; b=LWaPNp35JYkjDX0qi4FapryZQGYn9NsREmg8x9Aer5zqQ0jDI4hNUHa27A9Xg8meLGowXCqsNMukg9IHdXKKgBSp2hSKcHZsV6rc9dcFxvZ4yHuR8hhnptoHbECsazgb7soFl9/lh9twSh0ZTr63ZIRhrdb3qh6eVs6MVlNz1Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792383491; c=relaxed/simple;
	bh=oE5kzAgqLo1likBqsZsbwoH2X9fxEFOOjeWbVvumXjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i2qIwW4x3J7vk9vJ5nFhBOZ6v05Pm3xaRippTfqEuaMVrJpxVq37Q7XQsfDH7MaX4ZRWPAg3I+Oy0pY9w6/YpMVtz4j+WogCMy6f/tnKg6CHRab4GSwkI6EjKT6sK22r3wm2BqHIm2pk8SmbfjkumQzjKiOEIQN8D0a6D/Ws8H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hackers.camp; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hackers.camp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a17ce1dc00so2098455e9.1
        for <linux-api@vger.kernel.org>; Sun, 18 Oct 2026 21:18:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792383483; x=1792988283;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=c+MkjuN+lEsWJZ1kOqNsI5zRWTUQRQd9JZH1J8sAEIU=;
        b=0LGCyswFHwy79wtlMi7u77Y3o/x2W+5fIL9V2NZm4++dxg+yaV16rY2aCWWr03M7F/
         ADb66OOawFw90Fm1StAzuMf+/r4gyLop/eM5fs8AufVeaZtt7H2pUs5Sbbp1T4r9Z2Zp
         ylgqZLZQ8Cg1tWvllAD7Qz2FsvgPkYXTvZwKCBdXM8qpcWHFV8vdSFyG9PtuLwrxIdBP
         ncH8+6F6qmw3KxqcWXCGcvbl0SkNVZyaV+5IWmprscX17OR+B3Fy/jpsgYB/s+J+40se
         IFF3AhEalUKiymQknkKddz3mD8442Hpnk/4HTgF0TbCkDFjVXoHDpUXm3FFjAlAatLrq
         BeCA==
X-Forwarded-Encrypted: i=1; AKwUvBy1AiNJqSW7+qpabzqkE55euslvQCPnG7rurEoH9X9lFo+/V7f2G56LNu4V+7B1JPKqoBTvsu+7BXc=@vger.kernel.org
X-Gm-Message-State: AFq9FYL9af0yGa3+QMhe+dKjHckQJVccx5hnQWa7vnpCyYda+jZO8HSm
	PdL/45gUT6+UUbk3CfhFKCkWRajxQeGpxsi8vRuyRccIxrkz2x8EKuBv
X-Gm-Gg: AYBFou0zhQEIQVl6mqImfa9tHtfPKHQr4MR9L10X5W2jhvWBBNUcJo3ipiqTamZ/a0B
	uYZyaK+W5HrQwTSMUOAaI0LLJYT/1fsfosrDksWp6/0g5suqcLKTQit3DjZWVpYpKIO+0HbkAox
	xhqXEtfZTjbxd4Oq40SfBy6tX4pZ6OrhBZcTC4oH6xSfhv6bJkFFVzuK+nmuAQFcHo5V0wea0Ei
	spNZi4Idy+KxXngGeVJdN6jwInATnWc7vsN9eJrRRjmlSSZGjLSypb2e3szLBzF+5p96qRHlv11
	2W0NdgnztPgH+pHmp/qX0zxF6SXEhc6HODfzMa/sjVvBCPFM0jzRnZRy/6uvt7Ba9c/owmd1uFk
	hZNwBwLblyhF6nwGYAxIDxmL073SO/JRyMyfihRCzs96dR7h2LwmqC54qPhCInTebQGKbckJdta
	PzXI153/0iF2mzIbFdeNEg7T4fkUL+Do21BMTXQFep7LaZH8DmwH+X18jyJRa6NFzLegHIpCY6J
	eh/amSfNnmah5d03T8ikgDY7yYD0gDn/oQ6
X-Received: by 2002:a05:6000:2013:b0:48e:412:3825 with SMTP id ffacd0b85a97d-48e07997862mr10570187f8f.2.1792383483012;
        Sun, 18 Oct 2026 21:18:03 -0700 (PDT)
Received: from spartian.home ([2a01:cb1c:76:ed00:602f:c5f4:d108:b925])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd500e75sm20090449f8f.42.2026.10.18.21.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 21:18:02 -0700 (PDT)
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
Subject: [RFC PATCH 10/18] beamfs: add iomap file operations
Date: Mon, 19 Oct 2026 06:17:20 +0200
Message-ID: <20261019041728.327785-11-aurelien@hackers.camp>
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

file.c holds the file, inode and address_space operations of the
iomap-based path used by the INODE_UNIVERSAL scheme (scheme 5). That
path does not maintain the parity of indirect blocks, so the kernel
refuses to mount the scheme and mkfs.beamfs refuses to format it: on
volumes mkfs.beamfs creates, file data takes the inline path of the
next four patches. inode.c and namei.c choose between the two from the
volume's scheme.

Assisted-by: LLM
Signed-off-by: Aurelien DESBRIERES <aurelien@hackers.camp>
---
 fs/beamfs/file.c | 549 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 549 insertions(+)
 create mode 100644 fs/beamfs/file.c

diff --git a/fs/beamfs/file.c b/fs/beamfs/file.c
new file mode 100644
index 000000000000..553d177e5c31
--- /dev/null
+++ b/fs/beamfs/file.c
@@ -0,0 +1,549 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * beamfs - File operations
+ * Author: roastercode - Aurelien DESBRIERES <aurelien@hackers.camp>
+ */
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/iomap.h>
+#include <linux/pagemap.h>
+#include <linux/buffer_head.h>
+#include <linux/fiemap.h>
+#include "beamfs.h"
+
+/* Forward declaration - defined after iomap_ops */
+static ssize_t beamfs_file_write_iter(struct kiocb *iocb, struct iov_iter *from);
+
+/*
+ * generic_file_fsync() was removed along with sync_mapping_buffers() and
+ * the i_private_list mechanism it drove. Metadata buffer_heads owned by
+ * an inode now live in a per-inode mapping_metadata_bhs list, flushed
+ * through mmb_fsync(); ext2_fsync() has the same shape.
+ */
+static int beamfs_fsync(struct file *file, loff_t start, loff_t end,
+			int datasync)
+{
+	return simple_fsync(file, start, end, datasync);
+}
+
+const struct file_operations beamfs_file_operations = {
+	.llseek         = generic_file_llseek,
+	.read_iter      = generic_file_read_iter,
+	.write_iter     = beamfs_file_write_iter,
+	.mmap           = generic_file_mmap,
+	.fsync          = beamfs_fsync,
+	.splice_read    = filemap_splice_read,
+};
+
+const struct inode_operations beamfs_file_inode_operations = {
+	.getattr        = simple_getattr,
+	.fiemap         = beamfs_fiemap,  /* S2.2: file-precise bench targeting */
+};
+
+/*
+ * beamfs_iomap_begin -- map a file range to disk blocks for iomap.
+ * Handles read (no allocation) and write (allocate on demand).
+ * Supports direct blocks (iblock 0..11) and single indirect
+ * (iblock 12..523, covering up to ~2 MiB per file).
+ */
+static int beamfs_iomap_begin(struct inode *inode, loff_t pos, loff_t length,
+			      unsigned int flags, struct iomap *iomap,
+			     struct iomap *srcmap)
+{
+	struct beamfs_inode_info *fi  = BEAMFS_I(inode);
+	struct super_block      *sb  = inode->i_sb;
+	u64  iblock    = pos >> BEAMFS_BLOCK_SHIFT;
+	u64  new_block;
+	u64  phys;
+
+	iomap->offset = iblock << BEAMFS_BLOCK_SHIFT;
+	iomap->length = BEAMFS_BLOCK_SIZE;
+	iomap->bdev   = sb->s_bdev;
+	iomap->flags  = 0;
+
+	if (iblock < BEAMFS_DIRECT_BLOCKS) {
+		/* --- Direct block --- */
+		phys = le64_to_cpu(fi->i_direct[iblock]);
+		if (phys) {
+			iomap->type = IOMAP_MAPPED;
+			iomap->addr = phys << BEAMFS_BLOCK_SHIFT;
+			return 0;
+		}
+		if (!(flags & IOMAP_WRITE)) {
+			iomap->type = IOMAP_HOLE;
+			iomap->addr = IOMAP_NULL_ADDR;
+			return 0;
+		}
+		new_block = beamfs_alloc_block(sb, inode);
+		if (!new_block) {
+			pr_err("beamfs: iomap: no free blocks\n");
+			return -ENOSPC;
+		}
+		fi->i_direct[iblock] = cpu_to_le64(new_block);
+		mark_inode_dirty(inode);
+		iomap->type = IOMAP_MAPPED;
+		iomap->addr = new_block << BEAMFS_BLOCK_SHIFT;
+		return 0;
+	}
+
+	if (iblock < BEAMFS_DIRECT_BLOCKS + BEAMFS_INDIRECT_PTRS) {
+		/* --- Single indirect block --- */
+		u64 indirect_slot = iblock - BEAMFS_DIRECT_BLOCKS;
+		u64 indirect_blk  = le64_to_cpu(fi->i_indirect);
+		struct buffer_head *ibh;
+		__le64 *ptrs;
+
+		if (!indirect_blk) {
+			if (!(flags & IOMAP_WRITE)) {
+				iomap->type = IOMAP_HOLE;
+				iomap->addr = IOMAP_NULL_ADDR;
+				return 0;
+			}
+			indirect_blk = beamfs_alloc_block(sb, inode);
+			if (!indirect_blk) {
+				pr_err("beamfs: iomap: no free blocks for indirect\n");
+				return -ENOSPC;
+			}
+			ibh = sb_getblk(sb, indirect_blk);
+			if (!ibh) {
+				beamfs_free_block(sb, indirect_blk, inode);
+				return -EIO;
+			}
+			lock_buffer(ibh);
+			memset(ibh->b_data, 0, BEAMFS_BLOCK_SIZE);
+			set_buffer_uptodate(ibh);
+			unlock_buffer(ibh);
+			mark_buffer_dirty(ibh);
+			brelse(ibh);
+			fi->i_indirect = cpu_to_le64(indirect_blk);
+			mark_inode_dirty(inode);
+		}
+
+		ibh = sb_bread(sb, indirect_blk);
+		if (!ibh)
+			return -EIO;
+		ptrs = (__le64 *)ibh->b_data;
+		phys = le64_to_cpu(ptrs[indirect_slot]);
+
+		if (phys) {
+			brelse(ibh);
+			iomap->type = IOMAP_MAPPED;
+			iomap->addr = phys << BEAMFS_BLOCK_SHIFT;
+			return 0;
+		}
+		if (!(flags & IOMAP_WRITE)) {
+			brelse(ibh);
+			iomap->type = IOMAP_HOLE;
+			iomap->addr = IOMAP_NULL_ADDR;
+			return 0;
+		}
+		new_block = beamfs_alloc_block(sb, inode);
+		if (!new_block) {
+			brelse(ibh);
+			pr_err("beamfs: iomap: no free blocks\n");
+			return -ENOSPC;
+		}
+		ptrs[indirect_slot] = cpu_to_le64(new_block);
+		mark_buffer_dirty(ibh);
+		brelse(ibh);
+		iomap->type = IOMAP_MAPPED;
+		iomap->addr = new_block << BEAMFS_BLOCK_SHIFT;
+		return 0;
+	}
+
+	if (iblock < BEAMFS_MAX_IBLOCK_DINDIRECT) {
+		/* --- Double indirect block (scheme=5 iomap path) --- */
+		u64 didx = iblock - BEAMFS_MAX_IBLOCK_INDIRECT;
+		u64 l1_slot = didx / BEAMFS_INDIRECT_PTRS;
+		u64 l2_slot = didx % BEAMFS_INDIRECT_PTRS;
+		u64 dindirect_blk, l1_blk;
+		struct buffer_head *ibh, *l1bh;
+		__le64 *ptrs;
+
+		dindirect_blk = le64_to_cpu(fi->i_dindirect);
+		if (!dindirect_blk) {
+			if (!(flags & IOMAP_WRITE)) {
+				iomap->type = IOMAP_HOLE;
+				iomap->addr = IOMAP_NULL_ADDR;
+				return 0;
+			}
+			dindirect_blk = beamfs_alloc_block(sb, inode);
+			if (!dindirect_blk) {
+				pr_err("beamfs: iomap: no free blocks for dindirect\n");
+				return -ENOSPC;
+			}
+			ibh = sb_getblk(sb, dindirect_blk);
+			if (!ibh) {
+				beamfs_free_block(sb, dindirect_blk, inode);
+				return -EIO;
+			}
+			lock_buffer(ibh);
+			memset(ibh->b_data, 0, BEAMFS_BLOCK_SIZE);
+			set_buffer_uptodate(ibh);
+			unlock_buffer(ibh);
+			mark_buffer_dirty(ibh);
+			brelse(ibh);
+			fi->i_dindirect = cpu_to_le64(dindirect_blk);
+			mark_inode_dirty(inode);
+		}
+
+		ibh = sb_bread(sb, dindirect_blk);
+		if (!ibh)
+			return -EIO;
+		ptrs = (__le64 *)ibh->b_data;
+		l1_blk = le64_to_cpu(ptrs[l1_slot]);
+		if (!l1_blk) {
+			if (!(flags & IOMAP_WRITE)) {
+				brelse(ibh);
+				iomap->type = IOMAP_HOLE;
+				iomap->addr = IOMAP_NULL_ADDR;
+				return 0;
+			}
+			l1_blk = beamfs_alloc_block(sb, inode);
+			if (!l1_blk) {
+				brelse(ibh);
+				pr_err("beamfs: iomap: no free blocks for dindirect L1\n");
+				return -ENOSPC;
+			}
+			l1bh = sb_getblk(sb, l1_blk);
+			if (!l1bh) {
+				beamfs_free_block(sb, l1_blk, inode);
+				brelse(ibh);
+				return -EIO;
+			}
+			lock_buffer(l1bh);
+			memset(l1bh->b_data, 0, BEAMFS_BLOCK_SIZE);
+			set_buffer_uptodate(l1bh);
+			unlock_buffer(l1bh);
+			mark_buffer_dirty(l1bh);
+			brelse(l1bh);
+			ptrs[l1_slot] = cpu_to_le64(l1_blk);
+			mark_buffer_dirty(ibh);
+		}
+		brelse(ibh);
+
+		l1bh = sb_bread(sb, l1_blk);
+		if (!l1bh)
+			return -EIO;
+		ptrs = (__le64 *)l1bh->b_data;
+		phys = le64_to_cpu(ptrs[l2_slot]);
+
+		if (phys) {
+			brelse(l1bh);
+			iomap->type = IOMAP_MAPPED;
+			iomap->addr = phys << BEAMFS_BLOCK_SHIFT;
+			return 0;
+		}
+		if (!(flags & IOMAP_WRITE)) {
+			brelse(l1bh);
+			iomap->type = IOMAP_HOLE;
+			iomap->addr = IOMAP_NULL_ADDR;
+			return 0;
+		}
+		new_block = beamfs_alloc_block(sb, inode);
+		if (!new_block) {
+			brelse(l1bh);
+			pr_err("beamfs: iomap: no free blocks (dindirect data)\n");
+			return -ENOSPC;
+		}
+		ptrs[l2_slot] = cpu_to_le64(new_block);
+		mark_buffer_dirty(l1bh);
+		brelse(l1bh);
+		iomap->type = IOMAP_MAPPED;
+		iomap->addr = new_block << BEAMFS_BLOCK_SHIFT;
+		return 0;
+	}
+
+	if (iblock < BEAMFS_MAX_IBLOCK_TINDIRECT) {
+		/* --- Triple indirect block (scheme=5 iomap path) --- */
+		u64 tidx = iblock - BEAMFS_MAX_IBLOCK_DINDIRECT;
+		u64 l1_slot = tidx / (BEAMFS_INDIRECT_PTRS * BEAMFS_INDIRECT_PTRS);
+		u64 l2_slot = (tidx / BEAMFS_INDIRECT_PTRS) % BEAMFS_INDIRECT_PTRS;
+		u64 l3_slot = tidx % BEAMFS_INDIRECT_PTRS;
+		u64 tindirect_blk, l1_blk, l2_blk;
+		struct buffer_head *ibh, *l1bh, *l2bh;
+		__le64 *ptrs;
+
+		tindirect_blk = le64_to_cpu(fi->i_tindirect);
+		if (!tindirect_blk) {
+			if (!(flags & IOMAP_WRITE)) {
+				iomap->type = IOMAP_HOLE;
+				iomap->addr = IOMAP_NULL_ADDR;
+				return 0;
+			}
+			tindirect_blk = beamfs_alloc_block(sb, inode);
+			if (!tindirect_blk) {
+				pr_err("beamfs: iomap: no free blocks for tindirect\n");
+				return -ENOSPC;
+			}
+			ibh = sb_getblk(sb, tindirect_blk);
+			if (!ibh) {
+				beamfs_free_block(sb, tindirect_blk, inode);
+				return -EIO;
+			}
+			lock_buffer(ibh);
+			memset(ibh->b_data, 0, BEAMFS_BLOCK_SIZE);
+			set_buffer_uptodate(ibh);
+			unlock_buffer(ibh);
+			mark_buffer_dirty(ibh);
+			brelse(ibh);
+			fi->i_tindirect = cpu_to_le64(tindirect_blk);
+			mark_inode_dirty(inode);
+		}
+
+		ibh = sb_bread(sb, tindirect_blk);
+		if (!ibh)
+			return -EIO;
+		ptrs = (__le64 *)ibh->b_data;
+		l1_blk = le64_to_cpu(ptrs[l1_slot]);
+		if (!l1_blk) {
+			if (!(flags & IOMAP_WRITE)) {
+				brelse(ibh);
+				iomap->type = IOMAP_HOLE;
+				iomap->addr = IOMAP_NULL_ADDR;
+				return 0;
+			}
+			l1_blk = beamfs_alloc_block(sb, inode);
+			if (!l1_blk) {
+				brelse(ibh);
+				pr_err("beamfs: iomap: no free blocks for tindirect L1\n");
+				return -ENOSPC;
+			}
+			l1bh = sb_getblk(sb, l1_blk);
+			if (!l1bh) {
+				beamfs_free_block(sb, l1_blk, inode);
+				brelse(ibh);
+				return -EIO;
+			}
+			lock_buffer(l1bh);
+			memset(l1bh->b_data, 0, BEAMFS_BLOCK_SIZE);
+			set_buffer_uptodate(l1bh);
+			unlock_buffer(l1bh);
+			mark_buffer_dirty(l1bh);
+			brelse(l1bh);
+			ptrs[l1_slot] = cpu_to_le64(l1_blk);
+			mark_buffer_dirty(ibh);
+		}
+		brelse(ibh);
+
+		l1bh = sb_bread(sb, l1_blk);
+		if (!l1bh)
+			return -EIO;
+		ptrs = (__le64 *)l1bh->b_data;
+		l2_blk = le64_to_cpu(ptrs[l2_slot]);
+		if (!l2_blk) {
+			if (!(flags & IOMAP_WRITE)) {
+				brelse(l1bh);
+				iomap->type = IOMAP_HOLE;
+				iomap->addr = IOMAP_NULL_ADDR;
+				return 0;
+			}
+			l2_blk = beamfs_alloc_block(sb, inode);
+			if (!l2_blk) {
+				brelse(l1bh);
+				pr_err("beamfs: iomap: no free blocks for tindirect L2\n");
+				return -ENOSPC;
+			}
+			l2bh = sb_getblk(sb, l2_blk);
+			if (!l2bh) {
+				beamfs_free_block(sb, l2_blk, inode);
+				brelse(l1bh);
+				return -EIO;
+			}
+			lock_buffer(l2bh);
+			memset(l2bh->b_data, 0, BEAMFS_BLOCK_SIZE);
+			set_buffer_uptodate(l2bh);
+			unlock_buffer(l2bh);
+			mark_buffer_dirty(l2bh);
+			brelse(l2bh);
+			ptrs[l2_slot] = cpu_to_le64(l2_blk);
+			mark_buffer_dirty(l1bh);
+		}
+		brelse(l1bh);
+
+		l2bh = sb_bread(sb, l2_blk);
+		if (!l2bh)
+			return -EIO;
+		ptrs = (__le64 *)l2bh->b_data;
+		phys = le64_to_cpu(ptrs[l3_slot]);
+
+		if (phys) {
+			brelse(l2bh);
+			iomap->type = IOMAP_MAPPED;
+			iomap->addr = phys << BEAMFS_BLOCK_SHIFT;
+			return 0;
+		}
+		if (!(flags & IOMAP_WRITE)) {
+			brelse(l2bh);
+			iomap->type = IOMAP_HOLE;
+			iomap->addr = IOMAP_NULL_ADDR;
+			return 0;
+		}
+		new_block = beamfs_alloc_block(sb, inode);
+		if (!new_block) {
+			brelse(l2bh);
+			pr_err("beamfs: iomap: no free blocks (tindirect data)\n");
+			return -ENOSPC;
+		}
+		ptrs[l3_slot] = cpu_to_le64(new_block);
+		mark_buffer_dirty(l2bh);
+		brelse(l2bh);
+		iomap->type = IOMAP_MAPPED;
+		iomap->addr = new_block << BEAMFS_BLOCK_SHIFT;
+		return 0;
+	}
+
+	/* Beyond triple indirect: not supported */
+	pr_err_ratelimited("beamfs: iomap: offset beyond tindirect blocks\n");
+	return -EOPNOTSUPP;
+}
+
+static int beamfs_iomap_end(struct inode *inode, loff_t pos, loff_t length,
+			    ssize_t written, unsigned int flags,
+			   struct iomap *iomap)
+{
+	return 0;
+}
+
+static const struct iomap_ops beamfs_iomap_ops = {
+	.iomap_begin = beamfs_iomap_begin,
+	.iomap_end   = beamfs_iomap_end,
+};
+
+/*
+ * S2.2: fiemap support for file-precise bench targeting (TODO.md l.1979).
+ * Thin wrapper over iomap_fiemap() reusing beamfs_iomap_ops. Pattern
+ * follows fs/ext2/inode.c::ext2_fiemap() (kernel 7.0.x). Required by
+ * userspace filefrag(8) to expose the file -> physical block mapping
+ * for beamfs-bench file-level RS-FEC validation.
+ *
+ * Shared by both schemes (UNIVERSAL_INLINE and INODE_UNIVERSAL) since
+ * both use the same direct[12] + indirect[512] block layout, handled
+ * uniformly by beamfs_iomap_begin().
+ */
+int beamfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
+		  u64 start, u64 len)
+{
+	int ret;
+	loff_t i_size;
+
+	inode_lock(inode);
+	i_size = i_size_read(inode);
+	/*
+	 * iomap_fiemap() returns -EINVAL for len == 0. Trim the request to
+	 * the file size but never below 1 to keep the call valid for empty
+	 * files (where it will simply return zero extents).
+	 */
+	if (i_size == 0)
+		i_size = 1;
+	len = min_t(u64, len, i_size);
+	ret = iomap_fiemap(inode, fieinfo, start, len, &beamfs_iomap_ops);
+	inode_unlock(inode);
+	return ret;
+}
+
+/*
+ * Write path - beamfs_iomap_write_ops
+ * get_folio/put_folio use generic helpers (no journaling required).
+ */
+static struct folio *beamfs_iomap_get_folio(struct iomap_iter *iter,
+					    loff_t pos, unsigned int len)
+{
+	return iomap_get_folio(iter, pos, len);
+}
+
+static void beamfs_iomap_put_folio(struct inode *inode, loff_t pos,
+				   unsigned int copied, struct folio *folio)
+{
+	folio_unlock(folio);
+	folio_put(folio);
+}
+
+static const struct iomap_write_ops beamfs_iomap_write_ops = {
+	.get_folio = beamfs_iomap_get_folio,
+	.put_folio = beamfs_iomap_put_folio,
+};
+
+static ssize_t beamfs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
+{
+	return iomap_file_buffered_write(iocb, from, &beamfs_iomap_ops,
+					 &beamfs_iomap_write_ops, NULL);
+}
+
+/*
+ * Writeback path - beamfs_writeback_ops
+ */
+static ssize_t beamfs_writeback_range(struct iomap_writepage_ctx *wpc,
+				      struct folio *folio, u64 offset,
+				     unsigned int len, u64 end_pos)
+{
+	if ((loff_t)offset < wpc->iomap.offset ||
+	    (loff_t)offset >= wpc->iomap.offset + (loff_t)wpc->iomap.length) {
+		int ret;
+
+		memset(&wpc->iomap, 0, sizeof(wpc->iomap));
+		ret = beamfs_iomap_begin(wpc->inode,
+					 offset, INT_MAX, 0,
+					&wpc->iomap, NULL);
+		if (ret)
+			return ret;
+	}
+	return iomap_add_to_ioend(wpc, folio, offset, end_pos, len);
+}
+
+static const struct iomap_writeback_ops beamfs_writeback_ops = {
+	.writeback_range  = beamfs_writeback_range,
+	.writeback_submit = iomap_ioend_writeback_submit,
+};
+
+static int beamfs_writepages(struct address_space *mapping,
+			     struct writeback_control *wbc)
+{
+	struct iomap_writepage_ctx wpc = {
+		.inode = mapping->host,
+		.wbc   = wbc,
+		.ops   = &beamfs_writeback_ops,
+	};
+
+	return iomap_writepages(&wpc);
+}
+
+/*
+ * Read path - uses iomap_bio_read_ops (kernel-provided)
+ */
+static int beamfs_read_folio(struct file *file, struct folio *folio)
+{
+	struct iomap_read_folio_ctx ctx = {
+		.ops       = &iomap_bio_read_ops,
+		.cur_folio = folio,
+	};
+
+	iomap_read_folio(&beamfs_iomap_ops, &ctx, NULL);
+	return 0;
+}
+
+static void beamfs_readahead(struct readahead_control *rac)
+{
+	struct iomap_read_folio_ctx ctx = {
+		.ops = &iomap_bio_read_ops,
+		.rac = rac,
+	};
+
+	iomap_readahead(&beamfs_iomap_ops, &ctx, NULL);
+}
+
+static sector_t beamfs_bmap(struct address_space *mapping, sector_t block)
+{
+	return iomap_bmap(mapping, block, &beamfs_iomap_ops);
+}
+
+const struct address_space_operations beamfs_aops = {
+	.read_folio       = beamfs_read_folio,
+	.readahead        = beamfs_readahead,
+	.writepages       = beamfs_writepages,
+	.bmap             = beamfs_bmap,
+	.dirty_folio      = iomap_dirty_folio,
+	.invalidate_folio = iomap_invalidate_folio,
+	.release_folio    = iomap_release_folio,
+	.migrate_folio    = filemap_migrate_folio,
+};
-- 
2.55.0

