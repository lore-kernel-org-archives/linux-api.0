From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH 23/27] bpf: Restrict kernel image access functions when
 the kernel is locked down
Date: Thu, 28 Mar 2019 13:08:39 -0700
Message-ID: <CACdnJusN0XwKAFhCk-z2+u8Wn1OOzbSqQYYACFikcAtFqOA+WA@mail.gmail.com>
References: <20190325220954.29054-1-matthewgarrett@google.com>
 <20190325220954.29054-24-matthewgarrett@google.com> <20190325164221.5d8687bd@shemminger-XPS-13-9360>
 <CALCETrU=EqqRwyQGBT0=_N9-E_pBM53=z+WJrd9OzV7g6xJa0A@mail.gmail.com>
 <alpine.LRH.2.21.1903270523240.5235@namei.org> <CALCETrUZ+oP0xxNt4mwN=AZA+zvkkfPZiAsFmAuqUD48pOHbBg@mail.gmail.com>
 <alpine.LRH.2.21.1903281403540.27561@namei.org> <CACdnJusbi1jB+G0wMcj43wNik9Fiv3QCc8v30ztrFWg5-P-0iQ@mail.gmail.com>
 <alpine.LRH.2.21.1903290621350.1769@namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.21.1903290621350.1769@namei.org>
Sender: netdev-owner@vger.kernel.org
To: James Morris <jmorris@namei.org>
Cc: Andy Lutomirski <luto@kernel.org>, Stephen Hemminger <stephen@networkplumber.org>, Linux API <linux-api@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, Network Development <netdev@vger.kernel.org>, Chun-Yi Lee <jlee@suse.com>, Daniel Borkmann <daniel@iogearbox.net>, Kees Cook <keescook@chromium.org>, Will Drewry <wad@chromium.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 28, 2019 at 12:23 PM James Morris <jmorris@namei.org> wrote:
>
> On Thu, 28 Mar 2019, Matthew Garrett wrote:
>
> > On Wed, Mar 27, 2019 at 8:15 PM James Morris <jmorris@namei.org> wrote:
> > > OTOH, this seems like a combination of mechanism and policy. The 3 modes
> > > are a help here, but I wonder if they may be too coarse grained still,
> > > e.g. if someone wants to allow a specific mechanism according to their own
> > > threat model and mitigations.
> >
> > In general the interfaces blocked by these patches could also be
> > blocked with an LSM, and I'd guess that people with more fine-grained
> > requirements would probably take that approach.
>
> So... I have to ask, why not use LSM for this in the first place?
>
> Either with an existing module or perhaps a lockdown LSM?

Some of it isn't really achievable that way - for instance, enforcing
module or kexec signatures. We have other mechanisms that can be used
to enable that which could be done at the more fine-grained level, but
a design goal was to make it possible to automatically enable a full
set of integrity protections under specified circumstances.
