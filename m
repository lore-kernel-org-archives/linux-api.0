From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH V38 15/29] acpi: Ignore acpi_rsdp kernel param when the
 kernel has been locked down
Date: Wed, 14 Aug 2019 09:26:02 +0200
Message-ID: <20190814072602.GA27836@zn.tnic>
References: <20190808000721.124691-1-matthewgarrett@google.com>
 <20190808000721.124691-16-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190808000721.124691-16-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>
Cc: jmorris@namei.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Josh Boyer <jwboyer@redhat.com>, David Howells <dhowells@redhat.com>, Matthew Garrett <mjg59@google.com>, Kees Cook <keescook@chromium.org>, Dave Young <dyoung@redhat.com>, linux-acpi@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Aug 07, 2019 at 05:07:07PM -0700, Matthew Garrett wrote:
> From: Josh Boyer <jwboyer@redhat.com>
> 
> This option allows userspace to pass the RSDP address to the kernel, which
> makes it possible for a user to modify the workings of hardware. Reject
> the option when the kernel is locked down. This requires some reworking
> of the existing RSDP command line logic, since the early boot code also
> makes use of a command-line passed RSDP when locating the SRAT table
> before the lockdown code has been initialised. This is achieved by
> separating the command line RSDP path in the early boot code from the
> generic RSDP path, and then copying the command line RSDP into boot
> params in the kernel proper if lockdown is not enabled. If lockdown is
> enabled and an RSDP is provided on the command line, this will only be
> used when parsing SRAT (which shouldn't permit kernel code execution)
> and will be ignored in the rest of the kernel.
> 
> (Modified by Matthew Garrett in order to handle the early boot RSDP
> environment)
> 
> Signed-off-by: Josh Boyer <jwboyer@redhat.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Matthew Garrett <mjg59@google.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> cc: Dave Young <dyoung@redhat.com>
> cc: linux-acpi@vger.kernel.org
> ---
>  arch/x86/boot/compressed/acpi.c | 19 +++++++++++++------
>  arch/x86/include/asm/acpi.h     |  9 +++++++++
>  arch/x86/include/asm/x86_init.h |  2 ++
>  arch/x86/kernel/acpi/boot.c     |  5 +++++
>  arch/x86/kernel/x86_init.c      |  1 +
>  drivers/acpi/osl.c              | 14 +++++++++++++-
>  include/linux/acpi.h            |  6 ++++++
>  7 files changed, 49 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/boot/compressed/acpi.c b/arch/x86/boot/compressed/acpi.c
> index 15255f388a85..149795c369f2 100644
> --- a/arch/x86/boot/compressed/acpi.c
> +++ b/arch/x86/boot/compressed/acpi.c
> @@ -26,7 +26,7 @@ struct mem_vector immovable_mem[MAX_NUMNODES*2];
>   */
>  #define MAX_ADDR_LEN 19
>  
> -static acpi_physical_address get_acpi_rsdp(void)
> +static acpi_physical_address get_cmdline_acpi_rsdp(void)
>  {
>  	acpi_physical_address addr = 0;
>  
> @@ -278,10 +278,7 @@ acpi_physical_address get_rsdp_addr(void)
>  {
>  	acpi_physical_address pa;
>  
> -	pa = get_acpi_rsdp();
> -
> -	if (!pa)
> -		pa = boot_params->acpi_rsdp_addr;

AFAICT, this looks like it would break current usage: get_rsdp_addr()
needs to call get_acpi_rsdp() which you've now called
get_cmdline_acpi_rsdp() to parse "acpi_rsdp=" but it ain't happening
anymore.

Where the parsing is happening now is in get_acpi_srat_table() which is
not present in configs with

#if defined(CONFIG_RANDOMIZE_BASE) && defined(CONFIG_MEMORY_HOTREMOVE)

false and thus not available to early code anymore.

I think the cleaner/easier approach would be to clear
boot_params->acpi_rsdp_addr after SRAT has been parsed in lockdown
configurations so that nothing else uses the supplied RDSP address
anymore. But I could very well be missing something...

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
