From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 12/23] netpoll: Introduce netpoll_target configs
Date: Tue, 9 Nov 2010 12:27:32 +0800
Message-ID: <20101109042732.GC5220@cr0.nay.redhat.com>
References: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
 <20101108203246.22479.60118.stgit@crlf.mtv.corp.google.com>
 <20101109033024.GA5220@cr0.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20101109033024.GA5220-+dguKlz9DXUf7BdofF/totBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, simon.kagstrom-vI6UBbBVNY+JA8cjQkG2/g@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>, adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, chavey-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Nov 09, 2010 at 11:30:24AM +0800, Am=C3=A9rico Wang wrote:
>
=2E...
>
>So, either we need to de-modulize configfs or replace configfs API
>with sysfs API. Personally, I prefer the former one, I don't think
>configfs should be a module as long as it can provide API's
>for other subsystems, like debugfs.
>

To clarify, I meant "as long as the API it provides can be used by
other core subsystems".
