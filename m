From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 7/9] [media] v4l2: introduce v4l2_timeval
Date: Fri, 18 Sep 2015 12:08:25 +0200
Message-ID: <4764782.hLp7DObtr0@wuerfel>
References: <1442524780-781677-1-git-send-email-arnd@arndb.de> <9019880.VVdOR6WRt1@wuerfel> <55FBDEDC.8040204@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55FBDEDC.8040204@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org, y2038@lists.linaro.org, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, linux-api@vger.kernel.org, linux-samsung-soc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Friday 18 September 2015 11:52:28 Hans Verkuil wrote:
> On 09/18/15 11:43, Arnd Bergmann wrote:
> > On Friday 18 September 2015 11:27:40 Hans Verkuil wrote:
> >> Ah, OK. Got it.
> >>
> >> I think this is dependent on the upcoming media workshop next month. If we
> >> decide to redesign v4l2_buffer anyway, then we can avoid timeval completely.
> >> And the only place where we would need to convert it in the compat code
> >> hidden in the v4l2 core (likely v4l2-ioctl.c).
> > 
> > Ah, I think I understood the idea now, I missed that earlier when you mention
> > the idea.
> > 
> > So what you are saying here is that you could come up with a new unambiguous
> > (using only __u32 and __u64 types and no pointers) format that gets exposed
> > to a new set of ioctls, and then change the handling of the existing three
> > formats (native 64-bit, traditional 32-bit, and 32-bit with 64-bit time_t)
> > so they get converted into the new format by the common ioctl handling code?
> 
> Right. Drivers only see the new struct, and only v4l2-ioctl.c (and possible
> v4l2-compat-ioctl32.c) see the old ones.
> 
> BTW, I will probably pick up patches 4 and 6 for 4.4. That should help a bit.

Ok, thanks!

I guess it's up to Mauro to pick up the first three patches?

As I don't see anything more to do for me here until you've had the
discussion about the new format, I'll move on to another subsystem now.
I have around 70 patches waiting to be submitted, plus the system call
series.

	Arnd
