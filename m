From: Florian Weimer <fw-d32yF4oPJVt0XxTmqZlbVQ@public.gmane.org>
Subject: Re: Return type of getrandom(2)
Date: Wed, 12 Oct 2016 08:30:16 +0200
Message-ID: <87eg3mw03r.fsf@mid.deneb.enyo.de>
References: <87mvifnhxw.fsf@mid.deneb.enyo.de>
        <20161008194005.uo7uwiaukgk4y7ku@thunk.org>
        <CALCETrWgc0Wwd5AQ8fk3qPabsXKAgFZmH5O6w0CrcXEx+Pwy-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrWgc0Wwd5AQ8fk3qPabsXKAgFZmH5O6w0CrcXEx+Pwy-Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
        (Andy Lutomirski's message of "Sun, 9 Oct 2016 09:53:48 -0700")
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

* Andy Lutomirski:

> On Oct 8, 2016 4:17 PM, "Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org> wrote:
>>
>> On Sat, Oct 08, 2016 at 02:28:27PM +0200, Florian Weimer wrote:
>> > The manual page says the return type of getrandom(2) is int, but
>> > ssize_t would be more natural (see read(2) for comparison).  The
>> > kernel uses ssize_t internally, which is converted to long on the
>> > system call boundary.
>> >
>> > The difference does not currently matter because the return value is
>> > limited to much less than INT_MAX in the implementation.
>> >
>> > Should we use int or ssize_t in the glibc system call wrapper?
>
> I think it should be ssize_t.  Having the types mismatched across the
> syscall boundary is just confusing.
>
>> (b) the maximum number of bytes returned will *always* be well
>> under INT_MAX.
>
> I would argue that this particular ship sailed when the len parameter
> was given the type size_t.  The door is open for requests bigger than
> 2GiB.  Even if Linux will never honor those requests, I see no reason
> to make their return value have a nonsensical type.

Thanks for your input.  I'm leaning towards ssize_t now as well.
Ted's getentropy example was helpful as well.
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
