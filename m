From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [PATCH] sysfs.txt: update show method notes about
 sprintf/snprintf/scnprintf usage
Date: Thu, 25 Jun 2015 16:05:28 +0900
Message-ID: <20150625070528.GA601@swordfish>
References: <DDB9C85B850785449757F9914A034FCB3F8EA364@G4W3219.americas.hpqcorp.net>
 <20150625015957.GB3365@swordfish>
 <20150625060305.GA11905@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150625060305.GA11905@kroah.com>
Sender: linux-doc-owner@vger.kernel.org
To: "Greg KH <gregkh@linuxfoundation.org> (gregkh@linuxfoundation.org)" <gregkh@linuxfoundation.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, "Seymour, Shane M" <shane.seymour@hp.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org


Cc Jonathan and linux-doc

On (06/24/15 23:03), Greg KH <gregkh@linuxfoundation.org> (gregkh@linuxfoundation.org) wrote:
[..]
> > > -- show() should always use scnprintf().
> > > +- show() must not use snprintf() when formatting a value to be
> > > +  returned to user space. For small single values you can use
> > > +  sprintf() otherwise you must use scnprintf().
> > 
> > Well, a single value can easily overflow
> > 
> > 	sprintf(buf, "%s", dev->large_value);
> 
> That's an obviously foolish sysfs attribute, if you do that, you deserve
> the kernel crash :)

:)

And the 'always use scnprintf()' rule keeps all of us on the safe
side (almost for free).

> > Probably the wording better be "if you guarantee that overflow will
> > never happen, then you can use ...".
> 
> For a document that no one has obviously read in the past 5 years, I
> really doubt we need to work too hard on the exact specific wording of
> it.

Oh, it's especially pleasant and satisfactory to ignore
a well-written and scrupulous documentation  :)  just kidding.

	-ss
