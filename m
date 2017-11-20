From: Alan Cox <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Subject: Re: [PATCH] time: Make NTP optionnal
Date: Mon, 20 Nov 2017 16:39:11 +0000
Message-ID: <20171120163911.628daa14@alans-desktop>
References: <20171102182950.6129-1-romain.perier@gmail.com>
        <dd52374f-af2d-3ff1-b9cf-fbf28634a739@sony.com>
        <CABgxDoKm3PZuzV9H=jFnMOQoxKg2_byA7kane-kDhcVEwd9FJw@mail.gmail.com>
        <24617dd4-66ed-d7c9-4c2c-8ad2faac7b72@sony.com>
        <20171120160853.2a1bb7b2@alans-desktop>
        <CABgxDoKXJSkx88XAN=pcL25GJtevM7wkEn4AbigZr1CYKrAWyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABgxDoKXJSkx88XAN=pcL25GJtevM7wkEn4AbigZr1CYKrAWyg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Romain Perier <romain.perier-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: peter enderborg <peter.enderborg-7U/KSKJipcs@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, 20 Nov 2017 17:29:53 +0100
Romain Perier <romain.perier-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> So even if the correspondong syscall are disabled and the
> corresponding clocks too, you should return an -ENOSYS from the
> do_adjtimex helper, in case that another component tries to use it in
> the kernel, right ?

Probably - but you need to trace those callers and check.

Alan
