From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH -v5] random: introduce getrandom(2) system call
Date: Fri, 25 Jul 2014 09:22:25 -0400
Message-ID: <20140725132225.GQ1865@thunk.org>
References: <1406212287-9855-1-git-send-email-tytso@mit.edu>
 <20140724151814.GE32421@khazad-dum.debian.net>
 <CALCETrXAA=UzS-pRCo5tKSjSCOP9xfu66BG9QbRefVrovkavhQ@mail.gmail.com>
 <20140724190206.GL6673@thunk.org>
 <20140724203019.GA20737@khazad-dum.debian.net>
 <20140724232434.GN6673@thunk.org>
 <CALCETrVgKMVnBuzE+bCXaUPRrqhVxwv4AXmJrUJSYws5rZxhJw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrVgKMVnBuzE+bCXaUPRrqhVxwv4AXmJrUJSYws5rZxhJw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Henrique de Moraes Holschuh <hmh-N3TV7GIv+o9fyO9Q7EP/yw@public.gmane.org>, Linux Kernel Developers List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Jul 24, 2014 at 04:27:36PM -0700, Andy Lutomirski wrote:
> 
> I think that people might do:
> 
> try getrandom(GRND_RANDOM)
> fall back to /dev/random
> fall back to something intensely stupid
> 
> We want them to at least attempt the fallback from GRND_RANDOM to !GRND_RANDOM.

We can't legislate against stupidity.  Seriously, the best way to do
this is to write a good userspace library and encourage application
writers to use it.

Regards,

						- Ted
