From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH V34 09/29] kexec_file: Restrict at runtime if the kernel
 is locked down
Date: Thu, 27 Jun 2019 16:17:46 -0700
Message-ID: <CACdnJuvRtQWFknzxLwKc6erCBZ3+6tXmabEdRuXXGTGrYEAp6w@mail.gmail.com>
References: <20190622000358.19895-1-matthewgarrett@google.com>
 <20190622000358.19895-10-matthewgarrett@google.com> <alpine.LRH.2.21.1906271423070.16512@namei.org>
 <CACdnJusJeCYPKVFHiu6yn+mfqQe5k0RqZhbCUZEkxtXx_shMmw@mail.gmail.com> <alpine.LRH.2.21.1906280411370.18880@namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.21.1906280411370.18880@namei.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Morris <jmorris@namei.org>
Cc: LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Jiri Bohac <jbohac@suse.cz>, David Howells <dhowells@redhat.com>, kexec@lists.infradead.org
List-Id: linux-api@vger.kernel.org

On Thu, Jun 27, 2019 at 11:14 AM James Morris <jmorris@namei.org> wrote:
>
> On Thu, 27 Jun 2019, Matthew Garrett wrote:
>
> > By that metric, on a secure boot system how do we determine that code
> > running in the firmware environment wasn't compromised before it
> > launched the initial signed kernel?
>
> Remote attestation tied to a hardware root of trust, before allowing
> access to any further resources.

If you use IMA you can get the same guarantees over kexec.
