From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH] signal: remove the wrong signal_pending() check in
 restore_user_sigmask()
Date: Tue, 4 Jun 2019 15:57:41 +0000
Message-ID: <3b68788ea9114d08bdfdab575c8c29bb@AcuMS.aculab.com>
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
	<20190529161157.GA27659@redhat.com>	<20190604134117.GA29963@redhat.com>
 <87tvd5nz8i.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <87tvd5nz8i.fsf@xmission.com>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: "'Eric W. Biederman'" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Deepa Dinamani <deepa.kernel@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "arnd@arndb.de" <arnd@arndb.de>, "dbueso@suse.de" <dbueso@suse.de>, "axboe@kernel.dk" <axboe@kernel.dk>, "dave@stgolabs.net" <dave@stgolabs.net>, "e@80x24.org" <e@80x24.org>, "jbaron@akamai.com" <jbaron@akamai.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-aio@kvack.org" <linux-aio@kvack.org>, "omar.kilani@gmail.com" <omar.kilani@gmail.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "stable@vger.kernel.org" <stable@vger.kernel.org>, Al
 Viro <viro@ZenIV.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

From: Eric W. Biederman
> Sent: 04 June 2019 16:32
...
> Michael is there any chance we can get this guarantee of the linux
> implementation of pselect and friends clearly documented.  The guarantee
> that if the system call completes successfully we are guaranteed that
> no signal that is unblocked by using sigmask will be delivered?

The behaviour certainly needs documenting - the ToG docs are unclear.
I think you need stronger statement that the one above.

Maybe "signals will only be delivered (ie the handler called) if
the system call has to wait and the wait is interrupted by a signal.
(Even then pselect might find ready fd and return success.)

There is also the 'issue' of ERESTARTNOHAND.
Some of the system calls will return EINTR if the wait is interrupted
by a signal that doesn't have a handler, others get restarted.
I'm not at all sure about why there is a difference.

=09David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
