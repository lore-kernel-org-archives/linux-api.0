From: David Drysdale <drysdale@google.com>
Subject: Re: [PATCH 5/5] man-pages: cap_rights_get: retrieve Capsicum fd
 rights
Date: Tue, 1 Jul 2014 10:19:00 +0100
Message-ID: <20140701091900.GB2242@google.com>
References: <1404124096-21445-1-git-send-email-drysdale@google.com>
 <1404124096-21445-17-git-send-email-drysdale@google.com>
 <CALCETrW94NY+SNGsW3PYsdHfwpykPYs55FFDztQ2MVwMLmwJ4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrW94NY+SNGsW3PYsdHfwpykPYs55FFDztQ2MVwMLmwJ4Q@mail.gmail.com>
Sender: linux-security-module-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: LSM List <linux-security-module@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Meredydd Luff <meredydd@senatehouse.org>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jun 30, 2014 at 03:28:14PM -0700, Andy Lutomirski wrote:
> On Mon, Jun 30, 2014 at 3:28 AM, David Drysdale <drysdale@google.com>=
 wrote:
> > Signed-off-by: David Drysdale <drysdale@google.com>
> > ---
> >  man2/cap_rights_get.2 | 126 ++++++++++++++++++++++++++++++++++++++=
++++++++++++
> >  1 file changed, 126 insertions(+)
> >  create mode 100644 man2/cap_rights_get.2
> >
> > diff --git a/man2/cap_rights_get.2 b/man2/cap_rights_get.2
> > new file mode 100644
> > index 000000000000..966c0ed7e336
> > --- /dev/null
> > +++ b/man2/cap_rights_get.2
> > @@ -0,0 +1,126 @@
> > +.\"
> > +.\" Copyright (c) 2008-2010 Robert N. M. Watson
> > +.\" Copyright (c) 2012-2013 The FreeBSD Foundation
> > +.\" Copyright (c) 2013-2014 Google, Inc.
> > +.\" All rights reserved.
> > +.\"
> > +.\" %%%LICENSE_START(BSD_2_CLAUSE)
> > +.\" Redistribution and use in source and binary forms, with or wit=
hout
> > +.\" modification, are permitted provided that the following condit=
ions
> > +.\" are met:
> > +.\" 1. Redistributions of source code must retain the above copyri=
ght
> > +.\"    notice, this list of conditions and the following disclaime=
r.
> > +.\" 2. Redistributions in binary form must reproduce the above cop=
yright
> > +.\"    notice, this list of conditions and the following disclaime=
r in the
> > +.\"    documentation and/or other materials provided with the dist=
ribution.
> > +.\"
> > +.\" THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS =
IS'' AND
> > +.\" ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED =
TO, THE
> > +.\" IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTIC=
ULAR PURPOSE
> > +.\" ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS =
BE LIABLE
> > +.\" FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR C=
ONSEQUENTIAL
> > +.\" DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTIT=
UTE GOODS
> > +.\" OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERR=
UPTION)
> > +.\" HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONT=
RACT, STRICT
> > +.\" LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING=
 IN ANY WAY
> > +.\" OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIB=
ILITY OF
> > +.\" SUCH DAMAGE.
> > +.\" %%%LICENSE_END
> > +.\"
> > +.TH CAP_RIGHTS_GET 2 2014-05-07 "Linux" "Linux Programmer's Manual=
"
> > +.SH NAME
> > +cap_rights_get \- retrieve Capsicum capability rights
> > +.SH SYNOPSIS
> > +.nf
> > +.B #include <sys/capsicum.h>
> > +.sp
> > +.BI "int cap_rights_get(int " fd ", struct cap_rights *" rights ,
> > +.BI "                   unsigned int *" fcntls ,
> > +.BI "                   int *" nioctls ", unsigned int *" ioctls )=
;
> > +.SH DESCRIPTION
> > +Obtain the current Capsicum capability rights for a file descripto=
r.
> > +.PP
> > +The function will fill the
> > +.I rights
> > +argument (if non-NULL) with the primary capability rights of the
> > +.I fd
> > +descriptor.  The result can be examined with the
> > +.BR cap_rights_is_set (3)
> > +family of functions.  The complete list of primary rights can be f=
ound in the
> > +.BR rights (7)
> > +manual page.
> > +.PP
> > +If the
> > +.I fcntls
> > +argument is non-NULL, it will be filled in with a bitmask of allow=
ed
> > +.BR fcntl (2)
> > +commands; see
> > +.BR cap_rights_limit (2)
> > +for values.  If the file descriptor does not have the
> > +.B CAP_FCNTL
> > +primary right, the returned
> > +.I fcntls
> > +value will be zero.
> > +.PP
> > +If the
> > +.I nioctls
> > +argument is non-NULL, it will be filled in with the number of allo=
wed
> > +.BR ioctl (2)
> > +commands, or with the value CAP_IOCTLS_ALL to indicate that all
> > +.BR ioctl (2)
> > +commands are allowed.  If the file descriptor does not have the
> > +.B CAP_IOCTL
> > +primary right, the returned
> > +.I nioctls
> > +value will be zero.
> > +.PP
> > +The
> > +.I ioctls
> > +argument (if non-NULL) should point at memory that can hold up to
> > +.I nioctls
> > +values.
> > +The system call populates the provided buffer with up to
> > +.I nioctls
> > +elements, but always returns the total number of
>=20
> I assume you mean "up to the initial value of *nioctls elements" or
> something.  Can you clarify?
>=20
> --Andy

Yeah, that's what I meant.  Is this clearer?

  If  the  ioctls argument is non-NULL, the caller should specify
  the size of the provided buffer as the  initial  value  of  the
  nioctls  argument (as a count of the number of ioctl(2) command
  values the buffer can hold).  On successful completion  of  the
  system call, the ioctls buffer is filled with the ioctl(2) com=E2=80=90
  mand values, up to maximum of the initial value of nioctls.

--
To unsubscribe from this list: send the line "unsubscribe linux-securit=
y-module" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
