From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH v5 bpf-next 06/10] tracepoint: compute num_args at build
 time
Date: Mon, 26 Mar 2018 17:27:19 -0400 (EDT)
Message-ID: <443917241.580.1522099639111.JavaMail.zimbra@efficios.com>
References: <20180324023038.938665-1-ast@fb.com> <523311773.184.1522079745421.JavaMail.zimbra@efficios.com> <f39181e0-3d46-2154-044c-dfc985053b3a@fb.com> <1055377367.195.1522081045131.JavaMail.zimbra@efficios.com> <89fbc745-c290-c82c-a837-8998cf2988e7@fb.com> <20180326123530.66ced6ae@gandalf.local.home> <1218234422.259.1522083422808.JavaMail.zimbra@efficios.com> <17073efa-d833-7348-bef1-79376ad43bc6@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <17073efa-d833-7348-bef1-79376ad43bc6@fb.com>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <ast@fb.com>
Cc: rostedt <rostedt@goodmis.org>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, netdev <netdev@vger.kernel.org>, kernel-team <kernel-team@fb.com>, linux-api <linux-api@vger.kernel.org>, "Frank Ch. Eigler" <fche@redhat.com>
List-Id: linux-api@vger.kernel.org

----- On Mar 26, 2018, at 1:55 PM, Alexei Starovoitov ast@fb.com wrote:

[...]

> 
> correct. this set deals with in-kernel tracepoints only.
> No attempt to do anything with tracepoints inside modules.

Please endeavor to handle in-module tracepoints properly, then we'll
be able to pursue a more constructive discussion.

[...]

> Also I hope you noticed that the patch is doing:
> +++ b/include/linux/tracepoint-defs.h
> @@ -33,6 +33,7 @@ struct tracepoint {
>         int (*regfunc)(void);
>         void (*unregfunc)(void);
>         struct tracepoint_func __rcu *funcs;
> +       u32 num_args;
>  };
> 
> To make sure that bpf programs are safe I need to do a static check
> in the verifier that programs don't access arguments beyond
> those specified by the tracepoint.
> 
> That was mentioned in the commit log of patch 6 too:
> "
> compute number of arguments passed into tracepoint
> at compile time and store it as part of 'struct tracepoint'.
> The number is necessary to check safety of bpf program access that
> is coming in subsequent patch.
> "

This part of the patch and its associated changelog is fine
with me. Please submit it as a separate commit from the rest
of the tracepoint.{c,h} changes.

[...]

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
