From: Petr Mladek <pmladek@suse.com>
Subject: Re: [RFC PATCH v2 2/6] module: preserve Elf information for
 livepatch modules
Date: Thu, 17 Dec 2015 17:28:17 +0100
Message-ID: <20151217162817.GI3729@pathway.suse.cz>
References: <1448943679-3412-1-git-send-email-jeyu@redhat.com>
 <1448943679-3412-3-git-send-email-jeyu@redhat.com>
 <20151208183212.GB14846@treble.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151208183212.GB14846@treble.redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Jessica Yu <jeyu@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, Jonathan Corbet <corbet@lwn.net>, Miroslav Benes <mbenes@suse.cz>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue 2015-12-08 12:32:12, Josh Poimboeuf wrote:
> On Mon, Nov 30, 2015 at 11:21:15PM -0500, Jessica Yu wrote:
> > For livepatch modules, copy Elf section, symbol, and string information
> > from the load_info struct in the module loader.
> > 
> > Livepatch uses special relocation sections in order to be able to patch
> > modules that are not yet loaded, as well as apply patches to the kernel
> > when the addresses of symbols cannot be determined at compile time (for
> > example, when kaslr is enabled). Livepatch modules must preserve Elf
> > information such as section indices in order to apply the remaining
> > relocation sections at the appropriate time (i.e. when the target module
> > loads).
> > 
> > Signed-off-by: Jessica Yu <jeyu@redhat.com>
> > ---
> >  include/linux/module.h |  9 +++++
> >  kernel/module.c        | 98 ++++++++++++++++++++++++++++++++++++++++++++++++--
> >  2 files changed, 105 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/linux/module.h b/include/linux/module.h
> > index 3a19c79..9b46256 100644
> > --- a/include/linux/module.h
> > +++ b/include/linux/module.h
> > @@ -425,6 +425,14 @@ struct module {
> >  
> >  	/* Notes attributes */
> >  	struct module_notes_attrs *notes_attrs;
> > +
> > +	/* Elf information (optionally saved) */
> > +	Elf_Ehdr *hdr;
> 
> I would rename "hdr" to "elf_hdr" to make its purpose clearer.
> 
> > +	Elf_Shdr *sechdrs;
> > +	char *secstrings;
> 
> Probably a good idea to add underscores to the names ("sec_hdrs" and
> "sec_strings") to be consistent with most of the other fields in the
> struct.

We should keep the names in sync with struct load_info.

> > +	struct {
> > +		unsigned int sym, str, mod, vers, info, pcpu;
> > +	} index;
> 
> I might be contradicting myself from what I said before.  But I'm
> thinking we should put all these fields inside a CONFIG_LIVEPATCH ifdef.
> Then below, there could be two versions of copy_module_elf(), the real
> one for LIVEPATCH and and an empty one for !LIVEPATCH.  And the same
> story for free_module_elf().

Yes, I would hide these fields for !LIVEPATCH.


Best Regards,
Petr
