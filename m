From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Subject: Re: [PATCH -v4] random: introduce getrandom(2) system call
Date: Thu, 31 Jul 2014 10:06:37 +0200
Message-ID: <1406794012.26034.14.camel@thorin>
References: <1405718127-30042-1-git-send-email-tytso@mit.edu>
	 <20140730122620.GC13965@amd.pavel.ucw.cz>
	 <CAComcpMnAdOk=Hs8Dtc7VZeJDHnpKQtzZ_=_67tqCeYU3pdJ_Q@mail.gmail.com>
	 <1406731254.26034.4.camel@thorin> <20140730221819.GB18189@amd.pavel.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20140730221819.GB18189@amd.pavel.ucw.cz>
Sender: linux-crypto-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: Bob Beck <beck@openbsd.org>, Theodore Ts'o <tytso@mit.edu>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, linux-crypto <linux-crypto@vger.kernel.org>, Theo de Raadt <deraadt@cvs.openbsd.org>
List-Id: linux-api@vger.kernel.org

On Don, 2014-07-31 at 00:18 +0200, Pavel Machek wrote:
> On Wed 2014-07-30 16:40:52, Bernd Petrovitsch wrote:
> > On Mit, 2014-07-30 at 07:56 -0600, Bob Beck wrote:
> > > Pavel. I have bit 'ol enterprise daemon running with established file
> > > descriptors serving thousands of connections
> > > which periodically require entropy.  Now I run out of descriptors. I
> > > can't establish new connections. but I should
> > > now halt all the other ones that require entropy?  I should raise
> > > SIGKILL on my process serving these thousands
> > > of connetions?  I don't think so.
> > 
> > If that long-running daemon periodically needs something from a device,
> > one would better keep the fd for that open the whole time. Saves some
> > CPU cycles and latency too BTW.
> 
> Agreed.
> 
> On the other hand, keeping a fd open is quite tricky for a
> library. But better solution might be to make that easier.

Yes, in a (full-fledged, standalone) library seems at least tricky (also
referring to some off-list mails here: think about fork() - which could
be inside system() or popen() or similar). 

But as part of the *application* (where one has control over fork()
etc.), this should be somewhat less risky. Yes, that doesn't really help
libssl;-)

Hehe, we (Unix!) have (had) gettimeofday(), time() and similar sys-calls
since ages and no one proposed to make devices for them and get rid of
the system-calls.

> open( , O_IM_A_LIBRARY_GIVE_ME_ONE_OF_THREE_RESERVED_FDS) might be one
> solution. Actually, one reserved fd should be enough.

Well, this can also be DoSed and the proposal aims to make that
impossible (and where does this reserved count against? process-limits,
kernel-wide limit?).

	Bernd
-- 
"I dislike type abstraction if it has no real reason. And saving
on typing is not a good reason - if your typing speed is the main
issue when you're coding, you're doing something seriously wrong."
    - Linus Torvalds
