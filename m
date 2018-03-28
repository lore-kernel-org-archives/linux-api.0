From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH v8 bpf-next 0/9] bpf, tracing: introduce bpf raw
 tracepoints
Date: Thu, 29 Mar 2018 01:59:43 +0200
Message-ID: <3aa29104-4b50-af2c-0df7-a3844e2c022b@iogearbox.net>
References: <20180328190540.370956-1-ast@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180328190540.370956-1-ast@kernel.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net
Cc: torvalds@linux-foundation.org, peterz@infradead.org, rostedt@goodmis.org, mathieu.desnoyers@efficios.com, netdev@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 03/28/2018 09:05 PM, Alexei Starovoitov wrote:
> v7->v8:
> - moved 'u32 num_args' from 'struct tracepoint' into 'struct bpf_raw_event_map'
>   that increases memory overhead, but can be optimized/compressed later.
>   Now it's zero changes in tracepoint.[ch]
[...]
> The first approach simply added these pointers to sched tracepoints:
> https://lkml.org/lkml/2017/12/14/753
> which Peter nacked.
> Few options were discussed and eventually the discussion converged on
> doing bpf specific tracepoint_probe_register() probe functions.
> Details here:
> https://lkml.org/lkml/2017/12/20/929
> 
> Patch 1 is kernel wide cleanup of pass-struct-by-value into
> pass-struct-by-reference into tracepoints.
> 
> Patches 2 and 3 are minor cleanups to address allyesconfig build
> 
> Patch 4 refactor trace_iwlwifi_dev_ucode_error from 17 to 4 args
> 
> Patch 5 introduces COUNT_ARGS macro
> 
> Patch 6 introduces BPF_RAW_TRACEPOINT api.
> the auto-cleanup and multiple concurrent users are must have
> features of tracing api. For bpf raw tracepoints it looks like:
>   // load bpf prog with BPF_PROG_TYPE_RAW_TRACEPOINT type
>   prog_fd = bpf_prog_load(...);
> 
>   // receive anon_inode fd for given bpf_raw_tracepoint
>   // and attach bpf program to it
>   raw_tp_fd = bpf_raw_tracepoint_open("xdp_exception", prog_fd);
> 
> Ctrl-C of tracing daemon or cmdline tool will automatically
> detach bpf program, unload it and unregister tracepoint probe.
> More details in patch 6.
> 
> Patch 7 - trivial support in libbpf
> Patches 8, 9 - user space tests
> 
> samples/bpf/test_overhead performance on 1 cpu:
> 
> tracepoint    base  kprobe+bpf tracepoint+bpf raw_tracepoint+bpf
> task_rename   1.1M   769K        947K            1.0M
> urandom_read  789K   697K        750K            755K

Applied to bpf-next, thanks everyone!
