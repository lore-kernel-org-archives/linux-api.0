From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: MPK: removing a pkey (was: pkey_free and key reuse)
Date: Wed, 22 Nov 2017 09:18:44 +0100
Message-ID: <8741e4d6-6ac0-9c07-99f3-95d8d04940b4@suse.cz>
References: <0f006ef4-a7b5-c0cf-5f58-d0fd1f911a54@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0f006ef4-a7b5-c0cf-5f58-d0fd1f911a54-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-x86_64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 11/05/2017 11:35 AM, Florian Weimer wrote:
> I'm working on adding memory protection key support to glibc.
> 
> I don't think pkey_free, as it is implemented today, is very safe due to 
> key reuse by a subsequent pkey_alloc.  I see two problems:
> 
> (A) pkey_free allows reuse for they key while there are still mappings 
> that use it.
> 
> (B) If a key is reused, existing threads retain their access rights, 
> while there is an expectation that pkey_alloc denies access for the 
> threads except the current one.

I have a somewhat related question to API/documentation of pkeys, that
came up from a customer interested in using the feature. The man page of
mprotect/pkey_mprotect doesn't say how to remove a pkey from a set of
pages, i.e. reset it to the default 0 (or the exec-only pkey), so
initially they thought there's no way to do that.

Calling pkey_mprotect() with pkey==0 will fail with EINVAL, because 0
was not allocated by pkey_alloc(). That's fair I guess.

What seems to work to reset the pkey is either calling plain mprotect(),
or calling pkey_mprotect() with pkey == -1, as the former is just wired
to the latter.

So, is plain mprotect() the intended way to reset a pkey and should it
be explicitly documented in the man page?

And, was the pkey == -1 internal wiring supposed to be exposed to the
pkey_mprotect() signal, or should there have been a pre-check returning
EINVAL in SYSCALL_DEFINE4(pkey_mprotect), before calling
do_mprotect_pkey())? I assume it's too late to change it now anyway (or
not?), so should we also document it?

Thanks,
Vlastimil
