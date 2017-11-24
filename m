From: Florian Weimer <fweimer@redhat.com>
Subject: Re: MPK: pkey_free and key reuse
Date: Fri, 24 Nov 2017 15:55:28 +0100
Message-ID: <2e3bfec2-303b-2221-0154-1145af3fffe8@redhat.com>
References: <0f006ef4-a7b5-c0cf-5f58-d0fd1f911a54@redhat.com>
 <e7d1e622-bbac-2750-2895-cc151458ff2f@linux.intel.com>
 <48ac42c0-4c31-cef8-a75a-8f3beab7cc66@redhat.com>
 <633b5b03-3481-0da2-9d6c-f5298902e36a@linux.intel.com>
 <068b89c7-4303-88a7-540a-1491dc8a292d@redhat.com>
 <04ef6b4a-6d20-d025-0b56-741fd467d445@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <04ef6b4a-6d20-d025-0b56-741fd467d445@linux.intel.com>
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
To: Dave Hansen <dave.hansen@linux.intel.com>, linux-x86_64@vger.kernel.org, linux-arch@vger.kernel.org
Cc: linux-mm <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 11/23/2017 04:25 PM, Dave Hansen wrote:
> I don't see a way to do a broadcast PKRU update.  But, I'd love to be
> proven wrong, with code.

I could use the existing setxid broadcast code in glibc to update PKRU 
on all running threads upon a key allocation (before pkey_alloc returns 
to the application), but this won't work for the implicit protection key 
used for PROT_EXEC.  I don't see a good way to get its number, and to 
determine whether a particular mprotect call allocated it.  (We 
obviously don't want to do the broadcast on every mprotect call with 
PROT_EXEC, just in case.)

What's worse, the setxid broadcast is not async-signal-safe, so we can't 
use it from mprotect, which should better be async-signal-safe (I know 
that official, it's not, but it would still be problematic to change 
that IMHO).

(The setxid broadcast mechanism allows us to run a piece of code on all 
threads of the process.  We could look at %rip and see if the signal 
arrived during a pkey_set function call, and make sure that this call 
delivers the right result, by altering the task state before returning.)

Thanks,
Florian

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
