From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [PATCH V6 07/10] sched: add a macro to ref all CLONE_NEW* flags
Date: Fri, 17 Apr 2015 11:42:50 -0400
Message-ID: <20150417154250.GA26233@madcap2.tricolour.ca>
References: <cover.1429252659.git.rgb@redhat.com>
 <cf1ed24f71743ea7f85682f26f3185202a1f8a32.1429252659.git.rgb@redhat.com>
 <20150417081843.GE23123@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150417081843.GE23123@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, linux-audit@redhat.com, sgrubb@redhat.com, eparis@parisplace.org, pmoore@redhat.com, arozansk@redhat.com, ebiederm@xmission.com, serge@hallyn.com, zohar@linux.vnet.ibm.com, linux-api@vger.kernel.org, mingo@redhat.com
List-Id: linux-api@vger.kernel.org

On 15/04/17, Peter Zijlstra wrote:
> On Fri, Apr 17, 2015 at 03:35:54AM -0400, Richard Guy Briggs wrote:
> > Added the macro CLONE_NEW_MASK_ALL to refer to all CLONE_NEW* flags.
> 
> A wee bit about why might be nice..

It makes the following patch much cleaner to read:
	[PATCH V6 08/10] fork: audit on creation of new namespace(s)
	https://lkml.org/lkml/2015/4/17/50

I was hoping it might also make a lot of other code cleaner, but most of
the other places where multiple CLONE_NEW* flags are used, not all six
are used together, but only 5 are used.  Ok, so it is helpful in 1 of 3:

It would actually be useful in check_unshare_flags():
	https://github.com/torvalds/linux/blob/v3.17/kernel/fork.c#L1791

but not in copy_namespaces() or unshare_nsproxy_namespaces():
	https://github.com/torvalds/linux/blob/v3.17/kernel/nsproxy.c#L130
	https://github.com/torvalds/linux/blob/v3.17/kernel/nsproxy.c#L183

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
