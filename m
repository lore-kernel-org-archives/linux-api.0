From: Andy Lutomirski <luto@kernel.org>
Subject: [PATCH v3 4/8] random: Ignore GRND_RANDOM in getentropy(2)
Date: Mon, 23 Dec 2019 00:20:47 -0800
Message-ID: <705c5a091b63cc5da70c99304bb97e0109be0a26.1577088521.git.luto@kernel.org>
References: <cover.1577088521.git.luto@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1577088521.git.luto@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, Lennart Poettering <mzxreary@0pointer.de>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, Stephan Mueller <smueller@chronox.de>, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

The separate blocking pool is going away.  Start by ignoring
GRND_RANDOM in getentropy(2).

This should not materially break any API.  Any code that worked
without this change should work at least as well with this change.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 drivers/char/random.c       | 3 ---
 include/uapi/linux/random.h | 2 +-
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 675b8a48e18a..c0a3032b30ca 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -2206,9 +2206,6 @@ SYSCALL_DEFINE3(getrandom, char __user *, buf, size_t, count,
 	if (count > INT_MAX)
 		count = INT_MAX;
 
-	if (flags & GRND_RANDOM)
-		return _random_read(flags & GRND_NONBLOCK, buf, count);
-
 	if (!(flags & GRND_INSECURE) && !crng_ready()) {
 		if (flags & GRND_NONBLOCK)
 			return -EAGAIN;
diff --git a/include/uapi/linux/random.h b/include/uapi/linux/random.h
index c092d20088d3..dcc1b3e6106f 100644
--- a/include/uapi/linux/random.h
+++ b/include/uapi/linux/random.h
@@ -48,7 +48,7 @@ struct rand_pool_info {
  * Flags for getrandom(2)
  *
  * GRND_NONBLOCK	Don't block and return EAGAIN instead
- * GRND_RANDOM		Use the /dev/random pool instead of /dev/urandom
+ * GRND_RANDOM		No effect
  * GRND_INSECURE	Return non-cryptographic random bytes
  */
 #define GRND_NONBLOCK	0x0001
-- 
2.23.0
