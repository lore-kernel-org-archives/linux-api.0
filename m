From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: Re: [PATCH 15/45] dm-log-userspace.h: include stdint.h in userspace
Date: Tue, 17 Feb 2015 01:48:13 +0200
Message-ID: <20150216234813.GJ12550@lakka.kapsi.fi>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
 <1424127948-22484-16-git-send-email-mikko.rapeli@iki.fi>
 <20150216233254.GA23033@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150216233254.GA23033-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Feb 16, 2015 at 06:32:54PM -0500, Mike Snitzer wrote:
> On Mon, Feb 16 2015 at  6:05pm -0500,
> Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org> wrote:
>=20
> > Fixes compilation error:
> >=20
> > linux/dm-log-userspace.h:416:2: error: unknown type name =E2=80=98u=
int64_t=E2=80=99
>=20
> What userspace code are you compiling?  Do you have a feel for when t=
his
> stopped working?

See Message-Id: <1424127948-22484-1-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
or https://lkml.org/lkml/2015/2/16/521

The failure comes from a test which tries to compile each exported head=
er file
in userspace one at a time.

-Mikko
