From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH v3 1/3] mm: introduce fincore()
Date: Mon, 07 Jul 2014 15:44:22 -0700
Message-ID: <53BB22C6.2020502@intel.com>
References: <1404756006-23794-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1404756006-23794-2-git-send-email-n-horiguchi@ah.jp.nec.com> <53BAEE95.50807@intel.com> <20140707202108.GA5031@nhori.bos.redhat.com> <53BB0673.8020604@intel.com> <20140707214820.GA13596@nhori.bos.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20140707214820.GA13596@nhori.bos.redhat.com>
Sender: owner-linux-mm@kvack.org
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Konstantin Khlebnikov <koct9i@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, Borislav Petkov <bp@alien8.de>, "Kirill A. Shutemov" <kirill@shutemov.name>, Johannes Weiner <hannes@cmpxchg.org>, Rusty Russell <rusty@rustcorp.com.au>, David Miller <davem@davemloft.net>, Andres Freund <andres@2ndquadrant.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Linux API <linux-api@vger.kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>, Kees Cook <kees@outflux.net>
List-Id: linux-api@vger.kernel.org

On 07/07/2014 02:48 PM, Naoya Horiguchi wrote:
> On Mon, Jul 07, 2014 at 01:43:31PM -0700, Dave Hansen wrote:
>> The whole FINCORE_PGOFF vs. FINCORE_BMAP issue is something that will
>> come up in practice.  We just don't have the interfaces for an end user
>> to pick which one they want to use.
>>
>>>> Is it really right to say this is going to be 8 bytes?  Would we want it
>>>> to share types with something else, like be an loff_t?
>>>
>>> Could you elaborate it more?
>>
>> We specify file offsets in other system calls, like the lseek family.  I
>> was just thinking that this type should match up with those calls since
>> they are expressing the same data type with the same ranges and limitations.
> 
> The 2nd parameter is loff_t, do we already do this?

I mean the fields in the buffer, like:

> +Any of the following flags are to be set to add an 8 byte field in each entry.
> +You can set any of these flags at the same time, although you can't set
> +FINCORE_BMAP combined with these 8 byte field flags.


>>>> This would essentially tell userspace where in the kernel's address
>>>> space some user-controlled data will be.
>>>
>>> OK, so this and FINCORE_PAGEFLAGS will be limited for privileged users.
> 
> Sorry, this statement of mine might a bit short-sighted, and I'd like
> to revoke it.
> I think that some page flags and/or numa info should be useful outside
> the debugging environment, and safe to expose to userspace. So limiting
> to bitmap-one for unprivileged users is too strict.

The PFN is not the same as NUMA information, and the PFN is insufficient
to describe the NUMA node on all systems that Linux supports.

Trying to get NUMA information back out is a good goal, but doing it
with PFNs is a bad idea since they have so many consequences.

I'm also bummed exporting NUMA information was a design goal of these
patches, but they weren't mentioned in any of the patch descriptions.

>> Then I'd just question their usefulness outside of a debugging
>> environment, especially when you can get at them in other (more
>> roundabout) ways in a debugging environment.
>>
>> This is really looking to me like two system calls.  The bitmap-based
>> one, and another more extensible one.  I don't think there's any harm in
>> having two system calls, especially when they're trying to glue together
>> two disparate interfaces.
> 
> I think that if separating syscall into two, one for privileged users
> and one for unprivileged users migth be fine (rather than bitmap-based
> one and extensible one.)

The problem as I see it is shoehorning two interfaces in to the same
syscall.  If there are privileged and unprivileged operations that use
the same _interfaces_ I think they should share a syscall.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
