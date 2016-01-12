From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [RFC PATCH v3 6/6] Documentation: livepatch: outline the Elf
 format of a livepatch module
Date: Tue, 12 Jan 2016 08:45:08 -0600
Message-ID: <20160112144508.GB310@treble.redhat.com>
References: <1452281304-28618-1-git-send-email-jeyu@redhat.com>
 <1452281304-28618-7-git-send-email-jeyu@redhat.com>
 <20160112120951.GO731@pathway.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160112120951.GO731@pathway.suse.cz>
Sender: linux-doc-owner@vger.kernel.org
To: Petr Mladek <pmladek@suse.com>
Cc: Jessica Yu <jeyu@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, Jonathan Corbet <corbet@lwn.net>, Miroslav Benes <mbenes@suse.cz>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Jan 12, 2016 at 01:09:51PM +0100, Petr Mladek wrote:
> Hi Jessica,
> 
> first, thanks a lot for writing a documentation. It is really
> appreciated!
> 
> To be honest, I am not sure if it makes sense to give feedback
> at this stage. It seems that there still will be some changes
> in the elf format.
> 
> On Fri 2016-01-08 14:28:24, Jessica Yu wrote:
> > Document the special Elf sections and constants livepatch modules use.
> > 
> > Signed-off-by: Jessica Yu <jeyu@redhat.com>
> > ---
> >  Documentation/livepatch/patch-module-format.txt | 106 ++++++++++++++++++++++++
> >  1 file changed, 106 insertions(+)
> >  create mode 100644 Documentation/livepatch/patch-module-format.txt
> 
> I would call this symbol-relocation.txt or so. It describes only this
> part of the patch format.
> 
> > 
> > diff --git a/Documentation/livepatch/patch-module-format.txt b/Documentation/livepatch/patch-module-format.txt
> > new file mode 100644
> > index 0000000..d825629
> > --- /dev/null
> > +++ b/Documentation/livepatch/patch-module-format.txt
> > @@ -0,0 +1,106 @@
> > +---------------------------
> > +Livepatch module Elf format
> > +---------------------------
> 
> I would start with a description what symbols are relocated and why
> it needs to be done a special way.

The cover letter has this information, and a lot of other useful
background.  It would be good to add all that background to this
document as an introduction.

-- 
Josh
