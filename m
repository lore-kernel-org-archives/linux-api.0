From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH, v10 3/3] cgroups: introduce timer slack controller
Date: Mon, 17 Oct 2011 09:34:37 +0200
Message-ID: <1318836877.6594.26.camel@twins>
References: <1318349729-3108-1-git-send-email-kirill@shutemov.name>
	 <1318349729-3108-4-git-send-email-kirill@shutemov.name>
	 <20111014154348.ae6267aa.akpm@linux-foundation.org>
	 <20111015112006.GA10173@tango.0pointer.de> <1318705910.2664.5.camel@laptop>
	 <20111017013921.GA30035@tango.0pointer.de>
	 <20111017032232.GA4816@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111017032232.GA4816@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg@redhat.com>
Cc: Lennart Poettering <mzxreary@0pointer.de>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>, containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com, Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org, Matt Helsley <matthltc@us.ibm.com>, linux-api@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>, harald@redhat.com, david@fubar.dk, greg@kroah.com
List-Id: linux-api@vger.kernel.org

On Mon, 2011-10-17 at 04:22 +0100, Matthew Garrett wrote:
> 
> I agree. We can't assume perfect software, and I don't think *requiring* 
> the duplication of this functionality in every single session 
> application is sensible. We want to be able to shut down timer based 
> code when the session is idle. We could do this by exposing the slack in 
> /proc. We could do this by modifying every piece of code to listen for 
> session idle events and (independently) enact session-wide policy. Or we 
> could just accept that it's a problem that maps onto what people are 
> already using cgroups for and implement it in the same way. 

So what about the app that is both screen oriented and has a server
part, say some multi-player game thing. Suppose you run one as a server
but leave the client idle (you go have dinner with a pretty lady instead
of playing quake, but leave your machine up to serve for your nerd
friends).

Should your friends get punished with a horrible gaming experience just
because you're having a good time IRL and your screen went blank?

Sure pushing up timer slack will save you power, but it will also hurt
people, what will you do for them? The same that you do for those that
want to run a CGROUP=n kernel?
