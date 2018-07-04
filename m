From: Adrian Reber <adrian@lisas.de>
Subject: Re: [PATCH 7/7] aio: implement io_pgetevents
Date: Wed, 4 Jul 2018 16:21:16 +0200
Message-ID: <20180704142116.GM17048@lisas.de>
References: <20180502211448.18276-1-hch@lst.de>
 <20180502211448.18276-8-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180502211448.18276-8-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, May 02, 2018 at 11:14:48PM +0200, Christoph Hellwig wrote:
> This is the io_getevents equivalent of ppoll/pselect and allows to
> properly mix signals and aio completions (especially with IOCB_CMD_POLL)
> and atomically executes the following sequence:
> 
> 	sigset_t origmask;
> 
> 	pthread_sigmask(SIG_SETMASK, &sigmask, &origmask);
> 	ret = io_getevents(ctx, min_nr, nr, events, timeout);
> 	pthread_sigmask(SIG_SETMASK, &origmask, NULL);
> 
> Note that unlike many other signal related calls we do not pass a sigmask
> size, as that would get us to 7 arguments, which aren't easily supported
> by the syscall infrastructure.  It seems a lot less painful to just add a
> new syscall variant in the unlikely case we're going to increase the
> sigset size.

Starting with this commit following code does not compile for me
anymore:

#include <signal.h>
#include <linux/aio_abi.h>

int main()
{
        return 0;
}

In file included from /usr/include/linux/signal.h:5,
                 from /usr/include/linux/aio_abi.h:32,
                 from include.c:2:
/usr/include/asm/signal.h:16:23: error: conflicting types for ‘sigset_t’
 typedef unsigned long sigset_t;
                       ^~~~~~~~
In file included from /usr/include/signal.h:35,
                 from include.c:1:
/usr/include/bits/types/sigset_t.h:7:20: note: previous declaration of ‘sigset_t’ was here
 typedef __sigset_t sigset_t;
                    ^~~~~~~~
In file included from /usr/include/linux/signal.h:5,
                 from /usr/include/linux/aio_abi.h:32,
                 from include.c:2:
/usr/include/asm/signal.h:115:8: error: redefinition of ‘struct sigaction’
 struct sigaction {
        ^~~~~~~~~
In file included from /usr/include/signal.h:226,
                 from include.c:1:
/usr/include/bits/sigaction.h:27:8: note: originally defined here
 struct sigaction
        ^~~~~~~~~
[and much more]

Before this commit it compiles without errors.

		Adrian

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
