From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH V31 11/25] x86: Lock down IO port access when the kernel
 is locked down
Date: Tue, 26 Mar 2019 13:56:49 -0700
Message-ID: <CALCETrVjhHbJ+41fY9ra7YBm42ingOZ0_XjY=xAxLUU8n0U=9Q@mail.gmail.com>
References: <20190326182742.16950-1-matthewgarrett@google.com> <20190326182742.16950-12-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190326182742.16950-12-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>
Cc: James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, Andrew Lutomirski <luto@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>, Matthew Garrett <mjg59@google.com>, X86 ML <x86@kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 26, 2019 at 11:28 AM Matthew Garrett
<matthewgarrett@google.com> wrote:
>
> From: Matthew Garrett <mjg59@srcf.ucam.org>
>
> IO port access would permit users to gain access to PCI configuration
> registers, which in turn (on a lot of hardware) give access to MMIO
> register space. This would potentially permit root to trigger arbitrary
> DMA, so lock it down by default.
>
> This also implicitly locks down the KDADDIO, KDDELIO, KDENABIO and
> KDDISABIO console ioctls.
>

Reviewed-by: Andy Lutomirski <luto@kernel.org>
