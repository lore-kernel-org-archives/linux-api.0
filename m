From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH 4/5] man-pages: cap_rights_limit.2: limit FD rights for Capsicum
Date: Mon, 30 Jun 2014 09:06:41 -0700
Message-ID: <CALCETrWYQdAp1E-MNu59XS8DD0oO1dA8EvoqDrMaH2YLos8iSg@mail.gmail.com>
References: <1404124096-21445-1-git-send-email-drysdale@google.com>
 <1404124096-21445-16-git-send-email-drysdale@google.com> <CALCETrUi71FgVABRF4C+n_STc02j=GxRwBqDaoC+NLeAP9Ui3w@mail.gmail.com>
 <20140630153503.GA10375@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140630153503.GA10375-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jun 30, 2014 at 8:35 AM, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> On Mon, Jun 30, 2014 at 07:53:57AM -0700, Andy Lutomirski wrote:
>> On Mon, Jun 30, 2014 at 3:28 AM, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>> > Signed-off-by: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> > ---
>> >  man2/cap_rights_limit.2 | 171 ++++++++++++++++++++++++++++++++++++++++++++++++
>> >  1 file changed, 171 insertions(+)
>> >  create mode 100644 man2/cap_rights_limit.2
>> >
>> > diff --git a/man2/cap_rights_limit.2 b/man2/cap_rights_limit.2
>> > new file mode 100644
>> > index 000000000000..3484ee1076aa
>> > --- /dev/null
>> > +++ b/man2/cap_rights_limit.2
>> > @@ -0,0 +1,171 @@
>> > +.\"
>> > +.\" Copyright (c) 2008-2010 Robert N. M. Watson
>> > +.\" Copyright (c) 2012-2013 The FreeBSD Foundation
>> > +.\" Copyright (c) 2013-2014 Google, Inc.
>> > +.\" All rights reserved.
>> > +.\"
>> > +.\" %%%LICENSE_START(BSD_2_CLAUSE)
>> > +.\" Redistribution and use in source and binary forms, with or without
>> > +.\" modification, are permitted provided that the following conditions
>> > +.\" are met:
>> > +.\" 1. Redistributions of source code must retain the above copyright
>> > +.\"    notice, this list of conditions and the following disclaimer.
>> > +.\" 2. Redistributions in binary form must reproduce the above copyright
>> > +.\"    notice, this list of conditions and the following disclaimer in the
>> > +.\"    documentation and/or other materials provided with the distribution.
>> > +.\"
>> > +.\" THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
>> > +.\" ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
>> > +.\" IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
>> > +.\" ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
>> > +.\" FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
>> > +.\" DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
>> > +.\" OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
>> > +.\" HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
>> > +.\" LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
>> > +.\" OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
>> > +.\" SUCH DAMAGE.
>> > +.\" %%%LICENSE_END
>> > +.\"
>> > +.TH CAP_RIGHTS_LIMIT 2 2014-05-07 "Linux" "Linux Programmer's Manual"
>> > +.SH NAME
>> > +cap_rights_limit \- limit Capsicum capability rights
>> > +.SH SYNOPSIS
>> > +.nf
>> > +.B #include <sys/capsicum.h>
>> > +.sp
>> > +.BI "int cap_rights_limit(int " fd ", const struct cap_rights *" rights ,
>> > +.BI "                     unsigned int " fcntls ,
>> > +.BI "                     int " nioctls ", unsigned int *" ioctls );
>>
>> Am I missing the docs for struct cap_rights somewhere?
>
> There's a little bit of discussion in rights.7 (mail 3/5 of the
> man-pages set), but there isn't a structure description.
>
> I was trying to keep the structure opaque to userspace, which would
> be expected to manipulate the rights with various utility functions
> rather than directly.
>
> But I now realize this leaves a gap -- the description of this syscall
> doesn't include a full description of its ABI.
>
> So I'll add in a description of the structure to this page -- basically:
>
>   struct cap_rights {
>         __u64   cr_rights[2];
>   };
>
> with a slightly complicated scheme to encode rights into the bitmask
> array.  (The encoding scheme is taken from the FreeBSD implementation,
> which I've tried to stick to unless there's good reason to change.)

How does extensibility work?  For example, what happens when someone
needs to add a new right for whatever reason and they fall off the end
of the list?

Linux so-called capabilities have done this a few times, resulting in
a giant mess.

--Andy
