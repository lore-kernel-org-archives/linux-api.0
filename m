From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH V36 19/29] Lock down module params that specify hardware
 parameters (eg. ioport)
Date: Mon, 29 Jul 2019 14:47:56 -0700
Message-ID: <CACdnJute8aakro+Cb7oNrxgCiZTYj2BOt2WMc1dYF-xktxBucQ@mail.gmail.com>
References: <20190718194415.108476-1-matthewgarrett@google.com> <20190718194415.108476-20-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190718194415.108476-20-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Morris <jmorris@namei.org>
Cc: LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, David Howells <dhowells@redhat.com>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Kees Cook <keescook@chromium.org>, Jessica Yu <jeyu@kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 18, 2019 at 12:45 PM Matthew Garrett
<matthewgarrett@google.com> wrote:
>
> From: David Howells <dhowells@redhat.com>
>
> Provided an annotation for module parameters that specify hardware
> parameters (such as io ports, iomem addresses, irqs, dma channels, fixed
> dma buffers and other types).
>
> Suggested-by: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Matthew Garrett <mjg59@google.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Cc: Jessica Yu <jeyu@kernel.org>

Jessica, any feedback on this?
