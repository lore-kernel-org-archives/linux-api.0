From: Michael Kerrisk <mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: [patch] MAINTAINERS: downgrade support for man-pages
Date: Thu, 12 Mar 2009 09:37:52 +1300
Message-ID: <cfd18e0f0903111337l7d423903t70afee6e5a987bfa@mail.gmail.com>
References: <49B70A21.7070400@gmail.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <49B70A21.7070400-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

[Looks as though vger didn't like my long CC list, and didn't carry
the message to the lists, so resending a slightly edited version to
just the lists.]

---------- Forwarded message ----------
=46rom: Michael Kerrisk <mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Date: Wed, Mar 11, 2009 at 1:47 PM
Subject: [patch] MAINTAINERS: downgrade support for man-pages
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linus Torvalds
<torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>,
Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>, Jim Zemlin
<jzemlin-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org>,
Oleg Nesterov <oleg-6lXkIZvqkOAvJsYlp49lxw@public.gmane.org>, Arnd Bergmann <arndb-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>,
Jeff Licquia <licquia-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Miller
<davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Stephen Hemminger
<shemminger-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mats Wichmann
<mats.d.wichmann-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
Ulrich Drepper <drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Petr Baudis <pasky-AlSwsSmVLrQ@public.gmane.org>, "H.
Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Theodore T'so <tytso-3s7WtUTddSA@public.gmane.org>, James
Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Ulrich Drepper
<drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Alain Portal
<alain.portal-CD6X2pywdrkGaKE8qFNMvg@public.gmane.org>, Greg KH <gregkh-l3A5Bk7waGM@public.gmane.org>, Andi Kleen
<andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Matthew Wilcox <matthew-Ztpu424NOJ8@public.gmane.org>, Andries
Brouwer <Andries.Brouwer-rh8NL+sEX9E@public.gmane.org>, hohndel-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org,
"linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


Hi Andrew,

Unfortunately, Linux Foundation funding for my work
on man-pages/testing/doc under the auspices of the
LF documentation fellowship ran out a
short while ago (after earlier attempts to seek funding,
only Google stepped forward with a bit of further
funding for the position), so the patch below
acknowledges something closer to reality.

There will (probably very) soon be a further
downgrade from "Maintained" to "Odd Fixes" or "Orphan",
unless some funding miracle occurs. =A0So, if anyone is
looking to become man-pages maintainer, there may soon be
an opening (okay, don't trample me in the rush ;-).)

Cheers,

Michael

diff --git a/MAINTAINERS b/MAINTAINERS
index 1c2ca1d..61aeb5a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1469,8 +1469,6 @@ L: =A0 =A0 =A0 =A0linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
=A0S: =A0 =A0 Supported

=A0DOCUMENTATION (/Documentation directory)
-P: =A0 =A0 Michael Kerrisk
-M: =A0 =A0 mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
=A0P: =A0 =A0 Randy Dunlap
=A0M: =A0 =A0 rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org
=A0L: =A0 =A0 linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
@@ -2879,7 +2877,7 @@ P: =A0 =A0 =A0 =A0Michael Kerrisk
=A0M: =A0 =A0 mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
=A0W: =A0 =A0 http://www.kernel.org/doc/man-pages
=A0L: =A0 =A0 linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
-S: =A0 =A0 Supported
+S: =A0 =A0 Maintained

=A0MARVELL LIBERTAS WIRELESS DRIVER
=A0P: =A0 =A0 Dan Williams




--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
=46ound a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
