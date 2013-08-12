From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: Request for comments: reserving a value for O_SEARCH and O_EXEC
Date: Mon, 12 Aug 2013 10:42:03 -0700
Message-ID: <52091E6B.10800@mit.edu>
References: <20130803024808.GA26932@brightrain.aerifal.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130803024808.GA26932-C3MtFaGISjmo6RMmaWD+6Sb1p8zYI1N1@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rich Felker <dalias-/miJ2pyFWUyWIDz0JBNUog@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

[cc: linux-api]


On 08/02/2013 07:48 PM, Rich Felker wrote:
> Hi,
> 
> At present, one of the few interface-level conformance issues for
> Linux against POSIX 2008 is lack of O_SEARCH and O_EXEC. I am trying
> to get full, conforming support for them both into musl libc (for
> which I am the maintainer) and glibc (see the libc-alpha post[1]).
> At this point, I believe it is possible to do so with no changes at
> the kernel level, using O_PATH and a moderate amount of
> userspace-level emulation where O_PATH semantics are lacking. What
> we're missing, however, is a reserved O_ACCMODE value for O_SEARCH and
> O_EXEC (it can be the same for both). Using O_PATH directly is not an
> option because the semantics for O_PATH|O_NOFOLLOW differ from the
> POSIX semantics for O_SEARCH|O_NOFOLLOW and O_EXEC|O_NOFOLLOW:
> 
> - Linux O_PATH|O_NOFOLLOW opens a file descriptor referring to the
>   symlink inode itself.
> 
> - POSIX O_NOFOLLOW with O_SEARCH or O_EXEC forces failure if the
>   pathname refers to a symlink.
> 
> Both are important functionality to support - the former for features
> and the latter for security. We can't just fstat and reject symbolic
> links in userspace when O_PATH gets one or we would break access to
> the Linux-specific O_PATH functionality, which is useful. So there
> needs to be a way for open (the library function) to detect whether
> the caller requested O_PATH or O_SEARCH/O_EXEC.
> 
> We could chord O_PATH with another flag such as O_EXCL where the
> behavior would otherwise be undefined, but I don't want to conflict
> with future such use by the kernel; that would be a compatibility
> disaster.
> 
> My preference would be to use the value 3 for O_SEARCH and O_EXEC, so
> that the O_ACCMODE mask would not even need to change. But doing this
> requires (even moreso than chording) agreement with the kernel
> community that this value will not be used for something else in the
> future. Looking back, I see that it's been accepted by the kernel for
> a long time (at least since 2.6.32) and treated as "no access" (reads
> and writes result in EBADF, like O_PATH) but still does not let you
> open files you don't have permissions to, or directories. However I'm
> not clear if this is a documented (or undocumented, but stable :)
> interface that should be left with its current behavior. Taking the
> value 3 for O_SEARCH and O_EXEC would mean having open (the library
> function) automatically apply O_PATH before passing it to the kernel
> and rejecting the resulting fd if it's a symbolic link.
> 
> An alternate, less graceful but perhaps more compatible approach,
> would be to use O_PATH|3 for O_SEARCH and O_EXEC. Then open could just
> look for the low bits of flags (which should be 0 when using O_PATH
> for the Linux semantics, no?) and reject symbolic links if they are
> set.
> 
> Whatever approach we settle on, it would be nice if it has the
> property that the kernel could eventually provide the full O_SEARCH
> and O_EXEC semantics itself and eliminate the need for userspace
> emulation. The current emulations we need are:
> 
> - fchmod and fchown (still not supported for O_PATH) fall back to
>   calling chmod or chown on the pseudo-symlink in /proc/self/fd.
> 
> - fchdir and fstat (not supported prior to 3.5/3.6) fall back to
>   calling chdir or stat.
> 
> - open checks whether it obtained a symlink and if so closes it and
>   reports ELOOP.
> 
> - fcntl, depending on the value chosen for O_SEARCH/O_EXEC, may have
>   to map the flags from F_GETFL to the right value.
> 
> There may be others I'm missing, but emulation generally follows the
> same pattern.
> 
> Opinions? Please keep me CC'd on replies since I am not on the list.

You'll have the same problem that O_TMPFILE had: the kernel currently
ignores unrecognized flags.  I wonder if it's time to add a new syscall
(or syscalls) with more sensible semantics.

--Andy
