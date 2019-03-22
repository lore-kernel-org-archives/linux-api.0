From: Christoph Paasch <christoph.paasch@gmail.com>
Subject: Re: [net-next PATCH v3 4/8] net: Change return type of sk_busy_loop
 from bool to void
Date: Fri, 22 Mar 2019 15:25:37 -0400
Message-ID: <CALMXkpYk=VB4Npyk-fmr8=KT6V-XXyqEUQNwRUOtXyZFxQm2fg@mail.gmail.com>
References: <20170324164902.15226.48358.stgit@localhost.localdomain>
 <20170324170812.15226.97497.stgit@localhost.localdomain> <CALMXkpb3MfLbNoBgLJc0rgMDbPg9yOevKOiq9N8pzVw-aeNb3g@mail.gmail.com>
 <e532fdb97e142eca2484e5abbeca4c30d11fbad6.camel@redhat.com>
 <CAKgT0Uc68jsuPHKbxxFpeMCQAo2M69DhzA_XGw7Kvou4H3eHPg@mail.gmail.com>
 <CALMXkpZ_eB+aRx3+aKM5Bs4RwDfzPNX+XneESo2-yuMPjHV5-Q@mail.gmail.com> <0eb092b7ca67942f52e36c672d20f130f1d54e1e.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0eb092b7ca67942f52e36c672d20f130f1d54e1e.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Abeni <pabeni@redhat.com>
Cc: Alexander Duyck <alexander.duyck@gmail.com>, netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "Samudrala, Sridhar" <sridhar.samudrala@intel.com>, Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi Paolo,

On Fri, Mar 22, 2019 at 6:33 AM Paolo Abeni <pabeni@redhat.com> wrote:
> On Thu, 2019-03-21 at 23:05 -0400, Christoph Paasch wrote:
> > On Thu, Mar 21, 2019 at 12:43 PM Alexander Duyck
> > <alexander.duyck@gmail.com> wrote:
> > > On Thu, Mar 21, 2019 at 2:45 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > > > The following - completely untested - should avoid the unbounded loop,
> > > > but it's not a complete fix, I *think* we should also change
> > > > sk_busy_loop_end() in a similar way, but that is a little more complex
> > > > due to the additional indirections.
> > >
> > > As far as sk_busy_loop_end we could look at just forking sk_busy_loop
> > > and writing a separate implementation for datagram sockets that uses a
> > > different loop_end function. It shouldn't take much to change since
> > > all we would need to do is pass a structure containing the sk and last
> > > pointers instead of just passing the sk directly as the loop_end
> > > argument.
> > >
> > > > Could you please test it?
> > > >
> > > > Any feedback welcome!
> > >
> > > The change below looks good to me.
> >
> > I just tried it out. Worked for me!
> >
> > You can add my Tested-by if you do a formal patch-submission:
> >
> > Tested-by: Christoph Paasch <cpaasch@apple.com>
>
> Thanks for testing!
>
> I'm trying to reproduce the issue locally, but I'm unable. I think that
> the current UDP implementation is not affected, as we always ensure
> sk_receive_queue is empty before busy polling. Unix sockets should not
> be affected, too, as busy polling should not have any effect there
> (sk_napi_id should be never >= MIN_NAPI_ID). Can you reproduce the
> issue on an unpatched, recent, upstream kernel?

yes, I can repro it with the C-reproducer reliably on the latest
net-branch, v4.14.105 and then also bisected it down to the commit.

> Can you please provide the syzkaller repro?

Sure, here is the full report:

Syzkaller hit 'INFO: rcu detected stall in unix_seqpacket_recvmsg' bug.

INFO: rcu_sched self-detected stall on CPU
1-...: (19373 ticks this GP) idle=ac6/140000000000001/0 softirq=4477/4477 fqs=4
(t=21000 jiffies g=1853 c=1852 q=16)
rcu_sched kthread starved for 20984 jiffies! g1853 c1852 f0x0
RCU_GP_WAIT_FQS(3) ->state=0x0 ->cpu=0
rcu_sched       R  running task    21040     8      2 0x80000000
Call Trace:
 schedule+0xee/0x3a0 kernel/sched/core.c:3427
 schedule_timeout+0x158/0x260 kernel/time/timer.c:1744
 rcu_gp_kthread+0x12fc/0x3580 kernel/rcu/tree.c:2247
 kthread+0x355/0x430 kernel/kthread.c:232
 ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:402
NMI backtrace for cpu 1
CPU: 1 PID: 1956 Comm: syz-executor808 Not tainted 4.14.105 #6
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.5.1 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:17 [inline]
 dump_stack+0x10a/0x1d1 lib/dump_stack.c:53
 nmi_cpu_backtrace+0xf2/0x110 lib/nmi_backtrace.c:101
 nmi_trigger_cpumask_backtrace+0x116/0x170 lib/nmi_backtrace.c:62
 trigger_single_cpu_backtrace include/linux/nmi.h:158 [inline]
 rcu_dump_cpu_stacks+0x180/0x1dd kernel/rcu/tree.c:1396
 print_cpu_stall kernel/rcu/tree.c:1542 [inline]
 check_cpu_stall.isra.69+0x9f1/0x1080 kernel/rcu/tree.c:1610
 __rcu_pending kernel/rcu/tree.c:3382 [inline]
 rcu_pending kernel/rcu/tree.c:3444 [inline]
 rcu_check_callbacks+0x380/0xc90 kernel/rcu/tree.c:2784
 update_process_times+0x28/0x60 kernel/time/timer.c:1588
 tick_sched_handle+0x7d/0x150 kernel/time/tick-sched.c:161
 tick_sched_timer+0x3d/0x110 kernel/time/tick-sched.c:1219
 __run_hrtimer kernel/time/hrtimer.c:1220 [inline]
 __hrtimer_run_queues+0x3d8/0xb80 kernel/time/hrtimer.c:1284
 hrtimer_interrupt+0x1b0/0x590 kernel/time/hrtimer.c:1318
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1037 [inline]
 smp_apic_timer_interrupt+0x1d5/0x5b0 arch/x86/kernel/apic/apic.c:1062
 apic_timer_interrupt+0x87/0x90 arch/x86/entry/entry_64.S:787
 </IRQ>
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:778 [inline]
RIP: 0010:__raw_spin_unlock_irqrestore
include/linux/spinlock_api_smp.h:160 [inline]
RIP: 0010:_raw_spin_unlock_irqrestore+0x32/0x60 kernel/locking/spinlock.c:192
RSP: 0018:ffff888065b273b0 EFLAGS: 00000297 ORIG_RAX: ffffffffffffff10
RAX: 0000000000000007 RBX: 0000000000000297 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000297
RBP: ffff88806a2447a0 R08: 1ffff1100cb64e57 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff888065b27450
R13: ffffed100cb64e92 R14: 0000000000000000 R15: ffff88806a244788
 spin_unlock_irqrestore include/linux/spinlock.h:372 [inline]
 __skb_try_recv_datagram+0x299/0x4b0 net/core/datagram.c:274
 unix_dgram_recvmsg+0x294/0x1840 net/unix/af_unix.c:2107
 unix_seqpacket_recvmsg+0x82/0xb0 net/unix/af_unix.c:2073
 sock_recvmsg_nosec net/socket.c:818 [inline]
 sock_recvmsg+0xc4/0x110 net/socket.c:825
 ___sys_recvmsg+0x2a7/0x620 net/socket.c:2220
 __sys_recvmsg+0xc6/0x200 net/socket.c:2265
 SYSC_recvmsg net/socket.c:2277 [inline]
 SyS_recvmsg+0x27/0x40 net/socket.c:2272
 do_syscall_64+0x23f/0x6d0 arch/x86/entry/common.c:289
 entry_SYSCALL_64_after_hwframe+0x42/0xb7
RIP: 0033:0x7f4a53385469
RSP: 002b:00007f4a53a76f28 EFLAGS: 00000246 ORIG_RAX: 000000000000002f
RAX: ffffffffffffffda RBX: 0000000000603168 RCX: 00007f4a53385469
RDX: 0000000040000002 RSI: 0000000020001680 RDI: 0000000000000003
RBP: 0000000000603160 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000060316c
R13: 0800000000008923 R14: 00007f4a53a57000 R15: 0000000000000003


Syzkaller reproducer:
# {Threaded:true Collide:false Repeat:true RepeatTimes:0 Procs:8
Sandbox:none Fault:false FaultCall:-1 FaultNth:0 EnableTun:false
UseTmpDir:false EnableCgroups:false EnableNetdev:false ResetNet:false
HandleSegv:false Repro:false Trace:false}
socketpair$unix(0x1, 0x1000000000005, 0x0,
&(0x7f0000000340)={<r0=>0xffffffffffffffff, <r1=>0xffffffffffffffff})
setsockopt$sock_int(r0, 0x1, 0x2a, &(0x7f00000000c0)=0x9, 0x4)
recvmsg(r0, &(0x7f0000001680)={0x0, 0x0, 0x0}, 0x40000002)
setsockopt$sock_int(r0, 0x1, 0x2e, &(0x7f00000003c0)=0x9, 0x4)
sendmsg(r1, &(0x7f0000000680)={0x0, 0x0, 0x0}, 0x0)
connect$inet6(0xffffffffffffffff, 0x0, 0x0)
socketpair(0xa, 0x800, 0x4, 0x0)
fcntl$getflags(0xffffffffffffffff, 0x40b)
sendto$inet6(0xffffffffffffffff, 0x0, 0x0, 0x24000855, 0x0, 0x0)
getsockopt$inet_IP_XFRM_POLICY(0xffffffffffffff9c, 0x0, 0x11, 0x0, 0x0)
socket$nl_xfrm(0x10, 0x3, 0x6)
setsockopt$netlink_NETLINK_BROADCAST_ERROR(0xffffffffffffffff, 0x10e,
0x4, 0x0, 0x0)
socket$unix(0x1, 0x3, 0x0)
getsockopt$sock_int(0xffffffffffffffff, 0x1, 0x1e, 0x0, 0x0)
ioctl$sock_SIOCGSKNS(0xffffffffffffffff, 0x894c, 0x0)
ioctl$sock_inet_udp_SIOCOUTQ(0xffffffffffffffff, 0x5411, 0x0)
setsockopt$IP_VS_SO_SET_EDIT(0xffffffffffffffff, 0x0, 0x483, 0x0, 0x0)
setsockopt$inet6_IPV6_XFRM_POLICY(0xffffffffffffffff, 0x29, 0x23, 0x0, 0x0)
ioctl$sock_ifreq(0xffffffffffffffff, 0x800000000008923, 0x0)
bind(0xffffffffffffffff, 0x0, 0x0)
socket(0xa, 0x3, 0x3)


C reproducer:
// autogenerated by syzkaller (https://github.com/google/syzkaller)

#define _GNU_SOURCE

#include <dirent.h>
#include <endian.h>
#include <errno.h>
#include <fcntl.h>
#include <pthread.h>
#include <sched.h>
#include <signal.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mount.h>
#include <sys/prctl.h>
#include <sys/resource.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

#include <linux/futex.h>

unsigned long long procid;

static void sleep_ms(uint64_t ms)
{
usleep(ms * 1000);
}

static uint64_t current_time_ms(void)
{
struct timespec ts;
if (clock_gettime(CLOCK_MONOTONIC, &ts))
exit(1);
return (uint64_t)ts.tv_sec * 1000 + (uint64_t)ts.tv_nsec / 1000000;
}

static void thread_start(void* (*fn)(void*), void* arg)
{
pthread_t th;
pthread_attr_t attr;
pthread_attr_init(&attr);
pthread_attr_setstacksize(&attr, 128 << 10);
int i;
for (i = 0; i < 100; i++) {
if (pthread_create(&th, &attr, fn, arg) == 0) {
pthread_attr_destroy(&attr);
return;
}
if (errno == EAGAIN) {
usleep(50);
continue;
}
break;
}
exit(1);
}

typedef struct {
int state;
} event_t;

static void event_init(event_t* ev)
{
ev->state = 0;
}

static void event_reset(event_t* ev)
{
ev->state = 0;
}

static void event_set(event_t* ev)
{
if (ev->state)
exit(1);
__atomic_store_n(&ev->state, 1, __ATOMIC_RELEASE);
syscall(SYS_futex, &ev->state, FUTEX_WAKE | FUTEX_PRIVATE_FLAG);
}

static void event_wait(event_t* ev)
{
while (!__atomic_load_n(&ev->state, __ATOMIC_ACQUIRE))
syscall(SYS_futex, &ev->state, FUTEX_WAIT | FUTEX_PRIVATE_FLAG, 0, 0);
}

static int event_isset(event_t* ev)
{
return __atomic_load_n(&ev->state, __ATOMIC_ACQUIRE);
}

static int event_timedwait(event_t* ev, uint64_t timeout)
{
uint64_t start = current_time_ms();
uint64_t now = start;
for (;;) {
uint64_t remain = timeout - (now - start);
struct timespec ts;
ts.tv_sec = remain / 1000;
ts.tv_nsec = (remain % 1000) * 1000 * 1000;
syscall(SYS_futex, &ev->state, FUTEX_WAIT | FUTEX_PRIVATE_FLAG, 0, &ts);
if (__atomic_load_n(&ev->state, __ATOMIC_RELAXED))
return 1;
now = current_time_ms();
if (now - start > timeout)
return 0;
}
}

static bool write_file(const char* file, const char* what, ...)
{
char buf[1024];
va_list args;
va_start(args, what);
vsnprintf(buf, sizeof(buf), what, args);
va_end(args);
buf[sizeof(buf) - 1] = 0;
int len = strlen(buf);
int fd = open(file, O_WRONLY | O_CLOEXEC);
if (fd == -1)
return false;
if (write(fd, buf, len) != len) {
int err = errno;
close(fd);
errno = err;
return false;
}
close(fd);
return true;
}

static void setup_common()
{
if (mount(0, "/sys/fs/fuse/connections", "fusectl", 0, 0)) {
}
}

static void loop();

static void sandbox_common()
{
prctl(PR_SET_PDEATHSIG, SIGKILL, 0, 0, 0);
setpgrp();
setsid();
struct rlimit rlim;
rlim.rlim_cur = rlim.rlim_max = (200 << 20);
setrlimit(RLIMIT_AS, &rlim);
rlim.rlim_cur = rlim.rlim_max = 32 << 20;
setrlimit(RLIMIT_MEMLOCK, &rlim);
rlim.rlim_cur = rlim.rlim_max = 136 << 20;
setrlimit(RLIMIT_FSIZE, &rlim);
rlim.rlim_cur = rlim.rlim_max = 1 << 20;
setrlimit(RLIMIT_STACK, &rlim);
rlim.rlim_cur = rlim.rlim_max = 0;
setrlimit(RLIMIT_CORE, &rlim);
rlim.rlim_cur = rlim.rlim_max = 256;
setrlimit(RLIMIT_NOFILE, &rlim);
if (unshare(CLONE_NEWNS)) {
}
if (unshare(CLONE_NEWIPC)) {
}
if (unshare(0x02000000)) {
}
if (unshare(CLONE_NEWUTS)) {
}
if (unshare(CLONE_SYSVSEM)) {
}
typedef struct {
const char* name;
const char* value;
} sysctl_t;
static const sysctl_t sysctls[] = {
   {"/proc/sys/kernel/shmmax", "16777216"},
   {"/proc/sys/kernel/shmall", "536870912"},
   {"/proc/sys/kernel/shmmni", "1024"},
   {"/proc/sys/kernel/msgmax", "8192"},
   {"/proc/sys/kernel/msgmni", "1024"},
   {"/proc/sys/kernel/msgmnb", "1024"},
   {"/proc/sys/kernel/sem", "1024 1048576 500 1024"},
};
unsigned i;
for (i = 0; i < sizeof(sysctls) / sizeof(sysctls[0]); i++)
write_file(sysctls[i].name, sysctls[i].value);
}

int wait_for_loop(int pid)
{
if (pid < 0)
exit(1);
int status = 0;
while (waitpid(-1, &status, __WALL) != pid) {
}
return WEXITSTATUS(status);
}

static int do_sandbox_none(void)
{
if (unshare(CLONE_NEWPID)) {
}
int pid = fork();
if (pid != 0)
return wait_for_loop(pid);
setup_common();
sandbox_common();
if (unshare(CLONE_NEWNET)) {
}
loop();
exit(1);
}

static void kill_and_wait(int pid, int* status)
{
kill(-pid, SIGKILL);
kill(pid, SIGKILL);
int i;
for (i = 0; i < 100; i++) {
if (waitpid(-1, status, WNOHANG | __WALL) == pid)
return;
usleep(1000);
}
DIR* dir = opendir("/sys/fs/fuse/connections");
if (dir) {
for (;;) {
struct dirent* ent = readdir(dir);
if (!ent)
break;
if (strcmp(ent->d_name, ".") == 0 || strcmp(ent->d_name, "..") == 0)
continue;
char abort[300];
snprintf(abort, sizeof(abort), "/sys/fs/fuse/connections/%s/abort",
ent->d_name);
int fd = open(abort, O_WRONLY);
if (fd == -1) {
continue;
}
if (write(fd, abort, 1) < 0) {
}
close(fd);
}
closedir(dir);
} else {
}
while (waitpid(-1, status, __WALL) != pid) {
}
}

#define SYZ_HAVE_SETUP_TEST 1
static void setup_test()
{
prctl(PR_SET_PDEATHSIG, SIGKILL, 0, 0, 0);
setpgrp();
}

#define SYZ_HAVE_RESET_TEST 1
static void reset_test()
{
int fd;
for (fd = 3; fd < 30; fd++)
close(fd);
}

struct thread_t {
int created, call;
event_t ready, done;
};

static struct thread_t threads[16];
static void execute_call(int call);
static int running;

static void* thr(void* arg)
{
struct thread_t* th = (struct thread_t*)arg;
for (;;) {
event_wait(&th->ready);
event_reset(&th->ready);
execute_call(th->call);
__atomic_fetch_sub(&running, 1, __ATOMIC_RELAXED);
event_set(&th->done);
}
return 0;
}

static void execute_one(void)
{
int i, call, thread;
for (call = 0; call < 21; call++) {
for (thread = 0; thread < (int)(sizeof(threads) / sizeof(threads[0]));
thread++) {
struct thread_t* th = &threads[thread];
if (!th->created) {
th->created = 1;
event_init(&th->ready);
event_init(&th->done);
event_set(&th->done);
thread_start(thr, th);
}
if (!event_isset(&th->done))
continue;
event_reset(&th->done);
th->call = call;
__atomic_fetch_add(&running, 1, __ATOMIC_RELAXED);
event_set(&th->ready);
event_timedwait(&th->done, 45);
break;
}
}
for (i = 0; i < 100 && __atomic_load_n(&running, __ATOMIC_RELAXED); i++)
sleep_ms(1);
}

static void execute_one(void);

#define WAIT_FLAGS __WALL

static void loop(void)
{
int iter;
for (iter = 0;; iter++) {
int pid = fork();
if (pid < 0)
exit(1);
if (pid == 0) {
setup_test();
execute_one();
reset_test();
exit(0);
}
int status = 0;
uint64_t start = current_time_ms();
for (;;) {
if (waitpid(-1, &status, WNOHANG | WAIT_FLAGS) == pid)
break;
sleep_ms(1);
if (current_time_ms() - start < 5 * 1000)
continue;
kill_and_wait(pid, &status);
break;
}
}
}

uint64_t r[2] = {0xffffffffffffffff, 0xffffffffffffffff};

void execute_call(int call)
{
long res; switch (call) {
case 0:
res = syscall(__NR_socketpair, 1, 0x1000000000005, 0, 0x20000340);
if (res != -1) {
r[0] = *(uint32_t*)0x20000340;
r[1] = *(uint32_t*)0x20000344;
}
break;
case 1:
*(uint32_t*)0x200000c0 = 9;
syscall(__NR_setsockopt, r[0], 1, 0x2a, 0x200000c0, 4);
break;
case 2:
*(uint64_t*)0x20001680 = 0;
*(uint32_t*)0x20001688 = 0;
*(uint64_t*)0x20001690 = 0;
*(uint64_t*)0x20001698 = 0;
*(uint64_t*)0x200016a0 = 0;
*(uint64_t*)0x200016a8 = 0;
*(uint32_t*)0x200016b0 = 0;
syscall(__NR_recvmsg, r[0], 0x20001680, 0x40000002);
break;
case 3:
*(uint32_t*)0x200003c0 = 9;
syscall(__NR_setsockopt, r[0], 1, 0x2e, 0x200003c0, 4);
break;
case 4:
*(uint64_t*)0x20000680 = 0;
*(uint32_t*)0x20000688 = 0;
*(uint64_t*)0x20000690 = 0;
*(uint64_t*)0x20000698 = 0;
*(uint64_t*)0x200006a0 = 0;
*(uint64_t*)0x200006a8 = 0;
*(uint32_t*)0x200006b0 = 0;
syscall(__NR_sendmsg, r[1], 0x20000680, 0);
break;
case 5:
syscall(__NR_connect, -1, 0, 0);
break;
case 6:
syscall(__NR_socketpair, 0xa, 0x800, 4, 0);
break;
case 7:
syscall(__NR_fcntl, -1, 0x40b, 0);
break;
case 8:
syscall(__NR_sendto, -1, 0, 0, 0x24000855, 0, 0);
break;
case 9:
syscall(__NR_getsockopt, 0xffffff9c, 0, 0x11, 0, 0);
break;
case 10:
syscall(__NR_socket, 0x10, 3, 6);
break;
case 11:
syscall(__NR_setsockopt, -1, 0x10e, 4, 0, 0);
break;
case 12:
syscall(__NR_socket, 1, 3, 0);
break;
case 13:
syscall(__NR_getsockopt, -1, 1, 0x1e, 0, 0);
break;
case 14:
syscall(__NR_ioctl, -1, 0x894c, 0);
break;
case 15:
syscall(__NR_ioctl, -1, 0x5411, 0);
break;
case 16:
syscall(__NR_setsockopt, -1, 0, 0x483, 0, 0);
break;
case 17:
syscall(__NR_setsockopt, -1, 0x29, 0x23, 0, 0);
break;
case 18:
syscall(__NR_ioctl, -1, 0x800000000008923, 0);
break;
case 19:
syscall(__NR_bind, -1, 0, 0);
break;
case 20:
syscall(__NR_socket, 0xa, 3, 3);
break;
}

}
int main(void)
{
syscall(__NR_mmap, 0x20000000, 0x1000000, 3, 0x32, -1, 0);
for (procid = 0; procid < 8; procid++) {
if (fork() == 0) {
do_sandbox_none();
}
}
sleep(1000000);
return 0;
}
