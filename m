From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v6 bpf-next 08/11] bpf: introduce BPF_RAW_TRACEPOINT
Date: Tue, 27 Mar 2018 13:11:43 -0400
Message-ID: <20180327131143.4b83534c@gandalf.local.home>
References: <20180327024706.2064725-1-ast@fb.com>
        <20180327024706.2064725-9-ast@fb.com>
        <20180327130211.284c8924@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180327130211.284c8924@gandalf.local.home>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <ast@fb.com>
Cc: davem@davemloft.net, daniel@iogearbox.net, torvalds@linux-foundation.org, peterz@infradead.org, netdev@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Tue, 27 Mar 2018 13:02:11 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> Honestly, I think this is too much of a short cut and a hack. I know
> you want to keep it "simple" and save space, but you really should do
> it the same way ftrace and perf do it. That is, create a section and
> have all tracepoints create a structure that holds a pointer to the
> tracepoint and to the bpf probe function. Then you don't even need the
> kernel_tracepoint_find_by_name(), you just iterate over your table and
> you get the tracepoint and the bpf function associated to it.

Also, if you do it the perf/ftrace way, you get support for module
tracepoints pretty much for free. Which would include tracepoints in
networking code that is loaded by a module.

-- Steve
