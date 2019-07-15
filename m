From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH V35 23/29] bpf: Restrict bpf when kernel lockdown is in
 confidentiality mode
Date: Tue, 16 Jul 2019 00:54:06 +0200
Message-ID: <5d363f09-d649-5693-45c0-bb99d69f0f38@iogearbox.net>
References: <20190715195946.223443-1-matthewgarrett@google.com>
 <20190715195946.223443-24-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190715195946.223443-24-matthewgarrett@google.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>, jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, David Howells <dhowells@redhat.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, Matthew Garrett <mjg59@google.com>, netdev@vger.kernel.org, Chun-Yi Lee <jlee@suse.com>
List-Id: linux-api@vger.kernel.org

On 7/15/19 9:59 PM, Matthew Garrett wrote:
> From: David Howells <dhowells@redhat.com>
> 
> bpf_read() and bpf_read_str() could potentially be abused to (eg) allow
> private keys in kernel memory to be leaked. Disable them if the kernel
> has been locked down in confidentiality mode.
> 
> Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Signed-off-by: Matthew Garrett <mjg59@google.com>
> cc: netdev@vger.kernel.org
> cc: Chun-Yi Lee <jlee@suse.com>
> cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> ---
>  include/linux/security.h     |  1 +
>  kernel/trace/bpf_trace.c     | 10 ++++++++++
>  security/lockdown/lockdown.c |  1 +
>  3 files changed, 12 insertions(+)
> 
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 987d8427f091..8dd1741a52cd 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -118,6 +118,7 @@ enum lockdown_reason {
>  	LOCKDOWN_INTEGRITY_MAX,
>  	LOCKDOWN_KCORE,
>  	LOCKDOWN_KPROBES,
> +	LOCKDOWN_BPF_READ,
>  	LOCKDOWN_CONFIDENTIALITY_MAX,
>  };
>  
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index ca1255d14576..605908da61c5 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -142,7 +142,12 @@ BPF_CALL_3(bpf_probe_read, void *, dst, u32, size, const void *, unsafe_ptr)
>  {
>  	int ret;
>  
> +	ret = security_locked_down(LOCKDOWN_BPF_READ);
> +	if (ret)
> +		goto out;
> +
>  	ret = probe_kernel_read(dst, unsafe_ptr, size);
> +out:
>  	if (unlikely(ret < 0))
>  		memset(dst, 0, size);

Hmm, does security_locked_down() ever return a code > 0 or why do you
have the double check on return code? If not, then for clarity the
ret code from security_locked_down() should be checked as 'ret < 0'
as well and out label should be at the memset directly instead.

> @@ -569,6 +574,10 @@ BPF_CALL_3(bpf_probe_read_str, void *, dst, u32, size,
>  {
>  	int ret;
>  
> +	ret = security_locked_down(LOCKDOWN_BPF_READ);
> +	if (ret)
> +		goto out;
> +
>  	/*
>  	 * The strncpy_from_unsafe() call will likely not fill the entire
>  	 * buffer, but that's okay in this circumstance as we're probing
> @@ -579,6 +588,7 @@ BPF_CALL_3(bpf_probe_read_str, void *, dst, u32, size,
>  	 * is returned that can be used for bpf_perf_event_output() et al.
>  	 */
>  	ret = strncpy_from_unsafe(dst, unsafe_ptr, size);
> +out:
>  	if (unlikely(ret < 0))
>  		memset(dst, 0, size);

Ditto.

Thanks,
Daniel
