From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH 3/4] firmware: avoid invalid fallback aborts by using killable swait
Date: Wed, 14 Jun 2017 15:20:16 -0700
Message-ID: <20170614222017.14653-4-mcgrof@kernel.org>
References: <20170614222017.14653-1-mcgrof@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170614222017.14653-1-mcgrof@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org
Cc: mfuzzey@parkeon.com, ebiederm@xmission.com, dmitry.torokhov@gmail.com, wagi@monom.org, dwmw2@infradead.org, jewalt@lgsinnovations.com, rafal@milecki.pl, arend.vanspriel@broadcom.com, rjw@rjwysocki.net, yi1.li@linux.intel.com, atull@kernel.org, moritz.fischer@ettus.com, pmladek@suse.com, johannes.berg@intel.com, emmanuel.grumbach@intel.com, luciano.coelho@intel.com, kvalo@codeaurora.org, luto@kernel.org, torvalds@linux-foundation.org, keescook@chromium.org, takahiro.akashi@linaro.org, dhowells@redhat.com, pjones@redhat.com, hdegoede@redhat.com, alan@linux.intel.com, tytso@mit.edu, mtk.manpages@gmail.com, paul.gortmaker@windriver.com, mtosatti@redhat.com, mawilcox@microsoft.com, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, L
List-Id: linux-api@vger.kernel.org

Commit 0cb64249ca500 ("firmware_loader: abort request if wait_for_completion
is interrupted") added via 4.0 added support to abort the fallback mechanism
when a signal was detected and wait_for_completion_interruptible() returned
-ERESTARTSYS -- for instance when a user hits CTRL-C. The abort was overly
*too* effective.

When a child process terminates (successful or not) the signal SIGCHLD can
be sent to the parent process which ran the child in the background and
later triggered a sync request for firmware through a sysfs interface which
relies on the fallback mechanism. This signal in turn can be recieved by the
interruptible swait we constructed on firmware_class and detects it as an
abort *before* userspace could get a chance to write the firmware. Upon
failure -EAGAIN is returned, so userspace is also kept in the dark about
exactly what happened.

We can reproduce the issue with the fw_fallback.sh selftest:

Before this patch:
$ sudo tools/testing/selftests/firmware/fw_fallback.sh
...
tools/testing/selftests/firmware/fw_fallback.sh: error - sync firmware request cancelled due to SIGCHLD

After this patch:
$ sudo tools/testing/selftests/firmware/fw_fallback.sh
...
tools/testing/selftests/firmware/fw_fallback.sh: SIGCHLD on sync ignored as expected

Fix this by making the swait killable -- only killable by SIGKILL (kill -9).
We loose the ability to allow userspace to cancel a write with CTRL-C
(SIGINT), however its been decided the compromise to require SIGKILL is
worth the gains.

Chances of this issue occuring are low due to the number of drivers upstream
exclusively relying on the fallback mechanism for firmware (2 drivers),
however this is observed in the field with custom drivers with sysfs
triggers to load firmware. Only distributions relying on the fallback
mechanism are impacted as well. An example reported issue was on Android,
as follows:

1) Android init (pid=1) fork()s (say pid=42) [this child process is totally
   unrelated to firmware loading, it could be sleep 2; for all we care ]
2) Android init (pid=1) does a write() on a (driver custom) sysfs file which
   ends up calling request_firmware() kernel side
3) The firmware loading fallback mechanism is used, the request is sent to
   userspace and pid 1 waits in the kernel on wait_*
4) before firmware loading completes pid 42 dies (for any reason, even
   normal termination)
5) Kernel delivers SIGCHLD to pid=1 to tell it a child has died, which
   causes -ERESTARTSYS to be returned from wait_*
6) The kernel's wait aborts and return -EAGAIN for the
   request_firmware() caller.

swait was introduced as of v4.6 and the firmware_class code was modified to
use swait only as of v4.10 via commit 5b029624948d6 ("firmware: do not use
fw_lock for fw_state protection"), as such stable kernels older than v4.10
must modify the old firmware_class call:

	from  wait_for_completion_interruptible_timeout()
	to    wait_for_completion_killable_timeout()

Cc: stable <stable@vger.kernel.org> # 4.0
Suggested-by: "Eric W. Biederman" <ebiederm@xmission.com>
Suggested-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Tested-by: Martin Fuzzey <mfuzzey@parkeon.com>
Reported-by: Martin Fuzzey <mfuzzey@parkeon.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 drivers/base/firmware_class.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index b9f907eedbf7..70fc42e5e0da 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -131,7 +131,7 @@ static int __fw_state_wait_common(struct fw_state *fw_st, long timeout)
 {
 	long ret;
 
-	ret = swait_event_interruptible_timeout(fw_st->wq,
+	ret = swait_event_killable_timeout(fw_st->wq,
 				__fw_state_is_done(READ_ONCE(fw_st->status)),
 				timeout);
 	if (ret != 0 && fw_st->status == FW_STATUS_ABORTED)
-- 
2.11.0
