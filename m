From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 18/24] Lock down module params that specify hardware
 parameters (eg. ioport)
Date: Wed, 11 Apr 2018 10:22:46 -0700
Message-ID: <17b6d3ad-367c-be6f-40d8-a9f60c7edae3@infradead.org>
References: <152346387861.4030.4408662483445703127.stgit@warthog.procyon.org.uk>
 <152346399627.4030.8043878470312297727.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <152346399627.4030.8043878470312297727.stgit@warthog.procyon.org.uk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org
Cc: linux-man@vger.kernel.org, linux-api@vger.kernel.org, jmorris@namei.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 04/11/2018 09:26 AM, David Howells wrote:
> Provided an annotation for module parameters that specify hardware
> parameters (such as io ports, iomem addresses, irqs, dma channels, fixed
> dma buffers and other types).
> 
> Suggested-by: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  kernel/params.c |   26 +++++++++++++++++++++-----
>  1 file changed, 21 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/params.c b/kernel/params.c
> index cc9108c2a1fd..2c08c4aa376b 100644
> --- a/kernel/params.c
> +++ b/kernel/params.c
> @@ -108,13 +108,19 @@ bool parameq(const char *a, const char *b)
>  	return parameqn(a, b, strlen(a)+1);
>  }
>  
> -static void param_check_unsafe(const struct kernel_param *kp)
> +static bool param_check_unsafe(const struct kernel_param *kp,
> +			       const char *doing)
>  {
>  	if (kp->flags & KERNEL_PARAM_FL_UNSAFE) {
>  		pr_warn("Setting dangerous option %s - tainting kernel\n",
>  			kp->name);
>  		add_taint(TAINT_USER, LOCKDEP_STILL_OK);
>  	}
> +
> +	if (kp->flags & KERNEL_PARAM_FL_HWPARAM &&
> +	    kernel_is_locked_down("Command line-specified device addresses, irqs and dma channels"))

s/dma/DMA/

Other patches use PCI instead of pci, CIS instead of cis, MMIO instead of mmio,
BPF instead of bpf, MSR instead of msr, etc...


> +		return false;
> +	return true;
>  }
>  
>  static int parse_one(char *param,


-- 
~Randy
