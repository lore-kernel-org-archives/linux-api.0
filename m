From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH V32 11/27] x86: Lock down IO port access when the kernel
 is locked down
Date: Thu, 4 Apr 2019 09:49:02 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1904040948000.1833@nanos.tec.linutronix.de>
References: <20190404003249.14356-1-matthewgarrett@google.com> <20190404003249.14356-12-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190404003249.14356-12-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>
Cc: jmorris@namei.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-api@vger.kernel.org, luto@kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>, Matthew Garrett <mjg59@google.com>, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, 3 Apr 2019, Matthew Garrett wrote:

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
> Signed-off-by: Matthew Garrett <mjg59@google.com>
> Signed-off-by: David Howells <dhowells@redhat.com>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
