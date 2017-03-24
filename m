From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: select fails to verify all file descriptors are valid
Date: Fri, 24 Mar 2017 15:41:01 +0100
Message-ID: <b809e8e3-cd95-96c0-ee79-7459ad9f10f1@gmail.com>
References: <20170314161138.GC4033@bombadil.infradead.org>
 <4859e5e8-4cc1-626c-3294-e5f529fe41d3@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4859e5e8-4cc1-626c-3294-e5f529fe41d3-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Carlos,

On 03/15/2017 06:34 AM, Carlos O'Donell wrote:
> On 03/14/2017 12:11 PM, Matthew Wilcox wrote:
> 
> Hello Matthew :-)
>  
>> Quoting the manpage:
>>
>>        int select(int nfds, fd_set *readfds, fd_set *writefds,
>>                   fd_set *exceptfds, struct timeval *timeout);
>>
>>        nfds  is the highest-numbered file descriptor in any of the three sets,
>>        plus 1.
> 
> OK.
> 
>>        EBADF  An  invalid file descriptor was given in one of the sets.  (Per‐
>>               haps a file descriptor that was already closed, or one on  which
>>               an error has occurred.)
>>
>> That's not quite how Linux behaves.  We only check the fd_set up to the
>> maximum number of fds allocated to this task:
>>
>>         rcu_read_lock();
>>         fdt = files_fdtable(current->files);
>>         max_fds = fdt->max_fds;
>>         rcu_read_unlock();
>>         if (n > max_fds)
>>                 n = max_fds;
>>
>> (then we copy in up to 'n' bits worth of bitmaps).
> 
> Right, and that doesn't match the POSIX requirement either.
> 
> http://pubs.opengroup.org/onlinepubs/9699919799/functions/pselect.html
> ~~~
> The nfds argument specifies the range of descriptors to be tested. 
> The first nfds descriptors shall be checked in each set; that is, 
> the descriptors from zero through nfds-1 in the descriptor sets 
> shall be examined.
> ~~~
> 
> That is to say you should "test" `nfds - 1` descriptors, potentially
> returning EBADF for invalid descriptors, not some random number that
> depends on how many you have open right now.

Thanks for checking POSIX!

>> It is pretty straightforward to demonstrate that Linux doesn't check:
>>
>> int main(void)
>> {
>> 	int ret;
>> 	struct timeval tv = { };
>> 	fd_set fds;
>> 	FD_ZERO(&fds);
>> 	FD_SETFD(FD_SETSIZE - 1, &fds);
>> 	ret = select(FD_SETSIZE, &fds, NULL, NULL, &tv);
>> 	assert(ret == -1 && errno == EBADF);
>> 	return 0;
>> }
> 
> And one that compiles and works...
> 
> cat >> select-verify.c <<EOF
> #include <stdio.h>
> #include <stdlib.h>
> #include <sys/select.h>
> #include <sys/time.h>
> #include <sys/types.h>
> #include <unistd.h>
> #include <assert.h>
> #include <errno.h>
> 
> int 
> main(void)
> {
>   int ret;
>   struct timeval tv = {0, 0};
>   fd_set fds;
>   FD_ZERO(&fds);
>   FD_SET(FD_SETSIZE - 1, &fds);
>   ret = select(FD_SETSIZE, &fds, NULL, NULL, &tv);
>   assert(ret == -1 && errno == EBADF);
>   return 0;
> }
> EOF
> gcc -O0 -g3 -Wall -pedantic -o ./select-verify ./select-verify.c
> ./select-verify 
> select-verify: ./select-verify.c:19: main: Assertion `ret == -1 && errno == EBADF' failed.
> Aborted (core dumped)

And thanks for the CWE.
 
>> Linux has behaved this way since 2.6.12, and I can't be bothered to get
>> out the historical git trees to find out what happened before 2005.
>>
>> So ... if I change this behaviour by checking all the file descriptors, I
>> do stand a chance of breaking an application.  On the other hand, that
>> application could already have been broken by the shell deciding to open
>> a really high file descriptor (I'm looking at you, bash), which the program
>> then inherits.
> 
> The user application would have to:
> 
> (a) Use a sloppy limit for nfds e.g. `FD_SETSIZE - 1`.
> 
> _and_
> 
> (b) Have an fd selected that they were not interested in selecting.
> 
> Exactly what the test application above does.
> 
>> Worth fixing this bug?  Worth documenting this bug, at least?
> 
> I would fix it on the grounds of making the interface as robust as
> it was designed to be.
> 
> Right now it randomly depends on your task max_fds if it's going to
> work or not. That's pretty terrible.

It's certainly at least sloppy. Of course, fixing this might
conceivably break some (broken) code. But, the violation of POSIX
suggests we should at least try a fix and see if anything does
get broken (presumably, it's rather unlikely).

> I'm including Michael Kerrisk here if he has any comments since he
> touched the manual page several times ;-)

Thanks ;-).

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
