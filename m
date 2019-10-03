From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: trace_printk issue. Was: [PATCH bpf-next] bpf, capabilities:
 introduce CAP_BPF
Date: Thu, 3 Oct 2019 12:41:48 -0400
Message-ID: <20191003124148.4b94a720@gandalf.local.home>
References: <DA52992F-4862-4945-8482-FE619A04C753@amacapital.net>
        <20190829040721.ef6rumbaunkavyrr@ast-mbp.dhcp.thefacebook.com>
        <20190928193727.1769e90c@oasis.local.home>
        <201909301129.5A1129C@keescook>
        <20191001012226.vwpe56won5r7gbrz@ast-mbp.dhcp.thefacebook.com>
        <20191001181052.43c9fabb@gandalf.local.home>
        <6e8b910c-a739-857d-4867-395bd369bc6a@fb.com>
        <20191001184731.0ec98c7a@gandalf.local.home>
        <a98725c6-a7db-1d9f-7033-5ecd96438c8d@fb.com>
        <20191002190027.4e204ea8@gandalf.local.home>
        <20191003161838.7lz746aa2lzl7qi4@ast-mbp.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20191003161838.7lz746aa2lzl7qi4@ast-mbp.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Alexei Starovoitov <ast@fb.com>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Alexei Starovoitov <ast@kernel.org>, LSM List <linux-security-module@vger.kernel.org>, James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>, Peter Zijlstra <peterz@infradead.org>, Masami Hiramatsu <mhiramat@kernel.org>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Network Development <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, 3 Oct 2019 09:18:40 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> I think dropping last events is just as bad. Is there a mode to overwrite old
> and keep the last N (like perf does) ?

Well, it drops it by pages. Thus you should always have the last page
of events.

> Peter Wu brought this issue to my attention in
> commit 55c33dfbeb83 ("bpf: clarify when bpf_trace_printk discards lines").
> And later sent similar doc fix to ftrace.rst.

It was documented there, he just elaborated on it more:

        This file holds the output of the trace in a human
        readable format (described below). Note, tracing is temporarily
-       disabled while this file is being read (opened).
+       disabled when the file is open for reading. Once all readers
+       are closed, tracing is re-enabled.


> To be honest if I knew of this trace_printk quirk I would not have picked it
> as a debugging mechanism for bpf.
> I urge you to fix it.

It's not a trivial fix by far.

Note, trying to read the trace file without disabling the writes to it,
will most likely make reading it when function tracing enabled totally
garbage, as the buffer will most likely be filled for every read event.
That is, each read event will not be related to the next event that is
read, making it very confusing.

Although, I may be able to make it work per page. That way you get at
least a page worth of events.

Now, I could also make it where you have to stop tracing to read the
trace file. That is, if you try to open the trace files while the
buffer is active, it will error -EBUSY. Forcing you to stop tracing to
read it, otherwise you would need to read the trace_pipe. At least this
way you will not get surprised that events were dropped.

-- Steve
