From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH bpf-next] bpf, tracing: unbreak lttng
Date: Mon, 26 Mar 2018 20:08:40 -0400
Message-ID: <20180326200840.2b9eda2c@gandalf.local.home>
References: <20180326220845.678423-1-ast@kernel.org>
        <1523827268.612.1522103407744.JavaMail.zimbra@efficios.com>
        <761ce9e6-aea4-01d8-8ff0-a17ad8a92526@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <761ce9e6-aea4-01d8-8ff0-a17ad8a92526@fb.com>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <ast@fb.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Alexei Starovoitov <ast@kernel.org>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, netdev <netdev@vger.kernel.org>, kernel-team <kernel-team@fb.com>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, 26 Mar 2018 15:35:56 -0700
Alexei Starovoitov <ast@fb.com> wrote:


> > This patch is not reverting to the old code properly. It introduces a
> > static inline void function that returns NULL. Please compile-test
> > with CONFIG_TRACEPOINTS=n before submitting a patch involving tracepoints.  
> 
> right. good catch. v2 is coming.

Either fold the patch into the original patch, or I'm pulling in
Mathieu's patch and pushing it to Linus come the merge window.

-- Steve
