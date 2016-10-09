From: Florian Weimer <fw-d32yF4oPJVt0XxTmqZlbVQ@public.gmane.org>
Subject: Re: Return type of getrandom(2)
Date: Sun, 09 Oct 2016 11:47:00 +0200
Message-ID: <87d1j9kg6j.fsf@mid.deneb.enyo.de>
References: <87mvifnhxw.fsf@mid.deneb.enyo.de>
        <20161008194005.uo7uwiaukgk4y7ku@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161008194005.uo7uwiaukgk4y7ku-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org> (Theodore Ts'o's
        message of "Sat, 8 Oct 2016 15:40:05 -0400")
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>
List-Id: linux-api@vger.kernel.org

* Theodore Ts'o:

> On Sat, Oct 08, 2016 at 02:28:27PM +0200, Florian Weimer wrote:
>> The manual page says the return type of getrandom(2) is int, but
>> ssize_t would be more natural (see read(2) for comparison).  The
>> kernel uses ssize_t internally, which is converted to long on the
>> system call boundary.
>> 
>> The difference does not currently matter because the return value is
>> limited to much less than INT_MAX in the implementation.
>> 
>> Should we use int or ssize_t in the glibc system call wrapper?
>
> I'd suggest keeping it as an int since (a) OpenBSD's getentropy(2)
> returns an int, and part of the orignal design goal is to be able to
> emulate OpenBSD's getentropy(2) system call via:
>
> int getentropy(void *buf, size_t buflen)
> {
> 	return getrandom(buf, buflen, 0);
> }

But this implementation is quite wrong.  It has to look like something
like this:

int
getentropy (void *buf, size_t buflen)
{
  ssize_t ret = getrandom (buf, buflen, 0)
  if (ret < 0)
    return -1;
  if (ret < buflen)
    {
      errno = EIO;
      return -1;
    }
  return 0;
}

The ssize_t return would hint to the fact that such a wrapper is
required because the interfaces are somewhat different.

> and (b) the maximum number of bytes returned will *always* be well
> under INT_MAX.  I can't forsee at any point in any future or alternate
> universe where getrandom() would need to return anywhere near
> SHORT_MAX, let alone INT_MAX.

Right, that's true for the Linux implementation.  The question is
whether it applies to other implementations as well.  Solaris appears
to have an even lower limit.
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
