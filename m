From: christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 01/13] kdbus: add documentation
Date: Mon, 26 Jan 2015 08:44:57 -0800
Message-ID: <20150126164457.GC22803@infradead.org>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
 <1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org>
 <54BE5DC8.70706@gmail.com>
 <54BE9D08.7010804@zonque.org>
 <54BF805B.4000609@gmail.com>
 <54BFDAAA.50203@zonque.org>
 <54C0CE8A.5080805@gmail.com>
 <20150123155402.GB2159@kroah.com>
 <54C65267.7090905@gmail.com>
 <CAG-2HqUCZjc4Ucc-L21uG6e-di4UcLJAT5mW_-5-c-uqmoJyzA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG-2HqUCZjc4Ucc-L21uG6e-di4UcLJAT5mW_-5-c-uqmoJyzA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, Johannes Stezenbach <js-FF7aIK3TAVNeoWH0uzbU5w@public.gmane.org>, Theodore T'so <tytso-3s7WtUTddSA@public.gmane.org>, christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jan 26, 2015 at 04:26:53PM +0100, Tom Gundersen wrote:
> The way I read this is that there will (probably) be a handful of
> users, namely the existing dbus libraries: libdus, sd-bus, glib, Qt,
> ell, and maybe a few others. However, third-party developers will not
> know/care about the details of kdbus, they'll just be coding against
> the dbus libraries as before (might be minor changes, but they
> certainly won't need to know anything about the kernel API). Similarly
> to how userspace developers now code against their libc of choice,
> rather than use kernel syscalls directly.

Which means we do need proper man pages and detailed documentation for
it, just like syscalls for syscalls which just happened to be used by
a few libcs.  I suspect it really should be implemented as
syscalls anyway, but we can leave that argument aside from now.  Good
documentation certainly helps with making that decision in an educated
way.
