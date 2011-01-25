From: Linas Vepstas <linasvepstas@gmail.com>
Subject: Re: [BUG] Generic syscalls -- chmod vs. fchmodat
Date: Tue, 25 Jan 2011 16:10:48 -0600
Message-ID: <AANLkTi=_sRM6k+fiKiOkbano7LCmys6Hy2Em_W3GaYx=@mail.gmail.com>
References: <AANLkTikhKHnR+7DskxYqWXduX4=tpfgsfL4sNYq+4QDq@mail.gmail.com> <20110125174515.C1DC2183C19@magilla.sf.frob.com> <201101251921.15184.arnd@arndb.de> <201101251352.03079.vapier@gentoo.org> <4D3F2AD9.8060000@redhat.com> <4D3F3308.1050305@redhat.com> <4D3F4156.7010900@redhat.com>
Reply-To: linasvepstas@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <libc-ports-return-1824-gclgp-libc-ports=m.gmane.org@sourceware.org>
In-Reply-To: <4D3F4156.7010900@redhat.com>
List-Unsubscribe: <mailto:libc-ports-unsubscribe-gclgp-libc-ports=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-ports-subscribe@sourceware.org>
List-Post: <mailto:libc-ports@sourceware.org>
List-Help: <mailto:libc-ports-help@sourceware.org>, <http://sourceware.org/lists.html#faqs>
Sender: libc-ports-owner@sourceware.org
To: Eric Blake <eblake@redhat.com>
Cc: Mike Frysinger <vapier@gentoo.org>, Arnd Bergmann <arnd@arndb.de>, Paul Eggert <eggert@cs.ucla.edu>, Roland McGrath <roland@redhat.com>, Chris Metcalf <cmetcalf@tilera.com>, GLIBC Devel <libc-alpha@sourceware.org>, linux-kernel@vger.kernel.org, libc-ports@sourceware.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi,

On 25 January 2011 15:32, Eric Blake <eblake@redhat.com> wrote:
>
> 7. fchmodat(AT_FDCWD, "") must fail with ENOENT. =C2=A0Apparently, the ke=
rnel
> currently modifies ".", although point 1 says it might make more sense
> to fail with ENOENT so that glibc doesn't have to do as much work in
> chmod and fchmodat (if the kernel call does not change, then the burden
> is on glibc).

Interesting discussion, but I'm very embarrassed to say I started it
due to a mis-diagnosis of a bug :-(

In fact, the current kernels *do* check for an empty string, and do so
in order to maintain POSIX compliance, per Eric's points 5 and 7.
See fs/namei.c in do_getname, circa line 114,  where we read:

 * POSIX.1 2.4: an empty pathname is invalid (ENOENT).

This is backed up with code, circa line 129 ff:

   retval =3D strncpy_from_user(page, filename, len);
...
else if (!retval)
      retval =3D -ENOENT;
   return retval;

So an empty string will have length zero, and the ENOENT is indeed
set.

This handles cases 5 & 7.  I've no idea how any of the other cases
work out.

Note that getname() is used in a variety of places; its not just chmod,
but also in symlinks and many others.

--linas
