From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: android: binder: move to the "real" part of the
 kernel
Date: Fri, 17 Oct 2014 10:01:01 +0200
Message-ID: <20141017080101.GA20268@kroah.com>
References: <20141016124741.GA3832@kroah.com>
 <CALAqxLU05D8qQA47E77PiuuN7eVt66WEq1qn+PqdE-tpEUzFpw@mail.gmail.com>
 <20141016231221.GA13592@kroah.com>
 <CALAqxLXDZ4Q_C456o_A-V_LkcY=wpoC30kvNavyVaZRu7uK9fQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <CALAqxLXDZ4Q_C456o_A-V_LkcY=wpoC30kvNavyVaZRu7uK9fQ@mail.gmail.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: John Stultz <john.stultz@linaro.org>
Cc: devel@driverdev.osuosl.org, Anup Patel <anup.patel@linaro.org>, Linux API <linux-api@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>, Santosh Shilimkar <santosh.shilimkar@ti.com>, Rebecca Schultz Zavin <rebecca@android.com>, Sumit Semwal <sumit.semwal@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 16, 2014 at 08:25:33PM -0700, John Stultz wrote:
> On Thu, Oct 16, 2014 at 4:12 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Thu, Oct 16, 2014 at 10:09:04AM -0700, John Stultz wrote:
> >> On Thu, Oct 16, 2014 at 5:47 AM, Greg Kroah-Hartman
> >> <gregkh@linuxfoundation.org> wrote:
> >> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >> >
> >> > The Android binder code has been "stable" for many years now.  No matter
> >>
> >> Well, ignoring the ABI break that landed in the last year. :)
> >
> > As no one noticed, it wasn't a "break" :)
> >
> >> > This was discussed in the Android miniconf at the Plumbers conference.
> >> > If anyone has any objections to this, please let me know, otherwise I'm
> >> > queueing this up for 3.19-rc1
> >>
> >> So my main concerns/thoughts here are:
> >>
> >> Who is going to maintain this? Has Arve agreed?
> >
> > Do we really need someone to do more work that has been done on it in
> > the past as an official "maintainer"?  I'll be glad to do it, as I doubt
> > it will require any time at all.
> 
> Ok. The only caution I have if Arve isn't involved is that we have in
> the past merged cleanup changes that introduced bugs, and it wasn't
> until Arve took at look at the new kernel that these were sorted out
> (see e194fd8a5d8e0a7eeed239a8534460724b62fe2d). So I think if at all
> possible getting his ack on things would be good.

I'll make sure to get his Ack on anything that could possibly cause a
problem.

> But yes, I'm fine with it going in. I'm just a bit surprised at how
> quickly thoughts change here.

Over the past year I've realized that code in staging needs to progress
either out of the kernel due to no need/use, or into the main part of
the kernel as people rely on it.  The android code is something that
people rely on, and this code is "stable", so it should be merged into
the main kernel tree.

So yes, this does seem to be a change in the public stance, but it's
something that I have been talking about with people at the zillion
conferences I go to around the world.

> This does raise the question if the same standard could be held to
> ashmem then?

Ah, you beat me to it, I was going to wait to talk to you in person
about this :)

> That's a *much* simpler and easier to maintain chunk of
> code, and is just as isolated, logic wise.  And while I think it would
> be ideal if the unpinning feature could be done more generically, if
> volatile ranges really doesn't have a future, then its maybe silly to
> hold ashmem out as well?

Yes, that was the second thing I was going to move, I'll send a patch
for that later today.

thanks,

greg k-h
