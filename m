From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: Odd hang on suspend and shutdown
Date: Mon, 6 Jul 2015 10:29:08 -0700
Message-ID: <CA+55aFwM8c3Zm0t0cEnbGS0d0rinzGwnX9uSxqKjff8K=ATaRA@mail.gmail.com>
References: <CA+55aFy1x6iwbdV8WfR+wawj_1+PxJ+P-Js=EVqD9ZsQetSNJA@mail.gmail.com>
	<20150706160706.GA22015@zurbaran.home>
	<CA+55aFxfENpyWSDxgaQhB1mBHE6zs=w=Mc0VEQLgdwSaCMX5eQ@mail.gmail.com>
	<20150706165959.GB22015@zurbaran.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150706165959.GB22015-nKCvNrh56OoJmsy6czSMtA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Samuel Ortiz <sameo-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 6, 2015 at 9:59 AM, Samuel Ortiz <sameo-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
>
> Ok, if you can suspend after this modprobe we're looking at some
> potential mei bus or mei core issues.

Just looking at the mei/bus.c code to match the driver, and it looks just odd.

Before the commit that breaks for me, it used to have this loop:

-       while (id->name[0]) {

and now it has

+       while (uuid_le_cmp(NULL_UUID_LE, uuid_le_cast(id->uuid))) {

which seems to mean that together with my change to make a working
kernel (just removing the UUID entirely) means that now the
device_driver isn't matched against anything at all any more.

So I'm not sure "modprobe pn544_mei" ends up actually triggering
anything at all with my change to make it not lock up for me.

                  Linus
