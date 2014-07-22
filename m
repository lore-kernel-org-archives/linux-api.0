From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH 0/5] futex: introduce an optimistic spinning futex
Date: Tue, 22 Jul 2014 09:35:25 +0200
Message-ID: <20140722073525.GU3935@laptop>
References: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com>
 <8761iq3bp3.fsf@tassilo.jf.intel.com>
 <871tte3bjw.fsf@tassilo.jf.intel.com>
 <CFF29A00.9D44A%dvhart@linux.intel.com>
 <CFF29E4A.9D44E%dvhart@linux.intel.com>
 <alpine.DEB.2.10.1407212025130.20847@nanos>
 <20140721212740.GS3935@laptop>
 <CALCETrXSaWM6-nxr4ggtMh5qcfTQg4wRvkW8FTSbri5+_1ZbVg@mail.gmail.com>
 <1405989175.25048.5.camel@buesod1.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1405989175.25048.5.camel@buesod1.americas.hpqcorp.net>
Sender: linux-doc-owner@vger.kernel.org
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Thomas Gleixner <tglx@linutronix.de>, Darren Hart <dvhart@linux.intel.com>, Andi Kleen <andi@firstfloor.org>, Waiman Long <Waiman.Long@hp.com>, Ingo Molnar <mingo@kernel.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Jason Low <jason.low2@hp.com>, Scott J Norton <scott.norton@hp.com>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 21, 2014 at 05:32:55PM -0700, Davidlohr Bueso wrote:
> On Mon, 2014-07-21 at 14:31 -0700, Andy Lutomirski wrote:
> > On Mon, Jul 21, 2014 at 2:27 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > > All this is predicated on the fact that syscalls are 'expensive'.
> > > Weren't syscalls only 100s of cycles? All this bitmap mucking is far
> > > more expensive due to cacheline misses, which due to the size of the
> > > things is almost guaranteed.
> > 
> > 120 - 300 cycles for me, unless tracing happens, and I'm working on
> > reducing the incidence of tracing.
> 
> fwiw here's what lmbench's lat_ctx says on my system . For 'accuracy', I
> kept the runs short.
> 
> http://www.stgolabs.net/lat_ctx.png

Create a syscall without 'work body', so say something like the below.
Context switches do quite a lot of work (unfortunately).

diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index ec255a1646d2..daf27ec10e29 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -323,6 +323,7 @@
 314	common	sched_setattr		sys_sched_setattr
 315	common	sched_getattr		sys_sched_getattr
 316	common	renameat2		sys_renameat2
+317	common	nop			sys_nop
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/kernel/sys.c b/kernel/sys.c
index 66a751ebf9d9..1b86614bb551 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2108,6 +2108,11 @@ SYSCALL_DEFINE1(sysinfo, struct sysinfo __user *, info)
 	return 0;
 }
 
+SYSCALL_DEFINE0(nop)
+{
+	return 0;
+}
+
 #ifdef CONFIG_COMPAT
 struct compat_sysinfo {
 	s32 uptime;
