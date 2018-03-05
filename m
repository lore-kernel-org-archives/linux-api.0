From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 0/5] bpf, tracing: introduce bpf raw tracepoints
Date: Mon, 5 Mar 2018 14:36:07 +0100
Message-ID: <9bb38939-c357-4db5-6cf4-7b42187f6c7c@iogearbox.net>
References: <20180301041957.399230-1-ast@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180301041957.399230-1-ast@kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net
Cc: torvalds@linux-foundation.org, peterz@infradead.org, mingo@kernel.org, rostedt@goodmis.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 03/01/2018 05:19 AM, Alexei Starovoitov wrote:
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

Ping, Peter/Steven. If you have a chance, please review the series.

> Patch 1 is kernel wide cleanup of pass-struct-by-value into
> pass-struct-by-reference into tracepoints.
> 
> Patch 2 minor prep work to expose number of arguments passed
> into tracepoints.
> 
> Patch 3 introduces BPF_RAW_TRACEPOINT api.
> the auto-cleanup and multiple concurrent users are must have
> features of tracing api. For bpf raw tracepoints it looks like:
>   // load bpf prog with BPF_PROG_TYPE_RAW_TRACEPOINT type
>   prog_fd = bpf_prog_load(...);
> 
>   // receive anon_inode fd for given bpf_raw_tracepoint
>   raw_tp_fd = bpf_raw_tracepoint_open("xdp_exception");
> 
>   // attach bpf program to given tracepoint
>   bpf_prog_attach(prog_fd, raw_tp_fd, BPF_RAW_TRACEPOINT);
> 
> Ctrl-C of tracing daemon or cmdline tool will automatically
> detach bpf program, unload it and unregister tracepoint probe.
> More details in patch 3.
> 
> Patch 4, 5 - user space lib and tests
> 
> samples/bpf/test_overhead performance on 1 cpu:
> 
> tracepoint    base  kprobe+bpf tracepoint+bpf raw_tracepoint+bpf
> task_rename   1.1M   769K        947K            1.0M
> urandom_read  789K   697K        750K            755K
> 
> Alexei Starovoitov (5):
>   treewide: remove struct-pass-by-value from tracepoints arguments
>   tracepoint: compute num_args at build time
>   bpf: introduce BPF_RAW_TRACEPOINT
>   libbpf: add bpf_raw_tracepoint_open helper
>   samples/bpf: raw tracepoint test
> 
>  arch/x86/xen/mmu_pv.c                    |  16 +--
>  drivers/gpu/drm/i915/i915_trace.h        |  13 +-
>  drivers/infiniband/hw/hfi1/file_ops.c    |   2 +-
>  drivers/infiniband/hw/hfi1/trace_ctxts.h |  12 +-
>  drivers/s390/cio/ioasm.c                 |  18 +--
>  drivers/s390/cio/trace.h                 |  50 ++++----
>  fs/dax.c                                 |   2 +-
>  include/linux/bpf_types.h                |   1 +
>  include/linux/trace_events.h             |  57 +++++++++
>  include/linux/tracepoint-defs.h          |   1 +
>  include/linux/tracepoint.h               |  32 +++--
>  include/trace/bpf_probe.h                |  87 +++++++++++++
>  include/trace/define_trace.h             |  15 ++-
>  include/trace/events/f2fs.h              |   2 +-
>  include/trace/events/fs_dax.h            |   6 +-
>  include/trace/events/rcu.h               |   4 +-
>  include/trace/events/xen.h               |  32 ++---
>  include/uapi/linux/bpf.h                 |  11 ++
>  kernel/bpf/syscall.c                     | 108 ++++++++++++++++
>  kernel/rcu/tree.c                        |  10 +-
>  kernel/trace/bpf_trace.c                 | 211 +++++++++++++++++++++++++++++++
>  kernel/tracepoint.c                      |  27 ++--
>  net/wireless/trace.h                     |   2 +-
>  samples/bpf/Makefile                     |   1 +
>  samples/bpf/bpf_load.c                   |  13 ++
>  samples/bpf/test_overhead_raw_tp_kern.c  |  17 +++
>  samples/bpf/test_overhead_user.c         |  12 ++
>  sound/firewire/amdtp-stream-trace.h      |   2 +-
>  tools/include/uapi/linux/bpf.h           |  11 ++
>  tools/lib/bpf/bpf.c                      |  10 ++
>  tools/lib/bpf/bpf.h                      |   1 +
>  31 files changed, 677 insertions(+), 109 deletions(-)
>  create mode 100644 include/trace/bpf_probe.h
>  create mode 100644 samples/bpf/test_overhead_raw_tp_kern.c
> 
