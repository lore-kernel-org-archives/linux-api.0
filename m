From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH V38 15/29] acpi: Ignore acpi_rsdp kernel param when the
 kernel has been locked down
Date: Wed, 14 Aug 2019 19:47:32 +0200
Message-ID: <20190814174732.GD1841@zn.tnic>
References: <20190808000721.124691-1-matthewgarrett@google.com>
 <20190808000721.124691-16-matthewgarrett@google.com>
 <20190814072602.GA27836@zn.tnic>
 <CACdnJuuOhuw71GDwQOrPQxUexpvpZNJocr6m0dYzJw+MMaVKWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACdnJuuOhuw71GDwQOrPQxUexpvpZNJocr6m0dYzJw+MMaVKWQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@google.com>
Cc: James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Josh Boyer <jwboyer@redhat.com>, David Howells <dhowells@redhat.com>, Kees Cook <keescook@chromium.org>, Dave Young <dyoung@redhat.com>, linux-acpi@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Aug 14, 2019 at 10:14:54AM -0700, Matthew Garrett wrote:
> We explicitly don't want to pay attention to the acpi_rsdp kernel
> parameter in early boot except for the case of finding the SRAT table,
> and we only need that if CONFIG_RANDOMIZE_BASE and
> CONFIG_MEMORY_HOTREMOVE are set. However, we *do* want to tell the
> actual kernel where the RSDP is if we found it via some other means,
> so we can't just clear the boot parameters value.

Ok.

> The kernel proper will parse the command line again and will then (if
> lockdown isn't enabled) override the actual value we passed up in boot
> params.

Yeah, ok, I see what you're doing there. AFAICT, you do that in

setup_arch->acpi_boot_table_init-> ... -> acpi_os_get_root_pointer()

I hope nothing needs it earlier because then we'll have to restructure
again...

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
