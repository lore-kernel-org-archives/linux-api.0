From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC] simple_char: New infrastructure to simplify chardev management
Date: Wed, 11 Feb 2015 12:04:32 -0800
Message-ID: <CALCETrWaFd3xyv-E0VrnBEab6OtDptf6q=V16H52jwK7M-uyTg@mail.gmail.com>
References: <d3ab93173d51cebf00dd2263fd0ce9f8cd6258f7.1423609645.git.luto@amacapital.net>
 <20150211004459.GA30746@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150211004459.GA30746-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Feb 10, 2015 at 4:44 PM, Greg Kroah-Hartman
<gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
> On Tue, Feb 10, 2015 at 03:44:05PM -0800, Andy Lutomirski wrote:
>> This isn't adequately tested, and I don't have a demonstration (yet).
>> It's here for review for whether it's a good idea in the first place
>> and for weather the fully_dynamic mechanism is a good idea.
>>
>> The current character device interfaces are IMO awful.
>
> That's a total understatement.  Redoing the char interface has been in
> my todo list for a decade now.  It's the complexity that happens to be
> used by just a handful of drivers that have prevented me from doing the
> rework in the past.  Creating a "new" interface that we then port code
> to is a very good idea, as it can happen over time in a much more
> orderly way.
>
> And we can throw the kernel-janitors people at it once it's working, to
> convert the rest of the tree, providing them a useful outlet for their
> need for patch cleanups :)
>
> So yes, I'm all for this, thanks so much for looking into this.  I'm at
> a conference this week, but will go over it on the plane home and give
> you some review comments.

It would be nice to make the reference counting cleaner, perhaps by
tying a chardev minor more directly to a struct device, but I wasn't
sure how to do that usefully.

--Andy

>
> greg k-h



-- 
Andy Lutomirski
AMA Capital Management, LLC
