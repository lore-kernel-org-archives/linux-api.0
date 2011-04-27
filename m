From: Andrea Righi <andrea-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org>
Subject: Re: [RFC] [PATCH] drop_pagecache syscall
Date: Wed, 27 Apr 2011 11:47:17 +0200
Message-ID: <20110427094717.GB1749@linux.betterlinux.com>
References: <1303853727-21444-1-git-send-email-andrea@betterlinux.com>
 <20110427001453.GD12436@dastard>
 <20110427085910.GA1749@linux.betterlinux.com>
 <BANLkTimrpNOHVfnund7uc=thf-c3_HxyYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BANLkTimrpNOHVfnund7uc=thf-c3_HxyYQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Cc: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Apr 27, 2011 at 05:10:41AM -0400, Mike Frysinger wrote:
> On Wed, Apr 27, 2011 at 05:01, Andrea Righi wrote:
> > On Wed, Apr 27, 2011 at 10:14:53AM +1000, Dave Chinner wrote:
> >> On Tue, Apr 26, 2011 at 11:35:27PM +0200, Andrea Righi wrote:
> >> > This functionality can be used by all the applications that want=
 to have a
> >> > better control over the page cache management (for example to im=
mediately drop
> >> > pages that for sure will not be reused in the near future, witho=
ut calling
> >> > posix_fadvise() for all the files they've touched), or to provid=
e a more fine
> >> > grained debugging feature usable by the filesystem benchmarks.
> >> >
> >> > The system call does not require root privileges and it can be c=
alled by any
> >> > unprivileged application. For example, we can write a userspace =
tool to run
> >> > something like this:
> >> >
> >> > =A0 $ drop-pagecache /path/file_or_dir
> >>
> >> That's a potential DOS vector, I think. Drop the pagecache in a ha=
rd
> >> loop on the root fs of a busy server and watch it crawl...
> >
> > Yes, probably we could allow only the CAP_SYS_ADMIN tasks to execut=
e
> > this syscall.
>=20
> if /proc/sys/vm/drop_caches has any checks other than file permission
> checks (i.e. UID=3D=3D0), it'd probably be better to copy those rathe=
r
> than picking something different.

ok, what about checking current_euid() =3D=3D 0?

Thanks,
-Andrea
