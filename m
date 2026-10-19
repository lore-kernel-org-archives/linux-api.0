Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC733C1D59
	for <linux-api@vger.kernel.org>; Mon, 19 Oct 2026 04:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792383489; cv=none; b=eA0duzqn1TcGyEK+nQ2WO8DiYI+HpkJ7pM6IoRpqkmOEtHZwMEej6sSXXm2uhWBOPFsMGzNoC5gZcfF9Wi+QLOM6WUNAO/dxlyZRls6IZfYPR7ynKPE7jT4oECTytlfIHQni1pDreHovMGFw6bEVvbYL7Guk2lNJ3/mxmCHKqIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792383489; c=relaxed/simple;
	bh=AmfpfHpYEu/w7/FFs6XX79OV0t3gB2YUZN7wXQSi8cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YIpVzfgZ7trnCNoD1RSXn5hFsvC611WFjrFSMYqs8jyP9X7v9R2Nl6RkzxVUaTWl6+EAQCLMziu5K9vZvJfB/fenoHKybryrYq+/GgBS/pV4rgDw1g4DPpqwmmYz3kejg7WnpG79Deaot1HkTDRKtO4v4bSIsx73M7hJzE9jL68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hackers.camp; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hackers.camp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-4887dbe4f2dso206026f8f.3
        for <linux-api@vger.kernel.org>; Sun, 18 Oct 2026 21:18:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792383480; x=1792988280;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=f/WZ3TP3LXM+Ui53bpSK3rPF5PJRlGDTuKIegWXDu7g=;
        b=v/RD2mE4YcD91lbA1BH/eUWGUf43Y/8BZ1f1C6wh9HpsOT2COwov1ncLPjI5KRUhk9
         aMH3t2xh2XxzSs9AlJJyV0Cx4TXCOK3GRHju9BO8yp9InOovz3ySNRqis148BSeoZZiU
         CreLayeZh1jzDnQnYcnJSZ91n6EP84085jFo2EXBu3Usn2xcSx+1Rol4AB/hBShviwGY
         tNPqQqwL0P0SsI+SJ1VhF+az5eU35k1b+54i+bxMD96USHOXKBv/xYWF/fxtiAhY0RsN
         AtBXIfE7WayoIAhM8XZbGtDEF12gVuVCRfI0qCGG5XrA2LXvMEI/eLsM4Xb+PIxFTYf1
         tA3g==
X-Forwarded-Encrypted: i=1; AKwUvBxlRB7N7M/8Yh6FJjzwVh7rGVpj7b/23tJbM91Fn0oKrLO6R5mXqVcJBeCxg/qZudVjBN7/x32TqU4=@vger.kernel.org
X-Gm-Message-State: AFq9FYJj+TxmEim+PS/pKmmFvLrD8Fs5lIqKYe1P1711xon7aXUNCyyk
	VxMEoOmyltDapXuh0RfkLjIlQWl4hnsrr0W3s0WeL4a/GtApM/dAOCS9
X-Gm-Gg: AYBFou0M8dfNIqeNM6qRB+pYwWsaeWpQooKUC+xx1CihMJGCuvusVk5uJY9E+JTL8ns
	qR4CW6cBt32xr0jqUFWDsLLBvJbFzKFYxJizdhlqouJTKJM5p5PDwxvUzKZvODq7xhBUcdyF8Oo
	gsJ/Te63ZvzRE6+ZRel0l5Wncvw7aRV5eRy1GRFRLPa/hyr/VuAC9B8TF2FhrDIoTV9ixKjelDS
	vuslE6RF+EMi4HF/2FYnnhUKqTdUqUaqOf5BBjWJaXEJhKZJaeS6bz7MJjSHrL207gDmle1f6Jp
	CKlhPkKsHwdZVPovV1AHlC9hARNNm+3yT1OfZYrrwsXTHLaER5+tloP292d0erXFhiJwr0yvb5T
	i84M/d1OHsP1fbfGikE7um+XXklsQXmtUe7Az2pHpZ/OCUBm+VJsFk9nw0gDu4lsdeb8G7XcQJ8
	DTiUVtPv85Gtzg+sWrylsw6OODXL4Ml9pe3obhK3yGSJKXVmUrwQRvcoIgDSuSa0zFg4XIS3mSw
	igWaCmyo7ejoCrOZWAvaf77ovmMmh976CO7
X-Received: by 2002:adf:e187:0:b0:48d:f1b3:7e82 with SMTP id ffacd0b85a97d-48e0792a1d8mr12241036f8f.0.1792383479306;
        Sun, 18 Oct 2026 21:17:59 -0700 (PDT)
Received: from spartian.home ([2a01:cb1c:76:ed00:602f:c5f4:d108:b925])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd500e75sm20090449f8f.42.2026.10.18.21.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 21:17:57 -0700 (PDT)
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
Subject: [RFC PATCH 08/18] beamfs: add inode and directory operations
Date: Mon, 19 Oct 2026 06:17:18 +0200
Message-ID: <20261019041728.327785-9-aurelien@hackers.camp>
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

inode.c reads inodes from the inode table into the VFS.

dir.c implements readdir and dirent.c the directory block format.
Directory blocks carry inline Reed-Solomon parity, sixteen codewords
per block as on the data path, and hold variable-length entries
delimited by d_rec_len.

Assisted-by: LLM
Signed-off-by: Aurelien DESBRIERES <aurelien@hackers.camp>
---
 fs/beamfs/dir.c    | 279 ++++++++++++++++++++++++++++++++
 fs/beamfs/dirent.c | 276 ++++++++++++++++++++++++++++++++
 fs/beamfs/inode.c  | 388 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 943 insertions(+)
 create mode 100644 fs/beamfs/dir.c
 create mode 100644 fs/beamfs/dirent.c
 create mode 100644 fs/beamfs/inode.c

diff --git a/fs/beamfs/dir.c b/fs/beamfs/dir.c
new file mode 100644
index 000000000000..dcb595b16b4e
--- /dev/null
+++ b/fs/beamfs/dir.c
@@ -0,0 +1,279 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * beamfs - Directory operations
+ * Author: Aurelien DESBRIERES <aurelien@hackers.camp>
+ */
+#include <linux/fs.h>
+#include <linux/buffer_head.h>
+#include <linux/fs_dirent.h>
+#include "beamfs.h"
+
+/*
+ * beamfs_readdir - iterate directory entries
+ *
+ * ctx->pos encoding:
+ *   0, 1       : '.' and '..' (emitted by dir_emit_dots)
+ *   INT_MAX    : EOF
+ *   other      : 2 + block_idx * BEAMFS_DATA_INLINE_BYTES + offset
+ *
+ * block_idx is the 0-based logical block, direct then single indirect;
+ * offset is a byte offset into that block's 3824-byte payload. The
+ * cookie names where reading resumes, and any value is accepted: one
+ * that falls inside a record resumes at the next record boundary.
+ *
+ * At most BEAMFS_DIRECT_BLOCKS + BEAMFS_INDIRECT_PTRS = 524 blocks, so
+ * pos is at most 2 + 524 * 3824, well within the 32-bit pos space.
+ */
+static int beamfs_readdir(struct file *file, struct dir_context *ctx)
+{
+	struct inode            *inode = file_inode(file);
+	struct super_block      *sb    = inode->i_sb;
+	struct buffer_head      *bh;
+	struct beamfs_dir_entry *de;
+	u8            *payload;
+	unsigned long  block_no;
+	u32            offset;
+	int            block_idx;
+	int            start_block;
+	u32            start_off;
+	int            ret = 0;
+
+	/*
+	 * ctx->pos is a byte offset into the directory, and any value is
+	 * legal.
+	 *
+	 * It used to be (block + 1) << 16 | offset, which cannot express
+	 * a position below 65536 as anything but block -1: seekdir to a
+	 * cookie this filesystem never issued -- which is exactly what
+	 * t_readdir_3 does -- started the walk outside every block and
+	 * returned nothing. "Unexpected EOF while reading dir",
+	 * reproducible at thirty files and above.
+	 *
+	 * ext2 treats pos as the offset it is: block = pos / blocksize,
+	 * offset = pos % blocksize, and a position past the end simply
+	 * finds no entries. Same here, with 3824-byte blocks. Positions
+	 * 0 and 1 stay reserved for dot and dotdot, so the first real
+	 * entry sits at 2 and the arithmetic starts one step in.
+	 */
+	if (ctx->pos == INT_MAX)
+		return 0;
+
+	if (ctx->pos < 2) {
+		if (!dir_emit_dots(file, ctx))
+			return 0;
+	}
+
+	if (ctx->pos <= 2) {
+		start_block = 0;
+		start_off   = 0;
+	} else {
+		u64 p = (u64)ctx->pos - 2;
+
+		/*
+		 * A directory block is not a capsule.
+		 *
+		 * dirent.c encodes and decodes one in the alternating
+		 * layout, so its payload is 3824 whatever the volume's
+		 * data blocks do. Following beamfs_block_payload here
+		 * would have the reader seek by 3808 into blocks laid
+		 * out in 3824 -- every entry past the first block off by
+		 * sixteen bytes.
+		 */
+		start_block = (int)div_u64_rem(p, BEAMFS_DATA_INLINE_BYTES, &start_off);
+	}
+
+	payload = beamfs_scratch_get(sb);
+	if (!payload)
+		return -ENOMEM;
+
+	for (block_idx = start_block;
+	     block_idx < (int)(BEAMFS_DIRECT_BLOCKS + BEAMFS_INDIRECT_PTRS);
+	     block_idx++) {
+		u64 _bno;
+		int _ret = beamfs_dir_get_block(inode, block_idx, false, &_bno);
+
+		if (_ret) {
+			ret = _ret;
+			goto out;
+		}
+		block_no = (unsigned long)_bno;
+		if (!block_no)
+			break;
+
+		bh = beamfs_bread(sb, block_no, "directory");
+		if (!bh)
+			continue;
+
+		_ret = beamfs_dirent_decode(sb, bh, payload);
+		brelse(bh);
+		if (_ret < 0) {
+			pr_err_ratelimited("beamfs: directory block %lu uncorrectable\n",
+					   block_no);
+			ret = _ret;
+			goto out;
+		}
+
+		offset = (block_idx == start_block) ? start_off : 0;
+
+		/*
+		 * Slide to a record boundary.
+		 *
+		 * seekdir can land mid-record, and reading a header from
+		 * the middle of a name yields nonsense. Walk from the top
+		 * of the block to the first record at or after the
+		 * requested offset -- ext2_validate_entry does the same,
+		 * for the same reason.
+		 */
+		if (offset != 0 && offset < BEAMFS_DATA_INLINE_BYTES) {
+			u32 scan = 0;
+
+			while (scan < offset) {
+				u32 nxt;
+
+				de = (struct beamfs_dir_entry *)(payload + scan);
+				if (!beamfs_dirent_valid(de, scan))
+					break;
+				nxt = beamfs_dirent_next(de, scan);
+				if (nxt == BEAMFS_DIRENT_NOSPACE || nxt <= scan)
+					break;
+				scan = nxt;
+			}
+			offset = scan;
+		}
+
+		while (offset < BEAMFS_DATA_INLINE_BYTES) {
+			u32 next;
+
+			de = (struct beamfs_dir_entry *)(payload + offset);
+			if (!beamfs_dirent_valid(de, offset))
+				break;
+
+			if (de->d_ino &&
+			    !(de->d_name_len == 1 && de->d_name[0] == '.') &&
+			    !(de->d_name_len == 2 && de->d_name[0] == '.' &&
+			      de->d_name[1] == '.')) {
+				u8 dt;
+
+				switch (de->d_file_type) {
+				case 1:
+					dt = DT_REG;
+					break;
+				case 2:
+					dt = DT_DIR;
+					break;
+				default:
+					dt = de->d_file_type;
+					break;
+				}
+
+				if (!dir_emit(ctx, de->d_name, de->d_name_len,
+					      le64_to_cpu(de->d_ino), dt))
+					goto out;
+			}
+
+			next = beamfs_dirent_next(de, offset);
+			if (next == BEAMFS_DIRENT_NOSPACE)
+				break;
+			offset = next;
+
+			/*
+			 * Advance after emitting, and for every record, so
+			 * the cookie names where reading resumes rather
+			 * than the entry just returned.
+			 */
+			ctx->pos = 2 + (loff_t)block_idx *
+					BEAMFS_DATA_INLINE_BYTES + offset;
+		}
+	}
+
+	ctx->pos = INT_MAX;
+out:
+	beamfs_scratch_put(sb, payload);
+	return ret;
+}
+
+/*
+ * beamfs_lookup - find dentry in directory
+ */
+struct dentry *beamfs_lookup(struct inode *dir,
+			     struct dentry *dentry,
+			     unsigned int flags)
+{
+	struct super_block      *sb = dir->i_sb;
+	struct buffer_head      *bh;
+	struct beamfs_dir_entry *de;
+	struct inode            *inode = NULL;
+	u8            *payload;
+	unsigned long  block_no;
+	u32            offset;
+	unsigned int   i;
+	int            ret = 0;
+
+	if (dentry->d_name.len > BEAMFS_MAX_FILENAME)
+		return ERR_PTR(-ENAMETOOLONG);
+
+	payload = beamfs_scratch_get(sb);
+	if (!payload)
+		return ERR_PTR(-ENOMEM);
+
+	for (i = 0; i < BEAMFS_DIRECT_BLOCKS + BEAMFS_INDIRECT_PTRS; i++) {
+		u64 _bno;
+		int _ret = beamfs_dir_get_block(dir, i, false, &_bno);
+
+		if (_ret) {
+			ret = _ret;
+			goto out;
+		}
+		block_no = (unsigned long)_bno;
+		if (!block_no)
+			break;
+
+		bh = beamfs_bread(sb, block_no, "directory");
+		if (!bh)
+			continue;
+
+		_ret = beamfs_dirent_decode(sb, bh, payload);
+		brelse(bh);
+		if (_ret < 0) {
+			ret = _ret;
+			goto out;
+		}
+
+		offset = 0;
+		while (offset < BEAMFS_DATA_INLINE_BYTES) {
+			u32 next;
+
+			de = (struct beamfs_dir_entry *)(payload + offset);
+			if (!beamfs_dirent_valid(de, offset))
+				break;
+
+			if (de->d_ino &&
+			    de->d_name_len == dentry->d_name.len &&
+			    !memcmp(de->d_name, dentry->d_name.name,
+				    de->d_name_len)) {
+				inode = beamfs_iget(sb,
+						    (unsigned long)le64_to_cpu(de->d_ino));
+				goto out;
+			}
+
+			next = beamfs_dirent_next(de, offset);
+			if (next == BEAMFS_DIRENT_NOSPACE)
+				break;
+			offset = next;
+		}
+	}
+
+out:
+	beamfs_scratch_put(sb, payload);
+	if (ret)
+		return ERR_PTR(ret);
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
+	return d_splice_alias(inode, dentry);
+}
+
+const struct file_operations beamfs_dir_operations = {
+	.llseek         = generic_file_llseek,
+	.read           = generic_read_dir,
+	.iterate_shared = beamfs_readdir,
+};
diff --git a/fs/beamfs/dirent.c b/fs/beamfs/dirent.c
new file mode 100644
index 000000000000..fcefff321c39
--- /dev/null
+++ b/fs/beamfs/dirent.c
@@ -0,0 +1,276 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * beamfs - Directory blocks: variable-length entries, and parity over them
+ * Author: Aurelien DESBRIERES <aurelien@hackers.camp>
+ *
+ * Every other structure on this volume is covered. A directory block
+ * without parity would be 4096 raw bytes, no checksum, no correction,
+ * and an upset there silent and permanent: a flipped inode number
+ * points a name at the wrong file, a flipped length walks the parser
+ * off the end of an entry, and neither is detectable let alone
+ * correctable.
+ *
+ * Parity is inline, sixteen RS codewords in the block, matching the
+ * data path. The alternative -- a separate parity region, which is what
+ * the indirect blocks use -- keeps 4096 usable bytes but makes that
+ * region a single point of failure for every directory on the volume,
+ * and leaves the filesystem with three different parity models instead
+ * of two. ext4 puts its directory checksum inline for the same reason.
+ *
+ * Entries are variable length, and every walk steps by d_rec_len.
+ * Stepping by sizeof(struct beamfs_dir_entry) instead -- a flat 268
+ * bytes, whatever the name's length -- would give fourteen entries per
+ * 3824-byte block and a hard ceiling of 7336 per directory.
+ *
+ * An eleven-character name takes 24 bytes: 144 entries per block and a
+ * ceiling above 75000. Roughly ten times the density, ten times fewer
+ * blocks read per lookup, and ten times less metadata exposed for the
+ * same directory.
+ */
+
+#include <linux/fs.h>
+#include <linux/buffer_head.h>
+#include "beamfs.h"
+
+/*
+ * Which subblock an offset falls in, and where that subblock ends.
+ *
+ * Each of the sixteen subblocks is an independent codeword: one is
+ * correctable, or not, on its own. An entry spanning two turns a single
+ * uncorrectable subblock into a parse failure for everything after it
+ * in the block, so entries are kept inside one whenever they fit.
+ */
+static inline u32 beamfs_dirent_sub_end(u32 off)
+{
+	return (off / BEAMFS_SUBBLOCK_DATA + 1) * BEAMFS_SUBBLOCK_DATA;
+}
+
+/*
+ * Where the next entry of @len bytes goes, given a cursor at @off.
+ *
+ * Returns the offset to place it at, which is @off unless the entry
+ * would straddle a subblock boundary and does not have to. Returns
+ * BEAMFS_DIRENT_NOSPACE when the block cannot hold it.
+ *
+ * An entry longer than a subblock -- a name of 225 characters or more, which
+ * NAME_MAX allows and xfstests exercises -- is placed where it falls.
+ * Refusing it would mean rejecting a filename every other Linux
+ * filesystem accepts, and the property is kept everywhere it can be.
+ */
+u32 beamfs_dirent_place(u32 off, u16 len)
+{
+	u32 end;
+
+	if (off + len > BEAMFS_DATA_INLINE_BYTES)
+		return BEAMFS_DIRENT_NOSPACE;
+
+	if (len > BEAMFS_SUBBLOCK_DATA)
+		return off;			/* cannot fit either way */
+
+	end = beamfs_dirent_sub_end(off);
+	if (off + len <= end)
+		return off;			/* fits where it is */
+
+	if (end + len > BEAMFS_DATA_INLINE_BYTES)
+		return BEAMFS_DIRENT_NOSPACE;
+
+	return end;				/* start of the next subblock */
+}
+
+/*
+ * Step to the entry after the one at @off.
+ *
+ * A record length of zero, or one that would leave the block, ends the
+ * walk: on a damaged block that is the difference between stopping and
+ * reading whatever follows as a directory entry.
+ */
+u32 beamfs_dirent_next(const struct beamfs_dir_entry *de, u32 off)
+{
+	u16 rec = le16_to_cpu(de->d_rec_len);
+
+	if (rec < BEAMFS_DIRENT_MIN_LEN)
+		return BEAMFS_DIRENT_NOSPACE;
+	if (off + rec > BEAMFS_DATA_INLINE_BYTES)
+		return BEAMFS_DIRENT_NOSPACE;
+	return off + rec;
+}
+
+/*
+ * Is the entry at @off structurally sound?
+ *
+ * Checked before the name is used, because a flipped length is exactly
+ * the failure this parity was added to catch, and a name length that
+ * runs past the record is how a directory read walks off into the next
+ * entry.
+ */
+bool beamfs_dirent_valid(const struct beamfs_dir_entry *de, u32 off)
+{
+	u16 rec = le16_to_cpu(de->d_rec_len);
+
+	if (rec < BEAMFS_DIRENT_MIN_LEN)
+		return false;
+	if (off + rec > BEAMFS_DATA_INLINE_BYTES)
+		return false;
+	/* d_name_len is a u8: every length it can hold is allowed. */
+	BUILD_BUG_ON(BEAMFS_MAX_FILENAME < U8_MAX);
+	if (BEAMFS_DIRENT_HDR_LEN + de->d_name_len > rec)
+		return false;
+	return true;
+}
+
+/*
+ * Re-encode a directory block's parity. The buffer lock must be held.
+ *
+ * Same sixteen codewords as a data block, over the same 239-byte
+ * subblocks, so a corrupted directory is correctable to the same depth
+ * as corrupted file contents.
+ */
+void beamfs_dirent_encode(struct buffer_head *bh)
+{
+	u8 *b = (u8 *)bh->b_data;
+	unsigned int i;
+
+	/*
+	 * The payload is laid out contiguously in the first 3824 bytes
+	 * and scattered into the codeword slots here, the way the data
+	 * path does it, so the walk above can treat the block as flat.
+	 */
+	for (i = BEAMFS_DATA_INLINE_SUBBLOCKS; i-- > 0; )
+		memmove(b + (size_t)i * BEAMFS_SUBBLOCK_TOTAL,
+			b + (size_t)i * BEAMFS_SUBBLOCK_DATA,
+			BEAMFS_SUBBLOCK_DATA);
+
+	{
+		int _e = beamfs_rs_encode_region(b, BEAMFS_SUBBLOCK_TOTAL,
+				b + BEAMFS_SUBBLOCK_DATA,
+				BEAMFS_SUBBLOCK_TOTAL,
+				BEAMFS_SUBBLOCK_DATA,
+				BEAMFS_DATA_INLINE_SUBBLOCKS);
+
+		/*
+		 * A directory block with no valid parity is one a
+		 * verify will later call beyond correction.
+		 */
+		if (_e < 0)
+			pr_err_ratelimited("beamfs/dirent: encode failed: %d\n",
+					   _e);
+	}
+}
+
+/*
+ * Decode a directory block into @dst, correcting what RS can.
+ *
+ * @dst holds the 3824 payload bytes contiguously, which is what the
+ * entry walk expects. Returns the number of subblocks that needed
+ * correcting, or -EUCLEAN if any could not be.
+ */
+int beamfs_dirent_decode(struct super_block *sb, struct buffer_head *bh,
+			 u8 *dst)
+{
+	/*
+	 * On the stack, not from the allocator.
+	 *
+	 * These are 64 and 512 bytes, and this runs once per directory
+	 * block on every lookup, readdir, create and unlink -- so a
+	 * ten-block directory meant twenty allocations to resolve one
+	 * name. Under memory pressure that turns a path that should never
+	 * block into one that does: generic/558 had twelve tasks in D and
+	 * one of them was sitting in kfree underneath this function,
+	 * called from beamfs_lookup.
+	 *
+	 * 576 bytes against the kernel's 2 KiB frame budget, on a
+	 * function whose callers are shallow.
+	 */
+	int results[BEAMFS_DATA_INLINE_SUBBLOCKS];
+	u8 positions[BEAMFS_DATA_INLINE_SUBBLOCKS * (BEAMFS_RS_PARITY / 2)];
+	unsigned int i, corrected = 0;
+	int ret = 0;
+
+	memset(results, 0, sizeof(results));
+
+	/*
+	 * Under the buffer lock, like the sweep.
+	 *
+	 * beamfs_dirent_encode holds lock_buffer across the memmove that
+	 * spreads the records into codeword slots and the RS encode that
+	 * follows. Copying without the lock catches that halfway: payload
+	 * from after the write, parity from before, uncorrectable by
+	 * construction and reported as damage on a block nothing has
+	 * damaged.
+	 *
+	 * Five callers reach here -- readdir, lookup, add_dirent,
+	 * del_dirent, dir_is_empty -- and any of them can run while
+	 * another writes the same directory.
+	 */
+	lock_buffer(bh);
+	/*
+	 * The whole block, parity included.
+	 *
+	 * decode_rs8 corrects data and parity in place -- it writes to
+	 * both buffers it is given. Copying only the payload and pointing
+	 * the decoder at bh->b_data for the parity means every read
+	 * rewrites the shared buffer's parity bytes. A block read often
+	 * enough degrades until it will not decode at all, which is what
+	 * the sweep kept reporting on blocks fsck called clean, and why
+	 * the count grew as the volume got busier.
+	 *
+	 * The data path has done this correctly all along: "Decode
+	 * RS(255,239) subblocks into a private scratch buffer, never into
+	 * bh->b_data."
+	 */
+	memcpy(dst, (u8 *)bh->b_data, BEAMFS_BLOCK_SIZE);
+	unlock_buffer(bh);
+
+	ret = beamfs_rs_decode_region(dst, BEAMFS_SUBBLOCK_TOTAL,
+				      dst + BEAMFS_SUBBLOCK_DATA,
+				      BEAMFS_SUBBLOCK_TOTAL,
+				      BEAMFS_SUBBLOCK_DATA,
+				      BEAMFS_DATA_INLINE_SUBBLOCKS,
+				      results, positions,
+				      BEAMFS_RS_PARITY / 2,
+				"directory");
+
+	for (i = 0; i < BEAMFS_DATA_INLINE_SUBBLOCKS; i++) {
+		if (results[i] > 0) {
+			corrected++;
+			beamfs_log_rs_event_flagged(sb,
+						    bh->b_blocknr,
+				positions + (size_t)i * (BEAMFS_RS_PARITY / 2),
+				(unsigned int)results[i],
+				BEAMFS_SUBBLOCK_DATA,
+				beamfs_rs_event_subblock_bits(i));
+			beamfs_budget_record(sb, bh->b_blocknr,
+					     (unsigned int)results[i]);
+		} else if (results[i] < 0) {
+			/*
+			 * Name the block and the codeword. The buffer knows
+			 * where it came from; the decoder does not, and a
+			 * line that says only "uncorrectable" leaves the
+			 * reader with nowhere to look.
+			 */
+			pr_err_ratelimited("beamfs: directory block %llu subblock %u/%u uncorrectable\n",
+					   (unsigned long long)bh->b_blocknr,
+					   i, BEAMFS_DATA_INLINE_SUBBLOCKS);
+			ret = -EUCLEAN;
+		}
+	}
+
+	/*
+	 * De-interleave what the decoder corrected.
+	 *
+	 * dst held the block in its on-disk layout for the decode --
+	 * decode_rs8 writes to both the data and the parity it is given,
+	 * so both had to be private. Callers want the 3824 payload bytes
+	 * contiguous, which is what the walk over records expects.
+	 */
+	if (ret >= 0) {
+		unsigned int k;
+
+		for (k = 0; k < BEAMFS_DATA_INLINE_SUBBLOCKS; k++)
+			memmove(dst + (size_t)k * BEAMFS_SUBBLOCK_DATA,
+				dst + (size_t)k * BEAMFS_SUBBLOCK_TOTAL,
+				BEAMFS_SUBBLOCK_DATA);
+	}
+
+	return ret < 0 ? ret : (int)corrected;
+}
diff --git a/fs/beamfs/inode.c b/fs/beamfs/inode.c
new file mode 100644
index 000000000000..fb7a8aead44a
--- /dev/null
+++ b/fs/beamfs/inode.c
@@ -0,0 +1,388 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * beamfs - Inode operations
+ * Author: Aurelien DESBRIERES <aurelien@hackers.camp>
+ */
+
+#include <linux/fs.h>
+#include <linux/buffer_head.h>
+#include <linux/pagemap.h>
+#include <linux/slab.h>
+#include <linux/time.h>
+#include "beamfs.h"
+
+/*
+ * Split a nanosecond count into the seconds and nanoseconds a timespec64
+ * wants, with the nanosecond part never negative.
+ */
+static void beamfs_split_ns(s64 ns, s64 *sec, long *nsec)
+{
+	s32 rem;
+
+	*sec = div_s64_rem(ns, NSEC_PER_SEC, &rem);
+	if (rem < 0) {
+		*sec -= 1;
+		rem += NSEC_PER_SEC;
+	}
+	*nsec = rem;
+}
+
+#define beamfs_set_time_from_ns(inode, setter, ns)			\
+	do {								\
+		s64  _sec;						\
+		long _nsec;						\
+									\
+		beamfs_split_ns((ns), &_sec, &_nsec);			\
+		setter((inode), _sec, _nsec);				\
+	} while (0)
+
+/*
+ * beamfs_iget - read inode from disk into VFS
+ * @sb:  superblock
+ * @ino: inode number (1-based)
+ *
+ * Inode table starts at s_inode_table_blk.
+ * Each block holds BEAMFS_BLOCK_SIZE / sizeof(beamfs_inode) inodes.
+ */
+struct inode *beamfs_iget(struct super_block *sb, unsigned long ino)
+{
+	struct beamfs_sb_info    *sbi = BEAMFS_SB(sb);
+	struct beamfs_inode_info *fi;
+	struct beamfs_inode      *raw;
+	struct buffer_head      *bh;
+	struct inode            *inode;
+	unsigned long            inodes_per_block;
+	unsigned long            block, offset;
+	u64                      ninodes;
+	__u32                    crc;
+
+	/*
+	 * An inode number is on-disk data, so it is attacker- and
+	 * flip-controlled. beamfs_lookup passes de->d_ino straight here
+	 * and beamfs_dirent_valid checks d_rec_len and d_name_len only,
+	 * never d_ino. Without this bound the block computed just below,
+	 * s_inode_table_blk + (ino - 1) / inodes_per_block, walks out of
+	 * the inode table and an arbitrary block is read as inodes; any
+	 * write to the inode that comes back then allocates blocks under
+	 * a number no volume of this size can hold. Observed as ino=27192
+	 * on a 16384-inode volume, 241 blocks.
+	 *
+	 * The bound comes from the superblock, not from sbi->s_ninodes:
+	 * beamfs_setup_bitmap runs after the root iget in fill_super, so
+	 * s_ninodes is still zero on that first call and every mount
+	 * would be refused here.
+	 */
+	ninodes = le64_to_cpu(sbi->s_beamfs_sb->s_inode_count);
+	if (ino < BEAMFS_RESERVED_INO_ROOT || (u64)ino > ninodes) {
+		pr_err_ratelimited("beamfs: inode number %lu out of range (1..%llu)\n",
+				   ino, ninodes);
+		return ERR_PTR(-EUCLEAN);
+	}
+
+	inode = iget_locked(sb, ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+
+	/* Already in cache */
+	if (!beamfs_inode_is_new(inode))
+		return inode;
+
+	inodes_per_block = BEAMFS_BLOCK_SIZE / sizeof(struct beamfs_inode);
+	block  = le64_to_cpu(sbi->s_beamfs_sb->s_inode_table_blk)
+		 + (ino - 1) / inodes_per_block;
+	offset = (ino - 1) % inodes_per_block;
+
+	bh = beamfs_bread(sb, block, "inode table");
+	if (!bh) {
+		pr_err("beamfs: unable to read inode block %lu\n", block);
+		iget_failed(inode);
+		return ERR_PTR(-EIO);
+	}
+
+	raw = (struct beamfs_inode *)bh->b_data + offset;
+
+	/*
+	 * Integrity check, two stages.
+	 *
+	 * Stage A: CRC32. The nominal path. >99% of inode reads are
+	 * expected to match here at low cost; CRC32 is hardware-accelerated
+	 * by crc32_le on architectures that support it.
+	 *
+	 * Stage B: RS FEC, only invoked if CRC32 fails AND the format
+	 * declares RS protection on inodes. Two activation paths:
+	 *   - s_data_protection_scheme == INODE_UNIVERSAL (legacy v4)
+	 *   - s_feat_incompat & BEAMFS_FEATURE_INCOMPAT_PER_INODE_RS (v5)
+	 * Both paths share the same on-disk parity layout in i_reserved
+	 * [0..15] (16 bytes covering BEAMFS_INODE_RS_DATA = 172 data
+	 * bytes). The kernel write path always emits this parity
+	 * (namei.c::beamfs_write_inode_raw) and mkfs.beamfs always seeds
+	 * it at format time (rs_encode_inode), so the decoder is safe to
+	 * invoke whenever either path is active.
+	 *
+	 * After a successful RS correction we re-verify CRC32 on the
+	 * corrected buffer before accepting the inode. This guards
+	 * against the rare case where an SEU on the parity field itself
+	 * makes decode_rs8 return success while the data has actually
+	 * been altered toward a wrong codeword.
+	 */
+	/*
+	 * A free inode is not a corrupt one.
+	 *
+	 * Free slots are zeroed, i_crc32 included, and beamfs_inode_crc of
+	 * a zeroed inode is 0x0ee93c94 rather than zero -- so every read of
+	 * a free inode fails the check below by construction. Dozens of them
+	 * appeared in twenty milliseconds during one test run, reported as
+	 * "CRC32 mismatch", which is both the wrong error and the wrong
+	 * diagnosis: nothing was corrupt, something had followed a stale
+	 * reference.
+	 *
+	 * ESTALE is what the VFS expects here, and it is what ext2 returns
+	 * for an inode with no links.
+	 */
+	if (le16_to_cpu(raw->i_mode) == 0) {
+		brelse(bh);
+		iget_failed(inode);
+		return ERR_PTR(-ESTALE);
+	}
+
+	crc = beamfs_inode_crc(raw);
+	if (crc != le32_to_cpu(raw->i_crc32)) {
+		struct beamfs_super_block *bsb = BEAMFS_SB(sb)->s_beamfs_sb;
+		u32 scheme = le32_to_cpu(bsb->s_data_protection_scheme);
+		int nerr;
+
+		if (scheme != BEAMFS_DATA_PROTECTION_INODE_UNIVERSAL &&
+		    !(BEAMFS_SB(sb)->s_feat_incompat &
+		      BEAMFS_FEATURE_INCOMPAT_PER_INODE_RS)) {
+			pr_err("beamfs: inode %lu CRC32 mismatch (no RS available, scheme=%u feat_incompat=0x%016llx)\n",
+			       ino, scheme,
+			       (unsigned long long)BEAMFS_SB(sb)->s_feat_incompat);
+			brelse(bh);
+			iget_failed(inode);
+			return ERR_PTR(-EIO);
+		}
+
+		{
+			u8 positions[BEAMFS_RS_PARITY / 2];
+			struct beamfs_inode *fixed;
+
+			/*
+			 * Decode a copy, not the shared buffer.
+			 *
+			 * decode_rs8 corrects in place, and raw points into
+			 * the inode table block, which holds several inodes.
+			 * Correcting there rewrites a buffer other inodes are
+			 * read from, and the mark_buffer_dirty below then
+			 * carries the result to disk -- a speculative fix
+			 * written before the CRC has confirmed it, on a block
+			 * that may simply have been mid-write.
+			 *
+			 * The same shape as beamfs_ind_parity_verify had, and
+			 * as the data read path avoids: "never into
+			 * bh->b_data. decode_rs8 mutates both data and parity."
+			 *
+			 * Decode into a private copy, confirm with the CRC,
+			 * and only then write the corrected inode back under
+			 * the buffer lock. A correction that does not pass the
+			 * CRC touches nothing.
+			 */
+			/*
+			 * The copy lives on the heap: with it on the stack
+			 * the frame of beamfs_iget was 560 bytes, past the
+			 * 512 submit-checklist allows, and iget_locked has
+			 * just allocated the in-core inode anyway.
+			 */
+			fixed = kmemdup(raw, sizeof(*fixed), GFP_NOFS);
+			if (!fixed) {
+				brelse(bh);
+				iget_failed(inode);
+				return ERR_PTR(-ENOMEM);
+			}
+			nerr = beamfs_rs_decode((u8 *)fixed,
+						BEAMFS_INODE_RS_DATA,
+					       fixed->i_reserved,
+					       positions,
+					       BEAMFS_RS_PARITY / 2,
+				"inode");
+			if (nerr < 0) {
+				pr_err("beamfs: inode %lu uncorrectable\n", ino);
+				kfree(fixed);
+				brelse(bh);
+				iget_failed(inode);
+				return ERR_PTR(-EIO);
+			}
+
+			crc = beamfs_inode_crc(fixed);
+			if (crc != le32_to_cpu(fixed->i_crc32)) {
+				pr_err("beamfs: inode %lu CRC32 mismatch after RS correction\n",
+				       ino);
+				kfree(fixed);
+				brelse(bh);
+				iget_failed(inode);
+				return ERR_PTR(-EIO);
+			}
+
+			/* Confirmed: publish the correction. */
+			lock_buffer(bh);
+			memcpy(raw, fixed, sizeof(*fixed));
+			unlock_buffer(bh);
+			kfree(fixed);
+
+			/* Log the RS event with its positions: nerr is the number
+			 * of data bytes corrected, the entries positions[] holds.
+			 */
+			if (nerr > 0) {
+				unsigned int np = (unsigned int)nerr;
+
+				if (np > BEAMFS_RS_PARITY / 2)
+					np = BEAMFS_RS_PARITY / 2;
+				/*
+				 * The table block, not the inode number: a
+				 * clustering pass asks where on the medium the
+				 * damage landed, and an inode number is not a
+				 * position.
+				 */
+				beamfs_log_rs_event_flagged(sb, bh->b_blocknr,
+							    positions, np,
+						   BEAMFS_INODE_RS_DATA,
+						   BEAMFS_RS_EVENT_FLAG_INODE);
+			}
+			mark_buffer_dirty(bh);
+			pr_warn("beamfs: inode %lu corrected by RS FEC (%d symbols)\n",
+				ino, nerr);
+		}
+	}
+
+	fi = BEAMFS_I(inode);
+
+	/* Populate VFS inode */
+	inode->i_mode  = le16_to_cpu(raw->i_mode);
+	inode->i_uid   = make_kuid(sb->s_user_ns, le32_to_cpu(raw->i_uid));
+	inode->i_gid   = make_kgid(sb->s_user_ns, le32_to_cpu(raw->i_gid));
+	set_nlink(inode, le16_to_cpu(raw->i_nlink));
+	inode->i_size  = le64_to_cpu(raw->i_size);
+
+	/*
+	 * Times before 1970 are negative, and there is nothing exotic
+	 * about them: tar preserves them, build systems set them, and a
+	 * file dated 1960 is a file. le64_to_cpu returns unsigned, so
+	 * dividing it turned -315M seconds into 1.8e19 -- generic/258
+	 * reports it as "Timestamp wrapped".
+	 *
+	 * div_s64_rem rather than / and %, because C truncates toward
+	 * zero: -1.5e9 ns would give -1 second and -5e8 nanoseconds, and
+	 * a negative nanosecond field is not a time the VFS can use. The
+	 * floor form gives -2 seconds and +5e8 nanoseconds, which is the
+	 * same instant expressed the way timespec64 requires.
+	 */
+	beamfs_set_time_from_ns(inode, inode_set_atime,
+				(s64)le64_to_cpu(raw->i_atime));
+	beamfs_set_time_from_ns(inode, inode_set_mtime,
+				(s64)le64_to_cpu(raw->i_mtime));
+	beamfs_set_time_from_ns(inode, inode_set_ctime,
+				(s64)le64_to_cpu(raw->i_ctime));
+
+	/* Copy block pointers to in-memory inode */
+	memcpy(fi->i_direct, raw->i_direct, sizeof(fi->i_direct));
+	fi->i_indirect  = raw->i_indirect;
+	fi->i_dindirect = raw->i_dindirect;
+	fi->i_tindirect = raw->i_tindirect;
+	fi->i_flags     = le32_to_cpu(raw->i_flags);
+
+	/* Layer 1 defense: mark reserved inodes (canary) as immutable.
+	 * VFS rejects open(O_TRUNC), setattr(ATTR_SIZE), unlink, chmod
+	 * with EPERM before reaching beamfs hooks. Layer 2 in alloc.c
+	 * provides the safety net if VFS check is bypassed (corruption).
+	 */
+	if (beamfs_ino_is_reserved((u64)ino) && ino != BEAMFS_RESERVED_INO_ROOT)
+		inode->i_flags |= S_IMMUTABLE;
+
+	/* Set ops based on file type */
+	if (S_ISDIR(inode->i_mode)) {
+		inode->i_op  = &beamfs_dir_inode_operations;
+		inode->i_fop = &beamfs_dir_operations;
+	} else if (S_ISREG(inode->i_mode)) {
+		if (sbi->s_scheme == BEAMFS_DATA_PROTECTION_UNIVERSAL_INLINE) {
+			/*
+			 * v2 INLINE: per-block RS FEC requires gather/scatter
+			 * across 16 subblocks per disk block. Single-page
+			 * folios only; large folios deferred to v2.1.
+			 * Dedicated i_op carries setattr/truncate (sub-step 6).
+			 */
+			inode->i_op = &beamfs_inline_inode_operations;
+			inode->i_fop = &beamfs_inline_file_operations;
+			inode->i_mapping->a_ops = &beamfs_inline_aops;
+			mapping_set_folio_order_range(inode->i_mapping, 0, 0);
+		} else {
+			/* legacy iomap path (scheme=5 INODE_UNIVERSAL) */
+			inode->i_op = &beamfs_file_inode_operations;
+			inode->i_fop = &beamfs_file_operations;
+			inode->i_mapping->a_ops = &beamfs_aops;
+		}
+	} else if (S_ISLNK(inode->i_mode)) {
+		/*
+		 * Symlink: a target under 96 bytes is inline in i_direct[],
+		 * a longer one in the data block i_direct[0] names.
+		 */
+		inode->i_op = &beamfs_symlink_inode_operations;
+	} else {
+		/* Special files: use generic */
+		init_special_inode(inode, inode->i_mode, 0);
+	}
+
+	brelse(bh);
+	unlock_new_inode(inode);
+	return inode;
+}
+
+/*
+ * beamfs_getattr -- stat for every beamfs inode.
+ *
+ * st_blocks is the count of blocks the inode holds on the medium, data
+ * and indirect alike. The inode does not store it, so it is taken from
+ * the tree the first time it is asked for, and beamfs_alloc_block and
+ * beamfs_free_block keep it from there. Regular files and symlinks used
+ * simple_getattr, which counts the pages in the page cache: 0 for any
+ * file after a mount.
+ *
+ * The count is taken under the allocation mutex alone, which every path
+ * that installs or frees a block of the inode holds, a directory's
+ * included. Not the inode lock: ->getattr is called without it, and a
+ * caller of vfs_getattr that holds it would wait on itself here.
+ *
+ * A count stopped by a block of pointers that failed its check is not
+ * kept, and is taken again on the next call; the block was reported
+ * where it failed. Until a count is kept, the mask statx returns leaves
+ * STATX_BLOCKS out rather than vouch for the number.
+ */
+int beamfs_getattr(const struct mnt_idmap *idmap, const struct path *path,
+		   struct kstat *stat, u32 request_mask,
+		   unsigned int query_flags)
+{
+	struct inode *inode = d_inode(path->dentry);
+	struct beamfs_inode_info *fi = BEAMFS_I(inode);
+	bool counted;
+
+	/* Pairs with the release below: the count is in before the flag. */
+	counted = smp_load_acquire(&fi->i_blocks_counted);
+	if ((request_mask & STATX_BLOCKS) && !counted) {
+		mutex_lock(&fi->i_alloc_mutex);
+		counted = fi->i_blocks_counted;
+		if (!counted) {
+			u64 n = 0;
+			int err = beamfs_count_blocks(inode, &n);
+
+			inode_set_bytes(inode, (loff_t)n * BEAMFS_BLOCK_SIZE);
+			if (!err) {
+				/* Pairs with the acquire above. */
+				smp_store_release(&fi->i_blocks_counted, true);
+				counted = true;
+			}
+		}
+		mutex_unlock(&fi->i_alloc_mutex);
+	}
+	generic_fillattr(idmap, request_mask, inode, stat);
+	if (!counted)
+		stat->result_mask &= ~STATX_BLOCKS;
+	return 0;
+}
-- 
2.55.0

