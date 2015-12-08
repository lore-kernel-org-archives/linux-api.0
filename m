From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [RFC PATCH v2 5/6] samples: livepatch: init reloc section array
 and mark as klp module
Date: Tue, 8 Dec 2015 12:41:03 -0600
Message-ID: <20151208184103.GD14846@treble.redhat.com>
References: <1448943679-3412-1-git-send-email-jeyu@redhat.com>
 <1448943679-3412-6-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1448943679-3412-6-git-send-email-jeyu@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: Jessica Yu <jeyu@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, Jonathan Corbet <corbet@lwn.net>, Miroslav Benes <mbenes@suse.cz>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Nov 30, 2015 at 11:21:18PM -0500, Jessica Yu wrote:
> Create the array of klp relocation sections in the sample
> klp_object (even if the array is empty in this case).
> 
> In addition, mark the module as a livepatch module so that
> the module loader can appropriately identify and initialize it.
> 
> Signed-off-by: Jessica Yu <jeyu@redhat.com>
> ---
>  samples/livepatch/livepatch-sample.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/samples/livepatch/livepatch-sample.c b/samples/livepatch/livepatch-sample.c
> index fb8c861..298dc21 100644
> --- a/samples/livepatch/livepatch-sample.c
> +++ b/samples/livepatch/livepatch-sample.c
> @@ -53,10 +53,15 @@ static struct klp_func funcs[] = {
>  	}, { }
>  };
>  
> +static struct klp_reloc_sec reloc_secs[] = {
> +	{ }
> +};
> +

I think it's not possible to specify the relocations when building the
patch module in this way, right?  If so, I think this is confusing, and
it would be better to just leave out any mention of reloc_secs in the
sample module.

>  static struct klp_object objs[] = {
>  	{
>  		/* name being NULL means vmlinux */
>  		.funcs = funcs,
> +		.reloc_secs = reloc_secs,
>  	}, { }
>  };
>  
> @@ -89,3 +94,4 @@ static void livepatch_exit(void)
>  module_init(livepatch_init);
>  module_exit(livepatch_exit);
>  MODULE_LICENSE("GPL");
> +MODULE_INFO(livepatch, "Y");
> -- 
> 2.4.3
> 

-- 
Josh
