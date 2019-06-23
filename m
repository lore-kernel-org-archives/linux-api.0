From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH V34 20/29] x86/mmiotrace: Lock down the testmmiotrace
 module
Date: Sun, 23 Jun 2019 13:08:52 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1906231308420.32342@nanos.tec.linutronix.de>
References: <20190622000358.19895-1-matthewgarrett@google.com> <20190622000358.19895-21-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190622000358.19895-21-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>
Cc: jmorris@namei.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, David Howells <dhowells@redhat.com>, Matthew Garrett <mjg59@google.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
List-Id: linux-api@vger.kernel.org



On Fri, 21 Jun 2019, Matthew Garrett wrote:

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
> cc: Steven Rostedt <rostedt@goodmis.org>
> cc: Ingo Molnar <mingo@kernel.org>
> cc: "H. Peter Anvin" <hpa@zytor.com>
> cc: x86@kernel.org

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
