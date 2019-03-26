From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH 23/27] bpf: Restrict kernel image access functions when
 the kernel is locked down
Date: Tue, 26 Mar 2019 12:22:17 -0700
Message-ID: <CALCETrUZ+oP0xxNt4mwN=AZA+zvkkfPZiAsFmAuqUD48pOHbBg@mail.gmail.com>
References: <20190325220954.29054-1-matthewgarrett@google.com>
 <20190325220954.29054-24-matthewgarrett@google.com> <20190325164221.5d8687bd@shemminger-XPS-13-9360>
 <CALCETrU=EqqRwyQGBT0=_N9-E_pBM53=z+WJrd9OzV7g6xJa0A@mail.gmail.com> <alpine.LRH.2.21.1903270523240.5235@namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.21.1903270523240.5235@namei.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Morris <jmorris@namei.org>
Cc: Andy Lutomirski <luto@kernel.org>, Stephen Hemminger <stephen@networkplumber.org>, Linux API <linux-api@vger.kernel.org>, Matthew Garrett <matthewgarrett@google.com>, LSM List <linux-security-module@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, Network Development <netdev@vger.kernel.org>, Chun-Yi Lee <jlee@suse.com>, Daniel Borkmann <daniel@iogearbox.net>, Kees Cook <keescook@chromium.org>, Will Drewry <wad@chromium.org>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 26, 2019 at 11:57 AM James Morris <jmorris@namei.org> wrote:
>
> On Mon, 25 Mar 2019, Andy Lutomirski wrote:
>
> > A while back, I suggested an approach to actually make this stuff
> > mergeable: submit a patch series that adds lockdown mode, enables it
> > by command line option (and maybe sysctl) *only* and has either no
> > effect or only a token effect.  Then we can add actual features to
> > lockdown mode one at a time and review them separately.
>
> This makes sense to me.
>
> >
> > And I'm going to complain loudly unless two things change about this
> > whole thing:
> >
> > 1. Lockdown mode becomes three states, not a boolean.  The states are:
> > no lockdown, best-effort-to-protect-kernel-integrity, and
> > best-effort-to-protect-kernel-secrecy-and-integrity.  And this BPF
> > mess illustrates why: most users will really strongly object to
> > turning off BPF when they actually just want to protect kernel
> > integrity.  And as far as I know, things like Secure Boot policy will
> > mostly care about integrity, not secrecy, and tracing and such should
> > work on a normal locked-down kernel.  So I think we need this knob.
>
> Another approach would be to make this entirely policy based:
>
> - Assign an ID to each lockdown point
> - Implement a policy mechanism where each ID is mapped to 0 or 1
> - Allow this policy to be specified statically or dynamically
>
> So,
>
>         kernel_is_locked_down("ioperm")
>
> becomes
>
>         kernel_is_locked_down(LOCKDOWN_IOPERM)
>
> and this function checks e.g.
>
>         if (lockdown_polcy[id]) {
>                 fail or warn;
>         }
>
> Thoughts?

I'm concerned that this gives too much useless flexibility to
administrators and user code in general.  If you can break kernel
integrity, you can break kernel integrity -- it shouldn't really
matter *how* you break it.

--Andy
