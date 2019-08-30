From: Andy Lutomirski <luto@kernel.org>
Subject: [PATCH 3/7] random: Ignore GRND_RANDOM in getentropy(2)
Date: Thu, 29 Aug 2019 18:11:38 -0700
Message-ID: <531cfcd62151916cc7fbade2ecd0311fbafc02a9.1567126741.git.luto@kernel.org>
References: <cover.1567126741.git.luto@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1567126741.git.luto@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Theodore Tso <tytso@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Andy Lutomirski <luto@kernel.org>
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
index acabb870f222..1ad2c7eaf675 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -2135,9 +2135,6 @@ SYSCALL_DEFINE3(getrandom, char __user *, buf, size_t, count,
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
2.21.0
