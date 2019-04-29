From: Daniel Axtens <dja@axtens.net>
Subject: Re: [PATCH V32 01/27] Add the ability to lock down access to the running kernel image
Date: Mon, 29 Apr 2019 10:06:51 +1000
Message-ID: <87wojdy8ro.fsf@dja-thinkpad.axtens.net>
References: <20190404003249.14356-1-matthewgarrett@google.com> <20190404003249.14356-2-matthewgarrett@google.com> <059c523e-926c-24ee-0935-198031712145@au1.ibm.com> <CACdnJus9AhAAYs-R94BH7HDuuQfXjgdhdqUR6Pvk9mxbuPx1=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACdnJus9AhAAYs-R94BH7HDuuQfXjgdhdqUR6Pvk9mxbuPx1=Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@google.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Cc: James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Michael Ellerman <mpe@ellerman.id.au>, cmr <cmr@informatik.wtf>
List-Id: linux-api@vger.kernel.org

Matthew Garrett <mjg59@google.com> writes:

> On Tue, Apr 16, 2019 at 1:40 AM Andrew Donnellan
> <andrew.donnellan@au1.ibm.com> wrote:
>> I'm thinking about whether we should lock down the powerpc xmon debug
>> monitor - intuitively, I think the answer is yes if for no other reason
>> than Least Astonishment, when lockdown is enabled you probably don't
>> expect xmon to keep letting you access kernel memory.
>
> The original patchset contained a sysrq hotkey to allow physically
> present users to disable lockdown, so I'm not super concerned about
> this case - I could definitely be convinced otherwise, though.

So currently (and I'm pretty new to this as I've only recently rejoined
IBM) we aren't considering access to the console to be sufficient to
assert physical presence on bare-metal server-class Power machines. The
short argument for this is that with IPMI and BMCs, a server's console
isn't what it used to be. Our console is also a bit different to x86:
we don't generally have bios configuration screens on the console.

In your example, a sysrq key would allow you to disable lockdown after
the system has booted. On Power though, we use Linux as a bootloader
(Petitboot: https://github.com/open-power/petitboot) so being able to
disable lockdown there allows an IPMI-connected user to prevent a signed
kernel being loaded in the first place. I don't know if this is
_actually_ worse, but it certainly feels worse.

There are of course some arguments against our approach. I'm aware of
some of them. I'm also very open to being told that not equating console
access with physical access is fundamentally silly or broken and that we
should rethink things.

Regards,
Daniel
