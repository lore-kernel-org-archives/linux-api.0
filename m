From: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [PATCH] x86/sigreturn: use SYSCALL_DEFINE0
Date: Wed, 14 Mar 2018 21:36:45 +0100
Message-ID: <20180314203645.GA21437@light.dominikbrodowski.net>
References: <9C9981F4-0E5E-42A7-8788-70F3DEAD258D@amazon.com>
 <alpine.DEB.2.21.1803142102300.1946@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1803142102300.1946@nanos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Tautschnig, Michael" <tautschn@amazon.co.uk>, "x86@kernel.org" <x86@kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Jaswinder Singh <jaswinder@infradead.org>, Andi Kleen <ak@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 14, 2018 at 09:04:13PM +0100, Thomas Gleixner wrote:
> On Wed, 14 Mar 2018, Tautschnig, Michael wrote:
> 
> > All definitions of syscalls in x86 except for those patched here have
> > already been using the appropriate SYSCALL_DEFINE*.
> 
> Dominik, do you have more urgent stuff queued in that area?
> 
> If yes, please add: Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
> 
> If not, I simply route it through x86/urgent for 4.16.

Thanks for asking! Nothing urgent from my side, only stuff for 4.17, so it
would be great if you could route it through x86/urgent.

Thanks,
	Dominik
