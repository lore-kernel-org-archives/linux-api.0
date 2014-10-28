From: Greg Hackmann <ghackmann@google.com>
Subject: Re: [RFC PATCH 0/1] arm64: Fix /proc/cpuinfo
Date: Mon, 27 Oct 2014 21:43:25 -0700
Message-ID: <CAJKQeMZu+E_j-O3+bAhQ2oN-9iuAe9RwfRAy87EiHzF0MVTEXA@mail.gmail.com>
References: <1414159000-27059-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1414159000-27059-1-git-send-email-mark.rutland@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, ijc@hellion.org.uk, Serban Constantinescu <serban.constantinescu@arm.com>, will.deacon@arm.com, cross-distro@lists.linaro.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Oct 24, 2014 at 6:56 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> [c] Print different hwcaps for compat tasks
>
>     This would allow for 32-bit and 64-bit applications to function
>     correctly. Having the format differ depending on the instruction set
>     of the application reading /proc/cpuinfo may be misleading in some
>     cases (e.g. a human using a 32-bit cat to read /proc/cpuinfo on a
>     64-bit system).

FWIW we have an Nvidia-contributed patch in the android-3.10 kernel
tree that basically does this.  It works well in almost all cases.

We've only found one situation so far where this approach falls apart.
One specific Android NDK app detects NEON support by running
"/system/bin/cat /proc/cpuinfo" in another process and searching for
the string "neon" in the output.  Even though the app itself is
32-bit, /system/bin/cat is 64-bit, so it reads the "wrong"
/proc/cpuinfo and decides the CPU doesn't support NEON.

>From Android's perspective, the only downside of using personalities
instead is that our runtime will need to ensure 32-bit apps have the
right personality.  Our runtime team has said they're fine with doing
this, if that's the direction the upstream kernel wants to go.

> Are there applications for which any of these strategies will not work?

We've found a handful of Android apps that expect the "CPU
architecture" field to be "7" specifically and get confused by the
existence of ARMv8.  There's not much you can do on the kernel side to
support those apps, other than lying about the CPU architecture to
32-bit apps (and we drew the line at doing that).
