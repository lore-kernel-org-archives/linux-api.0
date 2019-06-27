From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH V33 24/30] bpf: Restrict bpf when kernel lockdown is in
 confidentiality mode
Date: Thu, 27 Jun 2019 16:16:17 -0400
Message-ID: <de8b15eb-ba6c-847a-7435-42742203d4a5@tycho.nsa.gov>
References: <20190621011941.186255-1-matthewgarrett@google.com>
 <20190621011941.186255-25-matthewgarrett@google.com>
 <CALCETrVUwQP7roLnW6kFG80Cc5U6X_T6AW+BTAftLccYGp8+Ow@mail.gmail.com>
 <alpine.LRH.2.21.1906270621080.28132@namei.org>
 <6E53376F-01BB-4795-BC02-24F9CAE00001@amacapital.net>
 <bce70c8b-9efd-6362-d536-cfbbcf70b0b7@tycho.nsa.gov>
 <alpine.LRH.2.21.1906280332500.17363@namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.21.1906280332500.17363@namei.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: James Morris <jmorris@namei.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Matthew Garrett <matthewgarrett@google.com>, linux-security@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, David Howells <dhowells@redhat.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, Matthew Garrett <mjg59@google.com>, Network Development <netdev@vger.kernel.org>, Chun-Yi Lee <jlee@suse.com>, Daniel Borkmann <daniel@iogearbox.net>, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 6/27/19 2:06 PM, James Morris wrote:
> On Thu, 27 Jun 2019, Stephen Smalley wrote:
> 
>> There are two scenarios where finer-grained distinctions make sense:
>>
>> - Users may need to enable specific functionality that falls under the
>> umbrella of "confidentiality" or "integrity" lockdown.  Finer-grained lockdown
>> reasons free them from having to make an all-or-nothing choice between lost
>> functionality or no lockdown at all.
> 
> Agreed. This will be used for more than just UEFI secure boot on desktops,
> e.g. embedded systems using verified boot, where finer grained policy will
> be needed for what are sometimes very specific use-cases (which may be
> also covered by other mitigations).
> 
>> This can be supported directly by the
>> lockdown module without any help from SELinux or other security modules; we
>> just need the ability to specify these finer-grained lockdown levels via the
>> boot parameters and securityfs nodes.
> 
> If the lockdown LSM implements fine grained policy (rather than the simple
> coarse grained policy), I'd suggest adding a new lockdown level of
> 'custom' which by default enables all hooks but allows selective
> disablement via params/sysfs.
> 
> This would be simpler than telling users to use a different lockdown LSM
> for this.
> 
>> - Different processes/programs may need to use different sets of functionality
>> restricted via lockdown confidentiality or integrity categories.  If we have
>> to allow all-or-none for the set of interfaces/functionality covered by the
>> generic confidentiality or integrity categories, then we'll end up having to
>> choose between lost functionality or overprivileged processes, neither of
>> which is optimal.
>>
>> Is it truly the case that everything under the "confidentiality" category
>> poses the same level of risk to kernel confidentiality, and similarly for
>> everything under the "integrity" category?  If not, then being able to
>> distinguish them definitely has benefit.
> 
> Good question. We can't know the answer to this unless we know how an
> attacker might leverage access.
> 
> The value here IMHO is more in allowing tradeoffs to be made by system
> designers vs. disabling lockdown entirely.
> 
>> I'm still not clear though on how/if this will compose with or be overridden
>> by other security modules.  We would need some means for another security
>> module to take over lockdown decisions once it has initialized (including
>> policy load), and to be able to access state that is currently private to the
>> lockdown module, like the level.
> 
> Why not utilize stacking (restrictively), similarly to capabilities?

That would only allow the LSM to further lock down the system above the 
lockdown level set at boot, not grant exemptions for specific 
functionality/interfaces required by the user or by a specific 
process/program. You'd have to boot with lockdown=none (or your 
lockdown=custom suggestion) in order for the LSM to allow anything 
covered by the integrity or confidentiality levels.  And then the kernel 
would be unprotected prior to full initialization of the LSM, including 
policy load.

It seems like one would want to be able to boot with lockdown=integrity 
to protect the kernel initially, then switch over to allowing the LSM to 
selectively override it.
