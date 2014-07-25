From: Henrique de Moraes Holschuh <hmh-N3TV7GIv+o9fyO9Q7EP/yw@public.gmane.org>
Subject: Re: [PATCH -v5] random: introduce getrandom(2) system call
Date: Fri, 25 Jul 2014 09:46:01 -0300
Message-ID: <20140725124601.GB401@khazad-dum.debian.net>
References: <1406212287-9855-1-git-send-email-tytso@mit.edu>
 <20140724151814.GE32421@khazad-dum.debian.net>
 <CALCETrXAA=UzS-pRCo5tKSjSCOP9xfu66BG9QbRefVrovkavhQ@mail.gmail.com>
 <20140724190206.GL6673@thunk.org>
 <20140724203019.GA20737@khazad-dum.debian.net>
 <20140724232434.GN6673@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140724232434.GN6673-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux Kernel Developers List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 24 Jul 2014, Theodore Ts'o wrote:
> On Thu, Jul 24, 2014 at 05:30:19PM -0300, Henrique de Moraes Holschuh wrote:
> > > I wouldn't add the error to the man page until we actually modify the
> > > kernel to add such a restriction.
> > 
> > By then, it might be too late.  It would be really sad to find ourselves
> > forced to return ENOSYS to getrandom(GRND_RANDOM) when we actually wanted to
> > return EPERM/EACCES.
> 
> I wouldn't worry about.  The reality is that anyone using GRND_RANDOM
> has to be checking for error codes anyway, and if they do something

...

> In general, all system calls can return errno's other than the ones
> documented in the man page.  This is certainly true for open(2), and
> read(2) if you are using a network file system such as NFS.  Someone

A few manpages might actually have warnings to that effect, but it is not
the rule.  Amusingly enough, the one for read(2) does, while open(2) does
not.

IMHO the getrandom(2) case is slightly different: we already know to a high
degree of confidence that we will want to convey a "permission denied"
condition to userspace for getrandom(GRND_RANDOM) sooner or later.

I'd be fine with text that mentions that GRND_RANDOM access by a process
may be restricted/rejected by system policy in the future, so code should
not assume any error return code from getrandom(GRND_RANDOM) would also
apply to getrandom() without GRND_RANDOM, and must degrade gracefully and
safely in that case.

> I don't think it's necessary to add a sentence that other errors can
> be returned in the future, and users much check for other errors, but
> if you really think people are that stupid that we need to say
> something which is true for every single system call in Linux, we can
> do that....

Well, I feel we could go a bit further than usual for getrandom(2), but
I've already stated my case.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
