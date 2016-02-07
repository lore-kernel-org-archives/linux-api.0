From: Martin Steigerwald <martin@lichtvoll.de>
Subject: Re: getrichacl(1) man page review comments
Date: Sun, 07 Feb 2016 19:16:40 +0100
Message-ID: <1505883.O2zQ69A2Zb@merkaba>
References: <56B770B6.7040803@gmail.com> <56B77139.4080209@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56B77139.4080209@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, "J. Bruce Fields" <bfields@fieldses.org>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, lkml <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, Anna Schumaker <anna.schumaker@netapp.com>, Trond Myklebust <trond.myklebust@primarydata.com>, Jeff Layton <jlayton@poochiereds.net>, Andreas Dilger <adilger@dilger.ca>
List-Id: linux-api@vger.kernel.org

Am Sonntag, 7. Februar 2016, 17:30:49 CET schrieb Michael Kerrisk (man-=
pages):
> Hello Andreas,
>=20
> Here, some comments on the getrichacl(1) page.

I know that the command names are based on setfacl and getfacl. But som=
etimes=20
I still wonder about these names. They just don=C2=B4t fit.

Its chsomething for changing things in Unix traditionally =E2=80=93 cho=
wn, chmod,=20
chattr, chage chsh, you name it =E2=80=93, but there is nothing for que=
rying things.=20
So I get where this is coming from, yet I always found setfacl and getf=
acl=20
command names cumbersome.

Sorry, for posting here instead of a previous richacl implementation pa=
tchset.=20
I fully appreciate that it may be too late to change anything regarding=
=20
command names. Also considering usermod and groupmod the command naming=
 in=20
Unix / Linux appears to be a big mess anyway.

Thanks,
--=20
Martin
