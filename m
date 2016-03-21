From: Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: livepatch: reuse module loader code to write relocations
Date: Mon, 21 Mar 2016 23:02:44 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1603212256080.3656@cbobk.fhfr.pm>
References: <1458157628-8264-1-git-send-email-jeyu@redhat.com> <1458157628-8264-5-git-send-email-jeyu@redhat.com> <alpine.LNX.2.00.1603211449240.12175@pobox.suse.cz> <20160321191832.GC12357@packer-debian-8-amd64.digitalocean.com> <alpine.LNX.2.00.1603212213340.3656@cbobk.fhfr.pm>
 <20160321213445.e64jic2uoc7tdtbl@treble.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160321213445.e64jic2uoc7tdtbl-8wJ5/zUtDR0XGNroddHbYwC/G2K4zDHf@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 21 Mar 2016, Josh Poimboeuf wrote:

> According to my test that still results in the literal value of
> "(64 - 8)".

Alright. But we should be able to special-case it with a two #if checks on 
the __SIZEOF_LONG__ value and BUILD_BUG_ON() when __SIZEOF_LONG__ is not 
of one of the ususal sizes.

Thanks,

-- 
Jiri Kosina
SUSE Labs
