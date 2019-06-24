From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH V34 23/29] bpf: Restrict bpf when kernel lockdown is in
 confidentiality mode
Date: Mon, 24 Jun 2019 13:08:44 -0700
Message-ID: <CALCETrWmZX3R1L88Gz9vLY68gcK8zSXL4cA4GqAzQoyqSR7rRQ@mail.gmail.com>
References: <20190622000358.19895-1-matthewgarrett@google.com>
 <20190622000358.19895-24-matthewgarrett@google.com> <739e21b5-9559-d588-3542-bf0bc81de1b2@iogearbox.net>
 <CACdnJuvR2bn3y3fYzg06GWXXgAGjgED2Dfa5g0oAwJ28qCCqBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACdnJuvR2bn3y3fYzg06GWXXgAGjgED2Dfa5g0oAwJ28qCCqBg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@google.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>, James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, David Howells <dhowells@redhat.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, Network Development <netdev@vger.kernel.org>, Chun-Yi Lee <jlee@suse.com>, Jann Horn <jannh@google.com>, bpf@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Jun 24, 2019 at 12:54 PM Matthew Garrett <mjg59@google.com> wrote:
>
> On Mon, Jun 24, 2019 at 8:37 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> > On 06/22/2019 02:03 AM, Matthew Garrett wrote:
> > > From: David Howells <dhowells@redhat.com>
> > >
> > > There are some bpf functions can be used to read kernel memory:
> >
> > Nit: that
>
> Fixed.
>
> > > bpf_probe_read, bpf_probe_write_user and bpf_trace_printk.  These allow
> >
> > Please explain how bpf_probe_write_user reads kernel memory ... ?!
>
> Ha.
>
> > > private keys in kernel memory (e.g. the hibernation image signing key) to
> > > be read by an eBPF program and kernel memory to be altered without
> >
> > ... and while we're at it, also how they allow "kernel memory to be
> > altered without restriction". I've been pointing this false statement
> > out long ago.
>
> Yup. How's the following description:
>
>     bpf: Restrict bpf when kernel lockdown is in confidentiality mode
>
>     There are some bpf functions that can be used to read kernel memory and
>     exfiltrate it to userland: bpf_probe_read, bpf_probe_write_user and
>     bpf_trace_printk.  These could be abused to (eg) allow private
> keys in kernel
>     memory to be leaked. Disable them if the kernel has been locked
> down in confidentiality
>     mode.

I'm confused.  I understand why we're restricting bpf_probe_read().
Why are we restricting bpf_probe_write_user() and bpf_trace_printk(),
though?

--Andy
