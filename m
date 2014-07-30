From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH -v4] random: introduce getrandom(2) system call
Date: Thu, 31 Jul 2014 00:18:19 +0200
Message-ID: <20140730221819.GB18189@amd.pavel.ucw.cz>
References: <1405718127-30042-1-git-send-email-tytso@mit.edu>
 <20140730122620.GC13965@amd.pavel.ucw.cz>
 <CAComcpMnAdOk=Hs8Dtc7VZeJDHnpKQtzZ_=_67tqCeYU3pdJ_Q@mail.gmail.com>
 <1406731254.26034.4.camel@thorin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1406731254.26034.4.camel@thorin>
Sender: linux-crypto-owner@vger.kernel.org
To: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Cc: Bob Beck <beck@openbsd.org>, Theodore Ts'o <tytso@mit.edu>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, linux-crypto <linux-crypto@vger.kernel.org>, Theo de Raadt <deraadt@cvs.openbsd.org>
List-Id: linux-api@vger.kernel.org

On Wed 2014-07-30 16:40:52, Bernd Petrovitsch wrote:
> On Mit, 2014-07-30 at 07:56 -0600, Bob Beck wrote:
> > Pavel. I have bit 'ol enterprise daemon running with established file
> > descriptors serving thousands of connections
> > which periodically require entropy.  Now I run out of descriptors. I
> > can't establish new connections. but I should
> > now halt all the other ones that require entropy?  I should raise
> > SIGKILL on my process serving these thousands
> > of connetions?  I don't think so.
> 
> If that long-running daemon periodically needs something from a device,
> one would better keep the fd for that open the whole time. Saves some
> CPU cycles and latency too BTW.

Agreed.

On the other hand, keeping a fd open is quite tricky for a
library. But better solution might be to make that easier.

open( , O_IM_A_LIBRARY_GIVE_ME_ONE_OF_THREE_RESERVED_FDS) might be one
solution. Actually, one reserved fd should be enough.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
