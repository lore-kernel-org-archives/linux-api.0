From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH bpf-next] bpf, tracing: unbreak lttng
Date: Mon, 26 Mar 2018 18:15:32 -0400
Message-ID: <20180326181532.587e9e2b@gandalf.local.home>
References: <20180326220845.678423-1-ast@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180326220845.678423-1-ast@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <ast@kernel.org>
Cc: davem@davemloft.net, daniel@iogearbox.net, torvalds@linux-foundation.org, peterz@infradead.org, mathieu.desnoyers@efficios.com, netdev@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, 26 Mar 2018 15:08:45 -0700
Alexei Starovoitov <ast@kernel.org> wrote:

> for_each_kernel_tracepoint() is used by out-of-tree lttng module
> and therefore cannot be changed.
> Instead introduce kernel_tracepoint_find_by_name() to find
> tracepoint by name.
> 
> Fixes: 9e9afbae6514 ("tracepoint: compute num_args at build time")
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

I'm curious, why can't you rebase? The first patch was never acked.

-- Steve
