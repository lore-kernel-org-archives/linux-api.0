From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v6 bpf-next 08/11] bpf: introduce BPF_RAW_TRACEPOINT
Date: Tue, 27 Mar 2018 15:00:41 -0400
Message-ID: <20180327150041.3d86e16e@gandalf.local.home>
References: <20180327024706.2064725-1-ast@fb.com>
        <20180327024706.2064725-9-ast@fb.com>
        <20180327130211.284c8924@gandalf.local.home>
        <f071b59d-5d67-0eb6-c5b1-68094b0a5118@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <f071b59d-5d67-0eb6-c5b1-68094b0a5118@fb.com>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <ast@fb.com>
Cc: davem@davemloft.net, daniel@iogearbox.net, torvalds@linux-foundation.org, peterz@infradead.org, netdev@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, 27 Mar 2018 11:45:34 -0700
Alexei Starovoitov <ast@fb.com> wrote:

> >> +
> >> +	snprintf(buf, sizeof(buf), "__bpf_trace_%s", tp->name);
> >> +	addr = kallsyms_lookup_name(buf);
> >> +	if (!addr)
> >> +		return -ENOENT;
> >> +
> >> +	return tracepoint_probe_register(tp, (void *)addr, prog);  
> >
> > You are putting in a hell of a lot of trust with kallsyms returning
> > properly. I can see this being very fragile. This is calling a function
> > based on the result of kallsyms. I'm sure the security folks would love
> > this.
> >
> > There's a few things to make this a bit more robust. One is to add a
> > table that points to all __bpf_trace_* functions, and verify that the
> > result from kallsyms is in that table.
> >
> > Honestly, I think this is too much of a short cut and a hack. I know
> > you want to keep it "simple" and save space, but you really should do
> > it the same way ftrace and perf do it. That is, create a section and
> > have all tracepoints create a structure that holds a pointer to the
> > tracepoint and to the bpf probe function. Then you don't even need the
> > kernel_tracepoint_find_by_name(), you just iterate over your table and
> > you get the tracepoint and the bpf function associated to it.
> >
> > Relying on kallsyms to return an address to execute is just way too
> > extreme and fragile for my liking.  
> 
> Wasting extra 8bytes * number_of_tracepoints just for lack of trust
> in kallsyms doesn't sound like good trade off to me.
> If kallsyms are inaccurate all sorts of things will break:
> kprobes, livepatch, etc.
> I'd rather suggest for ftrace to use kallsyms approach as well
> and reduce memory footprint.

If Linus, Thomas, Peter, Ingo, and the security folks trust kallsyms to
return a valid function pointer from a name, then sure, we can try
going that way.

-- Steve
