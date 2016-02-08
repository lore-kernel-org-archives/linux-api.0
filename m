From: Miroslav Benes <mbenes@suse.cz>
Subject: Re: [RFC PATCH v4 0/6] (mostly) Arch-independent livepatch
Date: Mon, 8 Feb 2016 15:54:22 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1602081548070.12964@pobox.suse.cz>
References: <1454548271-24923-1-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1454548271-24923-1-git-send-email-jeyu@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: Jessica Yu <jeyu@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, Jonathan Corbet <corbet@lwn.net>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, 3 Feb 2016, Jessica Yu wrote:

> Jessica Yu (6):
>   Elf: add livepatch-specific Elf constants
>   module: preserve Elf information for livepatch modules
>   module: s390: keep mod_arch_specific for livepatch modules
>   livepatch: reuse module loader code to write relocations
>   samples: livepatch: mark as livepatch module
>   Documentation: livepatch: outline Elf format and requirements for
>     patch modules

Hi,

I walked through the code and it looks good except for several minor 
things in the fourth patch (livepatch: reuse module loader code to write 
relocations). I'd propose to send the next version as a regular PATCH set 
and not RFC. We can start collecting Reviews and Acks. Hopefully it won't 
take more than one or two iterations. Would that be ok with everyone?

Thanks,
Miroslav
