From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf
 binaries
Date: Mon, 5 Mar 2018 18:13:19 -0800
Message-ID: <67abc3a2-80c9-7223-37c2-e15bbecdcd00@infradead.org>
References: <20180306013457.1955486-1-ast@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180306013457.1955486-1-ast@kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net
Cc: daniel@iogearbox.net, torvalds@linux-foundation.org, gregkh@linuxfoundation.org, mcgrof@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi,

On 03/05/2018 05:34 PM, Alexei Starovoitov wrote:

> diff --git a/kernel/module.c b/kernel/module.c
> index ad2d420024f6..6cfa35795741 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c

> @@ -3669,6 +3683,17 @@ static int load_module(struct load_info *info, const char __user *uargs,
>  	if (err)
>  		goto free_copy;
>  
> +	if (info->hdr->e_type == ET_EXEC) {
> +#ifdef CONFIG_MODULE_SIG
> +		if (!info->sig_ok) {
> +			pr_notice_once("umh %s verification failed: signature and/or required key missing - tainting kernel\n",

That's not a very friendly message to tell a user.  "umh" eh?

> +				       info->file->f_path.dentry->d_name.name);
> +			add_taint(TAINT_UNSIGNED_MODULE, LOCKDEP_STILL_OK);
> +		}

And since the signature failed, why is it being loaded at all?
Is this in the "--force" load path?

> +#endif
> +		return 0;
> +	}
> +
>  	/* Figure out module layout, and allocate all the memory. */
>  	mod = layout_and_allocate(info, flags);
>  	if (IS_ERR(mod)) {

thanks,
-- 
~Randy
