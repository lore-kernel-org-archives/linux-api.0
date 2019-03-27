From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH V31 19/25] x86/mmiotrace: Lock down the testmmiotrace
 module
Date: Wed, 27 Mar 2019 11:57:49 -0400
Message-ID: <20190327115749.5770a102@gandalf.local.home>
References: <20190326182742.16950-1-matthewgarrett@google.com>
        <20190326182742.16950-20-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190326182742.16950-20-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>
Cc: jmorris@namei.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-api@vger.kernel.org, luto@kernel.org, Thomas Gleixner <tglx@linutronix.de>, Matthew Garrett <mjg59@google.com>, Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, 26 Mar 2019 11:27:35 -0700
Matthew Garrett <matthewgarrett@google.com> wrote:

> From: David Howells <dhowells@redhat.com>
> 
> The testmmiotrace module shouldn't be permitted when the kernel is locked
> down as it can be used to arbitrarily read and write MMIO space. This is
> a runtime check rather than buildtime in order to allow configurations
> where the same kernel may be run in both locked down or permissive modes
> depending on local policy.
> 

Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

I'm curious. Should there be a mode to lockdown the tracefs directory
too? As that can expose addresses.

-- Steve


> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: David Howells <dhowells@redhat.com
> Signed-off-by: Matthew Garrett <mjg59@google.com>
> cc: Thomas Gleixner <tglx@linutronix.de>
> cc: Steven Rostedt <rostedt@goodmis.org>
> cc: Ingo Molnar <mingo@kernel.org>
> cc: "H. Peter Anvin" <hpa@zytor.com>
> cc: x86@kernel.org
> ---
>  arch/x86/mm/testmmiotrace.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/mm/testmmiotrace.c b/arch/x86/mm/testmmiotrace.c
> index f6ae6830b341..9e8ad665f354 100644
> --- a/arch/x86/mm/testmmiotrace.c
> +++ b/arch/x86/mm/testmmiotrace.c
> @@ -115,6 +115,9 @@ static int __init init(void)
>  {
>  	unsigned long size = (read_far) ? (8 << 20) : (16 << 10);
>  
> +	if (kernel_is_locked_down("MMIO trace testing", LOCKDOWN_INTEGRITY))
> +		return -EPERM;
> +
>  	if (mmio_address == 0) {
>  		pr_err("you have to use the module argument mmio_address.\n");
>  		pr_err("DO NOT LOAD THIS MODULE UNLESS YOU REALLY KNOW WHAT YOU ARE DOING!\n");
