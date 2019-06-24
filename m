From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH V34 23/29] bpf: Restrict bpf when kernel lockdown is in
 confidentiality mode
Date: Mon, 24 Jun 2019 12:54:00 -0700
Message-ID: <CACdnJuvR2bn3y3fYzg06GWXXgAGjgED2Dfa5g0oAwJ28qCCqBg@mail.gmail.com>
References: <20190622000358.19895-1-matthewgarrett@google.com>
 <20190622000358.19895-24-matthewgarrett@google.com> <739e21b5-9559-d588-3542-bf0bc81de1b2@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <739e21b5-9559-d588-3542-bf0bc81de1b2@iogearbox.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, David Howells <dhowells@redhat.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, Network Development <netdev@vger.kernel.org>, Chun-Yi Lee <jlee@suse.com>, Jann Horn <jannh@google.com>, bpf@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Jun 24, 2019 at 8:37 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 06/22/2019 02:03 AM, Matthew Garrett wrote:
> > From: David Howells <dhowells@redhat.com>
> >
> > There are some bpf functions can be used to read kernel memory:
>
> Nit: that

Fixed.

> > bpf_probe_read, bpf_probe_write_user and bpf_trace_printk.  These allow
>
> Please explain how bpf_probe_write_user reads kernel memory ... ?!

Ha.

> > private keys in kernel memory (e.g. the hibernation image signing key) to
> > be read by an eBPF program and kernel memory to be altered without
>
> ... and while we're at it, also how they allow "kernel memory to be
> altered without restriction". I've been pointing this false statement
> out long ago.

Yup. How's the following description:

    bpf: Restrict bpf when kernel lockdown is in confidentiality mode

    There are some bpf functions that can be used to read kernel memory and
    exfiltrate it to userland: bpf_probe_read, bpf_probe_write_user and
    bpf_trace_printk.  These could be abused to (eg) allow private
keys in kernel
    memory to be leaked. Disable them if the kernel has been locked
down in confidentiality
    mode.

> This whole thing is still buggy as has been pointed out before by
> Jann. For helpers like above and few others below, error conditions
> must clear the buffer ...

Sorry, yes. My fault.
