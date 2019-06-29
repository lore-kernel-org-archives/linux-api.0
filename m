From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH V33 24/30] bpf: Restrict bpf when kernel lockdown is in
 confidentiality mode
Date: Sat, 29 Jun 2019 16:47:52 -0700
Message-ID: <CALCETrUzGfB2EO0eUpan3b4qyUPmkTZ-7dMuLqu_bmnY-ry=SA@mail.gmail.com>
References: <20190621011941.186255-1-matthewgarrett@google.com>
 <20190621011941.186255-25-matthewgarrett@google.com> <CALCETrVUwQP7roLnW6kFG80Cc5U6X_T6AW+BTAftLccYGp8+Ow@mail.gmail.com>
 <alpine.LRH.2.21.1906270621080.28132@namei.org> <6E53376F-01BB-4795-BC02-24F9CAE00001@amacapital.net>
 <bce70c8b-9efd-6362-d536-cfbbcf70b0b7@tycho.nsa.gov> <CALCETrXwt43w6rQY6zt0J_3HOaad=+E5PushJNdSOZDBuaYV+Q@mail.gmail.com>
 <CACdnJuuy7-tkj86njAqtdJ3dUMu-2T8a2y8DC3fMKBK0z9J6ag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACdnJuuy7-tkj86njAqtdJ3dUMu-2T8a2y8DC3fMKBK0z9J6ag@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@google.com>
Cc: Andy Lutomirski <luto@kernel.org>, Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>, linux-security@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, David Howells <dhowells@redhat.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, Network Development <netdev@vger.kernel.org>, Chun-Yi Lee <jlee@suse.com>, Daniel Borkmann <daniel@iogearbox.net>, LSM List <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jun 28, 2019 at 11:47 AM Matthew Garrett <mjg59@google.com> wrote:
>
> On Thu, Jun 27, 2019 at 4:27 PM Andy Lutomirski <luto@kernel.org> wrote:
> > They're really quite similar in my mind.  Certainly some things in the
> > "integrity" category give absolutely trivial control over the kernel
> > (e.g. modules) while others make it quite challenging (ioperm), but
> > the end result is very similar.  And quite a few "confidentiality"
> > things genuinely do allow all kernel memory to be read.
> >
> > I agree that finer-grained distinctions could be useful. My concern is
> > that it's a tradeoff, and the other end of the tradeoff is an ABI
> > stability issue.  If someone decides down the road that some feature
> > that is currently "integrity" can be split into a narrow "integrity"
> > feature and a "confidentiality" feature then, if the user policy knows
> > about the individual features, there's a risk of breaking people's
> > systems.  If we keep the fine-grained control, do we have a clear
> > compatibility story?
>
> My preference right now is to retain the fine-grained aspect of things
> in the internal API, simply because it'll be more annoying to add it
> back later if we want to. I don't want to expose it via the Lockdown
> user facing API for the reasons you've described, but it's not
> impossible that another LSM would find a way to do this reasonably.
> Does it seem reasonable to punt this discussion out to the point where
> another LSM tries to do something with this information, based on the
> implementation they're attempting?

I think I can get behind this, as long as it's clear to LSM authors
that this list is only a little bit stable.  I can certainly see the
use for the fine-grained info being available for auditing.
