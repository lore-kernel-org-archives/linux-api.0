From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v6 0/5] (mostly) Arch-independent livepatch
Date: Wed, 23 Mar 2016 08:00:06 -0500
Message-ID: <20160323130006.7x3bmikhivnhthbg@treble.redhat.com>
References: <1458691399-20078-1-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1458691399-20078-1-git-send-email-jeyu@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: Jessica Yu <jeyu@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Miroslav Benes <mbenes@suse.cz>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Mar 22, 2016 at 08:03:14PM -0400, Jessica Yu wrote:
> Patches based on linux-next.
> 
> Previous patchset (v5) found here:
> http://lkml.kernel.org/g/1458157628-8264-1-git-send-email-jeyu@redhat.com
> 
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

For the series:

Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>

Thanks Jessica!

-- 
Josh
