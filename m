From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
Date: Wed, 28 Aug 2019 09:14:21 +0200
Message-ID: <20190828071421.GK2332@hirez.programming.kicks-ass.net>
References: <20190827205213.456318-1-ast@kernel.org>
 <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, LSM List <linux-security-module@vger.kernel.org>, James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>, Masami Hiramatsu <mhiramat@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Network Development <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Aug 27, 2019 at 04:01:08PM -0700, Andy Lutomirski wrote:

> > Tracing:
> >
> > CAP_BPF and perf_paranoid_tracepoint_raw() (which is kernel.perf_event_paranoid == -1)
> > are necessary to:

That's not tracing, that's perf.

> > +bool cap_bpf_tracing(void)
> > +{
> > +       return capable(CAP_SYS_ADMIN) ||
> > +              (capable(CAP_BPF) && !perf_paranoid_tracepoint_raw());
> > +}

A whole long time ago, I proposed we introduce CAP_PERF or something
along those lines; as a replacement for that horrible crap Android and
Debian ship. But nobody was ever interested enough.

The nice thing about that is that you can then disallow perf/tracing in
general, but tag the perf executable (and similar tools) with the
capability so that unpriv users can still use it, but only limited
through the tool, not the syscalls directly.
