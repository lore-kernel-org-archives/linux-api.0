From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] staging: android: binder: move to the "real" part of
 the kernel
Date: Sat, 18 Oct 2014 22:36:30 +0100
Message-ID: <20141018223630.497988fa@alan.etchedpixels.co.uk>
References: <20141016124741.GA3832@kroah.com>
	<CALAqxLU05D8qQA47E77PiuuN7eVt66WEq1qn+PqdE-tpEUzFpw@mail.gmail.com>
	<20141016231221.GA13592@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141016231221.GA13592@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: John Stultz <john.stultz@linaro.org>, lkml <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org, Linux API <linux-api@vger.kernel.org>, Santosh Shilimkar <santosh.shilimkar@ti.com>, Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>, Sumit Semwal <sumit.semwal@linaro.org>, Rebecca Schultz Zavin <rebecca@android.com>, Christoffer Dall <christoffer.dall@linaro.org>, Anup Patel <anup.patel@linaro.org>
List-Id: linux-api@vger.kernel.org

> Do we really need someone to do more work that has been done on it in
> the past as an official "maintainer"?  I'll be glad to do it, as I doubt
> it will require any time at all.

Well every time in the past that Al Viro looked in its direction he broke
it so probably. Someone is going to have to clean up or fix the fact it
pokes around in the depths of the low level fd I/O code and calls stuff
like __fd_install and __alloc_fd directly, or mend it if it breaks.

I'm curious what Al Viro thinks of it

> > Currently in the android space no one but libbinder should use the
> > kernel interface.
> 
> That is correct.  If you do that, you deserve all of the pain and
> suffering and rooted machines you will get.

So what is the Android side model for its security. That probably also
should be described so nobody goes off and uses it for something like
systemd because "it looked neat".

> But all of the changes will be in new code.  Be it kdbus, or something
> else if that doesn't work out.  This existing binder.c file will not be
> changing at all.  This existing ABI, and codebase, is something that we
> have to maintain forever for those millions of devices out there in the
> real world today. 

95% of those devices are locked down, most of them have non replaceable
batteries that will dead and irreplacable (sanely anyway) in 3-5 years.
"Forever" in the phone world is mercifully rather short.

Alan
