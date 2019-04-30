From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH V32 22/27] bpf: Restrict bpf when kernel lockdown is in
 confidentiality mode
Date: Tue, 30 Apr 2019 15:19:20 -0400
Message-ID: <CAG48ez0uVYJHycXv8jTvYrSGomhsQrQkR+Jpf-vXYJYn58eEjw@mail.gmail.com>
References: <20190404003249.14356-1-matthewgarrett@google.com> <20190404003249.14356-23-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190404003249.14356-23-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>, bpf@vger.kernel.org
Cc: James Morris <jmorris@namei.org>, linux-security-module <linux-security-module@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, Matthew Garrett <mjg59@google.com>, Network Development <netdev@vger.kernel.org>, Chun-Yi Lee <jlee@suse.com>, Daniel Borkmann <daniel@iogearbox.net>
List-Id: linux-api@vger.kernel.org

+bpf list

On Wed, Apr 3, 2019 at 8:34 PM Matthew Garrett
<matthewgarrett@google.com> wrote:
> There are some bpf functions can be used to read kernel memory:
> bpf_probe_read, bpf_probe_write_user and bpf_trace_printk.  These allow
> private keys in kernel memory (e.g. the hibernation image signing key) to
> be read by an eBPF program and kernel memory to be altered without
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
> ---
>  kernel/trace/bpf_trace.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 8b068adb9da1..9e8eda605b5e 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -137,6 +137,9 @@ BPF_CALL_3(bpf_probe_read, void *, dst, u32, size, const void *, unsafe_ptr)
>  {
>         int ret;
>
> +       if (kernel_is_locked_down("BPF", LOCKDOWN_CONFIDENTIALITY))
> +               return -EINVAL;
> +
>         ret = probe_kernel_read(dst, unsafe_ptr, size);
>         if (unlikely(ret < 0))
>                 memset(dst, 0, size);

This looks wrong. bpf_probe_read_proto is declared with an
ARG_PTR_TO_UNINIT_MEM argument, so if you don't do a "memset(dst, 0,
size);" like in the probe_kernel_read() error path, the BPF program
can read uninitialized memory.
