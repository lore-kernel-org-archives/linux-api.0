From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] IPC: message queue stealing feature introduced
Date: Thu, 5 Apr 2012 11:50:03 +1200
Message-ID: <CAKgNAkjpWpHR9Ww0JzZqsACktXzsm9r8=k6e7CJF_9+5cWdJBQ@mail.gmail.com>
References: <20120215163203.27978.52494.stgit@localhost6.localdomain6>
 <20120215165439.27978.43513.stgit@localhost6.localdomain6> <20120404161224.dea67733.akpm@linux-foundation.org>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120404161224.dea67733.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Stanislav Kinsbursky <skinsbursky-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, lucas.demarchi-Y3ZbgMPKUGA34EUeqzHoZw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cmetcalf-kv+TWInifGbQT0dZR+AlfA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 5, 2012 at 11:12 AM, Andrew Morton
<akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> On Wed, 15 Feb 2012 20:54:39 +0400
> Stanislav Kinsbursky <skinsbursky-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:

Stanislav,

Luckily, Andrew added me to CC. However, as noted in
Documentation/SubmitChecklist, all patches that change the ABI/API
should CC linux-api-u79uwXL29TaiAVqoAR/hOA@public.gmane.org Please do that for the future.
(CC added for this thread.)

>> v2:
>> 1) compat functions added.
>> 2) message slot size in array is now aligned by struct msgbuf_a.
>> 3) check for enough free space in buffer before message copying adde=
d.
>> 4) if MSG_STEAL flag is set, then do_msgrcv() returns number of byte=
s written
>> to buffer.

By the way, why the name "MSG_STEAL"? At first glance, it sounds like
that means we're taking messages that belong to someone else. But I
gather you are in fact just flushing all messages from a queue. So I
more intuitive name seems to be in order (MSG_READ_ALL,
MSG_FLUSH_ALL?).

>> 5) flag MSG_NOERROR is ignored if MSG_STEAL flag is set.

Would it not be better to return an error if MSG_NOERROR is specified?

>> This patch is required for checkpoint/restore in userspace.
>> IOW, c/r requires some way to get all pending IPC messages without d=
eleting
>> them for the queue (checkpoint can fail and in this case tasks will =
be resumed,
>> so queue have to be valid).
>> To achive this, new operation flag MSG_STEAL for sys_msgrcv() system=
 call
>> introduced.
>> If this flag is set, then passed struct msgbuf pointer will be used =
for storing
>> array of structures:
>>
>> struct msgbuf_a {
>> =A0 =A0 =A0 long mtype; =A0 =A0 =A0 =A0 /* type of message */
>> =A0 =A0 =A0 int msize; =A0 =A0 =A0 =A0 =A0/* size of message */
>> =A0 =A0 =A0 char mtext[0]; =A0 =A0 =A0/* message text */
>> };

So, I'm not clear on how things look here. We get back array like this:

[0]                     [1]                     [2]
| mtype | msize | mtext | mtype | msize | mtext | ...

How do I calculate the offset of element 1 of the array? I assume it
can't be just
(&item[0].mtext + msize), since there'll be alignment issues to deal
with, so that there are padding bytes after each mtext. In that case,
msize on its own seems insufficient (since there is no null-terminator
in msize).

>> each of which will be followed by corresponding message data.
>>
>
> I'd be a bit more comfortable if there was some sign that other c/r
> developers have reviewed and tested this and have successfully used i=
t
> in c/r operation testing?

Indeed, do you have a userspace test program that you could post?

> We've been trying to isolate the c/r-specific functions inside #ifdef
> CONFIG_CHECKPOINT_RESTORE, but this patch doesn't do that. =A0I have =
been
> encouraging this isolation so that people who aren't using c/r don't
> have to carry the overhead it adds and so that we can more easily hun=
t
> down and remove everything if the entire c/r project doesn't work out
> successfully.
>
> This patch modifies the sys_msgrcv() API and so we should update the
> manpage for that syscall. =A0Please work with Michael on this.

Yes please.

Cheers,

Michael


> What does all the compat fiddling actually do? =A0I guess it's needed=
 for
> checkpoint and restore of 32-bit userspace on 64-bit kernels? =A0Does=
 c/r
> as a whole support that? =A0It should. =A0How well tested is this?
>



--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
