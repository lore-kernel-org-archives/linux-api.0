From: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Subject: Re: Revised futex(2) man page for review
Date: Mon, 27 Apr 2015 22:37:05 +0200
Message-ID: <20150427203705.GE29351@xo-6d-61-c0.localdomain>
References: <55166C01.7000803@gmail.com>
 <20150328114725.GJ27490@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150328114725.GJ27490-IIpfhp3q70z/8w/KjCw3T+5/BudmfyzbbVWyRVo5IupeoWH0uzbU5w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Torvald Riegel <triegel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, bill o gallmeister <bgallmeister-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, bert hubert <bert.hubert-dxZxOz86jR8sYtaaK7K+xw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi!

>               The FUTEX_WAIT_OP operation is equivalent to execute the follow???
>               ing  code  atomically  and totally ordered with respect to other
>               futex operations on any of the two supplied futex words:

"to executing"?

>               The  operation  and  comparison  that  are  to  be performed are
>               encoded in the bits of  the  argument  val3.   Pictorially,  the
>               encoding is:
> 
>                       +---+---+-----------+-----------+
>                       |op |cmp|   oparg   |  cmparg   |
>                       +---+---+-----------+-----------+
>                         4   4       12          12    <== # of bits
> 

:-)

> RETURN VALUE
>        In the event of an error, all operations return -1  and  set  errno  to
>        indicate  the  cause of the error.  The return value on success depends
>        on the operation, as described in the following list:

Did you say (at the begining) that there is no glibc wrapper?

>        EINVAL The operation in futex_op is one of those that employs  a  time???
>               out,  but  the supplied timeout argument was invalid (tv_sec was
>               less than zero, or tv_nsec was not less than 1000,000,000).

1,000...?

> NOTES
>        Glibc does not provide a wrapper for this system call;  call  it  using
>        syscall(2).

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
