From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] ptrace: add ability to retrieve signals without
	removing from a queue (v3)
Date: Wed, 27 Feb 2013 19:38:50 +0100
Message-ID: <20130227183850.GA6042@redhat.com>
References: <1361975829-1738-1-git-send-email-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1361975829-1738-1-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Pedro Alves <palves-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 02/27, Andrey Vagin wrote:
>
> +struct ptrace_peeksiginfo_args {
> +	__u64 off;	/* from which siginfo to start */

Cough... You are optimist. You want to handle the case when the
tracee has 1 << 33 or more pending sigqueues. OK good luck ;)

Looks correct, just one nit.

> +	for (i = 0; i < arg.nr; i++) {
> ...
> +		data += sizeof(siginfo_t);
> +
> +		if (signal_pending(current)) {
> +			i++; /* accounting the current siginfo */
> +			break;
> +		}

Imho, this is confusing. Just do

	for (i = 0; i < arg.nr; ) {
		...

		data += sizeof(siginfo_t);
		i++;

		if (signal_pending(current))
			break;

Oleg.
