From: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>
Subject: Re: module: preserve Elf information for livepatch modules
Date: Fri, 15 Jan 2016 06:58:08 +1030
Message-ID: <87a8o76h47.fsf@rustcorp.com.au>
References: <1452281304-28618-1-git-send-email-jeyu@redhat.com> <1452281304-28618-3-git-send-email-jeyu@redhat.com> <87oacshpqn.fsf@rustcorp.com.au> <20160114044718.GC980@packer-debian-8-amd64.digitalocean.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160114044718.GC980-N0bYjD2NfQ6k4hzjq3hgyGTy53QMssKEsp+A89P3RPuQWHG76I6BsA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
> +++ Rusty Russell [11/01/16 11:55 +1030]:
>>This comment is a bit misleading: it's actually pointing into the
>>temporary module copy, which will be discarded.  The init section is
>>slightly different...
>
> Ah, perhaps I'm misunderstanding something..
>
> Since copy_module_elf() is called after move_module(), my
> understanding is that all the section sh_addr's should be pointing
> to either module core memory or module init memory (instead of the
> initial temporary copy of the module in info->hdr).

You're absolutely correct; I'd forgotten that particular kallsyms twist.

Sorry for the noise!
Rusty.
