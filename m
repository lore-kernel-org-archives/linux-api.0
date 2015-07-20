From: Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH] selftests/futex: Fix futex_cmp_requeue_pi() error handling
Date: Mon, 20 Jul 2015 15:48:37 -0700
Message-ID: <e45eef3361e23760f2fa8750d0468d7ec021db6d.1437432376.git.dvhart@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, David Binderman <dcb314-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

An earlier (pre-kernel-integration) refactoring of this code mistakenly
replaced the error condition, <, with a >. Use < to detect an error as
opposed to a successful requeue or signal race.

Reported-by: David Binderman <dcb314-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org>
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Signed-off-by: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 .../selftests/futex/functional/futex_requeue_pi_signal_restart.c        | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/futex/functional/futex_requeue_pi_signal_restart.c b/tools/testing/selftests/futex/functional/futex_requeue_pi_signal_restart.c
index 7f0c756..3d7dc6a 100644
--- a/tools/testing/selftests/futex/functional/futex_requeue_pi_signal_restart.c
+++ b/tools/testing/selftests/futex/functional/futex_requeue_pi_signal_restart.c
@@ -191,7 +191,7 @@ int main(int argc, char *argv[])
 		if (res > 0) {
 			atomic_set(&requeued, 1);
 			break;
-		} else if (res > 0) {
+		} else if (res < 0) {
 			error("FUTEX_CMP_REQUEUE_PI failed\n", errno);
 			ret = RET_ERROR;
 			break;
-- 
2.1.4


-- 
Darren Hart
Intel Open Source Technology Center
