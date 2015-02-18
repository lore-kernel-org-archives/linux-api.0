From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: Re: [PATCH 20/45] sctp.h: include stdint.h in userspace
Date: Wed, 18 Feb 2015 18:05:13 +0200
Message-ID: <20150218160513.GN12550@lakka.kapsi.fi>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
 <1424127948-22484-21-git-send-email-mikko.rapeli@iki.fi>
 <54E4B434.3030302@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54E4B434.3030302-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vlad Yasevich <vyasevich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Feb 18, 2015 at 04:48:04PM +0100, Daniel Borkmann wrote:
> On 02/17/2015 12:05 AM, Mikko Rapeli wrote:
> >Fixes compilation error:
> >
> >linux/sctp.h:652:2: error: unknown type name =E2=80=98uint32_t=E2=80=
=99
> >
> >Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
>=20
> I have no idea where the rest of this series went (neither netdev, no=
r
> lkml, nor linux-sctp) and what user space application making use of t=
he
> header you are trying to fix !?

There is a test written to test compilation of exported kernel headers
one by one in userspace. lkml thread is here:

https://lkml.org/lkml/2015/2/16/521

The series should have gone to the right addresses with:

$ git send-email --to linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org \
	--cc-cmd "scripts/get_maintainer.pl --norolestats"

-Mikko
