From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Subject: Re: [PATCH -v4] random: introduce getrandom(2) system call
Date: Wed, 30 Jul 2014 16:40:52 +0200
Message-ID: <1406731254.26034.4.camel@thorin>
References: <1405718127-30042-1-git-send-email-tytso@mit.edu>
	 <20140730122620.GC13965@amd.pavel.ucw.cz>
	 <CAComcpMnAdOk=Hs8Dtc7VZeJDHnpKQtzZ_=_67tqCeYU3pdJ_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAComcpMnAdOk=Hs8Dtc7VZeJDHnpKQtzZ_=_67tqCeYU3pdJ_Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bob Beck <beck@openbsd.org>
Cc: Pavel Machek <pavel@ucw.cz>, Theodore Ts'o <tytso@mit.edu>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, linux-crypto <linux-crypto@vger.kernel.org>, Theo de Raadt <deraadt@cvs.openbsd.org>
List-Id: linux-api@vger.kernel.org

On Mit, 2014-07-30 at 07:56 -0600, Bob Beck wrote:
> Pavel. I have bit 'ol enterprise daemon running with established file
> descriptors serving thousands of connections
> which periodically require entropy.  Now I run out of descriptors. I
> can't establish new connections. but I should
> now halt all the other ones that require entropy?  I should raise
> SIGKILL on my process serving these thousands
> of connetions?  I don't think so.

If that long-running daemon periodically needs something from a device,
one would better keep the fd for that open the whole time. Saves some
CPU cycles and latency too BTW.

	Bernd
-- 
"I dislike type abstraction if it has no real reason. And saving
on typing is not a good reason - if your typing speed is the main
issue when you're coding, you're doing something seriously wrong."
    - Linus Torvalds
