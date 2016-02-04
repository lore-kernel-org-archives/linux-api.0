From: Joe Perches <joe@perches.com>
Subject: Re: [patch] MAINTAINERS: trim the file triggers for ABI/API
Date: Thu, 04 Feb 2016 12:55:28 -0800
Message-ID: <1454619328.3263.4.camel@perches.com>
References: <56B35A9F.1080303@gmail.com> <20160204153415.GB6066@x>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160204153415.GB6066@x>
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Triplett <josh@joshtriplett.org>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, lkml <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Steven Rostedt <rostedt@goodmis.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Shuah Khan <shuahkh@osg.samsung.com>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

On Thu, 2016-02-04 at 07:34 -0800, Josh Triplett wrote:
> On Thu, Feb 04, 2016 at 03:05:19PM +0100, Michael Kerrisk (man-pages)=
 wrote:

> Might I suggest an alternate commit message?
>=20
> """
> Commit ea8f8fc8631 ("MAINTAINERS: add linux-api for review of API/ABI
> changes") added file triggers for various paths that likely indicated
> API/ABI changes.=A0=A0However, catching all changes in Documentation/=
ABI/
> and include/uapi/ produces a large volume of mail to linux-api, rathe=
r
> than only API/ABI changes.=A0=A0Drop those two entries, but leave
> include/linux/syscalls.h and kernel/sys_ni.c to catch syscall-related
> changes.
> """
[]
> > diff --git a/MAINTAINERS b/MAINTAINERS
[]
> > @@ -223,9 +223,7 @@ F:=A0=A0drivers/scsi/aacraid/
> >=20
> > =A0ABI/API
> > =A0L:=A0=A0=A0=A0=A0linux-api@vger.kernel.org
> > -F:=A0=A0=A0=A0=A0Documentation/ABI/
> > =A0F:=A0=A0=A0=A0=A0include/linux/syscalls.h
> > -F:=A0=A0=A0=A0=A0include/uapi/
> > =A0F:=A0=A0=A0=A0=A0kernel/sys_ni.c

Maybe add a keyword entry like:

K:	(?i)syscall

to see all actual changes of syscalls too?
