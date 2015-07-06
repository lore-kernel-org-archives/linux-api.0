From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: Odd hang on suspend and shutdown
Date: Mon, 6 Jul 2015 16:06:45 -0700
Message-ID: <CA+55aFwsrywW4fEt33BZFPSu5F0eAFB5YAY-zHUZ8-BLv1VcDg@mail.gmail.com>
References: <CA+55aFy1x6iwbdV8WfR+wawj_1+PxJ+P-Js=EVqD9ZsQetSNJA@mail.gmail.com>
	<20150706160706.GA22015@zurbaran.home>
	<CA+55aFxfENpyWSDxgaQhB1mBHE6zs=w=Mc0VEQLgdwSaCMX5eQ@mail.gmail.com>
	<20150706223133.GC22015@zurbaran.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150706223133.GC22015-nKCvNrh56OoJmsy6czSMtA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Samuel Ortiz <sameo-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 6, 2015 at 3:31 PM, Samuel Ortiz <sameo-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
>
> The pn544 mei support was added with 3.10 iirc, so starting from there
> your pn544* modules have been most likely automatically loaded.

I no longer had a 4.1 kernel (with all the bisecting I had pruned away
old kernel builds), but booting into a distro kernel shows that in
4.0.6, the pn544 modules do get loaded, and suspend/resume works fine.

.. and that also explains why I had it enabled in my .config. It would
have been picked up by "make localmodconfig".

> If the pn544 probed correctly you will see a /sys/class/nfc/nfc0 entry.

Yes, that shows up in 4.0.6. It does not show up in my modified
4.2-rc1 kernel that dropped the UUID.

I'll go and test the plain revert case.

               Linus
