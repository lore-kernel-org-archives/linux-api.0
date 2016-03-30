From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: (mostly) Arch-independent livepatch
Date: Wed, 30 Mar 2016 09:10:09 +0200
Message-ID: <20160330071009.GA3551@osiris>
References: <1458691399-20078-1-git-send-email-jeyu@redhat.com>
 <20160329211330.GA1253@packer-debian-8-amd64.digitalocean.com>
 <alpine.LNX.2.00.1603300122020.3656@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1603300122020.3656@cbobk.fhfr.pm>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Kosina <jikos@kernel.org>
Cc: Jessica Yu <jeyu@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Petr Mladek <pmladek@suse.com>, Jonathan Corbet <corbet@lwn.net>, Miroslav Benes <mbenes@suse.cz>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 30, 2016 at 01:24:08AM +0200, Jiri Kosina wrote:
> On Tue, 29 Mar 2016, Jessica Yu wrote:
> 
> > > v6:
> > > - Since we hard-code the field widths for the objname and symbol name
> > >   for the sscanf() calls, which are supposed to correspond to the values
> > >   of MODULE_NAME_LEN and KSYM_NAME_LEN, use BUILD_BUG_ON() to detect when
> > >   the values of these constants deviate from the expected values.
> > > - Squash the sample livepatch module patch into patch 4
> > >   ("livepatch: reuse module loader code to write relocations") so
> > >   git bisects don't break
> > > - Don't need the klp_buf struct, just use plain char arrays to hold the
> > >   output of sscanf(). Also, no need to clear the bufs after every
> > >   invocation, as sscanf() takes care to put a null byte at the end of
> > >   the bufs.
> > > - Fix compiler kbuild errors for the !CONFIG_LIVEPATCH case
> > > - Fixed some small module.c nits
> > > 
> > 
> > Pinging Rusty, just in case this thread got buried :-)
> > How do the module.c changes look?
> 
> Plus there are (admittedly indeed rather small and trivial) changes to 
> s390 module loader, so I'd prefer to have Heiko's / Martin's Ack before 
> merging this.
> 
> Hence, let me piggy back on this ping to Rusty, and let me ping Heiko and 
> Martin as well (adding to CC explicitly to make sure this doesn't get lost 
> in general noise).

For the s390 changes:
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Jessica, thanks for also writing the documentation!
