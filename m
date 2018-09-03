From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 05/10] signal: send_sig_all no longer needs SEND_SIG_FORCED
Date: Mon,  3 Sep 2018 22:44:25 +0200
Message-ID: <20180903204430.25473-5-ebiederm@xmission.com>
References: <87musyl3fa.fsf@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87musyl3fa.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

Now that send_signal always delivers SEND_SIG_PRIV signals to a pid
namespace init it is no longer necessary to use SEND_SIG_FORCED when
calling do_send_sig_info to ensure that pid namespace inits are
signaled and possibly killed.  Using SEND_SIG_PRIV is sufficient.

So use SEND_SIG_PRIV so that userspace when it receives a SIGTERM can
tell that the kernel sent the signal and not some random userspace
application.

Fixes: b82c32872db2 ("sysrq: use SEND_SIG_FORCED instead of force_sig()")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 drivers/tty/sysrq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
index 06ed20dd01ba..ad1ee5d01b53 100644
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -348,7 +348,7 @@ static void send_sig_all(int sig)
 		if (is_global_init(p))
 			continue;
 
-		do_send_sig_info(sig, SEND_SIG_FORCED, p, PIDTYPE_MAX);
+		do_send_sig_info(sig, SEND_SIG_PRIV, p, PIDTYPE_MAX);
 	}
 	read_unlock(&tasklist_lock);
 }
-- 
2.17.1
