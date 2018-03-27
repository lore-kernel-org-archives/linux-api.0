From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v6 bpf-next 08/11] bpf: introduce BPF_RAW_TRACEPOINT
Date: Tue, 27 Mar 2018 15:07:43 -0400
Message-ID: <20180327150743.4182ab3e@gandalf.local.home>
References: <20180327024706.2064725-1-ast@fb.com>
        <20180327024706.2064725-9-ast@fb.com>
        <20180327130211.284c8924@gandalf.local.home>
        <f071b59d-5d67-0eb6-c5b1-68094b0a5118@fb.com>
        <20180327150041.3d86e16e@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180327150041.3d86e16e@gandalf.local.home>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <ast@fb.com>
Cc: davem@davemloft.net, daniel@iogearbox.net, torvalds@linux-foundation.org, peterz@infradead.org, netdev@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, 27 Mar 2018 15:00:41 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> >  Wasting extra 8bytes * number_of_tracepoints just for lack of trust
> > in kallsyms doesn't sound like good trade off to me.
> > If kallsyms are inaccurate all sorts of things will break:
> > kprobes, livepatch, etc.

And if kallsyms breaks, these will break by failing to attach, or some
other benign error. Ftrace uses kallsyms to find functions too, but it
only enables functions based on the result, it doesn't use the result
for anything but to compare it to what it already knows.

This is a first that I know of to trust that kallsyms returns something
that you expect to execute with no other validation. It may be valid,
but it also makes me very nervous too. If others are fine with such an
approach, then OK, we can enter a new chapter of development where we
can use kallsyms to find the functions we want to call and use it.

-- Steve
