From: Yury Norov <ynorov@caviumnetworks.com>
Subject: Re: [PATCH v16 00/13] support "task_isolation" mode
Date: Wed, 7 Mar 2018 13:07:55 +0300
Message-ID: <20180307100755.afewiyhkdxytdfnl@yury-thinkpad>
References: <1509728692-10460-1-git-send-email-cmetcalf@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1509728692-10460-1-git-send-email-cmetcalf@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@mellanox.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, Daniel Lezcano <daniel.lezcano@linaro.org>, Francis Giraldeau <francis.giraldeau@gmail.com>, linux-mm@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Prasun Kapoor <Prasun.Kapo>
List-Id: linux-api@vger.kernel.org

Hi Chris,

(CC Cavium people)

Thanks for your series.

On Fri, Nov 03, 2017 at 01:04:39PM -0400, Chris Metcalf wrote:
> Here, finally, is a new spin of the task isolation work (v16), with
> changes based on the issues that were raised at last year's Linux
> Plumbers Conference and in the email discussion that followed.
> 
> This version of the patch series cleans up a number of areas that were
> a little dodgy in the previous patch series.
> 
> - It no longer loops in the final code that prepares to return to
>   userspace; instead, it sets things up in the prctl() and then
>   validates when preparing to return to userspace, adjusting the
>   syscall return value to -EAGAIN at that point if something doesn't
>   line up quite correctly.
> 
> - We no longer support the NOSIG mode that let you freely call into
>   the kernel multiple times while in task isolation.  This was always
>   a little odd, since you really should be in sufficient control of
>   task isolation code that you can explicitly stop isolation with a
>   "prctl(PR_TASK_ISOLATION, 0)" before using the kernel for anything
>   else.  It also made the semantics of migrating the task confusing.
>   More importantly, removing that support means that the only path
>   that sets up task isolation is the return from prctl(), which allows
>   us to make the simplification above.
> 
> - We no longer try to signal the task isolation process from a remote
>   core when we detect that we are about to violate its isolation.
>   Instead, we just print a message there (and optionally dump stack),
>   and rely on the eventual interrupt on the core itself to trigger the
>   signal.  We are always in a safe context to generate a signal when
>   we enter the kernel, unlike when we are deep in a call stack sending
>   an SMP IPI or whatever.
> 
> - We notice the case of an unstable scheduler clock and return
>   EINVAL rather than spinning forever with EAGAIN (suggestion from
>   Francis Giraldeau).
> 
> - The prctl() call requires zeros for arg3/4/5 (suggestion from
>   Eugene Syromiatnikov).
> 
> The kernel internal isolation API is also now cleaner, and I have
> included kerneldoc APIs for all the interfaces so that it should be
> easier to port it to additional architectures; in fact looking at
> include/linux/isolation.h is a good place to start understanding the
> overall patch set.
> 
> I removed Catalin's Reviewed-by for arm64, and Christoph's Tested-by
> for x86, since this version is sufficiently different to merit
> re-review and re-testing.
> 
> Note that this is not rebased on top of Frederic's recent housekeeping
> patch series, although it is largely orthogonal right now.  After
> Frederic's patch series lands, task isolation is enabled with
> "isolcpus=nohz,domain,CPUS".  We could add some shorthand for that
> ("isolcpus=full,CPUS"?) or just use it as-is.
> 
> The previous (v15) patch series is here:
> 
> https://lkml.kernel.org/r/1471382376-5443-1-git-send-email-cmetcalf@mellanox.com
> 
> This patch series is available at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git dataplane
> 
> Some folks raised some good points at the LPC discussion and then in
> email discussions that followed.  Rather than trying to respond to
> everyone in a flurry of emails, I'll answer some questions here:
> 
> 
> Why not just instrument user_exit() to raise the isolation-lost signal?
> 
> Andy pointed me in this direction.  The advantage is that you catch
> *everything*, by definition.  There is a hook that can do this in the
> current patch set, but you have to #define DEBUG_TASK_ISOLATION
> manually to take advantage of it, because as written it has two issues:
> 
> 1. You can't actually exit the kernel with prctl(PR_TASK_ISOLATION,0)
>    because the user_exit hook kills you first.
> 2. You lose the ability to get much better diagnostics by waiting
>    until you are further into kernel entry and know what you're doing.
> 
> You could work around #2 in several ways, but #1 is harder.  I looked
> at x86 for a while, and although you could imagine this, you really
> want to generate a lost-isolation signal on any syscall that isn't
> that exact prctl(), and it's awkward to try to do all of that checking
> before user_exit().  Since in any case we do want to have the more
> specific probes at the various kernel entry points where we generate
> the diagnostics, I felt like it wasn't the right approach to enable
> as a compilation-time default.  I'm open to discussion on this though!
> 
> 
> Can't we do all the exit-to-userspace work with irqs disabled?
> 
> In fact, it turns out that you can do lru_add_drain() with irqs
> disabled, so that's what we're doing in the patch series now.
> 
> However, it doesn't seem possible to do the synchronous cancellation of
> the vmstat deferred work with irqs disabled, though if there's a way,
> it would be a little cleaner to do that; Christoph?  We can certainly
> update the statistics with interrupts disabled via
> refresh_cpu_vm_stats(false), but that's not sufficient.  For now, I
> just issue the cancellation during sys_prctl() call, and then if it
> isn't synchronized by the time we are exiting to userspace, we just
> jam in an EAGAIN and let userspace retry.  In practice, this doesn't
> seem to ever happen.
> 
> 
> What about using a per-cpu flag to stop doing new deferred work?
> 
> Andy also suggested we could structure the code to have the prctl()
> set a per-cpu flag to stop adding new future work (e.g. vmstat per-cpu
> data, or lru page cache).  Then, we could flush those structures right
> from the sys_prctl() call, and when we were returning to user space,
> we'd be confident that there wasn't going to be any new work added.
> 
> With the current set of things that we are disabling for task
> isolation, though, it didn't seem necessary.  Quiescing the vmstat
> shepherd seems like it is generally pretty safe since we will likely
> be able to sync up the per-cpu cache and kill the deferred work with
> high probability, with no expectation that additional work will show
> up.  And since we can flush the LRU page cache with interrupts
> disabled, that turns out not to be an issue either.
> 
> I could imagine that if we have to deal with some new kind of deferred
> work, we might find the per-cpu flag becomes a good solution, but for
> now we don't have a good use case for that approach.
> 
> 
> How about stopping the dyn tick?
> 
> Right now we try to stop it on return to userspace, but if we can't,
> we just return EAGAIN to userspace.  In practice, what I see is that
> usually the tick stops immediately, but occasionally it doesn't; in
> this case I've always seen that nr_running is >1, presumably with some
> temporary kernel worker threads, and the user code just needs to call
> prctl() until those threads are done.  We could structure things with
> a completion that we wait for, which is set by the timer code when it
> finally does stop the tick, but this may be overkill, particularly
> since we'll only be running this prctl() loop from userspace on cores
> where we have no other useful work that we're trying to run anyway.
> 
> 
> What about TLB flushing?
> 
> We talked about this at Plumbers and some of the email discussion also
> was about TLB flushing.  I haven't tried to add it to this patch set,
> because I really want to avoid scope creep; in any case, I think I
> managed to convince Andy that he was going to work on it himself. :)
> Paul McKenney already contributed some framework for such a patch, in
> commit b8c17e6664c4 ("rcu: Maintain special bits at bottom of
> ->dynticks counter").
> 
> What about that d*mn 1 Hz clock?
> 
> It's still there, so this code still requires some further work before
> it can actually get a process into long-term task isolation (without
> the obvious one-line kernel hack).  Frederic suggested a while ago
> forcing updates on cpustats was required as the last gating factor; do
> we think that is still true?  Christoph was working on this at one
> point - any progress from your point of view?

I tested your series on ThunderX 2 machine. When I run 10 giga-ticks test,
it always passed. If I run for more, the test exits like this:

# time ./isolation 1000
/sys devices: OK (using task isolation cpu 100)
prctl unaffinitized: OK
prctl on cpu 0: OK
==> hello, world
test_off: OK
Received signal 11 successfully
test_segv: OK
test_fault: OK
test_fault (SIGUSR1): OK
test_syscall: OK
test_syscall (SIGUSR1): OK
test_schedule: OK
test_schedule (SIGUSR1): OK
testing task isolation jitter for 1000000000000 ticks
ERROR: Program unexpectedly entered kernel.
INFO: loop times:
  1 cycles (count: 128606844716)
  2 cycles (count: 31558352292)
  3 cycles (count: 4)
  29 cycles (count: 437)
  30 cycles (count: 1874)
  31 cycles (count: 221)
  57 cycles (count: 4)
  58 cycles (count: 6)
  59 cycles (count: 1)

real  15m58.643s
user  15m58.626s
sys   0m0.012s

I pass task_isolation_debug to boot parameters:
# cat /proc/cmdline 
BOOT_IMAGE=/boot/Image-isol nohz_full=100-110 isolcpus=100-110 task_isolation_debug root=UUID=75b9dd5b-58d8-4a50-8868-004cb7c1f25f ro text

But dmesg looks empty...

I investigate it, but at now I have no ideas what happens. Have you seen
that before?

Anyway, we are going to include your test in our scenario, with some
modifications. I've added --dry-run option to make it easier to
demonstrate the effect of isolation on jitter. If you like it, feel
free to use this change.

Tested-by: Yury Norov <ynorov@caviumnetworks.com>

>From 5c5823c1fc8441ab1486287679de77b8cea5154d Mon Sep 17 00:00:00 2001
From: Yury Norov <ynorov@caviumnetworks.com>
Date: Wed, 7 Mar 2018 02:41:08 +0300
Subject: [PATCH] isolation test: --dry-run mode

Add dry-run mode for better understanding the effect of isolation.
Also, make sanity checks on waitticks.

Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
---
 tools/testing/selftests/task_isolation/isolation.c | 47 +++++++++++++++++-----
 1 file changed, 36 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/task_isolation/isolation.c b/tools/testing/selftests/task_isolation/isolation.c
index 9c0b49619b40..e90a6c85fe2a 100644
--- a/tools/testing/selftests/task_isolation/isolation.c
+++ b/tools/testing/selftests/task_isolation/isolation.c
@@ -53,6 +53,7 @@
 #include <unistd.h>
 #include <stdlib.h>
 #include <fcntl.h>
+#include <limits.h>
 #include <assert.h>
 #include <string.h>
 #include <errno.h>
@@ -500,7 +501,7 @@ static void jitter_handler(int sig)
 	exit(exit_status);
 }
 
-static void test_jitter(unsigned long waitticks)
+static void test_jitter(unsigned long waitticks, int flags)
 {
 	u_int64_t start, last, elapsed;
 	int rc;
@@ -513,7 +514,8 @@ static void test_jitter(unsigned long waitticks)
 	rc = mlockall(MCL_CURRENT);
 	assert(rc == 0);
 
-	set_task_isolation(PR_TASK_ISOLATION_ENABLE |
+	if (flags & PR_TASK_ISOLATION_ENABLE)
+		set_task_isolation(PR_TASK_ISOLATION_ENABLE |
 			   PR_TASK_ISOLATION_SET_SIG(SIGUSR1));
 
 	last = start = get_cycle_count();
@@ -537,26 +539,49 @@ static void test_jitter(unsigned long waitticks)
 	} while (elapsed < waitticks);
 
 	jitter_test_complete = true;
-	prctl_isolation(0);
+
+	if (flags & PR_TASK_ISOLATION_ENABLE)
+		prctl_isolation(0);
+
 	jitter_summarize();
 }
 
 int main(int argc, char **argv)
 {
 	/* How many billion ticks to wait after running the other tests? */
-	unsigned long waitticks;
+	long waitticks = 10;
+	int flags = PR_TASK_ISOLATION_ENABLE;
 	char buf[100];
 	char *result, *end;
 	FILE *f;
 
-	if (argc == 1)
-		waitticks = 10;
-	else if (argc == 2)
-		waitticks = strtol(argv[1], NULL, 10);
-	else {
-		printf("syntax: isolation [gigaticks]\n");
+	errno = 0;
+
+	switch (argc) {
+	case 1:
+		break;
+	case 2:
+		if (strcmp(argv[1], "--dry-run") == 0)
+			flags = 0;
+		else
+			waitticks = strtol(argv[1], NULL, 10);
+		break;
+	case 3:
+		if (strcmp(argv[1], "--dry-run") == 0)
+			flags = 0;
+
+		waitticks = strtol(argv[2], NULL, 10);
+		break;
+	default:
+		printf("syntax: isolation [--dry-run] [gigaticks]\n");
 		ksft_exit_fail();
 	}
+
+	if (errno || waitticks <= 0 || waitticks > (LONG_MAX / 1000000000)) {
+		printf("Gigaticks: bad number.\n");
+		ksft_exit_fail();
+	}
+
 	waitticks *= 1000000000;
 
 	/* Get a core from the /sys nohz_full device. */
@@ -637,7 +662,7 @@ int main(int argc, char **argv)
 		return exit_status;
 	}
 
-	test_jitter(waitticks);
+	test_jitter(waitticks, flags);
 
 	return exit_status;
 }
-- 
2.14.1
