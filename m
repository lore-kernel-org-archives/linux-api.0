From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 18/79] dm-log-userspace.h: use __u32, __s32 and __u64
 from linux/types.h
Date: Thu, 15 Oct 2015 04:09:50 -0400
Message-ID: <20151015080950.GA25635@redhat.com>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
 <1444888618-4506-19-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1444888618-4506-19-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Oct 15 2015 at  1:55am -0400,
Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org> wrote:

> Fixes userspace compilation errors like:
>=20
> linux/dm-log-userspace.h:416:2: error: unknown type name =E2=80=98uin=
t64_t=E2=80=99
>=20
> Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>

As was already explained before, there is no need to compile this for
userspace consumption.  Where is this requirement coming from?

If your 0th patch's header speaks to _why_ you keep requesting this
change then please cc me on it.
