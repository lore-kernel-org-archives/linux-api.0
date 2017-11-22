From: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: MPK: removing a pkey
Date: Wed, 22 Nov 2017 08:32:11 -0800
Message-ID: <d98eb4b8-6e59-513d-fdf8-3395485cb851@linux.intel.com>
References: <0f006ef4-a7b5-c0cf-5f58-d0fd1f911a54@redhat.com>
 <8741e4d6-6ac0-9c07-99f3-95d8d04940b4@suse.cz>
 <813f9736-36dd-b2e5-c850-9f2d5f94514a@redhat.com>
 <f42fe774-bdcc-a509-bb7f-fe709fd28fcb@linux.intel.com>
 <9ec19ff3-86f6-7cfe-1a07-1ab1c5d9882c@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9ec19ff3-86f6-7cfe-1a07-1ab1c5d9882c-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-x86_64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 11/22/2017 08:21 AM, Florian Weimer wrote:
> On 11/22/2017 05:10 PM, Dave Hansen wrote:
>> On 11/22/2017 04:15 AM, Florian Weimer wrote:
>>> On 11/22/2017 09:18 AM, Vlastimil Babka wrote:
>>>> And, was the pkey == -1 internal wiring supposed to be exposed to the
>>>> pkey_mprotect() signal, or should there have been a pre-check returning
>>>> EINVAL in SYSCALL_DEFINE4(pkey_mprotect), before calling
>>>> do_mprotect_pkey())? I assume it's too late to change it now anyway (or
>>>> not?), so should we also document it?
>>>
>>> I think the -1 case to the set the default key is useful because it
>>> allows you to use a key value of -1 to mean “MPK is not supported”, and
>>> still call pkey_mprotect.
>>
>> The behavior to not allow 0 to be set was unintentional and is a bug.
>> We should fix that.
> 
> On the other hand, x86-64 has no single default protection key due to
> the PROT_EXEC emulation.

No, the default is clearly 0 and documented to be so.  The PROT_EXEC
emulation one should be inaccessible in all the APIs so does not even
show up as *being* a key in the API.  The fact that it's implemented
with pkeys should be pretty immaterial other than the fact that you
can't touch the high bits in PKRU.
