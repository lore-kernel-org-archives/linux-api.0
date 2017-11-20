From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] time: Make NTP optionnal
Date: Mon, 20 Nov 2017 16:08:53 +0000
Message-ID: <20171120160853.2a1bb7b2@alans-desktop>
References: <20171102182950.6129-1-romain.perier@gmail.com>
        <dd52374f-af2d-3ff1-b9cf-fbf28634a739@sony.com>
        <CABgxDoKm3PZuzV9H=jFnMOQoxKg2_byA7kane-kDhcVEwd9FJw@mail.gmail.com>
        <24617dd4-66ed-d7c9-4c2c-8ad2faac7b72@sony.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <24617dd4-66ed-d7c9-4c2c-8ad2faac7b72@sony.com>
Sender: linux-kernel-owner@vger.kernel.org
To: peter enderborg <peter.enderborg@sony.com>
Cc: Romain Perier <romain.perier@gmail.com>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Stephen Boyd <sboyd@codeaurora.org>, linux-api@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, 20 Nov 2017 16:22:06 +0100
peter enderborg <peter.enderborg@sony.com> wrote:

> On 11/20/2017 04:00 PM, Romain Perier wrote:
> > Hi,
> >
> > 2017-11-20 15:10 GMT+01:00 peter enderborg <peter.enderborg@sony.com>:  
> >> I think it should return a error code at least.  
> > In which case ? The idea was to don't change the behaviour of these
> > functions (from the "API" point of view) and to avoid regressions in
> > the kernel components that depend on these NTP feature.
> > (so be transparent the most as possible)
> >
> > Thanks,
> > Romain
> >  
> 
> do_adjtimex should return -ENOSYS in my opinion, however it is not in the manual
> that it can return ENOSYS. 

The standards specifications state what must be returned for certain
error cases, they don't forbid other errors being added.

Old old Linx will of course already return -1,ENOSYS to this call.

Alan
