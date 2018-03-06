From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH bpf-next 0/5] bpf, tracing: introduce bpf raw tracepoints
Date: Tue, 6 Mar 2018 11:35:31 +0100
Message-ID: <20180306103531.GB25201@hirez.programming.kicks-ass.net>
References: <20180301041957.399230-1-ast@kernel.org>
 <9bb38939-c357-4db5-6cf4-7b42187f6c7c@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9bb38939-c357-4db5-6cf4-7b42187f6c7c@iogearbox.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net, torvalds@linux-foundation.org, mingo@kernel.org, rostedt@goodmis.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Mar 05, 2018 at 02:36:07PM +0100, Daniel Borkmann wrote:
> On 03/01/2018 05:19 AM, Alexei Starovoitov wrote:
> > This patch set is a different way to address the pressing need to access
> > task_struct pointers in sched tracepoints from bpf programs.
> > 
> > The first approach simply added these pointers to sched tracepoints:
> > https://lkml.org/lkml/2017/12/14/753
> > which Peter nacked.
> > Few options were discussed and eventually the discussion converged on
> > doing bpf specific tracepoint_probe_register() probe functions.
> > Details here:
> > https://lkml.org/lkml/2017/12/20/929
> 
> Ping, Peter/Steven. If you have a chance, please review the series.

This series doesn't really touch anything I maintain, but the general
appraoch seems sane to me. I like the first patch that ensures
structures are passed by reference.

The rest is all tracepoint/bpf glue and I never really got into the bpf
internals, so I don't think I've got anything useful to say there.
