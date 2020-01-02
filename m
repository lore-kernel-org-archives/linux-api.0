From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH RFC 0/1] mount: universally disallow mounting over
 symlinks
Date: Thu, 2 Jan 2020 08:58:09 +0000
Message-ID: <e1066da936244de99e7ee827695d6583@AcuMS.aculab.com>
References: <20191230052036.8765-1-cyphar@cyphar.com>
 <20191230054413.GX4203@ZenIV.linux.org.uk>
 <20191230054913.c5avdjqbygtur2l7@yavin.dot.cyphar.com>
 <20191230072959.62kcojxpthhdwmfa@yavin.dot.cyphar.com>
 <CAHk-=whxNw7hYT6bJn9mVrB_a=7Y-irmpaPsp1R4xbHHkicv7g@mail.gmail.com>
 <20191230083224.sbk2jspqmup43obs@yavin.dot.cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191230083224.sbk2jspqmup43obs@yavin.dot.cyphar.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: 'Aleksa Sarai' <cyphar@cyphar.com>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>, Eric Biederman <ebiederm@xmission.com>, stable <stable@vger.kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, Serge Hallyn <serge@hallyn.com>, "dev@opencontainers.org" <dev@opencontainers.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

From: Aleksa Sarai
> Sent: 30 December 2019 08:32
...
> I'm not sure I agree -- as I mentioned in my other mail, re-opening
> through /proc/self/fd/$n works *very* well and has for a long time (in
> fact, both LXC and runc depend on this working).

I thought it was marginally broken because it is followed as a symlink?
On, for example, NetBSD /proc/<n>/fd/<n> is a real reference to the
filesystem inode and can be used to link the file back into the filesystem
if all the directory entries have been removed.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
