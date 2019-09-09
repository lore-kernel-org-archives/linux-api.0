From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v4 bpf-next 1/4] capability: introduce CAP_BPF and CAP_TRACING
Date: Mon, 9 Sep 2019 15:52:27 -0700
Message-ID: <CALCETrVCimrLCzdZ2Jgb-AFd-Ptjd+MmyD-XW=baSt6uOOTtEg@mail.gmail.com>
References: <20190906231053.1276792-1-ast@kernel.org> <20190906231053.1276792-2-ast@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190906231053.1276792-2-ast@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <ast@kernel.org>, James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Steven Rostedt <rostedt@goodmis.org>
Cc: "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Peter Zijlstra <peterz@infradead.org>, Network Development <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Sep 6, 2019 at 4:10 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> Split BPF and perf/tracing operations that are allowed under
> CAP_SYS_ADMIN into corresponding CAP_BPF and CAP_TRACING.
> For backward compatibility include them in CAP_SYS_ADMIN as well.
>
> The end result provides simple safety model for applications that use BPF:
> - for tracing program types
>   BPF_PROG_TYPE_{KPROBE, TRACEPOINT, PERF_EVENT, RAW_TRACEPOINT, etc}
>   use CAP_BPF and CAP_TRACING
> - for networking program types
>   BPF_PROG_TYPE_{SCHED_CLS, XDP, CGROUP_SKB, SK_SKB, etc}
>   use CAP_BPF and CAP_NET_ADMIN
>
> There are few exceptions from this simple rule:
> - bpf_trace_printk() is allowed in networking programs, but it's using
>   ftrace mechanism, hence this helper needs additional CAP_TRACING.
> - cpumap is used by XDP programs. Currently it's kept under CAP_SYS_ADMIN,
>   but could be relaxed to CAP_NET_ADMIN in the future.
> - BPF_F_ZERO_SEED flag for hash/lru map is allowed under CAP_SYS_ADMIN only
>   to discourage production use.
> - BPF HW offload is allowed under CAP_SYS_ADMIN.
> - cg_sysctl, cg_device, lirc program types are neither networking nor tracing.
>   They can be loaded under CAP_BPF, but attach is allowed under CAP_NET_ADMIN.
>   This will be cleaned up in the future.
>
> userid=nobody + (CAP_TRACING | CAP_NET_ADMIN) + CAP_BPF is safer than
> typical setup with userid=root and sudo by existing bpf applications.
> It's not secure, since these capabilities:
> - allow bpf progs access arbitrary memory
> - let tasks access any bpf map
> - let tasks attach/detach any bpf prog
>
> bpftool, bpftrace, bcc tools binaries should not be installed with
> cap_bpf+cap_tracing, since unpriv users will be able to read kernel secrets.
>
> CAP_BPF, CAP_NET_ADMIN, CAP_TRACING are roughly equal in terms of
> damage they can make to the system.
> Example:
> CAP_NET_ADMIN can stop network traffic. CAP_BPF can write into map
> and if that map is used by firewall-like bpf prog the network traffic
> may stop.
> CAP_BPF allows many bpf prog_load commands in parallel. The verifier
> may consume large amount of memory and significantly slow down the system.
> CAP_TRACING allows many kprobes that can slow down the system.

Do we want to split CAP_TRACE_KERNEL and CAP_TRACE_USER?  It's not
entirely clear to me that it's useful.

>
> In the future more fine-grained bpf permissions may be added.
>
> Existing unprivileged BPF operations are not affected.
> In particular unprivileged users are allowed to load socket_filter and cg_skb
> program types and to create array, hash, prog_array, map-in-map map types.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  include/linux/capability.h          | 18 +++++++++++
>  include/uapi/linux/capability.h     | 49 ++++++++++++++++++++++++++++-
>  security/selinux/include/classmap.h |  4 +--
>  3 files changed, 68 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/capability.h b/include/linux/capability.h
> index ecce0f43c73a..13eb49c75797 100644
> --- a/include/linux/capability.h
> +++ b/include/linux/capability.h
> @@ -247,6 +247,24 @@ static inline bool ns_capable_setid(struct user_namespace *ns, int cap)
>         return true;
>  }
>  #endif /* CONFIG_MULTIUSER */
> +
> +static inline bool capable_bpf(void)
> +{
> +       return capable(CAP_SYS_ADMIN) || capable(CAP_BPF);
> +}
> +static inline bool capable_tracing(void)
> +{
> +       return capable(CAP_SYS_ADMIN) || capable(CAP_TRACING);
> +}
> +static inline bool capable_bpf_tracing(void)
> +{
> +       return capable(CAP_SYS_ADMIN) || (capable(CAP_BPF) && capable(CAP_TRACING));
> +}
> +static inline bool capable_bpf_net_admin(void)
> +{
> +       return (capable(CAP_SYS_ADMIN) || capable(CAP_BPF)) && capable(CAP_NET_ADMIN);
> +}
> +

These helpers are all wrong, unfortunately, since they will produce
inappropriate audit events.  capable_bpf() should look more like this:

if (capable_noaudit(CAP_BPF))
  return capable(CAP_BPF);
if (capable_noaudit(CAP_SYS_ADMIN))
  return capable(CAP_SYS_ADMIN);

return capable(CAP_BPF);

James, etc: should there instead be new helpers to do this more
generically rather than going through the noaudit contortions?  My
code above is horrible.
