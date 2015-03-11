From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: Re: [PATCH 37/45] include/uapi/linux/socket.h: include sys/socket.h
 in userspace
Date: Wed, 11 Mar 2015 02:38:15 +0200
Message-ID: <20150311003815.GC12550@lakka.kapsi.fi>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
 <1424127948-22484-38-git-send-email-mikko.rapeli@iki.fi>
 <3218094.36vl2gijCv@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3218094.36vl2gijCv@wuerfel>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Feb 17, 2015 at 10:14:10AM +0100, Arnd Bergmann wrote:
> On Tuesday 17 February 2015 00:05:40 Mikko Rapeli wrote:
> > This libc header has sockaddr definition for userspace.
> > Fixes compilation errors like:
> > error: field =E2=80=98ifru_addr=E2=80=99 has incomplete type
> > struct sockaddr ifru_addr;
> >=20
> > Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
> > ---
> >  include/uapi/linux/socket.h | 4 ++++
> >  1 file changed, 4 insertions(+)
>=20
> This looks wrong: where do you see a use of ifru_addr
> in uapi/linux/socket.h?

Indeed, this one seems completely wrong. Based on the test logs the
change should have gone to linux/if.h.

-Mikko
