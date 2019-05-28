From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH ghak90 V6 00/10] audit: implement container identifier
Date: Tue, 28 May 2019 18:26:47 -0400
Message-ID: <CAHC9VhRW9f6GbhvvfifbOzd9p=PgdB2gq1E7tACcaqvfb85Y8A@mail.gmail.com>
References: <cover.1554732921.git.rgb@redhat.com> <20190422113810.GA27747@hmswarspite.think-freely.org>
 <CAHC9VhQYPF2ma_W+hySbQtfTztf=K1LTFnxnyVK0y9VYxj-K=w@mail.gmail.com> <509ea6b0-1ac8-b809-98c2-37c34dd98ca3@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <509ea6b0-1ac8-b809-98c2-37c34dd98ca3@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Walsh <dwalsh@redhat.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, Richard Guy Briggs <rgb@redhat.com>, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com, Mrunal Patel <mpatel@redhat.com>
List-Id: linux-api@vger.kernel.org

On Tue, May 28, 2019 at 5:54 PM Daniel Walsh <dwalsh@redhat.com> wrote:
>
> On 4/22/19 9:49 AM, Paul Moore wrote:
> > On Mon, Apr 22, 2019 at 7:38 AM Neil Horman <nhorman@tuxdriver.com> wrote:
> >> On Mon, Apr 08, 2019 at 11:39:07PM -0400, Richard Guy Briggs wrote:
> >>> Implement kernel audit container identifier.
> >> I'm sorry, I've lost track of this, where have we landed on it? Are we good for
> >> inclusion?
> > I haven't finished going through this latest revision, but unless
> > Richard made any significant changes outside of the feedback from the
> > v5 patchset I'm guessing we are "close".
> >
> > Based on discussions Richard and I had some time ago, I have always
> > envisioned the plan as being get the kernel patchset, tests, docs
> > ready (which Richard has been doing) and then run the actual
> > implemented API by the userland container folks, e.g. cri-o/lxc/etc.,
> > to make sure the actual implementation is sane from their perspective.
> > They've already seen the design, so I'm not expecting any real
> > surprises here, but sometimes opinions change when they have actual
> > code in front of them to play with and review.
> >
> > Beyond that, while the cri-o/lxc/etc. folks are looking it over,
> > whatever additional testing we can do would be a big win.  I'm
> > thinking I'll pull it into a separate branch in the audit tree
> > (audit/working-container ?) and include that in my secnext kernels
> > that I build/test on a regular basis; this is also a handy way to keep
> > it based against the current audit/next branch.  If any changes are
> > needed Richard can either chose to base those changes on audit/next or
> > the separate audit container ID branch; that's up to him.  I've done
> > this with other big changes in other trees, e.g. SELinux, and it has
> > worked well to get some extra testing in and keep the patchset "merge
> > ready" while others outside the subsystem look things over.
> >
> Mrunal Patel (maintainer of CRI-O) and I have reviewed the API, and
> believe this is something we can work on in the container runtimes team
> to implement the container auditing code in CRI-O and Podman.

Thanks Dan.  If I pulled this into a branch and built you some test
kernels to play with, any idea how long it might take to get a proof
of concept working on the cri-o side?

FWIW, I've also reached out to some of the LXC folks I know to get
their take on the API.  I think if we can get two different container
runtimes to give the API a thumbs-up then I think we are in good shape
with respect to the userspace interface.

I just finished looking over the last of the pending audit kernel
patches that were queued waiting for the merge window to open so this
is next on my list to look at.  I plan to start doing that
tonight/tomorrow, and as long as the changes between v5/v6 are not
that big, it shouldn't take too long.

-- 
paul moore
www.paul-moore.com
