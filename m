From: Florian Weimer <fw@deneb.enyo.de>
Subject: Re: RFC: reject unknown open flags
Date: Thu, 30 Mar 2017 21:22:29 +0200
Message-ID: <87tw6atvre.fsf@mid.deneb.enyo.de>
References: <20170330163327.23920-1-hch@lst.de>
	<CA+55aFw92r4h4sNW41ifs31ixdZpNmaxY23KthB9R-LXNm7p-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <libc-alpha-return-78337-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <CA+55aFw92r4h4sNW41ifs31ixdZpNmaxY23KthB9R-LXNm7p-w@mail.gmail.com>
	(Linus Torvalds's message of "Thu, 30 Mar 2017 10:08:10 -0700")
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>, Alexander Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, libc-alpha <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

* Linus Torvalds:

> But probing for flags is why we *could* add things like O_NOATIME etc
> - exactly because it "just worked" with old kernels, and people could
> just use the new flags knowing that it was a no-op on old kernels.

Right, it mostly works for the flags we added.

> The whole concept of "probing for supported features" is very suspect.
> It's a bad bad idea. Don't do it.

It's vastly preferable to hard-coding kernel version dependencies in
source or object code.  Particularly if you want to move applications
between different kernel versions (which seems to be all the rage
right now).

The problem with probing for flags is that it's kind of hard to see
which flag causes the failure.  Maybe application code could
retroactively apply it with fcntl.  This is what we did when there was
no support for O_CLOEXEC, but this was easy because there has been
FD_CLOEXEC in fcntl since basically forever.

> What kind of new flag did you even have in mind that would have such
> broken semantics that it would completely change the other flags?

I think we had to go through some gymnastics to get the desired
behavior for O_TMPFILE and O_PATH.

There's another consideration.  open/openat flags are very special in
one regard: glibc tries to implement the system call wrapper in
standard C, with proper <stdarg.h> processing.  This means that the
wrapper has to determine whether there is a mode argument or not, and
avoid the va_arg call if it is missing.  Consequently, we parse the
flag argument to see if it implies the need for a mode.  This broke
with O_TMPFILE.

We don't do that for fcntl, which has exactly the same issue because
F_GETFD has an empty variable argument list.  We just call va_arg
beyond the end of the argument list in the F_GETFD case.  We don't
check the command argument and use it to adjust the number of va_arg
calls.  We should do the same for open/openat because it obviously
works for all architectures we care about in the fcntl case.  (This is
independent if there is going to be another system call with different
semantics for handling unknown flags.)
