From: Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>
Subject: Re: [PATCH 6/9] x86, pkeys: add pkey set/get syscalls
Date: Fri, 8 Jul 2016 09:32:07 -0700
Message-ID: <577FD587.6050101@sr71.net>
References: <20160707124719.3F04C882@viggo.jf.intel.com>
 <20160707124728.C1116BB1@viggo.jf.intel.com>
 <20160707144508.GZ11498@techsingularity.net> <577E924C.6010406@sr71.net>
 <20160708071810.GA27457@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160708071810.GA27457-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 07/08/2016 12:18 AM, Ingo Molnar wrote:
> So the question is, what is user-space going to do? Do any glibc
> patches exist? How are the user-space library side APIs going to look
> like?

My goal at the moment is to get folks enabled to the point that they can
start modifying apps to use pkeys without having to patch their kernels.
 I don't have confidence that we can design good high-level userspace
interfaces without seeing some real apps try to use the low-level ones
and seeing how they struggle.

I had some glibc code to do the pkey alloc/free operations, but those
aren't necessary if we're doing it in the kernel.  Other than getting
the syscall wrappers in place, I don't have any immediate plans to do
anything in glibc.

Was there something you were expecting to see?
