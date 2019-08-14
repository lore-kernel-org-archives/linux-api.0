From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH V38 15/29] acpi: Ignore acpi_rsdp kernel param when the
 kernel has been locked down
Date: Wed, 14 Aug 2019 11:02:32 -0700
Message-ID: <CACdnJutcF6ZdQKwz7L+i9FUuD8SBsHuhk8rwQpwfDsCpM1y9dA@mail.gmail.com>
References: <20190808000721.124691-1-matthewgarrett@google.com>
 <20190808000721.124691-16-matthewgarrett@google.com> <20190814072602.GA27836@zn.tnic>
 <CACdnJuuOhuw71GDwQOrPQxUexpvpZNJocr6m0dYzJw+MMaVKWQ@mail.gmail.com> <20190814174732.GD1841@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190814174732.GD1841@zn.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Josh Boyer <jwboyer@redhat.com>, David Howells <dhowells@redhat.com>, Kees Cook <keescook@chromium.org>, Dave Young <dyoung@redhat.com>, linux-acpi@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Aug 14, 2019 at 10:46 AM Borislav Petkov <bp@alien8.de> wrote:
> Yeah, ok, I see what you're doing there. AFAICT, you do that in
>
> setup_arch->acpi_boot_table_init-> ... -> acpi_os_get_root_pointer()

Right.

> I hope nothing needs it earlier because then we'll have to restructure
> again...

Passing the RSDP via command line is a pretty grotesque hack - we
should just set up boot params in kexec_file, which would leave this
as a problem for legacy kexec and nothing else.
