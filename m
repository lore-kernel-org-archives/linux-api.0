From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: writev error codes
Date: Thu, 19 Jan 2017 15:09:52 +1300
Message-ID: <CAKgNAkgWN6Fkx0UqE7Hu6RV82funbbP4OJM0yNK9wiE=0FAMxA@mail.gmail.com>
References: <20170118154431.GD7021@dhcp22.suse.cz>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170118154431.GD7021-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello Michal,

On 19 January 2017 at 04:44, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hi,
> we have noticed that one of the LTP tests started to fail after
> 99526912c934 ("fix iov_iter_fault_in_readable()"). The code has expected
> EINVAL while it gets EFAULT. I believe the new behavior is reasonable,
> but checking the man 2 writev, there is no mention about EFAULT,
> and other errnos for that matter, so it seems this is rather under
> documented and it can confuse users. LTP has been fixed in the meantime
> [1] but this might come unexpected to others.
>
> In principle writev as a write
> "multiplier" should be allowed all the error codes that write(2) allows,
> right? I am not sure how we should reflect that. Either c&p what we have
> in man 2 write or put a reference to it and only describe writev
> specific, if there are any (I haven't checked that).
>
> [1] https://github.com/linux-test-project/ltp/commit/db19194527060a962955a7db54a2f5710e69bec9

Perhaps I am misunderstanding you, but in the writev(2) page there is the text:

    ERRORS
       The  errors  are  as given for read(2) and write(2).  Furthermore,
       preadv(), preadv2(), pwritev(), and pwritev2() can also  fail  for
       the  same reasons as lseek(2).

And in the write(2) page, we have:

       EFAULT buf is outside your accessible address space.

Does this not cover the case you describe?

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
