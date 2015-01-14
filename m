From: Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: Linux GPIO internals
Date: Wed, 14 Jan 2015 13:18:21 +0100
Message-ID: <CACRpkdathuQYLba1wMGLsV2TqhfBqGNQQAWqPfZ7XH1Oj+UFZg@mail.gmail.com>
References: <20141224215352.GA26482@sysresccd>
	<CAAVeFuJcWizqtW4mmD8ow5eg2841vgXhZ=7bHDiO3ZJfE2ezog@mail.gmail.com>
	<20150105174723.GA11391@sysresccd>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150105174723.GA11391@sysresccd>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Welling <mwelling-ei31t81uNw5BDgjK7y7TUQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alexandre Courbot <gnurou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "acourbot-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org" <acourbot-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-gpio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-gpio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Stigge <stigge-uj/7R2tJ6VmzQB+pC5nmwQ@public.gmane.org>, Wolfgang Grandegger <wg-5Yr1BZd7O62+XT7JhA+gdA@public.gmane.org>, tstratman-ei31t81uNw5BDgjK7y7TUQ@public.gmane.org, Rojhalat Ibrahim <imr-yYm5e5rpIQsb1SvskN2V4Q@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jan 5, 2015 at 6:47 PM, Michael Welling <mwelling-ei31t81uNw5BDgjK7y7TUQ@public.gmane.org> wrote:
> On Sat, Jan 03, 2015 at 02:12:06PM +0100, Alexandre Courbot wrote:

>> It seems like your mail is coming just at the right time. We have
>> recently merged a patch that allows setting several GPIOs at the same
>> time, if the hardware supports it:
>>
>> http://patchwork.ozlabs.org/patch/406666/
>
> This looks like a good starting point. Being able to access to multiple
> GPIOs simultaneously on the same controller bank is great.

It's intended to handle the case when several GPIOs can be
switched at the same time by a single register write. It implies
being on the same controller.

> What is nice about the EMAC class is that the GPIOs do not necessarily
> have to be on the same bank (or controller) to be grouped together. The
> system call overhead of accessing a single IO is the same as multiple
> IOs in the same group.

You're comparing pears and apples now I think.

A userspace ABI making it possible to switch several GPIOs
on several controllers is perfectly doable both with and without
the above interface.

In this latter case you're more worried about the latency
incurred by the userspace/kernelspace switch, whereas
the former is about the delays incurred by several register
writes.

Userspace/kernelspace switch delay is a few magnitudes
larger than the delay between sequenced register writes I
suspect.

> Still wondering what happened to the gpioblock patch.

Roland?

> The sysfs interface is great for command line and scripting languages
> but it has more overhead. It requires string conversion at both the
> kernel and userspace. More system calls are typically required for
> similar transactions.

Agree. I have a problem with it too.

>> Considering the constraints that we have (no GPIO integers for
>> exporting, sysfs-based, uses gpiod_*array()), do you think we could
>> satisfy your goals as well?
>
> This should be satisfactory for most use cases. I will try to support
> efforts toward modernizing the sysfs interface.
>
> Would a character interface to gpiolib ever be considered?

I like the character interface idea actually.

/dev/gpiochip0
/dev/gpiochip1
(...)

Then ioctl() operations to do all the magic to figure out what GPIOs
are there and how to read/write them etc. To me this reflects the
system properly and gives all kind of freedom to manipulate the
GPIOs with efficient context switches. Plus we can deliberately
avoid including any GPIO numbers anywhere, just allow names
and nothing else.

But I'm no userspace/kernelspace expert, let's hear what
the linux-api mailing list has to say.

Yours,
Linus Walleij
