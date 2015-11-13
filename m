From: Miroslav Benes <mbenes@suse.cz>
Subject: Re: livepatch: reuse module loader code to write relocations
Date: Fri, 13 Nov 2015 14:51:27 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1511131445550.15073@pobox.suse.cz>
References: <1447130755-17383-1-git-send-email-jeyu@redhat.com> <1447130755-17383-4-git-send-email-jeyu@redhat.com> <alpine.LNX.2.00.1511111519250.12467@pobox.suse.cz> <20151111200732.GB30025@packer-debian-8-amd64.digitalocean.com>
 <alpine.LNX.2.00.1511121601370.9440@pobox.suse.cz> <20151112174032.GG4038@treble.hsd1.ky.comcast.net> <20151112202243.GC5841@packer-debian-8-amd64.digitalocean.com> <20151112203221.GM4038@treble.hsd1.ky.comcast.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151112203221.GM4038@treble.hsd1.ky.comcast.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Jessica Yu <jeyu@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, 12 Nov 2015, Josh Poimboeuf wrote:

> On Thu, Nov 12, 2015 at 03:22:44PM -0500, Jessica Yu wrote:
> > Looking into this more, I think we do need one __klp_rela section per
> > function being patched.  Each rela section is linked to the section to
> > which the relocations apply via the rela section's sh_info field. In
> > SHT_RELA sections, the sh_info field contains the section index to
> > which the relocs apply. We cannot have one single combined rela
> > section per object as the call to apply_relocate_add() simply won't
> > work, because we would have relocs that apply to different functions
> > (and hence different sections).
> > 
> > So I guess instead of a single field in klp_object specifying the
> > __klp_rela section index, we could probably just have an array of
> > section indices.
> 
> Ok, makes sense, sounds like we need multiple klp relas per object.

Ok, it seems so.

> I still don't quite understand the benefit of caching the klp_rela
> section indices.  What problem does it solve?  It seems simpler to just
> iterate over all the sections in klp_write_object_relocations().

It was just my need to be efficient and I think it would have made sense 
with only one dynrela section per object. An array of indices is "ugly" so 
I am all for iteration over all the sections in 
klp_write_object_relocations().

Miroslav
