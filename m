From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH V34 28/29] efi: Restrict efivar_ssdt_load when the kernel
 is locked down
Date: Tue, 25 Jun 2019 17:00:24 +0200
Message-ID: <CAKv+Gu_0bSCdeUGQo=nnKU=mfHXu+-U+qXWqJpJGUd6dVZF61Q@mail.gmail.com>
References: <20190622000358.19895-1-matthewgarrett@google.com> <20190622000358.19895-29-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190622000358.19895-29-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>
Cc: James Morris <jmorris@namei.org>, linux-security-module <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Matthew Garrett <mjg59@google.com>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sat, 22 Jun 2019 at 02:05, Matthew Garrett <matthewgarrett@google.com> wrote:
>
> efivar_ssdt_load allows the kernel to import arbitrary ACPI code from an
> EFI variable, which gives arbitrary code execution in ring 0. Prevent
> that when the kernel is locked down.
>
> Signed-off-by: Matthew Garrett <mjg59@google.com>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: linux-efi@vger.kernel.org

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  drivers/firmware/efi/efi.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 55b77c576c42..9f92a013ab27 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -31,6 +31,7 @@
>  #include <linux/acpi.h>
>  #include <linux/ucs2_string.h>
>  #include <linux/memblock.h>
> +#include <linux/security.h>
>
>  #include <asm/early_ioremap.h>
>
> @@ -242,6 +243,11 @@ static void generic_ops_unregister(void)
>  static char efivar_ssdt[EFIVAR_SSDT_NAME_MAX] __initdata;
>  static int __init efivar_ssdt_setup(char *str)
>  {
> +       int ret = security_locked_down(LOCKDOWN_ACPI_TABLES);
> +
> +       if (ret)
> +               return ret;
> +
>         if (strlen(str) < sizeof(efivar_ssdt))
>                 memcpy(efivar_ssdt, str, strlen(str));
>         else
> --
> 2.22.0.410.gd8fdbe21b5-goog
>
