From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH V34 23/29] bpf: Restrict bpf when kernel lockdown is in
 confidentiality mode
Date: Mon, 24 Jun 2019 17:15:22 +0200
Message-ID: <739e21b5-9559-d588-3542-bf0bc81de1b2@iogearbox.net>
References: <20190622000358.19895-1-matthewgarrett@google.com>
 <20190622000358.19895-24-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190622000358.19895-24-matthewgarrett@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>, jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, David Howells <dhowells@redhat.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, Matthew Garrett <mjg59@google.com>, netdev@vger.kernel.org, Chun-Yi Lee <jlee@suse.com>, jannh@google.com, bpf@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 06/22/2019 02:03 AM, Matthew Garrett wrote:
> From: David Howells <dhowells@redhat.com>
> 
> There are some bpf functions can be used to read kernel memory:

Nit: that

> bpf_probe_read, bpf_probe_write_user and bpf_trace_printk.  These allow

Please explain how bpf_probe_write_user reads kernel memory ... ?!

> private keys in kernel memory (e.g. the hibernation image signing key) to
> be read by an eBPF program and kernel memory to be altered without

... and while we're at it, also how they allow "kernel memory to be
altered without restriction". I've been pointing this false statement
out long ago.

> restriction. Disable them if the kernel has been locked down in
> confidentiality mode.
> 
> Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Matthew Garrett <mjg59@google.com>
> cc: netdev@vger.kernel.org
> cc: Chun-Yi Lee <jlee@suse.com>
> cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>

Nacked-by: Daniel Borkmann <daniel@iogearbox.net>

[...]
>  
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index d64c00afceb5..638f9b00a8df 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -137,6 +137,10 @@ BPF_CALL_3(bpf_probe_read, void *, dst, u32, size, const void *, unsafe_ptr)
>  {
>  	int ret;
>  
> +	ret = security_locked_down(LOCKDOWN_BPF_READ);
> +	if (ret)
> +		return ret;

This whole thing is still buggy as has been pointed out before by
Jann. For helpers like above and few others below, error conditions
must clear the buffer ...

>  	ret = probe_kernel_read(dst, unsafe_ptr, size);
>  	if (unlikely(ret < 0))
>  		memset(dst, 0, size);
> @@ -156,6 +160,12 @@ static const struct bpf_func_proto bpf_probe_read_proto = {
>  BPF_CALL_3(bpf_probe_write_user, void *, unsafe_ptr, const void *, src,
>  	   u32, size)
>  {
> +	int ret;
> +
> +	ret = security_locked_down(LOCKDOWN_BPF_READ);
> +	if (ret)
> +		return ret;
> +
>  	/*
>  	 * Ensure we're in user context which is safe for the helper to
>  	 * run. This helper has no business in a kthread.
> @@ -205,7 +215,11 @@ BPF_CALL_5(bpf_trace_printk, char *, fmt, u32, fmt_size, u64, arg1,
>  	int fmt_cnt = 0;
>  	u64 unsafe_addr;
>  	char buf[64];
> -	int i;
> +	int i, ret;
> +
> +	ret = security_locked_down(LOCKDOWN_BPF_READ);
> +	if (ret)
> +		return ret;
>  
>  	/*
>  	 * bpf_check()->check_func_arg()->check_stack_boundary()
> @@ -534,6 +548,10 @@ BPF_CALL_3(bpf_probe_read_str, void *, dst, u32, size,
>  {
>  	int ret;
>  
> +	ret = security_locked_down(LOCKDOWN_BPF_READ);
> +	if (ret)
> +		return ret;
> +
>  	/*
>  	 * The strncpy_from_unsafe() call will likely not fill the entire
>  	 * buffer, but that's okay in this circumstance as we're probing
> diff --git a/security/lockdown/lockdown.c b/security/lockdown/lockdown.c
> index 5a08c17f224d..2eea2cc13117 100644
> --- a/security/lockdown/lockdown.c
> +++ b/security/lockdown/lockdown.c
> @@ -33,6 +33,7 @@ static char *lockdown_reasons[LOCKDOWN_CONFIDENTIALITY_MAX+1] = {
>  	[LOCKDOWN_INTEGRITY_MAX] = "integrity",
>  	[LOCKDOWN_KCORE] = "/proc/kcore access",
>  	[LOCKDOWN_KPROBES] = "use of kprobes",
> +	[LOCKDOWN_BPF_READ] = "use of bpf to read kernel RAM",
>  	[LOCKDOWN_CONFIDENTIALITY_MAX] = "confidentiality",
>  };
>  
> 
