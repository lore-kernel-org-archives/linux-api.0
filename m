From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [RFC v7 10/41] richacl: Permission check algorithm
Date: Thu, 17 Sep 2015 13:30:51 -0400
Message-ID: <20150917173051.GC13048@fieldses.org>
References: <1441448856-13478-1-git-send-email-agruenba@redhat.com>
 <1441448856-13478-11-git-send-email-agruenba@redhat.com>
 <20150911211617.GF11677@fieldses.org>
 <CAHpGcMJofUKKumcUe=6LOFZrVcJRM5APchbCQpfQzbMK7N1FYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHpGcMJofUKKumcUe=6LOFZrVcJRM5APchbCQpfQzbMK7N1FYg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andreas =?utf-8?Q?Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Linux API Mailing List <linux-api@vger.kernel.org>, linux-cifs@vger.kernel.org, LSM List <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sat, Sep 12, 2015 at 12:12:16AM +0200, Andreas Gr=C3=BCnbacher wrote=
:
> 2015-09-11 23:16 GMT+02:00 J. Bruce Fields <bfields@fieldses.org>:
> > On Sat, Sep 05, 2015 at 12:27:05PM +0200, Andreas Gruenbacher wrote=
:
> >> +             /*
> >> +              * Apply the group file mask to entries other than o=
wner@ and
> >> +              * everyone@ or user entries matching the owner.  Th=
is ensures
> >> +              * that we grant the same permissions as the acl com=
puted by
> >> +              * richacl_apply_masks().
> >> +              *
> >> +              * Without this restriction, the following richacl w=
ould grant
> >> +              * rw access to processes which are both the owner a=
nd in the
> >> +              * owning group, but not to other users in the ownin=
g group,
> >> +              * which could not be represented without masks:
> >> +              *
> >> +              *  owner:rw::mask
> >> +              *  group@:rw::allow
> >> +              */
> >> +             if ((acl->a_flags & RICHACL_MASKED) && richace_is_al=
low(ace))
> >> +                     ace_mask &=3D acl->a_group_mask;
> >
> > I'm having trouble understanding this.  I think the problem is that=
 I
> > don't really understand the notation in your example.  Is a_group_m=
ask
> > zero in that example?  I think it must be, in which case, OK I thin=
k I
> > get it.
>=20
> Yes. I'm not sure if the example becomes easier to understand when th=
e
> empty group mask and perhaps also the other mask is included.

I think it would have been for me.

In general I find it confusing to present the mask bits as additional
ACEs--they're really pretty different.

> > (Though I still have to think about it a little more to convince my=
self
> > that richacl_apply_masks() always gets the same result.)
>=20
> I have tried to break the algorithm into digestible pieces. Do you se=
e
> another way to make things easier to understand?

I just haven't reread those carefully enough yet, working on it....

--b.
