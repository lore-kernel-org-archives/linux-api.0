From: Jiri Kosina <jikos@kernel.org>
Subject: Re: [PATCH v6 0/5] (mostly) Arch-independent livepatch
Date: Fri, 1 Apr 2016 17:00:54 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1604011502080.16158@cbobk.fhfr.pm>
References: <1458691399-20078-1-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1458691399-20078-1-git-send-email-jeyu@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: Jessica Yu <jeyu@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Petr Mladek <pmladek@suse.com>, Jonathan Corbet <corbet@lwn.net>, Miroslav Benes <mbenes@suse.cz>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, 22 Mar 2016, Jessica Yu wrote:

> This patchset removes livepatch's need for architecture-specific relocation
> code by leveraging existing code in the module loader to perform
> arch-dependent work. 

This is now in livepatching.git#for-4.7/arch-independent-klp-relocations

I was waiting a bit whether there would be any discussion regarding the 
new relocation flag and symbol section index added to elf, but given the 
fact that noone objected and that we are using the OS-specific range 
anyway, I don't expect this to be an issue.

Thanks everybody,

-- 
Jiri Kosina
SUSE Labs

