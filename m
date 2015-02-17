From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 37/45] include/uapi/linux/socket.h: include sys/socket.h in userspace
Date: Tue, 17 Feb 2015 10:14:10 +0100
Message-ID: <3218094.36vl2gijCv@wuerfel>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi> <1424127948-22484-38-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424127948-22484-38-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tuesday 17 February 2015 00:05:40 Mikko Rapeli wrote:
> This libc header has sockaddr definition for userspace.
> Fixes compilation errors like:
> error: field =E2=80=98ifru_addr=E2=80=99 has incomplete type
> struct sockaddr ifru_addr;
>=20
> Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
> ---
>  include/uapi/linux/socket.h | 4 ++++
>  1 file changed, 4 insertions(+)

This looks wrong: where do you see a use of ifru_addr
in uapi/linux/socket.h?

	Arnd
