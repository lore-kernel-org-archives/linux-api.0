From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: Re: [PATCH 67/98]
 include/uapi/linux/netfilter/ipset/ip_set_bitmap.h: include
 linux/netfilter/ipset/ip_set.h
Date: Tue, 2 Jun 2015 22:42:16 +0300
Message-ID: <20150602194216.GT12550@lakka.kapsi.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
 <1433000370-19509-68-git-send-email-mikko.rapeli@iki.fi>
 <alpine.DEB.2.10.1505312014550.2712@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1505312014550.2712-K40Dz/62t/MgiyqX0sVFJYdd74u8MsAO@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jozsef Kadlecsik <kadlec-K40Dz/62t/MgiyqX0sVFJYdd74u8MsAO@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pablo Neira Ayuso <pablo-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org>, Patrick McHardy <kaber-dcUjhNyLwpNeoWH0uzbU5w@public.gmane.org>, netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, coreteam-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun, May 31, 2015 at 08:15:48PM +0200, Jozsef Kadlecsik wrote:
> On Sat, 30 May 2015, Mikko Rapeli wrote:
> 
> > Fixes userspace compilation error:
> > 
> > error: ?IPSET_ERR_TYPE_SPECIFIC? undeclared here (not in a function)
> >   IPSET_ERR_BITMAP_RANGE = IPSET_ERR_TYPE_SPECIFIC,
> 
> What kind of userspace compilation generates the error message above? How 
> can one reproduce it?

Here's the test which reproduces this https://lkml.org/lkml/2015/5/30/98

Should run on at least Debian based distributions and some cross compilers.
In the end the script generates a .c file which includes only this header file
and tries to compile it with a call like:

cc -Wall -c -nostdinc -I /usr/lib/gcc/i586-linux-gnu/4.9/include -I /usr/lib/gcc/i586-linux-gnu/4.9/include-fixed -I . -I ../headers_compile_test_include -I ../headers_compile_test_include/i586-linux-gnu ./linux/netfilter/ipset/ip_set_bitmap.c

-Mikko
