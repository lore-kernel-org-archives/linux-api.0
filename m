From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH V33 24/30] bpf: Restrict bpf when kernel lockdown is in
 confidentiality mode
Date: Thu, 27 Jun 2019 10:35:41 -0400
Message-ID: <bce70c8b-9efd-6362-d536-cfbbcf70b0b7@tycho.nsa.gov>
References: <20190621011941.186255-1-matthewgarrett@google.com>
 <20190621011941.186255-25-matthewgarrett@google.com>
 <CALCETrVUwQP7roLnW6kFG80Cc5U6X_T6AW+BTAftLccYGp8+Ow@mail.gmail.com>
 <alpine.LRH.2.21.1906270621080.28132@namei.org>
 <6E53376F-01BB-4795-BC02-24F9CAE00001@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6E53376F-01BB-4795-BC02-24F9CAE00001@amacapital.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>, James Morris <jmorris@namei.org>
Cc: Andy Lutomirski <luto@kernel.org>, Matthew Garrett <matthewgarrett@google.com>, linux-security@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, David Howells <dhowells@redhat.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, Matthew Garrett <mjg59@google.com>, Network Development <netdev@vger.kernel.org>, Chun-Yi Lee <jlee@suse.com>, Daniel Borkmann <daniel@iogearbox.net>, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 6/26/19 8:57 PM, Andy Lutomirski wrote:
> 
> 
>> On Jun 26, 2019, at 1:22 PM, James Morris <jmorris@namei.org> wrote:
>>
>> [Adding the LSM mailing list: missed this patchset initially]
>>
>>> On Thu, 20 Jun 2019, Andy Lutomirski wrote:
>>>
>>> This patch exemplifies why I don't like this approach:
>>>
>>>> @@ -97,6 +97,7 @@ enum lockdown_reason {
>>>>         LOCKDOWN_INTEGRITY_MAX,
>>>>         LOCKDOWN_KCORE,
>>>>         LOCKDOWN_KPROBES,
>>>> +       LOCKDOWN_BPF,
>>>>         LOCKDOWN_CONFIDENTIALITY_MAX,
>>>
>>>> --- a/security/lockdown/lockdown.c
>>>> +++ b/security/lockdown/lockdown.c
>>>> @@ -33,6 +33,7 @@ static char *lockdown_reasons[LOCKDOWN_CONFIDENTIALITY_MAX+1] = {
>>>>         [LOCKDOWN_INTEGRITY_MAX] = "integrity",
>>>>         [LOCKDOWN_KCORE] = "/proc/kcore access",
>>>>         [LOCKDOWN_KPROBES] = "use of kprobes",
>>>> +       [LOCKDOWN_BPF] = "use of bpf",
>>>>         [LOCKDOWN_CONFIDENTIALITY_MAX] = "confidentiality",
>>>
>>> The text here says "use of bpf", but what this patch is *really* doing
>>> is locking down use of BPF to read kernel memory.  If the details
>>> change, then every LSM needs to get updated, and we risk breaking user
>>> policies that are based on LSMs that offer excessively fine
>>> granularity.
>>
>> Can you give an example of how the details might change?
>>
>>> I'd be more comfortable if the LSM only got to see "confidentiality"
>>> or "integrity".
>>
>> These are not sufficient for creating a useful policy for the SELinux
>> case.
>>
>>
> 
> I may have misunderstood, but I thought that SELinux mainly needed to allow certain privileged programs to bypass the policy.  Is there a real example of what SELinux wants to do that can’t be done in the simplified model?
> 
> The think that specifically makes me uneasy about exposing all of these precise actions to LSMs is that they will get exposed to userspace in a way that forces us to treat them as stable ABIs.

There are two scenarios where finer-grained distinctions make sense:

- Users may need to enable specific functionality that falls under the 
umbrella of "confidentiality" or "integrity" lockdown.  Finer-grained 
lockdown reasons free them from having to make an all-or-nothing choice 
between lost functionality or no lockdown at all. This can be supported 
directly by the lockdown module without any help from SELinux or other 
security modules; we just need the ability to specify these 
finer-grained lockdown levels via the boot parameters and securityfs nodes.

- Different processes/programs may need to use different sets of 
functionality restricted via lockdown confidentiality or integrity 
categories.  If we have to allow all-or-none for the set of 
interfaces/functionality covered by the generic confidentiality or 
integrity categories, then we'll end up having to choose between lost 
functionality or overprivileged processes, neither of which is optimal.

Is it truly the case that everything under the "confidentiality" 
category poses the same level of risk to kernel confidentiality, and 
similarly for everything under the "integrity" category?  If not, then 
being able to distinguish them definitely has benefit.

I'm still not clear though on how/if this will compose with or be 
overridden by other security modules.  We would need some means for 
another security module to take over lockdown decisions once it has 
initialized (including policy load), and to be able to access state that 
is currently private to the lockdown module, like the level.
