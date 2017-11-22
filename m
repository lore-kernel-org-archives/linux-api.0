From: Florian Weimer <fweimer@redhat.com>
Subject: Re: MPK: removing a pkey
Date: Wed, 22 Nov 2017 13:15:24 +0100
Message-ID: <813f9736-36dd-b2e5-c850-9f2d5f94514a@redhat.com>
References: <0f006ef4-a7b5-c0cf-5f58-d0fd1f911a54@redhat.com>
 <8741e4d6-6ac0-9c07-99f3-95d8d04940b4@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <8741e4d6-6ac0-9c07-99f3-95d8d04940b4@suse.cz>
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
To: Vlastimil Babka <vbabka@suse.cz>, Dave Hansen <dave.hansen@linux.intel.com>, linux-x86_64@vger.kernel.org, linux-arch@vger.kernel.org
Cc: linux-mm <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 11/22/2017 09:18 AM, Vlastimil Babka wrote:
> And, was the pkey == -1 internal wiring supposed to be exposed to the
> pkey_mprotect() signal, or should there have been a pre-check returning
> EINVAL in SYSCALL_DEFINE4(pkey_mprotect), before calling
> do_mprotect_pkey())? I assume it's too late to change it now anyway (or
> not?), so should we also document it?

I think the -1 case to the set the default key is useful because it 
allows you to use a key value of -1 to mean “MPK is not supported”, and 
still call pkey_mprotect.

I plan to document this behavior on the glibc side, and glibc will call 
mprotect (not pkey_mprotect) for key -1, so that you won't get ENOSYS 
with kernels which do not support pkey_mprotect.

Thanks,
Florian

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
