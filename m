From: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: MPK: removing a pkey
Date: Thu, 23 Nov 2017 07:00:32 -0800
Message-ID: <17831167-7142-d42a-c7a0-59bdc8bbb786@linux.intel.com>
References: <0f006ef4-a7b5-c0cf-5f58-d0fd1f911a54@redhat.com>
 <8741e4d6-6ac0-9c07-99f3-95d8d04940b4@suse.cz>
 <813f9736-36dd-b2e5-c850-9f2d5f94514a@redhat.com>
 <f42fe774-bdcc-a509-bb7f-fe709fd28fcb@linux.intel.com>
 <9ec19ff3-86f6-7cfe-1a07-1ab1c5d9882c@redhat.com>
 <d98eb4b8-6e59-513d-fdf8-3395485cb851@linux.intel.com>
 <de93997a-7802-96cf-62e2-e59416e745ca@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <de93997a-7802-96cf-62e2-e59416e745ca-AlSwsSmVLrQ@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-x86_64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 11/23/2017 12:11 AM, Vlastimil Babka wrote:
>> No, the default is clearly 0 and documented to be so.  The PROT_EXEC
>> emulation one should be inaccessible in all the APIs so does not even
>> show up as *being* a key in the API.  The fact that it's implemented
>> with pkeys should be pretty immaterial other than the fact that you
>> can't touch the high bits in PKRU.
> So, just to be sure, if we call pkey_mprotect() with 0, will it blindly
> set 0, or the result of arch_override_mprotect_pkey() (thus equivalent
> to call with -1) ? I assume the latter?

It's supposed to set 0.

-1 was, as far as I remember, an internal-to-the-kernel-only thing to
tell us that a key came from *mprotect()* instead of pkey_mprotect().
