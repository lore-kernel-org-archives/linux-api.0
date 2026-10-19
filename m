Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD983B05BF
	for <linux-api@vger.kernel.org>; Mon, 19 Oct 2026 04:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792383474; cv=none; b=W/4bckLCLNZmDq4Bvmhe4YQufzP+3t9hxtJd0jLXojdLGrOi3xDL7SzWYMlfvswah9isYJpQgAhco+QjZKfizLsLH32KmSpY4B5XvtMcTv3z8SqwLb02S/rlJ3eSp6uT1lKATbRjwhp6Kw0bRNEcafFKk+f9UBojNoNZf51eVGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792383474; c=relaxed/simple;
	bh=FYHRXerYv843D1MeVQZ+xDe2F9xLIe44YumaoTpwF+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k+t+dwqXutVGfkmsV5flDPcB+FhdBmpkvUWwhh19LJxE8DFgCuVhT9Eg0UBEm40DFnjTKl/BkChmjEE6CXdNjY24mn/RdsgI0PWfjkU/Nkq4K/Ohatk7hcY6dEFBXBMArm97TEh/hKtHDf6S1nK7qgpyODAAjs70NZDl/xxxKvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hackers.camp; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hackers.camp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a16d39964bso1432165e9.0
        for <linux-api@vger.kernel.org>; Sun, 18 Oct 2026 21:17:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792383467; x=1792988267;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vmmZ+r1GKeiajAMO/Oqv+74SZCyvFxDg0X3dCh5FB8k=;
        b=KwmrRpgP6JAZX2mBV6Ud1ndErjmkITM1gJrLkNqOGbu8bRg95GSlWcFJN2UQ4ms34N
         1QdK/KDvDfD4Wx6qBxrpX2/cRSA4LzlyrqzY+QBoRJ+RHeqckzNGjizc8+iayJ8/0h+O
         ofF7s2lo26k9D2bkO5LcdFrKTFKG39hYlsioR0x9+cmJGlSbuKgT9lxblugmFk+CQYjo
         kxkIBHbUeY+fRkvKzQsqP5DIeGVLaxsCFUYBivlGoGEU9BNCnwTbOUfocFwqT2tTyomC
         yMHuDf/DkjuFxg8VF1Y5aTAHZqODQ6QCRh2dh8YmpRYUM2sEPCqDRhHRO8kHrqIwX41C
         rFGQ==
X-Forwarded-Encrypted: i=1; AKwUvByPRuE75w3SD8WVjvK6GGsEtIVbhREUZGUrKWkBOTpYMFMTq4EOMfSKH8S8m/xp74nNgUJU8zbP+Ss=@vger.kernel.org
X-Gm-Message-State: AFq9FYJFi80lhtj8BwMQ+VgCdwzkSvNzU/wVtTgBiv8Guj6A0InRxg68
	m693dc35SsUKw3I4LAxJhgbxYjNzH4mKs0UZldaKUAV+B+0vqqvS2IpIn+NxY8sps4Q=
X-Gm-Gg: AYBFou1oUzNxEluCjrJLbcFL+6WteJUJLr3Q5WOgonCi4wQ5kLpIKy2cITb0ip8cO1r
	gXwlcu9nXyneMsNcz/cqZYpj4I6yVaMvuvYVdulIEIDrFqOj5Z0Mg0uinBh2/rIU6p6gMYLI6c0
	NIS3efQhMkkvcrreyL7rK7wZBvbfL8ObvQ7b5bvqXpKEdjsV/cK2HHkQt6GGxJcUN7b+Qhjc4T6
	3fGMu8MVGZMwFa9x8e50uVHhkVtOKAvILDeq7GcuwLPIG1lo94+rIQ1yjyockIOXqlsBb0hnXnN
	hkol9/mzzwbZ3cmlOqLBluszSZP2YyNllc9uhuKEiON9keGDT5am3Wspo2/GYCwJ9EUpr221+x4
	2Y4CH/BnEFgI0IBDC9v2Bb+35RYg8inSw5B7+Sgi5A3/u/38Tw7GSvmJaYd38TjQlkp0Gvj9wn6
	HUuHwCyN2XWgiwFdH6cnDpMMgzpi6lK/Y1CirPhssm17cuAKXfoxVR/FJ3UJYDaTmns/bDNk3DK
	/R0oLWXk13SSp3hsqoChH+GLOxrkpclPhI9huC2o2CU3gw=
X-Received: by 2002:a05:600c:c0da:b0:4a1:e000:fdf with SMTP id 5b1f17b1804b1-4a1e0001230mr57715215e9.0.1792383467032;
        Sun, 18 Oct 2026 21:17:47 -0700 (PDT)
Received: from spartian.home ([2a01:cb1c:76:ed00:602f:c5f4:d108:b925])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd500e75sm20090449f8f.42.2026.10.18.21.17.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 21:17:44 -0700 (PDT)
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
Subject: [RFC PATCH 04/18] beamfs: add error budget, alerts and clock
Date: Mon, 19 Oct 2026 06:17:14 +0200
Message-ID: <20261019041728.327785-5-aurelien@hackers.camp>
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

budget.c records, for each data block, the largest number of symbols
corrected in any of its codewords: a high-water mark of the correction
capacity the block has used, which reads as the margin it has left.

alert.c sends a KOBJ_CHANGE uevent on the filesystem's kobject when a
threshold is crossed: a block reached zero margin, uncorrectable
codewords within an interval, or blocks at zero margin. Notifications
are rate-limited per class; what to do about them is left to
userspace.

clock.c anchors the monotonic timestamps of the event journal to the
wall clock, with the accuracy of that clock as declared by the
clock_source module parameter.

Assisted-by: LLM
Signed-off-by: Aurelien DESBRIERES <aurelien@hackers.camp>
---
 fs/beamfs/alert.c  | 153 +++++++++++++++++++++++++++
 fs/beamfs/budget.c | 252 +++++++++++++++++++++++++++++++++++++++++++++
 fs/beamfs/clock.c  | 132 ++++++++++++++++++++++++
 3 files changed, 537 insertions(+)
 create mode 100644 fs/beamfs/alert.c
 create mode 100644 fs/beamfs/budget.c
 create mode 100644 fs/beamfs/clock.c

diff --git a/fs/beamfs/alert.c b/fs/beamfs/alert.c
new file mode 100644
index 000000000000..27fcba769742
--- /dev/null
+++ b/fs/beamfs/alert.c
@@ -0,0 +1,153 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * beamfs -- threshold alerting
+ *
+ * Author: Aurelien DESBRIERES <aurelien@hackers.camp>
+ *
+ * Everything beamfs knows about its own health is already recorded:
+ * dmesg carries each uncorrectable, the RS journal holds coordinates,
+ * the error budget holds remaining margin. All of it has to be looked
+ * at, and on an unattended system nobody looks.
+ *
+ * This notifies. A uevent on the filesystem's kobject when a threshold
+ * is crossed, which udev, systemd or a bare daemon can act on. The
+ * kernel says a line has been crossed and stops there; deciding what
+ * that means -- page an operator, schedule a copy, ground the aircraft
+ * -- is policy, and policy does not belong in a filesystem.
+ *
+ * Three thresholds, each answering a different question:
+ *
+ *   a block reached zero margin      is this volume about to lose data
+ *   uncorrectables in an interval    is it losing data now
+ *   blocks at zero margin            how much of it is at the edge
+ *
+ * Rate-limited per event class, because the failure mode this must not
+ * have is a volume degrading fast enough to bury the operator in
+ * notifications about it.
+ *
+ * No overlap with the report side: this signals that something
+ * happened, and the RS journal, read by the userspace decoder, says
+ * what. A notification carrying its own diagnosis would duplicate the
+ * decoder and drift from it.
+ */
+
+#include <linux/fs.h>
+#include <linux/kobject.h>
+#include <linux/jiffies.h>
+#include "beamfs.h"
+
+/* Minimum gap between two notifications of the same class. */
+#define BEAMFS_ALERT_INTERVAL_MS 60000
+
+/*
+ * beamfs_alert -- emit one, if the class has not fired recently.
+ *
+ * @class: index into the per-class rate limiter
+ * @reason: short token, the thing a udev rule matches on
+ * @detail: what was seen, for a human reading the log
+ */
+static void beamfs_alert(struct super_block *sb, unsigned int class,
+			 const char *reason, const char *detail)
+{
+	struct beamfs_sb_info *sbi = BEAMFS_SB(sb);
+	char *envp[4];
+	char buf_reason[64];
+	char buf_detail[96];
+	unsigned long now = jiffies;
+
+	if (class >= BEAMFS_ALERT_CLASSES)
+		return;
+	if (!sbi->s_kobj.state_initialized)
+		return;
+
+	/*
+	 * time_before handles wraparound; a zero last_alert means never,
+	 * and jiffies zero at boot would otherwise suppress the first
+	 * alert of the machine's life.
+	 */
+	if (sbi->s_alert_last[class] &&
+	    time_before(now, sbi->s_alert_last[class] +
+			msecs_to_jiffies(BEAMFS_ALERT_INTERVAL_MS)))
+		return;
+	sbi->s_alert_last[class] = now ? now : 1;
+
+	snprintf(buf_reason, sizeof(buf_reason), "BEAMFS_REASON=%s", reason);
+	snprintf(buf_detail, sizeof(buf_detail), "BEAMFS_DETAIL=%s", detail);
+
+	envp[0] = buf_reason;
+	envp[1] = buf_detail;
+	envp[2] = "BEAMFS_ALERT=1";
+	envp[3] = NULL;
+
+	kobject_uevent_env(&sbi->s_kobj, KOBJ_CHANGE, envp);
+
+	pr_warn("beamfs: alert %s: %s\n", reason, detail);
+}
+
+/*
+ * beamfs_alert_uncorrectable -- a block could not be recovered.
+ *
+ * The most serious of the three: data has been lost, not merely put at
+ * risk. Fires on the first one and then no more often than the
+ * interval, since a volume shedding blocks would otherwise bury the
+ * operator in notices about it.
+ */
+void beamfs_alert_uncorrectable(struct super_block *sb, u64 phys)
+{
+	char detail[96];
+
+	snprintf(detail, sizeof(detail), "block %llu unrecoverable",
+		 (unsigned long long)phys);
+	beamfs_alert(sb, BEAMFS_ALERT_UNCORRECTABLE, "uncorrectable", detail);
+}
+
+/*
+ * beamfs_alert_margin -- a block has no correction capacity left.
+ *
+ * It still reads correctly. The next upset in the wrong subblock does
+ * not, and this is the only warning that will come before that read.
+ * Which is the whole argument for the error budget: without it there
+ * is nothing to notify about until the data is already gone.
+ */
+void beamfs_alert_margin(struct super_block *sb, u64 phys, unsigned int used)
+{
+	char detail[96];
+
+	if (used < BEAMFS_ERROR_BUDGET_MAX)
+		return;
+
+	snprintf(detail, sizeof(detail),
+		 "block %llu has consumed all %u correctable symbols",
+		 (unsigned long long)phys, (unsigned int)BEAMFS_ERROR_BUDGET_MAX);
+	beamfs_alert(sb, BEAMFS_ALERT_MARGIN, "no-margin", detail);
+}
+
+/*
+ * beamfs_alert_check_rate -- has correction activity crossed the line?
+ *
+ * Called by the scrubber at the end of a sweep, where a whole-volume
+ * figure exists. s_alert_rate_limit is the number of corrections per
+ * sweep an operator is willing to see; zero disables the check, which
+ * is the default because the right number depends on the deployment
+ * and inventing one would produce either noise or silence.
+ */
+void beamfs_alert_check_rate(struct super_block *sb)
+{
+	struct beamfs_sb_info *sbi = BEAMFS_SB(sb);
+	u64 delta;
+	char detail[96];
+
+	if (!sbi->s_alert_rate_limit)
+		return;
+
+	delta = sbi->s_scrub_corrected - sbi->s_alert_last_corrected;
+	sbi->s_alert_last_corrected = sbi->s_scrub_corrected;
+
+	if (delta < sbi->s_alert_rate_limit)
+		return;
+
+	snprintf(detail, sizeof(detail),
+		 "%llu blocks corrected in one sweep, limit %u",
+		 delta, sbi->s_alert_rate_limit);
+	beamfs_alert(sb, BEAMFS_ALERT_RATE, "correction-rate", detail);
+}
diff --git a/fs/beamfs/budget.c b/fs/beamfs/budget.c
new file mode 100644
index 000000000000..61e858d3cfe8
--- /dev/null
+++ b/fs/beamfs/budget.c
@@ -0,0 +1,252 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * beamfs -- per-block error budget
+ *
+ * Author: Aurelien DESBRIERES <aurelien@hackers.camp>
+ *
+ * How much correction capacity a block has left, rather than how many
+ * corrections it has had.
+ *
+ * The RS journal holds the last 64 events. That answers "what happened
+ * recently" and says nothing about the state of the volume: a block
+ * that has quietly taken seven of its eight correctable symbols reads
+ * back perfectly and is one upset away from unrecoverable, and nothing
+ * anywhere would say so before the read that fails.
+ *
+ * One byte per data block records the worst subblock's corrected-symbol
+ * count. An operator can then ask how much margin is left -- a fuel
+ * gauge rather than an odometer.
+ *
+ * btrfs and ZFS count corrections and do not report margin, because
+ * with redundancy elsewhere there is no margin to report: a bad copy is
+ * replaced from a good one and the question does not arise. On a single
+ * device it does, and the answer is finite and worth knowing.
+ *
+ * The byte is a high-water mark, not a running total. What matters is
+ * the worst any subblock of the block has been, since that is the one
+ * that will saturate first; a count that decayed would report a
+ * healthier block than the medium justifies.
+ */
+
+#include <linux/fs.h>
+#include <linux/buffer_head.h>
+#include "beamfs.h"
+
+/* Is the feature active on this volume? */
+static bool budget_active(struct beamfs_sb_info *sbi)
+{
+	return sbi->s_budget_blk != 0 && sbi->s_budget_len != 0;
+}
+
+/*
+ * Where the byte for @phys lives: which region block, and the offset
+ * within it. Computed, not looked up -- a table mapping blocks to
+ * slots would be metadata needing protection of its own, and the
+ * recursion has to stop somewhere.
+ */
+static bool budget_slot(struct super_block *sb, u64 phys,
+			u64 *region_blk, u32 *offset)
+{
+	struct beamfs_sb_info *sbi = BEAMFS_SB(sb);
+	u64 index;
+
+	if (!budget_active(sbi) || phys < sbi->s_data_start)
+		return false;
+
+	index = phys - sbi->s_data_start;
+	*region_blk = sbi->s_budget_blk + index / BEAMFS_BLOCK_SIZE;
+	*offset = (u32)(index % BEAMFS_BLOCK_SIZE);
+
+	return *region_blk < sbi->s_budget_blk + sbi->s_budget_len;
+}
+
+/*
+ * beamfs_budget_record -- note that @phys needed @symbols corrections.
+ *
+ * Raises the high-water mark if this is the worst the block has seen.
+ * A no-op when the value would not change, so a volume being read
+ * repeatedly does not rewrite the region for nothing.
+ */
+void beamfs_budget_record(struct super_block *sb, u64 phys,
+			  unsigned int symbols)
+{
+	struct buffer_head *bh;
+	u64 region_blk;
+	u32 offset;
+	u8 capped;
+
+	if (!symbols || !budget_slot(sb, phys, &region_blk, &offset))
+		return;
+
+	capped = (u8)min_t(unsigned int, symbols, BEAMFS_ERROR_BUDGET_MAX);
+
+	bh = sb_bread(sb, region_blk);
+	if (!bh)
+		return;
+
+	if (((u8 *)bh->b_data)[offset] < capped) {
+		lock_buffer(bh);
+		((u8 *)bh->b_data)[offset] = capped;
+		unlock_buffer(bh);
+		mark_buffer_dirty(bh);
+
+		/*
+		 * Only on the transition. A block already at the limit
+		 * that gets corrected again has not crossed anything, and
+		 * notifying every time would say the same thing forever.
+		 */
+		beamfs_alert_margin(sb, phys, capped);
+	}
+	brelse(bh);
+}
+
+/*
+ * The next block at or past @from whose margin has fallen to @threshold.
+ *
+ * The budget region is one byte per block -- a quarter of a per mille of
+ * the volume -- so reading it end to end costs four thousand times less
+ * than sweeping the data it describes. It is already the index of where
+ * attention is due; nothing needed building, only reading.
+ *
+ * That asymmetry is the point. A block that has spent six of its eight
+ * correctable symbols is two upsets from unrecoverable and should be
+ * looked at often. A block that has never needed a correction can wait.
+ * Sweeping both at one rate spends the same effort on 262051 untouched
+ * blocks as on the one that matters -- measured, on a volume with
+ * exactly that shape.
+ *
+ * Returns the block number, or 0 when the region holds nothing above the
+ * threshold from @from onward. Reads a budget block at a time rather than
+ * a byte, since the caller walks forward and the buffer cache will have
+ * the next byte already.
+ */
+u64 beamfs_budget_next_worn(struct super_block *sb, u64 from, u8 threshold)
+{
+	struct beamfs_sb_info *sbi = BEAMFS_SB(sb);
+	u64 first, last, phys;
+
+	if (!sbi->s_budget_len)
+		return 0;
+
+	first = max_t(u64, from, sbi->s_data_start);
+	last  = sbi->s_data_start + sbi->s_nblocks;
+	phys  = first;
+
+	/*
+	 * One block read per 4096 blocks examined, not one per block.
+	 *
+	 * The region is a flat array of one byte per data block, so a
+	 * single 4096-byte read covers 4096 of them. Going through
+	 * beamfs_budget_read for each would cost an sb_bread and a brelse
+	 * per byte: on a 58 GiB volume that is 15115022 calls to find one
+	 * worn block, and the sweep asks once per step, every hundred
+	 * milliseconds at the default pace.
+	 */
+	while (phys < last) {
+		struct buffer_head *bh;
+		u64 region_blk;
+		u32 offset;
+		u32 span;
+		const u8 *p;
+		u32 i;
+
+		if (!budget_slot(sb, phys, &region_blk, &offset))
+			return 0;
+
+		/* Blocks described by the remainder of this region block. */
+		span = min_t(u64, BEAMFS_BLOCK_SIZE - offset, last - phys);
+
+		bh = sb_bread(sb, region_blk);
+		if (!bh) {
+			/*
+			 * Unreadable region block: skip what it covered
+			 * rather than stop. A wear scan that gives up on
+			 * one bad block stops watching everything past it.
+			 */
+			phys += span;
+			continue;
+		}
+
+		p = (const u8 *)bh->b_data + offset;
+		for (i = 0; i < span; i++) {
+			if (p[i] >= threshold) {
+				brelse(bh);
+				return phys + i;
+			}
+		}
+		brelse(bh);
+		phys += span;
+	}
+	return 0;
+}
+
+/*
+ * beamfs_budget_read -- worst corrected-symbol count seen for @phys.
+ *
+ * Returns 0 when the feature is off or the byte cannot be read, which
+ * reads as "no wear known" rather than "no wear" -- the distinction
+ * belongs to the caller.
+ */
+u8 beamfs_budget_read(struct super_block *sb, u64 phys)
+{
+	struct buffer_head *bh;
+	u64 region_blk;
+	u32 offset;
+	u8 v;
+
+	if (!budget_slot(sb, phys, &region_blk, &offset))
+		return 0;
+
+	bh = sb_bread(sb, region_blk);
+	if (!bh)
+		return 0;
+	v = ((u8 *)bh->b_data)[offset];
+	brelse(bh);
+
+	return v;
+}
+
+/*
+ * beamfs_budget_histogram -- how many blocks sit at each wear level.
+ *
+ * @hist must hold BEAMFS_ERROR_BUDGET_MAX + 1 entries. Index n is the
+ * number of blocks whose worst subblock needed n corrections, so
+ * hist[0] is untouched blocks and hist[MAX] is blocks with no margin
+ * left.
+ *
+ * The whole region is read, which on a 931 GiB volume is about 233 MiB.
+ * That is a deliberate cost paid on request: the alternative is
+ * maintaining counters in memory, which would have to be reconstructed
+ * at mount anyway and would drift against the medium in between.
+ */
+void beamfs_budget_histogram(struct super_block *sb, u64 *hist)
+{
+	struct beamfs_sb_info *sbi = BEAMFS_SB(sb);
+	u64 blk;
+	u64 seen = 0;
+
+	memset(hist, 0, (BEAMFS_ERROR_BUDGET_MAX + 1) * sizeof(*hist));
+	if (!budget_active(sbi))
+		return;
+
+	for (blk = 0; blk < sbi->s_budget_len; blk++) {
+		struct buffer_head *bh = sb_bread(sb, sbi->s_budget_blk + blk);
+		u32 i;
+
+		if (!bh)
+			continue;
+
+		for (i = 0; i < BEAMFS_BLOCK_SIZE; i++) {
+			u8 v = ((u8 *)bh->b_data)[i];
+
+			if (seen >= sbi->s_nblocks)
+				break;
+			seen++;
+			if (v > BEAMFS_ERROR_BUDGET_MAX)
+				v = BEAMFS_ERROR_BUDGET_MAX;
+			hist[v]++;
+		}
+		brelse(bh);
+		cond_resched();
+	}
+}
diff --git a/fs/beamfs/clock.c b/fs/beamfs/clock.c
new file mode 100644
index 000000000000..55ea9977af1f
--- /dev/null
+++ b/fs/beamfs/clock.c
@@ -0,0 +1,132 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * beamfs -- clock anchor for the radiation event journal
+ *
+ * Author: Aurelien DESBRIERES <aurelien@hackers.camp>
+ *
+ * Journal entries carry ktime_get_ns(): monotonic since boot, which
+ * orders events exactly and dates none of them. That is the right
+ * clock for an entry -- it cannot jump, so the interval between two
+ * corrections is good to the timer's resolution, and a burst of forty
+ * upsets inside three milliseconds reads as exactly that.
+ *
+ * What it cannot say is when. This supplies the other half: what the
+ * wall clock read at a known point on the monotonic scale, and what
+ * that wall clock was worth at the time.
+ *
+ * Declaring the uncertainty rather than implying a precision is the
+ * whole point. A journal that dates events to the nanosecond on a
+ * machine synchronised by NTP is claiming something it cannot support,
+ * and an auditor who notices that has reason to doubt everything else
+ * in it. Instrumentation states its source and its error; so does this.
+ */
+
+#include <linux/fs.h>
+#include <linux/buffer_head.h>
+#include <linux/timekeeping.h>
+#include <linux/moduleparam.h>
+#include "beamfs.h"
+
+/*
+ * What the wall clock is worth, declared rather than guessed.
+ *
+ * The obvious approach -- ask the timekeeping core whether NTP thinks
+ * it is synchronised -- does not work from a module: do_adjtimex is
+ * not exported, and nothing else exposes STA_UNSYNC. Which is just as
+ * well, because "NTP reports itself synchronised" is a weak claim to
+ * build a forensic record on: it says a daemon is running, not that
+ * the clock is right.
+ *
+ * So it is declared. An operator who has deployed PTP with hardware
+ * timestamping knows it and says so; one who has an RTC and nothing
+ * else says that. The journal then carries a claim its owner made
+ * rather than one this code inferred.
+ *
+ * MiFID II takes the same line on trade timestamps: the requirement is
+ * traceability to a stated reference, not a number on its own. A
+ * timestamp whose provenance is unstated is not evidence, whatever its
+ * resolution.
+ *
+ * The interval between two entries is unaffected by any of this. Those
+ * come from ktime_get_ns(), are good to the timer's resolution, and
+ * need no anchor at all -- a burst of forty upsets inside three
+ * milliseconds reads as exactly that on the worst-served machine.
+ */
+static u32 beamfs_clock_source = BEAMFS_CLOCK_UNKNOWN;
+module_param_named(clock_source, beamfs_clock_source, uint, 0644);
+MODULE_PARM_DESC(clock_source,
+		 "Wall-clock quality for journal anchoring: 0 unknown, 1 RTC, 2 NTP, 3 hardware (PTP/GPS)");
+
+static u32 beamfs_clock_quality(void)
+{
+	u32 q = READ_ONCE(beamfs_clock_source);
+
+	if (q > BEAMFS_CLOCK_HARDWARE)
+		q = BEAMFS_CLOCK_UNKNOWN;
+
+	/*
+	 * A machine that has never had its clock set cannot be
+	 * hardware-disciplined whatever the parameter says. Cheap
+	 * sanity, and it catches the common case of an embedded board
+	 * booting with no RTC and a clock_source setting copied from
+	 * elsewhere.
+	 */
+	if (q > BEAMFS_CLOCK_UNKNOWN &&
+	    ktime_get_real_seconds() < 1000000000LL)
+		return BEAMFS_CLOCK_UNKNOWN;
+
+	return q;
+}
+
+/*
+ * beamfs_clock_anchor -- record the two clocks at one instant.
+ *
+ * Sampled as close together as the code can manage; the gap between
+ * the two reads is a handful of nanoseconds and is not the dominant
+ * error by several orders of magnitude.
+ *
+ * Called at mount and refreshed by the scrubber, so drift is bounded
+ * by the refresh interval instead of accumulating from mount. A volume
+ * left mounted six months would otherwise be dated by a reading six
+ * months stale.
+ */
+void beamfs_clock_anchor(struct super_block *sb)
+{
+	struct beamfs_sb_info *sbi = BEAMFS_SB(sb);
+	u64 mono, real;
+	u32 quality;
+
+	quality = beamfs_clock_quality();
+	mono = ktime_get_ns();
+	real = ktime_get_real_ns();
+
+	sbi->s_anchor_mono = mono;
+	sbi->s_anchor_real = real;
+	sbi->s_anchor_quality = quality;
+
+	if (sbi->s_beamfs_sb) {
+		sbi->s_beamfs_sb->s_anchor_mono = cpu_to_le64(mono);
+		sbi->s_beamfs_sb->s_anchor_real = cpu_to_le64(real);
+		sbi->s_beamfs_sb->s_anchor_quality = cpu_to_le32(quality);
+		beamfs_dirty_super(sbi);
+	}
+}
+
+/*
+ * beamfs_clock_to_real -- turn a journal timestamp into a wall time.
+ *
+ * Returns 0 when there is no anchor, which the caller must read as
+ * "no date available" rather than "the epoch". An entry older than the
+ * anchor converts to a time before it, which is correct: the monotonic
+ * scale is continuous across the anchor.
+ */
+u64 beamfs_clock_to_real(struct beamfs_sb_info *sbi, u64 mono)
+{
+	if (!sbi->s_anchor_real)
+		return 0;
+
+	if (mono >= sbi->s_anchor_mono)
+		return sbi->s_anchor_real + (mono - sbi->s_anchor_mono);
+
+	return sbi->s_anchor_real - (sbi->s_anchor_mono - mono);
+}
-- 
2.55.0

