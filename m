From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: Odd hang on suspend and shutdown
Date: Mon, 6 Jul 2015 09:49:51 -0700
Message-ID: <CA+55aFxfENpyWSDxgaQhB1mBHE6zs=w=Mc0VEQLgdwSaCMX5eQ@mail.gmail.com>
References: <CA+55aFy1x6iwbdV8WfR+wawj_1+PxJ+P-Js=EVqD9ZsQetSNJA@mail.gmail.com>
	<20150706160706.GA22015@zurbaran.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150706160706.GA22015-nKCvNrh56OoJmsy6czSMtA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Samuel Ortiz <sameo-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 6, 2015 at 9:07 AM, Samuel Ortiz <sameo-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
>
> I suppose you were not seeing this issue on e.g. a 4.1 kernel (assuming
> this is not a brand new laptop) ?

Nope, 4.1 is fine. This is my travel laptop for the last almost two
years. Best laptop I've ever had (I like them small and light).

> If that's the case, is any of the pn544* kernel modules loaded when
> running on top of a good kernel ?

So it doesn't show up in lsmod, but presumably the module got loaded
and then errored out or something. The mei and mei_me modules are
loaded, nut no pn544_mei.

I'm not even sure why it's in my configuration, because I tend to try
to keep those small, and my config was generated (long ago) with "make
localmodconfig", but maybe there's something non-obvious that brought
it in. Presumably that pn544 module was loaded at _some_ point in the
past.

I just tested, and loading it manually with "modprobe pn544_mei"
doesn't seem to do anything bad.  I can still suspend with a good
kernel. So it's not just about loading the module, there's some other
interaction going on.

                     Linus
