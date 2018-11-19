From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH] proc: allow killing processes via file descriptors
Date: Mon, 19 Nov 2018 14:15:31 +0000
Message-ID: <9a269517770e4881b92756d47f17a5fd@AcuMS.aculab.com>
References: <20181118111751.6142-1-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181118111751.6142-1-christian@brauner.io>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: 'Christian Brauner' <christian@brauner.io>, "ebiederm@xmission.com" <ebiederm@xmission.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "serge@hallyn.com" <serge@hallyn.com>, "jannh@google.com" <jannh@google.com>, "luto@kernel.org" <luto@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "oleg@redhat.com" <oleg@redhat.com>, "cyphar@cyphar.com" <cyphar@cyphar.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "dancol@google.com" <dancol@google.com>, "timmurray@google.com" <timmurray@google.com>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

From: > Christian Brauner
> Sent: 18 November 2018 11:18
> 
> With this patch an open() call on /proc/<pid> will give userspace a handle
> to struct pid of the process associated with /proc/<pid>. This allows to
> maintain a stable handle on a process.

My 3c...

You need to add a version of fork() that returns an open fd to
/proc/pid to the parent.

Is it possible to overload fcntl() rather than ioctl() ?

More interestingly what about a 'unique pid' (eg the pid extended to
(say) 128 bits with a use count) that can be safely put into a /var/run/pid
file for a daemon and used later in a 'kill' that will only ever
reference the correct process.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
