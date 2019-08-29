From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
Date: Thu, 29 Aug 2019 08:43:23 -0700
Message-ID: <CALCETrWYu0XB_d-MhXFgopEmBu-pog493G1e+KsE3dS32UULgA@mail.gmail.com>
References: <20190827205213.456318-1-ast@kernel.org> <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
 <20190828071421.GK2332@hirez.programming.kicks-ass.net> <20190828220826.nlkpp632rsomocve@ast-mbp.dhcp.thefacebook.com>
 <20190829093434.36540972@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190829093434.36540972@gandalf.local.home>
Sender: netdev-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@kernel.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, LSM List <linux-security-module@vger.kernel.org>, James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>, Masami Hiramatsu <mhiramat@kernel.org>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Network Development <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Aug 29, 2019 at 6:34 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed, 28 Aug 2019 15:08:28 -0700
> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
>
> > On Wed, Aug 28, 2019 at 09:14:21AM +0200, Peter Zijlstra wrote:
> > > On Tue, Aug 27, 2019 at 04:01:08PM -0700, Andy Lutomirski wrote:
> > >
> > > > > Tracing:
> > > > >
> > > > > CAP_BPF and perf_paranoid_tracepoint_raw() (which is kernel.perf_event_paranoid == -1)
> > > > > are necessary to:
> > >
> > > That's not tracing, that's perf.
> > >
>
> > re: your first comment above.
> > I'm not sure what difference you see in words 'tracing' and 'perf'.
> > I really hope we don't partition the overall tracing category
> > into CAP_PERF and CAP_FTRACE only because these pieces are maintained
> > by different people.
>
> I think Peter meant: It's not tracing, it's profiling.
>
> And there is a bit of separation between the two, although there is an
> overlap.
>
> Yes, perf can do tracing but it's designed more for profiling.

As I see it, there are a couple of reasons to split something into
multiple capabilities.  If they allow users to do well-defined things
that have materially different risks from the perspective of the
person granting the capabilities, then they can usefully be different.
Similarly, if one carries a risk of accidental use that another does
not, they should usefully be different.  An example of the first is
that CAP_NET_BIND_SERVICE has very different powers from
CAP_NET_ADMIN, whereas CAP_SYS_ADMIN and CAP_PTRACE are really quite
similar from a security perspective.  An example of the latter is that
CAP_DAC_OVERRIDE changes overall open() semantics and CAP_SYS_ADMIN
does not, at least not outside of /proc.

Things having different development histories and different
maintainers doesn't seem like a good reason to split the capabilities
IMO.

>
> > On one side perf_event_open() isn't really doing tracing (as step by
> > step ftracing of function sequences), but perf_event_open() opens
> > an event and the sequence of events (may include IP) becomes a trace.
> > imo CAP_TRACING is the best name to descibe the privileged space
> > of operations possible via perf_event_open, ftrace, kprobe, stack traces, etc.
>
> I have no issue with what you suggest. I guess it comes down to how
> fine grain people want to go. Do we want it to be all or nothing?
> Should CAP_TRACING allow for write access to tracefs? Or should we go
> with needing both CAP_TRACING and permissions in that directory
> (like changing the group ownership of the files at every boot).
>
> Perhaps we should have a CAP_TRACING_RO, that gives read access to
> tracefs (and write if the users have permissions). And have CAP_TRACING
> to allow full write access as well (allowing for users to add kprobe
> events and enabling tracers like the function tracer).

I can imagine splitting it into three capabilities:

CAP_TRACE_KERNEL: learn which kernel functions are called when.  This
would allow perf profiling, for example, but not sampling of kernel
regs.

CAP_TRACE_READ_KERNEL_DATA: allow the tracing, profiling, etc features
that can read the kernel's data.  So you get function arguments via
kprobe, kernel regs, and APIs that expose probe_kernel_read()

CAP_TRACE_USER: trace unrelated user processes

I'm not sure the code is written in a way that makes splitting
CAP_TRACE_KERNEL and CAP_TRACE_READ_KERNEL_DATA, and I'm not sure that
CAP_TRACE_KERNEL is all that useful except for plain perf record
without CAP_TRACE_READ_KERNEL_DATA.  What do you all think?  I suppose
it could also be:

CAP_PROFILE_KERNEL: Use perf with events that aren't kprobes or
tracepoints.  Does not grant the ability to sample regs or the kernel
stack directly.

CAP_TRACE_KERNEL: Use all of perf, ftrace, kprobe, etc.

CAP_TRACE_USER: Use all of perf with scope limited to user mode and uprobes.

> As the above seems to favor the idea of CAP_TRACING allowing write
> access to tracefs, should we have a CAP_TRACING_RO for just read access
> and limited perf abilities?

How about making a separate cap for limited perf capabilities along
the lines of the above?

For what it's worth, it should be straightforward using full tracing
to read out the kernel's random number pool, for example, but it would
be difficult or impossible to do that using just perf record -e
cycles.
