From: Petr Mladek <pmladek@suse.com>
Subject: Re: [RFC PATCH v4 2/6] module: preserve Elf information for
 livepatch modules
Date: Wed, 10 Feb 2016 16:53:13 +0100
Message-ID: <20160210155313.GI3305@pathway.suse.cz>
References: <1454548271-24923-1-git-send-email-jeyu@redhat.com>
 <1454548271-24923-3-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1454548271-24923-3-git-send-email-jeyu@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: Jessica Yu <jeyu@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, Jonathan Corbet <corbet@lwn.net>, Miroslav Benes <mbenes@suse.cz>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed 2016-02-03 20:11:07, Jessica Yu wrote:
> diff --git a/kernel/module.c b/kernel/module.c
> index 71c77ed..9c16eb2 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2676,6 +2764,23 @@ static int copy_module_from_user(const void __user *umod, unsigned long len,
>  	return 0;
>  }
>  
> +#ifdef CONFIG_LIVEPATCH
> +static int find_livepatch_modinfo(struct module *mod, struct load_info *info)
> +{
> +	mod->klp = get_modinfo(info, "livepatch") ? true : false;
> +
> +	return 0;
> +}
> +#else /* !CONFIG_LIVEPATCH */
> +static int find_livepatch_modinfo(struct module *mod, struct load_info *info)
> +{
> +	if (get_modinfo(info, "livepatch"))

One more thing. I suggest to write a friendly message here. For example:

	pr_err("LifePatch support is not available. Rejecting the module: s\n",
	       mod->name);

It might safe some debugging a poor user or developer.

> +		return -ENOEXEC;
> +
> +	return 0;
> +}
> +#endif /* CONFIG_LIVEPATCH */
> +

Best Regards,
Petr
