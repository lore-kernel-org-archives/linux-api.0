From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH 23/27] bpf: Restrict kernel image access functions when
 the kernel is locked down
Date: Fri, 29 Mar 2019 06:23:30 +1100 (AEDT)
Message-ID: <alpine.LRH.2.21.1903290621350.1769@namei.org>
References: <20190325220954.29054-1-matthewgarrett@google.com> <20190325220954.29054-24-matthewgarrett@google.com> <20190325164221.5d8687bd@shemminger-XPS-13-9360> <CALCETrU=EqqRwyQGBT0=_N9-E_pBM53=z+WJrd9OzV7g6xJa0A@mail.gmail.com> <alpine.LRH.2.21.1903270523240.5235@namei.org>
 <CALCETrUZ+oP0xxNt4mwN=AZA+zvkkfPZiAsFmAuqUD48pOHbBg@mail.gmail.com> <alpine.LRH.2.21.1903281403540.27561@namei.org> <CACdnJusbi1jB+G0wMcj43wNik9Fiv3QCc8v30ztrFWg5-P-0iQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACdnJusbi1jB+G0wMcj43wNik9Fiv3QCc8v30ztrFWg5-P-0iQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@google.com>
Cc: Andy Lutomirski <luto@kernel.org>, Stephen Hemminger <stephen@networkplumber.org>, Linux API <linux-api@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, Network Development <netdev@vger.kernel.org>, Chun-Yi Lee <jlee@suse.com>, Daniel Borkmann <daniel@iogearbox.net>, Kees Cook <keescook@chromium.org>, Will Drewry <wad@chromium.org>
List-Id: linux-api@vger.kernel.org

On Thu, 28 Mar 2019, Matthew Garrett wrote:

> On Wed, Mar 27, 2019 at 8:15 PM James Morris <jmorris@namei.org> wrote:
> > OTOH, this seems like a combination of mechanism and policy. The 3 modes
> > are a help here, but I wonder if they may be too coarse grained still,
> > e.g. if someone wants to allow a specific mechanism according to their own
> > threat model and mitigations.
> 
> In general the interfaces blocked by these patches could also be
> blocked with an LSM, and I'd guess that people with more fine-grained
> requirements would probably take that approach.

So... I have to ask, why not use LSM for this in the first place?

Either with an existing module or perhaps a lockdown LSM?

> 
> > Secure boot gives you some assurance of the static state of the system at
> > boot time, and lockdown is certainly useful (with or without secure boot),
> > but it's not a complete solution to runtime kernel integrity protection by
> > any stretch of the imagination.  I'm concerned about it being perceived as
> > such.
> 
> What do you think the functionality gaps are in terms of ensuring
> kernel integrity (other than kernel flaws that allow the restrictions
> to be bypassed)?

I don't know of any non-flaw gaps.

-- 
James Morris
<jmorris@namei.org>
