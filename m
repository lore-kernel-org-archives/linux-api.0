From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v1 00/12] netoops support
Date: Wed, 03 Nov 2010 12:40:29 -0700
Message-ID: <1288813229.10236.2.camel@Joe-Laptop>
References: <20101103012917.4641.57113.stgit@crlf.mtv.corp.google.com>
	 <20101103023422.GB5782@kroah.com>
	 <AANLkTi=Oe4oJ0imCh1eoJLS0QYqSBM4pLo=dEUSiJcQb@mail.gmail.com>
	 <20101103181634.GF7441@kroah.com>
	 <20101103115020.ad8a4ecc.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101103115020.ad8a4ecc.randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Randy Dunlap <randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, simon.kagstrom-vI6UBbBVNY+JA8cjQkG2/g@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, chavey-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 2010-11-03 at 11:50 -0700, Randy Dunlap wrote:
> On Wed, 3 Nov 2010 11:16:34 -0700 Greg KH wrote:
> > On Tue, Nov 02, 2010 at 08:37:42PM -0700, Mike Waychison wrote:
> > > On Tue, Nov 2, 2010 at 7:34 PM, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org> wrote:
> > As for the user/kernel interface, perhaps exporting the data in a text
> > format that is "tagged" would be best?  Then the whole world can parse
> > it easily.
> I have been (occasionally) looking at critical kernel messages.
> IMO we really need an easy way to find them.
> They can begin with any of these strings (and others can be added
> too easily):
> BUG|panic|MCE|NMI|error:|Oops|Bad|Fatal|Unrecoverable|Unhandled|Weird
> We need a simple (single?) tagging method to identify any/all of these,
> /methinks.

Simply marking these messages KERN_CRIT or higher would seem to work.
