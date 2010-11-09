From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 12/23] netpoll: Introduce netpoll_target configs
Date: Tue, 9 Nov 2010 17:06:45 +0800
Message-ID: <20101109090645.GG5220@cr0.nay.redhat.com>
References: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
 <20101108203246.22479.60118.stgit@crlf.mtv.corp.google.com>
 <20101109033024.GA5220@cr0.nay.redhat.com>
 <20101109042732.GC5220@cr0.nay.redhat.com>
 <AANLkTingq8R8bc-4fwhBQomdhTgff+fN_vE-pc5zofKX@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTingq8R8bc-4fwhBQomdhTgff+fN_vE-pc5zofKX-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, simon.kagstrom-vI6UBbBVNY+JA8cjQkG2/g@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>, adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, chavey-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Nov 09, 2010 at 12:34:24AM -0800, Mike Waychison wrote:
>On Mon, Nov 8, 2010 at 8:27 PM, Am=C3=A9rico Wang <xiyou.wangcong@gmai=
l.com> wrote:
>> On Tue, Nov 09, 2010 at 11:30:24AM +0800, Am=C3=A9rico Wang wrote:
>>>
>> ....
>>>
>>>So, either we need to de-modulize configfs or replace configfs API
>>>with sysfs API. Personally, I prefer the former one, I don't think
>>>configfs should be a module as long as it can provide API's
>>>for other subsystems, like debugfs.
>>>
>>
>> To clarify, I meant "as long as the API it provides can be used by
>> other core subsystems".
>>
>
>Ya, I see the problem with it being a tristate.
>
>Why not just make netconsole support being compiled in force configfs
>to be compiled in?  Or does that just set bad precedent?

That is what netconsole does now, and this is fine, since netconsole is
a module too, however, after you move that code into netpoll, then netp=
oll
will have a dependence on it, we will have problems.

I think we can let NETPOLL_TARGET depend on CONFIGFS_FS=3Dy, but I stil=
l
see no reason why CONFIGFS_FS should be a module.
