From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v6 bpf-next 08/11] bpf: introduce BPF_RAW_TRACEPOINT
Date: Wed, 28 Mar 2018 10:06:53 -0400
Message-ID: <20180328100653.3dad40b9@gandalf.local.home>
References: <20180327024706.2064725-1-ast@fb.com>
        <20180327130211.284c8924@gandalf.local.home>
        <20180327131143.4b83534c@gandalf.local.home>
        <20180327145824.602dfdec@gandalf.local.home>
        <20180327170438.77c0f8fd@gandalf.local.home>
        <563f7fa0-5fea-00d3-1eb3-fa00d8cf7e29@fb.com>
        <430531879.1792.1522192417816.JavaMail.zimbra@efficios.com>
        <b0763759-3f8b-317b-5fb4-600648495462@fb.com>
        <1513083686.1804.1522197852512.JavaMail.zimbra@efficios.com>
        <34b9892d-c091-7b83-d8e8-79c0ff813140@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <34b9892d-c091-7b83-d8e8-79c0ff813140@fb.com>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <ast@fb.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, netdev <netdev@vger.kernel.org>, kernel-team <kernel-team@fb.com>, linux-api <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Tue, 27 Mar 2018 17:51:55 -0700
Alexei Starovoitov <ast@fb.com> wrote:

> Turned out it was in init.data section and got poisoned.
> this fixes it:
> @@ -258,6 +258,7 @@
>          LIKELY_PROFILE()                                                \
>          BRANCH_PROFILE()                                                \
>          TRACE_PRINTKS()                                                 \
> +       BPF_RAW_TP()                                                    \
>          TRACEPOINT_STR()
> 
>   /*
> @@ -585,7 +586,6 @@
>          *(.init.rodata)                                                 \
>          FTRACE_EVENTS()                                                 \
>          TRACE_SYSCALLS()                                                \
> -       BPF_RAW_TP()                                                    \
>          KPROBE_BLACKLIST()                                              \
>          ERROR_INJECT_WHITELIST()                                        \
>          MEM_DISCARD(init.rodata)                                        \
> 
> and it works :)
> I will clean few other nits I found while debugging and respin.

Getting it properly working was an exercise left to the reader ;-)

Sorry about that, I did a bit of copy and paste to get it working, and
copied from code that did things a bit differently, so I massaged it by
hand, and doing it quickly as I had other things to work on.

-- Steve
