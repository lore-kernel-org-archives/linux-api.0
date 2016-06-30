From: Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>
Subject: Re: [PATCH 0/9] [v3] System Calls for Memory Protection Keys
Date: Thu, 30 Jun 2016 09:46:34 -0700
Message-ID: <57754CEA.6070900@sr71.net>
References: <20160609000117.71AC7623@viggo.jf.intel.com>
 <20160630094123.GA29268@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160630094123.GA29268-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 06/30/2016 02:41 AM, Ingo Molnar wrote:
> * Dave Hansen <dave-gkUM19QKKo4@public.gmane.org> wrote:
>> Are there any concerns with merging these into the x86 tree so
>> that they go upstream for 4.8?  The updates here are pretty
>> minor.
> 
>>  include/linux/pkeys.h                         |   39 +-
>>  include/uapi/asm-generic/mman-common.h        |    5 +
>>  include/uapi/asm-generic/unistd.h             |   12 +-
>>  mm/mprotect.c                                 |  134 +-
> 
> So I'd love to have some high level MM review & ack for these syscall ABI 
> extensions.

That's a quite reasonable request, but I'm really surprised by it at
this point.  The proposed ABI is one very straightforward extension to
one existing system call, plus four others that you personally suggested.

They haven't *changed* since last November:

	http://lkml.iu.edu/hypermail/linux/kernel/1511.2/00985.html

I see you added Mel and Hugh to the cc.  Is that who you'd like to see
review it?  Is there anyone else?  I'd expect Mel and Hugh's review time
to be highly contended, and I'd rather not gate these on them.

If it helps anyone review these more easily, I've html-ized the affected
manpages and published them:

	https://www.sr71.net/~dave/intel/manpages/
