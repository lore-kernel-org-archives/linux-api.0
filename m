From: Petr Mladek <pmladek@suse.com>
Subject: Re: [RFC PATCH v2 2/6] module: preserve Elf information for
 livepatch modules
Date: Thu, 17 Dec 2015 17:26:13 +0100
Message-ID: <20151217162613.GH3729@pathway.suse.cz>
References: <1448943679-3412-1-git-send-email-jeyu@redhat.com>
 <1448943679-3412-3-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1448943679-3412-3-git-send-email-jeyu@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: Jessica Yu <jeyu@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, Jonathan Corbet <corbet@lwn.net>, Miroslav Benes <mbenes@suse.cz>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon 2015-11-30 23:21:15, Jessica Yu wrote:
> For livepatch modules, copy Elf section, symbol, and string information
> from the load_info struct in the module loader.
> 
> Livepatch uses special relocation sections in order to be able to patch
> modules that are not yet loaded, as well as apply patches to the kernel
> when the addresses of symbols cannot be determined at compile time (for
> example, when kaslr is enabled). Livepatch modules must preserve Elf
> information such as section indices in order to apply the remaining
> relocation sections at the appropriate time (i.e. when the target module
> loads).
> 
> Signed-off-by: Jessica Yu <jeyu@redhat.com>
> ---
>  include/linux/module.h |  9 +++++
>  kernel/module.c        | 98 ++++++++++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 105 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 3a19c79..9b46256 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -425,6 +425,14 @@ struct module {
>  
>  	/* Notes attributes */
>  	struct module_notes_attrs *notes_attrs;
> +
> +	/* Elf information (optionally saved) */
> +	Elf_Ehdr *hdr;
> +	Elf_Shdr *sechdrs;
> +	char *secstrings;
> +	struct {
> +		unsigned int sym, str, mod, vers, info, pcpu;
> +	} index;
>  #endif

I would hide this into a structure. It is 3 pointers and 6 integers
that are mostly unused. I think about using a pointer to struct load_info
here. We could set the unused stuff to zero and NULL.

Any better idea how to share the definition with struct load_info
is welcome.

Best Regards,
Petr
