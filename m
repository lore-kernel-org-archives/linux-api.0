From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH bpf-next] bpf, tracing: unbreak lttng
Date: Mon, 26 Mar 2018 20:06:03 -0400
Message-ID: <20180326200603.581eefb1@gandalf.local.home>
References: <20180326220845.678423-1-ast@kernel.org>
        <20180326181532.587e9e2b@gandalf.local.home>
        <24d0ff40-c6fd-6349-4a89-dffda22cb596@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <24d0ff40-c6fd-6349-4a89-dffda22cb596@fb.com>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <ast@fb.com>
Cc: Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net, daniel@iogearbox.net, torvalds@linux-foundation.org, peterz@infradead.org, mathieu.desnoyers@efficios.com, netdev@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, 26 Mar 2018 15:25:32 -0700
Alexei Starovoitov <ast@fb.com> wrote:

> On 3/26/18 3:15 PM, Steven Rostedt wrote:
> > On Mon, 26 Mar 2018 15:08:45 -0700
> > Alexei Starovoitov <ast@kernel.org> wrote:
> >  
> >> for_each_kernel_tracepoint() is used by out-of-tree lttng module
> >> and therefore cannot be changed.
> >> Instead introduce kernel_tracepoint_find_by_name() to find
> >> tracepoint by name.
> >>
> >> Fixes: 9e9afbae6514 ("tracepoint: compute num_args at build time")
> >> Signed-off-by: Alexei Starovoitov <ast@kernel.org>  
> >
> > I'm curious, why can't you rebase? The first patch was never acked.  
> 
> because I think it makes sense to keep such things in the commit log
> and in the separate diff, so next developer is aware of what kind of
> minefield the tracpoints are.

This is a bunch of BS. It's not a minefield, and you can change that
function. Mathieu is perfectly fine in modifying his code to deal with
it. He has several times in the past. But I did not agree with the
approach you were taking, that is why I'm against it. You are playing
the straw man with this.

> No wonder some maintainers refuse to add them.

Good grief. No! The reason maintainers refuse to add them is that
userspace can depend on them, and if that happens, it becomes an ABI.
Stop with this nonsense.

-- Steve
