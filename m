From: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [RFC PATCH 1/1] arm64: Fix up /proc/cpuinfo
Date: Thu, 30 Oct 2014 17:15:22 +0000
Message-ID: <20141030171521.GL32589@arm.com>
References: <1414159000-27059-1-git-send-email-mark.rutland@arm.com>
 <1414159000-27059-2-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1414159000-27059-2-git-send-email-mark.rutland-5wv7dgnIgG8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, "ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "ijc-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org" <ijc-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Serban Constantinescu <Serban.Constantinescu-5wv7dgnIgG8@public.gmane.org>, "cross-distro-cunTk1MwBs8s++Sfvej+rw@public.gmane.org" <cross-distro-cunTk1MwBs8s++Sfvej+rw@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Mark,

On Fri, Oct 24, 2014 at 02:56:40PM +0100, Mark Rutland wrote:
> Commit d7a49086f263164a (arm64: cpuinfo: print info for all CPUs)
> attempted to clean up /proc/cpuinfo, but due to concerns regarding
> further changes was reverted in commit 5e39977edf6500fd (Revert "arm64:
> cpuinfo: print info for all CPUs").

I've applied this on our devel branch, with a view to queuing it for -next
in a week or two. I think we should also CC stable on this, so could you
see how far back it applies please? (note that I already had to resolve
a conflict with a patch we've got queued from Ard).

Cheers,

Will
