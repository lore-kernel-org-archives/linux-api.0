From: Christian Brauner <christian@brauner.io>
Subject: Re: [RESEND PATCH v3 2/2] sysctl: handle overflow for file-max
Date: Fri, 11 Jan 2019 15:51:41 +0100
Message-ID: <20190111145140.lbmiz3w2f255uf65@brauner.io>
References: <20190107222700.15954-1-christian@brauner.io>
 <20190107222700.15954-3-christian@brauner.io>
 <20190108070110.GA7998@light.dominikbrodowski.net>
 <20190110145004.zhc2t42aasni7wnq@brauner.io>
 <20190110145559.relfx37ocq5xu4by@isilmar-4.linta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190110145559.relfx37ocq5xu4by@isilmar-4.linta.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Dominik Brodowski <linux@dominikbrodowski.net>, akpm@linux-foundation.org
Cc: keescook@chromium.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com, mcgrof@kernel.org, joe.lawrence@redhat.com, longman@redhat.com, viro@zeniv.linux.org.uk, adobriyan@gmail.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Jan 10, 2019 at 03:55:59PM +0100, Dominik Brodowski wrote:
> On Thu, Jan 10, 2019 at 03:50:05PM +0100, Christian Brauner wrote:
> > On Tue, Jan 08, 2019 at 08:01:10AM +0100, Dominik Brodowski wrote:
> > > On Mon, Jan 07, 2019 at 11:27:00PM +0100, Christian Brauner wrote:
> > > > @@ -2833,6 +2836,10 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int
> > > >  				break;
> > > >  			if (neg)
> > > >  				continue;
> > > > +			if ((max && val > *max) || (min && val < *min)) {
> > > > +				err = -EINVAL;
> > > > +				break;
> > > > +			}
> > > >  			val = convmul * val / convdiv;
> > > >  			if ((min && val < *min) || (max && val > *max))
> > > >  				continue;
> > > 
> > > This is a generic change which affects all users of
> > > do_proc_doulongvec_minmax() that have extra1 or extra2 set. In sysctl.c, I
> > > do not see another user of proc_doulongvec_minmax() that has extra1 or
> > > extra2 set. However, have you verified whether your patch changes the
> > > behaviour for other files that make use of proc_doulongvec_minmax() or
> > > proc_doulongvec_ms_jiffies_minmax(), and not only of the file-max sysctl?
> > 
> > Sorry for the delayed reply. I did look at the callers. The functions
> > that are of interest afaict are:
> > 
> > proc_doulongvec_ms_jiffies_minmax
> > proc_doulongvec_minmax
> > 
> > So this could be visible when users write values that would overflow the
> > type used in the kernel.
> >
> > I guess your point is whether we are venturing into userspace break
> > territory. Hm... We should probably make sure that we're not regressing
> > anyone else! What do you think if instead of the above patch we did:
> 
> Hm, I prefer the original patch -- as the same (valid) reasons which apply
> for the file-max sysctl might also apply to other users of this function
> where extra1 and/or2 extra2 are set.
> 
> If there are no other users of this function where extra1 or extra2 are set,
> just add a comment in the commit message:
> 
> 	While this changes the behaviour of __do_proc_doulongvec_minmax(),
> 	no other existing users in the kernel are affected by this change.
> 
> If there are other users of this function where extra1 or extra2 are set,
> you would need to generalize the commit message overall.

Andrew, can you please drop this patch

[RESEND PATCH v3 2/2] sysctl: handle overflow for file-max

from your tree (It should be located at [1] from what I can gather.).
I'll resend it based on Dominik's observation and will generalize the
commit message and also error out *after* the conversion has been done
and not before.
The first patch 1/2 is correct and can be kept.

Thanks!
Christian

[1]: https://www.ozlabs.org/~akpm/mmots/broken-out/sysctl-handle-overflow-for-file-max.patch
