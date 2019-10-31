From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH ghak90 V7 20/21] audit: add capcontid to set contid
 outside init_user_ns
Date: Thu, 31 Oct 2019 19:37:47 -0400
Message-ID: <CAHC9VhQ6Jq5kfrBZ21t9oFR9pYe5gxE2FxLPq27PcSCz4oFauA@mail.gmail.com>
References: <cover.1568834524.git.rgb@redhat.com> <CAHC9VhRDoX9du4XbCnBtBzsNPMGOsb-TKM1CC+sCL7HP=FuTRQ@mail.gmail.com>
 <20191030220320.tnwkaj5gbzchcn7j@madcap2.tricolour.ca> <3677995.NTHC7m0fHc@x2>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3677995.NTHC7m0fHc@x2>
Sender: linux-kernel-owner@vger.kernel.org
To: Steve Grubb <sgrubb@redhat.com>
Cc: Richard Guy Briggs <rgb@redhat.com>, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com, nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>, mpatel@redhat.com
List-Id: linux-api@vger.kernel.org

On Thu, Oct 31, 2019 at 10:51 AM Steve Grubb <sgrubb@redhat.com> wrote:
> On Wednesday, October 30, 2019 6:03:20 PM EDT Richard Guy Briggs wrote:
> > > Also, for the record, removing the audit loginuid from procfs is not
> > > something to take lightly, if at all; like it or not, it's part of the
> > > kernel API.
>
> It can also be used by tools to iterate processes related to one user or
> session. I use this in my Intrusion Prevention System which will land in
> audit user space at some point in the future.

Let's try to stay focused on the audit container ID functionality; I
fear if we start bringing in other unrelated issues we are never going
to land these patches.

> > Oh, I'm quite aware of how important this change is and it was discussed
> > with Steve Grubb who saw the concern and value of considering such a
> > disruptive change.
>
> Actually, I advocated for syscall. I think the gist of Eric's idea was that /
> proc is the intersection of many nasty problems. By relying on it, you can't
> simplify the API to reduce the complexity.

I guess complexity is relative in a sense, but reading and writing a
number from a file in procfs seems awfully simple to me.

> Almost no program actually needs
> access to /proc. ps does. But almost everything else is happy without it. For
> example, when you setup chroot jails, you may have to add /dev/random or /
> dev/null, but almost never /proc. What does force you to add /proc is any
> entry point daemon like sshd because it needs to set the loginuid. If we
> switch away from /proc, then sshd or crond will no longer /require/ procfs to
> be available which again simplifies the system design.

It's not that simple, there are plenty of container use cases beyond
ps which require procfs:

Most LSM aware applications require procfs to view and manage some LSM
state (e.g. /proc/self/attr).

System containers, containers that run their own init/systemd/etc.,
require a working procfs.

Nested container orchestrators often run in system containers, which
require a working procfs (see above).

I'm sure there are plenty others, but these are the ones that came
immediately to mind.

-- 
paul moore
www.paul-moore.com
