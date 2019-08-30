From: Andy Lutomirski <luto@kernel.org>
Subject: [PATCH 1/7] random: Don't wake crng_init_wait when crng_init == 1
Date: Thu, 29 Aug 2019 18:11:36 -0700
Message-ID: <5f729c0feb4aa105e6440124de099e0cf903d024.1567126741.git.luto@kernel.org>
References: <cover.1567126741.git.luto@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1567126741.git.luto@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Theodore Tso <tytso@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

crng_init_wait is only used to wayt for crng_init to be set to 2, so
there's no point to waking it when crng_init is set to 1.  Remove the
unnecessary wake_up_interruptible() call.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 drivers/char/random.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 5d5ea4ce1442..d152612e08fc 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -946,7 +946,6 @@ static int crng_fast_load(const char *cp, size_t len)
 	if (crng_init_cnt >= CRNG_INIT_CNT_THRESH) {
 		invalidate_batched_entropy();
 		crng_init = 1;
-		wake_up_interruptible(&crng_init_wait);
 		pr_notice("random: fast init done\n");
 	}
 	return 1;
-- 
2.21.0
