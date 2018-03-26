From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v5 bpf-next 00/10] bpf, tracing: introduce bpf raw
 tracepoints
Date: Mon, 26 Mar 2018 11:04:35 -0400
Message-ID: <20180326110435.4cdd7e7d@gandalf.local.home>
References: <20180324023038.938665-1-ast@fb.com>
        <c8be6d52-3f86-0402-9fdc-cc98f8e3e940@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <c8be6d52-3f86-0402-9fdc-cc98f8e3e940@iogearbox.net>
Sender: netdev-owner@vger.kernel.org
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: Alexei Starovoitov <ast@fb.com>, davem@davemloft.net, torvalds@linux-foundation.org, peterz@infradead.org, netdev@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, 26 Mar 2018 10:28:03 +0200
Daniel Borkmann <daniel@iogearbox.net> wrote:

> > tracepoint    base  kprobe+bpf tracepoint+bpf raw_tracepoint+bpf
> > task_rename   1.1M   769K        947K            1.0M
> > urandom_read  789K   697K        750K            755K  
> 
> Applied to bpf-next, thanks Alexei!

Please wait till you have the proper acks. Some of this affects
tracing.

-- Steve
