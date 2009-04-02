From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [RFC] asm-generic/{unistd,types,posix_types}.h for new arch
Date: Thu, 2 Apr 2009 15:06:12 +0200
Message-ID: <200904021506.13942.arnd@arndb.de>
References: <49D071A8.4010703@petalogix.com> <49D3DABA.2050001@zytor.com> <20090401213219.7B324FC3AB@magilla.sf.frob.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090401213219.7B324FC3AB-nL1rrgvulkc2UH6IwYuUx0EOCMrvLtNR@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Will Newton <will.newton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Geert Uytterhoeven <geert.uytterhoeven-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, michal.simek-g5w7nrANp4BDPfheJLI6IQ@public.gmane.org, Linux Kernel list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chen Liqin <liqin.chen-+XGAvkf1AAHby3iVrkZq2A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wednesday 01 April 2009, Roland McGrath wrote:
> > Actually, gcc does have the _LP64 and __SIZEOF_POINTER__ macros (as=
 well=20
> > as __CHAR_BIT__), although I don't know how far back it does have t=
hat.=20
> > =A0 =A0 =A0If it has been with us for long enough it might be possi=
ble to=20
> > switch over to using panarch macros.

=46or user space, we also need to consider non-gcc compilers that could=
 have
a different set of macros. As long as we don't start relying on any new
ones besides those we already use (__x86_64__, __s390x__, __powerpc64__=
,
__mips64, __arch64__), we at least don't break anything accidentally.

> Worst case the oldest compilers had <limits.h> and=20
> "#if ULONG_MAX =3D=3D 0xffffffffUL", though I wouldn't like
> myself to be using a setup where <limits.h> got pulled in.

That would of course work with non-gcc, but we are really not allowed
to pull in <limits.h> from places like <types.h> where it would be need=
ed
then.

	Arnd <><
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
