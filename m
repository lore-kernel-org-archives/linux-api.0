From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Subject: Re: [PATCH V32 01/27] Add the ability to lock down access to the
 running kernel image
Date: Tue, 30 Apr 2019 15:15:17 +1000
Message-ID: <b56f7fbe-f87a-0af7-f447-4bfee712ce16@au1.ibm.com>
References: <20190404003249.14356-1-matthewgarrett@google.com>
 <20190404003249.14356-2-matthewgarrett@google.com>
 <059c523e-926c-24ee-0935-198031712145@au1.ibm.com>
 <CACdnJus9AhAAYs-R94BH7HDuuQfXjgdhdqUR6Pvk9mxbuPx1=Q@mail.gmail.com>
 <87wojdy8ro.fsf@dja-thinkpad.axtens.net>
 <87tvehxvh0.fsf@dja-thinkpad.axtens.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87tvehxvh0.fsf@dja-thinkpad.axtens.net>
Content-Language: en-AU
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Axtens <dja@axtens.net>, Matthew Garrett <mjg59@google.com>
Cc: James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Michael Ellerman <mpe@ellerman.id.au>, cmr <cmr@informatik.wtf>
List-Id: linux-api@vger.kernel.org

On 29/4/19 2:54 pm, Daniel Axtens wrote:
> Hi,
> 
>>>> I'm thinking about whether we should lock down the powerpc xmon debug
>>>> monitor - intuitively, I think the answer is yes if for no other reason
>>>> than Least Astonishment, when lockdown is enabled you probably don't
>>>> expect xmon to keep letting you access kernel memory.
>>>
>>> The original patchset contained a sysrq hotkey to allow physically
>>> present users to disable lockdown, so I'm not super concerned about
>>> this case - I could definitely be convinced otherwise, though.
> 
> So Mimi contacted me offlist and very helpfully provided me with a much
> better and less confused justification for disabling xmon in lockdown:
> 
> On x86, physical presence (== console access) is a trigger to
> disable/enable lockdown mode.
> 
> In lockdown mode, you're not supposed to be able to modify memory. xmon
> allows you to modify memory, and therefore shouldn't be allowed in
> lockdown.
> 
> So, if you can disable lockdown on the console that's probably OK, but
> it should be specifically disabling lockdown, not randomly editing
> memory with xmon.

That makes sense.

-- 
Andrew Donnellan              OzLabs, ADL Canberra
andrew.donnellan@au1.ibm.com  IBM Australia Limited
