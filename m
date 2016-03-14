From: Piotr Henryk Dabrowski <ultr-FYXd98AMhaE@public.gmane.org>
Subject: Re: [PATCH v3] cpu-= command line parmeter, SYS_cpuid sys call,
 kernel-adjusted CPUID
Date: Mon, 14 Mar 2016 17:06:19 +0100
Message-ID: <20160314170619.5afe15f0@ultra.tux-net>
References: <20160310212716.3711abfc@ultra.tux-net>
	<20160312021218.6005d5dc@ultra.tux-net>
	<20160312193129.GA27165@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160312193129.GA27165-ZGHd14iZgfaRjzvQDGKj+xxZW9W5cXbT@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Henrique de Moraes Holschuh <hmh-N3TV7GIv+o9fyO9Q7EP/yw@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Piotr Henryk Dabrowski <ultr-FYXd98AMhaE@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Henrique de Moraes Holschuh <hmh@*****> writes:

> Wouldn't it be better to (finally) extend the AT_HWCAP ELF stuff properly on
> x86 for the missing cpuid levels?  Basically, get every cpuid leaf that
> contributes to the /proc/cpuinfo "flags" field into new AT_HWCAPx ELF
> fields? Some arches already have AT_HWCAP2, for example.  x86 would need
> more than just AT_HWCAP2, though.

man 3 getauxval: "The contents of the bit mask are hardware dependent (for
example, see the kernel source file arch/x86/include/asm/cpufeature.h for
details relating to the Intel x86 architecture)." [1]

IMHO this doesn't seem like a solution anyone in the userland would like to
port their __cpuid based code to.

1. Bits in the kernel are totally incompatible with those returned by __cpuid.
So for a portable application this requires including yet another header file
for the new set of bits. Which comes with kernel headers only, resulting in
people probably hard-copying it into their source code instead of requiring
this dependency.

2. Developers will need to add a totally different implementation alongside
with the fallback __cpuid call into their programs. And, as mentioned above,
test the bits separately as well.
Meanwhile the cpuid syscall/vdso the way it is proposed (having identical
syntax) requires just one additional condition before fallback __cpuid [2]
(plus a simple #ifndef to support non-Linux OSes). The entire remaining code
stays the same.

3. Kernel leafs are arbitrarily chosen and composed into an internal array
mixing every possible op/count call and register together [3].
While the __cpuid bits correspond to the output of the CPU hardware that is
well documented, kernel bits are just arbitrarily assigned indexes for a
private internal array in the kernel source. Even the kernel uses macros to
check/disable specific features to hide this fact.
IMO this array should never ever be exposed outside of the kernel source, at
least the way it is now.

If we want this feature to be respected and incorporated into every program,
then I think we should really make sure it is easy to switch to.

> AT_HWCAP is not only useful for LDSO tricks to load flag-optimized versions
> of libraries, it is directly accessible to the process, so it could also be
> used as an alternate source of cpuid() information that the kernel can
> modify through quirks.

Instead/alongside the syscall a vdso function can be implemented resulting in
exactly the same benefit.

And if we are thinking of ignoring the __cpuid way and creating a completely
new and portable API/ABI, then something better than constantly expanding
AT_HWCAPx internal arrays is needed.
Maybe a fast vdso function for checking for CPU features by their names, like:
    int __vdso_cpu_has_feature(char *feature_name);
Something that encourages programmers to use it instead of scaring them away.

> Indeed. Well, we already have it, but it is stuck in the past and gathering
> cowebs.

Still a cpu-= equivalent in the command line is required to let users disable
all the features they do not want to be reported.


[1] http://man7.org/linux/man-pages/man3/getauxval.3.html
[2]
    unsigned int eax = 0, ebx = 0, ecx = 0, edx = 0;
    if (syscall(SYS_cpuid, level, count, &eax, &ebx, &ecx, &edx) != 0)
        __cpuid_count(level, count, eax, ebx, ecx, edx);
[3]
    enum cpuid_leafs
    {
        CPUID_00000001_0_EDX	= 0,
        CPUID_80000001_0_EDX,
        CPUID_80860001_0_EDX,
        CPUID_LNX_1,
        CPUID_00000001_0_ECX,
        CPUID_C0000001_0_EDX,
        CPUID_80000001_0_ECX,
        CPUID_LNX_2,
        CPUID_LNX_3,
        CPUID_00000007_0_EBX,
        CPUID_0000000D_1_EAX,
        CPUID_0000000F_0_EDX,
        CPUID_0000000F_1_EDX,
        CPUID_80000008_0_EBX,
        CPUID_00000006_0_EAX,
        CPUID_8000000A_0_EDX,
        CPUID_00000007_0_ECX,
    };


Regards,
Piotr Henryk Dabrowski
