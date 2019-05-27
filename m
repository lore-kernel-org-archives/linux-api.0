From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v2] mm: mlockall error for flag MCL_ONFAULT
Date: Mon, 27 May 2019 15:19:44 +0200
Message-ID: <7d5b948d-0253-e73e-980f-f6db5f92b461@suse.cz>
References: <20190527070415.GA1658@dhcp22.suse.cz>
 <20190527075333.GA6339@er01809n.ebgroup.elektrobit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190527075333.GA6339@er01809n.ebgroup.elektrobit.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Potyra, Stefan" <Stefan.Potyra@elektrobit.com>, Michal Hocko <mhocko@kernel.org>, Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Jordan, Tobias" <Tobias.Jordan@elektrobit.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 5/27/19 9:53 AM, Potyra, Stefan wrote:
> If mlockall() is called with only MCL_ONFAULT as flag,
> it removes any previously applied lockings and does
> nothing else.
> 
> This behavior is counter-intuitive and doesn't match the
> Linux man page.
> 
>   For mlockall():
> 
>   EINVAL Unknown  flags were specified or MCL_ONFAULT was specified with‐
>          out either MCL_FUTURE or MCL_CURRENT.
> 
> Consequently, return the error EINVAL, if only MCL_ONFAULT
> is passed. That way, applications will at least detect that
> they are calling mlockall() incorrectly.
> 
> Fixes: b0f205c2a308 ("mm: mlock: add mlock flags to enable VM_LOCKONFAULT usage")
> Signed-off-by: Stefan Potyra <Stefan.Potyra@elektrobit.com>
> Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
> Acked-by: Michal Hocko <mhocko@suse.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

Thanks, shame we didn't catch it during review. Hope nobody will report
a regression.

> ---
>  mm/mlock.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/mlock.c b/mm/mlock.c
> index e492a155c51a..03f39cbdd4c4 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -797,7 +797,8 @@ SYSCALL_DEFINE1(mlockall, int, flags)
>  	unsigned long lock_limit;
>  	int ret;
>  
> -	if (!flags || (flags & ~(MCL_CURRENT | MCL_FUTURE | MCL_ONFAULT)))
> +	if (!flags || (flags & ~(MCL_CURRENT | MCL_FUTURE | MCL_ONFAULT)) ||
> +	    flags == MCL_ONFAULT)
>  		return -EINVAL;
>  
>  	if (!can_do_mlock())
> 
