From: Steve Grubb <sgrubb@redhat.com>
Subject: Re: [PATCH ghak90 V8 13/16] audit: track container nesting
Date: Tue, 04 Feb 2020 13:12:02 -0500
Message-ID: <35934535.C1y6eIYgqz@x2>
References: <cover.1577736799.git.rgb@redhat.com> <3665686.i1MIc9PeWa@x2> <CAHC9VhRHfjuv5yyn+nQ2LbHtcezBcjKtOQ69ssYrXOiExuCjBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAHC9VhRHfjuv5yyn+nQ2LbHtcezBcjKtOQ69ssYrXOiExuCjBw@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Paul Moore <paul@paul-moore.com>
Cc: Richard Guy Briggs <rgb@redhat.com>, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com, nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>, mpatel@redhat.com
List-Id: linux-api@vger.kernel.org

On Tuesday, February 4, 2020 10:52:36 AM EST Paul Moore wrote:
> On Tue, Feb 4, 2020 at 10:47 AM Steve Grubb <sgrubb@redhat.com> wrote:
> > On Tuesday, February 4, 2020 8:19:44 AM EST Richard Guy Briggs wrote:
> > > > The established pattern is that we print -1 when its unset and "?"
> > > > when
> > > > its totalling missing. So, how could this be invalid? It should be
> > > > set
> > > > or not. That is unless its totally missing just like when we do not
> > > > run
> > > > with selinux enabled and a context just doesn't exist.
> > > 
> > > Ok, so in this case it is clearly unset, so should be -1, which will be
> > > a
> > > 20-digit number when represented as an unsigned long long int.
> > > 
> > > Thank you for that clarification Steve.
> > 
> > It is literally a  -1.  ( 2 characters)
> 
> Well, not as Richard has currently written the code, it is a "%llu".
> This was why I asked the question I did; if we want the "-1" here we
> probably want to special case that as I don't think we want to display
> audit container IDs as signed numbers in general.

OK, then go with the long number, we'll fix it in the interpretation. I guess 
we do the same thing for auid.

-Steve
