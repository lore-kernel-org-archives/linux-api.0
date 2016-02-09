From: Miroslav Benes <mbenes@suse.cz>
Subject: Re: [RFC PATCH v4 4/6] livepatch: reuse module loader code to write
 relocations
Date: Tue, 9 Feb 2016 14:32:05 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1602091431080.13193@pobox.suse.cz>
References: <1454548271-24923-1-git-send-email-jeyu@redhat.com> <1454548271-24923-5-git-send-email-jeyu@redhat.com> <alpine.LNX.2.00.1602081554320.12964@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1602081554320.12964@pobox.suse.cz>
Sender: linux-doc-owner@vger.kernel.org
To: Jessica Yu <jeyu@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, Jonathan Corbet <corbet@lwn.net>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org


> > +/* .klp.sym.[objname].symbol_name,sympos */
> > +static int klp_get_sym_objname(char *s, char **result)
> > +{
> 
> Do we need result to be a double-pointer? If I am not mistaken just 'char 
> *result' could be sufficient. You check the return value, so result could 
> be NULL or objname as found. No?

Um, no. We need this. Sorry for the noise.

Miroslav
