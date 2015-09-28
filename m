From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH v8 00/41] Richacls
Date: Mon, 28 Sep 2015 13:46:48 -0400
Message-ID: <20150928174648.GA3190@fieldses.org>
References: <1443391772-10171-1-git-send-email-agruenba@redhat.com>
 <20150928163543.GF1358@fieldses.org>
 <CAHpGcM++=D1yrkVmZsKwdQCQj4yPdwGGNbmF-Bma7Yo_+kpNQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHpGcM++=D1yrkVmZsKwdQCQj4yPdwGGNbmF-Bma7Yo_+kpNQQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andreas =?utf-8?Q?Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jeff Layton <jlayton@poochiereds.net>, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, linux-ext4@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Linux API Mailing List <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Sep 28, 2015 at 07:10:06PM +0200, Andreas Gr=C3=BCnbacher wrote=
:
> 2015-09-28 18:35 GMT+02:00 J. Bruce Fields <bfields@fieldses.org>:
> > On Mon, Sep 28, 2015 at 12:08:51AM +0200, Andreas Gruenbacher wrote=
:
> >> Open issues in nfs:
> >>
> >> * When a user or group name cannot be mapped, nfs's idmapper alway=
s maps it
> >>   to nobody. That's good enough for mapping the file owner and own=
ing
> >>   group, but not for identifiers in acls. For now, to get the nfs =
richacl
> >>   support somewhat working, I'm explicitly checking if mapping has=
 resulted
> >>   in uid/gid 99 in the kernel.
> >>
> >> * When the nfs server replies with NFS4ERR_BADNAME for any user or=
 group
> >>   name lookup, the client will stop sending numeric uids and gids =
to the
> >>   server even when the lookup wasn't numeric.  From then on, the c=
lient
> >>   will translate uids and gids that have no mapping to the string =
"nobody",
> >>   and the server will reject them.  This problem is not specific t=
o acls.
> >
> > Do you have fixes in mind for these two issues?
>=20
> I'm not sure how to best fix the idmapper problem, with backwards
> compatibility and all.

I haven't looked at the current nfsidmap interface....  So it's
completely lacking any way to communicate failure?

> The second problem shouldn't be too hard to fix.

Is it enough to turn off the failover in the case there's no possibilit=
y
it could have been caused by a numeric id?

If any user can set ACLs with arbitrary strings as names, then we'd be
giving any user unprivileged user the ability to turn off numeric
idmapping, so I think we need to fix that.

--b.
