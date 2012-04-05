From: Stanislav Kinsbursky <skinsbursky-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 2/2] IPC: message queue stealing feature introduced
Date: Thu, 05 Apr 2012 15:42:28 +0400
Message-ID: <4F7D8524.8030709@parallels.com>
References: <20120215163203.27978.52494.stgit@localhost6.localdomain6> <20120215165439.27978.43513.stgit@localhost6.localdomain6> <20120404161224.dea67733.akpm@linux-foundation.org> <CAKgNAkjpWpHR9Ww0JzZqsACktXzsm9r8=k6e7CJF_9+5cWdJBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKgNAkjpWpHR9Ww0JzZqsACktXzsm9r8=k6e7CJF_9+5cWdJBQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org" <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org" <criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, "lucas.demarchi-Y3ZbgMPKUGA34EUeqzHoZw@public.gmane.org" <lucas.demarchi-Y3ZbgMPKUGA34EUeqzHoZw@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cmetcalf-kv+TWInifGbQT0dZR+AlfA@public.gmane.org" <cmetcalf-kv+TWInifGbQT0dZR+AlfA@public.gmane.org>, "dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

05.04.2012 03:50, Michael Kerrisk (man-pages) =D0=BF=D0=B8=D1=88=D0=B5=D1=
=82:
> On Thu, Apr 5, 2012 at 11:12 AM, Andrew Morton
> <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>  wrote:
>> On Wed, 15 Feb 2012 20:54:39 +0400
>> Stanislav Kinsbursky<skinsbursky-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>  wrote:
>
> Stanislav,
>
> Luckily, Andrew added me to CC. However, as noted in
> Documentation/SubmitChecklist, all patches that change the ABI/API
> should CC linux-api-u79uwXL29TaiAVqoAR/hOA@public.gmane.org Please do that for the future.
> (CC added for this thread.)
>

Yep, sure. Next time I'll do that. Sorry.

>>> v2:
>>> 1) compat functions added.
>>> 2) message slot size in array is now aligned by struct msgbuf_a.
>>> 3) check for enough free space in buffer before message copying add=
ed.
>>> 4) if MSG_STEAL flag is set, then do_msgrcv() returns number of byt=
es written
>>> to buffer.
>
> By the way, why the name "MSG_STEAL"? At first glance, it sounds like
> that means we're taking messages that belong to someone else. But I
> gather you are in fact just flushing all messages from a queue. So I
> more intuitive name seems to be in order (MSG_READ_ALL,
> MSG_FLUSH_ALL?).
>

Nice to know, that it sounds to you exactly like it is desired to. I.e.=
 this=20
flag was designed to take messages that belong to someone else without =
any=20
trace, visible to the owner of the messages.
But (like you mentioned in following letter) MSG_PEEK_ALL sound better =
to me.=20
Thus I'll replace MSG_STEAL with MSG_PEEK_ALL, if you don't mind.

>>> 5) flag MSG_NOERROR is ignored if MSG_STEAL flag is set.
>
> Would it not be better to return an error if MSG_NOERROR is specified=
?
>

I don't think so. IOW, error can be returned in this case, but I don't =
see any=20
practical reason for this. If you do - please share.

>>> This patch is required for checkpoint/restore in userspace.
>>> IOW, c/r requires some way to get all pending IPC messages without =
deleting
>>> them for the queue (checkpoint can fail and in this case tasks will=
 be resumed,
>>> so queue have to be valid).
>>> To achive this, new operation flag MSG_STEAL for sys_msgrcv() syste=
m call
>>> introduced.
>>> If this flag is set, then passed struct msgbuf pointer will be used=
 for storing
>>> array of structures:
>>>
>>> struct msgbuf_a {
>>>        long mtype;         /* type of message */
>>>        int msize;          /* size of message */
>>>        char mtext[0];      /* message text */
>>> };
>
> So, I'm not clear on how things look here. We get back array like thi=
s:
>
> [0]                     [1]                     [2]
> | mtype | msize | mtext | mtype | msize | mtext | ...
>
> How do I calculate the offset of element 1 of the array? I assume it
> can't be just
> (&item[0].mtext + msize), since there'll be alignment issues to deal
> with, so that there are padding bytes after each mtext. In that case,
> msize on its own seems insufficient (since there is no null-terminato=
r
> in msize).
>

This is easy. You can be sure, that struct msgbuf_a is aligned by sizeo=
f(struct=20
msgbuf_a). And since you know the size of this structure and length of =
data=20
segment, then offset of any element of the queue can be calculated like=
 this:

addr_N+1 =3D addr_N +
round_up(sizeof(struct msgbuf_a) + msize, sizeof(struct msgbuf_a));

>>> each of which will be followed by corresponding message data.
>>>
>>
>> I'd be a bit more comfortable if there was some sign that other c/r
>> developers have reviewed and tested this and have successfully used =
it
>> in c/r operation testing?
>
> Indeed, do you have a userspace test program that you could post?
>

Yes, sure. I'll add it to the patch set.
But please not, that this test (in it's current state) can be executed =
only as a=20
part of out CRIU test suit.
So you won't be able to execute it as is.

>> We've been trying to isolate the c/r-specific functions inside #ifde=
f
>> CONFIG_CHECKPOINT_RESTORE, but this patch doesn't do that.  I have b=
een
>> encouraging this isolation so that people who aren't using c/r don't
>> have to carry the overhead it adds and so that we can more easily hu=
nt
>> down and remove everything if the entire c/r project doesn't work ou=
t
>> successfully.
>>
>> This patch modifies the sys_msgrcv() API and so we should update the
>> manpage for that syscall.  Please work with Michael on this.
>
> Yes please.
>

Sure. What do you want me to do?

--=20
Best regards,
Stanislav Kinsbursky
