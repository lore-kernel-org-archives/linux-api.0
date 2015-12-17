From: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Subject: Re: livepatch: reuse module loader code to write relocations
Date: Thu, 17 Dec 2015 16:45:01 +0100
Message-ID: <20151217154500.GG3729@pathway.suse.cz>
References: <1448943679-3412-1-git-send-email-jeyu@redhat.com>
 <1448943679-3412-5-git-send-email-jeyu@redhat.com>
 <20151208183844.GC14846@treble.redhat.com>
 <20151209191013.GA25387@packer-debian-8-amd64.digitalocean.com>
 <20151216054048.GA28258@packer-debian-8-amd64.digitalocean.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151216054048.GA28258-N0bYjD2NfQ6k4hzjq3hgyGTy53QMssKEsp+A89P3RPuQWHG76I6BsA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed 2015-12-16 00:40:48, Jessica Yu wrote:
> Turns out the string parsing stuff, even with the help of lib/string.c, doesn't
> look very pretty. As I'm working on v3, I'm starting to think having
> klp_write_object_relocations() loop simply through all the elf sections might
> not be a good idea. Let me explain.
> 
> I don't like the amount of string manipulation code that would potentially come
> with this change. Even with a string as simple as ".klp.rela.objname", we'll
> end up with a bunch of kstrdup's/kmalloc's and kfree's (unless we modify and
> chop the section name string in place, which I don't think we should do) that
> are going to be required at every iteration of the loop, all just to be able to
> call strcmp() and see if we're dealing with a klp rela section that belongs to
> the object in question. This also leads to more complicated error handling.

I do not think that we need to allocate and free buffers every time
we compare a substring.

One possibility is to find the position of the substring using
strchr(). Then you could compare it using strncmp() and pass there
the pointer where the substring begins.

Alternatively we could use a static buffer or allocate a big enough
one at the beginning. IMHO, we could assume that function name must
fit into 80 characters, otherwise, that code would be unmanageable
(won't deserve patching). If we use a buffer size 256 bytes,
we should be definitely on the safe side.

Just 2 my cents,
Petr
