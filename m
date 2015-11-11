From: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH 4/5] samples: livepatch: init reloc list and mark as
 klp module
Date: Wed, 11 Nov 2015 16:42:49 +0100
Message-ID: <20151111154249.GQ2599@pathway.suse.cz>
References: <1447130755-17383-1-git-send-email-jeyu@redhat.com>
 <1447130755-17383-5-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1447130755-17383-5-git-send-email-jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon 2015-11-09 23:45:54, Jessica Yu wrote:
> Intialize the list of relocation sections in the sample
> klp_object (even if the list will be empty in this case).
> Also mark module as a livepatch module so that the module
> loader can appropriately initialize it.
> 
> Signed-off-by: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  samples/livepatch/livepatch-sample.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/samples/livepatch/livepatch-sample.c b/samples/livepatch/livepatch-sample.c
> index fb8c861..2ef9345 100644
> --- a/samples/livepatch/livepatch-sample.c
> +++ b/samples/livepatch/livepatch-sample.c
> @@ -89,3 +90,4 @@ static void livepatch_exit(void)
>  module_init(livepatch_init);
>  module_exit(livepatch_exit);
>  MODULE_LICENSE("GPL");
> +MODULE_INFO(livepatch, "Y");

This looks a bit error prone. I wonder if we could detect this
information another way. For example, by a check for the
livepatch-related elf sections. If it is missing,
we do not need to preserve struct load_info even
when it is a livepatch.

Best Regards,
Petr
