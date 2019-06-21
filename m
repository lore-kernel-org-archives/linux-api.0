From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH V33 24/30] bpf: Restrict bpf when kernel lockdown is in
 confidentiality mode
Date: Thu, 20 Jun 2019 22:22:21 -0700
Message-ID: <CALCETrVUwQP7roLnW6kFG80Cc5U6X_T6AW+BTAftLccYGp8+Ow@mail.gmail.com>
References: <20190621011941.186255-1-matthewgarrett@google.com> <20190621011941.186255-25-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190621011941.186255-25-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>
Cc: James Morris <jmorris@namei.org>, linux-security@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, David Howells <dhowells@redhat.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, Matthew Garrett <mjg59@google.com>, Network Development <netdev@vger.kernel.org>, Chun-Yi Lee <jlee@suse.com>, Daniel Borkmann <daniel@iogearbox.net>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 20, 2019 at 6:21 PM Matthew Garrett
<matthewgarrett@google.com> wrote:
>
> From: David Howells <dhowells@redhat.com>
>
> There are some bpf functions can be used to read kernel memory:
> bpf_probe_read, bpf_probe_write_user and bpf_trace_printk.  These allow
> private keys in kernel memory (e.g. the hibernation image signing key) to
> be read by an eBPF program and kernel memory to be altered without
> restriction. Disable them if the kernel has been locked down in
> confidentiality mode.

This patch exemplifies why I don't like this approach:

> @@ -97,6 +97,7 @@ enum lockdown_reason {
>         LOCKDOWN_INTEGRITY_MAX,
>         LOCKDOWN_KCORE,
>         LOCKDOWN_KPROBES,
> +       LOCKDOWN_BPF,
>         LOCKDOWN_CONFIDENTIALITY_MAX,

> --- a/security/lockdown/lockdown.c
> +++ b/security/lockdown/lockdown.c
> @@ -33,6 +33,7 @@ static char *lockdown_reasons[LOCKDOWN_CONFIDENTIALITY_MAX+1] = {
>         [LOCKDOWN_INTEGRITY_MAX] = "integrity",
>         [LOCKDOWN_KCORE] = "/proc/kcore access",
>         [LOCKDOWN_KPROBES] = "use of kprobes",
> +       [LOCKDOWN_BPF] = "use of bpf",
>         [LOCKDOWN_CONFIDENTIALITY_MAX] = "confidentiality",

The text here says "use of bpf", but what this patch is *really* doing
is locking down use of BPF to read kernel memory.  If the details
change, then every LSM needs to get updated, and we risk breaking user
policies that are based on LSMs that offer excessively fine
granularity.

I'd be more comfortable if the LSM only got to see "confidentiality"
or "integrity".

--Andy
