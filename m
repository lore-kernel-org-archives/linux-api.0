From: Andy Lutomirski <luto@kernel.org>
Subject: [PATCH v3 3/8] random: Add GRND_INSECURE to return best-effort non-cryptographic bytes
Date: Mon, 23 Dec 2019 00:20:46 -0800
Message-ID: <d5473b56cf1fa900ca4bd2b3fc1e5b8874399919.1577088521.git.luto@kernel.org>
References: <cover.1577088521.git.luto@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1577088521.git.luto@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, Lennart Poettering <mzxreary@0pointer.de>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, Stephan Mueller <smueller@chronox.de>, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 drivers/char/random.c       | 11 +++++++++--
 include/uapi/linux/random.h |  2 ++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 7b46751772e5..675b8a48e18a 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -2193,7 +2193,14 @@ SYSCALL_DEFINE3(getrandom, char __user *, buf, size_t, count,
 {
 	int ret;
 
-	if (flags & ~(GRND_NONBLOCK|GRND_RANDOM))
+	if (flags & ~(GRND_NONBLOCK|GRND_RANDOM|GRND_INSECURE))
+		return -EINVAL;
+
+	/*
+	 * Requesting insecure and blocking randomness at the same time makes
+	 * no sense.
+	 */
+	if ((flags & (GRND_INSECURE|GRND_RANDOM)) == (GRND_INSECURE|GRND_RANDOM))
 		return -EINVAL;
 
 	if (count > INT_MAX)
@@ -2202,7 +2209,7 @@ SYSCALL_DEFINE3(getrandom, char __user *, buf, size_t, count,
 	if (flags & GRND_RANDOM)
 		return _random_read(flags & GRND_NONBLOCK, buf, count);
 
-	if (!crng_ready()) {
+	if (!(flags & GRND_INSECURE) && !crng_ready()) {
 		if (flags & GRND_NONBLOCK)
 			return -EAGAIN;
 		ret = wait_for_random_bytes();
diff --git a/include/uapi/linux/random.h b/include/uapi/linux/random.h
index 26ee91300e3e..c092d20088d3 100644
--- a/include/uapi/linux/random.h
+++ b/include/uapi/linux/random.h
@@ -49,8 +49,10 @@ struct rand_pool_info {
  *
  * GRND_NONBLOCK	Don't block and return EAGAIN instead
  * GRND_RANDOM		Use the /dev/random pool instead of /dev/urandom
+ * GRND_INSECURE	Return non-cryptographic random bytes
  */
 #define GRND_NONBLOCK	0x0001
 #define GRND_RANDOM	0x0002
+#define GRND_INSECURE	0x0004
 
 #endif /* _UAPI_LINUX_RANDOM_H */
-- 
2.23.0
