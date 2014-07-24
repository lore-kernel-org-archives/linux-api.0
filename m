From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH -v5] random: introduce getrandom(2) system call
Date: Thu, 24 Jul 2014 17:30:19 -0300
Message-ID: <20140724203019.GA20737@khazad-dum.debian.net>
References: <1406212287-9855-1-git-send-email-tytso@mit.edu>
 <20140724151814.GE32421@khazad-dum.debian.net>
 <CALCETrXAA=UzS-pRCo5tKSjSCOP9xfu66BG9QbRefVrovkavhQ@mail.gmail.com>
 <20140724190206.GL6673@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140724190206.GL6673@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, Andy Lutomirski <luto@amacapital.net>, Linux Kernel Developers List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-crypto@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, 24 Jul 2014, Theodore Ts'o wrote:
> On Thu, Jul 24, 2014 at 08:21:38AM -0700, Andy Lutomirski wrote:
> > > Should we add E<SOMETHING> to be able to deny access to GRND_RANDOM or some
> > > future extension ?
> > 
> > This might actually be needed sooner rather than later.  There are
> > programs that use containers and intentionally don't pass /dev/random
> > through into the container.  I know that Sandstorm does this, and I
> > wouldn't be surprised if other things (Docker?) do the same thing.
> 
> I wouldn't add the error to the man page until we actually modify the
> kernel to add such a restriction.

By then, it might be too late.  It would be really sad to find ourselves
forced to return ENOSYS to getrandom(GRND_RANDOM) when we actually wanted to
return EPERM/EACCES.

Actually, we might not be able to do even that much: all it takes is for
someone to have the bright idea of deploying userspace code that checks for
ENOSYS only on a first "probe" getrandom() syscall without GRND_RANDOM, and
does something idiotic when it gets ENOSYS later on a
getrandom(GRND_RANDOM).  meh.  We can't even abuse the system ourselves :-)

> However, the thought crossed my mind a while back that perhaps the
> right answer is a cgroup controller which controls the rate at which a
> process is allowed to drain entropy from the /dev/random pool.  This
> could be set to 0, or it could be set to N bits per unit time T, and
> if the process exceeded the value, it would just block or return
> EAGAIN.  So instead of making it be just a binary "you have access" or

That will teach people to not have a SIGALRM on code that calls a blocking
syscall, I suppose.  Still, there is a risk it could cause so much bad
application behaviour to the point of being unusable.

> Then I decided that it was overkill, but for people who are trying to

Indeed :p

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
