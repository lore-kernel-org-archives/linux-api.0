From: Miroslav Benes <mbenes@suse.cz>
Subject: Re: [RFC PATCH 0/5] Arch-independent livepatch
Date: Wed, 11 Nov 2015 15:00:44 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1511111456510.12467@pobox.suse.cz>
References: <1447130755-17383-1-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447130755-17383-1-git-send-email-jeyu@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jessica Yu <jeyu@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, 9 Nov 2015, Jessica Yu wrote:

> This patchset removes livepatch's need for architecture-specific relocation
> code by leveraging existing code in the module loader to perform
> arch-dependent work. Specifically, instead of duplicating code and
> re-implementing what the apply_relocate_add() function in the module loader
> already does in livepatch's klp_write_module_reloc(), we reuse
> apply_relocate_add() to write relocations. The hope is that this will make
> livepatch more easily portable to other architectures and greatly reduce
> the amount of arch-specific code required to port livepatch to a particular
> architecture.

Hi,

thanks for the patch set. I started going through it but it is gonna take 
some time. Nevertheless I've already found few things which I need to 
clarify. See respective patches.

> Background: Why does livepatch need to write its own relocations?
> ==
> A typical livepatch module contains patched versions of functions that can
> reference non-exported global symbols and non-included local symbols.
> Relocations referencing these types of symbols cannot be left in as-is
> since the kernel module loader cannot resolve them and will therefore
> reject the livepatch module. Furthermore, we cannot apply relocations that
> affect modules not loaded yet at run time (e.g. a patch to a driver). The
> current kpatch build system therefore solves this problem by embedding
> special "dynrela" (dynamic reloc) sections in the resulting patch module
> elf output. Using these dynrela sections, livepatch can correctly resolve
> symbols while taking into account its scope and what module the symbol
> belongs to, and then manually apply the dynamic relocations.

I'll only add that we solve the problem with kallsyms calls in kGraft. It 
can get really cumbersome from time to time, so this work would simplify 
our effort as well.

Miroslav
