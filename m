From: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
Subject: Re: [PATCH v2 00/23] netoops support
Date: Tue, 09 Nov 2010 02:28:26 +0100
Message-ID: <87k4knqo91.fsf@basil.nowhere.org>
References: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101108203120.22479.19708.stgit-+dUuAhMFdFN6FDdRrpk8kO4/NqBCd+6Q@public.gmane.org> (Mike
	Waychison's message of "Mon, 08 Nov 2010 12:31:36 -0800")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: simon.kagstrom-vI6UBbBVNY+JA8cjQkG2/g@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>, adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, chavey-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> writes:

I'm still not fully convinced this needs to be a fully separate
mechanism from netconsole.  It seems a lot of work to implement
basically log level.

Maybe netconsole could be patched to support only dumping KERN_EMERG?

But I guess the structured logging has some advantages, although
there have been certainly oops parsers (e.g. kerneloops.org) without it.

>    * I am _NOT_ happy with the remaining userland ABIs presented in this
>      patchset.  Specifically the files "net_dump_now",
>      "net_dump_one_shot", "netdump_fw_version", "netdump_board_name"
>      and

fw_version and board_name is known by the kernel anyways through the DMI
interface, assuming the BIOS supplies that.  We also dump it already
on a standard oops. So why not just use that directly?

As a general user ABI perhaps simply an unstructured string is better
that is included in the packet.

-Andi

-- 
ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org -- Speaking for myself only.
