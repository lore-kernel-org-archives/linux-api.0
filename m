From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: Re: [PATCH v4 18/79] dm-log-userspace.h: use __u32, __s32 and __u64
 from linux/types.h
Date: Thu, 15 Oct 2015 20:53:34 +0300
Message-ID: <20151015175334.GB6104@lakka.kapsi.fi>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
 <1444888618-4506-19-git-send-email-mikko.rapeli@iki.fi>
 <20151015080950.GA25635@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151015080950.GA25635-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi,

On Thu, Oct 15, 2015 at 04:09:50AM -0400, Mike Snitzer wrote:
> On Thu, Oct 15 2015 at  1:55am -0400,
> Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org> wrote:
>=20
> > Fixes userspace compilation errors like:
> >=20
> > linux/dm-log-userspace.h:416:2: error: unknown type name =E2=80=98u=
int64_t=E2=80=99
> >=20
> > Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
>=20
> As was already explained before, there is no need to compile this for
> userspace consumption.  Where is this requirement coming from?

Sorry, maybe I did not understand this comment. Currently
include/uapi/linux/dm-log-userspace.h is in uapi headers and thus expor=
ted
to userspace and has this bug/feature which breaks a build.

Are you saying that it should not be exported to userspace at all and i=
t
should be moved back to include/linux/dm-log.h?

I can prepare such a change instead.

> If your 0th patch's header speaks to _why_ you keep requesting this
> change then please cc me on it.

Sorry, I'm touching too many uapi headers with similar changes
so I can't Cc that many mailing lists and individuals with the cover
letter, but it is available here:

https://lkml.org/lkml/2015/10/15/22

-Mikko
