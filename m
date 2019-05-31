From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v1 1/2] fork: add clone3
Date: Sat, 1 Jun 2019 00:08:59 +0200
Message-ID: <20190531220858.nyr7kdduk4auu67m@brauner.io>
References: <20190529152237.10719-1-christian@brauner.io>
 <20190529222414.GA6492@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190529222414.GA6492@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrei Vagin <avagin@gmail.com>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, jannh@google.com, fweimer@redhat.com, oleg@redhat.com, arnd@arndb.de, dhowells@redhat.com, Pavel Emelyanov <xemul@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, Adrian Reber <adrian@lisas.de>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, May 29, 2019 at 03:24:15PM -0700, Andrei Vagin wrote:
> On Wed, May 29, 2019 at 05:22:36PM +0200, Christian Brauner wrote:
> > This adds the clone3 system call.
> > 
> > As mentioned several times already (cf. [7], [8]) here's the promised
> > patchset for clone3().
> > 
> > We recently merged the CLONE_PIDFD patchset (cf. [1]). It took the last
> > free flag from clone().
> > 
> > Independent of the CLONE_PIDFD patchset a time namespace has been discussed
> > at Linux Plumber Conference last year and has been sent out and reviewed
> > (cf. [5]). It is expected that it will go upstream in the not too distant
> > future. However, it relies on the addition of the CLONE_NEWTIME flag to
> > clone(). The only other good candidate - CLONE_DETACHED - is currently not
> > recyclable as we have identified at least two large or widely used
> > codebases that currently pass this flag (cf. [2], [3], and [4]). Given that
> > CLONE_PIDFD grabbed the last clone() flag the time namespace is effectively
> > blocked. clone3() has the advantage that it will unblock this patchset
> > again.
> 
> Hi Christian,

Hi Andrei,

(Traveling until Monday, so sorry for delayed responses.)

> 
> Thank you for thinking about time namespaces. I looked at this patch
> quickly and I would suggest to move a termination signal out of flags. I
> think we can add a separate field (exit_signal) into clone_args. Does it
> make sense? For me, exit_signal in flags always looked weird...

Yup, that does sound good to me.

> 
> I will look at this patch more detailed later this week. Thanks.

Excellent!

Christian
