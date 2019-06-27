From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH V34 09/29] kexec_file: Restrict at runtime if the kernel
 is locked down
Date: Thu, 27 Jun 2019 14:59:09 +1000 (AEST)
Message-ID: <alpine.LRH.2.21.1906271423070.16512@namei.org>
References: <20190622000358.19895-1-matthewgarrett@google.com> <20190622000358.19895-10-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190622000358.19895-10-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Jiri Bohac <jbohac@suse.cz>, David Howells <dhowells@redhat.com>, Matthew Garrett <mjg59@google.com>, kexec@lists.infradead.org
List-Id: linux-api@vger.kernel.org

On Fri, 21 Jun 2019, Matthew Garrett wrote:

> From: Jiri Bohac <jbohac@suse.cz>
> 
> When KEXEC_SIG is not enabled, kernel should not load images through
> kexec_file systemcall if the kernel is locked down.

This is not a criticism of the patch but a related issue which I haven't 
seen discussed (apologies if it has).

If signed code is loaded into ring 0, verified by the kernel, then 
executed, you still lose your secure/trusted/verified boot state. If the 
currently running kernel has been runtime-compromised, any signature 
verification performed by the kernel cannot be trusted.

This problem is out of scope for the lockdown threat model (which 
naturally cannot include a compromised kernel), but folk should be aware 
that signature-verified kexec does not provide equivalent assurance to a 
full reboot on a secure-boot system.

Potential mitigations here include runtime integrity verification of the
kernel via a separate security monitor (hypervisor, SMM, TEE etc.) or some
kind of platform support for kexec verification.


-- 
James Morris
<jmorris@namei.org>
