From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH V33 21/30] x86/mmiotrace: Lock down the testmmiotrace
 module
Date: Wed, 26 Jun 2019 08:46:18 -0400
Message-ID: <20190626084618.49c6a311@gandalf.local.home>
References: <20190621011941.186255-1-matthewgarrett@google.com>
        <20190621011941.186255-22-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190621011941.186255-22-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>
Cc: jmorris@namei.org, linux-security@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, David Howells <dhowells@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Matthew Garrett <mjg59@google.com>, Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, 20 Jun 2019 18:19:32 -0700
Matthew Garrett <matthewgarrett@google.com> wrote:

> From: David Howells <dhowells@redhat.com>
> 
> The testmmiotrace module shouldn't be permitted when the kernel is locked
> down as it can be used to arbitrarily read and write MMIO space. This is
> a runtime check rather than buildtime in order to allow configurations
> where the same kernel may be run in both locked down or permissive modes
> depending on local policy.
> 
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: David Howells <dhowells@redhat.com
> Signed-off-by: Matthew Garrett <mjg59@google.com>
> cc: Thomas Gleixner <tglx@linutronix.de>

Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

-- Steve

> cc: Ingo Molnar <mingo@kernel.org>
> cc: "H. Peter Anvin" <hpa@zytor.com>
> cc: x86@kernel.org
> ---
