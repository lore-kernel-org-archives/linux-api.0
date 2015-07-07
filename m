From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: Odd hang on suspend and shutdown
Date: Mon, 6 Jul 2015 17:04:18 -0700
Message-ID: <CA+55aFxo064xa5m3KPjSJxQCrDL3H1QwuEcpCKMg0TL8C0aedQ@mail.gmail.com>
References: <CA+55aFy1x6iwbdV8WfR+wawj_1+PxJ+P-Js=EVqD9ZsQetSNJA@mail.gmail.com>
	<20150706160706.GA22015@zurbaran.home>
	<CA+55aFxfENpyWSDxgaQhB1mBHE6zs=w=Mc0VEQLgdwSaCMX5eQ@mail.gmail.com>
	<20150706223133.GC22015@zurbaran.home>
	<CA+55aFwsrywW4fEt33BZFPSu5F0eAFB5YAY-zHUZ8-BLv1VcDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFwsrywW4fEt33BZFPSu5F0eAFB5YAY-zHUZ8-BLv1VcDg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Samuel Ortiz <sameo-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 6, 2015 at 4:06 PM, Linus Torvalds
<torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
>
> I'll go and test the plain revert case.

So the "plain" revert ended up being more than a single revert, just
because there were multiple changes in that area. But after doing
this:

    git revert b144ce2d3761
    git revert 1d3ff76721fb
    git revert be9b720a0ccb
    git revert 007d64eb2232
    git revert dbac993f6a6d
    git revert d4b78c7290dd
    git revert c93b76b34b4d

I have a working kernel that loads the pn544 thing automatically, and
shows it in /sys/class/nfc/, and suspend works.

So I'm back to the pre-merge-window behavior.

I'd be happy to do a more minimal revert, but the above was the
trivial "revert without any conflicts" set.

              Linus
