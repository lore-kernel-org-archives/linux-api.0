From: Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v5 1/6] Elf: add livepatch-specific Elf constants
Date: Mon, 21 Mar 2016 14:47:01 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1603211445500.12175@pobox.suse.cz>
References: <1458157628-8264-1-git-send-email-jeyu@redhat.com> <1458157628-8264-2-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1458157628-8264-2-git-send-email-jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 16 Mar 2016, Jessica Yu wrote:

> Livepatch manages its own relocation sections and symbols in order to be
> able to reuse module loader code to write relocations. This removes
> livepatch's dependence on separate "dynrela" sections to write relocations
> and also allows livepatch to patch modules that are not yet loaded.
> 
> The livepatch Elf relocation section flag (SHF_RELA_LIVEPATCH),
> and symbol section index (SHN_LIVEPATCH) allow both livepatch and the
> module loader to identity livepatch relocation sections and livepatch
> symbols.
> 
> Livepatch relocation sections are marked with SHF_RELA_LIVEPATCH to
> indicate to the module loader that it should not apply that relocation
> section and that livepatch will handle them.
> 
> The SHN_LIVEPATCH shndx marks symbols that will be resolved by livepatch.
> The module loader ignores these symbols and does not attempt to resolve
> them.
> 
> The values of these Elf constants were selected from OS-specific
> ranges according to the definitions from glibc.
> 
> Signed-off-by: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Reviewed-by: Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>
