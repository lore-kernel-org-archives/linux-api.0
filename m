From: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 12/23] netpoll: Introduce netpoll_target configs
Date: Tue, 9 Nov 2010 09:24:33 -0800
Message-ID: <AANLkTi=tUSMrCqnY3-868ugi=b2K78Z=SD=ZDJ36vBUJ@mail.gmail.com>
References: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
 <20101108203246.22479.60118.stgit@crlf.mtv.corp.google.com>
 <20101109033024.GA5220@cr0.nay.redhat.com> <20101109042732.GC5220@cr0.nay.redhat.com>
 <AANLkTingq8R8bc-4fwhBQomdhTgff+fN_vE-pc5zofKX@mail.gmail.com>
 <20101109090645.GG5220@cr0.nay.redhat.com> <20101109142053.GA3067@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101109142053.GA3067-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Cc: Am??rico Wang <xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, simon.kagstrom-vI6UBbBVNY+JA8cjQkG2/g@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>, adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, chavey-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Nov 9, 2010 at 6:20 AM, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org> wrote:
> On Tue, Nov 09, 2010 at 05:06:45PM +0800, Am??rico Wang wrote:
>> On Tue, Nov 09, 2010 at 12:34:24AM -0800, Mike Waychison wrote:
>> >On Mon, Nov 8, 2010 at 8:27 PM, Am??rico Wang <xiyou.wangcong@gmail=
=2Ecom> wrote:
>> >> On Tue, Nov 09, 2010 at 11:30:24AM +0800, Am??rico Wang wrote:
>> >>>
>> >> ....
>> >>>
>> >>>So, either we need to de-modulize configfs or replace configfs AP=
I
>> >>>with sysfs API. Personally, I prefer the former one, I don't thin=
k
>> >>>configfs should be a module as long as it can provide API's
>> >>>for other subsystems, like debugfs.
>> >>>
>> >>
>> >> To clarify, I meant "as long as the API it provides can be used b=
y
>> >> other core subsystems".
>> >>
>> >
>> >Ya, I see the problem with it being a tristate.
>> >
>> >Why not just make netconsole support being compiled in force config=
fs
>> >to be compiled in? =A0Or does that just set bad precedent?
>>
>> That is what netconsole does now, and this is fine, since netconsole=
 is
>> a module too, however, after you move that code into netpoll, then n=
etpoll
>> will have a dependence on it, we will have problems.
>>
>> I think we can let NETPOLL_TARGET depend on CONFIGFS_FS=3Dy, but I s=
till
>> see no reason why CONFIGFS_FS should be a module.
>
> No, just have the NETPOLL_TARGET set CONFIG_FS to y, don't force the
> code to always be that way if the user isn't going to want that optio=
n.

Can you clarify what you mean by "that way" here?

Presumably, only NETPOLL_TARGET_DYNAMIC needs CONFIGFS_FS=3Dy ?

Maybe none of this matters:  NETPOLL_TARGET itself *can* be a module,
as it doesn't do anything more than stack a target management layer on
top of the existing netpoll code.  Nothing in this patchset actually
changes anything within netpoll itself.

Mike Waychison
