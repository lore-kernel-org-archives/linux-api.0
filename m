From: Steve Grubb <sgrubb@redhat.com>
Subject: Re: [PATCH ghak90 V7 20/21] audit: add capcontid to set contid outside init_user_ns
Date: Thu, 31 Oct 2019 10:50:57 -0400
Message-ID: <3677995.NTHC7m0fHc@x2>
References: <cover.1568834524.git.rgb@redhat.com> <CAHC9VhRDoX9du4XbCnBtBzsNPMGOsb-TKM1CC+sCL7HP=FuTRQ@mail.gmail.com> <20191030220320.tnwkaj5gbzchcn7j@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 7Bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20191030220320.tnwkaj5gbzchcn7j@madcap2.tricolour.ca>
Sender: netdev-owner@vger.kernel.org
To: Richard Guy Briggs <rgb@redhat.com>
Cc: Paul Moore <paul@paul-moore.com>, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com, nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>, mpatel@redhat.com
List-Id: linux-api@vger.kernel.org

Hello,

TLDR;  I see a lot of benefit to switching away from procfs for setting auid & 
sessionid.

On Wednesday, October 30, 2019 6:03:20 PM EDT Richard Guy Briggs wrote:
> > Also, for the record, removing the audit loginuid from procfs is not
> > something to take lightly, if at all; like it or not, it's part of the
> > kernel API.

It can also be used by tools to iterate processes related to one user or 
session. I use this in my Intrusion Prevention System which will land in 
audit user space at some point in the future.


> Oh, I'm quite aware of how important this change is and it was discussed
> with Steve Grubb who saw the concern and value of considering such a
> disruptive change.

Actually, I advocated for syscall. I think the gist of Eric's idea was that /
proc is the intersection of many nasty problems. By relying on it, you can't 
simplify the API to reduce the complexity. Almost no program actually needs 
access to /proc. ps does. But almost everything else is happy without it. For 
example, when you setup chroot jails, you may have to add /dev/random or /
dev/null, but almost never /proc. What does force you to add /proc is any 
entry point daemon like sshd because it needs to set the loginuid. If we 
switch away from /proc, then sshd or crond will no longer /require/ procfs to 
be available which again simplifies the system design.


> Removing proc support for auid/ses would be a
> long-term deprecation if accepted.

It might need to just be turned into readonly for a while. But then again, 
perhaps auid and session should be part of /proc/<pid>/status? Maybe this can 
be done independently and ahead of the container work so there is a migration 
path for things that read auid or session. TBH, maybe this should have been 
done from the beginning.

-Steve
