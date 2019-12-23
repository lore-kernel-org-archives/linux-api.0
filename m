From: Andy Lutomirski <luto@kernel.org>
Subject: [PATCH v3 2/8] random: Add a urandom_read_nowait() for random APIs that don't warn
Date: Mon, 23 Dec 2019 00:20:45 -0800
Message-ID: <c87ab200588de746431d9f916501ef11e5242b13.1577088521.git.luto@kernel.org>
References: <cover.1577088521.git.luto@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1577088521.git.luto@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, Lennart Poettering <mzxreary@0pointer.de>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, Stephan Mueller <smueller@chronox.de>, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

/dev/random and getrandom() never warn.  Split the meat of
urandom_read() into urandom_read_nowarn() and leave the warning code
in urandom_read().

This has no effect on kernel behavior, but it makes subsequent
patches more straightforward.  It also makes the fact that
getrandom() never warns more obvious.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 drivers/char/random.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index c6252a3a4aec..7b46751772e5 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -2018,12 +2018,23 @@ random_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 	return _random_read(file->f_flags & O_NONBLOCK, buf, nbytes);
 }
 
+static ssize_t
+urandom_read_nowarn(struct file *file, char __user *buf, size_t nbytes,
+		    loff_t *ppos)
+{
+	int ret;
+
+	nbytes = min_t(size_t, nbytes, INT_MAX >> (ENTROPY_SHIFT + 3));
+	ret = extract_crng_user(buf, nbytes);
+	trace_urandom_read(8 * nbytes, 0, ENTROPY_BITS(&input_pool));
+	return ret;
+}
+
 static ssize_t
 urandom_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 {
 	unsigned long flags;
 	static int maxwarn = 10;
-	int ret;
 
 	if (!crng_ready() && maxwarn > 0) {
 		maxwarn--;
@@ -2035,10 +2046,8 @@ urandom_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 		crng_init_cnt = 0;
 		spin_unlock_irqrestore(&primary_crng.lock, flags);
 	}
-	nbytes = min_t(size_t, nbytes, INT_MAX >> (ENTROPY_SHIFT + 3));
-	ret = extract_crng_user(buf, nbytes);
-	trace_urandom_read(8 * nbytes, 0, ENTROPY_BITS(&input_pool));
-	return ret;
+
+	return urandom_read_nowarn(file, buf, nbytes, ppos);
 }
 
 static __poll_t
@@ -2200,7 +2209,7 @@ SYSCALL_DEFINE3(getrandom, char __user *, buf, size_t, count,
 		if (unlikely(ret))
 			return ret;
 	}
-	return urandom_read(NULL, buf, count, NULL);
+	return urandom_read_nowarn(NULL, buf, count, NULL);
 }
 
 /********************************************************************
-- 
2.23.0
