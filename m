From: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch/rfc] eventfd semaphore-like behavior
Date: Mon, 30 Aug 2010 07:21:05 +0200
Message-ID: <AANLkTim_seWr0LZJyC+dPBy-N+_NkzTx21vte7qrwunC@mail.gmail.com>
References: <alpine.DEB.1.10.0902041349180.6214@alien.or.mcafeemobile.com>
 <20090204150507.665b5b7c.akpm@linux-foundation.org> <alpine.DEB.1.10.0902041509060.6214@alien.or.mcafeemobile.com>
 <20090204152434.c8f65d52.akpm@linux-foundation.org> <alpine.DEB.1.10.0902041526590.6214@alien.or.mcafeemobile.com>
 <20090204155514.6abbdc8f.akpm@linux-foundation.org> <cfd18e0f0902041559l4c40d9b6k704068337a00df7a@mail.gmail.com>
 <alpine.DEB.1.10.0902041600170.6214@alien.or.mcafeemobile.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.1.10.0902041600170.6214-GPJ85BhbkB8RepQJljzAVbITYcZ0+W3JAL8bYrjMMd8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Feb 5, 2009 at 2:02 AM, Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org=
> wrote:
> On Thu, 5 Feb 2009, Michael Kerrisk wrote:
>
>> > Dunno. =A0Probably try the syscall and see if it returned -EINVAL.=
 =A0Does
>> > that work in this case?
>>
>> As youll have seen by now, Ulrich and I noted that it works.
>>
>> > If so, it would be sensible to mention this in
>> > the description somewhere as the approved probing method and to
>> > maintain it.
>>
>> I'll add something to the man page, as this patch progresses.
>
> I see we already have stuff like this inside the man pages:
>
> O_CLOEXEC (Since Linux 2.6.23)
> =A0 =A0 =A0 =A0 =A0Enable the close-on-exec flag for the new file des=
criptor.
> =A0 =A0 =A0 =A0 =A0...
>
> Maybe a similar note for the new flag?

It took a while, but here's the new text in the eventfd.2 (will be in
man-pages-2.36). Could you please ACK, Davide?

       EFD_SEMAPHORE (since Linux 2.6.30)
              Provide semaphore-like semantics  for  reads  from
              the new file descriptor.  See below.
=2E..
              *  If EFD_SEMAPHORE  was  not  specified  and  the
                 eventfd  counter  has  a  nonzero value, then a
                 read(2) returns 8 bytes containing that  value,
                 and the counter's value is reset to zero.

              *  If  EFD_SEMAPHORE was specified and the eventfd
                 counter has a nonzero  value,  then  a  read(2)
                 returns 8 bytes containing the value 1, and the
                 counter's value is decremented by 1.

Thanks,

Michael

--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
