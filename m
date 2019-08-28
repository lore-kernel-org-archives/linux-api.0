From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
Date: Wed, 28 Aug 2019 15:08:28 -0700
Message-ID: <20190828220826.nlkpp632rsomocve@ast-mbp.dhcp.thefacebook.com>
References: <20190827205213.456318-1-ast@kernel.org>
 <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
 <20190828071421.GK2332@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190828071421.GK2332@hirez.programming.kicks-ass.net>
Sender: netdev-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andy Lutomirski <luto@kernel.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, LSM List <linux-security-module@vger.kernel.org>, James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>, Masami Hiramatsu <mhiramat@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Network Development <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Aug 28, 2019 at 09:14:21AM +0200, Peter Zijlstra wrote:
> On Tue, Aug 27, 2019 at 04:01:08PM -0700, Andy Lutomirski wrote:
> 
> > > Tracing:
> > >
> > > CAP_BPF and perf_paranoid_tracepoint_raw() (which is kernel.perf_event_paranoid == -1)
> > > are necessary to:
> 
> That's not tracing, that's perf.
> 
> > > +bool cap_bpf_tracing(void)
> > > +{
> > > +       return capable(CAP_SYS_ADMIN) ||
> > > +              (capable(CAP_BPF) && !perf_paranoid_tracepoint_raw());
> > > +}
> 
> A whole long time ago, I proposed we introduce CAP_PERF or something
> along those lines; as a replacement for that horrible crap Android and
> Debian ship. But nobody was ever interested enough.
> 
> The nice thing about that is that you can then disallow perf/tracing in
> general, but tag the perf executable (and similar tools) with the
> capability so that unpriv users can still use it, but only limited
> through the tool, not the syscalls directly.

Exactly.
Similar motivation for CAP_BPF as well.

re: your first comment above.
I'm not sure what difference you see in words 'tracing' and 'perf'.
I really hope we don't partition the overall tracing category
into CAP_PERF and CAP_FTRACE only because these pieces are maintained
by different people.
On one side perf_event_open() isn't really doing tracing (as step by
step ftracing of function sequences), but perf_event_open() opens
an event and the sequence of events (may include IP) becomes a trace.
imo CAP_TRACING is the best name to descibe the privileged space
of operations possible via perf_event_open, ftrace, kprobe, stack traces, etc.

Another reason are kuprobes. They can be crated via perf_event_open
and via tracefs. Are they in CAP_PERF or in CAP_FTRACE ? In both, right?
Should then CAP_KPROBE be used ? that would be an overkill.
It would partition the space even further without obvious need.

Looking from BPF angle... BPF doesn't have integration with ftrace yet.
bpf_trace_printk is using ftrace mechanism, but that's 1% of ftrace.
In the long run I really like to see bpf using all of ftrace.
Whereas bpf is using a lot of 'perf'.
And extending some perf things in bpf specific way.
Take a look at how BPF_F_STACK_BUILD_ID. It's clearly perf/stack_tracing
feature that generic perf can use one day.
Currently it sits in bpf land and accessible via bpf only.
Though its bpf only today I categorize it under CAP_TRACING.

I think CAP_TRACING privilege should allow task to do all of perf_event_open,
kuprobe, stack trace, ftrace, and kallsyms.
We can think of some exceptions that should stay under CAP_SYS_ADMIN,
but most of the functionality available by 'perf' binary should be
usable with CAP_TRACING. 'perf' can do bpf too.
With CAP_BPF it would be all set.
