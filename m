From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
Subject: Re: [PATCH v1 00/12] netoops support
Date: Wed, 3 Nov 2010 21:58:51 +0100
Message-ID: <20101103215851.2df7723f@neptune.home>
References: <20101103012917.4641.57113.stgit@crlf.mtv.corp.google.com>
	<20101103023422.GB5782@kroah.com>
	<AANLkTi=Oe4oJ0imCh1eoJLS0QYqSBM4pLo=dEUSiJcQb@mail.gmail.com>
	<20101103181634.GF7441@kroah.com>
	<20101103115020.ad8a4ecc.randy.dunlap@oracle.com>
	<1288813229.10236.2.camel@Joe-Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1288813229.10236.2.camel@Joe-Laptop>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Mike Waychison <mikew@google.com>, Randy Dunlap <randy.dunlap@oracle.com>, Greg KH <gregkh@suse.de>, simon.kagstrom@netinsight.net, davem@davemloft.net, adurbin@google.com, akpm@linux-foundation.org, chavey@google.com, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, 03 November 2010 Joe Perches wrote:
> On Wed, 2010-11-03 at 11:50 -0700, Randy Dunlap wrote:
> > On Wed, 3 Nov 2010 11:16:34 -0700 Greg KH wrote:
> > > On Tue, Nov 02, 2010 at 08:37:42PM -0700, Mike Waychison wrote:
> > > > On Tue, Nov 2, 2010 at 7:34 PM, Greg KH wrote:
> > > As for the user/kernel interface, perhaps exporting the data in a text
> > > format that is "tagged" would be best?  Then the whole world can parse
> > > it easily.
> > I have been (occasionally) looking at critical kernel messages.
> > IMO we really need an easy way to find them.
> > They can begin with any of these strings (and others can be added
> > too easily):
> > BUG|panic|MCE|NMI|error:|Oops|Bad|Fatal|Unrecoverable|Unhandled|Weird
> > We need a simple (single?) tagging method to identify any/all of these,
> > /methinks.
> 
> Simply marking these messages KERN_CRIT or higher would seem to work.

That's an idea (probably better higher that can be enabled on a console with
a specific flag), though it also invites for filter levels on a per-console
base (e.g. let uart only show KERN_WARN..KERN_CRIT but having more verbosity
on termial or netconsole [per target]).

I've been playing with this last winter, need to dig out that code again and
clean it up for sharing.

Bruno
