From: Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [patch/rfc] eventfd semaphore-like behavior
Date: Mon, 30 Aug 2010 07:22:57 -0700 (PDT)
Message-ID: <alpine.OSX.2.00.1008300721400.175@Macintosh-3.local>
References: <alpine.DEB.1.10.0902041349180.6214@alien.or.mcafeemobile.com> <20090204150507.665b5b7c.akpm@linux-foundation.org> <alpine.DEB.1.10.0902041509060.6214@alien.or.mcafeemobile.com> <20090204152434.c8f65d52.akpm@linux-foundation.org>
 <alpine.DEB.1.10.0902041526590.6214@alien.or.mcafeemobile.com> <20090204155514.6abbdc8f.akpm@linux-foundation.org> <cfd18e0f0902041559l4c40d9b6k704068337a00df7a@mail.gmail.com> <alpine.DEB.1.10.0902041600170.6214@alien.or.mcafeemobile.com>
 <AANLkTim_seWr0LZJyC+dPBy-N+_NkzTx21vte7qrwunC@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-561423044-1283178184=:175"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTim_seWr0LZJyC+dPBy-N+_NkzTx21vte7qrwunC@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-561423044-1283178184=:175
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Mon, 30 Aug 2010, Michael Kerrisk wrote:

> On Thu, Feb 5, 2009 at 2:02 AM, Davide Libenzi <davidel@xmailserver.org> wrote:
> > On Thu, 5 Feb 2009, Michael Kerrisk wrote:
> >
> >> > Dunno.  Probably try the syscall and see if it returned -EINVAL.  Does
> >> > that work in this case?
> >>
> >> As youll have seen by now, Ulrich and I noted that it works.
> >>
> >> > If so, it would be sensible to mention this in
> >> > the description somewhere as the approved probing method and to
> >> > maintain it.
> >>
> >> I'll add something to the man page, as this patch progresses.
> >
> > I see we already have stuff like this inside the man pages:
> >
> > O_CLOEXEC (Since Linux 2.6.23)
> >          Enable the close-on-exec flag for the new file descriptor.
> >          ...
> >
> > Maybe a similar note for the new flag?
> 
> It took a while, but here's the new text in the eventfd.2 (will be in
> man-pages-2.36). Could you please ACK, Davide?
> 
>        EFD_SEMAPHORE (since Linux 2.6.30)
>               Provide semaphore-like semantics  for  reads  from
>               the new file descriptor.  See below.
> ...
>               *  If EFD_SEMAPHORE  was  not  specified  and  the
>                  eventfd  counter  has  a  nonzero value, then a
>                  read(2) returns 8 bytes containing that  value,
>                  and the counter's value is reset to zero.
> 
>               *  If  EFD_SEMAPHORE was specified and the eventfd
>                  counter has a nonzero  value,  then  a  read(2)
>                  returns 8 bytes containing the value 1, and the
>                  counter's value is decremented by 1.

Looks fine to me.


- Davide

--0-561423044-1283178184=:175--
