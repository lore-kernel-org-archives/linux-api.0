From: Mike Waychison <mikew@google.com>
Subject: Re: [PATCH v2 12/23] netpoll: Introduce netpoll_target configs
Date: Tue, 9 Nov 2010 00:34:24 -0800
Message-ID: <AANLkTingq8R8bc-4fwhBQomdhTgff+fN_vE-pc5zofKX@mail.gmail.com>
References: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
 <20101108203246.22479.60118.stgit@crlf.mtv.corp.google.com>
 <20101109033024.GA5220@cr0.nay.redhat.com> <20101109042732.GC5220@cr0.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101109042732.GC5220@cr0.nay.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: simon.kagstrom@netinsight.net, davem@davemloft.net, nhorman@tuxdriver.com, Matt Mackall <mpm@selenic.com>, adurbin@google.com, linux-kernel@vger.kernel.org, chavey@google.com, Greg KH <greg@kroah.com>, akpm@linux-foundation.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Nov 8, 2010 at 8:27 PM, Am=E9rico Wang <xiyou.wangcong@gmail.co=
m> wrote:
> On Tue, Nov 09, 2010 at 11:30:24AM +0800, Am=E9rico Wang wrote:
>>
> ....
>>
>>So, either we need to de-modulize configfs or replace configfs API
>>with sysfs API. Personally, I prefer the former one, I don't think
>>configfs should be a module as long as it can provide API's
>>for other subsystems, like debugfs.
>>
>
> To clarify, I meant "as long as the API it provides can be used by
> other core subsystems".
>

Ya, I see the problem with it being a tristate.

Why not just make netconsole support being compiled in force configfs
to be compiled in?  Or does that just set bad precedent?
