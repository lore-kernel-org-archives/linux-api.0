From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH V32 01/27] Add the ability to lock down access to the
 running kernel image
Date: Thu, 18 Apr 2019 12:35:36 -0700
Message-ID: <CACdnJus9AhAAYs-R94BH7HDuuQfXjgdhdqUR6Pvk9mxbuPx1=Q@mail.gmail.com>
References: <20190404003249.14356-1-matthewgarrett@google.com>
 <20190404003249.14356-2-matthewgarrett@google.com> <059c523e-926c-24ee-0935-198031712145@au1.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <059c523e-926c-24ee-0935-198031712145@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Cc: James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Michael Ellerman <mpe@ellerman.id.au>, Daniel Axtens <dja@axtens.net>, cmr <cmr@informatik.wtf>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 16, 2019 at 1:40 AM Andrew Donnellan
<andrew.donnellan@au1.ibm.com> wrote:
> I'm thinking about whether we should lock down the powerpc xmon debug
> monitor - intuitively, I think the answer is yes if for no other reason
> than Least Astonishment, when lockdown is enabled you probably don't
> expect xmon to keep letting you access kernel memory.

The original patchset contained a sysrq hotkey to allow physically
present users to disable lockdown, so I'm not super concerned about
this case - I could definitely be convinced otherwise, though.
