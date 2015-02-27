From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH] fork: report pid reservation failure properly
Date: Fri, 27 Feb 2015 09:22:16 +0100
Message-ID: <20150227082216.GB30001@dhcp22.suse.cz>
References: <20150204102719.GB29434@dhcp22.suse.cz>
 <1423046628-23638-1-git-send-email-mhocko@suse.cz>
 <20150223201701.GA28639@dhcp22.suse.cz>
 <20150226144908.5e3d354d7b24174e90089721@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150226144908.5e3d354d7b24174e90089721@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-api@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Michael Kerrisk <mtk.manpages@gmail.com>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu 26-02-15 14:49:08, Andrew Morton wrote:
> On Mon, 23 Feb 2015 21:17:01 +0100 Michal Hocko <mhocko@suse.cz> wrote:
> 
> > ping on this one? Should I just resend (your way Andrew)? Or are there
> > any objections to the patch as is.
> 
> Were Eric's concerns all addressed?

I hope so. I didn't touch pid namespace parts and they return ENOMEM as
before.

> Oleg: wake up ;)
> 
> Overall it looks like a pretty minor issue?

I believe so. It should help deubugging when pid space is exhausted
because getting ENOMEM under that situation is really awkward and the
real reason for failure is hard to find out.

-- 
Michal Hocko
SUSE Labs
