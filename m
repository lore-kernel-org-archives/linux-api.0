From: Florian Weimer <fweimer@redhat.com>
Subject: Re: pkeys: Support setting access rights for signal handlers
Date: Wed, 13 Dec 2017 16:40:11 +0100
Message-ID: <93153ac4-70f0-9d17-37f1-97b80e468922@redhat.com>
References: <5fee976a-42d4-d469-7058-b78ad8897219@redhat.com>
 <c034f693-95d1-65b8-2031-b969c2771fed@intel.com>
 <5965d682-61b2-d7da-c4d7-c223aa396fab@redhat.com>
 <aa4d127f-0315-3ac9-3fdf-1f0a89cf60b8@intel.com>
 <20171212231324.GE5460@ram.oc3035372033.ibm.com>
 <9dc13a32-b1a6-8462-7e19-cfcf9e2c151e@redhat.com>
 <20171213113544.GG5460@ram.oc3035372033.ibm.com>
 <9f86d79e-165a-1b8e-32dd-7e4e8579da59@redhat.com>
 <c220f36f-c04a-50ae-3fd7-2c6245e27057@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <c220f36f-c04a-50ae-3fd7-2c6245e27057@intel.com>
Content-Language: en-US
Sender: linux-arch-owner@vger.kernel.org
To: Dave Hansen <dave.hansen@intel.com>, Ram Pai <linuxram@us.ibm.com>
Cc: linux-mm <linux-mm@kvack.org>, x86@kernel.org, linux-arch <linux-arch@vger.kernel.org>, linux-x86_64@vger.kernel.org, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 12/13/2017 04:22 PM, Dave Hansen wrote:
> On 12/13/2017 07:08 AM, Florian Weimer wrote:
>> Okay, this model is really quite different from x86.  Is there a
>> good reason for the difference?
> 
> Yes, both implementations are simple and take the "natural" behavior.
> x86 changes XSAVE-controlled register values on entering a signal, so we
> let them be changed (including PKRU).  POWER hardware does not do this
> to its PKRU-equivalent, so we do not force it to.

Why?  Is there a technical reason not have fully-aligned behavior?  Can 
POWER at least implement the original PKEY_ALLOC_SETSIGNAL semantics 
(reset the access rights for certain keys before switching to the signal 
handler) in a reasonably efficient manner?

At the very least, if we add a pkey_alloc flag, it should have identical 
behavior on both POWER and x86.  So it should either reset the access 
rights to a fixed value (as posted) or mask out the PKRU reset on x86 
(if that's even possible).  In the latter case, the POWER would not even 
have to change if we keep saying that the default key behavior (without 
the flag) is undefined regarding signal handlers.

> x86 didn't have to do this for *signals*.  But, we kinda went on this
> trajectory when we decided to clear/restore FPU state on
> entering/exiting signals before XSAVE even existed.

 From a userspace perspective, I find this variance rather 
disappointing.  It's particularly problematic for something like PKRU, 
which comes with an entire set of separately configurable keys.  I 
implemented a per-key knob, but who says that someone else doesn't need 
a per-thread or per-signal knob to switch between these incompatible 
behaviors?

What can a library assume regarding pkeys behavior if there are 
process-global flags that completely alter certain aspects of their 
behavior?

> FWIW, I do *not* think we have to do this for future XSAVE states.  But,
> if we do that, we probably need an interface for apps to tell us which
> states to save/restore and which state to set upon entering a signal
> handler.  That's what I was trying to get you to consider instead of
> just a one-off hack to fix this for pkeys.

I get that now.

But for pkeys and their access rights, having this configurable at the 
PKRU level (as opposed the individual key level) would completely rule 
out any use of pkeys in the glibc dynamic linker.

Thanks,
Florian
