From: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 2/5] raid: Require designated initialization of structures
Date: Thu, 31 Jul 2014 16:47:35 -0700
Message-ID: <1d468224409ef2bf46874f817d19389ac5d1b26d.1406850006.git.josh@joshtriplett.org>
References: <3130b0553b15518e3bef6d14c80280beed0f5ff9.1406850006.git.josh@joshtriplett.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kbuild-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3130b0553b15518e3bef6d14c80280beed0f5ff9.1406850006.git.josh@joshtriplett.org>
Sender: linux-kbuild-owner@vger.kernel.org
To: akpm@linux-foundation.org, "J. Bruce Fields" <bfields@fieldses.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Christopher Li <sparse@chrisli.org>, Ingo Molnar <mingo@redhat.com>, Jeff Layton <jlayton@poochiereds.net>, Michal Marek <mmarek@suse.cz>, Neil Brown <neilb@suse.de>, Steven Rostedt <rostedt@goodmis.org>, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-sparse@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Mark raid6_calls and other structures containing function pointers with
__designated_init.  Fix implementations in lib/raid6/ to use designated
initializers; this also simplifies those initializers using the default
initialization of fields to 0.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/raid/pq.h    |  4 ++--
 include/linux/raid/xor.h   |  2 +-
 include/linux/raid_class.h |  2 +-
 lib/raid6/altivec.uc       |  7 +++----
 lib/raid6/avx2.c           | 24 ++++++++++++------------
 lib/raid6/int.uc           |  6 ++----
 lib/raid6/mmx.c            | 14 ++++++--------
 lib/raid6/neon.c           |  7 +++----
 lib/raid6/sse1.c           | 16 ++++++++--------
 lib/raid6/sse2.c           | 24 ++++++++++++------------
 lib/raid6/tilegx.uc        |  6 ++----
 11 files changed, 52 insertions(+), 60 deletions(-)

diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
index 73069cb..2147bff 100644
--- a/include/linux/raid/pq.h
+++ b/include/linux/raid/pq.h
@@ -75,7 +75,7 @@ struct raid6_calls {
 	int  (*valid)(void);	/* Returns 1 if this routine set is usable */
 	const char *name;	/* Name of this routine set */
 	int prefer;		/* Has special performance attribute */
-};
+} __designated_init;
 
 /* Selected algorithm */
 extern struct raid6_calls raid6_call;
@@ -109,7 +109,7 @@ struct raid6_recov_calls {
 	int  (*valid)(void);
 	const char *name;
 	int priority;
-};
+} __designated_init;
 
 extern const struct raid6_recov_calls raid6_recov_intx1;
 extern const struct raid6_recov_calls raid6_recov_ssse3;
diff --git a/include/linux/raid/xor.h b/include/linux/raid/xor.h
index 5a21095..c7df59f 100644
--- a/include/linux/raid/xor.h
+++ b/include/linux/raid/xor.h
@@ -17,6 +17,6 @@ struct xor_block_template {
 		     unsigned long *, unsigned long *);
 	void (*do_5)(unsigned long, unsigned long *, unsigned long *,
 		     unsigned long *, unsigned long *, unsigned long *);
-};
+} __designated_init;
 
 #endif
diff --git a/include/linux/raid_class.h b/include/linux/raid_class.h
index 31e1ff6..603af94 100644
--- a/include/linux/raid_class.h
+++ b/include/linux/raid_class.h
@@ -16,7 +16,7 @@ struct raid_function_template {
 	int (*is_raid)(struct device *);
 	void (*get_resync)(struct device *);
 	void (*get_state)(struct device *);
-};
+} __designated_init;
 
 enum raid_state {
 	RAID_STATE_UNKNOWN = 0,
diff --git a/lib/raid6/altivec.uc b/lib/raid6/altivec.uc
index 7cc12b5..4ff138c 100644
--- a/lib/raid6/altivec.uc
+++ b/lib/raid6/altivec.uc
@@ -118,10 +118,9 @@ int raid6_have_altivec(void)
 #endif
 
 const struct raid6_calls raid6_altivec$# = {
-	raid6_altivec$#_gen_syndrome,
-	raid6_have_altivec,
-	"altivecx$#",
-	0
+	.gen_syndrome = raid6_altivec$#_gen_syndrome,
+	.valid = raid6_have_altivec,
+	.name = "altivecx$#",
 };
 
 #endif /* CONFIG_ALTIVEC */
diff --git a/lib/raid6/avx2.c b/lib/raid6/avx2.c
index bc3b1dd..e56fa06 100644
--- a/lib/raid6/avx2.c
+++ b/lib/raid6/avx2.c
@@ -88,10 +88,10 @@ static void raid6_avx21_gen_syndrome(int disks, size_t bytes, void **ptrs)
 }
 
 const struct raid6_calls raid6_avx2x1 = {
-	raid6_avx21_gen_syndrome,
-	raid6_have_avx2,
-	"avx2x1",
-	1			/* Has cache hints */
+	.gen_syndrome = raid6_avx21_gen_syndrome,
+	.valid = raid6_have_avx2,
+	.name = "avx2x1",
+	.prefer = 1,		/* Has cache hints */
 };
 
 /*
@@ -149,10 +149,10 @@ static void raid6_avx22_gen_syndrome(int disks, size_t bytes, void **ptrs)
 }
 
 const struct raid6_calls raid6_avx2x2 = {
-	raid6_avx22_gen_syndrome,
-	raid6_have_avx2,
-	"avx2x2",
-	1			/* Has cache hints */
+	.gen_syndrome = raid6_avx22_gen_syndrome,
+	.valid = raid6_have_avx2,
+	.name = "avx2x2",
+	.prefer = 1,		/* Has cache hints */
 };
 
 #ifdef CONFIG_X86_64
@@ -241,10 +241,10 @@ static void raid6_avx24_gen_syndrome(int disks, size_t bytes, void **ptrs)
 }
 
 const struct raid6_calls raid6_avx2x4 = {
-	raid6_avx24_gen_syndrome,
-	raid6_have_avx2,
-	"avx2x4",
-	1			/* Has cache hints */
+	.gen_syndrome = raid6_avx24_gen_syndrome,
+	.valid = raid6_have_avx2,
+	.name = "avx2x4",
+	.prefer = 1,		/* Has cache hints */
 };
 #endif
 
diff --git a/lib/raid6/int.uc b/lib/raid6/int.uc
index 5b50f8d..35ad01a 100644
--- a/lib/raid6/int.uc
+++ b/lib/raid6/int.uc
@@ -108,10 +108,8 @@ static void raid6_int$#_gen_syndrome(int disks, size_t bytes, void **ptrs)
 }
 
 const struct raid6_calls raid6_intx$# = {
-	raid6_int$#_gen_syndrome,
-	NULL,		/* always valid */
-	"int" NSTRING "x$#",
-	0
+	.gen_syndrome = raid6_int$#_gen_syndrome,
+	.name = "int" NSTRING "x$#",
 };
 
 #endif
diff --git a/lib/raid6/mmx.c b/lib/raid6/mmx.c
index 590c71c..cdd7d02 100644
--- a/lib/raid6/mmx.c
+++ b/lib/raid6/mmx.c
@@ -75,10 +75,9 @@ static void raid6_mmx1_gen_syndrome(int disks, size_t bytes, void **ptrs)
 }
 
 const struct raid6_calls raid6_mmxx1 = {
-	raid6_mmx1_gen_syndrome,
-	raid6_have_mmx,
-	"mmxx1",
-	0
+	.gen_syndrome = raid6_mmx1_gen_syndrome,
+	.valid = raid6_have_mmx,
+	.name = "mmxx1",
 };
 
 /*
@@ -133,10 +132,9 @@ static void raid6_mmx2_gen_syndrome(int disks, size_t bytes, void **ptrs)
 }
 
 const struct raid6_calls raid6_mmxx2 = {
-	raid6_mmx2_gen_syndrome,
-	raid6_have_mmx,
-	"mmxx2",
-	0
+	.gen_syndrome = raid6_mmx2_gen_syndrome,
+	.valid = raid6_have_mmx,
+	.name = "mmxx2",
 };
 
 #endif
diff --git a/lib/raid6/neon.c b/lib/raid6/neon.c
index 36ad470..99100dd 100644
--- a/lib/raid6/neon.c
+++ b/lib/raid6/neon.c
@@ -41,10 +41,9 @@
 		kernel_neon_end();					\
 	}								\
 	struct raid6_calls const raid6_neonx ## _n = {			\
-		raid6_neon ## _n ## _gen_syndrome,			\
-		raid6_have_neon,					\
-		"neonx" #_n,						\
-		0							\
+		.gen_syndrome = raid6_neon ## _n ## _gen_syndrome,	\
+		.valid = raid6_have_neon,				\
+		.name = "neonx" #_n,					\
 	}
 
 static int raid6_have_neon(void)
diff --git a/lib/raid6/sse1.c b/lib/raid6/sse1.c
index f762971..a9de46e 100644
--- a/lib/raid6/sse1.c
+++ b/lib/raid6/sse1.c
@@ -91,10 +91,10 @@ static void raid6_sse11_gen_syndrome(int disks, size_t bytes, void **ptrs)
 }
 
 const struct raid6_calls raid6_sse1x1 = {
-	raid6_sse11_gen_syndrome,
-	raid6_have_sse1_or_mmxext,
-	"sse1x1",
-	1			/* Has cache hints */
+	.gen_syndrome = raid6_sse11_gen_syndrome,
+	.valid = raid6_have_sse1_or_mmxext,
+	.name = "sse1x1",
+	.prefer = 1,		/* Has cache hints */
 };
 
 /*
@@ -153,10 +153,10 @@ static void raid6_sse12_gen_syndrome(int disks, size_t bytes, void **ptrs)
 }
 
 const struct raid6_calls raid6_sse1x2 = {
-	raid6_sse12_gen_syndrome,
-	raid6_have_sse1_or_mmxext,
-	"sse1x2",
-	1			/* Has cache hints */
+	.gen_syndrome = raid6_sse12_gen_syndrome,
+	.valid = raid6_have_sse1_or_mmxext,
+	.name = "sse1x2",
+	.prefer = 1,		/* Has cache hints */
 };
 
 #endif
diff --git a/lib/raid6/sse2.c b/lib/raid6/sse2.c
index 85b82c8..cd262518aa 100644
--- a/lib/raid6/sse2.c
+++ b/lib/raid6/sse2.c
@@ -89,10 +89,10 @@ static void raid6_sse21_gen_syndrome(int disks, size_t bytes, void **ptrs)
 }
 
 const struct raid6_calls raid6_sse2x1 = {
-	raid6_sse21_gen_syndrome,
-	raid6_have_sse2,
-	"sse2x1",
-	1			/* Has cache hints */
+	.gen_syndrome = raid6_sse21_gen_syndrome,
+	.valid = raid6_have_sse2,
+	.name = "sse2x1",
+	.prefer = 1,		/* Has cache hints */
 };
 
 /*
@@ -151,10 +151,10 @@ static void raid6_sse22_gen_syndrome(int disks, size_t bytes, void **ptrs)
 }
 
 const struct raid6_calls raid6_sse2x2 = {
-	raid6_sse22_gen_syndrome,
-	raid6_have_sse2,
-	"sse2x2",
-	1			/* Has cache hints */
+	.gen_syndrome = raid6_sse22_gen_syndrome,
+	.valid = raid6_have_sse2,
+	.name = "sse2x2",
+	.prefer = 1,		/* Has cache hints */
 };
 
 #ifdef CONFIG_X86_64
@@ -249,10 +249,10 @@ static void raid6_sse24_gen_syndrome(int disks, size_t bytes, void **ptrs)
 }
 
 const struct raid6_calls raid6_sse2x4 = {
-	raid6_sse24_gen_syndrome,
-	raid6_have_sse2,
-	"sse2x4",
-	1			/* Has cache hints */
+	.gen_syndrome = raid6_sse24_gen_syndrome,
+	.valid = raid6_have_sse2,
+	.name = "sse2x4",
+	.prefer = 1,		/* Has cache hints */
 };
 
 #endif /* CONFIG_X86_64 */
diff --git a/lib/raid6/tilegx.uc b/lib/raid6/tilegx.uc
index e7c2945..3077722 100644
--- a/lib/raid6/tilegx.uc
+++ b/lib/raid6/tilegx.uc
@@ -79,8 +79,6 @@ void raid6_tilegx$#_gen_syndrome(int disks, size_t bytes, void **ptrs)
 }
 
 const struct raid6_calls raid6_tilegx$# = {
-	raid6_tilegx$#_gen_syndrome,
-	NULL,
-	"tilegx$#",
-	0
+	.gen_syndrome = raid6_tilegx$#_gen_syndrome,
+	.name = "tilegx$#",
 };
-- 
2.0.1

