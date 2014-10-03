From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] x86,seccomp,prctl: Remove PR_TSC_SIGSEGV and seccomp TSC
 filtering
Date: Fri, 3 Oct 2014 23:02:13 +0200
Message-ID: <20141003210213.GG6324@worktop.programming.kicks-ass.net>
References: <fc0c2447cbc39257941c6b118388c024b719353a.1412356529.git.luto@amacapital.net>
 <CALCETrUfCrvidOS6VvUpWFAcHUrPUs58zSQqGRC5UOTS=E37rw@mail.gmail.com>
 <20141003201409.GM10583@worktop.programming.kicks-ass.net>
 <CALCETrVvFP66s5XOmSKaC8Vq73=uh11819HOOLkVTu7jJZotew@mail.gmail.com>
 <CALCETrWfrWpdMCAYySMAMGCHU3XRkNGmeMTECTE=PXQUfjGPZA@mail.gmail.com>
 <20141003204443.GP10583@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141003204443.GP10583-IIpfhp3q70z/8w/KjCw3T+5/BudmfyzbbVWyRVo5IupeoWH0uzbU5w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Erik Bosman <ebn310-vHs5IaWfoDhmR6Xm/wNWPw@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 03, 2014 at 10:44:43PM +0200, Peter Zijlstra wrote:
> On Fri, Oct 03, 2014 at 01:27:52PM -0700, Andy Lutomirski wrote:
> > On Fri, Oct 3, 2014 at 1:22 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> > >
> > > We could make the rule be that RDPMC is enabled if a perf event is
> > > mmapped or TIF_SECCOMP is clear, but I'd prefer to be convinced that
> > > there's an actual performance issue first.  Ideally we can get this
> > > all working with no API or ABI change at all.
> > 
> > No, we can't use that rule.  But we could say that RDPMC is enabled if
> > a perf event is mmapped and no thread in the mm uses seccomp.  I'll
> > grumble a little bit about adding yet another piece of seccomp state.
> 
> Well, we could simply disable the RDPMC for everything TIF_SECCOMP.
> Should be fairly straight fwd.


Something like so.. slightly less ugly and possibly with more
complicated conditions setting the cr4 if you want to fix tsc vs seccomp
as well.

---
 arch/x86/kernel/cpu/perf_event.c | 13 ++++++++++++-
 arch/x86/kernel/process.c        | 24 +++++++++++++++++-------
 2 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 16c73022306e..cfc42ff5d901 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1869,6 +1869,17 @@ static ssize_t set_attr_rdpmc(struct device *cdev,
 	return count;
 }
 
+void perf_change_rdpmc(bool on, unsigned long *cr4)
+{
+	if (x86_pmu.attr_rdpmc_broken)
+		return;
+
+	if (on)
+		*cr4 |= X86_CR4_PCE;
+	else
+		*cr4 &= ~X86_CR4_PCE;
+}
+
 static DEVICE_ATTR(rdpmc, S_IRUSR | S_IWUSR, get_attr_rdpmc, set_attr_rdpmc);
 
 static struct attribute *x86_pmu_attrs[] = {
@@ -1928,7 +1939,7 @@ void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
 
 	userpg->cap_user_time = 0;
 	userpg->cap_user_time_zero = 0;
-	userpg->cap_user_rdpmc = x86_pmu.attr_rdpmc;
+	userpg->cap_user_rdpmc = x86_pmu.attr_rdpmc && test_thread_flag(TIF_SECCOMP);
 	userpg->pmc_width = x86_pmu.cntval_bits;
 
 	if (!sched_clock_stable())
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index e127ddaa2d5a..b74c0400851e 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -201,12 +201,15 @@ void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
 		      struct tss_struct *tss)
 {
 	struct thread_struct *prev, *next;
+	struct thread_info *pi, *ni;
 
 	prev = &prev_p->thread;
 	next = &next_p->thread;
 
-	if (test_tsk_thread_flag(prev_p, TIF_BLOCKSTEP) ^
-	    test_tsk_thread_flag(next_p, TIF_BLOCKSTEP)) {
+	pi = task_thread_info(prev_p);
+	ni = task_thread_info(next_p);
+
+	if ((pi->flags & _TIF_BLOCKSTEP) ^ (ni->flags & _TIF_BLOCKSTEP)) {
 		unsigned long debugctl = get_debugctlmsr();
 
 		debugctl &= ~DEBUGCTLMSR_BTF;
@@ -216,13 +219,20 @@ void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
 		update_debugctlmsr(debugctl);
 	}
 
-	if (test_tsk_thread_flag(prev_p, TIF_NOTSC) ^
-	    test_tsk_thread_flag(next_p, TIF_NOTSC)) {
+	if ((pi->flags & (_TIF_NOTSC | _TIF_SECCOMP)) ^
+	    (ni->flags & (_TIF_NOTSC | _TIF_SECCOMP))) {
+		extern void perf_change_rdpmc(bool, unsigned long *);
+		unsigned long cr4 = read_cr4();
+
 		/* prev and next are different */
-		if (test_tsk_thread_flag(next_p, TIF_NOTSC))
-			hard_disable_TSC();
+		if (ni->flags & _TIF_NOTSC)
+			cr4 |= X86_CR4_TSD;
 		else
-			hard_enable_TSC();
+			cr4 &= ~X86_CR4_TSD;
+
+		perf_change_rdpmc(!(ni->flags & _TIF_SECCOMP), &cr4);
+
+		write_cr4(cr4);
 	}
 
 	if (test_tsk_thread_flag(next_p, TIF_IO_BITMAP)) {
