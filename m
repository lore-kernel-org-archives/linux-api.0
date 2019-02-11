From: Christian Brauner <christian@brauner.io>
Subject: Re: + sysctl-return-einval-if-val-violates-minmax.patch added to -mm
 tree
Date: Mon, 11 Feb 2019 22:32:50 +0100
Message-ID: <20190211213249.lta2pithpf5w6w7m@brauner.io>
References: <20190211210632.Nfd0f%akpm@linux-foundation.org>
 <20190211211716.GA31039@avx2>
 <20190211211917.kq2ahdkhoe36obhp@brauner.io>
 <20190211212523.GU11489@garbanzo.do-not-panic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190211212523.GU11489@garbanzo.do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, longman@redhat.com, linux@dominikbrodowski.net, keescook@chromium.org, joe.lawrence@redhat.com, ebiederm@xmission.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Feb 11, 2019 at 01:25:23PM -0800, Luis Chamberlain wrote:
> On Mon, Feb 11, 2019 at 10:19:19PM +0100, Christian Brauner wrote:
> > On Tue, Feb 12, 2019 at 12:17:16AM +0300, Alexey Dobriyan wrote:
> > > On Mon, Feb 11, 2019 at 01:06:32PM -0800, akpm@linux-foundation.org wrote:
> > > 
> > > > @@ -2848,8 +2848,10 @@ static int __do_proc_doulongvec_minmax(v
> > > 
> > > > -			if ((min && val < *min) || (max && val > *max))
> > > > -				continue;
> > > > +			if ((min && val < *min) || (max && val > *max)) {
> > > > +				err = -EINVAL;
> > > 
> > > I was asked to return ERANGE in kstrto*().
> > 
> > I think we discussed ERANGE vs EINVAL and decided EINVAL because there
> > was precedence for other sysctls already.
> 
> Can you do a proper audit and see?

If you look at proc_get_long() right now you can see that when the
buffer we use to parse the number is exceeded we return EINVAL. In short
if you do right now:

echo 1844674407370955161600000 > /proc/sys/fs/file-max

that would exceed the buffer in proc_get_long() and you already get
EINVAL for all such cases. If we now change this to ERANGE we would
return:

echo 18446744073709551616      > /proc/sys/fs/file-max -> ERANGE
echo 1844674407370955161600000 > /proc/sys/fs/file-max -> EINVAL

which would be very confusing. For consistency we should use EINVAL.

See kernel/sysctl.c:

/* We don't know if the next char is whitespace thus we may accept
 * invalid integers (e.g. 1234...a) or two integers instead of one
 * (e.g. 123...1). So lets not allow such large numbers. */
if (len == TMPBUFLEN - 1)
        return -EINVAL;

Christian
