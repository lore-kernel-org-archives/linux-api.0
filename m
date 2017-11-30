From: John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH v2] mmap.2: document new MAP_FIXED_SAFE flag
Date: Thu, 30 Nov 2017 10:31:12 -0800
Message-ID: <1a96e274-a986-12b7-6e47-fc6355cbf637@nvidia.com>
References: <20171129144219.22867-1-mhocko@kernel.org>
 <20171129144524.23518-1-mhocko@kernel.org>
 <20171130082405.b77eknaiblgmpa4s@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20171130082405.b77eknaiblgmpa4s@dhcp22.suse.cz>
Content-Language: en-US
Sender: linux-arch-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>
Cc: linux-api@vger.kernel.org, Khalid Aziz <khalid.aziz@oracle.com>, Michael Ellerman <mpe@ellerman.id.au>, Andrew Morton <akpm@linux-foundation.org>, Russell King - ARM Linux <linux@armlinux.org.uk>, Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Florian Weimer <fweimer@redhat.com>
List-Id: linux-api@vger.kernel.org

On 11/30/2017 12:24 AM, Michal Hocko wrote:
> Updated version based on feedback from John.
> ---
> From ade1eba229b558431581448e7d7838f0e1fe2c49 Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko@suse.com>
> Date: Wed, 29 Nov 2017 15:32:08 +0100
> Subject: [PATCH] mmap.2: document new MAP_FIXED_SAFE flag
> 
> 4.16+ kernels offer a new MAP_FIXED_SAFE flag which allows the caller to
> atomicaly probe for a given address range.
> 
> [wording heavily updated by John Hubbard <jhubbard@nvidia.com>]
> Signed-off-by: Michal Hocko <mhocko@suse.com>
> ---
>  man2/mmap.2 | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/man2/mmap.2 b/man2/mmap.2
> index 385f3bfd5393..923bbb290875 100644
> --- a/man2/mmap.2
> +++ b/man2/mmap.2
> @@ -225,6 +225,22 @@ will fail.
>  Because requiring a fixed address for a mapping is less portable,
>  the use of this option is discouraged.
>  .TP
> +.BR MAP_FIXED_SAFE " (since Linux 4.16)"
> +Similar to MAP_FIXED with respect to the
> +.I
> +addr
> +enforcement, but different in that MAP_FIXED_SAFE never clobbers a pre-existing
> +mapped range. If the requested range would collide with an existing
> +mapping, then this call fails with
> +.B EEXIST.
> +This flag can therefore be used as a way to atomically (with respect to other
> +threads) attempt to map an address range: one thread will succeed; all others
> +will report failure. Please note that older kernels which do not recognize this
> +flag will typically (upon detecting a collision with a pre-existing mapping)
> +fall back a "non-MAP_FIXED" type of behavior: they will return an address that

...and now I've created my own typo: please make that "fall back to a"  (the 
"to" was missing).

Sorry about the churn. It turns out that the compiler doesn't catch these. :)

thanks,
John Hubbard


> +is different than the requested one. Therefore, backward-compatible software
> +should check the returned address against the requested address.
> +.TP
>  .B MAP_GROWSDOWN
>  This flag is used for stacks.
>  It indicates to the kernel virtual memory system that the mapping
> @@ -449,6 +465,12 @@ is not a valid file descriptor (and
>  .B MAP_ANONYMOUS
>  was not set).
>  .TP
> +.B EEXIST
> +range covered by
> +.IR addr ,
> +.IR length
> +is clashing with an existing mapping.
> +.TP
>  .B EINVAL
>  We don't like
>  .IR addr ,
> 
