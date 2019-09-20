From: Andy Lutomirski <luto@kernel.org>
Subject: [PATCH v2 4/7] random: Make /dev/random be almost like /dev/urandom
Date: Fri, 20 Sep 2019 07:36:26 -0700
Message-ID: <b3108e0defc82daee3f14a0c794464b6e74c5e71.1568990048.git.luto@kernel.org>
References: <cover.1568990048.git.luto@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1568990048.git.luto@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Theodore Tso <tytso@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, Lennart Poettering <mzxreary@0pointer.de>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

This patch changes the read semantics of /dev/random to be the same
as /dev/urandom except that reads will block until the CRNG is
ready.

None of the cleanups that this enables have been done yet.  As a
result, this gives a warning about an unused function.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 drivers/char/random.c | 55 +++++++++++--------------------------------
 1 file changed, 14 insertions(+), 41 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 1ad2c7eaf675..29a158d9353c 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -354,7 +354,6 @@
 #define INPUT_POOL_WORDS	(1 << (INPUT_POOL_SHIFT-5))
 #define OUTPUT_POOL_SHIFT	10
 #define OUTPUT_POOL_WORDS	(1 << (OUTPUT_POOL_SHIFT-5))
-#define SEC_XFER_SIZE		512
 #define EXTRACT_SIZE		10
 
 
@@ -803,7 +802,6 @@ static void credit_entropy_bits(struct entropy_store *r, int nbits)
 		if (entropy_bits >= random_read_wakeup_bits &&
 		    wq_has_sleeper(&random_read_wait)) {
 			wake_up_interruptible(&random_read_wait);
-			kill_fasync(&fasync, SIGIO, POLL_IN);
 		}
 		/* If the input pool is getting full, and the blocking
 		 * pool has room, send some entropy to the blocking
@@ -1031,6 +1029,7 @@ static void crng_reseed(struct crng_state *crng, struct entropy_store *r)
 		crng_init = 2;
 		process_random_ready_list();
 		wake_up_interruptible(&crng_init_wait);
+		kill_fasync(&fasync, SIGIO, POLL_IN);
 		pr_notice("random: crng init done\n");
 		if (unseeded_warning.missed) {
 			pr_notice("random: %d get_random_xx warning(s) missed "
@@ -1921,43 +1920,6 @@ void rand_initialize_disk(struct gendisk *disk)
 }
 #endif
 
-static ssize_t
-_random_read(int nonblock, char __user *buf, size_t nbytes)
-{
-	ssize_t n;
-
-	if (nbytes == 0)
-		return 0;
-
-	nbytes = min_t(size_t, nbytes, SEC_XFER_SIZE);
-	while (1) {
-		n = extract_entropy_user(&blocking_pool, buf, nbytes);
-		if (n < 0)
-			return n;
-		trace_random_read(n*8, (nbytes-n)*8,
-				  ENTROPY_BITS(&blocking_pool),
-				  ENTROPY_BITS(&input_pool));
-		if (n > 0)
-			return n;
-
-		/* Pool is (near) empty.  Maybe wait and retry. */
-		if (nonblock)
-			return -EAGAIN;
-
-		wait_event_interruptible(random_read_wait,
-		    blocking_pool.initialized &&
-		    (ENTROPY_BITS(&input_pool) >= random_read_wakeup_bits));
-		if (signal_pending(current))
-			return -ERESTARTSYS;
-	}
-}
-
-static ssize_t
-random_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
-{
-	return _random_read(file->f_flags & O_NONBLOCK, buf, nbytes);
-}
-
 static ssize_t
 urandom_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 {
@@ -1981,15 +1943,26 @@ urandom_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 	return ret;
 }
 
+static ssize_t
+random_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
+{
+	int ret;
+
+	ret = wait_for_random_bytes();
+	if (ret != 0)
+		return ret;
+	return urandom_read(file, buf, nbytes, ppos);
+}
+
 static __poll_t
 random_poll(struct file *file, poll_table * wait)
 {
 	__poll_t mask;
 
-	poll_wait(file, &random_read_wait, wait);
+	poll_wait(file, &crng_init_wait, wait);
 	poll_wait(file, &random_write_wait, wait);
 	mask = 0;
-	if (ENTROPY_BITS(&input_pool) >= random_read_wakeup_bits)
+	if (crng_ready())
 		mask |= EPOLLIN | EPOLLRDNORM;
 	if (ENTROPY_BITS(&input_pool) < random_write_wakeup_bits)
 		mask |= EPOLLOUT | EPOLLWRNORM;
-- 
2.21.0
