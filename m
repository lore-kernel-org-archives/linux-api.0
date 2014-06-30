From: David Drysdale <drysdale@google.com>
Subject: Re: [PATCH 4/5] man-pages: cap_rights_limit.2: limit FD rights for
 Capsicum
Date: Mon, 30 Jun 2014 17:32:33 +0100
Message-ID: <20140630163233.GC10375@google.com>
References: <1404124096-21445-1-git-send-email-drysdale@google.com>
 <1404124096-21445-16-git-send-email-drysdale@google.com>
 <CALCETrUi71FgVABRF4C+n_STc02j=GxRwBqDaoC+NLeAP9Ui3w@mail.gmail.com>
 <20140630153503.GA10375@google.com>
 <CALCETrWYQdAp1E-MNu59XS8DD0oO1dA8EvoqDrMaH2YLos8iSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrWYQdAp1E-MNu59XS8DD0oO1dA8EvoqDrMaH2YLos8iSg@mail.gmail.com>
Sender: linux-security-module-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: LSM List <linux-security-module@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Meredydd Luff <meredydd@senatehouse.org>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jun 30, 2014 at 09:06:41AM -0700, Andy Lutomirski wrote:
> On Mon, Jun 30, 2014 at 8:35 AM, David Drysdale <drysdale@google.com> wrote:
> > On Mon, Jun 30, 2014 at 07:53:57AM -0700, Andy Lutomirski wrote:
> >> On Mon, Jun 30, 2014 at 3:28 AM, David Drysdale <drysdale@google.com> wrote:
> >> > Signed-off-by: David Drysdale <drysdale@google.com>
> >> > ---
> >> >  man2/cap_rights_limit.2 | 171 ++++++++++++++++++++++++++++++++++++++++++++++++
> >> >  1 file changed, 171 insertions(+)
> >> >  create mode 100644 man2/cap_rights_limit.2
> >> >
> >> > diff --git a/man2/cap_rights_limit.2 b/man2/cap_rights_limit.2
> >> > new file mode 100644
> >> > index 000000000000..3484ee1076aa
> >> > --- /dev/null
> >> > +++ b/man2/cap_rights_limit.2
> >> > @@ -0,0 +1,171 @@
> >> > +.\"
> >> > +.\" Copyright (c) 2008-2010 Robert N. M. Watson
> >> > +.\" Copyright (c) 2012-2013 The FreeBSD Foundation
> >> > +.\" Copyright (c) 2013-2014 Google, Inc.
> >> > +.\" All rights reserved.
> >> > +.\"
> >> > +.\" %%%LICENSE_START(BSD_2_CLAUSE)
> >> > +.\" Redistribution and use in source and binary forms, with or without
> >> > +.\" modification, are permitted provided that the following conditions
> >> > +.\" are met:
> >> > +.\" 1. Redistributions of source code must retain the above copyright
> >> > +.\"    notice, this list of conditions and the following disclaimer.
> >> > +.\" 2. Redistributions in binary form must reproduce the above copyright
> >> > +.\"    notice, this list of conditions and the following disclaimer in the
> >> > +.\"    documentation and/or other materials provided with the distribution.
> >> > +.\"
> >> > +.\" THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
> >> > +.\" ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
> >> > +.\" IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
> >> > +.\" ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
> >> > +.\" FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
> >> > +.\" DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
> >> > +.\" OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
> >> > +.\" HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
> >> > +.\" LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
> >> > +.\" OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
> >> > +.\" SUCH DAMAGE.
> >> > +.\" %%%LICENSE_END
> >> > +.\"
> >> > +.TH CAP_RIGHTS_LIMIT 2 2014-05-07 "Linux" "Linux Programmer's Manual"
> >> > +.SH NAME
> >> > +cap_rights_limit \- limit Capsicum capability rights
> >> > +.SH SYNOPSIS
> >> > +.nf
> >> > +.B #include <sys/capsicum.h>
> >> > +.sp
> >> > +.BI "int cap_rights_limit(int " fd ", const struct cap_rights *" rights ,
> >> > +.BI "                     unsigned int " fcntls ,
> >> > +.BI "                     int " nioctls ", unsigned int *" ioctls );
> >>
> >> Am I missing the docs for struct cap_rights somewhere?
> >
> > There's a little bit of discussion in rights.7 (mail 3/5 of the
> > man-pages set), but there isn't a structure description.
> >
> > I was trying to keep the structure opaque to userspace, which would
> > be expected to manipulate the rights with various utility functions
> > rather than directly.
> >
> > But I now realize this leaves a gap -- the description of this syscall
> > doesn't include a full description of its ABI.
> >
> > So I'll add in a description of the structure to this page -- basically:
> >
> >   struct cap_rights {
> >         __u64   cr_rights[2];
> >   };
> >
> > with a slightly complicated scheme to encode rights into the bitmask
> > array.  (The encoding scheme is taken from the FreeBSD implementation,
> > which I've tried to stick to unless there's good reason to change.)
> 
> How does extensibility work?  For example, what happens when someone
> needs to add a new right for whatever reason and they fall off the end
> of the list?
> 
> Linux so-called capabilities have done this a few times, resulting in
> a giant mess.
> 
> --Andy

The rights encoding scheme is supposed to cope with extensions, so let me
have a go at explaining it.

The size of the array in the structure can potentially change in future,
so a less abbreviated version is:

  #define CAP_RIGHTS_VERSION_00   0
  #define CAP_RIGHTS_VERSION_01   1
  #define CAP_RIGHTS_VERSION_02   2
  #define CAP_RIGHTS_VERSION_03   3
  #define CAP_RIGHTS_VERSION      CAP_RIGHTS_VERSION_00
  struct cap_rights {
      uint64_t cr_rights[CAP_RIGHTS_VERSION + 2];
  };

The encoding rules are then:
 - There are between 2 and 5 entries in the array.
 - The number of entries in the array is indicated by the top 2 bits of
   cr_rights[0] (as array size minus 2); this allows for future
   expansion (up to 285 distinct rights):
     0b00 = 2 entries
     0b01 = 3 entries
     0b10 = 4 entries
     0b11 = 5 entries
 - The top 2 bits of cr_rights[i] are 0b00 for i>0.
 - The next 5 bits of each array entry indicate its position in the
   array:
     0b00001 for cr_rights[0]
     0b00010 for cr_rights[1]
     0b00100 for cr_rights[2]
     0b01000 for cr_rights[3]
     0b10000 for cr_rights[4]
 - The remaining 57 bits of each entry are used to hold rights values,
   so the current structure can hold 114 rights, and the maximum is
   285.

So a future kernel (with an expanded array) can cope with an old binary
(that uses a narrow array) by reading the first u64 from the structure,
and using the top 2 bits to figure out how much more memory to copy
from userspace.  Slightly inefficient, but I wouldn't expect rights
setting to be a performance critical operation.

Of course, we can deviate from the FreeBSD implementation details if
we want to -- these details are deliberately hidden from userspace
programs in the rights-manipulation library functions, so a different
implementation under the covers wouldn't affect Capsicum-using
applications.  But I figured it's best to stay close unless there's
a good reason to diverge.
