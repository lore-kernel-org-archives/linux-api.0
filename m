From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: [PATCH v2] sparc64: Add support for Application Data Integrity
 (ADI)
Date: Mon, 07 Mar 2016 15:58:10 -0500 (EST)
Message-ID: <20160307.155810.587016604208120674.davem@davemloft.net>
References: <56DDDA31.9090105@oracle.com>
	<CALCETrXXU0fs2ezq+Wn_kr4dZTO=0RJmt6b=XBSA-wM7W_9j9A@mail.gmail.com>
	<56DDE783.8090009@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56DDE783.8090009-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: khalid.aziz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, dingel-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, bob.picco-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rob.gardner-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, chris.hyser-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, xiexiuqi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Vineet.Gupta1-HKixBCOQz3hWk0Htik3J/w@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org, dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org, adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Khalid Aziz <khalid.aziz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Date: Mon, 7 Mar 2016 13:41:39 -0700

> Shared data may not always be backed by a file. My understanding is
> one of the use cases is for in-memory databases. This shared space
> could also be used to hand off transactions in flight to other
> processes. These transactions in flight would not be backed by a
> file. Some of these use cases might not use shmfs even. Setting ADI
> bits at virtual address level catches all these cases since what backs
> the tagged virtual address can be anything - a mapped file, mmio
> space, just plain chunk of memory.

Frankly the most interesting use case to me is simply finding bugs
and memory scribbles, and for that we're want to be able to ADI
arbitrary memory returned from malloc() and friends.

I personally see ADI more as a debugging than a security feature,
but that's just my view.
