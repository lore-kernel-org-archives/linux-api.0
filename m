From: Chris Metcalf <cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: clocksource_watchdog causing scheduling of timers every second
 (was [v13] support "task_isolation" mode)
Date: Fri, 29 Jul 2016 17:04:05 -0400
Message-ID: <6f4107fb-9d42-d4a3-8681-317cf7175bf9@mellanox.com>
References: <1468529299-27929-1-git-send-email-cmetcalf@mellanox.com>
 <alpine.DEB.2.20.1607202059180.25838@east.gentwo.org>
 <e60d7fd1-022d-c823-52e6-d44a49d274b1@mellanox.com>
 <alpine.DEB.2.20.1607212118210.12213@east.gentwo.org>
 <7a3f66f7-5011-7d59-2e0e-f57e4e42e6b6@mellanox.com>
 <alpine.DEB.2.20.1607251133450.25354@east.gentwo.org>
 <alpine.DEB.2.20.1607270847460.24843@east.gentwo.org>
 <f8d72e47-7e84-cbd0-869f-69bf452a8bfb@mellanox.com>
 <alpine.DEB.2.20.1607271022130.25729@east.gentwo.org>
 <alpine.DEB.2.20.1607271030020.25729@east.gentwo.org>
 <f7553d2a-f4ab-b218-bb93-fcb436db1770@mellanox.com>
 <alpine.DEB.2.20.1607271355320.5760@east.gentwo.org>
 <eacd22ec-fc87-290e-ee5f-21b8e879b059@mellanox.com>
 <alpine.DEB.2.20.1607271452530.9567@east.gentwo.org>
 <2fefa17d-37c6-9669-724e-9ee0d841e7b2@mellanox.com>
 <CAC6yHM4LON5ASooVa_eUaDYsN1W0HYTMX76yHDxf8Mff0mKqiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAC6yHM4LON5ASooVa_eUaDYsN1W0HYTMX76yHDxf8Mff0mKqiA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Francis Giraldeau <francis.giraldeau-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Gilad Ben Yossef <giladb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 7/29/2016 2:31 PM, Francis Giraldeau wrote:
> I tested this patch on 4.7 and confirm that irq_work does not occurs anymore on
> the isolated cpu. Thanks!

Great!  Let me know if you'd like me to add your Tested-by in the patch series.

> I don't know of any utility to test the task isolation feature, so I started
> one:
>
>      https://github.com/giraldeau/taskisol
>
> The script exp.sh runs the taskisol to test five different conditions, but some
> behavior is not the one I would expect.
>
> At startup, it does:
>   - register a custom signal handler for SIGUSR1
>   - sched_setaffinity() on CPU 1, which is isolated
>   - mlockall(MCL_CURRENT) to prevent undesired page faults
>
> The default strict mode is set with:
>
>      prctl(PR_SET_TASK_ISOLATION, PR_TASK_ISOLATION_ENABLE)
>
> And then, the syscall write() is called. From previous discussion, the SIGKILL
> should be sent, but it does not occur. When instead of calling write() we force
> a page fault, then the SIGKILL is correctly sent.

This looks like it may be a bug in the x86-specific part of the kernel support.
On tilegx and arm64, running your test does the right thing:

# ./taskisol default syscall
taskisol run
taskisol/1855: task_isolation mode lost due to syscall 64
Killed

I think the x86 support doesn't properly return right away from a bad
syscall.  The patch below should fix that; can you try it?  However, it's
not clear to me why the signal isn't getting delivered.  Perhaps you can
try adding some tracing to the syscall_trace_enter() path and see if we're
actually running this code as expected?  Thank you!  :-)

--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -90,8 +90,10 @@ unsigned long syscall_trace_enter_phase1(struct pt_regs *regs, u32 arch)
  
      /* In isolation mode, we may prevent the syscall from running. */
      if (work & _TIF_TASK_ISOLATION) {
-        if (task_isolation_syscall(regs->orig_ax) == -1)
-            return -1;
+        if (task_isolation_syscall(regs->orig_ax) == -1) {
+            regs->orig_ax = -1;
+            return 0;
+        }
          work &= ~_TIF_TASK_ISOLATION;
      }

I updated my dataplane branch on kernel.org with this fix.

> When instead a custom signal handler SIGUSR1:
>
>      prctl(PR_SET_TASK_ISOLATION, PR_TASK_ISOLATION_USERSIG |
>                        PR_TASK_ISOLATION_SET_SIG(SIGUSR1)
>
> The signal is never delivered, either when the syscall is issued nor when the
> page fault occurs.

This is a bug in your test program.  Try again with this fix:

--- a/taskisol.c
+++ b/taskisol.c
@@ -79,8 +79,9 @@ int main(int argc, char *argv[])
           * The program completes when using USERSIG,
           * but actually no signal is delivered
           */
-        if (strcmp(argv[1], "signal") == 0) {
-            if (prctl(PR_SET_TASK_ISOLATION, PR_TASK_ISOLATION_USERSIG |
+        else if (strcmp(argv[1], "signal") == 0) {
+            if (prctl(PR_SET_TASK_ISOLATION, PR_TASK_ISOLATION_ENABLE |
+                      PR_TASK_ISOLATION_USERSIG |
                        PR_TASK_ISOLATION_SET_SIG(SIGUSR1)) < 0) {
                  perror("prctl sigusr");
                  return -1;

The prctl() API is intended to be one-shot, i.e. you set all the state you
want with a single prctl().  The next call to prctl() will reset the state
to whatever you specify (including if you don't specify "enable").

(Also, as a side note, I'd expect your Makefile to invoke $(CC) for taskisol,
not $(CXX) - there doesn't seem to be any actual C++ in the program.)

> I can confirm that, if two taskisol are created on the same CPU, the second one
> fails with Resource temporarily unavailable, so that's fine.
>
> I can add more test cases depending on your comments, such as the TLB events
> triggered by another thread on a non-isolated core. But maybe there is already
> a test suite?

The appended code is what I've been using as a test harness.  It passes on
tilegx and arm64.  No guarantees as to production-level code quality :-)

#define _GNU_SOURCE
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h>
#include <assert.h>
#include <string.h>
#include <errno.h>
#include <sched.h>
#include <pthread.h>
#include <sys/wait.h>
#include <sys/mman.h>
#include <sys/time.h>
#include <sys/prctl.h>

#ifndef PR_SET_TASK_ISOLATION   // Not in system headers yet?
# define PR_SET_TASK_ISOLATION		48
# define PR_GET_TASK_ISOLATION		49
# define PR_TASK_ISOLATION_ENABLE	(1 << 0)
# define PR_TASK_ISOLATION_USERSIG	(1 << 1)
# define PR_TASK_ISOLATION_SET_SIG(sig)	(((sig) & 0x7f) << 8)
# define PR_TASK_ISOLATION_GET_SIG(bits) (((bits) >> 8) & 0x7f)
# define PR_TASK_ISOLATION_NOSIG \
     (PR_TASK_ISOLATION_USERSIG | PR_TASK_ISOLATION_SET_SIG(0))
#endif

// The cpu we are using for isolation tests.
static int task_isolation_cpu;

// Overall status, maintained as tests run.
static int exit_status = EXIT_SUCCESS;

// Set affinity to a single cpu.
int set_my_cpu(int cpu)
{
	cpu_set_t set;
	CPU_ZERO(&set);
	CPU_SET(cpu, &set);
	return sched_setaffinity(0, sizeof(cpu_set_t), &set);
}

// Run a child process in task isolation mode and report its status.
// The child does mlockall() and moves itself to the task isolation cpu.
// It then runs SETUP_FUNC (if specified), calls prctl(PR_SET_TASK_ISOLATION, )
// with FLAGS (if non-zero), and then invokes TEST_FUNC and exits
// with its status.
static int run_test(void (*setup_func)(), int (*test_func)(), int flags)
{
	fflush(stdout);
	int pid = fork();
	assert(pid >= 0);
	if (pid != 0) {
		// In parent; wait for child and return its status.
		int status;
		waitpid(pid, &status, 0);
		return status;
	}

	// In child.
	int rc = mlockall(MCL_CURRENT);
	assert(rc == 0);
	rc = set_my_cpu(task_isolation_cpu);
	assert(rc == 0);
	if (setup_func)
		setup_func();
	if (flags) {
		int rc;
		do
			rc = prctl(PR_SET_TASK_ISOLATION, flags);
		while (rc != 0 && errno == EAGAIN);
		if (rc != 0) {
			printf("couldn't enable isolation (%d): FAIL\n", errno);
			exit(EXIT_FAILURE);
		}
	}
	rc = test_func();
	exit(rc);
}

// Run a test and ensure it is killed with SIGKILL by default,
// for whatever misdemeanor is committed in TEST_FUNC.
// Also test it with SIGUSR1 as well to make sure that works.
static void test_killed(const char *testname, void (*setup_func)(),
			int (*test_func)())
{
	int status = run_test(setup_func, test_func, PR_TASK_ISOLATION_ENABLE);
	if (WIFSIGNALED(status) && WTERMSIG(status) == SIGKILL) {
		printf("%s: OK\n", testname);
	} else {
		printf("%s: FAIL (%#x)\n", testname, status);
		exit_status = EXIT_FAILURE;
	}

	status = run_test(setup_func, test_func,
			  PR_TASK_ISOLATION_ENABLE | PR_TASK_ISOLATION_USERSIG |
			  PR_TASK_ISOLATION_SET_SIG(SIGUSR1));
	if (WIFSIGNALED(status) && WTERMSIG(status) == SIGUSR1) {
		printf("%s (SIGUSR1): OK\n", testname);
	} else {
		printf("%s (SIGUSR1): FAIL (%#x)\n", testname, status);
		exit_status = EXIT_FAILURE;
	}
}

// Run a test and make sure it exits with success.
static void test_ok(const char *testname, void (*setup_func)(),
		    int (*test_func)())
{
	int status = run_test(setup_func, test_func, PR_TASK_ISOLATION_ENABLE);
	if (status == EXIT_SUCCESS) {
		printf("%s: OK\n", testname);
	} else {
		printf("%s: FAIL (%#x)\n", testname, status);
		exit_status = EXIT_FAILURE;
	}
}

// Run a test with no signals and make sure it exits with success.
static void test_nosig(const char *testname, void (*setup_func)(),
		       int (*test_func)())
{
	int status =
		run_test(setup_func, test_func,
			 PR_TASK_ISOLATION_ENABLE | PR_TASK_ISOLATION_NOSIG);
	if (status == EXIT_SUCCESS) {
		printf("%s: OK\n", testname);
	} else {
		printf("%s: FAIL (%#x)\n", testname, status);
		exit_status = EXIT_FAILURE;
	}
}

// Mapping address passed from setup function to test function.
static char *fault_file_mapping;

// mmap() a file in so we can test touching an unmapped page.
static void setup_fault(void)
{
	char fault_file[] = "/tmp/isolation_XXXXXX";
	int fd = mkstemp(fault_file);
	assert(fd >= 0);
	int rc = ftruncate(fd, getpagesize());
	assert(rc == 0);
	fault_file_mapping = mmap(NULL, getpagesize(), PROT_READ | PROT_WRITE,
				  MAP_SHARED, fd, 0);
	assert(fault_file_mapping != MAP_FAILED);
	close(fd);
	unlink(fault_file);
}

// Now touch the unmapped page (and be killed).
static int do_fault(void)
{
	*fault_file_mapping = 1;
	return EXIT_FAILURE;
}

// Make a syscall (and be killed).
static int do_syscall(void)
{
	write(STDOUT_FILENO, "goodbye, world\n", 13);
	return EXIT_FAILURE;
}

// Turn isolation back off and don't be killed.
static int do_syscall_off(void)
{
	prctl(PR_SET_TASK_ISOLATION, 0);
	write(STDOUT_FILENO, "==> hello, world\n", 17);
	return EXIT_SUCCESS;
}

// If we're not getting a signal, make sure we can do multiple system calls.
static int do_syscall_multi(void)
{
	write(STDOUT_FILENO, "==> hello, world 1\n", 19);
	write(STDOUT_FILENO, "==> hello, world 2\n", 19);
	return EXIT_SUCCESS;
}

#ifdef __aarch64__
/* ARM64 uses tlbi instructions so doesn't need to interrupt the remote core. */
static void test_munmap(void) {}
#else

// Fork a thread that will munmap() after a short while.
// It will deliver a TLB flush to the task isolation core.

static void *start_munmap(void *p)
{
	usleep(500000);   // 0.5s
	munmap(p, getpagesize());
	return 0;
}

static void setup_munmap(void)
{
	// First, go back to cpu 0 and allocate some memory.
	set_my_cpu(0);
	void *p = mmap(0, getpagesize(), PROT_READ|PROT_WRITE,
		       MAP_ANONYMOUS|MAP_POPULATE|MAP_PRIVATE, 0, 0);
	assert(p != MAP_FAILED);

	// Now fire up a thread that will wait half a second on cpu 0
	// and then munmap the mapping.
	pthread_t thr;
	int rc = pthread_create(&thr, NULL, start_munmap, p);
	assert(rc == 0);

	// Back to the task-isolation cpu.
	set_my_cpu(task_isolation_cpu);
}

// Global variable to avoid the compiler outsmarting us.
volatile int munmap_spin;

static int do_munmap(void)
{
	while (munmap_spin < 1000000000)
		++munmap_spin;
	return EXIT_FAILURE;
}

static void test_munmap(void)
{
	test_killed("test_munmap", setup_munmap, do_munmap);
}
#endif

#ifdef __tilegx__
// Make an unaligned access (and be killed).
// Only for tilegx, since other platforms don't do in-kernel fixups.
static int
do_unaligned(void)
{
	static int buf[2];
	volatile int* addr = (volatile int *)((char *)buf + 1);

	*addr;

	asm("nop");
	return EXIT_FAILURE;
}

static void test_unaligned(void)
{
	test_killed("test_unaligned", NULL, do_unaligned);
}
#else
static void test_unaligned(void) {}
#endif

// Fork a process that will spin annoyingly on the same core
// for a second.  Since prctl() won't work if this task is actively
// running, we following this handshake sequence:
//
// 1. Child (in setup_quiesce, here) starts up, sets state 1 to let the
//    parent know it's running, and starts doing short sleeps waiting on a
//    state change.
// 2. Parent (in do_quiesce, below) starts up, spins waiting for state 1,
//    then spins waiting on prctl() to succeed.  At that point it is in
//    isolation mode and the child is completing its most recent sleep.
//    Now, as soon as the parent is scheduled out, it won't schedule back
//    in until the child stops spinning.
// 3. Child sees the state change to 2, sets it to 3, and starts spinning
//    waiting for a second to elapse, at which point it exits.
// 4. Parent spins waiting for the state to get to 3, then makes one
//    syscall.  This should take about a second even though the child
//    was spinning for a whole second after changing the state to 3.

volatile int *statep, *childstate;
struct timeval quiesce_start, quiesce_end;
int child_pid;

static void setup_quiesce(void)
{
	// First, go back to cpu 0 and allocate some shared memory.
	set_my_cpu(0);
	statep = mmap(0, getpagesize(), PROT_READ|PROT_WRITE,
		      MAP_ANONYMOUS|MAP_SHARED, 0, 0);
	assert(statep != MAP_FAILED);
	childstate = statep + 1;

	gettimeofday(&quiesce_start, NULL);

	// Fork and fault in all memory in both.
	child_pid = fork();
	assert(child_pid >= 0);
	if (child_pid == 0)
		*childstate = 1;
	int rc = mlockall(MCL_CURRENT);
	assert(rc == 0);
	if (child_pid != 0) {
		set_my_cpu(task_isolation_cpu);
		return;
	}

	// In child.  Wait until parent notifies us that it has completed
	// its prctl, then jump to its cpu and let it know.
	*childstate = 2;
	while (*statep == 0)
		;
	*childstate = 3;
	//  printf("child: jumping to cpu %d\n", task_isolation_cpu);
	set_my_cpu(task_isolation_cpu);
	//  printf("child: jumped to cpu %d\n", task_isolation_cpu);
	*statep = 2;
	*childstate = 4;

	// Now we are competing for the runqueue on task_isolation_cpu.
	// Spin for one second to ensure the parent gets caught in kernel space.
	struct timeval start, tv;
	gettimeofday(&start, NULL);
	while (1) {
		gettimeofday(&tv, NULL);
		double time = (tv.tv_sec - start.tv_sec) +
			(tv.tv_usec - start.tv_usec) / 1000000.0;
		if (time >= 0.5)
			exit(0);
	}
}

static int do_quiesce(void)
{
	double time;
	int rc;

	rc = prctl(PR_SET_TASK_ISOLATION,
		   PR_TASK_ISOLATION_ENABLE | PR_TASK_ISOLATION_NOSIG);
	if (rc != 0) {
		prctl(PR_SET_TASK_ISOLATION, 0);
		printf("prctl failed: rc %d", rc);
		goto fail;
	}
	*statep = 1;
     
	// Wait for child to come disturb us.
	while (*statep == 1) {
		gettimeofday(&quiesce_end, NULL);
		time = (quiesce_end.tv_sec - quiesce_start.tv_sec) +
			(quiesce_end.tv_usec - quiesce_start.tv_usec)/1000000.0;
		if (time > 0.1 && *statep == 1)	{
			prctl(PR_SET_TASK_ISOLATION, 0);
			printf("timed out at %gs in child migrate loop (%d)\n",
			       time, *childstate);
			char buf[100];
			sprintf(buf, "cat /proc/%d/stack", child_pid);
			system(buf);
			goto fail;
		}
	}
	assert(*statep == 2);

	// At this point the child is spinning, so any interrupt will keep us
	// in kernel space.  Make a syscall to make sure it happens at least
	// once during the second that the child is spinning.
	kill(0, 0);
	gettimeofday(&quiesce_end, NULL);
	prctl(PR_SET_TASK_ISOLATION, 0);
	time = (quiesce_end.tv_sec - quiesce_start.tv_sec) +
		(quiesce_end.tv_usec - quiesce_start.tv_usec) / 1000000.0;
	if (time < 0.4 || time > 0.6) {
		printf("expected 1s wait after quiesce: was %g\n", time);
		goto fail;
	}
	kill(child_pid, SIGKILL);
	return EXIT_SUCCESS;

fail:
	kill(child_pid, SIGKILL);
	return EXIT_FAILURE;
}

int main(int argc, char **argv)
{
	/* How many seconds to wait after running the other tests? */
	double waittime;
	if (argc == 1)
		waittime = 10;
	else if (argc == 2)
		waittime = strtof(argv[1], NULL);
	else {
		printf("syntax: isolation [seconds]\n");
		exit(EXIT_FAILURE);
	}

	/* Test that the /sys device is present and pick a cpu. */
	FILE *f = fopen("/sys/devices/system/cpu/task_isolation", "r");
	if (f == NULL) {
		printf("/sys device: FAIL\n");
		exit(EXIT_FAILURE);
	}
	char buf[100];
	char *result = fgets(buf, sizeof(buf), f);
	assert(result == buf);
	fclose(f);
	char *end;
	task_isolation_cpu = strtol(buf, &end, 10);
	assert(end != buf);
	assert(*end == ',' || *end == '-' || *end == '\n');
	assert(task_isolation_cpu >= 0);
	printf("/sys device : OK\n");

	// Test to see if with no mask set, we fail.
	if (prctl(PR_SET_TASK_ISOLATION, PR_TASK_ISOLATION_ENABLE) == 0 ||
	    errno != EINVAL) {
		printf("prctl unaffinitized: FAIL\n");
		exit_status = EXIT_FAILURE;
	} else {
		printf("prctl unaffinitized: OK\n");
	}

	// Or if affinitized to the wrong cpu.
	set_my_cpu(0);
	if (prctl(PR_SET_TASK_ISOLATION, PR_TASK_ISOLATION_ENABLE) == 0 ||
	    errno != EINVAL) {
		printf("prctl on cpu 0: FAIL\n");
		exit_status = EXIT_FAILURE;
	} else {
		printf("prctl on cpu 0: OK\n");
	}

	// Run the tests.
	test_killed("test_fault", setup_fault, do_fault);
	test_killed("test_syscall", NULL, do_syscall);
	test_munmap();
	test_unaligned();
	test_ok("test_off", NULL, do_syscall_off);
	test_nosig("test_multi", NULL, do_syscall_multi);
	test_nosig("test_quiesce", setup_quiesce, do_quiesce);

	// Exit failure if any test failed.
	if (exit_status != EXIT_SUCCESS)
		return exit_status;

	// Wait for however long was requested on the command line.
	// Note that this requires a vDSO implementation of gettimeofday();
	// if it's not available, we could just spin a fixed number of
	// iterations instead.
	struct timeval start, tv;
	gettimeofday(&start, NULL);
	while (1) {
		gettimeofday(&tv, NULL);
		double time = (tv.tv_sec - start.tv_sec) +
			(tv.tv_usec - start.tv_usec) / 1000000.0;
		if (time >= waittime)
			break;
	}

	return EXIT_SUCCESS;
}

-- 
Chris Metcalf, Mellanox Technologies
http://www.mellanox.com
