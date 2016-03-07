From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: [PATCH v2] sparc64: Add support for Application Data Integrity
 (ADI)
Date: Mon, 07 Mar 2016 14:22:45 -0500 (EST)
Message-ID: <20160307.142245.846579748692522977.davem@davemloft.net>
References: <56DDC47C.8010206@linux.intel.com>
	<56DDCAD3.3090106@oracle.com>
	<CALCETrVNM7ZcN7WnmLRMDqGrcYXn9xYWJfjMVwFLdiQS63-TcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrVNM7ZcN7WnmLRMDqGrcYXn9xYWJfjMVwFLdiQS63-TcA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org
Cc: khalid.aziz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, rob.gardner-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, dingel-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, bob.picco-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, chris.hyser-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, xiexiuqi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Vineet.Gupta1-HKixBCOQz3hWk0Htik3J/w@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org, dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org, adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Date: Mon, 7 Mar 2016 10:53:23 -0800

> x86 has an upcoming feature called protection keys.  A page of virtual
> memory has a protection key, which is a number from 0 through 16.  The
> master copy is in the PTE, i.e. page table entry, which is a
> software-managed data structure in memory and is exactly the thing
> that Linux calls "pte".  The processor can cache that value in the TLB
> (translation lookaside buffer), which is a hardware cache that caches
> PTEs.  On access to a page of virtual memory, the processor does a
> certain calculation involving a new register called PKRU and the
> protection key and may deny access.

ADI is similar, except the "keys" (or "tags") are stored externally
rather than in the PTEs.  A bit in the PTE is used to enable tag match
checking.

The tags live in an external table, which is populated by ASI store
instructions.  The location of the table is implementation specific,
it could be hypervisor or CPU managed, but if stored in memory it is
to a region of memory accessible only to the hypervisor at best.

Khalid, maybe you should share notes with the folks working on x86
protection keys.
