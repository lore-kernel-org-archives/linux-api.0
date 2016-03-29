From: Jessica Yu <jeyu@redhat.com>
Subject: Re: (mostly) Arch-independent livepatch
Date: Tue, 29 Mar 2016 17:13:30 -0400
Message-ID: <20160329211330.GA1253@packer-debian-8-amd64.digitalocean.com>
References: <1458691399-20078-1-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1458691399-20078-1-git-send-email-jeyu@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Miroslav Benes <mbenes@suse.cz>
Cc: linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

+++ Jessica Yu [22/03/16 20:03 -0400]:
>
>Patches based on linux-next.
>
>Previous patchset (v5) found here:
>http://lkml.kernel.org/g/1458157628-8264-1-git-send-email-jeyu@redhat.com
>
>v6:
> - Since we hard-code the field widths for the objname and symbol name
>   for the sscanf() calls, which are supposed to correspond to the values
>   of MODULE_NAME_LEN and KSYM_NAME_LEN, use BUILD_BUG_ON() to detect when
>   the values of these constants deviate from the expected values.
> - Squash the sample livepatch module patch into patch 4
>   ("livepatch: reuse module loader code to write relocations") so
>   git bisects don't break
> - Don't need the klp_buf struct, just use plain char arrays to hold the
>   output of sscanf(). Also, no need to clear the bufs after every
>   invocation, as sscanf() takes care to put a null byte at the end of
>   the bufs.
> - Fix compiler kbuild errors for the !CONFIG_LIVEPATCH case
> - Fixed some small module.c nits
>

Pinging Rusty, just in case this thread got buried :-)
How do the module.c changes look?

Thanks,
Jessica
