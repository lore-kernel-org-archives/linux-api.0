From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v7 bpf-next 06/10] tracepoint: compute num_args at build
 time
Date: Wed, 28 Mar 2018 13:38:30 -0400
Message-ID: <20180328133830.3d5d74d3@gandalf.local.home>
References: <20180328021105.4061744-1-ast@fb.com>
        <20180328021105.4061744-7-ast@fb.com>
        <1074829260.1986.1522244964935.JavaMail.zimbra@efficios.com>
        <67c5f9b4-b24a-2806-e8d6-8b5241c66d6e@fb.com>
        <20180328130407.7476cf17@gandalf.local.home>
        <fdcb0bf0-f896-ffb3-b9de-0b17f5f70fc6@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <fdcb0bf0-f896-ffb3-b9de-0b17f5f70fc6@fb.com>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <ast@fb.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, netdev <netdev@vger.kernel.org>, kernel-team <kernel-team@fb.com>, linux-api <linux-api@vger.kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>
List-Id: linux-api@vger.kernel.org

On Wed, 28 Mar 2018 10:10:34 -0700
Alexei Starovoitov <ast@fb.com> wrote:


> > and have:
> >
> > 	u64 tp_offset = (u64)tp - (u64)_sdata;
> >
> > 	if (WARN_ON(tp_offset > UINT_MAX)
> > 		return -EINVAL;
> >
> > 	 btp->tp_offset = (u32)tp_offset;  
> 
> above math has to be build time constant, so warn_on likely
> won't work.

Right, it would require a BUILD_BUG_ON.

> imo the whole thing is too fragile and obscure.
> I suggest to compress this 8 bytes * num_of_tracepoints later.
> Especially would be good to do it in one way for
> bpf_raw_event_map, ftrace and other places.

Fair enough. We can defer this shrinkage to another time. I only
suggested it here over your concern for the added bloat.

-- Steve
