From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: select fails to verify all file descriptors are valid
Date: Fri, 24 Mar 2017 15:40:49 +0100
Message-ID: <85d50ac0-3bf0-0e2c-4a89-dfffa54c4f4d@gmail.com>
References: <20170314161138.GC4033@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170314161138.GC4033-PfSpb0PWhxZc2C7mugBRk2EX/6BAtgUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Matthew,

On 03/14/2017 05:11 PM, Matthew Wilcox wrote:
> 
> Quoting the manpage:
> 
>        int select(int nfds, fd_set *readfds, fd_set *writefds,
>                   fd_set *exceptfds, struct timeval *timeout);
> 
>        nfds  is the highest-numbered file descriptor in any of the three sets,
>        plus 1.
> 
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
>
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
> 
> Linux has behaved this way since 2.6.12, and I can't be bothered to get
> out the historical git trees to find out what happened before 2005.

Looking back, this behavior seems to have been present at least as far 
back as 2.4.0:

        if (n > current->files->max_fdset)
                n = current->files->max_fdset;

My reading on the 2.2.0 source suggests this odd behavior did not 
occur there.

> So ... if I change this behaviour by checking all the file descriptors, I
> do stand a chance of breaking an application.  On the other hand, that
> application could already have been broken by the shell deciding to open
> a really high file descriptor (I'm looking at you, bash), which the program
> then inherits.

I'm not sure that bash's FD 255 oddity is a problem here, since the 
close-on-exec flag is set on that FD.

> Worth fixing this bug?  Worth documenting this bug, at least?

Certainly worth documenting. Fixing? I'm less sure. But, Carlos does
have a point about POSIX...

I've updated the man page to say:

       nfds  should be set to the highest-numbered file descriptor in any
       of the three sets, plus 1.  The indicated file descriptors in each
       set are checked, up to this limit (but see BUGS).

       ...

       EBADF  An  invalid  file  descriptor was given in one of the sets.
              (Perhaps a file descriptor that was already closed, or  one
              on which an error has occurred.)  However, see BUGS.
       ...

   BUGS
       According  to  POSIX,  select()  should  check  all specified file
       descriptors in the three file descriptor sets,  up  to  the  limit
       nfds-1.   However,  the  current  implementation  ignores any file
       descriptor in these sets that is greater  than  the  maximum  file
       descriptor  number that the process currently has open.  According
       to POSIX, any such file descriptor that is specified in one of the
       sets should result in the error EBADF.

Cheers,

Michael

> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
