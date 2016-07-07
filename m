From: Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>
Subject: Re: [PATCH 0/9] [REVIEW-REQUEST] [v4] System Calls for Memory
 Protection Keys
Date: Thu, 7 Jul 2016 15:47:21 +0100
Message-ID: <20160707144721.GA11498@techsingularity.net>
References: <20160707124719.3F04C882@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160707124719.3F04C882-LXbPSdftPKxrdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Jul 07, 2016 at 05:47:19AM -0700, Dave Hansen wrote:
> I'm resending these because Ingo has said that he'd "love to have
> some high level MM review & ack for these syscall ABI extensions."
> The only changes to the code in months have been in the selftests.
> So, if anyone has been putting off taking a look at these, I'd
> appreciate a look now.
> 

I took a look at the patches other than the self-tests and the
documentation. I did not see any major problems other than thinking
there is a lot of ways for userspace to shoot itself in the foot and
lose the protection pkeys is meant to give.

That said, consider the review to be unreliable on the grounds I haven't
followed pkeys development and this is my first time looking in its
general direction.

-- 
Mel Gorman
SUSE Labs
