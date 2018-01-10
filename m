From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: RFC(V3): Audit Kernel Container IDs
Date: Wed, 10 Jan 2018 01:54:45 -0500
Message-ID: <20180110065445.d2i4uuwnf44gvbl5@madcap2.tricolour.ca>
References: <20180109121620.wi7dq2423ugsraqv@madcap2.tricolour.ca>
 <87k1wqcykw.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87k1wqcykw.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: cgroups@vger.kernel.org, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Linux Audit <linux-audit@redhat.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Linux Network Development <netdev@vger.kernel.org>, Simo Sorce <simo@redhat.com>, Carlos O'Donell <carlos@redhat.com>, Aristeu Rozanski <arozansk@redhat.com>, David Howells <dhowells@redhat.com>, Eric Paris <eparis@parisplace.org>, Daniel Walsh <dwalsh@redhat.com>, jlayton@redhat.com, Andy Lutomirski <luto@kernel.org>, mszeredi@redhat.com, Paul Moore <pmoore@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Steve Grubb <sgrubb@redhat.com>, trondmy@primarydata.com, Al Viro <viro@zeniv.linux.org.uk>, Ma
List-Id: linux-api@vger.kernel.org

On 2018-01-09 19:05, Eric W. Biederman wrote:
> Please let's have a description of the problem you are trying to solve.

I thought the first sentence of the second paragraph summed it up rather
well.

Here are the elaborated motivations:

- Filter unwanted, irrelevant or unimportant messages before they fill
  queue so important messages don't get lost.  This is a certification
  requirement.

- Make security claims about containers, require tracking of actions
  within those containers to ensure compliance with established security
  policies.

- Route messages from events to local audit daemon instance or host
  audit daemon instance

- Tried nsIDs, but insufficient for efficient filtering, routing,
  tracking

> A proposed solution without talking about the problem space is useless.
> Any proposed solution could potentially work.
> 
> I know to these exist.  There is motivation for your work.
> What is the motivation?
> What problem are you trying to solve?
> 
> In particular what information are you trying to get into logs that you
> can not get into the logs today?
> 
> I am going to try to give this the attention it deserves but right now I
> am having to deal with half thought out patches for information leaks
> from speculative code paths, so I won't be able to give this much
> attention for a little bit.
> 
> Eric

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
