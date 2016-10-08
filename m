From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: Return type of getrandom(2)
Date: Sat, 8 Oct 2016 15:40:05 -0400
Message-ID: <20161008194005.uo7uwiaukgk4y7ku@thunk.org>
References: <87mvifnhxw.fsf@mid.deneb.enyo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87mvifnhxw.fsf-ZqZwdwZz9NfTBotR3TxKnbNAH6kLmebB@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Florian Weimer <fw-d32yF4oPJVt0XxTmqZlbVQ@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, Oct 08, 2016 at 02:28:27PM +0200, Florian Weimer wrote:
> The manual page says the return type of getrandom(2) is int, but
> ssize_t would be more natural (see read(2) for comparison).  The
> kernel uses ssize_t internally, which is converted to long on the
> system call boundary.
> 
> The difference does not currently matter because the return value is
> limited to much less than INT_MAX in the implementation.
> 
> Should we use int or ssize_t in the glibc system call wrapper?

I'd suggest keeping it as an int since (a) OpenBSD's getentropy(2)
returns an int, and part of the orignal design goal is to be able to
emulate OpenBSD's getentropy(2) system call via:

int getentropy(void *buf, size_t buflen)
{
	return getrandom(buf, buflen, 0);
}

and (b) the maximum number of bytes returned will *always* be well
under INT_MAX.  I can't forsee at any point in any future or alternate
universe where getrandom() would need to return anywhere near
SHORT_MAX, let alone INT_MAX.

Cheers,

					- Ted
