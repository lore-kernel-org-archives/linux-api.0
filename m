From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH V38 15/29] acpi: Ignore acpi_rsdp kernel param when the
 kernel has been locked down
Date: Wed, 14 Aug 2019 10:14:54 -0700
Message-ID: <CACdnJuuOhuw71GDwQOrPQxUexpvpZNJocr6m0dYzJw+MMaVKWQ@mail.gmail.com>
References: <20190808000721.124691-1-matthewgarrett@google.com>
 <20190808000721.124691-16-matthewgarrett@google.com> <20190814072602.GA27836@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190814072602.GA27836@zn.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Josh Boyer <jwboyer@redhat.com>, David Howells <dhowells@redhat.com>, Kees Cook <keescook@chromium.org>, Dave Young <dyoung@redhat.com>, linux-acpi@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Aug 14, 2019 at 12:25 AM Borislav Petkov <bp@alien8.de> wrote:
> #if defined(CONFIG_RANDOMIZE_BASE) && defined(CONFIG_MEMORY_HOTREMOVE)
>
> false and thus not available to early code anymore.

We explicitly don't want to pay attention to the acpi_rsdp kernel
parameter in early boot except for the case of finding the SRAT table,
and we only need that if CONFIG_RANDOMIZE_BASE and
CONFIG_MEMORY_HOTREMOVE are set. However, we *do* want to tell the
actual kernel where the RSDP is if we found it via some other means,
so we can't just clear the boot parameters value. The kernel proper
will parse the command line again and will then (if lockdown isn't
enabled) override the actual value we passed up in boot params. So I
think this is ok?

(Sorry for not Cc:ing x86, clear oversight on my part)
