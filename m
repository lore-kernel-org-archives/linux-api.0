From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [RFC v6 10/40] richacl: Permission check algorithm
Date: Mon, 31 Aug 2015 11:23:04 -0400
Message-ID: <20150831152304.GE17812@fieldses.org>
References: <1438689218-6921-1-git-send-email-agruenba@redhat.com>
 <1438689218-6921-11-git-send-email-agruenba@redhat.com>
 <20150828214917.GC23326@fieldses.org>
 <CAHpGcMJT0kQyrvCkur0csCmRn-LwUOJcRWqAfLaqCpNd2b8UXA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHpGcMJT0kQyrvCkur0csCmRn-LwUOJcRWqAfLaqCpNd2b8UXA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas =?utf-8?Q?Gr=C3=BCnbacher?= <andreas.gruenbacher-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS-devel Mailing List <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, Aug 29, 2015 at 12:06:22AM +0200, Andreas Gr=C3=BCnbacher wrote=
:
> 2015-08-28 23:49 GMT+02:00 J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>:
> > On Tue, Aug 04, 2015 at 01:53:08PM +0200, Andreas Gruenbacher wrote=
:
> >> +             /*
> >> +              * We don't care which class the process is in when =
the acl is
> >> +              * not masked.
> >> +              */
> >> +             in_owner_or_group_class =3D 1;
> >
> > So why bother setting it at all, then?  Oh, I see, it lets you brea=
k out
> > of the loop below earlier.  OK.
>=20
> Comment changed to:
>=20
>                 /*
>                  * When the acl is not masked, there is no need to de=
termine if
>                  * the process is in the group class and we can earli=
er break
>                  * out of the loop below.
>                  */

makes sense, just replace "earlier break out" by "break out earlier".

>=20
> > Patch makes sense to me, ACK.
>=20
> Thanks,
> Andreas
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
