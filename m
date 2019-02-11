From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: + sysctl-return-einval-if-val-violates-minmax.patch added to -mm
 tree
Date: Mon, 11 Feb 2019 13:25:23 -0800
Message-ID: <20190211212523.GU11489@garbanzo.do-not-panic.com>
References: <20190211210632.Nfd0f%akpm@linux-foundation.org>
 <20190211211716.GA31039@avx2>
 <20190211211917.kq2ahdkhoe36obhp@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190211211917.kq2ahdkhoe36obhp@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, longman@redhat.com, linux@dominikbrodowski.net, keescook@chromium.org, joe.lawrence@redhat.com, ebiederm@xmission.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Feb 11, 2019 at 10:19:19PM +0100, Christian Brauner wrote:
> On Tue, Feb 12, 2019 at 12:17:16AM +0300, Alexey Dobriyan wrote:
> > On Mon, Feb 11, 2019 at 01:06:32PM -0800, akpm@linux-foundation.org wrote:
> > 
> > > @@ -2848,8 +2848,10 @@ static int __do_proc_doulongvec_minmax(v
> > 
> > > -			if ((min && val < *min) || (max && val > *max))
> > > -				continue;
> > > +			if ((min && val < *min) || (max && val > *max)) {
> > > +				err = -EINVAL;
> > 
> > I was asked to return ERANGE in kstrto*().
> 
> I think we discussed ERANGE vs EINVAL and decided EINVAL because there
> was precedence for other sysctls already.

Can you do a proper audit and see?

linux-api folks may care.

 Luis
