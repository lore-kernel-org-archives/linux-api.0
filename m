From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: select fails to verify all file descriptors are valid
Date: Tue, 14 Mar 2017 09:11:38 -0700
Message-ID: <20170314161138.GC4033@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


Quoting the manpage:

       int select(int nfds, fd_set *readfds, fd_set *writefds,
                  fd_set *exceptfds, struct timeval *timeout);

       nfds  is the highest-numbered file descriptor in any of the three sets,
       plus 1.

       EBADF  An  invalid file descriptor was given in one of the sets.  (Per‐
              haps a file descriptor that was already closed, or one on  which
              an error has occurred.)

That's not quite how Linux behaves.  We only check the fd_set up to the
maximum number of fds allocated to this task:

        rcu_read_lock();
        fdt = files_fdtable(current->files);
        max_fds = fdt->max_fds;
        rcu_read_unlock();
        if (n > max_fds)
                n = max_fds;

(then we copy in up to 'n' bits worth of bitmaps).

It is pretty straightforward to demonstrate that Linux doesn't check:

int main(void)
{
	int ret;
	struct timeval tv = { };
	fd_set fds;
	FD_ZERO(&fds);
	FD_SETFD(FD_SETSIZE - 1, &fds);
	ret = select(FD_SETSIZE, &fds, NULL, NULL, &tv);
	assert(ret == -1 && errno == EBADF);
	return 0;
}

Linux has behaved this way since 2.6.12, and I can't be bothered to get
out the historical git trees to find out what happened before 2005.

So ... if I change this behaviour by checking all the file descriptors, I
do stand a chance of breaking an application.  On the other hand, that
application could already have been broken by the shell deciding to open
a really high file descriptor (I'm looking at you, bash), which the program
then inherits.

Worth fixing this bug?  Worth documenting this bug, at least?
