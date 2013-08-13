From: Rich Felker <dalias-/miJ2pyFWUyWIDz0JBNUog@public.gmane.org>
Subject: Re: Request for comments: reserving a value for O_SEARCH and O_EXEC
Date: Mon, 12 Aug 2013 23:22:15 -0400
Message-ID: <20130813032214.GA221@brightrain.aerifal.cx>
References: <20130803024808.GA26932@brightrain.aerifal.cx>
 <52091E6B.10800@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <52091E6B.10800-3s7WtUTddSA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Aug 12, 2013 at 10:42:03AM -0700, Andy Lutomirski wrote:
> You'll have the same problem that O_TMPFILE had: the kernel currently
> ignores unrecognized flags.  I wonder if it's time to add a new syscall
> (or syscalls) with more sensible semantics.

That's not a problem here. In fact, in the case where O_PATH is not
supported by the kernel, the best possible behavior for O_SEARCH and
O_EXEC would be for them to be the same as O_RDONLY, since this gives
comforming behavior in all ways except that it will fail if you don't
have read access to the file.

Some folks have raised the issue that it would be "dangerous" because
certain devices have side effects on open, even open for read, but
POSIX does not specify that opening for search or exec suppresses such
side effects anyway. It's only applications directly using O_PATH and
expecting the Linux semantics that would be thrown off by getting
O_READ semantics instead. In any case, there are many reasons it's
unsafe for a privileged process to open an untrusted pathname already.

Anyway, the whole point of this discussion is about choosing a value
that has the best fallback behavior on old kernels. O_PATH alone would
meet that requirement almost perfectly, but it has the unfortunate
issue that O_NOFOLLOW is interpreted in a special way with O_PATH: it
causes the symlink itelf to be opened, rather than for open to fail
when encountering a symlink. So we need a new flag by which the kernel
could detect and reject symlinks with O_PATH, _or_ the kernel could
just ignore this new flag, since userspace will have to check (to
support older kernels) that it did not get a symlink, and if so,
simulate failure.

Rich
