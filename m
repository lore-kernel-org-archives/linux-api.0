From: Lennart Poettering <mzxreary@0pointer.de>
Subject: Re: [PATCH, v10 3/3] cgroups: introduce timer slack controller
Date: Mon, 17 Oct 2011 15:55:23 +0200
Message-ID: <20111017135522.GA8855@tango.0pointer.de>
References: <1318349729-3108-1-git-send-email-kirill@shutemov.name>
 <1318349729-3108-4-git-send-email-kirill@shutemov.name>
 <20111014154348.ae6267aa.akpm@linux-foundation.org>
 <20111015112006.GA10173@tango.0pointer.de>
 <1318705910.2664.5.camel@laptop>
 <20111017013921.GA30035@tango.0pointer.de>
 <20111017032232.GA4816@srcf.ucam.org>
 <1318836877.6594.26.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1318836877.6594.26.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Matthew Garrett <mjg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>, containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com, Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org, Matt Helsley <matthltc@us.ibm.com>, linux-api@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>, harald@redhat.com, david@fubar.dk, greg@kroah.com
List-Id: linux-api@vger.kernel.org

On Mon, 17.10.11 09:34, Peter Zijlstra (peterz@infradead.org) wrote:

> 
> On Mon, 2011-10-17 at 04:22 +0100, Matthew Garrett wrote:
> > 
> > I agree. We can't assume perfect software, and I don't think *requiring* 
> > the duplication of this functionality in every single session 
> > application is sensible. We want to be able to shut down timer based 
> > code when the session is idle. We could do this by exposing the slack in 
> > /proc. We could do this by modifying every piece of code to listen for 
> > session idle events and (independently) enact session-wide policy. Or we 
> > could just accept that it's a problem that maps onto what people are 
> > already using cgroups for and implement it in the same way. 
> 
> So what about the app that is both screen oriented and has a server
> part, say some multi-player game thing. Suppose you run one as a server
> but leave the client idle (you go have dinner with a pretty lady instead
> of playing quake, but leave your machine up to serve for your nerd
> friends).
> 
> Should your friends get punished with a horrible gaming experience just
> because you're having a good time IRL and your screen went blank?

Well, there's already an API to ensure that sessions are not considered
idle, which is used by movie players and such to disable screen
savers.

> Sure pushing up timer slack will save you power, but it will also hurt
> people, what will you do for them? The same that you do for those that
> want to run a CGROUP=n kernel?

As you might have noticed already I am not overly concerned about
those. And anyway, if you don't enable the timer slack cgroup controller
we won't make use of it, it's that easy.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
