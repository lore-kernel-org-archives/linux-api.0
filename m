From: Miroslav Benes <mbenes@suse.cz>
Subject: Re: [RFC PATCH v2 2/6] module: preserve Elf information for livepatch
 modules
Date: Wed, 16 Dec 2015 11:58:53 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1512161156290.25787@pobox.suse.cz>
References: <1448943679-3412-1-git-send-email-jeyu@redhat.com> <1448943679-3412-3-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1448943679-3412-3-git-send-email-jeyu@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: Jessica Yu <jeyu@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, Jonathan Corbet <corbet@lwn.net>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, 30 Nov 2015, Jessica Yu wrote:

> @@ -3530,6 +3614,16 @@ static int load_module(struct load_info *info, const char __user *uargs,
>  	if (err < 0)
>  		goto bug_cleanup;
>  
> +	/*
> +	 * Save sechdrs, indices, and other data from info
> +	 * in order to patch to-be-loaded modules.
> +	 * Do not call free_copy() for livepatch modules.
> +	 */
> +	if (mod->klp)
> +		err = copy_module_elf(mod, info);
> +	if (err < 0)
> +		goto bug_cleanup;
> +

I think goto bug_cleanup is not sufficient. Just before this hunk sysfs is 
created. So in case of error here we should call mod_sysfs_teardown() or 
something before going to bug_cleanup. That is new error label is needed 
before bug_cleanup. Correct?

Miroslav
