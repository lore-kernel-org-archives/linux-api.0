From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [PATCH ghak90 V7 20/21] audit: add capcontid to set contid
 outside init_user_ns
Date: Fri, 1 Nov 2019 11:09:27 -0400
Message-ID: <20191101150927.c5sf3n5ezfg2eano@madcap2.tricolour.ca>
References: <cover.1568834524.git.rgb@redhat.com>
 <CAHC9VhRDoX9du4XbCnBtBzsNPMGOsb-TKM1CC+sCL7HP=FuTRQ@mail.gmail.com>
 <20191030220320.tnwkaj5gbzchcn7j@madcap2.tricolour.ca>
 <3677995.NTHC7m0fHc@x2>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <3677995.NTHC7m0fHc@x2>
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
To: Steve Grubb <sgrubb@redhat.com>
Cc: nhorman@tuxdriver.com, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com, Linux-Audit Mailing List <linux-audit@redhat.com>, netfilter-devel@vger.kernel.org, ebiederm@xmission.com, simo@redhat.com, netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>, mpatel@redhat.com, Serge Hallyn <serge@hallyn.com>
List-Id: linux-api@vger.kernel.org

On 2019-10-31 10:50, Steve Grubb wrote:
> Hello,
>=20
> TLDR;  I see a lot of benefit to switching away from procfs for setting a=
uid &=20
> sessionid.
>=20
> On Wednesday, October 30, 2019 6:03:20 PM EDT Richard Guy Briggs wrote:
> > > Also, for the record, removing the audit loginuid from procfs is not
> > > something to take lightly, if at all; like it or not, it's part of th=
e
> > > kernel API.
>=20
> It can also be used by tools to iterate processes related to one user or=
=20
> session. I use this in my Intrusion Prevention System which will land in=
=20
> audit user space at some point in the future.
>=20
> > Oh, I'm quite aware of how important this change is and it was discusse=
d
> > with Steve Grubb who saw the concern and value of considering such a
> > disruptive change.
>=20
> Actually, I advocated for syscall. I think the gist of Eric's idea was th=
at /
> proc is the intersection of many nasty problems. By relying on it, you ca=
n't=20
> simplify the API to reduce the complexity. Almost no program actually nee=
ds=20
> access to /proc. ps does. But almost everything else is happy without it.=
 For=20
> example, when you setup chroot jails, you may have to add /dev/random or =
/
> dev/null, but almost never /proc. What does force you to add /proc is any=
=20
> entry point daemon like sshd because it needs to set the loginuid. If we=
=20
> switch away from /proc, then sshd or crond will no longer /require/ procf=
s to=20
> be available which again simplifies the system design.
>=20
> > Removing proc support for auid/ses would be a
> > long-term deprecation if accepted.
>=20
> It might need to just be turned into readonly for a while. But then again=
,=20
> perhaps auid and session should be part of /proc/<pid>/status? Maybe this=
 can=20
> be done independently and ahead of the container work so there is a migra=
tion=20
> path for things that read auid or session. TBH, maybe this should have be=
en=20
> done from the beginning.

How about making loginuid/contid/capcontid writable only via netlink but
still provide the /proc interface for reading?  Deprecation of proc can
be left as a decision for later.  This way sshd/crond/getty don't need
/proc, but the info is still there for tools that want to read it.

> -Steve

- RGB
