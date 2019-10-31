From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH] clone3: validate stack arguments
Date: Thu, 31 Oct 2019 11:41:06 +0000
Message-ID: <c600032527d24cf2a7dfd8a81467fd6f@AcuMS.aculab.com>
References: <20191031113608.20713-1-christian.brauner@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20191031113608.20713-1-christian.brauner@ubuntu.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: 'Christian Brauner' <christian.brauner@ubuntu.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Florian Weimer <fweimer@redhat.com>, GNU C Library <libc-alpha@sourceware.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

From: Christian Brauner
> Sent: 31 October 2019 11:36
...
> /* Intentional user visible API change */
> clone3() was released with 5.3. Currently, it is not documented and very
> unclear to userspace how the stack and stack_size argument have to be
> passed. After talking to glibc folks we concluded that trying to change
> clone3() to setup the stack instead of requiring userspace to do this is
> the right course of action.

What happens if someone 'accidentally' runs a program compiled for
the new API on a system running the existing 5.3 kernel?

While it won't work, it needs to die reasonably gracefully.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
