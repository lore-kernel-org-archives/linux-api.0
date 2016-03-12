From: Henrique de Moraes Holschuh <hmh-N3TV7GIv+o9fyO9Q7EP/yw@public.gmane.org>
Subject: Re: [PATCH v3] cpu-= command line parmeter, SYS_cpuid sys call,
 kernel-adjusted CPUID
Date: Sat, 12 Mar 2016 16:31:29 -0300
Message-ID: <20160312193129.GA27165@khazad-dum.debian.net>
References: <20160310212716.3711abfc@ultra.tux-net>
 <20160312021218.6005d5dc@ultra.tux-net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160312021218.6005d5dc-iCS8D82cxDOkYAyEuCb6Mw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Piotr Henryk Dabrowski <ultr-FYXd98AMhaE@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, 12 Mar 2016, Piotr Henryk Dabrowski wrote:
> Currently there is no way of disabling CPU features reported by the CPUID
> instruction. Which sometimes turn out to be broken [1] or undesired [2].

...

> * The kernel takes a command line parameter (cpu-=...) allowing for an easy way
>   to disable any of the known CPUID capability bits [3]. Plus the kernel may
>   disable certain features by itself as well.
> * Then the kernel provides a system call for obtaining the adjusted data [4]
>   (SYS_cpuid, to be used instead of the __cpuid* macros from GCC's cpuid.h).

Wouldn't it be better to (finally) extend the AT_HWCAP ELF stuff properly on
x86 for the missing cpuid levels?  Basically, get every cpuid leaf that
contributes to the /proc/cpuinfo "flags" field into new AT_HWCAPx ELF
fields? Some arches already have AT_HWCAP2, for example.  x86 would need
more than just AT_HWCAP2, though.

https://lwn.net/Articles/519085/
http://man7.org/linux/man-pages/man3/getauxval.3.html

AT_HWCAP is not only useful for LDSO tricks to load flag-optimized versions
of libraries, it is directly accessible to the process, so it could also be
used as an alternate source of cpuid() information that the kernel can
modify through quirks.

> Since the cpuid instruction is available from the user-space, use of SYS_cpuid
> cannot be enforced on programmers. But it can be encouraged. And having a

Indeed. Well, we already have it, but it is stuck in the past and gathering
cowebs.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
