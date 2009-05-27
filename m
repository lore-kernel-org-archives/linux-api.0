From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [RFC v16][PATCH 41/43] c/r: (s390): expose a constant for the
	number of words (CRs)
Date: Wed, 27 May 2009 22:39:31 +0400
Message-ID: <20090527183837.GB31930@x200.localdomain>
References: <1243445589-32388-1-git-send-email-orenl@cs.columbia.edu> <1243445589-32388-42-git-send-email-orenl@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1243445589-32388-42-git-send-email-orenl@cs.columbia.edu>
Sender: owner-linux-mm@kvack.org
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@osdl.org>, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Serge Hallyn <serue@us.ibm.com>, Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Pavel Emelyanov <xemul@openvz.org>, Dan Smith <danms@us.ibm.com>
List-Id: linux-api@vger.kernel.org

On Wed, May 27, 2009 at 01:33:07PM -0400, Oren Laadan wrote:
> We need to use this value in the checkpoint/restart code and would like to
> have a constant instead of a magic '3'.
> 
> Changelog:
>     Mar 30:
>             . Add CHECKPOINT_SUPPORT in Kconfig (Nathan Lynch)
>     Mar 03:
>             . Picked up additional use of magic '3' in ptrace.h
> 
> Signed-off-by: Dan Smith <danms@us.ibm.com>
> ---
>  arch/s390/Kconfig |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> index 2eca5fe..bf62cad 100644
> --- a/arch/s390/Kconfig
> +++ b/arch/s390/Kconfig
> @@ -49,6 +49,10 @@ config GENERIC_TIME_VSYSCALL
>  config GENERIC_CLOCKEVENTS
>  	def_bool y
>  
> +config CHECKPOINT_SUPPORT
> +	bool
> +	default y if 64BIT
> +
>  config GENERIC_BUG
>  	bool
>  	depends on BUG

Changelog and content aren't compatible.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
