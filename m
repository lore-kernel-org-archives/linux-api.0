From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v7 bpf-next 06/10] tracepoint: compute num_args at build
 time
Date: Wed, 28 Mar 2018 14:10:45 -0400
Message-ID: <20180328141045.1202afeb@gandalf.local.home>
References: <20180328021105.4061744-1-ast@fb.com>
        <20180328021105.4061744-7-ast@fb.com>
        <1074829260.1986.1522244964935.JavaMail.zimbra@efficios.com>
        <67c5f9b4-b24a-2806-e8d6-8b5241c66d6e@fb.com>
        <20180328130407.7476cf17@gandalf.local.home>
        <fdcb0bf0-f896-ffb3-b9de-0b17f5f70fc6@fb.com>
        <20180328133830.3d5d74d3@gandalf.local.home>
        <80d7af37-10ef-28d7-f03f-27b4b5849cd1@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <80d7af37-10ef-28d7-f03f-27b4b5849cd1@fb.com>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <ast@fb.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, netdev <netdev@vger.kernel.org>, kernel-team <kernel-team@fb.com>, linux-api <linux-api@vger.kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>
List-Id: linux-api@vger.kernel.org

On Wed, 28 Mar 2018 11:03:24 -0700
Alexei Starovoitov <ast@fb.com> wrote:

> I can live with this overhead if Mathieu insists,
> but I prefer to keep it in 'struct tracepoint'.
> 
> Thoughts?

I'm fine with keeping it as is. We could probably use it for future
enhancements in perf and ftrace.

Perhaps, we should just add a:

#ifdef CONFIG_BPF_EVENTS

Around the use cases of num_args.

-- Steve
