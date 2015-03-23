From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v9 tip 6/9] samples: bpf: simple non-portable kprobe
 filter example
Date: Mon, 23 Mar 2015 08:35:07 +0100
Message-ID: <20150323073506.GC25184@gmail.com>
References: <1426894210-27441-1-git-send-email-ast@plumgrid.com>
 <1426894210-27441-7-git-send-email-ast@plumgrid.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1426894210-27441-7-git-send-email-ast@plumgrid.com>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung@kernel.org>, Arnaldo Carvalho de Melo <acme@infradead.org>, Jiri Olsa <jolsa@redhat.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-api@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org


* Alexei Starovoitov <ast@plumgrid.com> wrote:

> +void read_trace_pipe(void)
> +{
> +	int trace_fd;
> +
> +	trace_fd = open(DEBUGFS "trace_pipe", O_RDONLY, 0);
> +	if (trace_fd < 0)
> +		return;
> +
> +	while (1) {
> +		static char buf[4096];
> +		ssize_t sz;
> +
> +		sz = read(trace_fd, buf, sizeof(buf));

read() will return -1 on failure ...

> +		if (sz) {

... this test passes ...

> +			buf[sz] = 0;

... and here we smash the stack?

> +			puts(buf);
> +		}
> +	}


Thanks,

	Ingo
