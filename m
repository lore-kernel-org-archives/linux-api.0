From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v6 bpf-next 07/11] tracepoint: introduce
 kernel_tracepoint_find_by_name
Date: Tue, 27 Mar 2018 10:42:42 -0400
Message-ID: <20180327104242.3594bcac@gandalf.local.home>
References: <20180327024706.2064725-1-ast@fb.com>
        <20180327024706.2064725-8-ast@fb.com>
        <20180327100711.0ec7aafb@gandalf.local.home>
        <1566743692.1117.1522160304471.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1566743692.1117.1522160304471.JavaMail.zimbra@efficios.com>
Sender: netdev-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Alexei Starovoitov <ast@fb.com>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, netdev <netdev@vger.kernel.org>, kernel-team <kernel-team@fb.com>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, 27 Mar 2018 10:18:24 -0400 (EDT)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> ----- On Mar 27, 2018, at 10:07 AM, rostedt rostedt@goodmis.org wrote:
> 
> > On Mon, 26 Mar 2018 19:47:02 -0700
> > Alexei Starovoitov <ast@fb.com> wrote:
> >   
> >> From: Alexei Starovoitov <ast@kernel.org>
> >> 
> >> introduce kernel_tracepoint_find_by_name() helper to let bpf core
> >> find tracepoint by name and later attach bpf probe to a tracepoint
> >> 
> >> Signed-off-by: Alexei Starovoitov <ast@kernel.org>  
> > 
> > Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>  
> 
> Steven showed preference for tracepoint_kernel_find_by_name() at some
> point (starting with a tracepoint_ prefix). I'm find with either of
> the names.

Yeah, I do prefer tracepoint_kernel_find_by_name() to stay consistent
with the other tracepoint functions. But we have
"for_each_kernel_tracepoint()" and not "for_each_tracepoint_kernel()",
thus we need to pick being consistent with one or the other. One answer
is to use tracpoint_kernel_find_by_name() and rename the for_each to
for_each_tracpoint_kernel().

-- Steve


> 
> Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> 
> Thanks,
> 
> Mathieu
> 
> > 
> > Thanks for doing this Alexei!
> > 
> > One nit below.
