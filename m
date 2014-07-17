From: Zach Brown <zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org>
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Date: Thu, 17 Jul 2014 14:39:06 -0700
Message-ID: <20140717213906.GD24196@lenny.home.zabbo.net>
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
 <20140717194812.GC24196@lenny.home.zabbo.net>
 <20140717205417.GT1491@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140717205417.GT1491-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, beck-7YlrpqBBQ3VAfugRpC6u6w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Jul 17, 2014 at 04:54:17PM -0400, Theodore Ts'o wrote:
> On Thu, Jul 17, 2014 at 12:48:12PM -0700, Zach Brown wrote:
> > 
> > > +	return urandom_read(NULL, buf, count, NULL);
> > 
> > I wonder if we want to refactor the entry points a bit more instead of
> > directly calling the device read functions.
> 
> I could refactor the entropy point, but it probably wouldn't add any
> extra bloat, since the compiler would hopefully compile it away, but
> adding the extra static function would seem to make things less
> readable at least in my opinion.

Fair enough, I don't have a strong preference either way.  It was just
something I noticed when leafing through the (unfamiliar) code.

- z
