From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH v5 bpf-next 00/10] bpf, tracing: introduce bpf raw
 tracepoints
Date: Mon, 26 Mar 2018 10:28:03 +0200
Message-ID: <c8be6d52-3f86-0402-9fdc-cc98f8e3e940@iogearbox.net>
References: <20180324023038.938665-1-ast@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180324023038.938665-1-ast@fb.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <ast@fb.com>, davem@davemloft.net
Cc: torvalds@linux-foundation.org, peterz@infradead.org, rostedt@goodmis.org, netdev@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 03/24/2018 03:30 AM, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> v4->v5:
> - adopted Daniel's fancy REPEAT macro in bpf_trace.c in patch 7
>   
> v3->v4:
> - adopted Linus's CAST_TO_U64 macro to cast any integer, pointer, or small
>   struct to u64. That nicely reduced the size of patch 1
> 
> v2->v3:
> - with Linus's suggestion introduced generic COUNT_ARGS and CONCATENATE macros
>   (or rather moved them from apparmor)
>   that cleaned up patches 6 and 7
> - added patch 4 to refactor trace_iwlwifi_dev_ucode_error() from 17 args to 4
>   Now any tracepoint with >12 args will have build error
> 
> v1->v2:
> - simplified api by combing bpf_raw_tp_open(name) + bpf_attach(prog_fd) into
>   bpf_raw_tp_open(name, prog_fd) as suggested by Daniel.
>   That simplifies bpf_detach as well which is now simple close() of fd.
> - fixed memory leak in error path which was spotted by Daniel.
> - fixed bpf_get_stackid(), bpf_perf_event_output() called from raw tracepoints
> - added more tests
> - fixed allyesconfig build caught by buildbot
> 
> v1:
> This patch set is a different way to address the pressing need to access
> task_struct pointers in sched tracepoints from bpf programs.
> 
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
> Patch 6 minor prep work to expose number of arguments passed
> into tracepoints.
> 
> Patch 7 introduces BPF_RAW_TRACEPOINT api.
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
> More details in patch 7.
> 
> Patch 8 - trivial support in libbpf
> Patches 9, 10 - user space tests
> 
> samples/bpf/test_overhead performance on 1 cpu:
> 
> tracepoint    base  kprobe+bpf tracepoint+bpf raw_tracepoint+bpf
> task_rename   1.1M   769K        947K            1.0M
> urandom_read  789K   697K        750K            755K

Applied to bpf-next, thanks Alexei!
