From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/6] blkcg: Track DISCARD statistics and output them in cgroup io.stat
Date: Wed, 18 Jul 2018 04:47:41 -0700
Message-ID: <20180718114741.2580313-7-tj@kernel.org>
References: <20180718114741.2580313-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180718114741.2580313-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: michaelcallahan@fb.com, newella@fb.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org, Tejun Heo <tj@kernel.org>
List-Id: linux-api@vger.kernel.org

Add tracking of REQ_OP_DISCARD ios to the per-cgroup io.stat.  Two
fields, dbytes and dios, to respectively count the total bytes and
number of discards are added.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andy Newell <newella@fb.com>
Cc: Michael Callahan <michaelcallahan@fb.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 10 ++++++----
 block/blk-cgroup.c                      | 13 +++++++++----
 include/linux/blk-cgroup.h              |  5 ++++-
 3 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 569ce27b85e5..3afe10fa82bc 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1317,17 +1317,19 @@ IO Interface Files
 	Lines are keyed by $MAJ:$MIN device numbers and not ordered.
 	The following nested keys are defined.
 
-	  ======	===================
+	  ======	=====================
 	  rbytes	Bytes read
 	  wbytes	Bytes written
 	  rios		Number of read IOs
 	  wios		Number of write IOs
-	  ======	===================
+	  dbytes	Bytes discarded
+	  dios		Number of discard IOs
+	  ======	=====================
 
 	An example read output follows:
 
-	  8:16 rbytes=1459200 wbytes=314773504 rios=192 wios=353
-	  8:0 rbytes=90430464 wbytes=299008000 rios=8950 wios=1252
+	  8:16 rbytes=1459200 wbytes=314773504 rios=192 wios=353 dbytes=0 dios=0
+	  8:0 rbytes=90430464 wbytes=299008000 rios=8950 wios=1252 dbytes=50331648 dios=3021
 
   io.weight
 	A read-write flat-keyed file which exists on non-root cgroups.
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 7e2c19ce1a08..1942357d7165 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -567,6 +567,7 @@ u64 __blkg_prfill_rwstat(struct seq_file *sf, struct blkg_policy_data *pd,
 		[BLKG_RWSTAT_WRITE]	= "Write",
 		[BLKG_RWSTAT_SYNC]	= "Sync",
 		[BLKG_RWSTAT_ASYNC]	= "Async",
+		[BLKG_RWSTAT_DISCARD]	= "Discard",
 	};
 	const char *dname = blkg_dev_name(pd->blkg);
 	u64 v;
@@ -580,7 +581,8 @@ u64 __blkg_prfill_rwstat(struct seq_file *sf, struct blkg_policy_data *pd,
 			   (unsigned long long)atomic64_read(&rwstat->aux_cnt[i]));
 
 	v = atomic64_read(&rwstat->aux_cnt[BLKG_RWSTAT_READ]) +
-		atomic64_read(&rwstat->aux_cnt[BLKG_RWSTAT_WRITE]);
+		atomic64_read(&rwstat->aux_cnt[BLKG_RWSTAT_WRITE]) +
+		atomic64_read(&rwstat->aux_cnt[BLKG_RWSTAT_DISCARD]);
 	seq_printf(sf, "%s Total %llu\n", dname, (unsigned long long)v);
 	return v;
 }
@@ -959,7 +961,7 @@ static int blkcg_print_stat(struct seq_file *sf, void *v)
 		const char *dname;
 		char *buf;
 		struct blkg_rwstat rwstat;
-		u64 rbytes, wbytes, rios, wios;
+		u64 rbytes, wbytes, rios, wios, dbytes, dios;
 		size_t size = seq_get_buf(sf, &buf), off = 0;
 		int i;
 		bool has_stats = false;
@@ -982,19 +984,22 @@ static int blkcg_print_stat(struct seq_file *sf, void *v)
 					offsetof(struct blkcg_gq, stat_bytes));
 		rbytes = atomic64_read(&rwstat.aux_cnt[BLKG_RWSTAT_READ]);
 		wbytes = atomic64_read(&rwstat.aux_cnt[BLKG_RWSTAT_WRITE]);
+		dbytes = atomic64_read(&rwstat.aux_cnt[BLKG_RWSTAT_DISCARD]);
 
 		rwstat = blkg_rwstat_recursive_sum(blkg, NULL,
 					offsetof(struct blkcg_gq, stat_ios));
 		rios = atomic64_read(&rwstat.aux_cnt[BLKG_RWSTAT_READ]);
 		wios = atomic64_read(&rwstat.aux_cnt[BLKG_RWSTAT_WRITE]);
+		dios = atomic64_read(&rwstat.aux_cnt[BLKG_RWSTAT_DISCARD]);
 
 		spin_unlock_irq(blkg->q->queue_lock);
 
 		if (rbytes || wbytes || rios || wios) {
 			has_stats = true;
 			off += scnprintf(buf+off, size-off,
-					 "rbytes=%llu wbytes=%llu rios=%llu wios=%llu",
-					 rbytes, wbytes, rios, wios);
+					 "rbytes=%llu wbytes=%llu rios=%llu wios=%llu dbytes=%llu dios=%llu",
+					 rbytes, wbytes, rios, wios,
+					 dbytes, dios);
 		}
 
 		if (!blkcg_debug_stats)
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index de57de4831d5..3bed5e02a873 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -35,6 +35,7 @@ enum blkg_rwstat_type {
 	BLKG_RWSTAT_WRITE,
 	BLKG_RWSTAT_SYNC,
 	BLKG_RWSTAT_ASYNC,
+	BLKG_RWSTAT_DISCARD,
 
 	BLKG_RWSTAT_NR,
 	BLKG_RWSTAT_TOTAL = BLKG_RWSTAT_NR,
@@ -649,7 +650,9 @@ static inline void blkg_rwstat_add(struct blkg_rwstat *rwstat,
 {
 	struct percpu_counter *cnt;
 
-	if (op_is_write(op))
+	if (op_is_discard(op))
+		cnt = &rwstat->cpu_cnt[BLKG_RWSTAT_DISCARD];
+	else if (op_is_write(op))
 		cnt = &rwstat->cpu_cnt[BLKG_RWSTAT_WRITE];
 	else
 		cnt = &rwstat->cpu_cnt[BLKG_RWSTAT_READ];
-- 
2.17.1
