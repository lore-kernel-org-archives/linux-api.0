From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC][PATCH 0/7] System Calls for Memory Protection Keys
Date: Thu, 3 Mar 2016 09:05:06 +0100
Message-ID: <CAKgNAkjaZvR-Csf5eEBVi+Eo1HjeXH7Kg0LUL=i1Q-HAJ1EP-A@mail.gmail.com>
References: <20160223011107.FB9B8215@viggo.jf.intel.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160223011107.FB9B8215-LXbPSdftPKxrdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>
Cc: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Dave,

On 23 February 2016 at 02:11, Dave Hansen <dave-gkUM19QKKo4@public.gmane.org> wrote:
> As promised, here are the proposed new Memory Protection Keys
> interfaces.  These interfaces make it possible to do something
> with pkeys other than execute-only support.
>
> There are 5 syscalls here.  I'm hoping for reviews of this set
> which can help nail down what the final interfaces will be.
>
> You can find a high-level overview of the feature and the new
> syscalls here:
>
>         https://www.sr71.net/~dave/intel/pkeys.txt

(That's pretty thin...)

> ===============================================================
>
> To use memory protection keys (pkeys), an application absolutely
> needs to be able to set the pkey field in the PTE (obviously has
> to be done in-kernel) and make changes to the "rights" register
> (using unprivileged instructions).
>
> An application also needs to have an an allocator for the keys
> themselves.  If two different parts of an application both want
> to protect their data with pkeys, they first need to know which
> key to use for their individual purposes.
>
> This set introduces 5 system calls, in 3 logical groups:
>
> 1. PTE pkey setting (sys_pkey_mprotect(), patches #1-3)
> 2. Key allocation (sys_pkey_alloc() / sys_pkey_free(), patch #4)
> 3. Rights register manipulation (sys_pkey_set/get(), patch #5)
>
> These patches build on top of "core" support already in the tip tree,
> specifically 62b5f7d013, which can currently be found at:
>
>         http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/log/?h=mm/pkeys
>
> I have manpages written for some of these syscalls, and I will
> submit a full set of manpages once we've reached some consensus
> on what the interfaces should be.

Please don't do things in this order. Providing man pages up front
make it easier for people to understand, review, and critique the API.
Submitting man pages should be a foundational part of submitting a new
set of interfaces and discussing their design.

Thanks,

Michael
