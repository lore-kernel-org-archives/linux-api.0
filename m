From: Chris J Arges <chris.j.arges@canonical.com>
Subject: Re: [PATCH v2] livepatch: old_name.number scheme in livepatch sysfs
 directory
Date: Thu, 5 Nov 2015 10:07:26 -0600
Message-ID: <20151105160726.GA23833@canonical.com>
References: <20151102203241.GF27488@treble.redhat.com>
 <1446505187-28970-1-git-send-email-chris.j.arges@canonical.com>
 <alpine.LNX.2.00.1511031146070.6257@pobox.suse.cz>
 <20151103145843.GH27488@treble.redhat.com>
 <alpine.LNX.2.00.1511031705340.6257@pobox.suse.cz>
 <20151103165058.GM27488@treble.redhat.com>
 <alpine.LNX.2.00.1511041047200.5621@pobox.suse.cz>
 <20151104160354.GA29899@treble.redhat.com>
 <alpine.LNX.2.00.1511051609320.13864@pobox.suse.cz>
 <20151105155656.GD28254@treble.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151105155656.GD28254@treble.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org, jeyu@redhat.com, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Nov 05, 2015 at 09:56:56AM -0600, Josh Poimboeuf wrote:
> On Thu, Nov 05, 2015 at 04:18:12PM +0100, Miroslav Benes wrote:
> > On Wed, 4 Nov 2015, Josh Poimboeuf wrote:
> > 
> > > On Wed, Nov 04, 2015 at 10:52:52AM +0100, Miroslav Benes wrote:
> > > > On Tue, 3 Nov 2015, Josh Poimboeuf wrote:
> > > > > > Object entry would be empty for not loaded object. I would not 
> > > > > > dare to propose to remove such object entries. It would make things worse. 
> > > > > 
> > > > > Why would removing an empty object entry make things worse?
> > > > 
> > > > I think it all comes down to a question whether the sysfs entries say what 
> > > > a patch is capable to patch or what this patch is currently patching in 
> > > > the system. I am inclined to the former so the removal would make me 
> > > > nervous. But I am not against the second approach. We are still in testing 
> > > > mode as far as sysfs is concerned so we can try even harsh changes and see 
> > > > how it's gonna go.
> > > 
> > > I see your point.  This approach only describes what is patched now, but
> > > it doesn't describe what *will* be patched.  Ideally we could find a way
> > > to describe both.
> > > 
> > > Speaking of harsh changes, here's an idea.
> > 
> > Which is the very same you proposed last year when I tried to persuade you 
> > to get rid off old_addr and stuff. I called it crazy I remember :D. So 
> > here we are again...
> 
> Ah, I knew I had entertained the idea before, but I forgot we discussed
> it.  It is indeed a little crazy.  But this is live patching after all
> ;-)
> 
> > > What if we require the patch author to supply the value of 'n' instead
> > > of supplying the symbol address?  We could get rid of 'old_addr' as an
> > > input in klp_func and and replace it with 'old_sympos' which has the
> > > value of 'n'.  Or alternatively we could require old_name to be of the
> > > format "func,n".
> > > 
> > > That would uniquely identify each patched function, even _before_ the
> > > object is loaded.
> > 
> > I find it reasonable and we should try it. I think that old_sympos should 
> > have this semantics
> > 
> > 0 - default, preserve more or less current behaviour. If the symbol is 
> >     unique there is no problem. If it is not the patching would fail.
> > 1, 2, ... - occurrence of the symbol in kallsyms.
> > 
> > The advantage is that if the user does not care and is certain that the 
> > symbol is unique he doesn't have to do anything. If the symbol is not 
> > unique he still has means how to solve it.
> > 
> > Does it make sense?
> 
> Sounds good!
> 
> > > It would also fix another big problem we have today, where there's no
> > > way to disambiguate duplicate symbols in modules, for both function
> > > addresses and for relocs.
> > 
> > True.
> > 
> > > It would simplify the code in other places as well: no special handling
> > > for kASLR, no need for klp_verify_vmlinux_symbol() vs
> > > klp_find_object_symbol().
> > 
> > Which would be great.
> > 
> > > A drawback is that it requires the patch author to do a little more due
> > > diligence when filling out klp_func.  But we already require them to be
> > > careful.
> > 
> > Yes, I don't think this should be a problem.
> > 
> > > Thoughts?
> > 
> > Yup, we should try it. I suppose that the order of the symbols in kallsyms 
> > table is stable for once-built kernel. It is the order of the symbols in 
> > the object files, isn't it? And since each livepatch module is built 
> > against the specific kernel there should be no issues with this.
> 
> The order of the symbols in an object's symbol table does appear to be
> the same as the order in kallsyms (per-object).  So yeah, let's try it.
> 
> -- 
> Josh
>

Great! Using this feedback to create the next patch. I'll post something in the
next few days.

--chris
 
