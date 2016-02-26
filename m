From: Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v6 0/8] Additional kmsg devices
Date: Fri, 26 Feb 2016 15:47:18 +0100
Message-ID: <20160226144718.GF3305@pathway.suse.cz>
References: <1456314801-32738-1-git-send-email-k.krosman@samsung.com>
 <20160225214714.GJ6092@mtj.duckdns.org>
 <56D051A2.6050106@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56D051A2.6050106@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kazimierz Krosman <k.krosman@samsung.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org, peter@hurleysoftware.com, vvs@virtuozzo.com, corbet@lwn.net, arnd@arndb.de, gregkh@linuxfoundation.org, daniel@zonque.org, kay.sievers@vrfy.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, k.lewandowsk@samsung.com, m.niesluchow@samsung.com, richard.weinberger@gmail.com, b.zolnierkie@samsung.com, luto@amacapital.net, knhoon.baik@samsung.com
List-Id: linux-api@vger.kernel.org

On Fri 2016-02-26 14:22:42, Kazimierz Krosman wrote:
> On 02/25/2016 10:47 PM, Tejun Heo wrote:
> >I'm not sure this is the right layer to implement generic logging
> >facility.
> In general this patches add only one feature- possibility of adding
> and deleting
> new kmsg devices, so I think that it can be treated as kmsg upgrade.
> >>2. Using kmsg can cause lower CPU utilisation in the real-word use case than
> >>>userspace logging mechanisms.
> >>>We created 2 tests: (1) 100 writer processes write to created kmsg buffer and
> >>>(2) 100 writers write to socket (stream)- there is one reader to protect
> >>>socket buffer against overflow. Tests show that cpu utilisation in case of first
> >>>test is about 2.3 times lower (39.1%) than it is in second case (87.7%) (measured
> >>>with top program; tests code is attached below). Tested on Odroid XU4.
> >This sounds like a generic IPC problem than anything else.
> 
> For the test purpose I've written two tests (attached in cover
> letter). I think that tests
> show that in this use case (multiple writers) system with additional
> kmsg devices
> consumes less CPU time than system which use sockets for logging.
> Logging system
> based on sockets needs read process, that continuously reads socket
> and protects
> against socket buffers overflow and messages drop. It is one of
> advantages of this
> solution: no maintenance.

Wait. The net addition of this patch set is 1755 lines out of it
526 lines seems to be in non-test code. You added another level
of complexity into the handling of the ring buffer(s). And it will
require no maintenance?


> Could you explain in more detail what did you mean by IPC problems?

I guess that the idea was to make IPC more effective in general.
You definitely could not move all functionality that needs IPC
into the kernel.

Best Regards,
Petr
