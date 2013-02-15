From: Pedro Alves <palves-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] ptrace: add ability to retrieve signals without removing
 them from a queue
Date: Fri, 15 Feb 2013 18:44:51 +0000
Message-ID: <511E8223.6010506@redhat.com>
References: <1360768595-31943-1-git-send-email-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1360768595-31943-1-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 02/13/2013 03:16 PM, Andrey Vagin wrote:
> This patch adds a new ptrace request PTRACE_PEEKSIGINFO.
> 
> This request is used to retrieve information about a signal with the
> specified sequence number. A siginfo_t structure is copied from the child
> to location data in the parent.
> 
> The low 16 bits of addr contains a sequence number of signal in a queue.
> All other bits of addr is used for flags. Currently here is only one
> flag PTRACE_PEEK_SHARED for dumping signals from process-wide shared
> queue. If this flag is not set, a signal is read from a per-thread
> queue.  A result siginfo contains a kernel part of si_code which usually
> striped, but it's required for queuing the same siginfo back during
> restore of pending signals.
> 
> If a signal with the specified sequence number doesn't exist, ptrace
> returns ENOENT.
> 
> This functionality is required for checkpointing pending signals.
> 
> The prototype of this code was developed by Oleg Nesterov.

Not sure I'm reading the patch right, but it looks like GDB would
be able to use this as alternative to PTRACE_GET_SIGINFO variant
that returns the siginfo_t object in the architecture/bitness of
the tracee, rather than the architecture of the kernel, right?
So it no longer would need to try and replicate the kernel's
siginfo conversions.  I wouldn't mind if this was added unconditionally
instead of wrapped on CONFIG_CHECKPOINT_RESTORE.  We'd miss the poke
variant, but that looks like something that could be always be added
later.

-- 
Pedro Alves
