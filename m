From: Samuel Ortiz <sameo-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: Odd hang on suspend and shutdown
Date: Tue, 7 Jul 2015 00:31:33 +0200
Message-ID: <20150706223133.GC22015@zurbaran.home>
References: <CA+55aFy1x6iwbdV8WfR+wawj_1+PxJ+P-Js=EVqD9ZsQetSNJA@mail.gmail.com>
 <20150706160706.GA22015@zurbaran.home>
 <CA+55aFxfENpyWSDxgaQhB1mBHE6zs=w=Mc0VEQLgdwSaCMX5eQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFxfENpyWSDxgaQhB1mBHE6zs=w=Mc0VEQLgdwSaCMX5eQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 06, 2015 at 09:49:51AM -0700, Linus Torvalds wrote:
> On Mon, Jul 6, 2015 at 9:07 AM, Samuel Ortiz <sameo-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> >
> > I suppose you were not seeing this issue on e.g. a 4.1 kernel (assuming
> > this is not a brand new laptop) ?
> 
> Nope, 4.1 is fine. This is my travel laptop for the last almost two
> years. Best laptop I've ever had (I like them small and light).
> 
> > If that's the case, is any of the pn544* kernel modules loaded when
> > running on top of a good kernel ?
> 
> So it doesn't show up in lsmod, but presumably the module got loaded
> and then errored out or something. The mei and mei_me modules are
> loaded, nut no pn544_mei.
Oh, by 'good kernel' I meant a 4.1 one for example, sorry for the
confusion.
Not one where you removed the UUID from pn544/mei.c because thay will
essentially make sure the driver is never probed.

What I'm trying to rule out is that you never saw that issue on previous
kernels because the pn544 driver was not loaded at all, but this:

> I'm not even sure why it's in my configuration, because I tend to try
> to keep those small, and my config was generated (long ago) with "make
> localmodconfig", but maybe there's something non-obvious that brought
> it in. Presumably that pn544 module was loaded at _some_ point in the
> past.
seems to prove it has already been automatically loaded (and thus probed
because the loading happened as the NFC device was found on the MEI
bus).

The pn544 mei support was added with 3.10 iirc, so starting from there
your pn544* modules have been most likely automatically loaded.

Cheers,
Samuel.
