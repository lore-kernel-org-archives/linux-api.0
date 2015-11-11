From: Petr Mladek <pmladek@suse.com>
Subject: Re: [RFC PATCH 3/5] livepatch: reuse module loader code to write
 relocations
Date: Wed, 11 Nov 2015 16:22:57 +0100
Message-ID: <20151111152256.GP2599@pathway.suse.cz>
References: <1447130755-17383-1-git-send-email-jeyu@redhat.com>
 <1447130755-17383-4-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1447130755-17383-4-git-send-email-jeyu@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jessica Yu <jeyu@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, Miroslav Benes <mbenes@suse.cz>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon 2015-11-09 23:45:53, Jessica Yu wrote:
> Reuse module loader code to write relocations, thereby eliminating the
> need for architecture specific code in livepatch. Namely, we reuse
> apply_relocate_add() in the module loader to write relocs instead of
> duplicating functionality in livepatch's klp_write_module_reloc(). To
> apply relocation sections, remaining SHN_LIVEPATCH symbols referenced by
> relocs are resolved and then apply_relocate_add() is called to apply
> those relocations.
> 
> Signed-off-by: Jessica Yu <jeyu@redhat.com>
> ---
>  include/linux/livepatch.h | 11 ++++--
>  include/linux/module.h    |  6 ++++
>  kernel/livepatch/core.c   | 89 +++++++++++++++++++++++++++++------------------
>  3 files changed, 70 insertions(+), 36 deletions(-)
> 
> index 087a8c7..26c419f 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -28,6 +28,8 @@
>  #include <linux/list.h>
>  #include <linux/kallsyms.h>
>  #include <linux/livepatch.h>
> +#include <linux/elf.h>
> +#include <asm/cacheflush.h>
>  
>  /**
>   * struct klp_ops - structure for tracking registered ftrace ops structs
> @@ -281,46 +283,54 @@ static int klp_find_external_symbol(struct module *pmod, const char *name,
>  }
>  
>  static int klp_write_object_relocations(struct module *pmod,
> -					struct klp_object *obj)
> +					struct klp_object *obj,
> +					struct klp_patch *patch)
>  {
[...]

> +
> +	/* For each __klp_rela section for this object */
> +	list_for_each_entry(reloc_sec, &obj->reloc_secs, list) {

Who, when, and how will define reloc_secs, please?

I guess that it is just an optimization. It helps to avoid going
through all elf sections of all livepatch modules. Therefore, I think
that we might fill this when the livepatch module is loaded. But
I do not see the code for this.

Best Regards,
Petr
