From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH V35 15/29] acpi: Ignore acpi_rsdp kernel param when the
 kernel has been locked down
Date: Tue, 16 Jul 2019 13:34:54 -0700
Message-ID: <CACdnJuut9cfc1fsAy63t0Z=JVujmNELm2Xm1grEZzORF5Cuviw@mail.gmail.com>
References: <20190715195946.223443-1-matthewgarrett@google.com>
 <20190715195946.223443-16-matthewgarrett@google.com> <20190716025923.GA5793@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190716025923.GA5793@dhcp-128-65.nay.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Young <dyoung@redhat.com>
Cc: James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Josh Boyer <jwboyer@redhat.com>, David Howells <dhowells@redhat.com>, Borislav Petkov <bp@alien8.de>, Kees Cook <keescook@chromium.org>, linux-acpi@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Jul 15, 2019 at 7:59 PM Dave Young <dyoung@redhat.com> wrote:
> I'm very sorry I noticed this late, but have to say this will not work for
> X86 with latest kernel code.

No problem, thank you for catching this! I'll update the patch and
send a new version.
