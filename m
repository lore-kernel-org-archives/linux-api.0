From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [RFC PATCH 0/5] Arch-independent livepatch
Date: Wed, 11 Nov 2015 10:28:10 -0600
Message-ID: <20151111162809.GD5331@treble.redhat.com>
References: <1447130755-17383-1-git-send-email-jeyu@redhat.com>
 <alpine.LNX.2.00.1511111456510.12467@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1511111456510.12467@pobox.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Miroslav Benes <mbenes@suse.cz>
Cc: Jessica Yu <jeyu@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Nov 11, 2015 at 03:00:44PM +0100, Miroslav Benes wrote:
> > Background: Why does livepatch need to write its own relocations?
> > ==
> > A typical livepatch module contains patched versions of functions that can
> > reference non-exported global symbols and non-included local symbols.
> > Relocations referencing these types of symbols cannot be left in as-is
> > since the kernel module loader cannot resolve them and will therefore
> > reject the livepatch module. Furthermore, we cannot apply relocations that
> > affect modules not loaded yet at run time (e.g. a patch to a driver). The
> > current kpatch build system therefore solves this problem by embedding
> > special "dynrela" (dynamic reloc) sections in the resulting patch module
> > elf output. Using these dynrela sections, livepatch can correctly resolve
> > symbols while taking into account its scope and what module the symbol
> > belongs to, and then manually apply the dynamic relocations.
> 
> I'll only add that we solve the problem with kallsyms calls in kGraft. It 
> can get really cumbersome from time to time, so this work would simplify 
> our effort as well.

I haven't yet reviewed the code in-depth, but overall I think this patch
set is a good idea.  It simplifies livepatch itself as well as the patch
creation process (for both kGraft and kpatch-build), so it's a win-win.

-- 
Josh
