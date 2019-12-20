From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH 1/2] uapi: split openat2(2) definitions from fcntl.h
Date: Fri, 20 Dec 2019 10:18:23 +0000
Message-ID: <85251686ad074be18db926f903497a45@AcuMS.aculab.com>
References: <20191219105533.12508-1-cyphar@cyphar.com>
 <20191219105533.12508-2-cyphar@cyphar.com>
 <87a77oy3oe.fsf@oldenburg2.str.redhat.com>
 <20191219134525.mgzmjbsp4wo5b2bw@yavin.dot.cyphar.com>
 <845fc9e8b55e4868bb4d20655e674b50@AcuMS.aculab.com>
 <20191220093153.v7jpzvch3lohabll@yavin.dot.cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191220093153.v7jpzvch3lohabll@yavin.dot.cyphar.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: 'Aleksa Sarai' <cyphar@cyphar.com>
Cc: Florian Weimer <fweimer@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Shuah Khan <shuah@kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, "dev@opencontainers.org" <dev@opencontainers.org>, "containers@lists.linux-foundation.org" <containers@lists.linux-foundation.org>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

From: Aleksa Sarai
> Sent: 20 December 2019 09:32
...
> > I'm guessing that is just 64bit aligned on 32bit archs like x86?
> 
> Yeah,
> 
> #define __aligned_u64 __u64 __attribute__((aligned(8)))
> 
> > No need to enforce it provided the structure will have no padding on
> > archs where the 64bit fields are 64bit aligned. A plain __u64 should
> > be fine.
> 
> Will this cause problems for x86-on-x86_64 emulation? Requiring an
> 8-byte alignment for 'struct open_how' really isn't that undue of a
> burden IMHO. Then again, clone3 is a bit of an outlier since both
> perf_event_open and sched_setattr just use __u64s.

Makes diddly-squit difference.
The 64bit kernel will 64bit align the structure.
The kernel must allow for the userspace structure having arbitrary alignment.
So there is no reason to (try to) align the user structure.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
