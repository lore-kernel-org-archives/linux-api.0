From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
Date: Tue, 27 Aug 2019 21:43:42 -0700
Message-ID: <20190828044340.zeha3k3cmmxgfqj7@ast-mbp.dhcp.thefacebook.com>
References: <20190827205213.456318-1-ast@kernel.org>
 <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
 <20190828003447.htgzsxs5oevn3eys@ast-mbp.dhcp.thefacebook.com>
 <CALCETrVbPPPr=BdPAx=tJKxD3oLXP4OVSgCYrB_E4vb6idELow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrVbPPPr=BdPAx=tJKxD3oLXP4OVSgCYrB_E4vb6idELow@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, LSM List <linux-security-module@vger.kernel.org>, James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>, Peter Zijlstra <peterz@infradead.org>, Masami Hiramatsu <mhiramat@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Network Development <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Aug 27, 2019 at 05:55:41PM -0700, Andy Lutomirski wrote:
> 
> I was hoping for something in Documentation/admin-guide, not in a
> changelog that's hard to find.

eventually yes.

> >
> > > Changing the capability that some existing operation requires could
> > > break existing programs.  The old capability may need to be accepted
> > > as well.
> >
> > As far as I can see there is no ABI breakage. Please point out
> > which line of the patch may break it.
> 
> As a more or less arbitrary selection:
> 
>  void bpf_prog_kallsyms_add(struct bpf_prog *fp)
>  {
>         if (!bpf_prog_kallsyms_candidate(fp) ||
> -           !capable(CAP_SYS_ADMIN))
> +           !capable(CAP_BPF))
>                 return;
> 
> Before your patch, a task with CAP_SYS_ADMIN could do this.  Now it
> can't.  Per the usual Linux definition of "ABI break", this is an ABI
> break if and only if someone actually did this in a context where they
> have CAP_SYS_ADMIN but not all capabilities.  How confident are you
> that no one does things like this?
>  void bpf_prog_kallsyms_add(struct bpf_prog *fp)
>  {
>         if (!bpf_prog_kallsyms_candidate(fp) ||
> -           !capable(CAP_SYS_ADMIN))
> +           !capable(CAP_BPF))
>                 return;

Yes. I'm confident that apps don't drop everything and
leave cap_sys_admin only before doing bpf() syscall, since it would
break their own use of networking.
Hence I'm not going to do the cap_syslog-like "deprecated" message mess
because of this unfounded concern.
If I turn out to be wrong we will add this "deprecated mess" later.

> 
> From the previous discussion, you want to make progress toward solving
> a lot of problems with CAP_BPF.  One of them was making BPF
> firewalling more generally useful. By making CAP_BPF grant the ability
> to read kernel memory, you will make administrators much more nervous
> to grant CAP_BPF. 

Andy, were your email hacked?
I explained several times that in this proposal 
CAP_BPF _and_ CAP_TRACING _both_ are necessary to read kernel memory.
CAP_BPF alone is _not enough_.

> Similarly, and correct me if I'm wrong, most of
> these capabilities are primarily or only useful for tracing, so I
> don't see why users without CAP_TRACING should get them.
> bpf_trace_printk(), in particular, even has "trace" in its name :)
> 
> Also, if a task has CAP_TRACING, it's expected to be able to trace the
> system -- that's the whole point.  Why shouldn't it be able to use BPF
> to trace the system better?

CAP_TRACING shouldn't be able to do BPF because BPF is not tracing only.

> > For example:
> > BPF_CALL_3(bpf_probe_read, void *, dst, u32, size, const void *, unsafe_ptr)
> > {
> >         int ret;
> >
> >         ret = probe_kernel_read(dst, unsafe_ptr, size);
> >         if (unlikely(ret < 0))
> >                 memset(dst, 0, size);
> >
> >         return ret;
> > }
> >
> > All of BPF (including prototype of bpf_probe_read) is controlled by CAP_BPF.
> > But the kernel primitives its using (probe_kernel_read) is controlled by CAP_TRACING.
> > Hence a task needs _both_ CAP_BPF and CAP_TRACING to attach and run bpf program
> > that uses bpf_probe_read.
> >
> > Similar with all other kernel code that BPF helpers may call directly or indirectly.
> > If there is a way for bpf program to call into piece of code controlled by CAP_TRACING
> > such helper would need CAP_BPF and CAP_TRACING.
> > If bpf helper calls into something that may mangle networking packet
> > such helper would need both CAP_BPF and CAP_NET_ADMIN to execute.
> 
> Why do you want to require CAP_BPF to call into functions like
> bpf_probe_read()?  I understand why you want to limit access to bpf,
> but I think that CAP_TRACING should be sufficient to allow the tracing
> parts of BPF.  After all, a lot of your concerns, especially the ones
> involving speculation, don't really apply to users with CAP_TRACING --
> users with CAP_TRACING can read kernel memory with or without bpf.

Let me try again to explain the concept...

Imagine AUDI logo with 4 circles.
They partially intersect.
The first circle is CAP_TRACING. Second is CAP_BPF. Third is CAP_NET_ADMIN.
Fourth - up to your imagination :)

These capabilities subdivide different parts of root privileges.
CAP_NET_ADMIN is useful on its own.
Just as CAP_TRACING that is useful for perf, ftrace, and probably
other tracing things that don't need bpf.

'bpftrace' is using a lot of tracing and a lot of bpf features,
but not all of bpf and not all tracing.
It falls into intersection of CAP_BPF and CAP_TRACING.

probe_kernel_read is a tracing mechanism.
perf can use it without bpf.
Hence it should be controlled by CAP_TRACING.

bpf_probe_read is a wrapper of that mechanism.
It's a place where BPF and TRACING circles intersect.
A task needs to have both CAP_BPF (to load the program)
and CAP_TRACING (to read kernel memory) to execute bpf_probe_read() helper.

> > > > @@ -2080,7 +2083,10 @@ static int bpf_prog_test_run(const union bpf_attr *attr,
> > > >         struct bpf_prog *prog;
> > > >         int ret = -ENOTSUPP;
> > > >
> > > > -       if (!capable(CAP_SYS_ADMIN))
> > > > +       if (!capable(CAP_NET_ADMIN) || !capable(CAP_BPF))
> > > > +               /* test_run callback is available for networking progs only.
> > > > +                * Add cap_bpf_tracing() above when tracing progs become runable.
> > > > +                */
> > >
> > > I think test_run should probably be CAP_SYS_ADMIN forever.  test_run
> > > is the only way that one can run a bpf program and call helper
> > > functions via the program if one doesn't have permission to attach the
> > > program.
> >
> > Since CAP_BPF + CAP_NET_ADMIN allow attach. It means that a task
> > with these two permissions will have programs running anyway.
> > (traffic will flow through netdev, socket events will happen, etc)
> > Hence no reason to disallow running program via test_run.
> >
> 
> test_run allows fully controlled inputs, in a context where a program
> can trivially flush caches, mistrain branch predictors, etc first.  It
> seems to me that, if a JITted bpf program contains an exploitable
> speculation gadget (MDS, Spectre v1, RSB, or anything else), 

speaking of MDS... I already asked you to help investigate its
applicability with existing bpf exposure. Are you going to do that?

> it will
> be *much* easier to exploit it using test_run than using normal
> network traffic.  Similarly, normal network traffic will have network
> headers that are valid enough to have caused the BPF program to be
> invoked in the first place.  test_run can inject arbitrary garbage.

Please take a look at Jann's var1 exploit. Was it hard to run bpf prog
in controlled environment without test_run command ?
