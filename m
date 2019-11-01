From: Steve Grubb <sgrubb@redhat.com>
Subject: Re: [PATCH ghak90 V7 20/21] audit: add capcontid to set contid outside init_user_ns
Date: Fri, 01 Nov 2019 11:13:45 -0400
Message-ID: <1592218.lpl3eoh2c6@x2>
References: <cover.1568834524.git.rgb@redhat.com> <3677995.NTHC7m0fHc@x2> <20191101150927.c5sf3n5ezfg2eano@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191101150927.c5sf3n5ezfg2eano@madcap2.tricolour.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Guy Briggs <rgb@redhat.com>
Cc: nhorman@tuxdriver.com, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com, Linux-Audit Mailing List <linux-audit@redhat.com>, netfilter-devel@vger.kernel.org, ebiederm@xmission.com, simo@redhat.com, netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>, mpatel@redhat.com, Serge Hallyn <serge@hallyn.com>
List-Id: linux-api@vger.kernel.org

On Friday, November 1, 2019 11:09:27 AM EDT Richard Guy Briggs wrote:
> On 2019-10-31 10:50, Steve Grubb wrote:
> > Hello,
> > 
> > TLDR;  I see a lot of benefit to switching away from procfs for setting
> > auid & sessionid.
> > 
> > On Wednesday, October 30, 2019 6:03:20 PM EDT Richard Guy Briggs wrote:
> > > > Also, for the record, removing the audit loginuid from procfs is not
> > > > something to take lightly, if at all; like it or not, it's part of
> > > > the
> > > > kernel API.
> > 
> > It can also be used by tools to iterate processes related to one user or
> > session. I use this in my Intrusion Prevention System which will land in
> > audit user space at some point in the future.
> > 
> > > Oh, I'm quite aware of how important this change is and it was
> > > discussed
> > > with Steve Grubb who saw the concern and value of considering such a
> > > disruptive change.
> > 
> > Actually, I advocated for syscall. I think the gist of Eric's idea was
> > that / proc is the intersection of many nasty problems. By relying on
> > it, you can't simplify the API to reduce the complexity. Almost no
> > program actually needs access to /proc. ps does. But almost everything
> > else is happy without it. For example, when you setup chroot jails, you
> > may have to add /dev/random or / dev/null, but almost never /proc. What
> > does force you to add /proc is any entry point daemon like sshd because
> > it needs to set the loginuid. If we switch away from /proc, then sshd or
> > crond will no longer /require/ procfs to be available which again
> > simplifies the system design.
> > 
> > > Removing proc support for auid/ses would be a
> > > long-term deprecation if accepted.
> > 
> > It might need to just be turned into readonly for a while. But then
> > again,
> > perhaps auid and session should be part of /proc/<pid>/status? Maybe this
> > can be done independently and ahead of the container work so there is a
> > migration path for things that read auid or session. TBH, maybe this
> > should have been done from the beginning.
> 
> How about making loginuid/contid/capcontid writable only via netlink but
> still provide the /proc interface for reading?  Deprecation of proc can
> be left as a decision for later.  This way sshd/crond/getty don't need
> /proc, but the info is still there for tools that want to read it.

This also sounds good to me. But I still think loginuid and audit sessionid 
should get written in /proc/<pid>/status so that all process information is 
consolidated in one place.

-Steve
