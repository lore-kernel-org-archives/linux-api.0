From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 01/24] Add the ability to lock down access to the running
 kernel image
Date: Wed, 11 Apr 2018 18:44:54 +0200
Message-ID: <CAG48ez3U3pf4O8Yc1y-+T=Dcc-N-KP0Zd_1GS44p--zxockJ1Q@mail.gmail.com>
References: <152346387861.4030.4408662483445703127.stgit@warthog.procyon.org.uk>
 <152346388583.4030.15146667041427303547.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <152346388583.4030.15146667041427303547.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-man <linux-man@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, James Morris <jmorris@namei.org>, kernel list <linux-kernel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 11, 2018 at 6:24 PM, David Howells <dhowells@redhat.com> wrote:
> Provide a single call to allow kernel code to determine whether the system
> should be locked down, thereby disallowing various accesses that might
> allow the running kernel image to be changed, including:
>
>  - /dev/mem and similar
>  - Loading of unauthorised modules
>  - Fiddling with MSR registers
>  - Suspend to disk managed by the kernel
>  - Use of device DMA
>
> Two kernel configuration options are provided:
>
>  (*) CONFIG_LOCK_DOWN_KERNEL
>
>      This makes lockdown available and applies it to all the points that
>      need to be locked down if the mode is set.  Lockdown mode can be
>      enabled by providing:
>
>         lockdown=1
>
>      on the command line.
>
>  (*) CONFIG_LOCK_DOWN_MANDATORY
>
>      This forces lockdown on at compile time, overriding the command line
>      option.
>
> init_lockdown() is used as a hook from which lockdown can be managed in
> future.  It has to be called from arch setup code before things like ACPI
> are enabled.
>
> Note that, with the other changes in this series, if lockdown mode is
> enabled, the kernel will not be able to use certain drivers as the ability
> to manually configure hardware parameters would then be prohibited.  This
> primarily applies to ISA hardware devices.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
[...]
> diff --git a/security/lock_down.c b/security/lock_down.c
> new file mode 100644
> index 000000000000..f35ffdd096ad
> --- /dev/null
> +++ b/security/lock_down.c
[...]
> +/*
> + * Lock the kernel down from very early in the arch setup.  This must happen
> + * prior to things like ACPI being initialised.
> + */

Pedantic nit: I think this comment is wrong now? This function
actually just prints stuff.

> +void __init init_lockdown(void)
> +{
> +#ifdef CONFIG_LOCK_DOWN_MANDATORY
> +       pr_notice("Kernel is locked down from config; see man kernel_lockdown.7\n");
> +#endif
> +}
