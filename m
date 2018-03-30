From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 32/32] random: convert to ->poll_mask
Date: Fri, 30 Mar 2018 17:08:09 +0200
Message-ID: <20180330150809.28094-33-hch@lst.de>
References: <20180330150809.28094-1-hch@lst.de>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180330150809.28094-1-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

The big change is that random_read_wait and random_write_wait are merged
into a single waitqueue that uses keyed wakeups.  Because wait_event_*
doesn't know about that this will lead to occassional spurious wakeups
in _random_read and add_hwgenerator_randomness, but wait_event_* is
designed to handle these and were are not in a a hot path there.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index e5b3d3ba4660..840d80b64431 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -401,8 +401,7 @@ static struct poolinfo {
 /*
  * Static global variables
  */
-static DECLARE_WAIT_QUEUE_HEAD(random_read_wait);
-static DECLARE_WAIT_QUEUE_HEAD(random_write_wait);
+static DECLARE_WAIT_QUEUE_HEAD(random_wait);
 static struct fasync_struct *fasync;
 
 static DEFINE_SPINLOCK(random_ready_list_lock);
@@ -710,7 +709,7 @@ static void credit_entropy_bits(struct entropy_store *r, int nbits)
 
 		/* should we wake readers? */
 		if (entropy_bits >= random_read_wakeup_bits) {
-			wake_up_interruptible(&random_read_wait);
+			wake_up_interruptible_poll(&random_wait, POLLIN);
 			kill_fasync(&fasync, SIGIO, POLL_IN);
 		}
 		/* If the input pool is getting full, send some
@@ -1293,7 +1292,7 @@ static size_t account(struct entropy_store *r, size_t nbytes, int min,
 	trace_debit_entropy(r->name, 8 * ibytes);
 	if (ibytes &&
 	    (r->entropy_count >> ENTROPY_SHIFT) < random_write_wakeup_bits) {
-		wake_up_interruptible(&random_write_wait);
+		wake_up_interruptible_poll(&random_wait, POLLOUT);
 		kill_fasync(&fasync, SIGIO, POLL_OUT);
 	}
 
@@ -1748,7 +1747,7 @@ _random_read(int nonblock, char __user *buf, size_t nbytes)
 		if (nonblock)
 			return -EAGAIN;
 
-		wait_event_interruptible(random_read_wait,
+		wait_event_interruptible(random_wait,
 			ENTROPY_BITS(&input_pool) >=
 			random_read_wakeup_bits);
 		if (signal_pending(current))
@@ -1784,14 +1783,17 @@ urandom_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 	return ret;
 }
 
+static struct wait_queue_head *
+random_get_poll_head(struct file *file, __poll_t events)
+{
+	return &random_wait;
+}
+
 static __poll_t
-random_poll(struct file *file, poll_table * wait)
+random_poll_mask(struct file *file, __poll_t events)
 {
-	__poll_t mask;
+	__poll_t mask = 0;
 
-	poll_wait(file, &random_read_wait, wait);
-	poll_wait(file, &random_write_wait, wait);
-	mask = 0;
 	if (ENTROPY_BITS(&input_pool) >= random_read_wakeup_bits)
 		mask |= EPOLLIN | EPOLLRDNORM;
 	if (ENTROPY_BITS(&input_pool) < random_write_wakeup_bits)
@@ -1890,7 +1892,8 @@ static int random_fasync(int fd, struct file *filp, int on)
 const struct file_operations random_fops = {
 	.read  = random_read,
 	.write = random_write,
-	.poll  = random_poll,
+	.get_poll_head  = random_get_poll_head,
+	.poll_mask  = random_poll_mask,
 	.unlocked_ioctl = random_ioctl,
 	.fasync = random_fasync,
 	.llseek = noop_llseek,
@@ -2223,7 +2226,7 @@ void add_hwgenerator_randomness(const char *buffer, size_t count,
 	 * We'll be woken up again once below random_write_wakeup_thresh,
 	 * or when the calling thread is about to terminate.
 	 */
-	wait_event_interruptible(random_write_wait, kthread_should_stop() ||
+	wait_event_interruptible(random_wait, kthread_should_stop() ||
 			ENTROPY_BITS(&input_pool) <= random_write_wakeup_bits);
 	mix_pool_bytes(poolp, buffer, count);
 	credit_entropy_bits(poolp, entropy);
-- 
2.14.2

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
