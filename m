From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [RFC PATCH 0/1] arm64: Fix /proc/cpuinfo
Date: Thu, 6 Nov 2014 16:43:12 +0000
Message-ID: <20141106164311.GD19702@e104818-lin.cambridge.arm.com>
References: <1414159000-27059-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <cross-distro-bounces-cunTk1MwBs8s++Sfvej+rw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1414159000-27059-1-git-send-email-mark.rutland-5wv7dgnIgG8@public.gmane.org>
List-Unsubscribe: <http://lists.linaro.org/mailman/options/cross-distro>,
 <mailto:cross-distro-request-cunTk1MwBs8s++Sfvej+rw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linaro.org/pipermail/cross-distro>
List-Post: <mailto:cross-distro-cunTk1MwBs8s++Sfvej+rw@public.gmane.org>
List-Help: <mailto:cross-distro-request-cunTk1MwBs8s++Sfvej+rw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linaro.org/mailman/listinfo/cross-distro>,
 <mailto:cross-distro-request-cunTk1MwBs8s++Sfvej+rw@public.gmane.org?subject=subscribe>
Errors-To: cross-distro-bounces-cunTk1MwBs8s++Sfvej+rw@public.gmane.org
Sender: cross-distro-bounces-cunTk1MwBs8s++Sfvej+rw@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: "cross-distro-cunTk1MwBs8s++Sfvej+rw@public.gmane.org" <cross-distro-cunTk1MwBs8s++Sfvej+rw@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Serban Constantinescu <Serban.Constantinescu-5wv7dgnIgG8@public.gmane.org>, Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 24, 2014 at 02:56:39PM +0100, Mark Rutland wrote:
> Currently, the arm64 /proc/cpuinfo format differs from that of arm, in a
> manner which prevents some otherwise portable applications from
> functioning as expected. Specifically, the "Features" line describes the
> 64-bit hwcaps exclusive of the 32-bit hwcaps, which causes issues for
> certain applications which attempt to parse /proc/cpuinfo to detect
> features rather than directly using the hwcaps exposed via auxval.
> 
> Additionally, the arm64 /proc/cpuinfo format only provides identifying
> information for a single CPU (unlike 32-bit), which is problematic for
> systems with heterogeneous CPUs (i.e. big.LITTLE).
> 
> This patch attempts to solve both issues.

I'm perfectly fine with the heterogeneous CPUs part.

> I believe the contentious part
> is what to do with the Features line, and for that there are a number of
> possibilities:
> 
> [a] Only print the 64-bit hwcaps
> 
>     This would match our current behaviour. However certain 32-bit
>     applications will not detect CPU features correctly, and could fail
>     to launch. The appropriate hwcaps are available in auxval, but this
>     will not be of help to existing binaries.
> 
> [b] Append the 64-bit and 32-bit hwcaps
> 
>     This would allow for a consistent format. However, some
>     human-readable hwcap names have been reused for analogous
>     instruction set features (e.g. "aes") despite 32-bit and 64-bit
>     instruction set support being largely unrelated per the
>     architecture. This could lead to applications mis-detecting
>     instruction set support on some CPUs in future, and may be
>     misleading to a casual reader.

The only overlap between 32 and 64-bit is aes, pmull, sha1, sha2, crc32.
An ARMv8 CPU implementing both AArch32 and AArch64 will likely support
these extensions in both modes. However, "likely" is not enough and we
need to get some confirmation from the architecture people. If that's
the case, point [b] is not too bad.

> [c] Print different hwcaps for compat tasks
> 
>     This would allow for 32-bit and 64-bit applications to function
>     correctly. Having the format differ depending on the instruction set
>     of the application reading /proc/cpuinfo may be misleading in some
>     cases (e.g. a human using a 32-bit cat to read /proc/cpuinfo on a
>     64-bit system).

Long time ago we decided that "uname -m" would report "aarch64"
independent of whether it is compat or not. That's the case for x86 as
well, you need PER_LINUX32 to report the actual compat UTS name.

> [d] Print different hwcaps dependent on the personality.
> 
>     This would allow for 32-bit and 64-bit applications to function
>     correctly, but for some 32-bit applications the personality would
>     need to be set explicitly by the user.

Which makes this option actually in line with the uname -m behaviour. My
vote goes for [d] with option [b] as a close alternative.

> [1] arm, v3.17, Versatile Express A15x2 A7x3 coretile
> Features        : half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm 
[...]
> [2] arm64, v3.17, Juno platform
> Features        : fp asimd evtstrm aes pmull sha1 sha2 crc32 

As an exercise, I'm trying to see what option [b] would look like when
CONFIG_COMPAT is enabled:

Features        : fp asimd evtstrm aes pmull sha1 sha2 crc32 half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae

The duplicate strings would only be listed once (evtstrm, aes, pmull,
sha1, sha2, crc32). New AArch64 features that we may expect to be
optional on AArch32 could be prefixed with "a64". If they are missing
entirely from AArch32, (like asimd), no need for the prefix.

The advantage is that we don't need to check the personality but we have
to assume that scripts would not search for substrings (sane people
shouldn't do this anyway as the Features string can always be extended).

-- 
Catalin
