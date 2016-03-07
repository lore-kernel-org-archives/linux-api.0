From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: [PATCH v2] sparc64: Add support for Application Data Integrity
 (ADI)
Date: Mon, 07 Mar 2016 11:56:26 -0500 (EST)
Message-ID: <20160307.115626.807716799249471744.davem@davemloft.net>
References: <1456951177-23579-1-git-send-email-khalid.aziz@oracle.com>
	<20160305.230702.1325379875282120281.davem@davemloft.net>
	<56DD9949.1000106@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56DD9949.1000106-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: khalid.aziz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: corbet-T1hC0tSOHrs@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, dingel-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, zhenzhang.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, bob.picco-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rob.gardner-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, chris.hyser-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, xiexiuqi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Vineet.Gupta1-HKixBCOQz3hWk0Htik3J/w@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org, dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org, adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Khalid Aziz <khalid.aziz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Date: Mon, 7 Mar 2016 08:07:53 -0700

> PR_GET_SPARC_ADICAPS

Put this into a new ELF auxiliary vector entry via ARCH_DLINFO.

So now all that's left is supposedly the TAG stuff, please explain
that to me so I can direct you to the correct existing interface to
provide that as well.

Really, try to avoid prtctl, it's poorly typed and almost worse than
ioctl().
