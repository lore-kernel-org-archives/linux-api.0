From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH V31 22/25] bpf: Restrict bpf when kernel lockdown is in
 confidentiality mode
Date: Tue, 26 Mar 2019 12:21:24 -0700
Message-ID: <CALCETrUtYir8bCCMMH2kEAEmWBB_h4tL_9fq0zgNwRNXmZfG6A@mail.gmail.com>
References: <20190326182742.16950-1-matthewgarrett@google.com> <20190326182742.16950-23-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190326182742.16950-23-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>
Cc: James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, Andrew Lutomirski <luto@kernel.org>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, Matthew Garrett <mjg59@google.com>, Network Development <netdev@vger.kernel.org>, Chun-Yi Lee <jlee@suse.com>, Daniel Borkmann <daniel@iogearbox.net>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 26, 2019 at 11:28 AM Matthew Garrett
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
>

:)

This is yet another reason to get the new improved bpf_probe_user_read
stuff landed!
