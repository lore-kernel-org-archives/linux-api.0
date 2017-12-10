From: Florian Weimer <fweimer@redhat.com>
Subject: Re: pkeys: Support setting access rights for signal handlers
Date: Sun, 10 Dec 2017 07:42:21 +0100
Message-ID: <5965d682-61b2-d7da-c4d7-c223aa396fab@redhat.com>
References: <5fee976a-42d4-d469-7058-b78ad8897219@redhat.com>
 <c034f693-95d1-65b8-2031-b969c2771fed@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <c034f693-95d1-65b8-2031-b969c2771fed@intel.com>
Content-Language: en-US
Sender: linux-arch-owner@vger.kernel.org
To: Dave Hansen <dave.hansen@intel.com>, linux-mm <linux-mm@kvack.org>, x86@kernel.org, linux-arch <linux-arch@vger.kernel.org>, linux-x86_64@vger.kernel.org, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 12/10/2017 01:17 AM, Dave Hansen wrote:
> On 12/09/2017 01:16 PM, Florian Weimer wrote:
>> The attached patch addresses a problem with the current x86 pkey
>> implementation, which makes default-readable pkeys unusable from signal
>> handlers because the default init_pkru value blocks access.
> 
> Thanks for looking into this!
> 
> What do you mean by "default-readable pkeys"?
> 
> I think you mean that, for any data that needs to be accessed to enter a
> signal handler, it must be set to pkey=0 with the current
> implementation.  All other keys are inaccessible when entering a signal
> handler because the "init" value disables access.

Right, and for keys which are readable (but not writable) most of the 
time, so that date is readable, this breaks things.

> My only nit with this is whether it is the *right* interface.  The
> signal vs. XSAVE state thing is pretty x86 specific and I doubt that
> this will be the last feature that we encounter that needs special
> signal behavior.

The interface is not specific to XSAVE.  To generic code, only the two 
signal mask manipulation functions are exposed.  And I expect that we're 
going to need that for other (non-x86) implementations because they will 
have the same issue because the signal handler behavior will be identical.

Thanks,
Florian
