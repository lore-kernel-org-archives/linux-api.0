From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/sigreturn: use SYSCALL_DEFINE0
Date: Wed, 14 Mar 2018 21:04:13 +0100 (CET)
Message-ID: <alpine.DEB.2.21.1803142102300.1946@nanos.tec.linutronix.de>
References: <9C9981F4-0E5E-42A7-8788-70F3DEAD258D@amazon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9C9981F4-0E5E-42A7-8788-70F3DEAD258D@amazon.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Tautschnig, Michael" <tautschn@amazon.co.uk>
Cc: "x86@kernel.org" <x86@kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Jaswinder Singh <jaswinder@infradead.org>, Andi Kleen <ak@linux.intel.com>, Dominik Brodowski <linux@dominikbrodowski.net>
List-Id: linux-api@vger.kernel.org

On Wed, 14 Mar 2018, Tautschnig, Michael wrote:

> All definitions of syscalls in x86 except for those patched here have
> already been using the appropriate SYSCALL_DEFINE*.

Dominik, do you have more urgent stuff queued in that area?

If yes, please add: Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

If not, I simply route it through x86/urgent for 4.16.

Thanks,

	tglx
