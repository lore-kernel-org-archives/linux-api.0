From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH V33 24/30] bpf: Restrict bpf when kernel lockdown is in
 confidentiality mode
Date: Thu, 27 Jun 2019 16:23:10 -0700
Message-ID: <CALCETrU7JVH7LR3d_=s-O=b2bjevTLw2rSm5g50UjaUB2PTY5A@mail.gmail.com>
References: <20190621011941.186255-1-matthewgarrett@google.com>
 <20190621011941.186255-25-matthewgarrett@google.com> <CALCETrVUwQP7roLnW6kFG80Cc5U6X_T6AW+BTAftLccYGp8+Ow@mail.gmail.com>
 <alpine.LRH.2.21.1906270621080.28132@namei.org> <6E53376F-01BB-4795-BC02-24F9CAE00001@amacapital.net>
 <bce70c8b-9efd-6362-d536-cfbbcf70b0b7@tycho.nsa.gov> <alpine.LRH.2.21.1906280332500.17363@namei.org>
 <de8b15eb-ba6c-847a-7435-42742203d4a5@tycho.nsa.gov> <CACdnJuuG8cR7h9v3pNcBKsxyckAzpKuBJs1GQxsz77jk5DRoQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACdnJuuG8cR7h9v3pNcBKsxyckAzpKuBJs1GQxsz77jk5DRoQA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@google.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>, Andy Lutomirski <luto@kernel.org>, linux-security@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, David Howells <dhowells@redhat.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, Network Development <netdev@vger.kernel.org>, Chun-Yi Lee <jlee@suse.com>, Daniel Borkmann <daniel@iogearbox.net>, LSM List <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 27, 2019 at 4:16 PM Matthew Garrett <mjg59@google.com> wrote:
>
> On Thu, Jun 27, 2019 at 1:16 PM Stephen Smalley <sds@tycho.nsa.gov> wrote:
> > That would only allow the LSM to further lock down the system above the
> > lockdown level set at boot, not grant exemptions for specific
> > functionality/interfaces required by the user or by a specific
> > process/program. You'd have to boot with lockdown=none (or your
> > lockdown=custom suggestion) in order for the LSM to allow anything
> > covered by the integrity or confidentiality levels.  And then the kernel
> > would be unprotected prior to full initialization of the LSM, including
> > policy load.
> >
> > It seems like one would want to be able to boot with lockdown=integrity
> > to protect the kernel initially, then switch over to allowing the LSM to
> > selectively override it.
>
> One option would be to allow modules to be "unstacked" at runtime, but
> there's still something of a problem here - how do you ensure that
> your userland can be trusted to load a new policy before it does so?
> If you're able to assert that your early userland is trustworthy
> (perhaps because it's in an initramfs that's part of your signed boot
> payload), there's maybe an argument that most of the lockdown
> integrity guarantees are unnecessary before handoff - just using the
> lockdown LSM to protect against attacks via kernel parameters would be
> sufficient.

I think that, if you don't trust your system enough to avoid
compromising itself before policy load, then your MAC policy is more
or less dead in the water.  It seems to be that it ought to be good
enough to boot with lockdown=none and then have a real policy loaded
along with the rest of the MAC policy.  Or, for applications that need
to be stricter, you accept that MAC policy can't override lockdown.
