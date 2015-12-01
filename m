From: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: module: preserve Elf information for livepatch modules
Date: Tue, 1 Dec 2015 03:48:59 -0500
Message-ID: <20151201084858.GB3974@packer-debian-8-amd64.digitalocean.com>
References: <1448943679-3412-1-git-send-email-jeyu@redhat.com>
 <1448943679-3412-3-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1448943679-3412-3-git-send-email-jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

+++ Jessica Yu [30/11/15 23:21 -0500]:
>For livepatch modules, copy Elf section, symbol, and string information
>from the load_info struct in the module loader.
>
>Livepatch uses special relocation sections in order to be able to patch
>modules that are not yet loaded, as well as apply patches to the kernel
>when the addresses of symbols cannot be determined at compile time (for
>example, when kaslr is enabled). Livepatch modules must preserve Elf
>information such as section indices in order to apply the remaining
>relocation sections at the appropriate time (i.e. when the target module
>loads).
>
>Signed-off-by: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>---
> include/linux/module.h |  9 +++++
> kernel/module.c        | 98 ++++++++++++++++++++++++++++++++++++++++++++++++--
> 2 files changed, 105 insertions(+), 2 deletions(-)
>
>diff --git a/include/linux/module.h b/include/linux/module.h
>index 3a19c79..9b46256 100644
>--- a/include/linux/module.h
>+++ b/include/linux/module.h
>@@ -425,6 +425,14 @@ struct module {
>
> 	/* Notes attributes */
> 	struct module_notes_attrs *notes_attrs;
>+
>+	/* Elf information (optionally saved) */
>+	Elf_Ehdr *hdr;
>+	Elf_Shdr *sechdrs;
>+	char *secstrings;
>+	struct {
>+		unsigned int sym, str, mod, vers, info, pcpu;
>+	} index;
> #endif
>
> 	/* The command line arguments (may be mangled).  People like
>@@ -461,6 +469,7 @@ struct module {
> #endif
>
> #ifdef CONFIG_LIVEPATCH
>+	bool klp; /* Is this a livepatch module? */

Gah. I believe this field should be outside the #ifdef. 

Jessica
