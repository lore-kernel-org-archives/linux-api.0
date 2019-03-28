From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH 23/27] bpf: Restrict kernel image access functions when
 the kernel is locked down
Date: Thu, 28 Mar 2019 14:15:46 +1100 (AEDT)
Message-ID: <alpine.LRH.2.21.1903281403540.27561@namei.org>
References: <20190325220954.29054-1-matthewgarrett@google.com> <20190325220954.29054-24-matthewgarrett@google.com> <20190325164221.5d8687bd@shemminger-XPS-13-9360> <CALCETrU=EqqRwyQGBT0=_N9-E_pBM53=z+WJrd9OzV7g6xJa0A@mail.gmail.com> <alpine.LRH.2.21.1903270523240.5235@namei.org>
 <CALCETrUZ+oP0xxNt4mwN=AZA+zvkkfPZiAsFmAuqUD48pOHbBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrUZ+oP0xxNt4mwN=AZA+zvkkfPZiAsFmAuqUD48pOHbBg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Stephen Hemminger <stephen@networkplumber.org>, Linux API <linux-api@vger.kernel.org>, Matthew Garrett <matthewgarrett@google.com>, LSM List <linux-security-module@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, Network Development <netdev@vger.kernel.org>, Chun-Yi Lee <jlee@suse.com>, Daniel Borkmann <daniel@iogearbox.net>, Kees Cook <keescook@chromium.org>, Will Drewry <wad@chromium.org>
List-Id: linux-api@vger.kernel.org

On Tue, 26 Mar 2019, Andy Lutomirski wrote:

> >
> >         kernel_is_locked_down("ioperm")
> >
> > becomes
> >
> >         kernel_is_locked_down(LOCKDOWN_IOPERM)
> >
> > and this function checks e.g.
> >
> >         if (lockdown_polcy[id]) {
> >                 fail or warn;
> >         }
> >
> > Thoughts?
> 
> I'm concerned that this gives too much useless flexibility to
> administrators and user code in general.  If you can break kernel
> integrity, you can break kernel integrity -- it shouldn't really
> matter *how* you break it.

OTOH, this seems like a combination of mechanism and policy. The 3 modes 
are a help here, but I wonder if they may be too coarse grained still, 
e.g. if someone wants to allow a specific mechanism according to their own 
threat model and mitigations.

Secure boot gives you some assurance of the static state of the system at 
boot time, and lockdown is certainly useful (with or without secure boot), 
but it's not a complete solution to runtime kernel integrity protection by 
any stretch of the imagination.  I'm concerned about it being perceived as 
such.

I'm not sure how to think about it architecturally and how it fits as such 
in the mainline kernel.


-- 
James Morris
<jmorris@namei.org>
