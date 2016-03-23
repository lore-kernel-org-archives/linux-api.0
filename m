From: Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v6 0/5] (mostly) Arch-independent livepatch
Date: Wed, 23 Mar 2016 14:50:09 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1603231443420.7170@pobox.suse.cz>
References: <1458691399-20078-1-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1458691399-20078-1-git-send-email-jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 22 Mar 2016, Jessica Yu wrote:

> v6:
>  - Since we hard-code the field widths for the objname and symbol name
>    for the sscanf() calls, which are supposed to correspond to the values
>    of MODULE_NAME_LEN and KSYM_NAME_LEN, use BUILD_BUG_ON() to detect when
>    the values of these constants deviate from the expected values.
>  - Squash the sample livepatch module patch into patch 4
>    ("livepatch: reuse module loader code to write relocations") so 
>    git bisects don't break
>  - Don't need the klp_buf struct, just use plain char arrays to hold the
>    output of sscanf(). Also, no need to clear the bufs after every
>    invocation, as sscanf() takes care to put a null byte at the end of
>    the bufs.
>  - Fix compiler kbuild errors for the !CONFIG_LIVEPATCH case
>  - Fixed some small module.c nits

FWIW I am fine with all the changes and my Reviewed-by tag is still valid.

Great job, Jessica.

Miroslav
