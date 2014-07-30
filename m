From: Bob Beck <beck@openbsd.org>
Subject: Re: [PATCH -v4] random: introduce getrandom(2) system call
Date: Wed, 30 Jul 2014 07:56:49 -0600
Message-ID: <CAComcpMnAdOk=Hs8Dtc7VZeJDHnpKQtzZ_=_67tqCeYU3pdJ_Q@mail.gmail.com>
References: <1405718127-30042-1-git-send-email-tytso@mit.edu> <20140730122620.GC13965@amd.pavel.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20140730122620.GC13965@amd.pavel.ucw.cz>
Sender: linux-crypto-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: Theodore Ts'o <tytso@mit.edu>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, linux-crypto <linux-crypto@vger.kernel.org>, Theo de Raadt <deraadt@cvs.openbsd.org>
List-Id: linux-api@vger.kernel.org

Pavel. I have bit 'ol enterprise daemon running with established file
descriptors serving thousands of connections
which periodically require entropy.  Now I run out of descriptors. I
can't establish new connections. but I should
now halt all the other ones that require entropy?  I should raise
SIGKILL on my process serving these thousands
of connetions?  I don't think so.



On Wed, Jul 30, 2014 at 6:26 AM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> The rationale of this system call is to provide resiliance against
>> file descriptor exhaustion attacks, where the attacker consumes all
>> available file descriptors, forcing the use of the fallback code where
>> /dev/[u]random is not available.  Since the fallback code is often not
>> well-tested, it is better to eliminate this potential failure mode
>> entirely.
>
> I'm not sure I understand the rationale; if someone can eat all your
> file descriptors, he can make you stop working. So you can just stop
> working when you can't open /dev/urandom, no?
>
> Fallback code is probably very bad idea to use...
>
>> The other feature provided by this new system call is the ability to
>> request randomness from the /dev/urandom entropy pool, but to block
>> until at least 128 bits of entropy has been accumulated in the
>> /dev/urandom entropy pool.  Historically, the emphasis in the
>> /dev/urandom development has been to ensure that urandom pool is
>> initialized as quickly as possible after system boot, and preferably
>> before the init scripts start execution.
>
> Sounds like ioctl() for /dev/urandom for this behaviour would be nice?
>
>                                                                         Pavel
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
