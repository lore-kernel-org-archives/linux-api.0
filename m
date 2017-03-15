From: Carlos O'Donell <carlos@redhat.com>
Subject: Re: select fails to verify all file descriptors are valid
Date: Wed, 15 Mar 2017 01:34:44 -0400
Message-ID: <4859e5e8-4cc1-626c-3294-e5f529fe41d3@redhat.com>
References: <20170314161138.GC4033@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170314161138.GC4033@bombadil.infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>
Cc: linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 03/14/2017 12:11 PM, Matthew Wilcox wrote:

Hello Matthew :-)
 
> Quoting the manpage:
> 
>        int select(int nfds, fd_set *readfds, fd_set *writefds,
>                   fd_set *exceptfds, struct timeval *timeout);
> 
>        nfds  is the highest-numbered file descriptor in any of the three sets,
>        plus 1.

OK.

>        EBADF  An  invalid file descriptor was given in one of the sets.  (Per‐
>               haps a file descriptor that was already closed, or one on  which
>               an error has occurred.)
> 
> That's not quite how Linux behaves.  We only check the fd_set up to the
> maximum number of fds allocated to this task:
> 
>         rcu_read_lock();
>         fdt = files_fdtable(current->files);
>         max_fds = fdt->max_fds;
>         rcu_read_unlock();
>         if (n > max_fds)
>                 n = max_fds;
> 
> (then we copy in up to 'n' bits worth of bitmaps).

Right, and that doesn't match the POSIX requirement either.

http://pubs.opengroup.org/onlinepubs/9699919799/functions/pselect.html
~~~
The nfds argument specifies the range of descriptors to be tested. 
The first nfds descriptors shall be checked in each set; that is, 
the descriptors from zero through nfds-1 in the descriptor sets 
shall be examined.
~~~

That is to say you should "test" `nfds - 1` descriptors, potentially
returning EBADF for invalid descriptors, not some random number that
depends on how many you have open right now.

> It is pretty straightforward to demonstrate that Linux doesn't check:
> 
> int main(void)
> {
> 	int ret;
> 	struct timeval tv = { };
> 	fd_set fds;
> 	FD_ZERO(&fds);
> 	FD_SETFD(FD_SETSIZE - 1, &fds);
> 	ret = select(FD_SETSIZE, &fds, NULL, NULL, &tv);
> 	assert(ret == -1 && errno == EBADF);
> 	return 0;
> }

And one that compiles and works...

cat >> select-verify.c <<EOF
#include <stdio.h>
#include <stdlib.h>
#include <sys/select.h>
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>
#include <assert.h>
#include <errno.h>

int 
main(void)
{
  int ret;
  struct timeval tv = {0, 0};
  fd_set fds;
  FD_ZERO(&fds);
  FD_SET(FD_SETSIZE - 1, &fds);
  ret = select(FD_SETSIZE, &fds, NULL, NULL, &tv);
  assert(ret == -1 && errno == EBADF);
  return 0;
}
EOF
gcc -O0 -g3 -Wall -pedantic -o ./select-verify ./select-verify.c
./select-verify 
select-verify: ./select-verify.c:19: main: Assertion `ret == -1 && errno == EBADF' failed.
Aborted (core dumped)

> Linux has behaved this way since 2.6.12, and I can't be bothered to get
> out the historical git trees to find out what happened before 2005.
> 
> So ... if I change this behaviour by checking all the file descriptors, I
> do stand a chance of breaking an application.  On the other hand, that
> application could already have been broken by the shell deciding to open
> a really high file descriptor (I'm looking at you, bash), which the program
> then inherits.

The user application would have to:

(a) Use a sloppy limit for nfds e.g. `FD_SETSIZE - 1`.

_and_

(b) Have an fd selected that they were not interested in selecting.

Exactly what the test application above does.

> Worth fixing this bug?  Worth documenting this bug, at least?

I would fix it on the grounds of making the interface as robust as
it was designed to be.

Right now it randomly depends on your task max_fds if it's going to
work or not. That's pretty terrible.

I'm including Michael Kerrisk here if he has any comments since he
touched the manual page several times ;-)

-- 
Cheers,
Carlos.
