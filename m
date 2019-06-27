From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH V34 09/29] kexec_file: Restrict at runtime if the kernel
 is locked down
Date: Thu, 27 Jun 2019 08:28:08 -0700
Message-ID: <CACdnJusJeCYPKVFHiu6yn+mfqQe5k0RqZhbCUZEkxtXx_shMmw@mail.gmail.com>
References: <20190622000358.19895-1-matthewgarrett@google.com>
 <20190622000358.19895-10-matthewgarrett@google.com> <alpine.LRH.2.21.1906271423070.16512@namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.21.1906271423070.16512@namei.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Morris <jmorris@namei.org>
Cc: LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Jiri Bohac <jbohac@suse.cz>, David Howells <dhowells@redhat.com>, kexec@lists.infradead.org
List-Id: linux-api@vger.kernel.org

On Wed, Jun 26, 2019 at 9:59 PM James Morris <jmorris@namei.org> wrote:
> This is not a criticism of the patch but a related issue which I haven't
> seen discussed (apologies if it has).
>
> If signed code is loaded into ring 0, verified by the kernel, then
> executed, you still lose your secure/trusted/verified boot state. If the
> currently running kernel has been runtime-compromised, any signature
> verification performed by the kernel cannot be trusted.
>
> This problem is out of scope for the lockdown threat model (which
> naturally cannot include a compromised kernel), but folk should be aware
> that signature-verified kexec does not provide equivalent assurance to a
> full reboot on a secure-boot system.

By that metric, on a secure boot system how do we determine that code
running in the firmware environment wasn't compromised before it
launched the initial signed kernel?
