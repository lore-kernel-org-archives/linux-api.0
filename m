From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH 23/27] bpf: Restrict kernel image access functions when
 the kernel is locked down
Date: Mon, 25 Mar 2019 17:10:00 -0700
Message-ID: <CALCETrU=EqqRwyQGBT0=_N9-E_pBM53=z+WJrd9OzV7g6xJa0A@mail.gmail.com>
References: <20190325220954.29054-1-matthewgarrett@google.com>
 <20190325220954.29054-24-matthewgarrett@google.com> <20190325164221.5d8687bd@shemminger-XPS-13-9360>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190325164221.5d8687bd@shemminger-XPS-13-9360>
Sender: netdev-owner@vger.kernel.org
To: Stephen Hemminger <stephen@networkplumber.org>, Linux API <linux-api@vger.kernel.org>
Cc: Matthew Garrett <matthewgarrett@google.com>, James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, Network Development <netdev@vger.kernel.org>, Chun-Yi Lee <jlee@suse.com>, Daniel Borkmann <daniel@iogearbox.net>, Kees Cook <keescook@chromium.org>, Will Drewry <wad@chromium.org>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 25, 2019 at 4:42 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Mon, 25 Mar 2019 15:09:50 -0700
> Matthew Garrett <matthewgarrett@google.com> wrote:
>
> > From: David Howells <dhowells@redhat.com>
> >
> > There are some bpf functions can be used to read kernel memory:
> > bpf_probe_read, bpf_probe_write_user and bpf_trace_printk.  These allow
> > private keys in kernel memory (e.g. the hibernation image signing key) to
> > be read by an eBPF program and kernel memory to be altered without
> > restriction.
> >
> > Completely prohibit the use of BPF when the kernel is locked down.
> >
> > Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> > Signed-off-by: David Howells <dhowells@redhat.com>
> > cc: netdev@vger.kernel.org
> > cc: Chun-Yi Lee <jlee@suse.com>
> > cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Signed-off-by: Matthew Garrett <matthewgarrett@google.com>
>
> Wouldn't this mean that Seccomp won't work in locked down mode?

I wasn't cc'd on this series, nor was linux-api, so it's awkward to review.

A while back, I suggested an approach to actually make this stuff
mergeable: submit a patch series that adds lockdown mode, enables it
by command line option (and maybe sysctl) *only* and has either no
effect or only a token effect.  Then we can add actual features to
lockdown mode one at a time and review them separately.

And I'm going to complain loudly unless two things change about this
whole thing:

1. Lockdown mode becomes three states, not a boolean.  The states are:
no lockdown, best-effort-to-protect-kernel-integrity, and
best-effort-to-protect-kernel-secrecy-and-integrity.  And this BPF
mess illustrates why: most users will really strongly object to
turning off BPF when they actually just want to protect kernel
integrity.  And as far as I know, things like Secure Boot policy will
mostly care about integrity, not secrecy, and tracing and such should
work on a normal locked-down kernel.  So I think we need this knob.

2. All the proponents of this series, and the documentation, needs to
document that it's best effort.  There will always be security bugs,
and there will always be things we miss.


--Andy
