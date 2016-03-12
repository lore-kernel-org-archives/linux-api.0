From: Simo <simo-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v18 00/22] Richacls (Core and Ext4)
Date: Sat, 12 Mar 2016 16:12:27 -0500
Message-ID: <1457817147.3540.28.camel@samba.org>
References: <1456733847-17982-1-git-send-email-agruenba@redhat.com>
	 <20160311140134.GA14808@infradead.org>
	 <20160311140757.GB13178@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160311140757.GB13178-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, 2016-03-11 at 09:07 -0500, J. Bruce Fields wrote:
> On Fri, Mar 11, 2016 at 06:01:34AM -0800, Christoph Hellwig wrote:
> >=20
> > On Mon, Feb 29, 2016 at 09:17:05AM +0100, Andreas Gruenbacher
> > wrote:
> > >=20
> > > Al,
> > >=20
> > > could you please make sure you are happy with the current version
> > > of the
> > > richacl patch queue for the next merge window?
> > I'm still not happy.
> >=20
> > For one I still see no reason to merge this broken ACL model at
> > all.
> > It provides our actualy Linux users no benefit at all, while
> > breaking
> > a lot of assumptions, especially by adding allow and deny ACE at
> > the
> > same sime.
> Could you explain what you mean by "adding allow and deny ACE at the
> same time"?
>=20
> >=20
> > It also doesn't help with the issue that the main thing it's trying
> > to be compatible with (Windows) actually uses a fundamentally
> > different
> > identifier to apply the ACLs to - as long as you're still limited
> > to users and groups and not guids we'll still have that mapping
> > problem
> > anyway.
> Agreed, but, one step at a time?=C2=A0=C2=A0My impression is that the=
 Samba
> people
> still consider this a step forward for Linux compatibility.

It is a step forward, but being able to store SIDs in the ACL, would be
a much better one.

Simo.

> --b.
>=20
> >=20
> >=20
> > But besides that fundamental question on the purpose of it I also
> > don't think the code is suitable, more in the individual patches.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
=20
> in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at=C2=A0=C2=A0http://vger.kernel.org/majordomo-in=
fo.html
