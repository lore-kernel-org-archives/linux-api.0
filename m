From: Andy Lutomirski <luto@kernel.org>
Subject: [PATCH 7/7] random: Remove kernel.random.read_wakeup_threshold
Date: Thu, 29 Aug 2019 18:11:42 -0700
Message-ID: <49f02ca58d95d1036ecc21c98ee544ddac5511ed.1567126741.git.luto@kernel.org>
References: <cover.1567126741.git.luto@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1567126741.git.luto@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Theodore Tso <tytso@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

It has no effect any more, so remove it.  We can revert this if
there is some user code that expects to be able to set this sysctl.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 drivers/char/random.c | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 99fea5cc29a8..2a284f30cac4 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -369,12 +369,6 @@
 #define ENTROPY_SHIFT 3
 #define ENTROPY_BITS(r) ((r)->entropy_count >> ENTROPY_SHIFT)
 
-/*
- * The minimum number of bits of entropy before we wake up a read on
- * /dev/random.  Should be enough to do a significant reseed.
- */
-static int random_read_wakeup_bits = 64;
-
 /*
  * If the entropy count falls under this number of bits, then we
  * should wake up processes which are selecting or polling on write
@@ -1982,8 +1976,7 @@ SYSCALL_DEFINE3(getrandom, char __user *, buf, size_t, count,
 
 #include <linux/sysctl.h>
 
-static int min_read_thresh = 8, min_write_thresh;
-static int max_read_thresh = OUTPUT_POOL_WORDS * 32;
+static int min_write_thresh;
 static int max_write_thresh = INPUT_POOL_WORDS * 32;
 static int random_min_urandom_seed = 60;
 static char sysctl_bootid[16];
@@ -2058,15 +2051,6 @@ struct ctl_table random_table[] = {
 		.proc_handler	= proc_do_entropy,
 		.data		= &input_pool.entropy_count,
 	},
-	{
-		.procname	= "read_wakeup_threshold",
-		.data		= &random_read_wakeup_bits,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &min_read_thresh,
-		.extra2		= &max_read_thresh,
-	},
 	{
 		.procname	= "write_wakeup_threshold",
 		.data		= &random_write_wakeup_bits,
-- 
2.21.0
