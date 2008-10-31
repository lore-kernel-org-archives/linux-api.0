From: Daniel Gollub <dgollub-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [patch 0/3] [RFC] kernel/glibc mismatch of "readlink" syscall?
Date: Fri, 31 Oct 2008 16:37:23 +0100
Message-ID: <200810311637.25371.dgollub@suse.de>
References: <20081023145054.998439866@marvin.suse.de> <cfd18e0f0810241553x77194611o11655a89871dc210@mail.gmail.com> <20081031160248.2b95d0e8@desktop.khms.westfalen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20081031160248.2b95d0e8-r49W/1Cwd2f9tVrXfjCyDJqJBGhVce5bs0AfqQuZ5sE@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kai Henningsen <kai.extern-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ltp-list-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, "A.E. Brouwer" <aeb-ek1Qb6IBo2Pz+pZb47iToQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Friday 31 October 2008 16:02:48 Kai Henningsen wrote:
> Am Fri, 24 Oct 2008 17:53:25 -0500
>
> schrieb "Michael Kerrisk" <mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>:
> > Hi Daniel,
> >
> > On Thu, Oct 23, 2008 at 9:50 AM, Daniel Gollub <dgollub-l3A5Bk7waGM@public.gmane.org>
> >
> > wrote:
> > > EINVAL bufsiz is not positive.
> >
> > The EINVAL error was added to man-pages-1.18 in 1997 (even though, =
as
> > you note, the type was "size_t"). =A0I suspect (this was well befor=
e I
> > had any association with man-pages) that was done to reflect kernel
> > reality (since one could bypass glibc invoke the syscall directly),
> > but obviously it is inconsistent with the prototype.
>
> Actually, it's not inconsistent as described, though perhaps that is
> unintentional. "Not positive" isn't the same as "negative", as zero
> isn't positive either, and zero is certainly a possible value of an
> unsigned type

True.

But there is still the problem for the ltp syscall test "readlink03", w=
hen=20
using the glibc "readlink" interface, by calling readlink with a buffer=
 size=20
of "-1".

Calling "-1" seems to be a valid code/error-path in the linux syscall=20
"readlink", since there is a check for less-equal zero.

But the less zero, condition can't be reached via the glibc "readlink"=20
interface since this would cause fortify-check to fail (when buliding w=
ith -
D_FORITFY_SOURCE=3D2).

To "workaround" the fortify check, by not compiling the testcase with -
D_FORTIFY_SOURCE=3D2, or trying to test the linux readlink interface by=
 calling=20
directly syscall() in the testcase ... both suggestion are just workaro=
unds -=20
no real solutions.

We could also just remove the testcase of buffer size "-1".

The problem is still, how to test the "readlink" syscall in LTP?

best regards,
Daniel
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
