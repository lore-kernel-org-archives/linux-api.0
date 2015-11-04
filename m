From: Chris J Arges <chris.j.arges-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH v2] livepatch: old_name.number scheme in livepatch sysfs
 directory
Date: Wed, 4 Nov 2015 10:17:52 -0600
Message-ID: <563A2FB0.60101@canonical.com>
References: <20151102203241.GF27488@treble.redhat.com>
 <1446505187-28970-1-git-send-email-chris.j.arges@canonical.com>
 <alpine.LNX.2.00.1511031146070.6257@pobox.suse.cz>
 <20151103145843.GH27488@treble.redhat.com>
 <alpine.LNX.2.00.1511031705340.6257@pobox.suse.cz>
 <20151103165058.GM27488@treble.redhat.com>
 <alpine.LNX.2.00.1511041047200.5621@pobox.suse.cz>
 <20151104160354.GA29899@treble.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151104160354.GA29899-8wJ5/zUtDR0XGNroddHbYwC/G2K4zDHf@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>
Cc: live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org



On 11/04/2015 10:03 AM, Josh Poimboeuf wrote:
> On Wed, Nov 04, 2015 at 10:52:52AM +0100, Miroslav Benes wrote:
>> On Tue, 3 Nov 2015, Josh Poimboeuf wrote:
>>>> Object entry would be empty for not loaded object. I would not 
>>>> dare to propose to remove such object entries. It would make things worse. 
>>>
>>> Why would removing an empty object entry make things worse?
>>
>> I think it all comes down to a question whether the sysfs entries say what 
>> a patch is capable to patch or what this patch is currently patching in 
>> the system. I am inclined to the former so the removal would make me 
>> nervous. But I am not against the second approach. We are still in testing 
>> mode as far as sysfs is concerned so we can try even harsh changes and see 
>> how it's gonna go.
> 
> I see your point.  This approach only describes what is patched now, but
> it doesn't describe what *will* be patched.  Ideally we could find a way
> to describe both.
> 
> Speaking of harsh changes, here's an idea.
> 
> What if we require the patch author to supply the value of 'n' instead
> of supplying the symbol address?  We could get rid of 'old_addr' as an
> input in klp_func and and replace it with 'old_sympos' which has the
> value of 'n'.  Or alternatively we could require old_name to be of the
> format "func,n".

I like the idea of old_sympos better than modifying the string.
In addition if no old_sympos is specified then it should default to 0,
since this will probably be the more common case.

> 
> That would uniquely identify each patched function, even _before_ the
> object is loaded.
> 
> It would also fix another big problem we have today, where there's no
> way to disambiguate duplicate symbols in modules, for both function
> addresses and for relocs.
> 
> It would simplify the code in other places as well: no special handling
> for kASLR, no need for klp_verify_vmlinux_symbol() vs
> klp_find_object_symbol().
> 
> A drawback is that it requires the patch author to do a little more due
> diligence when filling out klp_func.  But we already require them to be
> careful.
> 
> Thoughts?
> 

I'll hold off on my v3 for now. Very interesting discussion : ).
--chris
